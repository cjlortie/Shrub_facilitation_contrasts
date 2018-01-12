## WorldClim calculations
library(raster)
library(rgdal)


## site locations
site <- c("Pan.plateau","Pan.south","Pan.north","MNP1","MNP2","MNP3","MNP4","MNP5")
lat <- c(36.69627,36.70772,36.7056, 35.2682, 35.2620, 35.19298, 35.1625, 35.1513)
lon <- c(-120.7981,-120.81295, -120.81437, -116.0472, -115.96599, -115.90061, -115.82763, -115.76301)
sp.data <- data.frame(site,lat,lon)
coordinates(sp.data) <- ~lon+lat
proj4string(sp.data) <- CRS("+proj=longlat +datum=WGS84")


# bioclim <- getData('worldclim', var='bio', res=0.5, lon=c(-119,-118), lat=c(33,34)) ##download worldclim data
r1 <- raster("C:\\Data\\World Clim\\bio_1.bil") #annual temp
r8 <- raster("C:\\Data\\World Clim\\bio_8.bil") #temp wettest quarter
r12 <- raster("C:\\Data\\World Clim\\bio_12.bil") #annual precipitation
r15 <- raster("C:\\Data\\World Clim\\bio_15.bil") #precipitation seasonality
r16 <- raster("C:\\Data\\World Clim\\bio_16.bil") #precipitation wettest quarter

## combine rasters
clim.stack <- stack(r1,r8,r12,r15,r16)

## extract climate data for GPS coordinates
climate.data <- extract(clim.stack, sp.data)

## convert temperature to degrees
climate.data[,c("bio_1","bio_8")] <- climate.data[,c("bio_1","bio_8")]/10
climate.data <- data.frame(climate.data)
rownames(climate.data) <- c(site)

## calculate aridity index

climate.data["aridity"] <- c(climate.data[,"bio_12"]/(climate.data[,"bio_1"]*10))


write.csv(climate.data, "data\\shrub.contrast.climate.csv")