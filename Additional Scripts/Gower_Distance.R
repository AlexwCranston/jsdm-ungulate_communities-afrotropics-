library(gower)
library(tidyverse)
library(reshape2)
library(Hmsc)
library(heavy)


raw.data<-read.csv("Traits/Trait Data_AllUngulates.csv")

data<-raw.data %>% select(2,3,4,16,17,18,19,20)
data<-na.omit(data)


load("models/models_thin_100_samples_250_chains_4_FINALRUN.Rdata")


gower<-data
for (i in 1:88) {
  gower[,i]<-gower_dist(data[i,c(2:8)],data[,c(2:8)])
}

rownames(gower)<-data$Binomial
colnames(gower)<-data$Binomial

supportLevel=0.95
postOmega = getPostEstimate(models[[2]], parName ="Omega")
Omega.toPlot = ((postOmega[[2]]> supportLevel) + (postOmega[[2]] < (1-supportLevel)) > 0) * postOmega[[1]]
colnames(Omega.toPlot)<-colnames(models[[2]]$Y)
rownames(Omega.toPlot)<-colnames(Omega.toPlot)


gower <- gower[(names(gower) %in% rownames(Omega.toPlot)) , (names(gower) %in% rownames(Omega.toPlot))]

diag(gower)=NA
diag(Omega.toPlot)=NA
gower[lower.tri(gower)] <- NA
Omega.toPlot[lower.tri(Omega.toPlot)] <- NA



gower.col<-melt(as.matrix(gower))
omega.col<-melt(as.matrix(Omega.toPlot))

colnames(gower.col)<-c("Species 1","Species 2","Gower Distance")
colnames(omega.col)<-c("Species 1","Species 2","Omega")
final.cols<-merge(x = gower.col, y = omega.col, all.x = TRUE)
final.cols<-na.omit(final.cols)
final.cols <- final.cols %>% filter(Omega != 0)


hist(final.cols$Omega)
hist(final.cols$Gower)

plot(final.cols$Gower,final.cols$Omega)

fit <-lm(formula = final.cols$Omega~final.cols$Gower, data = final.cols )


summary(fit)
plot(fit)

