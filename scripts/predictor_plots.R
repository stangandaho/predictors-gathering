library(dplyr)
library(ggplot2)
library(MetBrewer)

predictors_path <- list.files("output/", pattern = "[.tif$|.tiff$]", full.names = T)

pred_df <- data.frame()
for (prd in predictors_path) {
  rst <- terra::rast(prd) %>%
    terra::as.data.frame(xy = TRUE) %>%
    dplyr::rename("pred_val" = 3) %>%
    dplyr::mutate(pred = gsub("\\..*$", "",  basename(prd)))

  pred_df <- rbind(pred_df, rst)
}

met.brewer("Tsimshian")
plot_list <- list()
clrs <- list("dnr"="Isfahan1" ,"dnw"="Hokusai2",
          "dsm"="Moreau", "lst"="Greek",
          "lulc"="Tsimshian", "ndvi" = "VanGogh3")

cls_tr <- function(type) {
  if (type == "lulc") {
    x <- scale_fill_met_d(name = clrs[[dt_name]])
  }else{
    x <- scale_fill_met_c(name = clrs[[dt_name]])
  }

  return(x)
}


for (dt_name in unique(pred_df$pred)) {
  dtt <- pred_df %>% filter(pred==dt_name)
  if (dt_name == "lulc") {
    dtt$pred_val <- as.character(round(dtt$pred_val))
  }

  p <- ggplot2::ggplot(data = dtt)+
    geom_tile(aes(x = x, y = y, fill = pred_val),
              show.legend = F)+
    labs(tag = toupper(dt_name))+
    guides(
        fill = guide_legend(
          title = toupper(dt_name),
          title.theme = element_text(angle = 90, hjust = .5),
          title.position = "left",
          keyheight = unit(10, units = "mm"),
          keywidth = unit(3, "mm")
        ))+
    cls_tr(dt_name)+
    coord_sf()+
    theme_void()+
    theme(
      legend.position = c(-.1,0.28),
      legend.text = element_text(size = 13)
    )

  plot_list[[dt_name]] <- p
}

cowplot::plot_grid(plotlist = plot_list, ncol = 6, nrow = 1)

ggsave(filename = "predictors.jpeg", width = 40, height = 18, units = "cm")
