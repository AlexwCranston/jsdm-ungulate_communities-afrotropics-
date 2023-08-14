library(rgdal)
library(letsR)
library(tidyverse)

my_spdf <- readOGR("Raw Data Processing", "IUCN_download")


##Subsetting to only polygons where species are extent
extant.spdf<-my_spdf[my_spdf$LEGEND=="Extant (resident)",]


##Aggregating subspecies into a single polygon
combined.polygons = aggregate(extant.spdf, by = "BINOMIAL")
combined.polygons$PRESENCE <- 1


##Getting polygon of protected areas and Africa

protected.areas <- readOGR("Raw Data Processing", "Africa_ProtectedAreas_Category1_2_plusNationalParks")
protected.areas_TropicalForest <- readOGR("Raw Data Processing", "Africa_ProtectedAreas_Category1_2_plusNationalParks_TropicalForestsonly")
protected.areas_OpenHabitats <- readOGR("Raw Data Processing", "Africa_ProtectedAreas_Category1_2_plusNationalParks_minusTropicalForests")

Extent<-extent(protected.areas)

africa <- readOGR("Raw Data Processing", "Africa_cropped")



###Cropping species ranges to only Africa and excluding others not present

combined.polygons <- crop(x = combined.polygons, y = africa)

##Adding unique number to each polygon
combined.polygons$ID <- c(1:100)

###Using LetsR to create presence absence matrix


PAM <- lets.presab(combined.polygons, xmn = -30,   xmx = 70,  ymn = -50,  ymx = 50, res = (1/6), count = TRUE, remove.cells = TRUE) 
PAM <- lets.pamcrop(PAM, protected.areas, remove.sp = TRUE)

presence.absence.matrix<-PAM$P
presence.absence <- data.frame(presence.absence.matrix)

presence.absence <- presence.absence %>% filter(Latitude.y.<= 15) # Exclude all points above 15 degrees North, i.e. include only points from sub Saharan Africa

# Create a data.frame with sample site coordinates

lon <- presence.absence$Longitude.x.
lat <- presence.absence$Latitude.y.
samples <- data.frame(lon,lat)

#Extract bioclim variables from WorldClim

#First change the working directory
##Annual Mean Temperature
BIO1 <- raster("Rasters/wc2.1_10m_bio_1.tif")
BIO1.data <- samples
BIO1.data$BIO1 <- raster::extract(BIO1, samples)

##Mean Diurnal Range (Mean of monthly (max temp - min temp))
BIO2 <- raster("Rasters/wc2.1_10m_bio_2.tif")
BIO2.data <- samples
BIO2.data$BIO2 <- raster::extract(BIO2, samples)

# Isothermality (BIO2/BIO7) (?100)
BIO3 <- raster("Rasters/wc2.1_10m_bio_3.tif")
BIO3.data <- samples
BIO3.data$BIO3 <- raster::extract(BIO3, samples)


## Temperature Seasonality (standard deviation ?100)
BIO4 <- raster("Rasters/wc2.1_10m_bio_4.tif")
BIO4.data <- samples
BIO4.data$BIO4 <- raster::extract(BIO4, samples)

# Max Temperature of Warmest Month

BIO5 <- raster("Rasters/wc2.1_10m_bio_5.tif")
BIO5.data <- samples
BIO5.data$BIO5 <- raster::extract(BIO5, samples)

# Min Temperature of Coldest Month

BIO6 <- raster("Rasters/wc2.1_10m_bio_6.tif")
BIO6.data <- samples
BIO6.data$BIO6 <- raster::extract(BIO6, samples)

#Temperature Annual Range (BIO5-BIO6)
BIO7 <- raster("Rasters/wc2.1_10m_bio_7.tif")
BIO7.data <- samples
BIO7.data$BIO7 <- raster::extract(BIO7, samples)


#Mean Temperature of Wettest Quarter
BIO8 <- raster("Rasters/wc2.1_10m_bio_8.tif")
BIO8.data <- samples
BIO8.data$BIO8 <- raster::extract(BIO8, samples)

##Mean Temperature of Driest Quarter

BIO9 <- raster("Rasters/wc2.1_10m_bio_9.tif")
BIO9.data <- samples
BIO9.data$BIO9 <- raster::extract(BIO9, samples)


## Mean Temperature of Warmest Quarter


BIO10 <- raster("Rasters/wc2.1_10m_bio_10.tif")
BIO10.data <- samples
BIO10.data$BIO10 <- raster::extract(BIO10, samples)

## Mean Temperature of Coldest Quarter

BIO11 <- raster("Rasters/wc2.1_10m_bio_11.tif")
BIO11.data <- samples
BIO11.data$BIO11 <- raster::extract(BIO11, samples)


## Annual Precipitation

BIO12 <- raster("Rasters/wc2.1_10m_bio_12.tif")
BIO12.data <- samples
BIO12.data$BIO12 <- raster::extract(BIO12, samples)

##Precipitation of Wettest Month
BIO13 <- raster("Rasters/wc2.1_10m_bio_13.tif")
BIO13.data <- samples
BIO13.data$BIO13 <- raster::extract(BIO13, samples)

## Precipitation of Driest Month
BIO14 <- raster("Rasters/wc2.1_10m_bio_14.tif")
BIO14.data <- samples
BIO14.data$BIO14 <- raster::extract(BIO14, samples)

##Precipitation Seasonality (Coefficient of Variation)
BIO15 <- raster("Rasters/wc2.1_10m_bio_15.tif")
BIO15.data <- samples
BIO15.data$BIO15 <- raster::extract(BIO15, samples)


##Precipitation of Wettest Quarter
BIO16 <- raster("Rasters/wc2.1_10m_bio_16.tif")
BIO16.data <- samples
BIO16.data$BIO16 <- raster::extract(BIO16, samples)



#Precipitation of Driest Quarter

BIO17 <- raster("Rasters/wc2.1_10m_bio_17.tif")
BIO17.data <- samples
BIO17.data$BIO17 <- raster::extract(BIO17, samples)


# Precipitation of Warmest Quarter

BIO18 <- raster("Rasters/wc2.1_10m_bio_18.tif")
BIO18.data <- samples
BIO18.data$BIO18 <- raster::extract(BIO18, samples)

# Precipitation of Coldest Quarter

BIO19 <- raster("Rasters/wc2.1_10m_bio_19.tif")
BIO19.data <- samples
BIO19.data$BIO19 <- raster::extract(BIO19, samples)



# Cattle Abundance

Cattle.Aw<- raster("Rasters/6_Ct_2010_Aw_reprojected.tif")
Cattle.Aw.data <- samples
Cattle.Aw.data$Cattle.Aw <- raster::extract(Cattle.Aw, samples)

# Sheep Abundance

Sheep.Aw<- raster("Rasters/6_Sh_2010_Aw_reprojected.tif")
Sheep.Aw.data <- samples
Sheep.Aw.data$Sheep.Aw <- raster::extract(Sheep.Aw, samples)

# Goats Abundance 

Goat.Aw<- raster("Rasters/6_Gt_2010_Aw_reprojected.tif")
Goat.Aw.data <- samples
Goat.Aw.data$Goat.Aw <- raster::extract(Goat.Aw, samples)

# Total livestock Abundance

Total.livestock.Aw.data <- samples
Total.livestock.Aw.data$Total.livestock.Aw <- Cattle.Aw.data$Cattle.Aw+Sheep.Aw.data$Sheep.Aw+Goat.Aw.data$Goat.Aw

# Human Footprint

Human.footprint<- raster("Rasters/wildareas-v3-2009-human-footprint_reprojected.tif")
Human.footprint.data <- samples
Human.footprint.data$Human.footprint <- raster::extract(Human.footprint, samples)

# Land Use Cover 

Land.Cover <- raster("Rasters/GLC_SHV10_DOM_reprojected_10arcminutes.tif")
plot(Land.Cover)
Land.Cover.data <- samples
Land.Cover.data$Land.Cover <- raster::extract(Land.Cover, samples)
Land.Cover.data$Land.Cover <- as.factor(Land.Cover.data$Land.Cover) # Change the data from continuous to categorical
levels(Land.Cover.data$Land.Cover)
levels(Land.Cover.data$Land.Cover) <- c("No Data","Artificial Surfaces",
                                        "CropLand",
                                        "Grassland",
                                        "Tree Covered Area",
                                        "Shrubs Covered Area",
                                        "Herbaceous vegetation, aquatic or regularly flooded",
                                        "Mangroves",
                                        "Sparse vegetation",
                                        "BareSoil",
                                        "Waterbodies") # Rename the categories from numbers to their actual meaning
levels(Land.Cover.data$Land.Cover)

ggplot(data = Land.Cover.data, aes(x=lon, y=lat, color=Land.Cover))+geom_point(size=1.5) +  ggtitle("Land Cover")+ theme(legend.position="bottom")+labs(y="") + scale_colour_manual(values = c("black","antiquewhite4","darkgoldenrod1","chartreuse4","darkgreen", "chocolate4","chartreuse", "darkmagenta","brown1","brown","blue")) # Here we plot Land Cover to make sure it has come out correctly

#Create final dataframe
#Reset the working directory
final.dataframe <- data.frame(presence.absence, BIO1.data, BIO2.data, BIO3.data,BIO4.data,BIO5.data, 
                              BIO6.data, BIO7.data, BIO8.data, BIO9.data, BIO10.data, BIO11.data, BIO12.data, BIO13.data, BIO14.data, BIO15.data, BIO16.data, 
                              BIO17.data, BIO18.data,BIO19.data,Total.livestock.Aw.data,Human.footprint.data,Land.Cover.data)
View(final.dataframe)
drops <- c("lat", "lon","lat.1", "lon.1","lat.2", "lon.2","lat.3", "lon.3","lat.4", "lon.4", "lat.5", "lon.5", "lat.6", "lon.6","lat.7", "lon.7", "lat.8", "lon.8","lat.9", "lon.9",
           "lat.10", "lon.10","lat.11", "lon.11", "lat.12", "lon.12","lat.13", "lon.13","lat.14", "lon.14","lat.15", "lon.15", "lat.16", "lon.16","lat.17", "lon.17",
           "lat.18", "lon.18","lat.19", "lon.19","lat.20", "lon.20","lat.21", "lon.21")
final.dataframe <- final.dataframe[ , !(names(final.dataframe) %in% drops)]
write.csv(final.dataframe,"Data/Presab_plus_climate_variables_PROTECTEDAREASONLY_Res10arcminutes.csv", row.names = FALSE)


# Repeat for Biome subsets # Open Habitats first

###Using LetsR to create presence absence matrix


PAM <- lets.presab(combined.polygons, xmn = -30,   xmx = 70,  ymn = -50,  ymx = 50, res = (1/6), count = TRUE, remove.cells = TRUE) 
PAM <- lets.pamcrop(PAM, protected.areas_OpenHabitats, remove.sp = TRUE)

presence.absence.matrix<-PAM$P
presence.absence <- data.frame(presence.absence.matrix)

presence.absence <- presence.absence %>% filter(Latitude.y.<= 15) # Exclude all points above 15 degrees North, i.e. include only points from sub Saharan Africa

# Create a data.frame with sample site coordinates

lon <- presence.absence$Longitude.x.
lat <- presence.absence$Latitude.y.
samples <- data.frame(lon,lat)

#Extract bioclim variables from WorldClim

#First change the working directory
##Annual Mean Temperature
BIO1 <- raster("Rasters/wc2.1_10m_bio_1.tif")
BIO1.data <- samples
BIO1.data$BIO1 <- raster::extract(BIO1, samples)

##Mean Diurnal Range (Mean of monthly (max temp - min temp))
BIO2 <- raster("Rasters/wc2.1_10m_bio_2.tif")
BIO2.data <- samples
BIO2.data$BIO2 <- raster::extract(BIO2, samples)

# Isothermality (BIO2/BIO7) (?100)
BIO3 <- raster("Rasters/wc2.1_10m_bio_3.tif")
BIO3.data <- samples
BIO3.data$BIO3 <- raster::extract(BIO3, samples)


## Temperature Seasonality (standard deviation ?100)
BIO4 <- raster("Rasters/wc2.1_10m_bio_4.tif")
BIO4.data <- samples
BIO4.data$BIO4 <- raster::extract(BIO4, samples)

# Max Temperature of Warmest Month

BIO5 <- raster("Rasters/wc2.1_10m_bio_5.tif")
BIO5.data <- samples
BIO5.data$BIO5 <- raster::extract(BIO5, samples)

# Min Temperature of Coldest Month

BIO6 <- raster("Rasters/wc2.1_10m_bio_6.tif")
BIO6.data <- samples
BIO6.data$BIO6 <- raster::extract(BIO6, samples)

#Temperature Annual Range (BIO5-BIO6)
BIO7 <- raster("Rasters/wc2.1_10m_bio_7.tif")
BIO7.data <- samples
BIO7.data$BIO7 <- raster::extract(BIO7, samples)


#Mean Temperature of Wettest Quarter
BIO8 <- raster("Rasters/wc2.1_10m_bio_8.tif")
BIO8.data <- samples
BIO8.data$BIO8 <- raster::extract(BIO8, samples)

##Mean Temperature of Driest Quarter

BIO9 <- raster("Rasters/wc2.1_10m_bio_9.tif")
BIO9.data <- samples
BIO9.data$BIO9 <- raster::extract(BIO9, samples)


## Mean Temperature of Warmest Quarter


BIO10 <- raster("Rasters/wc2.1_10m_bio_10.tif")
BIO10.data <- samples
BIO10.data$BIO10 <- raster::extract(BIO10, samples)

## Mean Temperature of Coldest Quarter

BIO11 <- raster("Rasters/wc2.1_10m_bio_11.tif")
BIO11.data <- samples
BIO11.data$BIO11 <- raster::extract(BIO11, samples)


## Annual Precipitation

BIO12 <- raster("Rasters/wc2.1_10m_bio_12.tif")
BIO12.data <- samples
BIO12.data$BIO12 <- raster::extract(BIO12, samples)

##Precipitation of Wettest Month
BIO13 <- raster("Rasters/wc2.1_10m_bio_13.tif")
BIO13.data <- samples
BIO13.data$BIO13 <- raster::extract(BIO13, samples)

## Precipitation of Driest Month
BIO14 <- raster("Rasters/wc2.1_10m_bio_14.tif")
BIO14.data <- samples
BIO14.data$BIO14 <- raster::extract(BIO14, samples)

##Precipitation Seasonality (Coefficient of Variation)
BIO15 <- raster("Rasters/wc2.1_10m_bio_15.tif")
BIO15.data <- samples
BIO15.data$BIO15 <- raster::extract(BIO15, samples)


##Precipitation of Wettest Quarter
BIO16 <- raster("Rasters/wc2.1_10m_bio_16.tif")
BIO16.data <- samples
BIO16.data$BIO16 <- raster::extract(BIO16, samples)



#Precipitation of Driest Quarter

BIO17 <- raster("Rasters/wc2.1_10m_bio_17.tif")
BIO17.data <- samples
BIO17.data$BIO17 <- raster::extract(BIO17, samples)


# Precipitation of Warmest Quarter

BIO18 <- raster("Rasters/wc2.1_10m_bio_18.tif")
BIO18.data <- samples
BIO18.data$BIO18 <- raster::extract(BIO18, samples)

# Precipitation of Coldest Quarter

BIO19 <- raster("Rasters/wc2.1_10m_bio_19.tif")
BIO19.data <- samples
BIO19.data$BIO19 <- raster::extract(BIO19, samples)



# Cattle Abundance

Cattle.Aw<- raster("Rasters/6_Ct_2010_Aw_reprojected.tif")
Cattle.Aw.data <- samples
Cattle.Aw.data$Cattle.Aw <- raster::extract(Cattle.Aw, samples)

# Sheep Abundance

Sheep.Aw<- raster("Rasters/6_Sh_2010_Aw_reprojected.tif")
Sheep.Aw.data <- samples
Sheep.Aw.data$Sheep.Aw <- raster::extract(Sheep.Aw, samples)

# Goats Abundance 

Goat.Aw<- raster("Rasters/6_Gt_2010_Aw_reprojected.tif")
Goat.Aw.data <- samples
Goat.Aw.data$Goat.Aw <- raster::extract(Goat.Aw, samples)

# Total livestock Abundance

Total.livestock.Aw.data <- samples
Total.livestock.Aw.data$Total.livestock.Aw <- Cattle.Aw.data$Cattle.Aw+Sheep.Aw.data$Sheep.Aw+Goat.Aw.data$Goat.Aw

# Human Footprint

Human.footprint<- raster("Rasters/wildareas-v3-2009-human-footprint_reprojected.tif")
Human.footprint.data <- samples
Human.footprint.data$Human.footprint <- raster::extract(Human.footprint, samples)

# Land Use Cover 

Land.Cover <- raster("Rasters/GLC_SHV10_DOM_reprojected_10arcminutes.tif")
plot(Land.Cover)
Land.Cover.data <- samples
Land.Cover.data$Land.Cover <- raster::extract(Land.Cover, samples)
Land.Cover.data$Land.Cover <- as.factor(Land.Cover.data$Land.Cover) # Change the data from continuous to categorical
levels(Land.Cover.data$Land.Cover)
levels(Land.Cover.data$Land.Cover) <- c("No Data","Artificial Surfaces",
                                        "CropLand",
                                        "Grassland",
                                        "Tree Covered Area",
                                        "Shrubs Covered Area",
                                        "Herbaceous vegetation, aquatic or regularly flooded",
                                        "Mangroves",
                                        "Sparse vegetation",
                                        "BareSoil",
                                        "Waterbodies") # Rename the categories from numbers to their actual meaning
levels(Land.Cover.data$Land.Cover)

ggplot(data = Land.Cover.data, aes(x=lon, y=lat, color=Land.Cover))+geom_point(size=1.5) +  ggtitle("Land Cover")+ theme(legend.position="bottom")+labs(y="") + scale_colour_manual(values = c("black","antiquewhite4","darkgoldenrod1","chartreuse4","darkgreen", "chocolate4","chartreuse", "darkmagenta","brown1","brown","blue")) # Here we plot Land Cover to make sure it has come out correctly

#Create final dataframe
#Reset the working directory
final.dataframe <- data.frame(presence.absence, BIO1.data, BIO2.data, BIO3.data,BIO4.data,BIO5.data, 
                              BIO6.data, BIO7.data, BIO8.data, BIO9.data, BIO10.data, BIO11.data, BIO12.data, BIO13.data, BIO14.data, BIO15.data, BIO16.data, 
                              BIO17.data, BIO18.data,BIO19.data,Total.livestock.Aw.data,Human.footprint.data,Land.Cover.data)
View(final.dataframe)
drops <- c("lat", "lon","lat.1", "lon.1","lat.2", "lon.2","lat.3", "lon.3","lat.4", "lon.4", "lat.5", "lon.5", "lat.6", "lon.6","lat.7", "lon.7", "lat.8", "lon.8","lat.9", "lon.9",
           "lat.10", "lon.10","lat.11", "lon.11", "lat.12", "lon.12","lat.13", "lon.13","lat.14", "lon.14","lat.15", "lon.15", "lat.16", "lon.16","lat.17", "lon.17",
           "lat.18", "lon.18","lat.19", "lon.19","lat.20", "lon.20","lat.21", "lon.21")
final.dataframe <- final.dataframe[ , !(names(final.dataframe) %in% drops)]
write.csv(final.dataframe,"Data/Presab_plus_climate_variables_PROTECTEDAREASONLY_Res10arcminutes_OpenHabitats.csv", row.names = FALSE)


# Now Tropical Forests

###Using LetsR to create presence absence matrix


PAM <- lets.presab(combined.polygons, xmn = -30,   xmx = 70,  ymn = -50,  ymx = 50, res = (1/6), count = TRUE, remove.cells = TRUE) 
PAM <- lets.pamcrop(PAM, protected.areas_TropicalForest, remove.sp = TRUE)

presence.absence.matrix<-PAM$P
presence.absence <- data.frame(presence.absence.matrix)

presence.absence <- presence.absence %>% filter(Latitude.y.<= 15) # Exclude all points above 15 degrees North, i.e. include only points from sub Saharan Africa

# Create a data.frame with sample site coordinates

lon <- presence.absence$Longitude.x.
lat <- presence.absence$Latitude.y.
samples <- data.frame(lon,lat)

#Extract bioclim variables from WorldClim

#First change the working directory
##Annual Mean Temperature
BIO1 <- raster("Rasters/wc2.1_10m_bio_1.tif")
BIO1.data <- samples
BIO1.data$BIO1 <- raster::extract(BIO1, samples)


##Mean Diurnal Range (Mean of monthly (max temp - min temp))
BIO2 <- raster("Rasters/wc2.1_10m_bio_2.tif")
BIO2.data <- samples
BIO2.data$BIO2 <- raster::extract(BIO2, samples)

# Isothermality (BIO2/BIO7) (?100)
BIO3 <- raster("Rasters/wc2.1_10m_bio_3.tif")
BIO3.data <- samples
BIO3.data$BIO3 <- raster::extract(BIO3, samples)


## Temperature Seasonality (standard deviation ?100)
BIO4 <- raster("Rasters/wc2.1_10m_bio_4.tif")
BIO4.data <- samples
BIO4.data$BIO4 <- raster::extract(BIO4, samples)

# Max Temperature of Warmest Month

BIO5 <- raster("Rasters/wc2.1_10m_bio_5.tif")
BIO5.data <- samples
BIO5.data$BIO5 <- raster::extract(BIO5, samples)

# Min Temperature of Coldest Month

BIO6 <- raster("Rasters/wc2.1_10m_bio_6.tif")
BIO6.data <- samples
BIO6.data$BIO6 <- raster::extract(BIO6, samples)

#Temperature Annual Range (BIO5-BIO6)
BIO7 <- raster("Rasters/wc2.1_10m_bio_7.tif")
BIO7.data <- samples
BIO7.data$BIO7 <- raster::extract(BIO7, samples)


#Mean Temperature of Wettest Quarter
BIO8 <- raster("Rasters/wc2.1_10m_bio_8.tif")
BIO8.data <- samples
BIO8.data$BIO8 <- raster::extract(BIO8, samples)

##Mean Temperature of Driest Quarter

BIO9 <- raster("Rasters/wc2.1_10m_bio_9.tif")
BIO9.data <- samples
BIO9.data$BIO9 <- raster::extract(BIO9, samples)


## Mean Temperature of Warmest Quarter


BIO10 <- raster("Rasters/wc2.1_10m_bio_10.tif")
BIO10.data <- samples
BIO10.data$BIO10 <- raster::extract(BIO10, samples)

## Mean Temperature of Coldest Quarter

BIO11 <- raster("Rasters/wc2.1_10m_bio_11.tif")
BIO11.data <- samples
BIO11.data$BIO11 <- raster::extract(BIO11, samples)


## Annual Precipitation

BIO12 <- raster("Rasters/wc2.1_10m_bio_12.tif")
BIO12.data <- samples
BIO12.data$BIO12 <- raster::extract(BIO12, samples)

##Precipitation of Wettest Month
BIO13 <- raster("Rasters/wc2.1_10m_bio_13.tif")
BIO13.data <- samples
BIO13.data$BIO13 <- raster::extract(BIO13, samples)

## Precipitation of Driest Month
BIO14 <- raster("Rasters/wc2.1_10m_bio_14.tif")
BIO14.data <- samples
BIO14.data$BIO14 <- raster::extract(BIO14, samples)

##Precipitation Seasonality (Coefficient of Variation)
BIO15 <- raster("Rasters/wc2.1_10m_bio_15.tif")
BIO15.data <- samples
BIO15.data$BIO15 <- raster::extract(BIO15, samples)


##Precipitation of Wettest Quarter
BIO16 <- raster("Rasters/wc2.1_10m_bio_16.tif")
BIO16.data <- samples
BIO16.data$BIO16 <- raster::extract(BIO16, samples)



#Precipitation of Driest Quarter

BIO17 <- raster("Rasters/wc2.1_10m_bio_17.tif")
BIO17.data <- samples
BIO17.data$BIO17 <- raster::extract(BIO17, samples)


# Precipitation of Warmest Quarter

BIO18 <- raster("Rasters/wc2.1_10m_bio_18.tif")
BIO18.data <- samples
BIO18.data$BIO18 <- raster::extract(BIO18, samples)

# Precipitation of Coldest Quarter

BIO19 <- raster("Rasters/wc2.1_10m_bio_19.tif")
BIO19.data <- samples
BIO19.data$BIO19 <- raster::extract(BIO19, samples)




# Land Use Cover 

Land.Cover <- raster("Rasters/GLC_SHV10_DOM_reprojected_10arcminutes.tif")
plot(Land.Cover)
Land.Cover.data <- samples
Land.Cover.data$Land.Cover <- raster::extract(Land.Cover, samples)
Land.Cover.data$Land.Cover <- as.factor(Land.Cover.data$Land.Cover)# Change the data from continuous to categorical
levels(Land.Cover.data$Land.Cover)
levels(Land.Cover.data$Land.Cover) <- c("CropLand",
                                        "Grassland",
                                        "Tree Covered Area",
                                        "Shrubs Covered Area",
                                        "Herbaceous vegetation, aquatic or regularly flooded",
                                        "Mangroves",
                                        "BareSoil",
                                        "Waterbodies") # Rename the categories from numbers to their actual meaning
levels(Land.Cover.data$Land.Cover)

ggplot(data = Land.Cover.data, aes(x=lon, y=lat, color=Land.Cover))+geom_point(size=1.5) +  ggtitle("Land Cover")+ theme(legend.position="bottom")+labs(y="") + scale_colour_manual(values = c("darkgoldenrod1","chartreuse4","darkgreen", "chocolate4","chartreuse", "darkmagenta","brown","blue")) # Here we plot Land Cover to make sure it has come out correctly

#Create final dataframe
#Reset the working directory
final.dataframe <- data.frame(presence.absence, BIO1.data, BIO2.data, BIO3.data,BIO4.data,BIO5.data, 
                              BIO6.data, BIO7.data, BIO8.data, BIO9.data, BIO10.data, BIO11.data, BIO12.data, BIO13.data, BIO14.data, BIO15.data, BIO16.data, 
                              BIO17.data, BIO18.data,BIO19.data,Total.livestock.Aw.data,Human.footprint.data,Land.Cover.data)
View(final.dataframe)
drops <- c("lat", "lon","lat.1", "lon.1","lat.2", "lon.2","lat.3", "lon.3","lat.4", "lon.4", "lat.5", "lon.5", "lat.6", "lon.6","lat.7", "lon.7", "lat.8", "lon.8","lat.9", "lon.9",
           "lat.10", "lon.10","lat.11", "lon.11", "lat.12", "lon.12","lat.13", "lon.13","lat.14", "lon.14","lat.15", "lon.15", "lat.16", "lon.16","lat.17", "lon.17",
           "lat.18", "lon.18","lat.19", "lon.19","lat.20", "lon.20","lat.21", "lon.21")
final.dataframe <- final.dataframe[ , !(names(final.dataframe) %in% drops)]
write.csv(final.dataframe,"Data/Presab_plus_climate_variables_PROTECTEDAREASONLY_Res10arcminutes_TropicalForests.csv", row.names = FALSE)

