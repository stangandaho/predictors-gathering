
# Install package if required
to_install <- c("terra", "sf", "dplyr")
for (pkg in to_install) {
  if (!pkg %in% rownames(installed.packages())) {
    install.packages(pkg)
  }
}
rm(pkg, to_install)

# Load packages
library(terra) # for raster manipulation
library(sf) # for vector/shapefile manipulation
library(dplyr) # for data manipulation

## Import Kruger National Park (KNP) shape file
knp_shp <- read_sf("knp/Kruger_National_Park.shp")

## Import Digital Surface Model (DSM)
### DSM Downloaded and unziped in raw_predictors folder at the root of the project
### Link to download: https://portal.opentopography.org/raster?jobId=rt1697677408993
dsm <- rast("raw_predictors/output_COP30.tif") %>%
  terra::aggregate(x = ., fact = 8) #create a new SpatRaster with a lower resolution (larger cells)

dsm <- terra::crop(x = dsm, y = knp_shp, snap = "out", mask = T) # cut out the KNP
names(dsm) <- "dsm"
terra::writeRaster(x = dsm, "./predictors/dsm.tif", overwrite = T)


## Distance to nearest water
### Shapfile downloaded and unziped in za folder at the root of the project
### Link to download: via https://download.geofabrik.de/africa/south-africa-latest-free.shp.zip
river_path <- "./za/gis_osm_waterways_free_1.shp"
river <- read_sf(river_path) %>%
  st_intersection(x = ., y = knp_shp) %>%
  st_as_sf()

river_raster <- terra::rasterize(x = river, y = dsm, values = 1)
dnw <- terra::distance(river_raster, unit = "km")
dnw_c <- terra::crop(x = dnw, y = knp_shp, snap = "out", mask = T)
plot(dnw_c)
names(dnw_c) <- "dnw"
terra::writeRaster(x = dnw_c, "./predictors/dnw.tiff", overwrite = T)

## Distance to nearest road
### Shapfile downloaded and unziped in za folder at the root of the project
### Link to download: via https://download.geofabrik.de/africa/south-africa-latest-free.shp.zip
road_path <- "./za/gis_osm_roads_free_1.shp"
road <- read_sf(road_path) %>%
  st_intersection(x = ., y = knp_shp) %>%
  st_as_sf()

road_raster <- terra::rasterize(x = road, y = dsm, values = 1)
dnr <- terra::distance(road_raster, unit = "km")
dnr_c <- terra::crop(x = dnr, y = knp_shp, snap = "out", mask = T)
plot(dnr_c)
names(dnr_c) <- "dnr"
terra::writeRaster(x = dnr_c, "./predictors/dnr.tiff", overwrite = T)


## Land Surface Temperature (LST)
# origin =    USGS EROS;
# pubdate =   Sun Mar 05 01:33:18 2023;
# title =     USGS eVIIRS Global 10-day Land Surface Temperature product;
# abstract =  Global Land Surface Temperature produced every 10 days;
# purpose =   Historical and Operational Land Surface Temperature;

lst <- rast("clipped/lst_clipped.tif")[[1]]
lst <- resample(x = lst, dsm)
lst_c <- terra::crop(x = lst, y = knp_shp, snap = "out", mask = T)
names(lst_c) <- "lst"
terra::writeRaster(x = lst_c*0.02, "./predictors/lst.tiff", overwrite = T)

## NDVI

# origin =    USGS EROS;
# pubdate =   Fri Feb 03 06:02:01 2023;
# title =     USGS eVIIRS Global NDVI 10-Day Composite;
# abstract =  Global composite of the last 10 day eVIIRS interval produced every 5 days;
# purpose =   Historical and Operational Vegetation Monitoring;

ndvi <- rast("clipped/ndvi_clipped.tif")[[1]]
ndvi <- terra::resample(x = ndvi, dsm)
ndvi_c <- terra::crop(x = ndvi, y = knp_shp, snap = "out", mask = T)
names(ndvi_c) <- "ndvi"
terra::writeRaster(x = ndvi_c*0.02, "./predictors/ndvi.tif", overwrite = T)

## LULC
lulc <- rast("clipped/lulc.tif") %>%
  project( y = crs(dsm)) %>%
  nimo::nm_match_raster(to_match = ., target = dsm, method = "near")

terra::writeRaster(x = lulc, "./predictors/lulc.tif", overwrite = T)


