library(ncdf4)
library(sp)
library(tidyverse)
library(data.table)
library(tidyverse)

# Input files are daily average of PM2.5 for the domain 
file_1 <- "China_EV_daily_PM25_" #first half of file names
file_2 = c('BASE','HDV_2010_v2','HDV_CUR_v2',
           'HDV_FUT_v2','LDV_2010_v2','LDV_CUR_v2') #second half of filenames (to loop over)
ncin <- nc_open('China_EV_daily_PM25_LDV_FUT_v2 (2).nc')
PM25 <- ncvar_get(ncin,"PM25") 


#set to loop over 6 different netcdf files
for (i in 1:6) { 
  ncfname <- paste(file_1,file_2[i],".nc",sep="") #whatever the netcdf filename is
  csvname <- paste(file_1,file_2[i],"TESTRUN_25andgreater.csv",sep="") #name of csv to save for benmap
  ncin <- nc_open(ncfname) #opens netcdf file
  PM25 <- ncvar_get(ncin,"PM25") #read pm2.5 variable
  nlon <- dim(PM25)[1] #extract lon and lat dimensions of grid from variable
  nlat <- dim(PM25)[2]
  nc_close(ncin) #close netcdf file
  
  df=data.frame(matrix(NA, nrow=nlat*nlon, ncol=6)) #create empty df
  lineknt=0 #create index of row to fill
  #set to loop through every grid cell (n=lon*lat)
  for (ilat in 1:nlat) {
    for (ilon in 1:nlon) {
      lineknt = lineknt+1  #start on first row
      if (lineknt==1) {
        df[lineknt,1:6] <- c('Column','Row','Metric','Seasonal Metric','Annual Metric','Values') #headers for benmap
      } else {
        string <- paste(paste(PM25[ilon,ilat,],collapse = ","),paste(rep(",.",334),collapse=""),collapse="",sep="") #creates string formatted for benmap
        #benmap needs 365 values, so the command above adds 334 "blank" days in addition to the values for 31 days of January.
        df[lineknt,1:6] <- c(1,lineknt-1,'D24HourMean','','',string) #puts string in correct row. D24HourMean is a metric for PM2.5
      }}}
  fwrite(df,csvname,col.names = FALSE) #write df to csv file
}

