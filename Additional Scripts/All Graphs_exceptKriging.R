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

load("models/models_thin_100_samples_250_chains_4_17April.Rdata")

#First let's look at the Open Habitats model

m_OpenHabitats<-models[[2]]

preds_OpenHabitats = computePredictedValues(m_OpenHabitats)
results_OpenHabitats<-evaluateModelFit(hM=m_OpenHabitats, predY=preds_OpenHabitats)
results_OpenHabitats<-as.data.frame(results_OpenHabitats)
rownames(results_OpenHabitats)<- colnames(m_OpenHabitats$Y)
View(results_OpenHabitats)
mean(results_OpenHabitats$RMSE) # 0.1864558
mean(results_OpenHabitats$TjurR2) # 0.6536397
linear<-lm(results_OpenHabitats$TjurR2~colMeans(m_OpenHabitats$Y))
summary(linear) # No relationship between prevalence and R2

# Now let's look at the Tropical Forests model 

m_TropicalForests<-models[[3]]

preds_TropicalForests = computePredictedValues(m_TropicalForests)
results_TropicalForests<-evaluateModelFit(hM=m_TropicalForests, predY=preds_TropicalForests)
results_TropicalForests<-as.data.frame(results_TropicalForests)
rownames(results_TropicalForests)<- colnames(m_TropicalForests$Y)
View(results_TropicalForests)
mean(results_TropicalForests$RMSE) #0.1219018
mean(results_TropicalForests$TjurR2) #0.7989281
linear<-lm(results_TropicalForests$TjurR2~colMeans(m_TropicalForests$Y))
summary(linear) # No relationship between prevalence and R2

# Let's look at the total model

m_total<-models[[1]]

preds_total = computePredictedValues(m_total)
results_total<-evaluateModelFit(hM=m_total, predY=preds_total)
results_total<-as.data.frame(results_total)
rownames(results_total)<- colnames(m_total$Y)
View(results_total)
mean(results_total$RMSE) # 0.1606042
mean(results_total$TjurR2) # 0.710787
linear<-lm(results_total$TjurR2~colMeans(m_total$Y))
summary(linear) # No relationship between prevalence and R2

## Let's look at the Latent Variables for the Open Habitats model

postEta_OpenHabitats = getPostEstimate(m_OpenHabitats, parName ="Eta")
xy_OpenHabitats<-models[[2]]$rL$ID$s

eta_OpenHabitats <- as.data.frame(postEta_OpenHabitats[[1]])
eta_OpenHabitats<-cbind(xy_OpenHabitats,eta_OpenHabitats)
colnames(eta_OpenHabitats)<-c("Longitude","Latitude","V1","V2","V3","V4","V5")


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

V2<-ggplot(data = eta_OpenHabitats, aes(x=Longitude, y=Latitude, color=V2))+geom_point(size=3) +  ggtitle("Second Latent Variable")+ 
  scale_colour_gradientn(colours = c("purple","blue","green","yellow","orange","red"), name = "") +theme(legend.position="bottom")+
  labs(y="",x="") + 
  geom_polygon(data = africa, aes(x = long, y = lat, group = group), colour = "black", fill = NA, size=1) +
  theme_bw() +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(), plot.title = element_text(hjust = 0.5, size=30,face="bold"),
        legend.text = element_text(size=15,face="bold"), legend.position = "bottom")

                                                                                                                                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                                                  
V3<-ggplot(data = eta_OpenHabitats, aes(x=Longitude, y=Latitude, color=V3))+geom_point(size=3) +  ggtitle("Third Latent Variable")+ 
  scale_colour_gradientn(colours = c("purple","blue","green","yellow","orange","red"), name = "") +theme(legend.position="bottom")+
  labs(y="",x="") + 
  geom_polygon(data = africa, aes(x = long, y = lat, group = group), colour = "black", fill = NA, size=1) +
  theme_bw() +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(), plot.title = element_text(hjust = 0.5, size=30,face="bold"),
        legend.text = element_text(size=15,face="bold"), legend.position = "bottom")

V4<-ggplot(data = eta_OpenHabitats, aes(x=Longitude, y=Latitude, color=V4))+geom_point(size=1.5) +  ggtitle("Latent Variable 4")+ scale_colour_gradientn(colours = c("purple","blue","green","yellow","orange","red"), name = "") +theme(legend.position="bottom")+labs(y="")
V5<-ggplot(data = eta_OpenHabitats, aes(x=Longitude, y=Latitude, color=V5))+geom_point(size=1.5) +  ggtitle("Latent Variable 5")+ scale_colour_gradientn(colours = c("purple","blue","green","yellow","orange","red"), name = "") +theme(legend.position="bottom")+labs(y="")

### Let's do the same for the Tropical Model

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

V2<-ggplot(data = eta_TropicalForests, aes(x=Longitude, y=Latitude, color=V2))+geom_point(size=3) +  ggtitle("Second Latent Variable")+ 
  scale_colour_gradientn(colours = c("purple","blue","green","yellow","orange","red"), name = "") +theme(legend.position="bottom")+
  labs(y="",x="") + 
  geom_polygon(data = africa, aes(x = long, y = lat, group = group), colour = "black", fill = NA, size=1) +
  theme_bw() +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(), plot.title = element_text(hjust = 0.5, size=30,face="bold"),
        legend.text = element_text(size=15,face="bold"), legend.position = "bottom")

V3<-ggplot(data = eta_TropicalForests, aes(x=Longitude, y=Latitude, color=V3))+geom_point(size=1.5) +  ggtitle("Latent Variable 3")+ scale_colour_gradientn(colours = c("purple","blue","green","yellow","orange","red"), name = "") +theme(legend.position="bottom")+labs(y="")

###

postEta_total = getPostEstimate(m_total, parName ="Eta")
xy_total<-models[[1]]$rL$ID$s

eta_total <- as.data.frame(postEta_total[[1]])
eta_total<-cbind(xy_total,eta_total)
colnames(eta_total)<-c("Longitude","Latitude","V1","V2","V3","V4","V5")

#Read in shapefile for Africa
africa <- readOGR("Raw Data Processing", "Africa_cropped")


V1<-ggplot(data = eta_total, aes(x=Longitude, y=Latitude, color=V1)) +  ggtitle("First Latent Variable")+ 
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

V2<-ggplot(data = eta_total, aes(x=Longitude, y=Latitude, color=V2))+geom_point(size=3) +  ggtitle("Second Latent Variable")+ 
  scale_colour_gradientn(colours = c("purple","blue","green","yellow","orange","red"), name = "") +theme(legend.position="bottom")+
  labs(y="",x="") + 
  geom_polygon(data = africa, aes(x = long, y = lat, group = group), colour = "black", fill = NA, size=1) +
  theme_bw() +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(), plot.title = element_text(hjust = 0.5, size=30,face="bold"),
        legend.text = element_text(size=15,face="bold"), legend.position = "bottom")

V3<-ggplot(data = eta_total, aes(x=Longitude, y=Latitude, color=V3))+geom_point(size=1.5) +  ggtitle("Latent Variable 3")+ scale_colour_gradientn(colours = c("purple","blue","green","yellow","orange","red"), name = "") +theme(legend.position="bottom")+labs(y="")




# Correlation Matrix for Open Habitats Model

supportLevel=0.95

postOmegaCor = getPostEstimate(models[[2]], parName ="OmegaCor")

OmegaCor.toPlot = ((postOmegaCor[[2]]> supportLevel) + (postOmegaCor[[2]] < (1-supportLevel)) > 0) * postOmegaCor[[1]]
colnames(OmegaCor.toPlot)<-colnames(models[[2]]$Y)
rownames(OmegaCor.toPlot)<-colnames(OmegaCor.toPlot)
rownames(OmegaCor.toPlot)<-gsub("."," ", rownames(OmegaCor.toPlot), fixed = TRUE) 
colnames(OmegaCor.toPlot)<-gsub("."," ", rownames(OmegaCor.toPlot), fixed = TRUE) 

dd <- set(as.dendrogram(hclust(dist(OmegaCor.toPlot))), "branches_lwd", 10)

rownames(OmegaCor.toPlot)<-gsub("Aepyceros melampus","Impala", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Alcelaphus buselaphus","Hartebeest", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Antidorcas marsupialis","Springbok", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus harveyi","Harvey's Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus rufilatus","Red-flanked Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus silvicultor","Yellow-backed Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus natalensis","Red Forest Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Ceratotherium simum","White Rhino", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Connochaetes taurinus","Blue Wildebeest", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Damaliscus lunatus","Topi", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Diceros bicornis","Black Rhino", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Equus quagga","Plains Zebra", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Equus zebra","Mountain Zebra", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Eudorcas albonotata","Mongalla Gazelle", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Eudorcas rufifrons","Red-fronted Gazelle", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Eudorcas thomsonii","Thomson's Gazelle", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Giraffa camelopardalis","Giraffe", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hippopotamus amphibius","Hippopotamus", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hippotragus equinus","Roan Antelope", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hippotragus niger","Sable Antelope", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hylochoerus meinertzhageni","Giant Forest Hog", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Kobus ellipsiprymnus","Waterbuck", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Kobus kob","Kob", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Kobus leche","Lechwe", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Kobus vardonii","Puku", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Litocranius walleri","Gerenuk", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Loxodonta africana","African Bush Elephant", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Madoqua guentheri","Günther's Dik-dik", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Madoqua kirkii","Kirk's Dik-dik", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Nanger granti","Grant's Gazelle", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Nesotragus moschatus","Suni", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Oreotragus oreotragus","Klipspringer", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Oryx beisa","East African Oryx", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Oryx gazella","Gemsbok", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Ourebia ourebi","Oribi", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Pelea capreolus","Grey Rhebok", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Phacochoerus africanus","Common Warthog", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Phacochoerus aethiopicus","Desert Warthog", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Philantomba maxwellii","Maxwell's Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Philantomba monticola","Blue Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Potamochoerus larvatus","Bushpig", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Potamochoerus porcus","Red River Hog", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Raphicerus campestris","Steenbok", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Raphicerus sharpei","Sharpe's Grysbok", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Redunca arundinum","Southern Reedbuck", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Redunca fulvorufula","Mountain Reedbuck", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Redunca redunca","Bohor Reedbuck", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Sylvicapra grimmia","Common Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Syncerus caffer","African Buffalo", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus angasii","Nyala", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus derbianus","Giant Eland", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus eurycerus","Bongo", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus imberbis","Lesser Kudu", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus oryx","Common Eland", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus scriptus","Bushbuck", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus spekii","Sitatunga", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus strepsiceros","Greater Kudu", rownames(OmegaCor.toPlot), fixed = TRUE) 
colnames(OmegaCor.toPlot)<-rownames(OmegaCor.toPlot)


heatmap.2(OmegaCor.toPlot, scale = "none", col = colorpanel(100, "blue", "white", "red"), 
          trace = "none", dendrogram = "both",Rowv = dd, Colv = dd, cexRow=4.25,cexCol = 4.25,cex.main = 5,  density.info = "none", symm = TRUE, 
          margins = c(40, 40),
          key=TRUE, lhei=c(0.5,3), lwid=c(0.5,3))


### Correlation Matrix for Tropical Forests Model


postOmegaCor = getPostEstimate(models[[3]], parName ="OmegaCor")

OmegaCor.toPlot = ((postOmegaCor[[2]]> supportLevel) + (postOmegaCor[[2]] < (1-supportLevel)) > 0) * postOmegaCor[[1]]
colnames(OmegaCor.toPlot)<-colnames(models[[3]]$Y)
rownames(OmegaCor.toPlot)<-colnames(OmegaCor.toPlot)
rownames(OmegaCor.toPlot)<-gsub("."," ", rownames(OmegaCor.toPlot), fixed = TRUE) 
colnames(OmegaCor.toPlot)<-gsub("."," ", rownames(OmegaCor.toPlot), fixed = TRUE) 

dd <- set(as.dendrogram(hclust(dist(OmegaCor.toPlot))), "branches_lwd", 10)


rownames(OmegaCor.toPlot)<-gsub("Cephalophus callipygus","Peters' Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus dorsalis","Bay Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus natalensis","Red Forest Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus harveyi","Harvey's Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus jentinki","Jentink's Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus leucogaster","White-bellied Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus niger","Black Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus nigrifrons","Black-fronted Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus ogilbyi","Ogilby's Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus rufilatus","Red-flanked Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus silvicultor","Yellow-backed Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus weynsi","Weyns's Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus zebra","Zebra Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Choeropsis liberiensis","Pygmy Hippopotamus", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hippopotamus amphibius","Hippopotamus", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hippotragus niger","Sable Antelope", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hyemoschus aquaticus","Water Chevrotain", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hylochoerus meinertzhageni","Giant Forest Hog", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Loxodonta cyclotis","African Forest Elephant", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Neotragus batesi","Bates's Pygmy Antelope", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Neotragus pygmaeus","Royal Antelope", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Nesotragus moschatus","Suni", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Okapia johnstoni","Okapi", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Philantomba maxwellii","Maxwell's Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Philantomba monticola","Blue Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Potamochoerus larvatus","Bushpig", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Potamochoerus porcus","Red River Hog", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Syncerus caffer","African Buffalo", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus eurycerus","Bongo", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus scriptus","Bushbuck", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus spekii","Sitatunga", rownames(OmegaCor.toPlot), fixed = TRUE) 
colnames(OmegaCor.toPlot)<-rownames(OmegaCor.toPlot)


heatmap.2(OmegaCor.toPlot, scale = "none", col = colorpanel(100, "blue", "white", "red"), 
          trace = "none", dendrogram = "both",Rowv = dd, Colv = dd,  cexRow=4.25,cexCol = 4.25,cex.main = 5,  density.info = "none", symm = TRUE, 
          margins = c(40, 40),key=TRUE, lhei=c(0.5,3), lwid=c(0.5,3))

### Correlation Matrix for TotalModel


postOmegaCor = getPostEstimate(models[[1]], parName ="OmegaCor")

OmegaCor.toPlot = ((postOmegaCor[[2]]> supportLevel) + (postOmegaCor[[2]] < (1-supportLevel)) > 0) * postOmegaCor[[1]]
colnames(OmegaCor.toPlot)<-colnames(models[[1]]$Y)
rownames(OmegaCor.toPlot)<-colnames(OmegaCor.toPlot)
rownames(OmegaCor.toPlot)<-gsub("."," ", rownames(OmegaCor.toPlot), fixed = TRUE) 
colnames(OmegaCor.toPlot)<-gsub("."," ", rownames(OmegaCor.toPlot), fixed = TRUE) 

dd <- set(as.dendrogram(hclust(dist(OmegaCor.toPlot))), "branches_lwd", 10)


rownames(OmegaCor.toPlot)<-gsub("Aepyceros melampus","Impala", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Alcelaphus buselaphus","Hartebeest", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Antidorcas marsupialis","Springbok", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus harveyi","Harvey's Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus rufilatus","Red-flanked Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus silvicultor","Yellow-backed Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus natalensis","Red Forest Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Ceratotherium simum","White Rhino", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Connochaetes taurinus","Blue Wildebeest", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Damaliscus lunatus","Topi", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Diceros bicornis","Black Rhino", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Equus quagga","Plains Zebra", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Equus zebra","Mountain Zebra", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Eudorcas albonotata","Mongalla Gazelle", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Eudorcas rufifrons","Red-fronted Gazelle", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Eudorcas thomsonii","Thomson's Gazelle", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Giraffa camelopardalis","Giraffe", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hippopotamus amphibius","Hippopotamus", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hippotragus equinus","Roan Antelope", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hippotragus niger","Sable Antelope", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hylochoerus meinertzhageni","Giant Forest Hog", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Kobus ellipsiprymnus","Waterbuck", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Kobus kob","Kob", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Kobus leche","Lechwe", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Kobus vardonii","Puku", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Litocranius walleri","Gerenuk", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Loxodonta africana","African Bush Elephant", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Madoqua guentheri","Günther's Dik-dik", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Madoqua kirkii","Kirk's Dik-dik", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Nanger granti","Grant's Gazelle", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Nesotragus moschatus","Suni", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Oreotragus oreotragus","Klipspringer", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Oryx beisa","East African Oryx", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Oryx gazella","Gemsbok", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Ourebia ourebi","Oribi", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Pelea capreolus","Grey Rhebok", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Phacochoerus africanus","Common Warthog", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Phacochoerus aethiopicus","Desert Warthog", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Philantomba maxwellii","Maxwell's Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Philantomba monticola","Blue Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Potamochoerus larvatus","Bushpig", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Potamochoerus porcus","Red River Hog", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Raphicerus campestris","Steenbok", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Raphicerus sharpei","Sharpe's Grysbok", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Redunca arundinum","Southern Reedbuck", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Redunca fulvorufula","Mountain Reedbuck", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Redunca redunca","Bohor Reedbuck", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Sylvicapra grimmia","Common Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Syncerus caffer","African Buffalo", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus angasii","Nyala", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus derbianus","Giant Eland", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus eurycerus","Bongo", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus imberbis","Lesser Kudu", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus oryx","Common Eland", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus scriptus","Bushbuck", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus spekii","Sitatunga", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus strepsiceros","Greater Kudu", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus callipygus","Peters' Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus dorsalis","Bay Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus natalensis","Red Forest Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus harveyi","Harvey's Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus jentinki","Jentink's Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus leucogaster","White-bellied Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus niger","Black Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus nigrifrons","Black-fronted Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus ogilbyi","Ogilby's Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus rufilatus","Red-flanked Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus silvicultor","Yellow-backed Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus weynsi","Weyns's Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Cephalophus zebra","Zebra Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Choeropsis liberiensis","Pygmy Hippopotamus", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hippopotamus amphibius","Hippopotamus", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hippotragus niger","Sable Antelope", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hyemoschus aquaticus","Water Chevrotain", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Hylochoerus meinertzhageni","Giant Forest Hog", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Loxodonta cyclotis","African Forest Elephant", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Neotragus batesi","Bates's Pygmy Antelope", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Neotragus pygmaeus","Royal Antelope", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Nesotragus moschatus","Suni", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Okapia johnstoni","Okapi", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Philantomba maxwellii","Maxwell's Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Philantomba monticola","Blue Duiker", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Potamochoerus larvatus","Bushpig", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Potamochoerus porcus","Red River Hog", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Syncerus caffer","African Buffalo", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus eurycerus","Bongo", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus scriptus","Bushbuck", rownames(OmegaCor.toPlot), fixed = TRUE) 
rownames(OmegaCor.toPlot)<-gsub("Tragelaphus spekii","Sitatunga", rownames(OmegaCor.toPlot), fixed = TRUE) 
colnames(OmegaCor.toPlot)<-rownames(OmegaCor.toPlot)


heatmap.2(OmegaCor.toPlot, scale = "none", col = colorpanel(100, "blue", "white", "red"), 
          trace = "none", dendrogram = "both",Rowv = dd, Colv = dd,  cexRow=4.25,cexCol = 4.25,cex.main = 5,  density.info = "none", symm = TRUE, 
          margins = c(40, 40),key=TRUE, lhei=c(0.5,3), lwid=c(0.5,3))



#### # Box Plot to show explained variance


# First work out explained variance for each model
# We group all fixed effects together as we're not interested in the difference between them, just value attributed to the random effect, i.e. the Latent variables

VP_OpenHabitats<-computeVariancePartitioning(m_OpenHabitats,group=c(1,1,1,1,1,1,1,1,1),groupnames = c("Climatic Effects"))
V_OpenHabitats<-as.data.frame(t(VP_OpenHabitats$vals))
V_OpenHabitats$species <- rownames(V_OpenHabitats) 
mean(V_OpenHabitats$`Climatic Effects`) # 0.7109677
mean(V_OpenHabitats$`Random: ID`) # 0.2890323


write.table(V_OpenHabitats, file="Tables/OpenHabitats_Variance.txt")




VP_TropicalForests<-computeVariancePartitioning(m_TropicalForests,group=c(1,1,1,1,1,1,1,1,1),groupnames = c("Climatic Effects"))
V_TropicalForests<-as.data.frame(t(VP_TropicalForests$vals))
V_TropicalForests$species <- rownames(V_TropicalForests)
mean(V_TropicalForests$`Climatic Effects`) #  0.6987139
mean(V_TropicalForests$`Random: ID`) # 0.3012861

write.table(V_TropicalForests, file="Tables/TropicalForests_Variance.txt")

VP_total<-computeVariancePartitioning(m_total,group=c(1,1,1,1,1,1,1,1,1),groupnames = c("Climatic Effects"))
V_total<-as.data.frame(t(VP_total$vals))
V_total$species <- rownames(V_total)
mean(V_total$`Climatic Effects`) #  0.6372123
mean(V_total$`Random: ID`) # 0.3627877
write.table(V_total, file="Tables/Total_Variance.txt")


# Then plot the proportion attributable to the random effect for each species in the model as a boxplot

both_variance = rbind(V_OpenHabitats, V_TropicalForests)

both_variance$model <- c(rep("Open Habitats", 57),rep("Tropical Forests", 30))

ggplot(both_variance, aes(x = model , y = `Random: ID`)) +
  stat_boxplot(geom = "errorbar",
               width = 0.1) + 
  geom_boxplot(width = 0.5, alpha = 0.5) +
  geom_jitter(alpha = 0.8) +
  theme_bw(base_size = 14) +
  ylab("Proportion of variance explained") +
  xlab("") +
  ylim(0,1) +
  theme(text = element_text(size=20))
