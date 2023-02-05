cd /Users/songyaoh/Documents/Workbench/F3/F3_SIR/build

// ZIP_Code_Population_Weighted_Centroids is populatio-weighted centoid.
// downloaded from 
// https://hudgis-hud.opendata.arcgis.com/datasets/HUD::zip-code-population-weighted-centroids


// prepare zip coordiantes data for cross tabulation
import delimited "./input/ZIP_Code_Population_Weighted_Centroids.csv", clear

keep std_zip5 latitude longitude
rename latitude lat_other
rename longitude lon_other
rename std_zip5 zip5_other

// direct cross results in large matrix (30k by 30K)
// divide file into 100 pieces, the matrix will be 30k by 300
local seg 100
xtile zip5_seg = zip5_other, nq(`seg')
save ./temp/zip5_seg, replace

forval i=1/`seg'{
	use ./temp/zip5_seg, clear
	keep if zip5_seg==`i'
	drop zip5_seg
	save ./temp/zip5_seg`i', replace
}

//cross the main file with each of the 100
forval i=1/`seg'{
	import delimited "./input/ZIP_Code_Population_Weighted_Centroids.csv", clear

	keep std_zip5 latitude longitude
	rename latitude lat_own
	rename longitude lon_own
	rename std_zip5 zip5_own

	cross using ./temp/zip5_seg`i'
	drop if zip5_own==zip5_other

	foreach var in own other{
		gen lat_`var'2 = lat_`var' * 69 /* converts degrees latitude to miles (roughly) */
		gen lon_`var'2 = lon_`var' * 52 /* converts degrees longitude to miles (roughly), 
		NOTE: longitude conversion varies depending on vicinity to poles */
	}

	gen dist_miles = ((lat_own2 - lat_other2)^2 + (lon_own2 - lon_other2)^2)^0.5
	drop lat_*2 lon_*2

	order zip5_other dist_miles, after(zip5_own)
	keep if dist_miles<=100 //only keep those zip5 paris within 100 miles
	
	save ./temp/zip5_dist`i', replace
}

use ./temp/zip5_dist1, clear
forval i=2/`seg'{
	append using ./temp/zip5_dist`i'
}

save ./output/zip2zip_dist_miles100, replace
