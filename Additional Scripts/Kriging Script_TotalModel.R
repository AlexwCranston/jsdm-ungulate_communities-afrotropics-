library(patchwork)
library(Hmsc)
library(ggplot2)
library(corrplot)
library(gplots)
library(ape)
library(dispRity)
library(rgdal)
library(letsR)
library(tidyverse)
library(dendextend)
library(rgdal)
library(automap)
library(sf)
library(ggsn)

load("models/models_thin_100_samples_250_chains_4_17April.Rdata") # Load models
m<-models[[1]] # Take Total model

postEta = getPostEstimate(m, parName ="Eta") # Extract eta parameters
xy<-models[[1]]$rL$ID$s # Extract coordinates

eta <- as.data.frame(postEta[[1]]) # Extract site loadings as dataframe 
eta<-cbind(xy,eta) # Add coordinates to site loadings
colnames(eta)<-c("Longitude","Latitude","V1","V2","V3","V4","V5")


#Convert eta to projected coordinates

eta_V1_projected <- eta[,1:3] #Take just first variable
coordinates(eta_V1_projected) <- c("Longitude", "Latitude") #Turn back into spdf
proj4string(eta_V1_projected) <- CRS("+proj=longlat +datum=WGS84")  ## Add crs info

eta_V1_projected <- spTransform(eta_V1_projected, CRS("+proj=merc +datum=WGS84")) # Transform from long lat to merc projection
eta_V1_projected<-as.data.frame(eta_V1_projected) # Convert back into dataframe


# Create grid from kriging 

min_x = min(eta_V1_projected$Longitude)-400000 #minimun x coordinate
min_y = min(eta_V1_projected$Latitude)-600000 #minimun y coordinate
x_length = max(eta_V1_projected$Longitude - min_x)+2500000 #easting amplitude
y_length = max(eta_V1_projected$Latitude - min_y) #northing amplitude
cellsize = 10000 #pixel size
ncol = round(x_length/cellsize,0) #number of columns in grid
nrow = round(y_length/cellsize,0) #number of rows in grid

coordinates(eta_V1_projected) = ~Longitude+Latitude # Convert again into a spdf
proj4string(eta_V1_projected) = CRS("+proj=merc +datum=WGS84") #assign CRS with projected coordinates.


grid.1 = GridTopology(cellcentre.offset=c(min_x,min_y),cellsize=c(cellsize,cellsize),cells.dim=c(ncol,nrow)) # Create grid


grid.1 = SpatialPixelsDataFrame(grid.1,
                                data=data.frame(id=1:prod(ncol,nrow)),
                                proj4string=CRS(proj4string(eta_V1_projected))) # Convert grid 

# Clip grid to just desired area, i.e. biome
total_shapefile <- readOGR("Raw Data Processing", "Africa_cropped") # upload shapefile
proj4string(total_shapefile) <- CRS("+proj=longlat +datum=WGS84") # add crs
total_shapefile<-spTransform(total_shapefile, CRS("+proj=merc +datum=WGS84")) # Transform to merc
total_shapefile.shp = total_shapefile@polygons # Convert to spatial polygons from spdf
total_shapefile.shp = SpatialPolygons(total_shapefile.shp, proj4string=CRS("+proj=merc +datum=WGS84")) #make sure the shapefile has the same CRS from the data, and from the prediction grid.

grid.1 = grid.1[!is.na(over(grid.1, total_shapefile.shp)),] # Crop grid to biome area and check grid is correct with plot(grid.1)


kriging_result = autoKrige(V1~1, eta_V1_projected, grid.1) # Run autokrige
plot(kriging_result) # Check result makes sense
krg.output=as.data.frame(kriging_result$krige_output)
interpolation.output=as.data.frame(krg.output)
names(interpolation.output)[1:3]<-c("x","y","z") # Change names to easier ones

#Create polygon for ggplot and crop it
africa <- readOGR("Raw Data Processing", "Africa_cropped") # Upload shapefile of Africa
africa.merc<-spTransform(africa, CRS("+proj=merc +datum=WGS84")) #Transform to merc projection
africa.merc<-st_as_sf(africa.merc) # Convert to sf object for cropping
africa.merc<-st_crop(africa.merc,y=c(xmin=min_x, ymin=min_y, ymax=1484892,xmax=(min_x+x_length))) # crop to size of kriging output
africa.merc<-as(africa.merc, 'Spatial') # Convert back to polygon

eta_points_projected<-as.data.frame(eta_V1_projected) # Make eta a dataframe again

limit.1 <- max(abs(interpolation.output$z)) * c(-1, 1)

V1.plot<-ggplot()+ 
  geom_polygon(data = africa.merc, aes(x = long, y = lat, group = group), colour = "black", fill = "black", size=0)+
  geom_raster(data=interpolation.output,mapping=aes(x,y,fill=z))+
  scale_fill_gradientn(colours = c("darkorchid4","darkorchid2","darkorchid1","white","chartreuse","chartreuse2","chartreuse4"), name = "",limits=limit.1)+
  geom_polygon(data = africa.merc, aes(x = long, y = lat, group = group), colour = "black", fill = "NA", size=1)+
  theme_bw()+
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(), plot.title = element_text(hjust = 0.5, size=25,face="bold"),
        legend.text = element_text(size=15,face="bold"),
        axis.title  = element_blank(),
        panel.border = element_blank(),
        panel.grid = element_blank())+
  geom_point(data = eta_points_projected, aes(x=Longitude, y=Latitude),shape=1,size=2)

#### Repeat for second latent variable


eta_V2_projected <- eta[,c(1:2,4)] #Take just first variable
coordinates(eta_V2_projected) <- c("Longitude", "Latitude") #Turn back into spdf
proj4string(eta_V2_projected) <- CRS("+proj=longlat +datum=WGS84")  ## Add crs info

eta_V2_projected <- spTransform(eta_V2_projected, CRS("+proj=merc +datum=WGS84")) # Transform from long lat to merc projection


# No reed to creat a new grid from kriging, we can use the existing one

kriging_result.2 = autoKrige(V2~1, eta_V2_projected, grid.1) # Run autokrige
plot(kriging_result.2) # Check result makes sense
krg.output.2=as.data.frame(kriging_result.2$krige_output)
interpolation.output.2=as.data.frame(krg.output.2)
names(interpolation.output.2)[1:3]<-c("x","y","z") # Change names to easier ones

eta_points_projected.2<-as.data.frame(eta_V2_projected) # Make eta a dataframe again

limit.2 <- max(abs(interpolation.output.2$z)) * c(-1, 1)

V2.plot<-ggplot()+ 
  geom_polygon(data = africa.merc, aes(x = long, y = lat, group = group), colour = "black", fill = "black", size=0)+
  geom_raster(data=interpolation.output.2,mapping=aes(x,y,fill=z))+
  scale_fill_gradientn(colours = c("darkorchid4","darkorchid2","darkorchid1","white","chartreuse","chartreuse2","chartreuse4"), name = "",limits=limit.2)+
  geom_polygon(data = africa.merc, aes(x = long, y = lat, group = group), colour = "black", fill = "NA", size=1)+
  theme_bw()+
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(), plot.title = element_text(hjust = 0.5, size=25,face="bold"),
        legend.text = element_text(size=15,face="bold"),
        axis.title  = element_blank(),
        panel.border = element_blank(),
        panel.grid = element_blank())+
  geom_point(data = eta_points_projected.2, aes(x=Longitude, y=Latitude),shape=1,size=2)

#1065*672


