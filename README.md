# zip2zip_dist_miles
This repository contains Stata code and raw data for computing the distance in miles between any pairs of population-weighted centroids of US zip codes. 

The raw data of population-weighted centroids are published by the US Department of Housing and Urban Development. https://hudgis-hud.opendata.arcgis.com/datasets/HUD::zip-code-population-weighted-centroids/explore

As an illustration, there is a sample output file that contains zip codes whose distances are within 10 miles. The variable names of the output file should be self-explanatory.

The full data are more than 38G. To get the full data, comment out line 51 of the Stata code when compiling the data.
