![Example Image](https://github.com/stangandaho/predictors-gathering/blob/main/predictors.jpeg)  
This R script details the methodology employed to gather environmental predictor variables essential for White-backed Vulture (WbV) distribution modeling across Kruger National Park. The process involves multiple steps, including the acquisition and preprocessing of geospatial data representing various environmental factors. The gathered predictor variables encompass Digital Surface Model (DSM), distances to nearest water bodies and roads, Land Surface Temperature (LST), Normalized Difference Vegetation Index (NDVI), and Land Use and Land Cover (LULC) information. The script utilizes several R packages such as `terra`, `sf`, and `dplyr` for efficient data manipulation and raster/vector processing. Each step is documented, ensuring reproducibility and transparency in the analysis.

_
The comments in the script serve as a guide to explain each step of the analysis process, providing clarity and direction for users. They offer concise explanations regarding the purpose of each code block, including data acquisition, preprocessing, and manipulation. Additionally, the comments include instructions for downloading required datasets, specifying relevant file paths, and describing the source of each dataset. Moreover, they outline specific functions and parameters utilized in the analysis.
_

## Introduction  
Species distribution modeling (SDM) is an important tool in ecological research, aiding in the understanding of species-environment relationships and facilitating conservation efforts. Central to SDM is the availability of accurate and comprehensive environmental predictor variables, which influence species distributions. In this study, we employ geospatial data representing key environmental factors within the study area, aiming to construct robust SDM frameworks for WbV using [nimo R package](https://github.com/stangandaho/nimo).

## Data Acquisition and Preprocessing  
The first phase involves the acquisition of relevant geospatial data. The Kruger National Park (KNP) shapefile serves as the study area boundary, delineating the spatial extent for subsequent analyses. Additionally, environmental data including DSM, distances to water bodies and roads, LST, NDVI, and LULC are obtained from various sources. These datasets undergo preprocessing to ensure consistency and compatibility for further analysis.

## Digital Surface Model (DSM)  
The [DSM](https://github.com/stangandaho/predictors-gathering/blob/main/metadata/COP30_metadata) dataset represents terrain elevation information, crucial for characterizing topographic features within the study area. To enhance computational efficiency, the DSM raster is aggregated to a lower resolution while retaining essential elevation characteristics. Subsequently, the DSM is cropped to the extent of KNP and saved as a GeoTIFF file for further analysis.

## Distance to Nearest Water and Road  
Using [vector data](https://download.geofabrik.de/africa/south-africa-latest-free.shp.zip) representing rivers and roads, rasterization techniques are employed to convert vector features into raster format. Distance calculations are then performed to derive continuous raster layers representing distances to the nearest water body (DNW) and road (DNR) from any given point within KNP. These raster layers are subsequently cropped and saved for integration into the SDM process.

## Land Surface Temperature (LST) and NDVI  
[LST](https://github.com/stangandaho/predictors-gathering/blob/main/metadata/LST_metadata) and [NDVI](https://github.com/stangandaho/predictors-gathering/blob/main/metadata/NDVI_metadata) are key biophysical variables reflecting surface temperature and vegetation abundance, respectively. Preprocessed raster datasets representing LST and NDVI are resampled to match the resolution of the DSM raster. Cropping procedures are applied to limit the analysis to the KNP extent. Finally, the processed LST and NDVI layers are saved in GeoTIFF format for incorporation into the SDM process.

## Land Use and Land Cover (LULC)  
The [LULC](https://arcg.is/1bO51q0) raster dataset is projected to match the coordinate reference system (CRS) of the DSM raster and resampled as necessary. To ensure consistency with other predictor variables, the LULC raster is matched to the extent and resolution of the DSM raster. The processed LULC layer is saved for subsequent integration into the SDM framework.

