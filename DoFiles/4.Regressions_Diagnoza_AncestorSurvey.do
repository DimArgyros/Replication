**************************************************************************************
**************************************************************************************
clear all
set matsize 5000
set more off

**************************************************************************************
*********** 	Table A.18                          ***********************************
**************************************************************************************

 
**** 1/ calculate education level by powiat from Diagnoza for people in Central Poland with no ancestors from Kresy : pow_eduk4_CPnokresy

use "${path}/Data/original_data/diagnoza_2015.dta", clear

collapse (mean) pow_eduk4_CPnokresy=eduk4 pow_secondary_edu_CPnokresy=secondary_edu pow_higher_edu_CPnokresy=higher_edu pow_edu_years_CPnokresy=edu_years if  anybody_from_kresy==0 , by(powiaty_code)

sort powiaty_code
save "${path}/Data/generated_data/temp1", replace

****2/ calculate education level by powiat from Diagnoza for people in Central Poland with no ancestors from Kresy and rural : pow_eduk4_CPnokresy_rural

use "${path}/Data/original_data/diagnoza_2015.dta", clear 

collapse (mean) pow_eduk4_CPnokresy_rural=eduk4 pow_secondary_edu_CPnokresy_r=secondary_edu pow_higher_edu_CPnokresy_r=higher_edu pow_edu_years_CPnokresy_rural=edu_years if  anybody_from_kresy==0 & rural==1, by(powiaty_code)

sort powiaty_code

save "${path}/Data/generated_data/temp2", replace

****3/ calculate education level by powiat from Diagnoza for people in Central Poland with no ancestors from Kresy and urban : pow_eduk4_CPnokresy_urban

use "${path}/Data/original_data/diagnoza_2015.dta", clear 

collapse (mean) pow_eduk4_CPnokresy_urban=eduk4 pow_secondary_edu_CPnokresy_u=secondary_edu pow_higher_edu_CPnokresy_u=higher_edu pow_edu_years_CPnokresy_urban=edu_years if year==2015 & anybody_from_kresy==0 & rural==0, by(powiaty_code)

sort powiaty_code

save "${path}/Data/generated_data/temp3", replace

 /**********************************************/

use  "${path}/Data/original_data/centeroid_of_pow_1931_in_powiaty_today.dta", clear 
destring powiaty_code_str, gen(powiaty_code)

gen pow_code1931_origin= pow_code_1931

merge m:1 powiaty_code  using "${path}/Data/generated_data/temp1"
keep if pow_code1931_origin!="" 
drop _merge
sort powiaty_code
merge m:1 powiaty_code  using "${path}/Data/generated_data/temp2"
keep if pow_code1931_origin!="" 
drop _merge
sort powiaty_code
merge m:1 powiaty_code  using "${path}/Data/generated_data/temp3"
keep if pow_code1931_origin!="" 
drop _merge
sort powiaty_code

drop powiaty_code powiaty_code_str pow_code1931_origin

rename pow_code_1931 anc_pow_code1931_use

save "${path}/Data/generated_data/edu_diagnoza_non_migrants", replace

erase "${path}/Data/generated_data/temp1.dta" 
erase "${path}/Data/generated_data/temp2.dta" 
erase "${path}/Data/generated_data/temp3.dta" 

/******************************************************************/

use "${path}/Data/generated_data/ancestry_anclevel_replicate.dta", clear 
cap drop city
cap drop age_sq

gen city=1 if strpos(gmina, "M. ")
replace city=0 if city==.

gen age_sq=age*age

merge m:1 anc_pow_code1931_use using "${path}/Data/generated_data/edu_diagnoza_non_migrants"
drop _merge 


gen WarsawKrakow = 1 if (anc_pow_code1931_use==" P000"|anc_pow_code1931_use== "P0322") | (anc_pow_code1931_use== "P0709"|anc_pow_code1931_use== "P0710") //Warszawa and Krakow powiaty
recode WarsawKrakow .=0
label var WarsawKrakow "Warsaw or Krakow"

set matsize 11000

label var pow_eduk4_CPnokresy  "education in powiat of origin in CP from Diagnoza no kresy origin"
label var pow_secondary_edu_CPnokresy "education in powiat of origin in CP from Diagnoza with no kresy origin"
label var pow_higher_edu_CPnokresy "education in powiat of origin in CP from Diagnoza with no kresy origin"
label var pow_edu_years_CPnokresy "education in powiat of origin in CP from Diagnoza with no kresy origin"

label var pow_eduk4_CPnokresy_rural  "education among rural in powiat of origin in CP from Diagnoza no kresy origin"
label var pow_secondary_edu_CPnokresy_r "education among rural in powiat of origin in CP from Diagnoza with no kresy origin"
label var pow_higher_edu_CPnokresy_r "education among rural in powiat of origin in CP from Diagnoza with no kresy origin"
label var pow_edu_years_CPnokresy_r "education among rural in powiat of origin in CP from Diagnoza with no kresy origin"

label var pow_eduk4_CPnokresy_urban  "education among urban in powiat of origin in CP from Diagnoza no kresy origin"
label var pow_secondary_edu_CPnokresy_u "education  among urban  in powiat of origin in CP from Diagnoza with no kresy origin"
label var pow_higher_edu_CPnokresy_u "education  among urban  in powiat of origin in CP from Diagnoza with no kresy origin"
label var pow_edu_years_CPnokresy_u "education  among urban  in powiat of origin in CP from Diagnoza with no kresy origin"


*** total powiat-level education:
gen diff_sec_fromCP=secondary_edu-pow_secondary_edu_CPnokresy if anc_in_cp==1 & anc1==2 //anc1==2 indicates that ancestors in CBOS survey are from CP
gen diff_high_fromCP=higher_edu-pow_higher_edu_CPnokresy if anc_in_cp==1 & anc1==2

*** urban origin and urban destination:
gen diff_sec_fromCP_uu=secondary_edu-pow_secondary_edu_CPnokresy_u if anc_in_cp==1 & anc1==2 & urban_anc2==1 & rural==0 //urban_anc2==1 indicates ancestor from urban origin in CBOS; rural==0 indicates urban location (destination) of CBOS respondents
gen diff_high_fromCP_uu=higher_edu-pow_higher_edu_CPnokresy_u if anc_in_cp==1 & anc1==2 & urban_anc2==1 & rural==0 

*** rural origin and rural destination:
gen diff_sec_fromCP_rr=secondary_edu-pow_secondary_edu_CPnokresy_r if anc_in_cp==1 & anc1==2 & rural_anc2==1 & rural==1 //rural_anc2==1 indicates ancestor from rural origin in CBOS; rural==1 indicates rural location (destination) of CBOS respondents
gen diff_high_fromCP_rr=higher_edu-pow_higher_edu_CPnokresy_r if anc_in_cp==1 & anc1==2 & rural_anc2==1 & rural==1

*** urban origin and rural destination:
gen diff_sec_fromCP_ur=secondary_edu-pow_secondary_edu_CPnokresy_u if anc_in_cp==1 & anc1==2 & urban_anc2==1 & rural==1 //urban_anc2==1 indicates ancestor from urban origin in CBOS; rural==1 indicates rural location (destination) of CBOS respondents
gen diff_high_fromCP_ur=higher_edu-pow_higher_edu_CPnokresy_u if anc_in_cp==1 & anc1==2 & urban_anc2==1 & rural==1

*** rural origin and urban destination:
gen diff_sec_fromCP_ru=secondary_edu-pow_secondary_edu_CPnokresy_r if anc_in_cp==1 & anc1==2 & rural_anc2==1 & rural==0 //rural_anc2==1 indicates ancestor from rural origin in CBOS; rural==0 indicates urban location (destination) of CBOS respondents
gen diff_high_fromCP_ru=higher_edu-pow_higher_edu_CPnokresy_r if anc_in_cp==1 & anc1==2 & rural_anc2==1 & rural==0

gen one=1
label var one "$\Delta Edu(i)$"

 


preserve

collapse diff_sec_fromCP-diff_high_fromCP_ru PL_central_poland_origin_only, by(numer_ankiety)

sort numer_ankiety

gen one=1
label var one "$\Delta Edu(i)$"

estimates clear
foreach diff of varlist diff_sec_fromCP-diff_high_fromCP_rr {
eststo: reg `diff' one if PL_central_poland_origin_only==1, nocons cluster(numer_ankiety) 
}
estout using "${path}/Results/Tables/Table_A18.tex", replace ///
				keep($show) label ///
                order($show ) prefoot("\hline") stats(N, layout(@ "\multicolumn{1}{c}{@}") fmt(%9.0gc) labels("Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))   style(tex) collabels(none)

*For note: Strong positive coeff for rural-->urban; negative coeff for urban-->rural. This is not absorbed here, because we can't include location FE. 
estimates clear
foreach diff of varlist diff_sec_fromCP_ur-diff_high_fromCP_ru {
eststo: reg `diff' one if PL_central_poland_origin_only==1, nocons cluster(numer_ankiety) 
}				
				
restore

clear




