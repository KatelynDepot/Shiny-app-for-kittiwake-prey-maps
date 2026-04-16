
# default map format

# basemap
basemap <- rnaturalearth::ne_countries(country = "united states of america", 
                                       scale = "large", returnclass = "sf")
my_basemap <- ggplot2::geom_sf(data = basemap, fill = "white", color = "black", linewidth = 0.3)

# bathymetry
# this downloads the data the first time it is run, and uses the downloaded file for subsequent runs
bathy <- marmap::getNOAA.bathy(lon1 = -149, lon2 = -143.5,
                               lat1 = 57.5, lat2 = 61, resolution = 0.1, # in minutes
                               keep = TRUE, path = "preymaps/data")
bathy_xyz <- marmap::as.xyz(bathy)
my_geom_bathy <-  ggplot2::geom_contour_filled(data = bathy_xyz, 
                                               stat = "contour_filled",
                                               ggplot2::aes(x = V1, y = V2, z = V3),
                                               breaks = c(-5000, -3000, -1000, -300, -200, -100, 0, 1000),
                                               show.legend = F)
my_bathy_scale <- ggplot2::scale_fill_manual(values = c("gray80", "gray85", "gray90", 
                                                        "gray95", "gray95", "white", "white"))

# coordinates
my_coords <- ggplot2::coord_sf(xlim = c((-148.4797-0.2), (-144.4048+0.6)),
                               ylim = c((58.08258-0.1), (60.46685+0.1)), expand = F)
