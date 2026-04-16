
# load packages
library(dplyr)
library(sp)
library(ggplot2)
library(patchwork)

# custom map functions
source("Map_functions.R")

# import data
gurge_ids_df <- read.csv('preymaps/data/Shiny_gurge_ids_df.csv')
gurge_table_long <- read.csv('preymaps/data/Shiny_gurge_table_long.csv')
gurge_prey_points <- read.csv('preymaps/data/Shiny_gurge_prey_points.csv')
gurge_dead_batteries <- read.csv('preymaps/data/Shiny_gurge_dead_batteries.csv')
fDNA_ids_df <- read.csv('preymaps/data/Shiny_fDNA_ids_df.csv')
fDNA_fish_long <- read.csv('preymaps/data/Shiny_fDNA_fish_long.csv')
fDNA_metazoa_long <- read.csv('preymaps/data/Shiny_fDNA_metazoa_long.csv')
fDNA_prey_points <- read.csv('preymaps/data/Shiny_fDNA_prey_points.csv')
fDNA_dead_batteries <- read.csv('preymaps/data/Shiny_fDNA_dead_batteries.csv')

# make sf objects
gurge_prey_points_sf <- gurge_prey_points %>%
  sf::st_as_sf(., coords = c('lon', 'lat'), crs = 4326)
gurge_dead_batteries_sf <- gurge_dead_batteries %>%
  sf::st_as_sf(., coords = c('last_lon', 'last_lat'), crs = 4326)
fDNA_prey_points_sf <- fDNA_prey_points %>%
  sf::st_as_sf(., coords = c('lon', 'lat'), crs = 4326)
fDNA_dead_batteries_sf <- fDNA_dead_batteries %>%
  sf::st_as_sf(., coords = c('last_lon', 'last_lat'), crs = 4326)

# individual diet plots -------------------------------------------------------

# relative biomass
ind_rel <- function(i){
  ggplot(data = gurge_table_long[gurge_table_long$dep_id == ids[i],], 
         aes(y = rel_mass, x = dep_id, fill = Prey, pattern = Prey)) +
    ggpattern::geom_bar_pattern(position = "fill",
                                stat = "identity",
                                width = 0.5,
                                pattern_color = "white",
                                pattern_angle = 45,
                                pattern_density = 0.1,
                                pattern_spacing = 0.15,
                                pattern_alpha = 0.4,
                                pattern_key_scale_factor = 0.05) +
    ggpattern::scale_pattern_manual(name = "Prey", values = c("Amphipod" = "none",
                                                              "Capelin (0)" = "stripe",
                                                              "Capelin (1+)" = "none",
                                                              "Eulachon" = "stripe",
                                                              "Euphausiid" = "none",
                                                              "Fish" = "stripe",
                                                              "Gadid" = "none",
                                                              "Greenling" = "stripe",
                                                              "Herring (0)" = "none",
                                                              "Herring (1+)" = "stripe",
                                                              "Lingcod" = "none",
                                                              "Myctophid" = "stripe",
                                                              "Pollock" = "none",
                                                              "Polychaete" = "stripe",
                                                              "Sablefish" = "none",
                                                              "Salmon" = "stripe",
                                                              "Sand lance (0)" = "none",
                                                              "Sand lance (1+)" = "stripe",
                                                              "Shrimp" = "none",
                                                              "Squid" = "stripe",
                                                              "Stichaeid" = "none"
    )) +
    scale_fill_manual(name = "Prey", values = c(viridis::viridis(n = 21, option = "H"))) +
    theme_void(base_size = 8) +
    theme(aspect.ratio = 5/1,
          legend.key.size = unit(0.4, 'cm'),
          axis.title.x = element_text()) + xlab("Relative\nbiomass") +
    guides(fill = guide_legend(ncol = 1), pattern = guide_legend(ncol = 1))
}

# fish relative read abundance
ind_12S <- function(i){
  ggplot(data = fDNA_fish_long[fDNA_fish_long$dep_id == ids[i],], 
         aes(y = rra, x = dep_id, fill = Prey, pattern = Prey)) +
    ggpattern::geom_bar_pattern(position = "fill",
                                stat = "identity",
                                width = 0.5,
                                pattern_color = "white",
                                pattern_angle = 45,
                                pattern_density = 0.1,
                                pattern_spacing = 0.15,
                                pattern_alpha = 0.4,
                                pattern_key_scale_factor = 0.05) +
    ggpattern::scale_pattern_manual(name = "Prey (12S)", values = c("Atlantic salmon" = "none",
                                                              "Capelin" = "stripe",
                                                              "Cockscomb" = "none",
                                                              "Crested bigscale" = "stripe",
                                                              "Daubed shanny" = "none",
                                                              "Eelpout" = "stripe",
                                                              "Eulachon" = "none",
                                                              "Gadid" = "stripe",
                                                              "Gadus" = "none",
                                                              "Greenling" = "stripe",
                                                              "Herring" = "none",
                                                              "Lingcod" = "stripe",
                                                              "Myctophids" = "none",
                                                              "Other fishes" = "stripe",
                                                              "Pacific salmon" = "none",
                                                              "Prowfish" = "stripe",
                                                              "Red Irish lord" = "none",
                                                              "Rockfish" = "stripe",
                                                              "Sablefish" = "none",
                                                              "Sand lance" = "stripe",
                                                              "Sandfish" = "none",
                                                              "Scaly paperbone" = "stripe",
                                                              "Searcher" = "none",
                                                              "Wrymouth" = "stripe"
    )) +
    scale_fill_manual(name = "Prey (12S)", values = c(viridis::viridis(n = 24, option = "H"))) +
    theme_void(base_size = 8) +
    theme(aspect.ratio = 7/1,
          legend.key.size = unit(0.4, 'cm')) +
    {if(ids[i] %in% unique(fDNA_fish_long$dep_id))theme(axis.title.x = element_text())} + xlab("12S") +
    guides(fill = guide_legend(ncol = 1), pattern = guide_legend(ncol = 1))
}

# metazoa relative read abundance
ind_18S <- function(i){
  ggplot(data = fDNA_metazoa_long[fDNA_metazoa_long$dep_id == ids[i],], 
         aes(y = rra, x = dep_id, fill = Prey, pattern = Prey)) +
    geom_bar(position = "fill", stat = "identity", width = 0.5) +
    scale_fill_manual(name = "Prey (18S)", values = c(viridis::viridis(n = 5, option = "C"))) +
    theme_void(base_size = 8) +
    theme(aspect.ratio = 7/1,
          legend.key.size = unit(0.4, 'cm')) +
    {if(ids[i] %in% unique(fDNA_metazoa_long$dep_id))theme(axis.title.x = element_text())} + xlab("18S") +
    guides(fill = guide_legend(ncol = 1), pattern = guide_legend(ncol = 1))
}

# individual maps -------------------------------------------------------------

# gurge
gurge_map <- function(i){
  ggplot() +
    my_geom_bathy + my_bathy_scale + my_basemap +
    xlab("Longitude") + ylab("Latitude") +
    geom_sf(data = gurge_prey_points_sf[gurge_prey_points_sf$dep_id == ids[i],], aes(col = time_dif / 60)) +
    geom_sf(data = gurge_dead_batteries_sf[gurge_dead_batteries_sf$dep_id == ids[i],], aes(col = dead_time), 
            shape = 4, size = 2, stroke = 1) +
    scale_color_continuous(limits = c(0,9), breaks = c(0,2,4,6,8), type = "viridis") +
    my_coords +
    metR::scale_x_longitude(breaks = c(-147,-145)) +
    metR::scale_y_latitude(breaks = c(59,60)) +
    labs(col = "Hours\nbefore\ncapture",
         title = paste(" Captured: ", lubridate::with_tz(lubridate::as_datetime(
           gurge_ids_df$time_recaptured[gurge_ids_df$dep_id == ids[i]]), tzone = "US/Alaska"),
                       "\n", "ID: ", ids[i])) +
    {if(ids[i] == "A08_RSRGB_01Aug2017") annotate(geom = "text", x = -146.2, y = 59.5, 
                                              color = "red", size = 3,
                                              label = "Foraging points\noutside of map limits")} +
    theme_bw(base_size = 8) +
    theme(panel.grid.major = element_blank(),
          axis.text.y = element_text(angle = 90, hjust = 0.5))
}

# fecal DNA
fDNA_map <- function(i){
  ggplot() +
    my_geom_bathy + my_bathy_scale + my_basemap +
    xlab("Longitude") + ylab("Latitude") +
    geom_sf(data = fDNA_prey_points_sf[fDNA_prey_points_sf$dep_id == ids[i],], aes(col = time_dif / 60)) +
    geom_sf(data = fDNA_dead_batteries_sf[fDNA_dead_batteries_sf$dep_id == ids[i],], aes(col = dead_time), 
            shape = 4, size = 2, stroke = 1) +
    scale_color_continuous(limits = c(0,24), type = "viridis") +
    my_coords +
    metR::scale_x_longitude(breaks = c(-147,-145)) +
    metR::scale_y_latitude(breaks = c(59,60)) +
    labs(col = "Hours\nbefore\ncapture",
         title = paste(" Captured: ", lubridate::with_tz(lubridate::as_datetime(
           fDNA_ids_df$time_recaptured[fDNA_ids_df$dep_id == ids[i]]), tzone = "US/Alaska"),
                       "\n", "ID: ", ids[i])) +
    theme_bw(base_size = 8) +
    theme(panel.grid.major = element_blank(),
          axis.text.y = element_text(angle = 90, hjust = 0.5))
}

# diet and map combined -------------------------------------------------------

gurge_plot <- function(i){
  gurge_map(i) + ind_rel(i) + plot_spacer() + guide_area() +
    plot_layout(ncol = 4, guides = "collect",
                widths = c(3,1,0.5,3)) &
    theme(legend.box = "horizontal")
}

fDNA_plot <- function(i){
  fDNA_map(i) + ind_18S(i) + ind_12S(i) + plot_spacer() + guide_area() +
    plot_layout(ncol = 5, guides = "collect",
                widths = c(3,0.5,0.5,0.5,3)) &
    theme(legend.box = "horizontal")
}

# export all plots ------------------------------------------------------------

# make gurge id list
ids <- gurge_ids_df %>%
  dplyr::pull(dep_id)

# export gurge plots
for(i in seq(1:dplyr::n_distinct(ids))){
  gurge_plot1 <- gurge_plot(i)
  filename <- paste0("preymaps/www/plots/gurge_", ids[i], ".png")
  ggsave(filename, plot = gurge_plot1,
         width = 210, height = 105, units = "mm", dpi = 300)
  message(paste(i,"/",dplyr::n_distinct(ids),"completed"))
}

# make fDNA id list
ids <- fDNA_ids_df %>%
  dplyr::pull(dep_id)

# export fDNA plots
for(i in seq(1:dplyr::n_distinct(ids))){
  fDNA_plot1 <- fDNA_plot(i)
  filename <- paste0("preymaps/www/plots/fDNA_", ids[i], ".png")
  ggsave(filename, plot = fDNA_plot1,
         width = 210, height = 105, units = "mm", dpi = 300)
  message(paste(i,"/",dplyr::n_distinct(ids),"completed"))
}

# export plot table -----------------------------------------------------------

gurge_ids_df <- read.csv('preymaps/data/Shiny_gurge_ids_df.csv') |>
  dplyr::mutate(type = "Regurgitate",
                temp = "gurge") |>
  tidyr::unite(col = "plot", c(temp, dep_id), remove = F) |>
  dplyr::mutate(plot = stringr::str_c(plot, ".png")) |>
  dplyr::select(dep_id, LocalTime = time_recaptured, type, plot) |>
  dplyr::mutate(LocalTime = lubridate::with_tz(lubridate::as_datetime(
    LocalTime), tzone = "US/Alaska"))

fDNA_ids_df <- read.csv('preymaps/data/Shiny_fDNA_ids_df.csv') |>
  dplyr::mutate(type = "Fecal DNA",
                temp = "fDNA") |>
  tidyr::unite(col = "plot", c(temp, dep_id), remove = F) |>
  dplyr::mutate(plot = stringr::str_c(plot, ".png")) |>
  dplyr::select(dep_id, LocalTime = time_recaptured, type, plot) |>
  dplyr::mutate(LocalTime = lubridate::with_tz(lubridate::as_datetime(
    LocalTime), tzone = "US/Alaska"))

plot_table <- rbind(gurge_ids_df, fDNA_ids_df)

# write.csv(plot_table, 'preymaps/data/Shiny_plot_table.csv', row.names = FALSE)
#------------------------------------------------------------------------------
