library(tidyverse)
library(ggplot2)
library(chron)
library(RColorBrewer)
library(lattice)
library(reticulate)
library(ncdf4)
library(foreach)

# Read in base files
cmaq_files <- list.files(path= "/projects/b1045/wrf-cmaq/output/Chicago_LADCO/output_BASE_FINAL_1.33km_sf_rrtmg_5_8_1_v3852/postprocess/", 
                         pattern = "COMBINE_ACONC_*", full.names=TRUE) %>%  
  map(nc_open)

# Read in no municipal vehicle files
cmaq_no_mun <- list.files(path=  '/projects/b1045/wrf-cmaq/output/Chicago_LADCO/output_Amy_noMUNI_1.33km_sf_rrtmg_5_10_1_v3852/postprocess/', 
                          pattern = "COMBINE_ACONC_*", full.names=TRUE) %>% 
  lapply( nc_open)

# Get lat lon 
lat_lon <- nc_open('/projects/b1045/jschnell/ForAmy/latlon_ChicagoLADCO_d03.nc') 
lon <- ncvar_get(lat_lon, varid = "lon")
lat <- ncvar_get(lat_lon, varid = "lat")

# Calculate NO2 mean 

pm <- tibble(map(cmaq_files,ncvar_get, varid = 'PM25_TOT'))

for i in 
cmaq_files
pm <- ncvar_get(cmaq_files, varid = 'PM25_TOT')
2cmaq_files[1]

PM25 <- ncvar_get(cmaq_files,"PM25_TOT") #read pm2.5 variable
dim(lon)
dim(lat)

ncvar(cmaq_files)
