
clear all
set matsize 5000
set more off
	
/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/
/****************  PREPARE DATASET: CBOS dataset respondent level   ******************************/
/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/

***  
quietly { 
	
use "${path}/Data/original_data/cbos_with_1931.dta", clear

cap drop city
cap drop age_sq

gen city=1 if strpos(gmina, "M. ")
replace city=0 if city==.

gen age_sq=age*age

/* generate age6 variable as in Diagnoza */
gen age6 = .
replace age6 = 1 if age<=24
replace age6 = 2 if age>=25 & age<=34
replace age6 = 3 if age>=35 & age<=44
replace age6 = 4 if age>=45 & age<=59
replace age6 = 5 if age>=60 & age<=64
replace age6 = 6 if age>=65 & age<=105

*Impute years of edu from average years corresponding to each degree (as computed in Diagnoza)
gen edu_years = .
replace edu_years = 7 if eduk4==1
replace edu_years = 11 if eduk4==2
replace edu_years = 13 if eduk4==3
replace edu_years = 17 if eduk4==4

gen weight1=waga_pesel 
gen weight2=waga_calosc 

label var weight1 "weight for representative sample"
label var weight2 "weight for both representative and Kresy samples together"


label var eduk4                "Degree, (4 cat.)"
label var secondary_edu        "Complete, secondary"
label var higher_edu           "Higher, education"

label var PL_kresy_origin_mean "Share of Ancestors, Kresy"
label var PL_wt_origin_mean    "Share of Ancestors, WT"
label var rural_origin_mean    "Share of Ancestors, rural"
label var abroad_origin_mean   "Share of Ancestors, abroad"
label var PL_kresy_origin 		"Ancestor from Kresy"


******create birth cohorts 

gen birth_year=D2

gen birth_pre1930=.
replace birth_pre1930=1 if birth_year<1930 
replace birth_pre1930=0 if birth_year>=1930 & birth_year~=.

gen birth_1930s=.
replace birth_1930s=1 if birth_year>=1930 & birth_year< 1940 
replace birth_1930s=0 if birth_year<1930 | (birth_year>=1940& birth_year~=.)

gen birth_1940s=.
replace birth_1940s=1 if birth_year>=1940 & birth_year< 1950 
replace birth_1940s=0 if birth_year<1940 | (birth_year>=1950& birth_year~=.)

gen birth_1950s=.
replace birth_1950s=1 if birth_year>=1950 & birth_year< 1960  
replace birth_1950s=0 if birth_year<1950 | (birth_year>=1960& birth_year~=.)

gen birth_1960s=.
replace birth_1960s=1 if birth_year>=1960 & birth_year< 1970  
replace birth_1960s=0 if birth_year<1960 | (birth_year>=1970& birth_year~=.)

gen birth_1970s=.
replace birth_1970s=1 if birth_year>=1970 & birth_year< 1980  
replace birth_1970s=0 if birth_year<1970 | (birth_year>=1980& birth_year~=.)

gen birth_1980s=.
replace birth_1980s=1 if birth_year>=1980 & birth_year< 1990  
replace birth_1980s=0 if birth_year<1980 | (birth_year>=1990& birth_year~=.)

gen birth_1990s=.
replace birth_1990s=1 if birth_year>=1990 & birth_year< 2000  
replace birth_1990s=0 if birth_year<1990 | (birth_year>=2000& birth_year~=.)

**** generate age controls
foreach var in birth_pre1930 birth_1930s birth_1940s birth_1950s birth_1960s birth_1970s birth_1980s birth_1990s { 
	gen age_`var'=age*`var'
}
     
foreach var in birth_pre1930 birth_1930s birth_1940s birth_1950s birth_1960s birth_1970s birth_1980s birth_1990s { 
	gen age_sq_`var'=age*age*`var'
}

xi i.age6

*only for regression output reporting FE's:
gen pow_FE_indicator=1 if  powiaty_code~=.
gen gminy_FE_indicator=1 if  gminy_code~=.

} 

global base_controls "age_birth* age_sq_birth* female rural city" 

drop wojewodztwo 

 label var powiaty_code "powiaty code, respondent"
 label var woj  "wojewodztwo"
 label var female "female"
 label var rural "rural"
 label var city "city"
 order city, after (rural) 
 label var edu_years "years of education"
 order edu_years, after (higher_edu)

 
 label var age_birth_pre1930 "age, respondent born before 1930"
 label var age_sq_birth_pre1930 "age squared, respondent born before 1930"

 foreach values in 1930 1940 1950 1960 1970 1980 1990 {
 label var age_birth_`values's "age, respondent born in the `values's"
 label var age_sq_birth_`values's "age squared, respondent born in the `values's"
}
label var pow_FE_indicator "powiaty, fixed effect indicator" 
label var gminy_code "gminy code" 
label var  gminy_FE_indicator "gminy, fixed effect indicator"

save  "${path}/Data/generated_data/ancestry_resplevel_replicate.dta", replace 

/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/
/****************  GENERATE DATASET: CBOS dataset ancestor level from respondent level  ******************************/
/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/


local anc_list "R F M FF MF FM MM FFF MFF FMF MMF FFM MFM FMM MMM"

foreach anc in `anc_list' {

	use "${path}/Data/original_data/cbos_with_1931.dta", clear
	
	keep if `anc'1 != . | `anc'2 != . | `anc'3 != . | `anc'5 != . | `anc'7 != . | `anc'9 != . | `anc'11 != . | `anc'12 != .
	
	keep numer_ankiety `anc'1 `anc'2 `anc'3 `anc'4 `anc'5 `anc'6 `anc'7 `anc'8 `anc'9 ///
		`anc'10 `anc'11 `anc'12 central_poland_`anc'1 wt_`anc'1 abroad_`anc'1 rural_`anc'2 ///
		urban_`anc'2 `anc'_abroad lithuania_`anc'11 belorussia_`anc'11 ukraine_`anc'11 `anc'12_forced ///
		`anc'_data_quality_source `anc'_latitude1939_use `anc'_longitude1939_use `anc'_pow_code1931_use ///
		`anc'_in_kresy `anc'_origin_country_use `anc'_r_rcatholic_1931 `anc'_r_gcatholic_1931 ///
	    `anc'_r_orthodox_1931 `anc'_r_jewish_1931 `anc'_r_protestant_1931 `anc'_Lang_polish_1931 ///
		`anc'_Lang_bel_1931 `anc'_Lang_russian_1931 `anc'_Lang_lit_1931 `anc'_Lang_german_1931 ///
		`anc'_Lang_ukranian_1931 `anc'_readonly_1931 `anc'_literate_1931 `anc'_notliterate_1931 ///
		`anc'_urbanization_1931 `anc'_r_rcatholic_1931urban `anc'_r_gcatholic_1931urban `anc'_r_orthodox_1931urban ///
		`anc'_r_jewish_1931urban `anc'_r_protestant_1931urban `anc'_Lang_polish_1931urban `anc'_Lang_bel_1931urban /// 
		`anc'_Lang_russian_1931urban `anc'_Lang_lit_1931urban `anc'_Lang_german_1931urban `anc'_Lang_ukranian_1931urban ///
		`anc'_readonly_1931urban `anc'_literate_1931urban `anc'_notliterate_1931urban `anc'_r_rcatholic_1931rural ///
		`anc'_r_gcatholic_1931rural `anc'_r_orthodox_1931rural `anc'_r_jewish_1931rural `anc'_r_protestant_1931rural ///
		`anc'_Lang_polish_1931rural `anc'_Lang_bel_1931rural `anc'_Lang_russian_1931rural `anc'_Lang_lit_1931rural ///
		`anc'_Lang_german_1931rural `anc'_Lang_ukranian_1931rural `anc'_readonly_1931rural `anc'_literate_1931rural ///
		`anc'_notliterate_1931rural `anc'_r_rcatholic_1931pow `anc'_r_gcatholic_1931pow `anc'_r_orthodox_1931pow ///
		`anc'_r_jewish_1931pow `anc'_r_protestant_1931pow `anc'_Lang_polish_1931pow `anc'_Lang_bel_1931pow ///
		`anc'_Lang_russian_1931pow `anc'_Lang_lit_1931pow `anc'_Lang_german_1931pow `anc'_Lang_ukranian_1931pow ///
		`anc'_readonly_1931pow  `anc'_literate_1931pow `anc'_notliterate_1931pow  ///
		`anc'_literate_1921_t `anc'_literate_1921_u `anc'_literate_1921_r  `anc'_literate_1921 ///
		`anc'_lit_rcath_1921_t `anc'_lit_rcath_1921_u `anc'_lit_rcath_1921_r  `anc'_lit_rcath_1921 ///
		`anc'_r_catholic_1921_t `anc'_r_catholic_1921_u `anc'_r_catholic_1921_r  `anc'_r_catholic_1921 `anc'_woj_code
	
	gen anc_lvl = "`anc'"
	
	rename `anc'1 anc1
	rename `anc'2 anc2
	rename `anc'3 anc3
	rename `anc'4 anc4
	rename `anc'5 anc5
	rename `anc'6 anc6
	rename `anc'7 anc7
	rename `anc'8 anc8
	rename `anc'9 anc9
	rename `anc'10 anc10
	rename `anc'11 anc11
	rename `anc'12 anc12
	rename central_poland_`anc'1 central_poland_anc1
	rename wt_`anc'1 wt_anc1
	rename abroad_`anc'1 abroad_anc1
	rename rural_`anc'2 rural_anc2
	rename urban_`anc'2 urban_anc2
	rename `anc'_abroad anc_abroad
	rename lithuania_`anc'11 lithuania_anc11
	rename belorussia_`anc'11 belorussia_anc11
	rename ukraine_`anc'11 ukraine_anc11
	rename `anc'12_forced anc12_forced
	rename `anc'_data_quality_source anc_data_quality_source
	rename `anc'_latitude1939_use anc_latitude1939_use
	rename `anc'_longitude1939_use anc_longitude1939_use
	rename `anc'_pow_code1931_use anc_pow_code1931_use
	rename `anc'_in_kresy anc_in_kresy
	rename `anc'_origin_country_use anc_origin_country_use
	rename `anc'_r_rcatholic_1931 anc_r_rcatholic_1931
	rename `anc'_r_gcatholic_1931 anc_r_gcatholic_1931
	rename `anc'_r_orthodox_1931 anc_r_orthodox_1931
	rename `anc'_r_jewish_1931 anc_r_jewish_1931
	rename `anc'_r_protestant_1931 anc_r_protestant_1931
	rename `anc'_Lang_polish_1931 anc_Lang_polish_1931
	rename `anc'_Lang_bel_1931 anc_Lang_bel_1931
	rename `anc'_Lang_russian_1931 anc_Lang_russian_1931
	rename `anc'_Lang_lit_1931 anc_Lang_lit_1931
	rename `anc'_Lang_german_1931 anc_Lang_german_1931
	rename `anc'_Lang_ukranian_1931 anc_Lang_ukranian_1931
	rename `anc'_readonly_1931 anc_readonly_1931
	rename `anc'_literate_1931 anc_literate_1931
	rename `anc'_notliterate_1931 anc_notliterate_1931
	rename `anc'_urbanization_1931 anc_urbanization_1931
	rename `anc'_r_rcatholic_1931urban anc_r_rcatholic_1931urban
	rename `anc'_r_gcatholic_1931urban anc_r_gcatholic_1931urban
	rename `anc'_r_orthodox_1931urban anc_r_orthodox_1931urban
	rename `anc'_r_jewish_1931urban anc_r_jewish_1931urban
	rename `anc'_r_protestant_1931urban anc_r_protestant_1931urban
	rename `anc'_Lang_polish_1931urban anc_Lang_polish_1931urban
	rename `anc'_Lang_bel_1931urban anc_Lang_bel_1931urban
	rename `anc'_Lang_russian_1931urban anc_Lang_russian_1931urban
	rename `anc'_Lang_lit_1931urban anc_Lang_lit_1931urban
	rename `anc'_Lang_german_1931urban anc_Lang_german_1931urban
	rename `anc'_Lang_ukranian_1931urban anc_Lang_ukranian_1931urban
	rename `anc'_readonly_1931urban anc_readonly_1931urban
	rename `anc'_literate_1931urban anc_literate_1931urban
	rename `anc'_notliterate_1931urban anc_notliterate_1931urban
	rename `anc'_r_rcatholic_1931rural anc_r_rcatholic_1931rural
	rename `anc'_r_gcatholic_1931rural anc_r_gcatholic_1931rural
	rename `anc'_r_orthodox_1931rural anc_r_orthodox_1931rural
	rename `anc'_r_jewish_1931rural anc_r_jewish_1931rural
	rename `anc'_r_protestant_1931rural anc_r_protestant_1931rural
	rename `anc'_Lang_polish_1931rural anc_Lang_polish_1931rural
	rename `anc'_Lang_bel_1931rural anc_Lang_bel_1931rural
	rename `anc'_Lang_russian_1931rural anc_Lang_russian_1931rural
	rename `anc'_Lang_lit_1931rural anc_Lang_lit_1931rural
	rename `anc'_Lang_german_1931rural anc_Lang_german_1931rural
	rename `anc'_Lang_ukranian_1931rural anc_Lang_ukranian_1931rural
	rename `anc'_readonly_1931rural anc_readonly_1931rural
	rename `anc'_literate_1931rural anc_literate_1931rural
	rename `anc'_notliterate_1931rural anc_notliterate_1931rural
	rename `anc'_r_rcatholic_1931pow anc_r_rcatholic_1931pow
	rename `anc'_r_gcatholic_1931pow anc_r_gcatholic_1931pow
	rename `anc'_r_orthodox_1931pow anc_r_orthodox_1931pow
	rename `anc'_r_jewish_1931pow anc_r_jewish_1931pow
	rename `anc'_r_protestant_1931pow anc_r_protestant_1931pow
	rename `anc'_Lang_polish_1931pow anc_Lang_polish_1931pow
	rename `anc'_Lang_bel_1931pow anc_Lang_bel_1931pow
	rename `anc'_Lang_russian_1931pow anc_Lang_russian_1931pow
	rename `anc'_Lang_lit_1931pow anc_Lang_lit_1931pow
	rename `anc'_Lang_german_1931pow anc_Lang_german_1931pow
	rename `anc'_Lang_ukranian_1931pow anc_Lang_ukranian_1931pow
	rename `anc'_readonly_1931pow anc_readonly_1931pow
	rename `anc'_literate_1931pow anc_literate_1931pow
	rename `anc'_notliterate_1931pow anc_notliterate_1931pow
	rename `anc'_literate_1921_t anc_literate_1921_t 
	rename `anc'_literate_1921_u anc_literate_1921_u  
	rename `anc'_literate_1921_r anc_literate_1921_r 
	rename `anc'_lit_rcath_1921_t anc_lit_rcath_1921_t 
	rename `anc'_lit_rcath_1921_u anc_lit_rcath_1921_u 
	rename `anc'_lit_rcath_1921_r anc_lit_rcath_1921_r 
	rename `anc'_r_catholic_1921_t anc_r_catholic_1921_t 
	rename `anc'_r_catholic_1921_u anc_r_catholic_1921_u 
	rename `anc'_r_catholic_1921_r anc_r_catholic_1921_r
	rename `anc'_woj_code anc_woj_code
	rename `anc'_r_catholic_1921 anc_r_catholic_1921
	rename 	`anc'_lit_rcath_1921 anc_lit_rcath_1921 
	rename 	`anc'_literate_1921 anc_literate_1921
	
	save "${path}/Data/generated_data/temp/`anc'_anc_list.dta", replace
}
 
local anc_list_2 "A1_1 S1_1 S1_2 S1_3"

foreach anc in `anc_list_2' {

	use "${path}/Data/original_data/cbos_with_1931.dta", clear
	
	local anc1 = substr("`anc'", 1, 1) + "1" + substr("`anc'", 3, 2)
	local anc2 = substr("`anc'", 1, 1) + "2" + substr("`anc'", 3, 2)
	local anc3 = substr("`anc'", 1, 1) + "3" + substr("`anc'", 3, 2)
	local anc4 = substr("`anc'", 1, 1) + "4" + substr("`anc'", 3, 2)
	local anc5 = substr("`anc'", 1, 1) + "5" + substr("`anc'", 3, 2)
	local anc6 = substr("`anc'", 1, 1) + "6" + substr("`anc'", 3, 2)
	local anc7 = substr("`anc'", 1, 1) + "7" + substr("`anc'", 3, 2)
	local anc8 = substr("`anc'", 1, 1) + "8" + substr("`anc'", 3, 2)
	local anc9 = substr("`anc'", 1, 1) + "9" + substr("`anc'", 3, 2)
	local anc10 = substr("`anc'", 1, 1) + "10" + substr("`anc'", 3, 2)
	local anc11 = substr("`anc'", 1, 1) + "11" + substr("`anc'", 3, 2)

	
	keep if  `anc2' != . | `anc3' != . | `anc5' != . | `anc7' != . | `anc9' != . | `anc11' != . 
	
	keep numer_ankiety `anc1' `anc2' `anc3' `anc4' `anc5' `anc6' `anc7' `anc8' `anc9' ///
		`anc10' `anc11'  rural_`anc2' ///
		urban_`anc2' `anc'_abroad lithuania_`anc11' belorussia_`anc11' ukraine_`anc11'  ///
		`anc'_data_quality_source `anc'_latitude1939_use `anc'_longitude1939_use `anc'_pow_code1931_use ///
		`anc'_in_kresy `anc'_origin_country_use `anc'_r_rcatholic_1931 `anc'_r_gcatholic_1931 ///
	    `anc'_r_orthodox_1931 `anc'_r_jewish_1931 `anc'_r_protestant_1931 `anc'_Lang_polish_1931 ///
		`anc'_Lang_bel_1931 `anc'_Lang_russian_1931 `anc'_Lang_lit_1931 `anc'_Lang_german_1931 ///
		`anc'_Lang_ukranian_1931 `anc'_readonly_1931 `anc'_literate_1931 `anc'_notliterate_1931 ///
		`anc'_urbanization_1931 `anc'_r_rcatholic_1931urban `anc'_r_gcatholic_1931urban `anc'_r_orthodox_1931urban ///
		`anc'_r_jewish_1931urban `anc'_r_protestant_1931urban `anc'_Lang_polish_1931urban `anc'_Lang_bel_1931urban /// 
		`anc'_Lang_russian_1931urban `anc'_Lang_lit_1931urban `anc'_Lang_german_1931urban `anc'_Lang_ukranian_1931urban ///
		`anc'_readonly_1931urban `anc'_literate_1931urban `anc'_notliterate_1931urban `anc'_r_rcatholic_1931rural ///
		`anc'_r_gcatholic_1931rural `anc'_r_orthodox_1931rural `anc'_r_jewish_1931rural `anc'_r_protestant_1931rural ///
		`anc'_Lang_polish_1931rural `anc'_Lang_bel_1931rural `anc'_Lang_russian_1931rural `anc'_Lang_lit_1931rural ///
		`anc'_Lang_german_1931rural `anc'_Lang_ukranian_1931rural `anc'_readonly_1931rural `anc'_literate_1931rural ///
		`anc'_notliterate_1931rural `anc'_r_rcatholic_1931pow `anc'_r_gcatholic_1931pow `anc'_r_orthodox_1931pow ///
		`anc'_r_jewish_1931pow `anc'_r_protestant_1931pow `anc'_Lang_polish_1931pow `anc'_Lang_bel_1931pow ///
		`anc'_Lang_russian_1931pow `anc'_Lang_lit_1931pow `anc'_Lang_german_1931pow `anc'_Lang_ukranian_1931pow ///
		`anc'_readonly_1931pow  `anc'_literate_1931pow `anc'_notliterate_1931pow  ///
		`anc'_literate_1921_t `anc'_literate_1921_u `anc'_literate_1921_r  `anc'_literate_1921 ///
		`anc'_lit_rcath_1921_t `anc'_lit_rcath_1921_u `anc'_lit_rcath_1921_r  `anc'_lit_rcath_1921 ///
		`anc'_r_catholic_1921_t `anc'_r_catholic_1921_u `anc'_r_catholic_1921_r  `anc'_r_catholic_1921 `anc'_woj_code


	gen anc_lvl = "`anc'"
	
	rename `anc1' anc1
	rename `anc2' anc2
	rename `anc3' anc3
	rename `anc4' anc4
	rename `anc5' anc5
	rename `anc6' anc6
	rename `anc7' anc7
	rename `anc8' anc8
	rename `anc9' anc9
	rename `anc10' anc10
	rename `anc11' anc11
	gen anc12 = .
	gen central_poland_anc1 = .
	gen wt_anc1 = .
	gen abroad_anc1 = .
	rename rural_`anc2' rural_anc2
	rename urban_`anc2' urban_anc2
	rename `anc'_abroad anc_abroad
	rename lithuania_`anc11' lithuania_anc11
	rename belorussia_`anc11' belorussia_anc11
	rename ukraine_`anc11' ukraine_anc11
	gen anc12_forced = .
	rename `anc'_data_quality_source anc_data_quality_source
	rename `anc'_latitude1939_use anc_latitude1939_use
	rename `anc'_longitude1939_use anc_longitude1939_use
	rename `anc'_pow_code1931_use anc_pow_code1931_use
	rename `anc'_in_kresy anc_in_kresy
	rename `anc'_origin_country_use anc_origin_country_use
	rename `anc'_r_rcatholic_1931 anc_r_rcatholic_1931
	rename `anc'_r_gcatholic_1931 anc_r_gcatholic_1931
	rename `anc'_r_orthodox_1931 anc_r_orthodox_1931
	rename `anc'_r_jewish_1931 anc_r_jewish_1931
	rename `anc'_r_protestant_1931 anc_r_protestant_1931
	rename `anc'_Lang_polish_1931 anc_Lang_polish_1931
	rename `anc'_Lang_bel_1931 anc_Lang_bel_1931
	rename `anc'_Lang_russian_1931 anc_Lang_russian_1931
	rename `anc'_Lang_lit_1931 anc_Lang_lit_1931
	rename `anc'_Lang_german_1931 anc_Lang_german_1931
	rename `anc'_Lang_ukranian_1931 anc_Lang_ukranian_1931
	rename `anc'_readonly_1931 anc_readonly_1931
	rename `anc'_literate_1931 anc_literate_1931
	rename `anc'_notliterate_1931 anc_notliterate_1931
	rename `anc'_urbanization_1931 anc_urbanization_1931
	rename `anc'_r_rcatholic_1931urban anc_r_rcatholic_1931urban
	rename `anc'_r_gcatholic_1931urban anc_r_gcatholic_1931urban
	rename `anc'_r_orthodox_1931urban anc_r_orthodox_1931urban
	rename `anc'_r_jewish_1931urban anc_r_jewish_1931urban
	rename `anc'_r_protestant_1931urban anc_r_protestant_1931urban
	rename `anc'_Lang_polish_1931urban anc_Lang_polish_1931urban
	rename `anc'_Lang_bel_1931urban anc_Lang_bel_1931urban
	rename `anc'_Lang_russian_1931urban anc_Lang_russian_1931urban
	rename `anc'_Lang_lit_1931urban anc_Lang_lit_1931urban
	rename `anc'_Lang_german_1931urban anc_Lang_german_1931urban
	rename `anc'_Lang_ukranian_1931urban anc_Lang_ukranian_1931urban
	rename `anc'_readonly_1931urban anc_readonly_1931urban
	rename `anc'_literate_1931urban anc_literate_1931urban
	rename `anc'_notliterate_1931urban anc_notliterate_1931urban
	rename `anc'_r_rcatholic_1931rural anc_r_rcatholic_1931rural
	rename `anc'_r_gcatholic_1931rural anc_r_gcatholic_1931rural
	rename `anc'_r_orthodox_1931rural anc_r_orthodox_1931rural
	rename `anc'_r_jewish_1931rural anc_r_jewish_1931rural
	rename `anc'_r_protestant_1931rural anc_r_protestant_1931rural
	rename `anc'_Lang_polish_1931rural anc_Lang_polish_1931rural
	rename `anc'_Lang_bel_1931rural anc_Lang_bel_1931rural
	rename `anc'_Lang_russian_1931rural anc_Lang_russian_1931rural
	rename `anc'_Lang_lit_1931rural anc_Lang_lit_1931rural
	rename `anc'_Lang_german_1931rural anc_Lang_german_1931rural
	rename `anc'_Lang_ukranian_1931rural anc_Lang_ukranian_1931rural
	rename `anc'_readonly_1931rural anc_readonly_1931rural
	rename `anc'_literate_1931rural anc_literate_1931rural
	rename `anc'_notliterate_1931rural anc_notliterate_1931rural
	rename `anc'_r_rcatholic_1931pow anc_r_rcatholic_1931pow
	rename `anc'_r_gcatholic_1931pow anc_r_gcatholic_1931pow
	rename `anc'_r_orthodox_1931pow anc_r_orthodox_1931pow
	rename `anc'_r_jewish_1931pow anc_r_jewish_1931pow
	rename `anc'_r_protestant_1931pow anc_r_protestant_1931pow
	rename `anc'_Lang_polish_1931pow anc_Lang_polish_1931pow
	rename `anc'_Lang_bel_1931pow anc_Lang_bel_1931pow
	rename `anc'_Lang_russian_1931pow anc_Lang_russian_1931pow
	rename `anc'_Lang_lit_1931pow anc_Lang_lit_1931pow
	rename `anc'_Lang_german_1931pow anc_Lang_german_1931pow
	rename `anc'_Lang_ukranian_1931pow anc_Lang_ukranian_1931pow
	rename `anc'_readonly_1931pow anc_readonly_1931pow
	rename `anc'_literate_1931pow anc_literate_1931pow
	rename `anc'_notliterate_1931pow anc_notliterate_1931pow
	rename `anc'_literate_1921_t anc_literate_1921_t 
	rename `anc'_literate_1921_u anc_literate_1921_u  
	rename `anc'_literate_1921_r anc_literate_1921_r 
	rename `anc'_lit_rcath_1921_t anc_lit_rcath_1921_t 
	rename `anc'_lit_rcath_1921_u anc_lit_rcath_1921_u 
	rename `anc'_lit_rcath_1921_r anc_lit_rcath_1921_r 
	rename `anc'_r_catholic_1921_t anc_r_catholic_1921_t 
	rename `anc'_r_catholic_1921_u anc_r_catholic_1921_u 
	rename `anc'_r_catholic_1921_r anc_r_catholic_1921_r
	rename `anc'_woj_code anc_woj_code
	rename `anc'_r_catholic_1921 anc_r_catholic_1921
	rename 	`anc'_lit_rcath_1921 anc_lit_rcath_1921 
	rename 	`anc'_literate_1921 anc_literate_1921
	
	
	save "${path}/Data/generated_data/temp/`anc'_anc_list.dta", replace
}

clear all 

local anc_list_3 "R F M FF MF FM MM FFF MFF FMF MMF FFM MFM FMM MMM A1_1 S1_1 S1_2 S1_3"

foreach anc in `anc_list_3' {
	append using "${path}/Data/generated_data/temp/`anc'_anc_list.dta"
}


sort numer_ankiety anc_lvl

order numer_ankiety anc_lvl

* Merge respondend-level variables

merge m:1 numer_ankiety using "${path}/Data/original_data/cbos_with_1931.dta"
keep if _merge == 3 
drop _merge

gen id_ancestor = _n 
gen 	anc_gender = 1 if substr(anc_lvl, 1, 1) == "F"
replace anc_gender = 2 if substr(anc_lvl, 1, 1) == "M"

gen anc_female_share = 1 if anc_lvl == "M" | anc_lvl == "MM" | anc_lvl == "MMM"
replace anc_female_share = 0.5 if anc_lvl == "MF" | anc_lvl == "FM"
replace anc_female_share = 0.33 if anc_lvl == "MFF" | anc_lvl == "FMF" | anc_lvl == "FFM" 
replace anc_female_share = 0.66 if anc_lvl == "MMF" | anc_lvl == "MFM" | anc_lvl == "FMM"
replace anc_female_share = 0 if anc_lvl == "F" | anc_lvl == "FF" | anc_lvl == "FFF"

gen 	anc_code = 1  if anc_lvl == "R"
replace anc_code = 2  if anc_lvl == "F" 
replace anc_code = 3  if anc_lvl == "M" 
replace anc_code = 4  if anc_lvl == "FF" 
replace anc_code = 5  if anc_lvl == "MF" 
replace anc_code = 6  if anc_lvl == "FM" 
replace anc_code = 7  if anc_lvl == "MM" 
replace anc_code = 8  if anc_lvl == "FFF" 
replace anc_code = 9  if anc_lvl == "MFF" 
replace anc_code = 10 if anc_lvl == "FMF" 
replace anc_code = 11 if anc_lvl == "MMF" 
replace anc_code = 12 if anc_lvl == "FFM" 
replace anc_code = 13 if anc_lvl == "MFM" 
replace anc_code = 14 if anc_lvl == "FMM" 
replace anc_code = 15 if anc_lvl == "MMM" 
replace anc_code = 16 if anc_lvl == "A1_1" 
replace anc_code = 17 if anc_lvl == "S1_1" 
replace anc_code = 18 if anc_lvl == "S1_2" 
replace anc_code = 19 if anc_lvl == "S1_3" 

gen 	anc_depth = 0 if anc_lvl == "R"
replace anc_depth = 1 if anc_lvl == "F" | anc_lvl == "M"
replace anc_depth = 2 if anc_lvl == "FM"| anc_lvl == "MF"| anc_lvl == "FF"| anc_lvl == "MM"
replace anc_depth = 3 if anc_lvl == "FMM" | anc_lvl == "MFM" | anc_lvl == "MMF"| anc_lvl == "MFF"| anc_lvl == "FMF" | anc_lvl == "FFM" | anc_lvl == "FFF" | anc_lvl == "MMM"
replace anc_depth = 4 if anc_lvl == "A1_1"

order id_ancestor numer_ankiety anc_lvl anc_gender anc_female_share anc_code anc_depth

label var id_ancestor "id_ancestor"
label var anc_lvl "level of ancestor"
label var anc_gender "gender of ancestor" 
label var anc_female_share "share of females in ancestor's branch"
label var anc_code "code of ancestor's level" 


label define anccode 1 "R" /// 
					 2 "F" /// 
					 3 "M" /// 
					 4 "FF" /// 
					 5 "MF" /// 
					 6 "FM" /// 
					 7 "MM" /// 
					 8 "FFF"  /// 
					 9 "MFF" /// 
					 10 "FMF" /// 
					 11 "MMF" /// 
					 12 "FFM" /// 
					 13 "MFM" /// 
					 14 "FMM" /// 
					 15 "MMM" /// 
					 16 "A1_1" ///
					 17 "S1_1" ///
					 18 "S1_2" ///
					 19 "S1_3"

label values anc_code anccode

label define gencod 1 "F" 2 "M"
label values anc_gender gencod

label define depthcode 0 "respondent" ///
					 1 "parents" /// 
					 2 "grandparents" /// 
					 3 "great grandparents" /// 
					 4 "great great grandparents" 
label values anc_depth depthcode

gen anc_in_wt=1 if anc_origin_country_use=="WT"|anc_origin_country_use=="Gdansk"
replace anc_in_wt=0 if  anc_origin_country_use!=""&anc_in_wt==.
gen anc_in_cp=1 if anc_origin_country_use=="Central Poland"
replace anc_in_cp=0 if  anc_origin_country_use!=""&anc_in_cp==.
gen anc_forced=1 if anc12==1
replace anc_forced=0 if anc_forced==.
replace anc_forced=. if anc12==.

drop if  anc_code>16	
drop if anc_depth==0|anc_depth==4	


gen anc_ussr_not_kresy=1 if anc_origin_country_use=="Kresy"& anc_pow_code1931_use==""&anc_data_quality_source<3000
replace anc_ussr_not_kresy=0 if anc_origin_country_use=="Kresy"&anc_ussr_not_kresy==.			 
 
gen anc_pow_woj_code1931=real(regexr(anc_pow_code1931_use,"P",""))
replace anc_pow_woj_code1931=10000*anc_woj_code if anc_pow_code1931_use==""
label var anc_pow_woj_code1931 "pow1931 code or 10000*woj1931_code"


gen anc_pow_code1931_str=anc_pow_code1931_use

save "${path}/Data/generated_data/anc_level_data.dta", replace


/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/
/****************  PREPARE DATASET: CBOS dataset ancestor level   ******************************/
/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/


quietly{ 

use "${path}/Data/generated_data/anc_level_data.dta", clear

set matsize 11000

rename anc_abroad anc_abroad_orig
gen anc_abroad = (anc_abroad_orig!="")
label var anc_abroad "Ancestor from abroad"

cap drop city 
cap drop age_sq

gen city=1 if strpos(gmina, "M. ")
replace city=0 if city==.

gen age_sq=age^2

/* generate age6 variable as in Diagnoza */
gen age6 = .
replace age6 = 1 if age<=24
replace age6 = 2 if age>=25 & age<=34
replace age6 = 3 if age>=35 & age<=44
replace age6 = 4 if age>=45 & age<=59
replace age6 = 5 if age>=60 & age<=64
replace age6 = 6 if age>=65 & age<=105


******create birth cohorts 

gen birth_year=D2

gen birth_pre1930=.
replace birth_pre1930=1 if birth_year<1930 
replace birth_pre1930=0 if birth_year>=1930 & birth_year~=.

gen birth_1930s=.
replace birth_1930s=1 if birth_year>=1930 & birth_year< 1940 
replace birth_1930s=0 if birth_year<1930 | (birth_year>=1940& birth_year~=.)

gen birth_1940s=.
replace birth_1940s=1 if birth_year>=1940 & birth_year< 1950 
replace birth_1940s=0 if birth_year<1940 | (birth_year>=1950& birth_year~=.)

gen birth_1950s=.
replace birth_1950s=1 if birth_year>=1950 & birth_year< 1960  
replace birth_1950s=0 if birth_year<1950 | (birth_year>=1960& birth_year~=.)

gen birth_1960s=.
replace birth_1960s=1 if birth_year>=1960 & birth_year< 1970  
replace birth_1960s=0 if birth_year<1960 | (birth_year>=1970& birth_year~=.)

gen birth_1970s=.
replace birth_1970s=1 if birth_year>=1970 & birth_year< 1980  
replace birth_1970s=0 if birth_year<1970 | (birth_year>=1980& birth_year~=.)

gen birth_1980s=.
replace birth_1980s=1 if birth_year>=1980 & birth_year< 1990  
replace birth_1980s=0 if birth_year<1980 | (birth_year>=1990& birth_year~=.)

gen birth_1990s=.
replace birth_1990s=1 if birth_year>=1990 & birth_year< 2000  
replace birth_1990s=0 if birth_year<1990 | (birth_year>=2000& birth_year~=.)

**** generate age controls
foreach var in birth_pre1930 birth_1930s birth_1940s birth_1950s birth_1960s birth_1970s birth_1980s birth_1990s { 
gen age_`var'=age*`var'
}
     
foreach var in birth_pre1930 birth_1930s birth_1940s birth_1950s birth_1960s birth_1970s birth_1980s birth_1990s { 
gen age_sq_`var'=age_sq*`var'
}


merge 1:1 id_ancestor using "${path}/Data/original_data/anc_ids_modern_country_origin.dta" 
drop _merge


foreach cnt in BLR UKR LTU POL{
gen anc_`cnt'_origin=1 if anc_origin_country_gmi=="`cnt'"
replace anc_`cnt'_origin=0 if anc_origin_country_gmi!="`cnt'"&anc_`cnt'_origin==.
}

replace anc_UKR_origin=. if anc_in_kresy==0&anc_UKR_origin==1 /*there are two people from Ukraine and not from kresy -- they are from powiaty split by the border */

****** some migrants were forced from central poland: for example, Ukrainians and military units...
gen anc_in_kresy_self=(anc1==1)
replace anc_in_kresy_self=. if anc1==.

gen anc_forced_ext=anc_forced 
replace anc_forced_ext=0 if anc_forced_ext==.&anc1==2&anc_in_cp

******* depth of ancestry --GENERATIONAL GAP

gen anc_in_kresy_parents=anc_in_kresy
replace anc_in_kresy_parents=0 if  anc_depth!=1&anc_depth!=.

gen anc_in_kresy_grandparents=anc_in_kresy
replace anc_in_kresy_grandparents=0 if  anc_depth!=2&anc_depth!=.

gen anc_in_kresy_grgrandparents=anc_in_kresy
replace anc_in_kresy_grgrandparents=0 if  anc_depth!=3&anc_depth!=.

*Impute years of edu from average years corresponding to each degree (as computed in Diagnoza)
gen edu_years = .
replace edu_years = 7 if eduk4==1
replace edu_years = 11 if eduk4==2
replace edu_years = 13 if eduk4==3
replace edu_years = 17 if eduk4==4

******

gen anc_in_kresy_parents_self=anc_in_kresy_self
replace anc_in_kresy_parents_self=0 if  anc_depth!=1&anc_depth!=.

gen anc_in_kresy_grandparents_self=anc_in_kresy_self
replace anc_in_kresy_grandparents_self=0 if  anc_depth!=2&anc_depth!=.

gen anc_in_kresy_grgrandparents_self=anc_in_kresy_self
replace anc_in_kresy_grgrandparents_self=0 if  anc_depth!=3&anc_depth!=.
  
rename waga_calosc weight2 
label var weight2 "Weight for Respondent Level Regs (to render CBOS representative)"
 
label var anc_in_kresy_parents "Ancestor from Kresy (Parent)"
label var anc_in_kresy_grandparents "Ancestor from Kresy (Grandparent)"
label var anc_in_kresy_grgrandparents "Ancestor from Kresy (Great-grandparent"
label var anc_in_wt "Ancestor from WT"

tab anc_depth, gen(d_anc)
label var d_anc1 "Parent"
label var d_anc2 "Grandparent"
label var d_anc3 "Great-grandparent"

label var rural_anc2 "Ancestor from rural area"
label var anc_in_kresy "Ancestor from Kresy"

*only for regression output reporting FE's:
gen pow_FE_indicator=1 if  powiaty_code~=.
gen gminy_FE_indicator=1 if  gminy_code~=.

gen anc_pow_code1931_use_cl=anc_pow_code1931_use
replace anc_pow_code1931_use_cl="Other" if anc_pow_code1931_use_cl == ""

xi i.age6

}

global base_controls "age_birth* age_sq_birth* female rural city" 
global anc_controls "anc_in_wt anc_abroad rural_anc2 d_anc2 d_anc3" 

keep edu_years secondary_edu higher_edu   $base_controls  $anc_controls  anc_in_kresy anc_in_cp anc_in_wt rural_anc2 urban_anc2 anc_gender anc_female_share  d_anc1 d_anc2 d_anc3  ///
edu_years  d_anc2 d_anc3  anc_pow_code1931_use  powiaty_code pow_FE_indicator numer_ankiety gminy_code gminy_FE_indicator anc_POL_origin anc_UKR_origin  anc_BLR_origin anc_LTU_origin ///
  rural anc_in_kresy PL_kresy_origin_mean d_anc1 d_anc2 d_anc3  id_ancestor anc_latitude1939_use anc_longitude1939_use ///
  anc_lit_rcath_1921  anc_r_rcatholic_1931  anc_Lang_polish_1931  anc_Lang_ukranian_1931 anc_r_rcatholic_1931 anc_Lang_polish_1931 anc_Lang_russian_1931  anc_literate_1931 anc_urbanization_1931 anc_literate_1921 anc_lit_rcath_1921 anc_r_catholic_1921   ///
   anc_pow_code1931_use_cl typ_proby  abroad_anc1 city rural age age_sq female  wt_origin_mean  anc_pow_code1931_str anc_depth  PL_wt_origin_mean  abroad_origin_mean  rural_origin_mean weight2 ///
   gmina anc1 PL_central_poland_origin_only

label var anc_depth "ancestor depth level"
label var female "female"
label var age "age"
label var age_sq "qge squared"
order age_sq, after (age)
label var secondary_edu "Complete, secondary"
label var higher_edu "Higher, education"
label var edu_years "years of education"
order edu_years, after (higher_edu)

label var gminy_code "Gminy code" 
label var powiaty_code "Powiaty code"
label var pow_FE_indicator "powiaty, fixed effect indicator" 
label var gminy_FE_indicator "gminy, fixed effect indicator" 
label var anc_pow_code1931_use_cl  "Ancestor, powiaty code of origin in 1931"
label var anc_pow_code1931_str "Ancestor, powiaty code of origin in 1931"
order anc_pow_code1931_str, after (anc_pow_code1931_use_cl)

label var rural "rural"
label var city "city"
order city, after (rural) 
 
 label var anc_in_cp "Ancestor from Central Poland"
 
 label var age_birth_pre1930 "age, respondent born before 1930"
 label var age_sq_birth_pre1930 "age squared, respondent born before 1930"
 foreach values in 1930 1940 1950 1960 1970 1980 1990 {
 label var age_birth_`values's "age, respondent born in the `values's"
 label var age_sq_birth_`values's "age squared, respondent born in the `values's"
}

label var anc_BLR_origin "Ancestor origin from (present-day) Belarus"
label var anc_LTU_origin "Ancestor origin from (present-day)  Lithuania"
label var anc_UKR_origin "Ancestor origin from (present-day) Ukraine"
label var anc_POL_origin "Ancestor origin from (present-day) Poland"

label var PL_kresy_origin_mean "Share of Ancestors, Kresy"
label var PL_wt_origin_mean    "Share of Ancestors, WT"
label var rural_origin_mean    "Share of Ancestors, rural"
label var abroad_origin_mean   "Share of Ancestors, abroad"
label var PL_kresy_origin 		"Ancestor from Kresy"

label define typ_proby  1 "representative sample" 2 "oversample"
label values  typ_proby   typ_proby  

label var powiaty_code "powiaty code, respondent"
 
label var  abroad_anc1 "Ancestor lived abroad, dummy"
label var urban_anc2 "Ancestor from urban area"
 

 label var anc_r_rcatholic_1931 "Share Rom. Cath., taking into account rural/urban origin, 1931"
 label var anc_Lang_polish_1931 "Share Polish speakers, taking into account rural/urban origin, 1931"
 label var anc_Lang_russian_1931 "Share Russian speakers, taking into account rural/urban origin, 1931"
 label var anc_Lang_ukranian_1931 "Share Ukrainian speakers, taking into account rural/urban origin, 1931"
 label var anc_literate_1931 "Literacy rate,taking into account rural/urban origin, 1931"
 label var anc_urbanization_1931 "Urbanization rate, 1931 (std)"
 label var anc_literate_1921  "Literacy rate,taking into account rural/urban origin, 1921"
 label var anc_lit_rcath_1921 "Literacy rate Rom. Cath.,taking into account rural/urban origin, 1921"
 label var anc_r_catholic_1921  "Share Rom. Cath.,taking into account rural/urban origin, 1921"
 
 
save "${path}/Data/generated_data/ancestry_anclevel_replicate.dta", replace 

/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/
/****************  PREPARE DATASET: DIAGNOZA   ******************************/
/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/

/* begin of quietly */
 quietly {  
	
use "${path}/Data/original_data/diagnoza_2015.dta", clear

merge m:1 powiaty_code using "${path}/Data/original_data/powiaty_history_geography.dta"


drop if _merge==2
drop _merge

compress

**** Places per respondent where Kresy people are coming from 
**** add historical information for these places

gen powiaty_orgin_kresy_1=""
gen powiaty_orgin_kresy_2=""
gen powiaty_orgin_kresy_3=""
replace powiaty_orgin_kresy_1=pow_code_19311

replace powiaty_orgin_kresy_1=pow_code_19312 if powiaty_orgin_kresy_1==""
replace powiaty_orgin_kresy_1=pow_code_19313 if powiaty_orgin_kresy_1==""
replace powiaty_orgin_kresy_2=pow_code_19312 if powiaty_orgin_kresy_1!=pow_code_19312&powiaty_orgin_kresy_2==""
replace powiaty_orgin_kresy_2=pow_code_19313 if powiaty_orgin_kresy_1!=pow_code_19313&powiaty_orgin_kresy_2==""
replace powiaty_orgin_kresy_3=pow_code_19313 if powiaty_orgin_kresy_1!=pow_code_19313&powiaty_orgin_kresy_2!=pow_code_19313&powiaty_orgin_kresy_3==""

cap drop powiaty_code_1931
gen powiaty_code_1931=powiaty_orgin_kresy_1
merge m:1 powiaty_code_1931 using "${path}/Data/original_data/1931_pow_curzon_line_distance.dta"
drop if _merge==2
drop _merge
rename disCursLineKm dist_CurzLineKm_1

merge m:1 powiaty_code_1931 using "${path}/Data/original_data/centeroid_pow_1931.dta"
drop if _merge==2
drop _merge
rename lat_1931 lat_1931_1 
rename lon_1931 lon_1931_1

replace powiaty_code_1931=powiaty_orgin_kresy_2

merge m:1 powiaty_code_1931 using "${path}/Data/original_data/1931_pow_curzon_line_distance.dta"
drop if _merge==2
drop _merge
rename disCursLineKm dist_CurzLineKm_2

merge m:1 powiaty_code_1931 using "${path}/Data/original_data/centeroid_pow_1931.dta"
drop if _merge==2
drop _merge
rename lat_1931 lat_1931_2 
rename lon_1931 lon_1931_2

replace powiaty_code_1931=powiaty_orgin_kresy_3

merge m:1 powiaty_code_1931 using "${path}/Data/original_data/1931_pow_curzon_line_distance.dta"
drop if _merge==2
drop _merge
rename disCursLineKm dist_CurzLineKm_3

merge m:1 powiaty_code_1931 using "${path}/Data/original_data/centeroid_pow_1931.dta"
drop if _merge==2
drop _merge
rename lat_1931 lat_1931_3 
rename lon_1931 lon_1931_3

egen origin_max_dist_CurzLine=rowmax(dist_CurzLineKm_1 dist_CurzLineKm_2 dist_CurzLineKm_3)
label var origin_max_dist_CurzLine "anc max dist to Curzon Line"

egen origin_mean_dist_CurzLine=rowmean(dist_CurzLineKm_1 dist_CurzLineKm_2 dist_CurzLineKm_3)
label var origin_mean_dist_CurzLine "anc mean dist to Curzon Line"

merge m:1 powiaty_code using "${path}/Data/original_data/current_powiaty_curzon_line_distance.dta"
drop if _merge==2
drop _merge

rename disCursLineKm resp_dist_pow_CurzLineKm
label var resp_dist_pow_CurzLineKm "resp dist to Curzon Line"

gen max_dist_CurzLine=-resp_dist_pow_CurzLineKm if anybody_from_kresy==0
replace max_dist_CurzLine=origin_max_dist_CurzLine if anybody_from_kresy==1
gen max_dist_CurzLine_kresy=max_dist_CurzLine*anybody_from_kresy

egen latitude_running=rmean(lat_1931_1 lat_1931_2 lat_1931_3)
egen longitude_running=rmean(lon_1931_1 lon_1931_2 lon_1931_3)

replace latitude_running=latitude if anybody_from_kresy==0
replace longitude_running=longitude if anybody_from_kresy==0

label var latitude_running "latitude for RDD"
label var longitude_running "longitude for RDD"

gen latitude_running_sq=latitude_running^2
gen longitude_running_sq=longitude_running^2
gen lat_x_long = latitude_running*longitude_running
gen lat_x_longsq = latitude_running*longitude_running_sq
gen latsq_x_long = latitude_running_sq*longitude_running
gen latsq_x_longsq = latitude_running_sq*longitude_running_sq

gen latitude_running_3=latitude_running^3
gen longitude_running_3=longitude_running^3

gen dist_CurzLine = max_dist_CurzLine
gen dist_CurzLine_sq = max_dist_CurzLine^2
gen dist_CurzLine_cub = max_dist_CurzLine^3

*only for regression output reporting FE's:

gen pow_FE_indicator=1 if  powiaty_code~=.
gen gminy_FE_indicator=1 if  gminy_code~=.
gen woj_FE_indicator=1 if  woj~=.

**** merge variables for diversity for non-kresy origin

cap drop powiaty_code_1931
merge m:1 powiaty_code using "${path}/Data/original_data/powiaty_code_today_1931.dta"
drop _merge
merge m:1 powiaty_code_1931 using "${path}/Data/original_data/1931_census_percentages_with_kresy_dummy.dta"
drop _merge

gen share_autochthons=autochtons_t/population_powiat_1950_t
label var share_autochthons "Share of autochthons"


******create birth cohorts 
gen birth_pre1930=.
replace birth_pre1930=1 if age>85 & age~=.
replace birth_pre1930=0 if age<=85 & age~=.

gen birth_1930s=.
replace birth_1930s=1 if age>75 & age<=85 
replace birth_1930s=0 if (age<=75) | (age>85 & age~=.)

gen birth_1940s=.
replace birth_1940s=1 if age>65 & age<=75 
replace birth_1940s=0 if (age<=65) | (age>75 & age~=.)

gen birth_1950s=.
replace birth_1950s=1 if age>55 & age<=65 
replace birth_1950s=0 if (age<=55) | (age>65 & age~=.)

gen birth_1960s=.
replace birth_1960s=1 if age>45 & age<=55 
replace birth_1960s=0 if (age<=45) | (age>55 & age~=.)

gen birth_1970s=.
replace birth_1970s=1 if age>35 & age<=45 
replace birth_1970s=0 if (age<=35) | (age>45 & age~=.)

gen birth_1980s=.
replace birth_1980s=1 if age>25 & age<=35 
replace birth_1980s=0 if (age<=25) | (age>35 & age~=.)

gen birth_1990s=.
replace birth_1990s=1 if age>15 & age<=25 
replace birth_1990s=0 if (age<=15) | (age>25 & age~=.)

**Number of children in HH:
gen nb_childrenless16_hh= nb_pers_hh-nb_persmore15_hh
drop if nb_childrenless16_hh<0
gen share_younger_16HH = nb_childrenless16_hh/nb_pers_hh
label var nb_childrenless16_hh "Number of children below 16 in HH"
label var share_younger_16HH "Share of children below 16 in HH"

**************************************************************************************
******  Occupations:

*** note that entrepreneur_status unemployed_status farmer_status employee_status not_working_status dummies come from empl_status status variable

gen white_collar=0
replace white_collar=1 if occupation_isco_active==1|occupation_isco_active==2|occupation_isco_active==3|occupation_isco_active==4|occupation_isco_active==5
replace white_collar=1 if white_collar==.&F_ZAWOD_AKTYWNI_SKR<432&F_ZAWOD_AKTYWNI_SKR!=.
replace white_collar=. if F_ZAWOD_AKTYWNI_SKR==.&occupation_isco_active==.


************ Aspiration for education
gen high_aspiration_edu = 1 if aspiration_educhildren==5
recode high_aspiration_edu .=0 if aspiration_educhildren~=.
label var high_aspiration_edu "High aspiration (5 of 5) for childrens' education"

********** Assets owned by households for financial and non-financial reasons:**************************

***  Sum of all assets that the respondent owns:
egen sum_physical_assests=rsum(own_wash_machine own_dishwasher own_microwave own_plasmaTV own_cable_satelliteTV own_DVDplayer own_homecinema own_summer_house own_desktop_computer own_laptop_computer own_tablet own_car own_ebook own_internet_access own_landphone own_boat own_garden_plot own_flat own_house own_other_property)

*** Generate dummies for whether respondent does not own an item and it is not for financial reasons
foreach var in no_washmachine_nofin no_dishwasher_nofin no_boat_nofin no_microwave_nofin no_plasmaTV_nofin no_cableTV_nofin no_DVDplayer_nofin no_homecinema_nofin no_summer_house_nofin no_deskcomputer_nofin no_laptop_nofin no_tablet_nofin no_car_nofin no_ebook_nofin no_internetacc_nofin no_landphone_nofin no_garden_plot_nofin no_flat_nofin no_house_nofin no_other_property_nofin{
replace `var'=1-`var'
label var `var' "does not own, but not for financial reasons"
}
*** Sum of how many assest respondent does not own, but for non-financial reasons:
egen sum_non_financial_reason=rsum(no_washmachine_nofin no_dishwasher_nofin no_boat_nofin  no_microwave_nofin no_plasmaTV_nofin no_cableTV_nofin no_DVDplayer_nofin no_homecinema_nofin no_summer_house_nofin no_deskcomputer_nofin no_laptop_nofin no_tablet_nofin no_car_nofin no_ebook_nofin no_internetacc_nofin no_landphone_nofin no_garden_plot_nofin no_flat_nofin no_house_nofin no_other_property_nofin)

*Share of assets that the household does not own for non-fincancial reasons (=total assets not owned for non-financial reasons / total assets not owned)
gen share_not_owned_NFR = sum_non_financial_reason/(20-sum_physical_assests)
replace share_not_owned_NFR =. if share_not_owned_NFR>1 | sum_physical_assests==0
label var share_not_owned_NFR "Share of assets not owned for non-financial reasons"
*********************************************************************************************************

gen lnedu_years = ln(edu_years)
label var lnedu_years "ln(years of education)"
label var anybody_from_kresy "Ancestor from Kresy"
label var WT "Western Territory"

label var edu_years "Years of education"

label define eduk4 1 "Primary or less" 2 "Vocational / incompl. secondary" 3 "Secondary" 4 "More than secondary"
label values eduk4 eduk4

drop if year~=2015

**** focus on adults
drop if age<16

**** generate age controls:

foreach var in birth_pre1930 birth_1930s birth_1940s birth_1950s birth_1960s birth_1970s birth_1980s birth_1990s{ 
gen age_`var'=female*`var'
gen age_sq_`var'=female*age*`var'
}

****************************************************
****** Financial and savings variables:
****************************************************

**** purpose 6 and 7 are almost the same -- medical purpose -- so merge them:
replace purpose6_savings=purpose6_savings|purpose7_savings
replace purpose6_savings=. if purpose7_savings==.
label var purpose6_savings "medical treatment or rehabilitation"

**** clean value of savings variable:		
replace value_of_savings=. if  value_of_savings==7
replace value_of_savings=0 if hh_savings==0

*** generate dummies for two types of financial investments - cash and other super-liquid safe assets and risky financial investment: 
gen save_liquid_assets =  (cash==1|  bank_deposit_PLN ==1| bank_deposit_foreign==1| personal_current_account==1| savings_account ==1)
replace save_liquid_assets=. if cash==.&  bank_deposit_PLN ==.& bank_deposit_foreign==.& personal_current_account==.& savings_account ==.
label var save_liquid_assets "savings in cash and bank liquid deposits"
gen save_financial_investment = (bonds==1|  invest_funds==1|  ind_pension_fund==1|  employee_pension_fund==1|  securities_SE==1|  securities_not_SE==1|  insurance_policy==1)
replace save_financial_investment =. if  (bonds==.&  invest_funds==.&  ind_pension_fund==.&  employee_pension_fund==.&  securities_SE==.& securities_not_SE==.&  insurance_policy==.)
label var save_financial_investment "savings in stocks, bonds, and other risky instruments"

foreach var in have_ins_group have_ins_life have_ins_3rdpers have_ins_car have_ins_healthtravel{
replace `var'=0 if have_insurance==0 
}

/* end quietly */
}


global base_controls "WT age_birth* age_sq_birth* female rural city" 
local list_birth_cohort "birth_pre1930 birth_1930s birth_1940s birth_1950s birth_1960s birth_1970s birth_1980s birth_1990s"
local list1 "high_aspiration_edu material_goods_lifesuccess_d successful_life_freedom"
local poly_lat_long "latitude_running longitude_running latitude_running_sq longitude_running_sq lat_x_long"
label var powiaty_code "powiaty code" 
keep $base_controls `list_birth_cohort' `list1' `poly_lat_long' edu_years higher_edu secondary_edu  lnedu_years   anybody_from_kresy rural WT  student_status powiaty_code   hh ///
     max_dist_CurzLine dist_CurzLine  perc_lan_polish1900 rural pow_FE_indicator gminy_FE_indicator WT share_not_owned_NFR log_hhincome ///
	 pensioner_status share_younger_16HH  nb_childrenless16_hh white_collar  unemployed_status  female rural city age_birth* age_sq_birth* hh_savings     ///
	 purpose* have_insurance smoking share_autochthons migr_ussr_1955_1959 ussr_1939 intend_go_abroad woj gminy_code name_wojewodztwa1952 perc_ussr_all population1950  powiat_1952 population_powiat_1950_t from_USRR_t  name_wojewodztwa1952
	 
label var intend_go_abroad "Intend to go abroad"
label var WT "Dummy for Western Territories"

 label var age_birth_pre1930 "age, respondent born before 1930"
 label var age_sq_birth_pre1930 "age squared, respondent born before 1930"
 label var  birth_pre1930 "dummy, respondent born before 1930"
 foreach values in 1930 1940 1950 1960 1970 1980 1990 {
 label var  birth_`values's "dummy, respondent born in the `values's"
 label var age_birth_`values's "age, respondent born in the `values's"
 label var age_sq_birth_`values's "age squared, respondent born in the `values's"
}

label var have_insurance "do you have insurance"
label define yesnovalues 0 "no" 1 "yes"
label values  have_insurance yesnovalues
label values  smoking yesnovalues

label var material_goods_lifesuccess_d "Main condition for success in life: possession of material goods"
label values  material_goods_lifesuccess_d yesnovalues

label var pensioner_status "employment status of respondent: pensioner"
label var student_status  "employment status of respondent: student"
label var unemployed_status "employment status of respondent: unemployed"

label var hh_savings "do you have savings" 
foreach x in  pensioner_status student_status unemployed_status hh_savings  intend_go_abroad_for_work {
label values  `x' yesnovalues
}
label var latitude_running_sq "latitude squared for RDD"
label var longitude_running_sq "longitude squared for RDD"
label var max_dist_CurzLine "distance to Curzon line" 
label var  dist_CurzLine "distance to Curzon line" 
label var lat_x_long "latitude*longitude"

label var pow_FE_indicator "powiaty, fixed effect indicator" 
label var gminy_FE_indicator "gminy, fixed effect indicator" 

label var white_collar "white collar occupation"

order higher_edu, after (secondary_edu)
order edu_years, after ( higher_edu)
order lnedu_years, after (edu_years)

order birth_pre1930-birth_1990s, before(age_birth_pre1930)

label var name_wojewodztwa1952 "name woj. 1952"

save "${path}/Data/generated_data/diagnoza_replicate.dta", replace 

/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/
/****************  PREPARE DATASET: LITS  ******************************/
/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/

/* begin of quietly */
quietly{
	
use  "${path}/Data/original_data/LiTS_Poland_Ukraine_Belarus_Lithuania_geocoded", clear
 
*** Keep only title ethnicities in these countries:
keep if q923_ethnicity=="Belarusian"| q923_ethnicity=="Lithuanian"|q923_ethnicity=="Pole"|q923_ethnicity=="Ukrainian"

*** Keep only if title ethnicity lives in the respective country:
keep if (q923_ethnicity=="Belarusian"&country=="Belarus")| (q923_ethnicity=="Lithuanian"&country=="Lithuania")|(q923_ethnicity=="Pole"&country=="Poland")|(q923_ethnicity=="Ukrainian"&country=="Ukraine")

************************************************************************************************
********  Generate dummy for anybody from Kresy
************************************************************************************************

gen crude_father=(q907a=="belarus"|q907a=="lithuania"|q907a=="russia"|q907a=="ukraine")
replace crude_father=. if country!="Poland"

gen crude_mother=(q906a=="belarus"|q906a=="lithuania"|q906a=="russia"|q906a=="ukraine")
replace crude_mother=. if country!="Poland"

gen crude_anybody_kresy=1 if crude_mother==1|crude_father==1

replace crude_anybody_kresy=0 if crude_mother==0&crude_father==0

gen mother_from_kresy=crude_mother
replace mother_from_kresy=1 if country=="Poland"&(q906b=="kijow"| q906b=="lw?w"|q906b=="lwow"|q906b=="wilenszczyzna"|q906b=="wilno")
replace mother_from_kresy=. if country!="Poland"


gen father_from_kresy=crude_father
replace father_from_kresy=1 if country=="Poland"&(q907b=="wilenskie"|q907b=="wilno"|q907b=="wolynskie"|q907b=="zytomierz"|q907b=="kresywschodnie"|q907b=="stanislaw?w")
replace father_from_kresy=. if country!="Poland"

gen anybody_from_kresy=crude_anybody_kresy
replace anybody_from_kresy=1 if country=="Poland"&(q906b=="kijow"| q906b=="lw?w"|q906b=="lwow"|q906b=="wilenszczyzna"|q906b=="wilno")
replace anybody_from_kresy=1 if country=="Poland"&(q907b=="wilenskie"|q907b=="wilno"|q907b=="wolynskie"|q907b=="zytomierz"|q907b=="kresywschodnie"|q907b=="stanislaw?w")
replace anybody_from_kresy=. if country!="Poland"

drop crude_anybody_kresy  crude_father crude_mother


************************************************************************************************
********  Generate education outcome variables
************************************************************************************************


gen higher_edu=(q109_1>5)
replace higher_edu=. if  q109_1==.
gen secondary_edu=(q109_1>4)
replace secondary_edu=. if  q109_1==.
gen age_pr_sq = age_pr^2

*Impute years of edu from average years corresponding to each degree (as computed in Diagnoza)
gen edu_years = .
replace edu_years =  7 if q109_1==2
replace edu_years = 10 if q109_1==3
replace edu_years = 12 if q109_1==4
replace edu_years = 14 if q109_1==5
replace edu_years = 17 if q109_1>5

drop if edu_years==.

************************************************************************************************
********  Generate WWII experience variables : whether family members were killed/injured or displaced
************************************************************************************************

gen displaced_WWII=q924b
gen killed_injured_WWII=q924a
recode displaced_WWII -99 -97 =. 2 =0
recode killed_injured_WWII -99 -97 =. 2 =0

*** Generate WWII experience variables, which are defined on the whole sample (replacing the few missing with zeros) 
gen killed_injured_WWII_full=(killed_injured_WWII==1)
gen displaced_WWII_full=(displaced_WWII==1)

************************************************************************************************
********  Generate woj dummies 
************************************************************************************************

egen woj=group(region_name)
gen woj_FE_indicator=1 if  woj~=.

************************************************************************************************
********  Generate variables needed for RDD at the polish (Kresy) border:
************************************************************************************************

**** generate the cross-term for spatial RDD:
**** current location:
gen lat_lon=latitude*longitude

**** origin location:
gen origin_lat=(q906_lat+q907_lat)/2
replace origin_lat=q906_lat if mother_from_kresy&!father_from_kresy
replace origin_lat=q907_lat if father_from_kresy&!mother_from_kresy

gen origin_lon=(q906_lon+q907_lon)/2
replace origin_lon=q906_lon if mother_from_kresy&!father_from_kresy
replace origin_lon=q907_lon if father_from_kresy&!mother_from_kresy

gen origin_lon_lat=origin_lat*origin_lon
gen origin_lon_sq=origin_lon*origin_lon
gen origin_lat_sq=origin_lat*origin_lat

gen dummy_Kresy_border=(country=="Poland")

************************************************************************************************
********  Generate variables indicating stayers (i.e., those people whose ancestors lived in the same coutnry as the respondent:
************************************************************************************************

**** generate the ancestors from same country dummy 
gen ancestors_same_country=(q906_sameCountry==1&q907_sameCountry==1)&anybody_from_kresy!=1


************************************************************************************************
***** urban/rural origin
************************************************************************************************
gen urban_mother=(q906c==1) if q906c!=.
label var urban_mother "Mother origin urban"
gen urban_father=(q907c==1) if q907c!=.
label var urban_father "Father origin urban"

label var anybody_from_kresy "Ancestor from Kresy"
label var killed_injured_WWII_full "Family killed or injured in WWII (missing = 0)"
label var killed_injured_WWII "Family killed or injured in WWII"
label var displaced_WWII_full "Family forcibly displaced in WWII"

gen female=(gender_pr==2)

******create birth cohorts 

gen birth_year=2016-age_pr

gen birth_pre1930=.
replace birth_pre1930=1 if birth_year<1930 
replace birth_pre1930=0 if birth_year>=1930 & birth_year~=.

gen birth_1930s=.
replace birth_1930s=1 if birth_year>=1930 & birth_year< 1940 
replace birth_1930s=0 if birth_year<1930 | (birth_year>=1940& birth_year~=.)

gen birth_1940s=.
replace birth_1940s=1 if birth_year>=1940 & birth_year< 1950 
replace birth_1940s=0 if birth_year<1940 | (birth_year>=1950& birth_year~=.)

gen birth_1950s=.
replace birth_1950s=1 if birth_year>=1950 & birth_year< 1960  
replace birth_1950s=0 if birth_year<1950 | (birth_year>=1960& birth_year~=.)

gen birth_1960s=.
replace birth_1960s=1 if birth_year>=1960 & birth_year< 1970  
replace birth_1960s=0 if birth_year<1960 | (birth_year>=1970& birth_year~=.)

gen birth_1970s=.
replace birth_1970s=1 if birth_year>=1970 & birth_year< 1980  
replace birth_1970s=0 if birth_year<1970 | (birth_year>=1980& birth_year~=.)

gen birth_1980s=.
replace birth_1980s=1 if birth_year>=1980 & birth_year< 1990  
replace birth_1980s=0 if birth_year<1980 | (birth_year>=1990& birth_year~=.)

gen birth_1990s=.
replace birth_1990s=1 if birth_year>=1990 & birth_year< 2000  
replace birth_1990s=0 if birth_year<1990 | (birth_year>=2000& birth_year~=.)

**** generate age controls
foreach var in birth_pre1930 birth_1930s birth_1940s birth_1950s birth_1960s birth_1970s birth_1980s birth_1990s{ 
gen age_`var'=age_pr*`var'
}
     
foreach var in birth_pre1930 birth_1930s birth_1940s birth_1950s birth_1960s birth_1970s birth_1980s birth_1990s{ 
gen age_sq_`var'=age_pr_sq*`var'
}

gen WT= (region_name=="dolnośląskie"|region_name=="lubuskie"|region_name=="opolskie"|region_name=="pomorskie"|region_name=="warmińsko-mazurskie"|region_name=="zachodniopomorskie") 

}
/* end of quietly */

keep country WT age_birth* age_sq_birth* female urban_mother urban_father urban ///
edu_years  secondary_edu anybody_from_kresy  higher_edu  woj* ///
killed_injured_WWII_full killed_injured_WWII  q428  PSU_name 

keep if country=="Poland" 

label var higher_edu "Higher education dummy" 
label var secondary_edu "Secondary education dummy" 
label var edu_years "Years of education"
label var WT "Western Territory dummy"
label var female "female respondent" 

label var age_birth_pre1930 "age, respondent born before 1930"
 label var age_sq_birth_pre1930 "age squared, respondent born before 1930"

 foreach values in 1930 1940 1950 1960 1970 1980 1990 {
 label var age_birth_`values's "age, respondent born in the `values's"
 label var age_sq_birth_`values's "age squared, respondent born in the `values's"
}

label var woj_FE_indicator "wojewodztwo (region), fixed effect indicator" 
label var woj "wojewodztwo (region), group indicator" 
label var country "country"

save "${path}/Data/generated_data/LiTS_replicate.dta", replace 

