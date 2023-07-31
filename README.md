**Climatic Variables Alone do not Determine Ungulate Community Composition in the Afrotropics**

Authors: Alex Cranston, Natalie Cooper, Jakob Bro-Jorgensen

This repository contains all code and data related to the paper "Climatic Variables Alone do not Determine Ungulate Community Composition in the Afrotropics" analysing the assembly of ungulate communities in sub-Saharan Africa using joint species distribution modelling.

To cite this paper: 

**Data Processing**

 **Analyses**

The main body of analyses are carried out using the HMSC pipeline in /HMSC Pipeline. These scripts have had minor modifications to fit this project but otherwise entirely use the original pipeline provide by HMSC authors, available [here](https://www.helsinki.fi/en/researchgroups/statistical-ecology/software/hmsc)

This pipeline uses the three files of processed data located in /Data but more broadly requires presence/absence or abundance data for any numbers of species over any number of sample sites, with environmental data for all sites also required to act as independent variables in the model. Presence/absence and count data does not need to be complete for all species in all sites but environmental data (or any other data used as an independent variable) does need to be complete.
