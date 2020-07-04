library(tidyverse)
library(ggplot2)
library(chron)
library(RColorBrewer)
library(lattice)
library(ncdf4)
library(zoo)

cmaq_files <- list.files('/projects/b1045/wrf-cmaq/output/Chicago_LADCO/output_BASE_FINAL_1.33km_sf_rrtmg_5_8_1_v3852/postprocess/',pattern='*.nc',full.names=TRUE) %>% 
  map(ncdf4::nc_open)

cmaq_no_bus <-  list.files('/projects/b1045/wrf-cmaq/output/Chicago_LADCO/output_Amy_noBUS_1.33km_sf_rrtmg_5_8_1_v3852/postprocess/',pattern='*.nc',full.names=TRUE) %>% 
  map(nc_open)

cmaq_no_school <- list.files('/projects/b1045/wrf-cmaq/output/Chicago_LADCO/output_Amy_noSCHOOL_1.33km_sf_rrtmg_5_8_1_v3852/postprocess/',pattern='*.nc',full.names=TRUE) %>% 
  map(nc_open)

o3 <- map(cmaq_files, ncvar_get, "O3")

o3_nb <- map(cmaq_no_bus, ncvar_get, "O3")

o3_ns <- map(cmaq_no_school, ncvar_get, "O3")

o3 <- write_rds(o3, path = 'o3.rds')
o3_bus <- write_rds(o3_nb, path = 'o3_bus.rds')
o3_school <- write_rds(o3_ns, path = 'o3_school.rds')

o3 <- read_rds("o3.rds")
o3_bus <- read_rds("o3_bus.rds")
o3_school <- read_rds("o3_school.rds")

apply(o3[[i]], c(1,2), mean)
max(o3[[30]][5,2,])

o3_av <-o3_school_av <- o3_bus_av <- array(dim = c(288, 315, 32))

for (i in 1:32){
  o3_av[,,i] <- apply(o3[[i]], c(1,2), mean)
}

for (i in 1:32){
  o3_school_av[,,i] <- apply(o3_school[[i]], c(1,2), mean)
}

for (i in 1:32){
  o3_bus_av[,,i] <- apply(o3_bus[[i]], c(1,2), mean)
}


max_av <- list(o3_av, o3_school_av, o3_bus_av)
max_av_name <- list("o3_av", "o3_school_av", "o3_bus_av")
nlon <- 288
nlat <- 315

for (i in 1:length(max_av)) {
  csvname <- paste(max_av_name[i],".csv", sep = "")
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
            paste(max_av[[i]][ilon, ilat, ], collapse = ","),
            paste(rep(",.", 333), collapse = ""),
            collapse = "",
            sep = ""
          ) #creates string formatted for benmap
        #benmap needs 365 values, so the command above adds 334 "blank" days in addition to the values for 31 days of January.
        df[lineknt, 1:6] <-
          c(1, lineknt - 1, 'D1HourMax', '', '', string) #puts string in correct row. D24HourMean is a metric for PM2.5
      }
    }
  }
  write.csv(df, csvname) #write df to csv file
}
 

base_o3_mean <- read_csv('o3_av.csv', skip = 1) %>% 
  subset(select = -1)

no_bus_o3_mean <- read_csv('o3_bus_av.csv', skip = 1) %>% 
  subset(select = -1)

no_school_o3_mean <- read_csv('o3_school_av.csv', skip = 1) %>% 
  subset(select = -1)


write_csv(base_o3_mean, "base_o3_m.csv")
write_csv(no_bus_o3_mean, "no_bus_o3_m.csv")
write_csv(no_school_o3_mean, "no_school_o3_m.csv")

