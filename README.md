# Shiny app for kittiwake prey maps

--- OVERVIEW ---

This repository contains data and code to produce the interactive Shiny app for viewing prey samples from GPS-tracked kittiwakes, associated with the manuscript:

"Coupling diet and foraging behavior of a surface-feeding seabird to map prey spatial distribution" by Katelyn M. Depot, Shannon Whelan, Mayumi L. Arimitsu, Gemma V. Clucas, and Kyle H. Elliott.

Detailed methodology can be found in the associated publication. The online app can be found at the following link at the time of publication: <https://kdepot.shinyapps.io/preymaps/>

--- INSTRUCTIONS ---

You may choose to run Make_plots.R to reproduce the plots. This will save the plots into the appropriate directory for use by the Shiny app.

Run app.R in an RStudio environment to produce a local version of the Shiny app. Note that the directory structure must be unchanged.

--- FILES ---

```         
Shiny-app-for-kittiwake-prey-maps/
├── README.md
├── Make_plots.R        # Script to reproduce plots.
├── Map_functions.R     # Functions for mapping, called by Make_plots.R.
├── preymaps/           # Project directory for Shiny app.
    ├── app.R           # Script for Shiny app.
    ├── www/plots/      # Folder where plots are saved. File names formatted SampleType_DeploymentID.png.
    ├── data/
        ├── marmap_coord_-149;57.5;-143.5;61_res_0.25.csv # Bathymetry data (downloaded with marmap package in Map_functions.R).
        ├── Shiny_plot_table.csv            # Table of plots, used to make table in app.
        ├── Shiny_gurge_ids_df.csv          # GPS deployments associated with regurgitates.
        ├── Shiny_fDNA_ids_df.csv           # GPS deployments associated with fecal DNA.
        ├── Shiny_gurge_table_long.csv      # Relative biomasses of prey in regurgitates. 
        ├── Shiny_fDNA_metazoa_long.csv     # Relative read abundances of metazoan prey in fecal DNA, from 18S sequences.
        ├── Shiny_fDNA_fish_long.csv        # Relative read abundances of fish prey in fecal DNA, from 12S sequences.
        ├── Shiny_gurge_prey_points.csv     # Foraging points associated with regurgitates.
        ├── Shiny_fDNA_prey_points.csv      # Foraging points associated with fecal DNA.
        ├── Shiny_gurge_dead_batteries.csv  # Locations and times of GPS battery death (regurgitates where <9 h before capture).
        └── Shiny_fDNA_dead_batteries.csv   # Locations and times of GPS battery death (fecal DNA where 1-12 h before capture).
```

--- DATA ATTRIBUTES ---

| File                           | Columns                               |
|--------------------------------|---------------------------------------|
| Shiny_plot_table.csv           | dep_id, LocalTime, type, plot         |
| Shiny_gurge_ids_df.csv         | dep_id, time_recaptured               |
| Shiny_fDNA_ids_df.csv          | dep_id, time_recaptured               |
| Shiny_gurge_table_long.csv     | dep_id, Prey, rel_mass                |
| Shiny_fDNA_metazoa_long.csv    | dep_id, Prey, rra                     |
| Shiny_fDNA_fish_long.csv       | dep_id, Prey, rra                     |
| Shiny_gurge_prey_points.csv    | dep_id, lon, lat, time_dif            |
| Shiny_fDNA_prey_points.csv     | dep_id, lon, lat, time_dif            |
| Shiny_gurge_dead_batteries.csv | dep_id, last_lon, last_lat, dead_time |
| Shiny_fDNA_dead_batteries.csv  | dep_id, last_lon, last_lat, dead_time |

| Column          | Description                                          |
|-----------------|------------------------------------------------------|
| dep_id          | Deployment ID                                        |
| LocalTime       | Local time (UTC-8)                                   |
| type            | "Regurgitate" or "Fecal DNA"                         |
| plot            | File name of plot                                    |
| time_recaptured | Date and time (UTC) GPS retrieved and prey collected |
| Prey            | Prey                                                 |
| rel_mass        | Relative biomass                                     |
| rra             | Relative read abundance                              |
| lon             | Longitude (decimal degrees)                          |
| lat             | Latitude (decimal degrees)                           |
| time_dif        | Minutes before capture (of foraging point)           |
| last_lon        | Last recorded longitude (decimal degrees)            |
| last_lat        | Last recorded latitude (decimal degrees)             |
| dead_time       | Hours before capture (of battery death)              |
