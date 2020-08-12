# Load Libraries
library(tidyverse)
library(Hmisc)

# Load in csv files -------------------------------------------------------

# Rate per distance
rpdist <- read_csv('Originals/rate_per_distance.csv')

# Rate per vehicle 
rpveh <- read_csv('Originals/rate_per_vehicle.csv')

# Rate per profile
rpprof <- read_csv("Originals/rate_per_profile.csv")

# Rate per hour
rphor <- read_csv("Originals/rate_per_hour.csv")

# SCC codes for gasoline light duty passenger vehicles
light_duty_a <- c(2201210153, 2201210162, 2201210172, 2201210181, 2201210191, 
                2201210253, 2201210262, 2201210272, 2201210281, 2201210291,
                2201210353, 2201210362, 2201210372, 2201210381, 2201210391, 
                2201210453, 2201210462, 2201210472, 2201210481, 2201210491, 
                2201210553, 2201210562, 2201210572, 2201210581, 2201210591)

# School bus vehicle emmissions array from SCC doc
school_emis_a <- c(2201430153,2201430162,2201430172,2201430181,2201430191,
                 2201430253,2201430262,2201430272,2201430281,2201430291,
                 2201430353,2201430362,2201430372,2201430381,2201430391,
                 2201430453,2201430462,2201430472,2201430481,2201430491,
                 2201430553,2201430562,2201430572,2201430581,2201430591,
                 2202430153,2202430162,2202430172,2202430181,2202430191,
                 2202430253,2202430262,2202430272,2202430281,2202430291,
                 2202430353,2202430362,2202430372,2202430381,2202430391,
                 2202430453,2202430462,2202430472,2202430481,2202430491,
                 2202430562,2202430572,2202430581,2202430591,2202430553,
                 2203430153,2203430162,2203430172,2203430181,2203430191,
                 2203430253,2203430262,2203430272,2203430281,2203430291,
                 2203430353,2203430362,2203430372,2203430381,2203430391,
                 2203430453,2203430453,2203430462,2203430472,2203430481,
                 2203430491,2203430491,2203430553,2203430562,2203430572,
                 2203430581,2203430591,2204430153,2204430162,2204430172,
                 2204430181,2204430191,2204430253,2204430262,2204430272,
                 2204430281,2204430291,2204430353,2204430362,2204430372,
                 2204430381,2204430391,2204430453,2204430462,2204430472,
                 2204430481,2204430491,2204430553,2204430562,2204430572,
                 2204430581,2204430591,2205430153,2205430162,2205430172,
                 2205430181,2205430191,2205430253,2205430262,2205430272,
                 2205430281,2205430291,2205430353,2205430362,2205430372,
                 2205430381,2205430391,2205430453,2205430462,2205430472,
                 2205430481,2205430491,2205430553,2205430562,2205430572,
                 2205430581,2205430591)


#Bus emissions array in rate per distance csv zeroed out
# For all othe the school bus emissions - zero out 
rpdist[which(rpdist$agg_scc %in% school_emis_a),9:101] = 0

# For the light duty vehicle emissions - zero out 5.2% of light duty vehicles (i.e. electrify 5.2% of fleet)
rpdist[which(rpdist$agg_scc %in% light_duty_a),9:101] <-  rpdist[which(rpdist$agg_scc %in% light_duty_a),9:101]*0.9484

# Save new file 
write.csv(rpdist, "no_school_ldv/rpdistance_no_school_ldv.csv")

# Bus emissions array in rate per profile csv zeroed out
rpprof[which(rpprof$agg_scc %in% school_emis_a),9:34] = 0

# For the light duty vehicle emissions - zero out 5.2% of light duty vehicles (i.e. electrify 5.2% of fleet)
rpprof[which(rpprof$agg_scc %in% light_duty_a ),9:34] <-  rpprof[which(rpprof$agg_scc %in% light_duty_a),9:34]*0.9484
write.csv(rpprof, "no_school_ldv/rpprofile_no_school_ldv.csv")

# Bus emissions array in rate per hour csv zeroed out
# NONE in this csv
rphor[which(rphor$agg_scc %in% school_emis_a),9:89] = 0

# For the light duty vehicle emissions - zero out 5.2% of light duty vehicles (i.e. electrify 5.2% of fleet)
rphor[which(rphor$agg_scc %in% light_duty_a),9:89] <-  rphor[which(rphor$agg_scc %in% light_duty_a),9:89]*0.9484
write.csv(rphor, "no_school_ldv/rphour_no_school_ldv.csv")

# School bus emissions array in rate per vehicle csv zeroed out
rpveh[which(rpveh$agg_scc %in% school_emis_a),9:96] = 0

# For the light duty vehicle emissions - zero out 5.2% of light duty vehicles (i.e. electrify 5.2% of fleet)
rpveh[which(rpveh$agg_scc %in% light_duty_a ),9:96] <-  rpveh[which(rpveh$agg_scc %in% light_duty_a),9:96]*0.9484

# Save file
write.csv(rpveh, "no_school_ldv/rpvehicle_no_school_ldv.csv")
