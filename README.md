**Climatic Variables Alone do not Determine Ungulate Community Composition in the Afrotropics**

Authors: Alex Cranston, Natalie Cooper, Jakob Bro-Jorgensen

This repository contains all code and data related to the paper "Climatic Variables Alone do not Determine Ungulate Community Composition in the Afrotropics" analysing the assembly of ungulate communities in sub-Saharan Africa using joint species distribution modelling.

To cite this paper: 

**Data Processing**

All code for data processing can be found in /Raw Data processing in the script IUCN Script_Protected Areas Only.R. This script takes spatial data on species distributions downloaded from the IUCN red list and converts it to a presence/absence matrix for all species downloaded, then crops this matrix to the area of interest for each model. Additionally, it extracts environmental data from a series of rasters covering a wide range of environmental variables for each point in the matrix. All raw data (rasters used as a source of environmental datas well as the IUCN spatial data download) are also found in /Raw Data processing.

The output of processing are contained in /Data. Note that there are three files of processed data and three models coded for in the pipeline but in order to avoid unnecessary repetition and focus on the most interesting findings, only the biome specific models are discussed in the paper.

 **Analyses**

The main body of analyses are carried out using the HMSC pipeline in /HMSC Pipeline. These scripts have had minor modifications to fit this project but otherwise entirely use the original pipeline provide by HMSC authors, available [here](https://www.helsinki.fi/en/researchgroups/statistical-ecology/software/hmsc)

This pipeline uses the three files of processed data located in /Data (Presab_plus_climate_variables_PROTECTEDAREASONLY_Res10arcminutes.csv) but more broadly requires presence/absence or abundance data for any numbers of species over any number of sample sites, with environmental data for all sites also required to act as independent variables in the model. Presence/absence and count data does not need to be complete for all species in all sites but environmental data (or any other data used as an independent variable) does need to be complete.

The pipeline is divided into 8 scripts, the role of which are listed below:
1. S1_define_models_template_africa_PAsonly_FINALRUN.R (Creates the unfitted HMSC models)
2. S2_fit_models_africa_PAsonly_FINALRUN.R (Fits the unfitted models defined in S1 to the data using MCMC)
3. S3_evaluate_convergence_africa_PAsonly_FINALRUN.R (Evaluates whether the MCMC algorithm has achieved convergence for each model)
4. S4_compute_model_fit_africa_PAsonly_FINALRUN.R (Calculates explanatory and predictive power for each model and calculates WAIC).
5. S5_show_model_fit_africa_PAsonly_FINALRUN.R (Outputs plots displaying explanatory and predictive power for each species in each model).
6. S6_show_parameter_estimates_africa_PAsonly_FINALRUN.R (Outputs plots displaying key parameters from the fitted model, including the covariance matrix for residual association between species in each model)
7. S7_make_predictions_africa_PAsonly_FINALRUN.R (Calculates and outputs plots showing the predicted species richness and probability of presence for focal species over a gradient of all fixed effects in the model)
8. S8_make_furtherpredictions_africa_PAsonly_FINALRUN.R (Shows further key parameters from the fitted model, including plotting the eta values from the latent variables spatially) 

