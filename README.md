## Climatic Variables Alone do not Determine Ungulate Community Composition in the Afrotropics

Authors: Alex Cranston, Natalie Cooper, Jakob Bro-Jorgensen

This repository contains all code, data and fitted models related to the paper "Climatic Variables Alone do not Determine Ungulate Community Composition in the Afrotropics" analysing the assembly of ungulate communities in sub-Saharan Africa using joint species distribution modelling.

To cite this paper: TBC

To cite this repo: TBC

### Data Processing

All code for data processing can be found in /Raw Data processing in the script IUCN Script_Protected Areas Only.R. This script takes spatial data on species distributions downloaded from the IUCN red list and converts it to a presence/absence matrix for all species downloaded, then crops this matrix to the area of interest for each model. Additionally, it extracts environmental data from a series of rasters covering a wide range of environmental variables for each point in the matrix. All raw data (rasters used as a source of environmental datas well as the IUCN spatial data download) are also found in /Raw Data processing. Note this file also contains spatial polygons of which are used in some plots.

The output of processing are contained in /Data. Note that there are three files of processed data and three models coded for in the pipeline but in order to avoid unnecessary repetition and focus on the most interesting findings, only the second and third biome specific models are discussed in the paper.

### Analyses

The main body of analyses are carried out using the HMSC pipeline in /HMSC Pipeline. These scripts have had minor modifications to fit this project but otherwise entirely use the original pipeline provide by HMSC authors, available [here](https://www.helsinki.fi/en/researchgroups/statistical-ecology/software/hmsc).

This pipeline uses the three files of processed data located in /Data (Presab_plus_climate_variables_PROTECTEDAREASONLY_Res10arcminutes.csv) but more broadly requires presence/absence or abundance data for any numbers of species over any number of sample sites, with environmental data for all sites also required to act as independent variables in the model. Presence/absence and count data does not need to be complete for all species in all sites but environmental data (or any other data used as an independent variable) does need to be complete.

The pipeline is divided into 7 scripts, the role of which are listed below:
1. **S1_define_models_template_africa_PAsonly_FINALRUN.R** (Creates the unfitted HMSC models)
2. **S2_fit_models_africa_PAsonly_FINALRUN.R** (Fits the unfitted models defined in S1 to the data using MCMC)
3. **S3_evaluate_convergence_africa_PAsonly_FINALRUN.R** (Evaluates whether the MCMC algorithm has achieved convergence for each model)
4. **S4_compute_model_fit_africa_PAsonly_FINALRUN.R** (Calculates explanatory and predictive power for each model and calculates WAIC).
5. **S5_show_model_fit_africa_PAsonly_FINALRUN.R** (Outputs plots displaying explanatory and predictive power for each species in each model).
6. **S6_show_parameter_estimates_africa_PAsonly_FINALRUN.R** (Outputs plots displaying key parameters from the fitted model, including the covariance matrix for residual association between species in each model)
7. **S7_make_predictions_africa_PAsonly_FINALRUN.R** (Calculates and outputs plots showing the predicted species richness and probability of presence for focal species over a gradient of all fixed effects in the model)

Code for the Trait dissimilarity analysis can be found in /Additional Scripts, named **Gower Distance.R**. 

### Code for Figures

Code for all figures can be found in /Additional Scripts. 

**Kriging Script_OpenHabitats.R** contains code for the Figure 4. This figure plots the site loadings values of the first (upper) and second latent variable from the Open Habitats model, interpolated across the Afrotropics using kriging interpolation. 

**Kriging Script_TropicalForests.R** contains code for the Figure 5. This figure plots the site loadings values in the same manner as the previous Figure, except from the Tropical Forests model.

Lastly, **All Graphs_exceptKriging.R** contains code for the correlation matrix plots (Figure 2), and the boxplots showing explained variance in both models attributable to the latent variables (Figure 1). It also contains code for the raw (not interpolated) site loadings plot found in the supplementary materials. It also contains code calculating the fit of both models using Tjur R2 and assessing the relationship between species occupancy and explanatory power.

### Other

/Graphs contains all figures used in the paper.

/Models contains all fitted and unfitted models used in the paper.

/results contains result of analysis of MCMC convergence as well as plots showing explanatory and predictive power for all species in each model

/Traits contains the trait data (**Trait Data_AllUngulates.csv**) used to calculate Gower's Distance between species.

## Session Info

Please see below for the output of devtools::session_info() used to perform the analyses for this paper.

```
- Session info ---------------------------------------------------------------------------------------------------------------------------------------
 setting  value
 version  R version 4.1.1 (2021-08-10)
 os       Windows 10 x64 (build 22621)
 system   x86_64, mingw32
 ui       RStudio
 language (EN)
 collate  English_United Kingdom.1252
 ctype    English_United Kingdom.1252
 tz       Europe/London
 date     2023-08-02
 rstudio  2021.09.0+351 Ghost Orchid (desktop)
 pandoc   NA

- Packages -------------------------------------------------------------------------------------------------------------------------------------------
 package           * version    date (UTC) lib source
 abind               1.4-5      2016-07-21 [1] CRAN (R 4.1.1)
 ade4                1.7-22     2023-02-06 [1] CRAN (R 4.1.3)
 ape               * 5.5        2021-04-25 [1] CRAN (R 4.1.2)
 assertthat          0.2.1      2019-03-21 [1] CRAN (R 4.1.2)
 automap           * 1.1-9      2023-03-23 [1] CRAN (R 4.1.3)
 backports           1.3.0      2021-10-27 [1] CRAN (R 4.1.1)
 BayesLogit          2.1        2019-09-26 [1] CRAN (R 4.1.1)
 bitops              1.0-7      2021-04-24 [1] CRAN (R 4.1.1)
 broom               0.7.10     2021-10-31 [1] CRAN (R 4.1.1)
 cachem              1.0.7      2023-02-24 [1] CRAN (R 4.1.3)
 callr               3.7.0      2021-04-20 [1] CRAN (R 4.1.2)
 caret               6.0-90     2021-10-09 [1] CRAN (R 4.1.2)
 castor              1.7.8      2023-03-01 [1] CRAN (R 4.1.3)
 caTools             1.18.2     2021-03-28 [1] CRAN (R 4.1.3)
 cellranger          1.1.0      2016-07-27 [1] CRAN (R 4.1.2)
 Claddis             0.6.3      2020-09-26 [1] CRAN (R 4.1.3)
 class               7.3-19     2021-05-03 [2] CRAN (R 4.1.1)
 classInt            0.4-3      2020-04-07 [1] CRAN (R 4.1.1)
 cli                 3.1.0      2021-10-27 [1] CRAN (R 4.1.1)
 clipr               0.8.0      2022-02-22 [1] CRAN (R 4.1.3)
 cluster             2.1.2      2021-04-17 [2] CRAN (R 4.1.1)
 clusterGeneration   1.3.7      2020-12-15 [1] CRAN (R 4.1.3)
 coda              * 0.19-4     2020-09-30 [1] CRAN (R 4.1.2)
 codetools           0.2-18     2020-11-04 [2] CRAN (R 4.1.1)
 colorspace        * 2.0-2      2021-06-24 [1] CRAN (R 4.1.1)
 combinat            0.0-8      2012-10-29 [1] CRAN (R 4.1.1)
 conquer             1.2.1      2021-11-01 [1] CRAN (R 4.1.2)
 corrplot          * 0.92       2021-11-18 [1] CRAN (R 4.1.2)
 crayon              1.4.2      2021-10-29 [1] CRAN (R 4.1.1)
 data.table          1.14.2     2021-09-27 [1] CRAN (R 4.1.2)
 DBI                 1.1.3      2022-06-18 [1] CRAN (R 4.1.3)
 dbplyr              2.1.1      2021-04-06 [1] CRAN (R 4.1.2)
 dendextend        * 1.16.0     2022-07-04 [1] CRAN (R 4.1.3)
 desc                1.4.0      2021-09-28 [1] CRAN (R 4.1.2)
 devtools            2.4.3      2021-11-30 [1] CRAN (R 4.1.2)
 digest              0.6.28     2021-09-23 [1] CRAN (R 4.1.1)
 dispRity          * 1.7.0      2022-08-09 [1] CRAN (R 4.1.3)
 doParallel          1.0.17     2022-02-07 [1] CRAN (R 4.1.3)
 dotCall64         * 1.0-1      2021-02-11 [1] CRAN (R 4.1.1)
 dplyr             * 1.0.7      2021-06-18 [1] CRAN (R 4.1.2)
 e1071               1.7-9      2021-09-16 [1] CRAN (R 4.1.1)
 ellipse             0.4.4      2023-03-29 [1] CRAN (R 4.1.3)
 ellipsis            0.3.2      2021-04-29 [1] CRAN (R 4.1.1)
 expm                0.999-7    2023-01-09 [1] CRAN (R 4.1.3)
 fansi               0.5.0      2021-05-25 [1] CRAN (R 4.1.1)
 fastmap             1.1.1      2023-02-24 [1] CRAN (R 4.1.3)
 fastmatch           1.1-3      2021-07-23 [1] CRAN (R 4.1.1)
 fields            * 13.3       2021-10-30 [1] CRAN (R 4.1.1)
 FNN                 1.1.3      2019-02-15 [1] CRAN (R 4.1.2)
 forcats           * 0.5.1      2021-01-27 [1] CRAN (R 4.1.2)
 foreach             1.5.2      2022-02-02 [1] CRAN (R 4.1.3)
 foreign             0.8-81     2020-12-22 [2] CRAN (R 4.1.1)
 fs                  1.5.0      2020-07-31 [1] CRAN (R 4.1.2)
 future              1.23.0     2021-10-31 [1] CRAN (R 4.1.2)
 future.apply        1.8.1      2021-08-10 [1] CRAN (R 4.1.2)
 generics            0.1.3      2022-07-05 [1] CRAN (R 4.1.3)
 geometry            0.4.7      2023-02-03 [1] CRAN (R 4.1.3)
 geoscale            2.0.1      2022-06-24 [1] CRAN (R 4.1.3)
 geosphere           1.5-14     2021-10-13 [1] CRAN (R 4.1.1)
 ggmap               3.0.2      2023-03-14 [1] CRAN (R 4.1.3)
 ggplot2           * 3.3.5      2021-06-25 [1] CRAN (R 4.1.2)
 ggsn              * 0.5.0      2019-02-18 [1] CRAN (R 4.1.3)
 globals             0.14.0     2020-11-22 [1] CRAN (R 4.1.1)
 glue                1.4.2      2020-08-27 [1] CRAN (R 4.1.1)
 gower             * 1.0.1      2022-12-22 [1] CRAN (R 4.1.3)
 gplots            * 3.1.3      2022-04-25 [1] CRAN (R 4.1.3)
 gridExtra           2.3        2017-09-09 [1] CRAN (R 4.1.1)
 gstat               2.1-1      2023-04-06 [1] CRAN (R 4.1.3)
 gtable              0.3.3      2023-03-21 [1] CRAN (R 4.1.3)
 gtools              3.9.3      2022-07-11 [1] CRAN (R 4.1.3)
 haven               2.4.3      2021-08-04 [1] CRAN (R 4.1.2)
 hms                 1.1.1      2021-09-26 [1] CRAN (R 4.1.1)
 Hmsc              * 3.0-13     2022-08-11 [1] CRAN (R 4.1.3)
 httr                1.4.2      2020-07-20 [1] CRAN (R 4.1.1)
 igraph              1.4.1      2023-02-24 [1] CRAN (R 4.1.3)
 intervals           0.15.3     2023-03-20 [1] CRAN (R 4.1.3)
 ipred               0.9-12     2021-09-15 [1] CRAN (R 4.1.2)
 iterators           1.0.14     2022-02-05 [1] CRAN (R 4.1.3)
 jpeg                0.1-9      2021-07-24 [1] CRAN (R 4.1.1)
 jsonlite            1.8.4      2022-12-06 [1] CRAN (R 4.1.3)
 KernSmooth          2.23-20    2021-05-03 [2] CRAN (R 4.1.1)
 knitr             * 1.42       2023-01-25 [1] CRAN (R 4.1.3)
 lattice             0.20-44    2021-05-02 [2] CRAN (R 4.1.1)
 lava                1.6.10     2021-09-02 [1] CRAN (R 4.1.2)
 letsR             * 4.0        2020-10-26 [1] CRAN (R 4.1.2)
 lifecycle           1.0.3      2022-10-07 [1] CRAN (R 4.1.3)
 listenv             0.8.0      2019-12-05 [1] CRAN (R 4.1.2)
 lubridate           1.8.0      2021-10-07 [1] CRAN (R 4.1.1)
 lwgeom              0.2-11     2023-01-14 [1] CRAN (R 4.1.3)
 magic               1.6-1      2022-11-16 [1] CRAN (R 4.1.3)
 magrittr            2.0.1      2020-11-17 [1] CRAN (R 4.1.1)
 maps              * 3.4.1      2022-10-30 [1] CRAN (R 4.1.3)
 maptools            1.1-6      2022-12-14 [1] CRAN (R 4.1.3)
 MASS                7.3-54     2021-05-03 [2] CRAN (R 4.1.1)
 Matrix              1.3-4      2021-06-01 [2] CRAN (R 4.1.1)
 MatrixModels        0.5-0      2021-03-02 [1] CRAN (R 4.1.2)
 matrixStats         0.61.0     2021-09-17 [1] CRAN (R 4.1.2)
 mcmc                0.9-7      2020-03-21 [1] CRAN (R 4.1.2)
 MCMCpack            1.6-0      2021-10-06 [1] CRAN (R 4.1.2)
 memoise             2.0.1      2021-11-26 [1] CRAN (R 4.1.2)
 mgcv                1.8-36     2021-06-01 [2] CRAN (R 4.1.1)
 mnormt              2.1.1      2022-09-26 [1] CRAN (R 4.1.3)
 ModelMetrics        1.2.2.2    2020-03-17 [1] CRAN (R 4.1.2)
 modelr              0.1.8      2020-05-19 [1] CRAN (R 4.1.2)
 munsell             0.5.0      2018-06-12 [1] CRAN (R 4.1.1)
 naturalsort         0.1.3      2016-08-30 [1] CRAN (R 4.1.3)
 nlme                3.1-152    2021-02-04 [2] CRAN (R 4.1.1)
 nnet                7.3-16     2021-05-03 [2] CRAN (R 4.1.1)
 numDeriv            2016.8-1.1 2019-06-06 [1] CRAN (R 4.1.1)
 optimParallel       1.0-2      2021-02-11 [1] CRAN (R 4.1.3)
 parallelly          1.29.0     2021-11-21 [1] CRAN (R 4.1.1)
 patchwork         * 1.1.1      2020-12-17 [1] CRAN (R 4.1.2)
 pbapply             1.7-0      2023-01-13 [1] CRAN (R 4.1.3)
 permute             0.9-7      2022-01-27 [1] CRAN (R 4.1.3)
 phangorn            2.11.1     2023-01-23 [1] CRAN (R 4.1.3)
 phyclust            0.1-33     2023-01-22 [1] CRAN (R 4.1.3)
 phytools            1.5-1      2023-02-19 [1] CRAN (R 4.1.3)
 pillar              1.9.0      2023-03-22 [1] CRAN (R 4.1.3)
 pkgbuild            1.2.1      2021-11-30 [1] CRAN (R 4.1.2)
 pkgconfig           2.0.3      2019-09-22 [1] CRAN (R 4.1.1)
 pkgload             1.2.3      2021-10-13 [1] CRAN (R 4.1.2)
 plotrix             3.8-2      2021-09-08 [1] CRAN (R 4.1.1)
 plyr                1.8.6      2020-03-03 [1] CRAN (R 4.1.1)
 png                 0.1-7      2013-12-03 [1] CRAN (R 4.1.1)
 pracma              2.3.3      2021-01-23 [1] CRAN (R 4.1.2)
 prettyunits         1.1.1      2020-01-24 [1] CRAN (R 4.1.1)
 pROC                1.18.0     2021-09-03 [1] CRAN (R 4.1.2)
 processx            3.5.2      2021-04-30 [1] CRAN (R 4.1.2)
 prodlim             2019.11.13 2019-11-17 [1] CRAN (R 4.1.2)
 proxy               0.4-26     2021-06-07 [1] CRAN (R 4.1.1)
 ps                  1.6.0      2021-02-28 [1] CRAN (R 4.1.2)
 purrr             * 0.3.4      2020-04-17 [1] CRAN (R 4.1.1)
 quadprog            1.5-8      2019-11-20 [1] CRAN (R 4.1.1)
 quantreg            5.86       2021-06-06 [1] CRAN (R 4.1.2)
 R6                  2.5.1      2021-08-19 [1] CRAN (R 4.1.1)
 raster            * 3.5-2      2021-10-11 [1] CRAN (R 4.1.1)
 Rcpp                1.0.7      2021-07-07 [1] CRAN (R 4.1.1)
 readr             * 2.0.2      2021-09-27 [1] CRAN (R 4.1.1)
 readxl              1.3.1      2019-03-13 [1] CRAN (R 4.1.2)
 recipes             0.1.17     2021-09-27 [1] CRAN (R 4.1.2)
 remotes             2.4.2      2021-11-30 [1] CRAN (R 4.1.2)
 reprex              2.0.1      2021-08-05 [1] CRAN (R 4.1.2)
 reshape             0.8.8      2018-10-23 [1] CRAN (R 4.1.2)
 reshape2          * 1.4.4      2020-04-09 [1] CRAN (R 4.1.2)
 rgdal             * 1.5-27     2021-09-16 [1] CRAN (R 4.1.1)
 rgeos               0.5-8      2021-09-22 [1] CRAN (R 4.1.1)
 RgoogleMaps         1.4.5.3    2020-02-12 [1] CRAN (R 4.1.1)
 rlang               1.1.0      2023-03-14 [1] CRAN (R 4.1.3)
 rpart               4.1-15     2019-04-12 [2] CRAN (R 4.1.1)
 rprojroot           2.0.2      2020-11-15 [1] CRAN (R 4.1.2)
 RSpectra            0.16-1     2022-04-24 [1] CRAN (R 4.1.3)
 rstudioapi          0.13       2020-11-12 [1] CRAN (R 4.1.2)
 rvest               1.0.2      2021-10-16 [1] CRAN (R 4.1.2)
 scales              1.2.1      2022-08-20 [1] CRAN (R 4.1.3)
 scatterplot3d       0.3-43     2023-03-14 [1] CRAN (R 4.1.3)
 sessioninfo         1.2.2      2021-12-06 [1] CRAN (R 4.1.2)
 sf                * 1.0-12     2023-03-19 [1] CRAN (R 4.1.3)
 sm                * 2.2-5.7.1  2022-07-04 [1] CRAN (R 4.1.3)
 sp                * 1.4-5      2021-01-10 [1] CRAN (R 4.1.1)
 spacetime           1.3-0      2023-04-05 [1] CRAN (R 4.1.3)
 spam              * 2.7-0      2021-06-25 [1] CRAN (R 4.1.1)
 SparseM             1.81       2021-02-18 [1] CRAN (R 4.1.1)
 spThin            * 0.2.0      2019-11-15 [1] CRAN (R 4.1.2)
 stars               0.6-1      2023-04-06 [1] CRAN (R 4.1.3)
 statmod             1.4.36     2021-05-10 [1] CRAN (R 4.1.2)
 strap               1.6-0      2022-06-13 [1] CRAN (R 4.1.3)
 stringi             1.7.5      2021-10-04 [1] CRAN (R 4.1.1)
 stringr           * 1.4.0      2019-02-10 [1] CRAN (R 4.1.1)
 survival            3.2-11     2021-04-26 [2] CRAN (R 4.1.1)
 terra               1.4-11     2021-10-11 [1] CRAN (R 4.1.1)
 testthat            3.1.0      2021-10-04 [1] CRAN (R 4.1.2)
 tibble            * 3.1.5      2021-09-30 [1] CRAN (R 4.1.1)
 tidyr             * 1.1.4      2021-09-27 [1] CRAN (R 4.1.1)
 tidyselect          1.1.1      2021-04-30 [1] CRAN (R 4.1.2)
 tidyverse         * 1.3.1      2021-04-15 [1] CRAN (R 4.1.2)
 timeDate            3043.102   2018-02-21 [1] CRAN (R 4.1.1)
 truncnorm           1.0-8      2018-02-27 [1] CRAN (R 4.1.2)
 tzdb                0.2.0      2021-10-27 [1] CRAN (R 4.1.1)
 units               0.7-2      2021-06-08 [1] CRAN (R 4.1.1)
 usethis             2.1.5      2021-12-09 [1] CRAN (R 4.1.2)
 utf8                1.2.2      2021-07-24 [1] CRAN (R 4.1.1)
 vctrs               0.6.1      2023-03-22 [1] CRAN (R 4.1.3)
 vegan               2.6-4      2022-10-11 [1] CRAN (R 4.1.3)
 vioplot           * 0.3.7      2021-07-27 [1] CRAN (R 4.1.3)
 viridis           * 0.6.2      2021-10-13 [1] CRAN (R 4.1.1)
 viridisLite       * 0.4.1      2022-08-22 [1] CRAN (R 4.1.3)
 withr               2.5.0      2022-03-03 [1] CRAN (R 4.1.3)
 writexl           * 1.4.0      2021-04-20 [1] CRAN (R 4.1.3)
 xfun                0.38       2023-03-24 [1] CRAN (R 4.1.3)
 XML                 3.99-0.8   2021-09-17 [1] CRAN (R 4.1.1)
 xml2                1.3.2      2020-04-23 [1] CRAN (R 4.1.1)
 xts                 0.13.1     2023-04-16 [1] CRAN (R 4.1.1)
 zoo               * 1.8-9      2021-03-09 [1] CRAN (R 4.1.2)
------------------------------------------------------------------------------------------------------------------------------------------------------
```
