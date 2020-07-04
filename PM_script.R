library(tidyverse)
library(ggplot2)
library(chron)
library(RColorBrewer)
library(lattice)
library(ncdf4)

cmaq_files <- list.files('/projects/b1045/wrf-cmaq/output/Chicago_LADCO/output_BASE_FINAL_1.33km_sf_rrtmg_5_8_1_v3852/postprocess/',pattern='*.nc',full.names=TRUE) %>% 
  map(ncdf4::nc_open)

cmaq_no_bus <-  list.files('/projects/b1045/wrf-cmaq/output/Chicago_LADCO/output_Amy_noBUS_1.33km_sf_rrtmg_5_8_1_v3852/postprocess/',pattern='*.nc',full.names=TRUE) %>% 
  map(nc_open)

cmaq_no_school <- list.files('/projects/b1045/wrf-cmaq/output/Chicago_LADCO/output_Amy_noSCHOOL_1.33km_sf_rrtmg_5_8_1_v3852/postprocess/',pattern='*.nc',full.names=TRUE) %>% 
  map(nc_open)

cmaq_no_school_ldv <- list.files('/projects/b1045/wrf-cmaq/output/Chicago_LADCO/output_Amy_noSCHOOLplusLDV_1.33km_sf_rrtmg_5_8_1_v3852/postprocess/',pattern='*.nc',full.names=TRUE) %>% 
  map(nc_open)

cmaq_no_mun <- list.files('/projects/b1045/wrf-cmaq/output/Chicago_LADCO/output_Amy_noMUNI_1.33km_sf_rrtmg_5_8_1_v3852/postprocess/',pattern='*.nc',full.names=TRUE) %>% 
  map(nc_open)

pm <-  map(cmaq_files, ncvar_get, "PM25_TOT")

pm_bus <- map(cmaq_no_bus, ncvar_get, "PM25_TOT")

pm_school <- map(cmaq_no_school, ncvar_get, "PM25_TOT")

pm_ldv <- map(cmaq_no_school_ldv, ncvar_get, "PM25_TOT")

pm_no_mun <- map(cmaq_no_mun, ncvar_get, "PM25_TOT")

pm_av <- pm_school_av <- pm_bus_av <- pm_ldv_av <- pm_no_mun_av <-  array(dim = c(288, 315, 32))

# Function to calcualte the daily average throughout the month 
monthly_av <- function(output_arr, input_arr){
  for (i in 1:32){
    output_arr[,,i] <- apply(input_arr[[i]], c(1,2), mean)
  }
  return(output_arr)
}

pm_av <- monthly_av(pm_av, pm)
pm_bus_av <- monthly_av(pm_bus_av, pm_bus)
pm_school_av <- monthly_av(pm_school_av, pm_school)
pm_ldv_av <- monthly_av(pm_ldv_av, pm_ldv)
pm_no_mun_av <- monthly_av(pm_no_mun_av, pm_no_mun)

pm_s_b <- pm_school_av + pm_bus_av 


daily_av <- list(pm_no_mun_av)
daily_av_name <- list("pm_no_mun_av")
nlon <- 288
nlat <- 315

for (i in 1) {
  csvname <- paste(daily_av_name[i],".csv", sep = "")
  df = data.frame(matrix(NA, nrow = nlat * nlon, ncol = 6)) #create empty df
  lineknt = 0 #create index of row to fill
  #set to loop through every grid cell (n=lon*lat)
  for (ilat in 1:nlat) {
    for (ilon in 1:nlon) {
      lineknt = lineknt + 1  #start on first row
      if (lineknt == 1) {
        df[lineknt, 1:6] <-
          c('Column',
            'Row',
            'Metric',
            'Seasonal Metric',
            'Annual Metric',
            'Values') #headers for benmap
      } else {
        string <-
          paste(
            paste(daily_av[[i]][ilon, ilat, ], collapse = ","),
            paste(rep(",.", 333), collapse = ""),
            collapse = "",
            sep = ""
          ) #creates string formatted for benmap
        #benmap needs 365 values, so the command above adds 334 "blank" days in addition to the values for 31 days of January.
        df[lineknt, 1:6] <-c(1,lineknt-1, 'D24HourMean', '', '', string) #puts string in correct row. D24HourMean is a metric for PM2.5
      }
    }
  }
  write.csv(df, csvname) #write df to csv file
}

base_pm <- read_csv('pm_av.csv', skip = 1) %>% 
  subset(select = -1)

no_bus_pm <- read_csv('pm_bus_av.csv', skip = 1) %>% 
  subset(select = -1)

no_school_pm <- read_csv('pm_school_av.csv', skip = 1) %>% 
  subset(select = -1)

ldv_pm <- read_csv('pm_ldv_av.csv', skip = 1) %>% 
  subset(select = -1)

no_mun_pm <- read_csv('pm_no_mun_av.csv', skip = 1) %>% 
  subset(select = -1)

write_csv(no_mun_pm, "no_mun_pm.csv")
write_csv(ldv_pm, "no_ldv_pm.csv")
write_csv(base_pm, "base_pm.csv")
write_csv(no_bus_pm, "no_bus_pm.csv")
write_csv(no_school_pm, "no_school_pm.csv")



