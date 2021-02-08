
clear all
set matsize 5000
set more off
	

**********************************************************************************************************
******* GENERATE COMMUNITY VARIABLE -- Note: This part of the code runs several hours!
**********************************************************************************************************

*** note that lines 16-62 generate community.dta, they are commented out as
*** this part of the code takes a long time, one can skip it, 
*** as these data can be found here: "${path}/Data/generated_data/community.dta"
*** the code runs both with and without commenting these lines out


		use "${path}/Data/generated_data/anc_level_data.dta", clear

		set matsize 11000

		cap drop city 
		cap drop age_sq

		gen city=1 if strpos(gmina, "M. ")
		replace city=0 if city==.

		gen age_sq=age*age

		gen anc_pow_code1931_short=subinstr(anc_pow_code1931_use,"P","",1)
		gen anc_pow_code1931_num=real(anc_pow_code1931_short)
		gen num_anc=.


		***** calculate for each ancestor how many people came from the same place

		*qui{
		forvalues anc_id = 1(1)14530 {
		qui sum gminy_code if id_ancestor==`anc_id'
		qui local gmina=r(mean)
		qui sum anc_pow_code1931_num if id_ancestor==`anc_id'
		qui local origin=r(mean)

		qui cap drop id_ancestor_count
		qui cap drop id_ancestor_max 
		qui egen id_ancestor_count=count(id_ancestor) if gminy_code==`gmina'&anc_pow_code1931_num==`origin'&typ_proby==1
		qui egen id_ancestor_max=max(id_ancestor_count)
		qui replace num_anc=id_ancestor_max if id_ancestor==`anc_id'
		dis `anc_id'
		}
		*}


		replace num_anc=. if anc_pow_code1931_use==""


		keep id_ancestor num_anc
		label var num_anc "community"

		save "${path}/Data/generated_data/community.dta", replace


*/
		
**********************************************************************************************************
***************      Table A.23   *************************************************
**********************************************************************************************************	
use "${path}/Data/generated_data/ancestry_anclevel_replicate.dta", clear

global base_controls "age_birth* age_sq_birth* female rural city" 
global anc_controls "anc_in_wt anc_abroad rural_anc2 d_anc2 d_anc3" 

sort id_ancestor
merge 1:1 id_ancestor using "${path}/Data/generated_data/community.dta" 
drop _merge

gen num_anc_m1 = num_anc - 1 // num_anc includes respondent's ancestor herself, so subtract 1 
bysort gminy_code: egen total_anc_gminy1 = count(id_ancestor) if typ_proby==1 & anc_pow_code1931_use!="" //use only the number of ancestors in the typ_proby==1 (representative sample) and who came from SPR with a known location (i.e., anc_pow_code1931_use!="").
egen total_anc_gminy = max(total_anc_gminy1), by(gminy_code)

label var num_anc_m1 "Size of ancestor community$^{\#}$"
label var total_anc_gminy "Total ancestors in sample"
*label var share_anc_m1 "\% ancestors from same origin$^{\dag}$"

estimates clear
/*1*/eststo: reg num_anc_m1     anc_in_kresy            total_anc_gminy  $base_controls $anc_controls i.powiaty_code, cl(gminy_code)
estadd ysumm
/*2*/eststo: reg edu_years      anc_in_kresy                             $base_controls $anc_controls i.powiaty_code  if num_anc_m1~=., cl(gminy_code)
estadd ysumm
/*3*/eststo: reg edu_years      anc_in_kresy num_anc_m1 total_anc_gminy  $base_controls $anc_controls i.powiaty_code, cl(gminy_code)
estadd ysumm
/*4*/eststo: reg secondary_edu  anc_in_kresy num_anc_m1 total_anc_gminy  $base_controls $anc_controls i.powiaty_code, cl(gminy_code)
estadd ysumm
/*5*/eststo: reg higher_edu 	anc_in_kresy num_anc_m1 total_anc_gminy  $base_controls $anc_controls i.powiaty_code, cl(gminy_code)
estadd ysumm
estout using "${path}/Results/Tables/Table_A23.tex", replace ///
				keep($show anc_in_kresy num_anc_m1 total_anc_gminy) label ///
                order(anc_in_kresy num_anc_m1 total_anc_gminy) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))   style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.85cm] Ancestor Controls$^{\dag}$=d_anc2" "\\[-0.75cm] Respondent County FE=age_birth_1960s", labels("{\checkmark}" "{ }"))	
	
