

##################################################################################################
# INPUT AND OUTPUT OF THIS SCRIPT (BEGINNING)
##################################################################################################
#	INPUT. Original datafiles of the case study, placed in the data folder.

#	OUTPUT. Unfitted models, i.e., the list of Hmsc model(s) that have been defined
# but not fitted yet, stored in the file "models/unfitted_models.RData".
##################################################################################################
# INPUT AND OUTPUT OF THIS SCRIPT (END)
##################################################################################################


##################################################################################################
# MAKE THE SCRIPT REPRODUCIBLE (BEGINNING)
##################################################################################################
set.seed(1)
##################################################################################################
## MAKE THE SCRIPT REPRODUCIBLE (END)
##################################################################################################


##################################################################################################
# LOAD PACKAGES (BEGINNING)
##################################################################################################
library(Hmsc)
library(tidyverse)
##################################################################################################
# LOAD PACKAGES (END)
##################################################################################################


##################################################################################################
# SET DIRECTORIES (BEGINNING)
##################################################################################################
localDir = "."
dataDir = file.path(localDir, "Data")
modelDir = file.path(localDir, "models")
if(!dir.exists(modelDir)) dir.create(modelDir)
##################################################################################################
# SET DIRECTORIES (END)
##################################################################################################


##################################################################################################
# READ AND EXPLORE THE DATA (BEGINNING)
##################################################################################################

da.10m<-read.csv("Data/Presab_plus_climate_variables_PROTECTEDAREASONLY_Res10arcminutes.csv")
da.10m$Land.Cover<-as.factor(da.10m$Land.Cover)
da.10m <- da.10m %>% filter(Land.Cover != c("No Data")) # omit values where land cover is not recorded
da.10m <- da.10m %>% filter(Land.Cover != c("Artificial Surfaces")) # omit values where land cover is recorded as artificial surface
da.10m <- da.10m %>% filter(Land.Cover != c("Waterbodies")) # omit values where land cover is recorded as Snow or Glacier
da.10m <- da.10m %>% filter(Land.Cover != c("CropLand")) # omit values where land cover is recorded as Cropland
da.10m <- da.10m[sample(nrow(da.10m),300), ] # Take a random sample of the raw data set

da.OpenHabitats<-read.csv("Data/Presab_plus_climate_variables_PROTECTEDAREASONLY_Res10arcminutes_OpenHabitats.csv")
da.OpenHabitats$Land.Cover<-as.factor(da.OpenHabitats$Land.Cover)
da.OpenHabitats <- da.OpenHabitats %>% filter(Land.Cover != c("No Data")) # omit values where land cover is not recorded
da.OpenHabitats <- da.OpenHabitats %>% filter(Land.Cover != c("Artificial Surfaces")) # omit values where land cover is recorded as artificial surface
da.OpenHabitats <- da.OpenHabitats %>% filter(Land.Cover != c("Waterbodies")) # omit values where land cover is recorded as Snow or Glacier
da.OpenHabitats <- da.OpenHabitats %>% filter(Land.Cover != c("CropLand")) # omit values where land cover is recorded as Cropland
da.OpenHabitats <- da.OpenHabitats[sample(nrow(da.OpenHabitats),300), ] # Take a random sample of the raw data set


da.TropicalForests<-read.csv("Data/Presab_plus_climate_variables_PROTECTEDAREASONLY_Res10arcminutes_TropicalForests.csv")
da.TropicalForests$Land.Cover<-as.factor(da.TropicalForests$Land.Cover)
da.TropicalForests <- da.TropicalForests %>% filter(Land.Cover != c("Waterbodies")) # omit values where land cover is recorded as Snow or Glacier
da.TropicalForests <- da.TropicalForests %>% filter(Land.Cover != c("CropLand")) # omit values where land cover is recorded as Cropland
da.TropicalForests <- da.TropicalForests[sample(nrow(da.TropicalForests),300), ] # Take a random sample of the raw data set



##################################################################################################
# READ AND EXPLORE THE DATA (END)
##################################################################################################

ggplot(data = da.10m, aes(x=Longitude.x., y=Latitude.y., color=Land.Cover))+geom_point(size=1.5) +  ggtitle("Land Cover")+ theme(legend.position="bottom")+labs(y="") + scale_colour_manual(values = c("brown","chartreuse4","chartreuse", "darkmagenta","chocolate4","brown1","darkgreen")) # Here we plot Land Cover to make sure it has come out correctly

ggplot(data = da.OpenHabitats, aes(x=Longitude.x., y=Latitude.y., color=Land.Cover))+geom_point(size=1.5) +  ggtitle("Land Cover")+ theme(legend.position="bottom")+labs(y="") + scale_colour_manual(values = c("brown","chartreuse4","chartreuse", "darkmagenta","chocolate4","brown1","darkgreen")) # Here we plot Land Cover to make sure it has come out correctly


ggplot(data = da.TropicalForests, aes(x=Longitude.x., y=Latitude.y., color=Land.Cover))+geom_point(size=1.5) +  ggtitle("Land Cover")+ theme(legend.position="bottom")+labs(y="") + scale_colour_manual(values = c("chartreuse4","darkmagenta","chocolate4","darkgreen")) # Here we plot Land Cover to make sure it has come out correctly



##################################################################################################
# SET UP THE MODEL (BEGINNING)
##################################################################################################
# Note that many of the components are optional 
# Here instructions are given at generic level, the details will depend on the model

# Organize the community data in the matrix Y

Y.10m=data.frame(da.10m %>% select(3:95)) # Select dependent variables, i.e. presence absence data for 93 species

Y.10m <- Y.10m %>% select_if((colMeans(Y.10m)>=0.025)) # select only columns with average greater than 0.1, i.e. exclude species with very small distributions
Y.10m <- Y.10m %>% select(-c("Diceros.bicornis","Ceratotherium.simum")) # Exclude rhinos species - presence or absence is done by country for these species and therefore do not reflect the true distribution



Y.OpenHabitats=data.frame(da.OpenHabitats %>% select(3:90)) # Select dependent variables, i.e. presence absence data for 88 species

Y.OpenHabitats <- Y.OpenHabitats %>% select_if((colMeans(Y.OpenHabitats)>=0.025)) # select only columns with average greater than 0.1, i.e. exclude species with very small distributions
Y.OpenHabitats <- Y.OpenHabitats %>% select(-c("Diceros.bicornis","Ceratotherium.simum")) # Exclude rhinos species - presence or absence is done by country for these species and therefore do not reflect the true distribution


Y.TropicalForests=data.frame(da.TropicalForests %>% select(3:69)) # Select dependent variables, i.e. presence absence data for 67 species

Y.TropicalForests <- Y.TropicalForests %>% select_if((colMeans(Y.TropicalForests)>=0.025)) # select only columns with average greater than 0.1, i.e. exclude species with very small distributions
Y.TropicalForests <- Y.TropicalForests %>% select(-c("Diceros.bicornis")) # Exclude rhinos species - presence or absence is done by country for these species and therefore do not reflect the true distribution
Y.TropicalForests <- Y.TropicalForests %>% select(-c("Giraffa.camelopardalis", "Oreotragus.oreotragus","Alcelaphus.buselaphus",
                                                     "Redunca.fulvorufula", "Kobus.kob", "Redunca.redunca", "Redunca.arundinum",
                                                     "Equus.quagga", "Madoqua.kirkii", "Phacochoerus.africanus",
                                                     "Tragelaphus.strepsiceros", "Aepyceros.melampus","Sylvicapra.grimmia",
                                                     "Kobus.ellipsiprymnus","Tragelaphus.oryx","Loxodonta.africana","Hippotragus.equinus",
                                                     "Nanger.granti","Hippotragus.niger",
                                                     "Ourebia.ourebi","Raphicerus.campestris"))

# Organize the environmental data into a dataframe XData

XData.10m <- data.frame(temp=da.10m$BIO1, hot=da.10m$BIO5,cold=da.10m$BIO6,precip=da.10m$BIO12, mean.diurnal.range=da.10m$BIO2, precip.seasonality=da.10m$BIO15, precip.range=(da.10m$BIO16-da.10m$BIO17)) # Create data set of independent variables - annual precipitation, max temperature, minimum temperature, seasonality
XData.OpenHabitats <- data.frame(temp=da.OpenHabitats$BIO1, hot=da.OpenHabitats$BIO5,cold=da.OpenHabitats$BIO6,precip=da.OpenHabitats$BIO12, mean.diurnal.range=da.OpenHabitats$BIO2, precip.seasonality=da.OpenHabitats$BIO15, precip.range=(da.OpenHabitats$BIO16-da.OpenHabitats$BIO17)) # Create data set of independent variables - annual precipitation, max temperature, minimum temperature, seasonality
XData.TropicalForests <- data.frame(temp=da.TropicalForests$BIO1, hot=da.TropicalForests$BIO5,cold=da.TropicalForests$BIO6,precip=da.TropicalForests$BIO12, mean.diurnal.range=da.TropicalForests$BIO2, precip.seasonality=da.TropicalForests$BIO15, precip.range=(da.TropicalForests$BIO16-da.TropicalForests$BIO17)) # Create data set of independent variables - annual precipitation, max temperature, minimum temperature, seasonality

# Check for multicollinearity - Precip Range has high VIF so exclude and rerun
library(car)
corr.check.Tropical.Forest<-lm(hot~temp+precip + mean.diurnal.range+precip.seasonality, data = XData.TropicalForests)
vif(corr.check.Tropical.Forest) #1.184031           1.160098           1.097232           1.052262
corr.check.OpenHabitats<-lm(hot~temp+precip + mean.diurnal.range+precip.seasonality, data = XData.OpenHabitats)
vif(corr.check.OpenHabitats ) #1.305686           1.351249           1.164116           1.11318



# Define the environmental model through XFormula

XFormula = ~poly(temp,degree = 2,raw = TRUE) + poly(precip,degree = 2,raw = TRUE) + poly(mean.diurnal.range, degree = 2, raw= TRUE) + poly(precip.seasonality, degree=2, raw=TRUE)


# Organize the trait data into a dataframe TrData
# Define the trait model through TrFormula
# TrFormula = ~ ..

# Set up a phylogenetic (or taxonomic tree) as myTree

# Define the studyDesign as a dataframe 

studyDesign.10m = data.frame(ID = as.factor(1:300))
studyDesign.OpenHabitats = data.frame(ID = as.factor(1:300))
studyDesign.TropicalForests = data.frame(ID = as.factor(1:300))


# For example, if you have sampled the same locations over multiple years, you may define
# studyDesign = data.frame(sample = ..., year = ..., location = ...)

# Set up the random effects

xy.10m = as.matrix(cbind(da.10m$Longitude.x.,da.10m$Latitude.y.))
rownames(xy.10m)=studyDesign.10m[,1]
rL.10m = HmscRandomLevel(sData = xy.10m) 


xy.OpenHabitats = as.matrix(cbind(da.OpenHabitats$Longitude.x.,da.OpenHabitats$Latitude.y.))
rownames(xy.OpenHabitats)=studyDesign.OpenHabitats[,1]
rL.OpenHabitats = HmscRandomLevel(sData = xy.OpenHabitats) 


xy.TropicalForests = as.matrix(cbind(da.TropicalForests$Longitude.x.,da.TropicalForests$Latitude.y.))
rownames(xy.TropicalForests)=studyDesign.TropicalForests[,1]
rL.TropicalForests = HmscRandomLevel(sData = xy.TropicalForests) 

# For example, you may define year as an unstructured random effect
# rL.year = HmscRandomLevel(units = levels(studyDesign$year))
# For another example, you may define location as a spatial random effect
# rL.location = HmscRandomLevel(sData = locations.xy)
# Here locations.xy would be a matrix (one row per unique location)
# where row names are the levels of studyDesign$location,
# and the columns are the xy-coordinates
# For another example, you may define the sample = sampling unit = row of matrix Y
# as a random effect, in case you are interested in co-occurrences at that level
# rL.sample = HmscRandomLevel(units = levels(studyDesign$sample))




# Use the Hmsc model constructor to define a model


m.10m = Hmsc(Y=Y.10m,
              distr="probit",
              XData = XData.10m,  XFormula=XFormula,
              studyDesign = studyDesign.10m, 
              ranLevels=list(ID=rL.10m))
m.OpenHabitats = Hmsc(Y=Y.OpenHabitats,
             distr="probit",
             XData = XData.OpenHabitats,  XFormula=XFormula,
             studyDesign = studyDesign.OpenHabitats, 
             ranLevels=list(ID=rL.OpenHabitats))
m.TropicalForests = Hmsc(Y=Y.TropicalForests,
             distr="probit",
             XData = XData.TropicalForests,  XFormula=XFormula,
             studyDesign = studyDesign.TropicalForests, 
             ranLevels=list(ID=rL.TropicalForests))

# note that in the random effects the left-hand sides in the list (year, location, sample)
# refer to the columns of the studyDesign

# In this example we assumed the probit distribution as appropriate for presence-absence data

# It is always a good idea to look at the model object, so type m to the console and press enter
# Look at the components of the model by exploring m$...



# You may define multiple models, e.g.
# alternative covariate selections
# alternative random effect choices
# alternative ways to model the data (e.g. lognormal Poisson versus hurdle model)
# models for different subsets of the data

# m.alternative = Hmsc(....)
##################################################################################################
# SET UP THE MODEL (END)
##################################################################################################


##################################################################################################
# In the general case, we could have multiple models. We combine them into a list and given them names.
# COMBINING AND SAVING MODELS (START)
models = list(m.10m,m.OpenHabitats,m.TropicalForests)
names(models) = c("Model.africa.PAsonly.10arcminutes_normal_FINALRUN","Model.africa.PAsonly.10arcminutes_OpenHabitats_FINALRUN","Model.africa.PAsonly.10arcminutes_TropicalForests_FINALRUN")
save(models, file = file.path(modelDir, "unfitted_models_FINALRUN.RData"))
##################################################################################################
# COMBINING AND SAVING MODELS (END)
##################################################################################################


##################################################################################################
# TESTING THAT MODELS FIT WITHOUT ERRORS (START)
##################################################################################################
for(i in 1:length(models)){
  print(i)
  sampleMcmc(models[[i]],samples=2)
}
##################################################################################################
# TESTING THAT MODELS FIT WITHOUT ERRORS (END)
##################################################################################################