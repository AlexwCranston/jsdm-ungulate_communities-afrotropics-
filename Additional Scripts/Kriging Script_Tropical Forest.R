library(patchwork)
library(Hmsc)
library(ggplot2)
library(corrplot)
library(gplots)
library(ape)
library(dispRity)
library(letsR)
library(tidyverse)
library(dendextend)
library(rgdal)
library(spThin)

load("models/models_thin_100_samples_250_chains_4_17April.Rdata")
m<-models[[3]]


postEta = getPostEstimate(m, parName ="Eta")
xy<-models[[3]]$rL$ID$s

eta <- as.data.frame(postEta[[1]])
eta<-cbind(xy,eta)
colnames(eta)<-c("Longitude","Latitude","V1","V2","V3","V4","V5")



eta_V1_projected <- eta[,1:3]
coordinates(eta_V1_projected) <- c("Longitude", "Latitude")
proj4string(eta_V1_projected) <- CRS("+proj=longlat +datum=WGS84")  ## for example

eta_V1_projected <- spTransform(eta_V1_projected, CRS("+proj=merc +datum=WGS84"))
eta_V1_projected<-as.data.frame(eta_V1_projected)

#Make Grid

min_x = -2004855.9922697 #minimun x coordinate
min_y = -4505107.92179046 #minimun y coordinate
x_length = 9282317.47214769 #easting amplitude
y_length = 6002575.43937934 #northing amplitude
cellsize = 10000 #pixel size
ncol = round(x_length/cellsize,0) #number of columns in grid
nrow = round(y_length/cellsize,0) #number of rows in grid

coordinates(eta_V1_projected) = ~Longitude+Latitude
proj4string(eta_V1_projected) = CRS("+proj=merc +datum=WGS84") #assign CRS with projected coordinates.

grid = GridTopology(cellcentre.offset=c(min_x,min_y),cellsize=c(cellsize,cellsize),cells.dim=c(ncol,nrow))



grid = SpatialPixelsDataFrame(grid,
                                data=data.frame(id=1:prod(ncol,nrow)),
                                proj4string=CRS(proj4string(eta_V1_projected)))


TropicalForests_shapefile <- readOGR("Raw Data Processing", "AfricaTropicalForests_highlysimplified_mappingONLY")
proj4string(TropicalForests_shapefile) <- CRS("+proj=longlat +datum=WGS84")

TropicalForests_shapefile<-spTransform(TropicalForests_shapefile, CRS("+proj=merc +datum=WGS84")) 
TropicalForests_shapefile.shp = TropicalForests_shapefile@polygons
TropicalForests_shapefile.shp = SpatialPolygons(TropicalForests_shapefile.shp, proj4string=CRS("+proj=merc +datum=WGS84")) #make sure the shapefile has the same CRS from the data, and from the prediction grid.


africa <- readOGR("Raw Data Processing", "Africa_cropped")
africa.merc<-spTransform(africa, CRS("+proj=merc +datum=WGS84"))
africa.merc.shp=africa.merc@polygons
africa.merc.shp=SpatialPolygons(africa.merc.shp, proj4string=CRS("+proj=merc +datum=WGS84")) #make sure the shapefile has the same CRS from the data, and from the prediction grid.



grid = grid[!is.na(over(grid, TropicalForests_shapefile.shp)),]


# Thin the data
tol=80000
zd <- zerodist(eta_V1_projected, zero=tol)
eta_V1_projected <- eta_V1_projected[-zd[,2], ] # Drop 226 of the original points to go from 300 to 74 points 

kriging_result = autoKrige(V1~1, eta_V1_projected, grid)
plot(kriging_result)
krg.output=as.data.frame(kriging_result$krige_output)
interpolation.output=as.data.frame(krg.output)
#Plot map with ggplot
names(interpolation.output)[1:3]<-c("x","y","z")


#Create polygon for ggplot and crop it

africa <- readOGR("Raw Data Processing", "Africa_cropped") # Upload shapefile of Africa
africa.merc<-spTransform(africa, CRS("+proj=merc +datum=WGS84")) #Transform to merc projection
africa.merc<-st_as_sf(africa.merc) # Convert to sf object for cropping
africa.merc<-st_crop(africa.merc,y=c(xmin=min_x, ymin=min_y, ymax=1497468,xmax=(min_x+x_length))) # crop to size of kriging output
africa.merc<-as(africa.merc, 'Spatial') # Convert back to polygon


eta_points_projected<-as.data.frame(eta_V1_projected) # Make eta a dataframe again

limit.1<- max(abs(interpolation.output$z)) * c(-1, 1)

V1.plot<-ggplot()+ 
  geom_polygon(data = africa.merc, aes(x = long, y = lat, group = group), colour = "black", fill = "black", size=0)+
  geom_tile(data=interpolation.output,mapping=aes(x,y,fill=z))+
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

## Now for 2nd variable



eta_V2_projected <- eta[,c(1:2,4)]
coordinates(eta_V2_projected) <- c("Longitude", "Latitude")
proj4string(eta_V2_projected) <- CRS("+proj=longlat +datum=WGS84")  ## for example
eta_V2_projected <- spTransform(eta_V2_projected, CRS("+proj=merc +datum=WGS84"))


# Thin the data

zd <- zerodist(eta_V2_projected, zero=tol)
eta_V2_projected <- eta_V2_projected[-zd[,2], ]

kriging_result.2 = autoKrige(V2~1, eta_V2_projected, grid)
plot(kriging_result.2)
krg.output.2=as.data.frame(kriging_result.2$krige_output)
interpolation.output.2=as.data.frame(krg.output.2)
names(interpolation.output.2)[1:3]<-c("x","y","z")

eta_points_projected<-as.data.frame(eta_V2_projected) # Make eta a dataframe again
limit.2<- max(abs(interpolation.output.2$z)) * c(-1, 1)


V2.plot<-ggplot()+ 
  geom_polygon(data = africa.merc, aes(x = long, y = lat, group = group), colour = "black", fill = "black", size=0)+
  geom_tile(data=interpolation.output.2,mapping=aes(x,y,fill=z))+
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
  geom_point(data = eta_points_projected, aes(x=Longitude, y=Latitude),shape=1,size=2)

