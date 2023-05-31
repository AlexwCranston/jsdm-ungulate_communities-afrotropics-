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

load("models/models_thin_100_samples_250_chains_4_FINALRUN.Rdata")

#First let's look at the Open Habitats model

m_OpenHabitats<-models[[2]]

preds_OpenHabitats = computePredictedValues(m_OpenHabitats)
results_OpenHabitats<-evaluateModelFit(hM=m_OpenHabitats, predY=preds_OpenHabitats)
results_OpenHabitats<-as.data.frame(results_OpenHabitats)
rownames(results_OpenHabitats)<- colnames(m_OpenHabitats$Y)
View(results_OpenHabitats)
mean(results_OpenHabitats$RMSE)
linear<-lm(results_OpenHabitats$TjurR2~colMeans(m_OpenHabitats$Y))
summary(linear) # No relationship between prevalence and R2

mean(results_OpenHabitats[,1])
# Now let's look at the Tropical Forests model 

m_TropicalForests<-models[[3]]

preds_TropicalForests = computePredictedValues(m_TropicalForests)
results_TropicalForests<-evaluateModelFit(hM=m_TropicalForests, predY=preds_TropicalForests)
results_TropicalForests<-as.data.frame(results_TropicalForests)
rownames(results_TropicalForests)<- colnames(m_TropicalForests$Y)
View(results_TropicalForests)
mean(results_TropicalForests$RMSE)
linear<-lm(results_TropicalForests$TjurR2~colMeans(m_TropicalForests$Y))
summary(linear) # No relationship between prevalence and R2

## Let's look at the Latent Variables for the Open Habitats model

postEta_OpenHabitats = getPostEstimate(m_OpenHabitats, parName ="Eta")
xy_OpenHabitats<-models[[2]]$rL$ID$s

eta_OpenHabitats <- as.data.frame(postEta_OpenHabitats[[1]])
eta_OpenHabitats<-cbind(xy_OpenHabitats,eta_OpenHabitats)
colnames(eta_OpenHabitats)<-c("Longitude","Latitude","V1","V2","V3","V4","V5")


library("rnaturalearth")
library("rnaturalearthdata")
library("ggspatial")


#Read in shapefile for Africa
africa <- readOGR("Raw Data Processing", "Africa_cropped")


V1<-ggplot(data = eta_OpenHabitats, aes(x=Longitude, y=Latitude, color=V1)) +  ggtitle("First Latent Variable")+ 
  scale_colour_gradientn(colours = c("purple","blue","green","yellow","orange","red"), name = "") +theme(legend.position="bottom")+
  labs(y="",x="") + 
  geom_polygon(data = africa, aes(x = long, y = lat, group = group), colour = "black", fill = "white", size=0.5) +
  geom_point(size=3)+
  theme_bw() +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(), plot.title = element_text(hjust = 0.5, size=30,face="bold"),
        legend.text = element_text(size=15,face="bold"),
        legend.position = "bottom")

V2<-ggplot(data = eta_OpenHabitats, aes(x=Longitude, y=Latitude, color=V2))+geom_point(size=1.5) +  ggtitle("Second Latent Variable")+ 
  scale_colour_gradientn(colours = c("purple","blue","green","yellow","orange","red"), name = "") +theme(legend.position="bottom")+
  labs(y="",x="") + 
  geom_polygon(data = africa, aes(x = long, y = lat, group = group), colour = "black", fill = NA, size=1) +
  theme_bw() +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(), plot.title = element_text(hjust = 0.5, size=30,face="bold"),
        legend.text = element_text(size=15,face="bold"), legend.position = "bottom")

                                                                                                                                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                                                  
V3<-ggplot(data = eta_OpenHabitats, aes(x=Longitude, y=Latitude, color=V3))+geom_point(size=1.5) +  ggtitle("Latent Variable 3")+ scale_colour_gradientn(colours = c("purple","blue","green","yellow","orange","red"), name = "") +theme(legend.position="bottom")+labs(y="")
V4<-ggplot(data = eta_OpenHabitats, aes(x=Longitude, y=Latitude, color=V4))+geom_point(size=1.5) +  ggtitle("Latent Variable 4")+ scale_colour_gradientn(colours = c("purple","blue","green","yellow","orange","red"), name = "") +theme(legend.position="bottom")+labs(y="")
V5<-ggplot(data = eta_OpenHabitats, aes(x=Longitude, y=Latitude, color=V5))+geom_point(size=1.5) +  ggtitle("Latent Variable 5")+ scale_colour_gradientn(colours = c("purple","blue","green","yellow","orange","red"), name = "") +theme(legend.position="bottom")+labs(y="")

protected.areas_OpenHabitats <- readOGR("Raw Data Processing", "Africa_ProtectedAreas_Category1_2_plusNationalParks_minusTropicalForests")

### Let's do the same for the Tropical Model

## Let's look at the Latent Variables for the Open Habitats model

postEta_TropicalForests = getPostEstimate(m_TropicalForests, parName ="Eta")
xy_TropicalForests<-models[[3]]$rL$ID$s

eta_TropicalForests <- as.data.frame(postEta_TropicalForests[[1]])
eta_TropicalForests<-cbind(xy_TropicalForests,eta_TropicalForests)
colnames(eta_TropicalForests)<-c("Longitude","Latitude","V1","V2","V3","V4","V5")

#Read in shapefile for Africa
africa <- readOGR("Raw Data Processing", "Africa_cropped")


V1<-ggplot(data = eta_TropicalForests, aes(x=Longitude, y=Latitude, color=V1)) +  ggtitle("First Latent Variable")+ 
  scale_colour_gradientn(colours = c("purple","blue","green","yellow","orange","red"), name = "") +theme(legend.position="bottom")+
  labs(y="",x="") + 
  geom_polygon(data = africa, aes(x = long, y = lat, group = group), colour = "black", fill = "white", size=0.5) +
  geom_point(size=3)+
  theme_bw() +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(), plot.title = element_text(hjust = 0.5, size=30,face="bold"),
        legend.text = element_text(size=15,face="bold"),
        legend.position = "bottom")

V2<-ggplot(data = eta_TropicalForests, aes(x=Longitude, y=Latitude, color=V2))+geom_point(size=1.5) +  ggtitle("Second Latent Variable")+ 
  scale_colour_gradientn(colours = c("purple","blue","green","yellow","orange","red"), name = "") +theme(legend.position="bottom")+
  labs(y="",x="") + 
  geom_polygon(data = africa, aes(x = long, y = lat, group = group), colour = "black", fill = NA, size=1) +
  theme_bw() +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(), plot.title = element_text(hjust = 0.5, size=30,face="bold"),
        legend.text = element_text(size=15,face="bold"), legend.position = "bottom")






## Try smoothing

#Convert eta to projected coordinates

eta_V1_projected <- eta_OpenHabitats[,1:3] #Take just first variable
coordinates(eta_V1_projected) <- c("Longitude", "Latitude") #Turn back into spdf
proj4string(eta_V1_projected) <- CRS("+proj=longlat +datum=WGS84")  ## Add crs info

eta_V1_projected <- spTransform(eta_V1_projected, CRS("+proj=merc +datum=WGS84")) # Transform from long lat to merc projection
eta_V1_projected<-as.data.frame(eta_V1_projected) # Convert back into dataframe



eta_V2_projected <- eta_OpenHabitats[,c(1:2,4)]
coordinates(eta_V2_projected) <- c("Longitude", "Latitude")
proj4string(eta_V2_projected) <- CRS("+proj=longlat +datum=WGS84")  ## for example

eta_V2_projected <- spTransform(eta_V2_projected, CRS("+proj=merc +datum=WGS84"))
eta_V2_projected<-as.data.frame(eta_V2_projected)

coordinates(eta_V2_projected) = ~Longitude+Latitude
proj4string(eta_V2_projected) = CRS("+proj=merc +datum=WGS84") #assign CRS with projected coordinates.



#Create Grid

#Setting the  prediction grid properties
min_x = min(eta_V1_projected$Longitude)-400000 #minimun x coordinate
min_y = min(eta_V1_projected$Latitude)-600000 #minimun y coordinate
x_length = max(eta_V1_projected$Longitude - min_x)+2500000 #easting amplitude
y_length = max(eta_V1_projected$Latitude - min_y) #northing amplitude
cellsize = 10000 #pixel size
ncol = round(x_length/cellsize,0) #number of columns in grid
nrow = round(y_length/cellsize,0) #number of rows in grid

coordinates(eta_V1_projected) = ~Longitude+Latitude
proj4string(eta_V1_projected) = CRS("+proj=merc +datum=WGS84") #assign CRS with projected coordinates.

grid.1 = GridTopology(cellcentre.offset=c(min_x,min_y),cellsize=c(cellsize,cellsize),cells.dim=c(ncol,nrow))

#Convert GridTopolgy object to SpatialPixelsDataFrame object.

grid.1 = SpatialPixelsDataFrame(grid.1,
                              data=data.frame(id=1:prod(ncol,nrow)),
                              proj4string=CRS(proj4string(eta_V1_projected)))


openHabitats_shapefile <- readOGR("Raw Data Processing", "Africa_minusTropicalForests")
proj4string(openHabitats_shapefile) <- CRS("+proj=longlat +datum=WGS84")

openHabitats_shapefile<-spTransform(openHabitats_shapefile, CRS("+proj=merc +datum=WGS84")) 
openHabitats_shapefile.shp = openHabitats_shapefile@polygons
openHabitats_shapefile.shp = SpatialPolygons(openHabitats_shapefile.shp, proj4string=CRS("+proj=merc +datum=WGS84")) #make sure the shapefile has the same CRS from the data, and from the prediction grid.

grid.1 = grid.1[!is.na(over(grid.1, openHabitats_shapefile.shp)),]



kriging_result = autoKrige(V1~1, eta_V1_projected, grid.1)
plot(kriging_result)
krg.output=as.data.frame(kriging_result$krige_output)
interpolation.output=as.data.frame(krg.output)
names(interpolation.output)[1:3]<-c("x","y","z") # Change names to easier ones

#Create polygon for ggplot and crop it
africa <- readOGR("Raw Data Processing", "Africa_cropped") # Upload shapefile of Africa
africa.merc<-spTransform(africa, CRS("+proj=merc +datum=WGS84")) #Transform to merc projection
africa.merc<-st_as_sf(africa.merc) # Convert to sf object for cropping
africa.merc<-st_crop(africa.merc,y=c(xmin=min_x, ymin=min_y, ymax=1484892,xmax=(min_x+x_length))) # crop to size of kriging output
africa.merc<-as(africa.merc, 'Spatial') # Convert back to polygon

ggplot()+ 
  geom_polygon(data = africa.merc, aes(x = long, y = lat, group = group), colour = "black", fill = "black", size=0)+
  geom_raster(data=interpolation.output,mapping=aes(x,y,fill=z))+
  scale_fill_gradientn(colours = c("darkorchid4","darkorchid2","darkorchid1","#88a974","chartreuse","chartreuse2","chartreuse4"), name = "")+
  geom_polygon(data = africa.merc, aes(x = long, y = lat, group = group), colour = "black", fill = "NA", size=1)+
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(), plot.title = element_text(hjust = 0.5, size=30,face="bold"),
        legend.text = element_text(size=15,face="bold"), legend.position = "bottom",
        axis.title  = element_blank())+
  theme_bw()
  

  
  


kriging_result2 = autoKrige(V2~1, eta_V2_projected, grid.1)
plot(kriging_result)
krg.output2=as.data.frame(kriging_result2$krige_output)
interpolation.output2=as.data.frame(krg.output2)
#Plot map with ggplot
names(interpolation.output2)[1:3]<-c("x","y","z")

ggplot()+ 
  geom_polygon(data = africa.merc, aes(x = long, y = lat, group = group), colour = "black", fill = "lightgrey", size=1)+
  geom_raster(data=interpolation.output2,mapping=aes(x,y,fill=z))+
  scale_fill_gradientn(colours = c("darkorchid4","darkorchid2","darkorchid1","#88a974","chartreuse","chartreuse2","chartreuse4"), name = "")+
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(), plot.title = element_text(hjust = 0.5, size=30,face="bold"),
        legend.text = element_text(size=15,face="bold"), legend.position = "bottom",
        axis.title  = element_blank(),
        panel.background = element_rect(fill = 'lightblue'),
        panel.grid = element_line(color = 'lightblue'))

?scale_fill_brewer

good_points_data<-st_drop_geometry(good_points)  
good_points_final<-cbind(good_points_data,good_points_UTM)

data(eta_projected)
head(eta_projected)


postLambda = getPostEstimate(m, parName ="Lambda")
lambda <- as.data.frame(postLambda[[1]])


colnames(lambda)<-colnames(m$Y)
rownames(lambda)<- c("V1","V2","V3","V4","V5")
transposed<-as.data.frame(t(lambda))


biPlot(m, etaPost = postEta, lambdaPost = postLambda, factors = c(1,2))

OmegaCor.spatial = computeAssociations(models[[2]])

supportLevel = 0.95
toPlot.spatial = ((OmegaCor.spatial[[1]]$support > supportLevel) + (OmegaCor.spatial[[1]]$support < (1-supportLevel)) > 0) * OmegaCor.spatial[[1]]$mean

corrplot(toPlot.spatial, method = "color", col = c("blue","white","red"), order = "FPC", type = "full")


OmegaCor.spatial = computeAssociations(models[[3]])

supportLevel = 0.95
toPlot.spatial = ((OmegaCor.spatial[[1]]$support > supportLevel) + (OmegaCor.spatial[[1]]$support < (1-supportLevel)) > 0) * OmegaCor.spatial[[1]]$mean

corrplot(toPlot.spatial, method = "color", col = COL2('PiYG', 200), order = "FPC", type = "full")



OmegaCor.spatial = computeAssociations(models[[1]])

supportLevel = 0.95
toPlot.spatial = ((OmegaCor.spatial[[1]]$support > supportLevel) + (OmegaCor.spatial[[1]]$support < (1-supportLevel)) > 0) * OmegaCor.spatial[[1]]$mean

corrplot(toPlot.spatial, method = "color", col = COL2('PiYG', 200), order = "FPC", type = "full")


#

xy.grid = as.matrix(cbind(mapping.da$Longitude.x., mapping.da$Latitude.y.))
XData.grid = data.frame(hot=mapping.da$BIO5,cold=mapping.da$BIO6,precip=mapping.da$BIO12, mean.diurnal.range=mapping.da$BIO2, precip.seasonality=mapping.da$BIO15, precip.range=(mapping.da$BIO16-mapping.da$BIO17), LandCover=as.factor(mapping.da$Land.Cover)) # Create data set of independent variables - annual precipitation, max temperature, minimum temperature, seasonality


Gradient = prepareGradient(m, XDataNew = m$XData, sDataNew = list(ID = xy))

predY = predict(m, Gradient = Gradient)


EpredY = apply(abind(predY,along = 3), c(1,2), mean) # Here we calculate the predicted values that Model 1 calculated for our randomly selected points


library(RColorBrewer)
coul <- colorRampPalette(brewer.pal(8, "PiYG"))(25)

postOmega = getPostEstimate(models[[2]], parName ="Omega")
Omega.toPlot = ((postOmega[[2]]> supportLevel) + (postOmega[[2]] < (1-supportLevel)) > 0) * postOmega[[1]]
colnames(Omega.toPlot)<-colnames(models[[2]]$Y)
rownames(Omega.toPlot)<-colnames(Omega.toPlot)

heatmap.2(Omega.toPlot, scale = "none", col = colorpanel(100, "blue", "white", "red"), 
          trace = "none", dendrogram = "row", density.info = "none", symm = TRUE, margins = c(9, 9), main = "Posterior Omega Estimates \n with High Support")


postOmegaCor = getPostEstimate(models[[2]], parName ="OmegaCor")

OmegaCor.toPlot = ((postOmegaCor[[2]]> supportLevel) + (postOmegaCor[[2]] < (1-supportLevel)) > 0) * postOmegaCor[[1]]
colnames(OmegaCor.toPlot)<-colnames(models[[2]]$Y)
rownames(OmegaCor.toPlot)<-colnames(OmegaCor.toPlot)
rownames(OmegaCor.toPlot)<-gsub("."," ", rownames(OmegaCor.toPlot), fixed = TRUE) 
colnames(OmegaCor.toPlot)<-gsub("."," ", rownames(OmegaCor.toPlot), fixed = TRUE) 

dd <- set(as.dendrogram(hclust(dist(OmegaCor.toPlot))), "branches_lwd", 10)

rownames(OmegaCor.toPlot)<-gsub("Aepyceros","A.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Alcelaphus","A.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Antidorcas","A.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus","C.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Connochaetes","C.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Connochaetes","C.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Damaliscus","D.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Equus","E.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Giraffa","G.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hippopotamus","H.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hippotragus","H.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hylochoerus","H.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Kobus","K.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Litocranius","L.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Loxodonta","L.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Madoqua","M.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Nanger","N.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Nanger","N.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Nesotragus","N.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Oreotragus","O.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Oryx","O.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Ourebia","O.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Phacochoerus","P.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Philantomba","P.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Potamochoerus","P.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Raphicerus","R.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Redunca","R.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Sylvicapra","S.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Syncerus","S.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus","T.", rownames(OmegaCor.toPlot), fixed = TRUE) 
colnames(OmegaCor.toPlot)<-rownames(OmegaCor.toPlot)

heatmap.2(OmegaCor.toPlot)
heatmap.2(OmegaCor.toPlot, scale = "none", col = colorpanel(100, "blue", "white", "red"), 
          trace = "none", dendrogram = "both",Rowv = dd, Colv = dd, cexRow=5.7,cexCol = 5.7,cex.main = 6,  density.info = "none", symm = TRUE, 
          margins = c(40, 40),
          labCol=as.expression(lapply(colnames(OmegaCor.toPlot), function(a) bquote(italic(.(a))))),
          labRow=as.expression(lapply(rownames(OmegaCor.toPlot), function(a) bquote(italic(.(a))))),
          key=TRUE, lhei=c(0.5,3), lwid=c(0.5,3))



postOmega = getPostEstimate(models[[1]], parName ="Omega")
Omega.toPlot = ((postOmega[[2]]> supportLevel) + (postOmega[[2]] < (1-supportLevel)) > 0) * postOmega[[1]]
colnames(Omega.toPlot)<-colnames(models[[1]]$Y)
rownames(Omega.toPlot)<-colnames(Omega.toPlot)
heatmap(Omega.toPlot, scale="column")
heatmap.2(Omega.toPlot, scale = "none", col = colorpanel(100, "blue", "white", "red"), 
          trace = "none", density.info = "none")


postOmega = getPostEstimate(models[[3]], parName ="Omega")
Omega.toPlot = ((postOmega[[2]]> supportLevel) + (postOmega[[2]] < (1-supportLevel)) > 0) * postOmega[[1]]
colnames(Omega.toPlot)<-colnames(models[[3]]$Y)
rownames(Omega.toPlot)<-colnames(Omega.toPlot)
heatmap.2(Omega.toPlot, scale = "none", col = colorpanel(100, "blue", "white", "red"), 
          trace = "none", density.info = "none")





postOmegaCor = getPostEstimate(models[[2]], parName ="OmegaCor")
OmegaCor.toPlot = ((postOmegaCor[[2]]> supportLevel) + (postOmegaCor[[2]] < (1-supportLevel)) > 0) * postOmegaCor[[1]]
colnames(OmegaCor.toPlot)<-colnames(models[[2]]$Y)
rownames(OmegaCor.toPlot)<-colnames(OmegaCor.toPlot)

heatmap.2(OmegaCor.toPlot, scale = "none", col = colorpanel(100, "blue", "white", "red"), 
          trace = "none", density.info = "none", symm = TRUE)


phy<-read.nexus("Phylogenetic Trees/tree-pruner-ccc90202-1f84-4ad0-8028-135052ba1d0d_AllUngulatesplusProboscidea/output.nex")

phy.1<- phy[[1]]
plot(phy.1)
nodelabels()
ages<-tree.age(phy.1)


distance<-(cophenetic.phylo(phy.1)) 
colnames(distance)<-gsub("_", ".", colnames(distance))
rownames(distance)<-gsub("_", ".", rownames(distance))
distance <- distance[, order((colnames(distance)))]
distance <- distance[order((rownames(distance))), ]
node.depth(phy.1)

diag(distance)=NA
diag(Omega.toPlot)=NA

plot(distance,Omega.toPlot, ylab="Omega",xlab="Phylogenetic distance")

VP_OpenHabitats<-computeVariancePartitioning(m_OpenHabitats,group=c(1,1,1,1,1,1,1,1,1),groupnames = c("Climatic Effects"))
V_OpenHabitats<-as.data.frame(t(VP_OpenHabitats$vals))
V_OpenHabitats$species <- rownames(V_OpenHabitats)



VP_TropicalForests<-computeVariancePartitioning(m_TropicalForests,group=c(1,1,1,1,1,1,1,1,1),groupnames = c("Climatic Effects"))
V_TropicalForests<-as.data.frame(t(VP_TropicalForests$vals))
V_TropicalForests$species <- rownames(V_TropicalForests)







###


library(dplyr)
library(dispRity)
library(reshape2)
get_recent_node_ages <- function(phy){
  
  # Use nodepath to get all the nodes from all the tips
  # then lapply will allow you to get the max node number of each
  # This should be the number of the node that is it's most recent ancestor
  nodeno <- lapply(ape::nodepath(phy), max)
  
  # Make the nodeno output into a dataframe
  # so we can use it in analyses later
  node.data <- as.data.frame(nodeno)
  
  # Add species names
  names(node.data) <- phy$tip.label
  
  # Reshape this so the names are a column
  # And the node counts are a column
  node.data <- reshape2::melt(node.data, value.name = "nodeno", 
                              variable.name = "species", id.vars = NULL)
  
  # Get tree ages
  tree.ages <- dispRity::tree.age(phy)
  
  # Make nodeno a character so we can merge with node.data
  node.data$nodeno <- as.character(node.data$nodeno)
  
  # Merge with node.data
  node.data <- left_join(node.data, tree.ages, by = c("nodeno" = "elements"))
  
  # Return the node.data dataframe
  return(node.data)
  
}

node.ages<-get_recent_node_ages(phy.1)
node.ages$species<-gsub("_",".", node.ages$species) 
names<-colnames(models[[2]]$Y)
node.ages<-node.ages %>% filter(species %in% names)
node.ages <- left_join(node.ages, V, by = c("species" = "species"))

plot(node.ages$ages,node.ages$`Random: ID`)
node.ages<-node.ages %>% slice(-17)
linear.model<-lm(node.ages$`Random: ID`~node.ages$ages, data=node.ages)
summary(linear.model)
tree_subset(phy.1, "Aepyceros_melampus", levels_back = 4)

plot.phylo(phy.1,show.tip.label =TRUE)






postOmegaCor = getPostEstimate(models[[3]], parName ="OmegaCor")

OmegaCor.toPlot = ((postOmegaCor[[2]]> supportLevel) + (postOmegaCor[[2]] < (1-supportLevel)) > 0) * postOmegaCor[[1]]
colnames(OmegaCor.toPlot)<-colnames(models[[3]]$Y)
rownames(OmegaCor.toPlot)<-colnames(OmegaCor.toPlot)
rownames(OmegaCor.toPlot)<-gsub("."," ", rownames(OmegaCor.toPlot), fixed = TRUE) 
colnames(OmegaCor.toPlot)<-gsub("."," ", rownames(OmegaCor.toPlot), fixed = TRUE) 

dd <- set(as.dendrogram(hclust(dist(OmegaCor.toPlot))), "branches_lwd", 10)

rownames(OmegaCor.toPlot)<-gsub("Aepyceros","A.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Alcelaphus","A.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Antidorcas","A.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus","C.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Choeropsis","C.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Connochaetes","C.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Equus","E.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hippopotamus","H.", rownames(OmegaCor.toPlot), fixed = TRUE)
rownames(OmegaCor.toPlot)<-gsub("Hyemoschus","H.", rownames(OmegaCor.toPlot), fixed = TRUE)
rownames(OmegaCor.toPlot)<-gsub("Hippotragus","H.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hylochoerus","H.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Kobus","K.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Loxodonta","L.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Madoqua","M.", rownames(OmegaCor.toPlot), fixed = TRUE)
rownames(OmegaCor.toPlot)<-gsub("Neotragus","N.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Nesotragus","N.", rownames(OmegaCor.toPlot), fixed = TRUE)
rownames(OmegaCor.toPlot)<-gsub("Okapia","O.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Oreotragus","O.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Ourebia","O.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Phacochoerus","P.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Philantomba","P.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Potamochoerus","P.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Redunca","R.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Sylvicapra","S.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Syncerus","S.", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus","T.", rownames(OmegaCor.toPlot), fixed = TRUE) 
colnames(OmegaCor.toPlot)<-rownames(OmegaCor.toPlot)

heatmap.2(OmegaCor.toPlot, scale = "none", col = colorpanel(100, "blue", "white", "red"), 
          trace = "none", dendrogram = "both",Rowv = dd, Colv = dd, cexRow=5.7,cexCol = 5.7,cex.main = 6,  density.info = "none", symm = TRUE, 
          margins = c(40, 40),
          labCol=as.expression(lapply(colnames(OmegaCor.toPlot), function(a) bquote(italic(.(a))))),
          labRow=as.expression(lapply(rownames(OmegaCor.toPlot), function(a) bquote(italic(.(a))))),
          key=TRUE, lhei=c(0.5,3), lwid=c(0.5,3))

View(postOmega[[1]])

# Box Plot to show explained variance


ggplot(V_OpenHabitats, aes(x="", y=`Random: ID`)) +
    stat_boxplot(geom ='errorbar',width = 0.5,lwd=1.5,color="darkred")+
    geom_boxplot(color="darkred", fill="orangered",alpha=1, lwd=1.5)+
    theme(legend.position="none",plot.title = element_text(size=11)) +
    ggtitle("") +
    xlab("")+
    ylab("Proportion of explained variance due to \nrandom effect")+
    geom_jitter(color="black", size=2.5, alpha=1)+
    theme(axis.text.x=element_blank(),
        axis.ticks.y=element_line(size = 1.5),
        plot.title = element_text(hjust = 0, size=30,face="bold"),
        axis.text.y=element_text(size=15,face="bold",colour = "black"),
        legend.text = element_text(size=15,face="bold"),
        axis.line.y = element_line(size = 1.5, linetype = "solid", colour = "black"),
        panel.background = element_blank(),
        panel.grid = element_blank(),
        axis.title.y = element_text(size = rel(1.8),face="bold",colour = "black"))
  

ggplot(V_TropicalForests, aes(x="", y=`Random: ID`)) +
  stat_boxplot(geom ='errorbar',width = 0.5,lwd=1.5,color="darkred")+
  geom_boxplot(color="darkred", fill="orangered",alpha=1, lwd=1.5)+
  theme(legend.position="none",plot.title = element_text(size=11)) +
  ggtitle("") +
  xlab("")+
  ylab("Proportion of explained variance due to \nrandom effect")+
  geom_jitter(color="black", size=2.5, alpha=1)+
  theme(axis.text.x=element_blank(),
        axis.ticks.y=element_line(size = 1.5),
        plot.title = element_text(hjust = 0, size=30,face="bold"),
        axis.text.y=element_text(size=15,face="bold",colour = "black"),
        legend.text = element_text(size=15,face="bold"),
        axis.line.y = element_line(size = 1.5, linetype = "solid", colour = "black"),
        panel.background = element_blank(),
        panel.grid = element_blank(),
        axis.title.y = element_text(size = rel(1.8),face="bold",colour = "black"))

