##Testing out GIS packages in R
#Created by Rebecca Finger
#Modified workflow from http://neondataskills.org/R/Introduction-to-Raster-Data-In-R/

#load libraries
library(raster)
library(rgdal)
library(here) ##set directory to project folder


##load DEM for Kanger area
slope<-raster(here("/DEM", "PGC_DEM_UTMzone22.img"))
slope
head(slope)

##Coordinate Reference System
crs(slope)

##Bring in vector file data (Shapefiles)
aoi_2011<-readOGR(here ("IK2011_outline.shp"))

#View typ of vector data
class(aoi_2011)

#View coordinate reference system
crs(aoi_2011)


##Crop DEM by Area of Interest
slope.crop <- crop(slope, aoi_2011, filename="slope_clip_2011aoi.tif", overwrite=TRUE)
plot(slope.crop,
     main= "Slope Model for West Greenland")
##par("mar")
par(mar=c(1,1,1,1))

#Create histogram of data
hist(slope.crop,
     breaks=10,
     main="Distribution of Slope Values",
     xlab="DEM Slope (deg)",
     ylab="Frequecny",
     col="wheat")

#Add in vector layer of lakes from 2011
lakes_2011<-readOGR(here ("/Spatial_join", "2011_spatialjoin.shp"))

plot(slope.crop,
     main= "Slope Model for West Greenland")
plot(lakes_2011, add=TRUE)
plot(aoi_2011, add=TRUE)


#attempting to calculate percent change of lakes
library(foreign)
lakes_2011dat<-read.dbf(here ("/Spatial_join", "2011_spatialjoin.dbf", as.is = TRUE))
