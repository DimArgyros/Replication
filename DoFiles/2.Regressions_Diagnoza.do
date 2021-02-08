clear all
set matsize 5000
set more off

******************************************************************************************************************************************************************************************************************************

*    Diagnoza 

******************************************************************************************************************************************************************************************************************************
*
use "${path}/Data/generated_data/diagnoza_replicate.dta", clear

global base_controls "WT age_birth* age_sq_birth* female rural city" 

*** Control for WT is redundant in specifications with region, county, or municipality fixed effects. In a few cases however, we report estimations in which WT baseline control is relevant 
*******************************************************************************************

**************************************************************************************************************************************************************************
***********      FIGURES IN THE PAPER  ************************************************************************************************************************
***********************************************************************************************************************************************************************************	

*******************************************************************************************
***********      Figure 1: DESCRIPTIVE MAP, DOES NOT REQUIRE REPLICATION      *******************************************
**********************************************************************************************************

*******************************************************************************************
***********      Figure 2: Results Overview      *******************************************
**********************************************************************************************************

* Descriptive statistics Left Panel
preserve
use "${path}/Data/original_data/1921_census_pow_for_kresy_survey.dta", clear
rename powiaty_code1931 powiaty_code_1931

merge 1:1 powiaty_code_1931 using "${path}/Data/original_data/1931_census_percentages_with_kresy_dummy.dta"

keep powiaty_code_1931 lit_rcath_1921_t lit_rcath_1921_u lit_rcath_1921_r in_kresy total_pop_u total_pop_t total_pop_r

*** NUMBERS FOR FIGURE 2:
* total:
sum lit_rcath_1921_t [aweight=total_pop_t]
* CP
sum lit_rcath_1921_t [aweight=total_pop_t] if in_kresy!=1
* kresy
sum lit_rcath_1921_t [aweight=total_pop_t] if in_kresy==1

*** GET PERCENTAGES FOR TOTAL POPULATION, USED IN FIGURE 2: 
*TOTAL: 61.9%
*CP:    63.9%
*KRESY: 57.6%

*** FOR THE NUMBERS QUOTED IN THE TEXT IN SECTION V.A. subsection "Were Poles in Kresy Already More Educated Before WWII" and SECTION V.B. subsection "Were Forced Migrants from Kresy Selected at the Origin":
* URBAN:
* kresy
sum lit_rcath_1921_u [aweight=total_pop_u] if in_kresy==1
* CP
sum lit_rcath_1921_u [aweight=total_pop_u] if in_kresy!=1

* RURAL:
* kresy
sum lit_rcath_1921_r [aweight=total_pop_r] if in_kresy==1
* CP
sum lit_rcath_1921_r [aweight=total_pop_r] if in_kresy!=1
restore

* Generate Figure  
preserve
gen mean_=.
gen order=_n

replace mean_=61.9 if order==1
replace mean_=63.9 if order==2
replace mean_=57.6 if order==3

sum secondary_edu
replace mean_=100*`r(mean)' if order==4

sum secondary_edu if anybody_from_kresy==0
replace mean_=100*`r(mean)' if order==5

sum secondary_edu if anybody_from_kresy==1
replace mean_=100*`r(mean)' if order==6

replace mean_=80 if order==10
replace mean_=70 if order==11
replace order=3.5 if order==10
replace order=6.5 if order==11

twoway ///
 (bar mean_ order if order==1, barw(0.4) fc(white) lc(black) lw(medium)) ///
 (bar mean_ order if order==2, barw(0.4) fc(gray) lc(black) lw(medium)) ///
 (bar mean_ order if order==3, barw(0.4) fc(black) lc(black) lw(medium)) ///
 (bar mean_ order if order==4, barw(0.4) fc(white) lc(black) lw(medium)) ///
 (bar mean_ order if order==5, barw(0.4) fc(gray) lc(black) lw(medium)) ///
 (bar mean_ order if order==6, barw(0.4) fc(black) lc(black) lw(medium)) ///
 (bar mean_ order if order==3.5, barw(0.005) fc(black) lc(black) lw(medium)), ///
       graphregion(color(white)) ///
       ylabel(0(10)70, nogrid) yscale(range(30 80)) ///
       xlabel(1 "Average" 2 `" "Central" "Poland" "' 3 "Kresy" 4 "Average" 5 `" "no Kresy" "Ancestors" "' 6 `" "Kresy" "Ancestors" "', labsize(small) noticks) ///
       text(75 2.1 "Literacy in 1921", size(small)) ///
	   text(72 2.1 "(in the borders of the Second Polish Republic)", size(small)) ///
	   text(80 2.1 "Education pre-WWII", size(medlarge)) ///
	   text(80 5.1 "Education today", size(medlarge)) ///
	   text(75 5.1 "Secondary School Attainment Rate in 2015", size(small)) ///
	   text(72 5.1 "(in today's Polish borders)", size(small)) ///
	   text(65.4 1.0 "61.9%", size(small) color(edkblue)) text(67.4 2.0 "63.9%", size(small) color(edkblue)) text(60.9 3.0 "57.6%", size(small) color(edkblue))  ///
       text(53.0 4 "49.55%", size(small) color(edkblue)) text(51.3 5 "47.9%", size(small) color(edkblue)) text(65.7 6 "62.4%", size(small) color(edkblue))  ///
       xtitle("") ytitle("Literacy Rate; Secondary Schooling Rate") legend(off)

graph export "${path}/Results/Figures/Fig_2.pdf", as(pdf) replace 
graph export "${path}/Results/Figures/Fig_2.eps", as(eps) replace

restore 
**********************************************************************************************************
***********      Figure 3: Coefficients on Kresy, by cohort      *************************************
**********************************************************************************************************

*			 					AND

**********************************************************************************************************
***********      Figure A.10: Coefficients on Kresy, by cohort      *************************************
**********************************************************************************************************

preserve

local list_birth_cohort "birth_pre1930 birth_1930s birth_1940s birth_1950s birth_1960s birth_1970s birth_1980s birth_1990s"

gen ind_id=.
replace ind_id=1 if birth_pre1930==1 
replace ind_id=2 if birth_1930s==1 
replace ind_id=3 if birth_1940s==1 
replace ind_id=4 if birth_1950s==1 
replace ind_id=5 if birth_1960s==1  
replace ind_id=6 if birth_1970s==1  
replace ind_id=7 if birth_1980s==1  
replace ind_id=8 if birth_1990s==1  

*Drop students among the 1990 birth cohort
drop if birth_1990s==1 & student_status==1

matrix A=J(8,3,0)
matrix B=J(8,3,0)

quietly{
	
	forv i=1/8 {

		reg lnedu_years anybody_from_kresy $base_controls i.powiaty_code pow_FE_indicator if ind_id==`i', cl(hh)

		matrix A[`i',1] = `i'
		matrix A[`i',2] = _b[anybody_from_kresy]
		matrix A[`i',3] = _se[anybody_from_kresy]
		
		reg edu_years anybody_from_kresy $base_controls i.powiaty_code pow_FE_indicator if ind_id==`i', cl(hh)

		matrix B[`i',1] = `i'
		matrix B[`i',2] = _b[anybody_from_kresy]
		matrix B[`i',3] = _se[anybody_from_kresy]
		
	}
	
}

svmat A

gen A4 = A2-1.65*A3
gen A5 = A2+1.65*A3

sort A1

label var A2 "Coefficient"
label var A4 "90% CI"
label var A5 "90% CI"

twoway bar A2 A1 if A1!=. & A1>0, barwidth(.8) ///
 || rcap A4 A5 A1 if A1!=. & A1>0, lcolor(black) ///
 || ,xtitle("Birth Decade") ///
 xlabel(1 "Pre-1930s" 2 "1930s" 3 "1940s" 4 "1950s" 5 "1960s" 6 "1970s" 7 "1980s" 8 "1990s") scheme(s1mono) ///
	ytitle("Coeff. Ancestor from Kresy ") graphr(c(white)) legend(ring(0) pos(6)) 
	
graph export "${path}/Results/Figures/Fig_A10.eps", replace as(eps)
graph export "${path}/Results/Figures/Fig_A10.pdf", replace as(pdf)


svmat B

gen B4 = B2-1.65*B3
gen B5 = B2+1.65*B3

sort B1

label var B2 "Coefficient"
label var B4 "90% CI"
label var B5 "90% CI"

twoway bar B2 B1 if B1!=. & B1>0, barwidth(.8) ///
 || rcap B4 B5 B1 if B1!=. & B1>0, lcolor(black) ///
 || ,xtitle("Birth Decade") ///
 xlabel(1 "Pre-1930s" 2 "1930s" 3 "1940s" 4 "1950s" 5 "1960s" 6 "1970s" 7 "1980s" 8 "1990s") scheme(s1mono) ///
	ytitle("Extra Years of Schooling when Ancestor from Kresy") graphr(c(white)) legend(ring(0) pos(6)) 
	
graph export "${path}/Results/Figures/Fig_3.eps", replace as(eps)
graph export "${path}/Results/Figures/Fig_3.pdf", replace as(pdf)
restore

**********************************************************************************************************
***********      Figure 4 - Right Panel  *********************************************
**********************************************************************************************************

set seed 123456789 /* just for bins on the graph, not needed for the actual results */
set sortseed 123456789 /* just for bins on the graph, not needed for the results */

capture drop bins 
gen bins=int((max_dist_CurzLine+8)/8) if max_dist_CurzLine>0
replace bins=int((max_dist_CurzLine-8)/8) if max_dist_CurzLine<0

local width 140
capture drop sum_bins_* count_bins_* vot_bins_*
egen sum_bins_edu_years=sum(edu_years) if (max_dist_CurzLine!=.), by( bins) 
egen count_bins_edu_years=count(edu_years) if (max_dist_CurzLine!=.), by( bins) 
gen vot_bins_edu_years=sum_bins_edu_years/count_bins_edu_years

label var vot_bins_edu_years "mean by distance bins of 8km"
sort max_dist_CurzLine bins vot_bins_edu_years 
cap drop flag
gen flag=1 if bins==bins[_n-1]&vot_bins_edu_years==vot_bins_edu_years[_n-1]
replace vot_bins_edu_years =. if flag==1


graph twoway (lfitci edu_years dist_CurzLine if (max_dist_CurzLine)<`width'&(max_dist_CurzLine)>0&(max_dist_CurzLine!=.), ///
fcolor(gs14) level(90) xline(0) title("Years of Education") clpattern(solid) alpattern(dash)  ///      
title("Years of Education in 2015") xtitle("current CP residents (left); respondents with Kresy origin (right)") ytitle("Years of Education") ///
lcolor(black) lpattern(dash) xlabel(-150(25)150) ylabel(10(1)15))   ///
|| ( lfitci edu_years   max_dist_CurzLine if (max_dist_CurzLine)>-`width'&(max_dist_CurzLine)<0&(max_dist_CurzLine!=.), level(90)  ///
lcolor(black) fcolor(gs14) clpattern(solid) alpattern(dash))     ///
|| (scatter vot_bins_edu_years max_dist_CurzLine if abs(max_dist_CurzLine)<`width'&(max_dist_CurzLine!=.), msymbol(circle_hollow)), legend(off) scheme(s1mono)  

drop bins- flag

graph export "${path}/Results/Figures/Fig_4_right.eps", replace as(eps)
graph export "${path}/Results/Figures/Fig_4_right.pdf", replace as(pdf)


**********************************************************************************************************
***********      Figure 4 -- Left Panel  *********************************************
**********************************************************************************************************
preserve

use "${path}/Data/original_data/1931_census_percentages_with_kresy_dummy.dta", clear

merge m:1 powiaty_code_1931 using "${path}/Data/original_data/1931_pow_curzon_line_distance.dta"
drop if _merge==2
drop _merge
merge m:1 powiaty_code_1931 using "${path}/Data/original_data/centeroid_pow_1931.dta"
drop if _merge==2
drop _merge

gen powiaty_code1931=powiaty_code_1931
merge m:1 powiaty_code1931 using "${path}/Data/original_data/1921_census_pow_for_kresy_survey.dta"
drop if _merge==2
drop _merge


foreach coord in lat lon{
gen `coord'_1931_sq= `coord'_1931*`coord'_1931
}


replace in_kresy=0 if in_kresy==.

replace  disCursLineKm=- disCursLineKm if in_kresy==0
gen disCursLine_kresy=disCursLineKm*in_kresy


label var lit_rcath_1921_t "Literacy of Roman Catholics in 1921 by county"
label var literate_1931pow "Literacy of population in 1931 by county"

set seed 123456789 /* just for bins on the graph, not needed for the actual results */
set sortseed 123456789 /* just for bins on the graph, not needed for the results */

capture drop bins 
gen bins=int((disCursLineKm+8)/8) if disCursLineKm>0
replace bins=int((disCursLineKm-8)/8) if disCursLineKm<0

local width 149
capture drop sum_bins_* count_bins_* vot_bins_*
egen sum_bins_lit_rcath_1921_t=sum(lit_rcath_1921_t) if (disCursLineKm!=.), by( bins) 
egen count_bins_lit_rcath_1921_t=count(lit_rcath_1921_t) if (disCursLineKm!=.), by( bins) 
gen vot_bins_lit_rcath_1921_t=sum_bins_lit_rcath_1921_t/count_bins_lit_rcath_1921_t

label var vot_bins_lit_rcath_1921_t "mean by distance bins of 8km"
sort disCursLineKm bins vot_bins_lit_rcath_1921_t 
cap drop flag
gen flag=1 if bins==bins[_n-1]&vot_bins_lit_rcath_1921_t==vot_bins_lit_rcath_1921_t[_n-1]
replace vot_bins_lit_rcath_1921_t =. if flag==1

twoway (lfitci lit_rcath_1921_t disCursLineKm if (disCursLineKm)<`width'&(disCursLineKm)>0&(disCursLineKm!=.), ///
level(90) fcolor(gs14) xline(0) title(`: variable label lit_rcath_1921_t') clpattern(solid) alpattern(dash) ///
xtitle("counties in CP (left) and Kresy (right)") ytitle("Share literate in 1921") lcolor(black) lpattern(dash) xlabel(-150(25)150) ylabel(0.4(0.1) 0.9)) ///
 ( lfitci lit_rcath_1921_t disCursLineKm if (disCursLineKm)>-`width'&(disCursLineKm)<0&(disCursLineKm!=.), level(90) fcolor(gs14) ///
lcolor(black)  clpattern(solid) alpattern(dash)) || (scatter vot_bins_lit_rcath_1921_t disCursLineKm if abs(disCursLineKm)<`width'&(disCursLineKm!=.), msymbol(circle_hollow)), legend(off) scheme(s1mono)  


graph export "${path}/Results/Figures/Fig_4_left.eps", replace as(eps)
graph export "${path}/Results/Figures/Fig_4_left.pdf", replace as(pdf)

restore


************************************************************************************************
***************      Figure A.8: Data Quality Diagnoza     *************************************
************************************************************************************************

**********************************************************************************************************
***************      Figure A.8 - Left
**********************************************************************************************************


use "${path}/Data/generated_data/diagnoza_replicate.dta", clear

egen woj_1950_id=group(name_wojewodztwa1952)
gen frac_ussr_all=perc_ussr_all/100
gen frac_ussr= ussr_1939/population1950

clear matrix
drop if name_wojewodztwa1952==""
collapse (mean) frac_ussr_all frac_ussr anybody_from_kresy, by(name_wojewodztwa1952)
reg frac_ussr anybody_from_kresy, r

mat mcoeff = e(b)
mat var = e(V) 
scalar sterr = round(sqrt(var[1,1])*1000)/1000
scalar coef = round(mcoeff[1,1]*1000)/1000
scalar tstat = round((mcoeff[1,1])/(sqrt(var[1,1]))*100)/100
scalar pval = ttail(462,abs(coef/sterr))*2
scalar R_sq = round(e(r2_a)*1000)/1000

local myNote = "coef="+string(coef) + ";   Robust SE="+ string(sterr) + ";   t=" + string(tstat) + ";   R-sq=" +string(R_sq)
di "`myNote'"

graph twoway (lfit  frac_ussr_all anybody_from_kresy) (scatter  frac_ussr_all anybody_from_kresy, msymbol(o) mlabel(name_wojewodztwa1952)), title("Region-level shares of Kresy migrants, in all of Poland") ytitle("Census 1950 shares") xtitle("Diagnoza Survey data shares") legend(off) scheme(s1mono)

graph export "${path}/Results/Figures/Fig_A8_left.pdf", replace as(pdf)
graph export "${path}/Results/Figures/Fig_A8_left.eps", replace as(eps)

clear


**********************************************************************************************************
***************      Figure A.8 - Right
**********************************************************************************************************

use "${path}/Data/generated_data/diagnoza_replicate.dta", clear

egen woj_1950_id=group(name_wojewodztwa1952)
gen frac_ussr_all=perc_ussr_all/100
gen frac_ussr= ussr_1939/population1950

clear matrix
drop if powiat_1952==""
drop if population_powiat_1950_t==.
gen frac_ussr_all_pow= from_USRR_t/ population_powiat_1950_t

collapse (mean) frac_ussr_all_pow anybody_from_kresy, by(powiat_1952)
reg frac_ussr_all anybody_from_kresy, r

mat mcoeff = e(b)
mat var = e(V) 
scalar sterr = round(sqrt(var[1,1])*1000)/1000
scalar coef = round(mcoeff[1,1]*1000)/1000
scalar tstat = round((mcoeff[1,1])/(sqrt(var[1,1]))*100)/100
scalar pval = ttail(462,abs(coef/sterr))*2
scalar R_sq = round(e(r2_a)*1000)/1000

local myNote = "coef="+string(coef) + ";   Robust SE="+ string(sterr) + ";   t=" + string(tstat) + ";   R-sq=" +string(R_sq)
di "`myNote'"

graph twoway (lfit  frac_ussr_all_pow anybody_from_kresy) (scatter  frac_ussr_all_pow anybody_from_kresy, msymbol(o)), title("County-level shares of Kresy migrants, in WT") ytitle("Census 1950 shares") xtitle("Diagnoza Survey data shares") legend(off) scheme(s1mono) 
graph export "${path}/Results/Figures/Fig_A8_right.pdf", replace as(pdf)
graph export "${path}/Results/Figures/Fig_A8_right.eps", replace as(eps) 

clear

**********************************************************************************************************
***************      Figure A.11   *********************************************
**********************************************************************************************************

*					AND
**********************************************************************************************************
***************      Figure A.12  *********************************************
**********************************************************************************************************


use "${path}/Data/original_data/1931_census_percentages_with_kresy_dummy.dta", clear

merge m:1 powiaty_code_1931 using "${path}/Data/original_data/1931_pow_curzon_line_distance.dta"
drop if _merge==2
drop _merge
merge m:1 powiaty_code_1931 using "${path}/Data/original_data/centeroid_pow_1931.dta"
drop if _merge==2
drop _merge

merge m:1 powiaty_code_1931 using "${path}/Data/original_data/pow_1931_geo.dta"
drop if _merge==2
drop _merge


foreach coord in lat lon{
gen `coord'_1931_sq= `coord'_1931*`coord'_1931
}

replace in_kresy=0 if in_kresy==.

replace  disCursLineKm=- disCursLineKm if in_kresy==0
gen disCursLine_kresy=disCursLineKm*in_kresy

set seed 123456789 /* just for bins on the graph, not needed for the actual results */
set sortseed 123456789 /* just for bins on the graph, not needed for the results */

local graph_list ann_prcp ann_temp elevation ruggedness barley wheat potato sunflower  

capture drop bins 
gen bins=int((disCursLineKm+8)/8) if disCursLineKm>0
replace bins=int((disCursLineKm-8)/8) if disCursLineKm<0

local width 149

foreach dep in `graph_list' { 
	
capture drop sum_bins_* count_bins_* vot_bins_*
egen sum_bins_`dep'=sum(`dep') if (disCursLineKm!=.), by( bins) 
egen count_bins_`dep'=count(`dep') if (disCursLineKm!=.), by( bins) 
gen vot_bins_`dep'=sum_bins_`dep'/count_bins_`dep'

label var vot_bins_`dep' "mean by distance bins of 8km"
sort disCursLineKm bins vot_bins_`dep' 
cap drop flag
gen flag=1 if bins==bins[_n-1]&vot_bins_`dep'==vot_bins_`dep'[_n-1]
replace vot_bins_`dep' =. if flag==1

twoway (lfitci `dep' disCursLineKm if (disCursLineKm)<`width'&(disCursLineKm)>0&(disCursLineKm!=.), ///
level(90) fcolor(gs14) xline(0) title(`: variable label `dep'', size(medsmall)) clpattern(solid) alpattern(dash) ///
xtitle("counties in CP (left) and Kresy (right)", size(small))  ytitle(, size(small)) lcolor(black) lpattern(dash) xlabel(-150(50)150) ) ///
 ( lfitci `dep' disCursLineKm if (disCursLineKm)>-`width'&(disCursLineKm)<0&(disCursLineKm!=.), level(90) fcolor(gs14) ///
lcolor(black)  clpattern(solid) alpattern(dash)) || (scatter vot_bins_`dep' disCursLineKm if abs(disCursLineKm)<`width'&(disCursLineKm!=.), msymbol(circle_hollow)), legend(off) scheme(s1mono)  

graph save "${path}/Results/Figures/Fig_`dep'.gph", replace 

}
*Figure A.11
graph combine  "${path}/Results/Figures/Fig_ann_temp.gph" "${path}/Results/Figures/Fig_ann_prcp.gph" "${path}/Results/Figures/Fig_elevation.gph" "${path}/Results/Figures/Fig_ruggedness.gph", scheme(s1mono)  
graph export "${path}/Results/Figures/Fig_A11.eps", replace as(eps)
graph export "${path}/Results/Figures/Fig_A11.pdf", replace as(pdf)

*Figure A.12
graph combine "${path}/Results/Figures/Fig_barley.gph" "${path}/Results/Figures/Fig_wheat.gph" "${path}/Results/Figures/Fig_potato.gph"  "${path}/Results/Figures/Fig_sunflower.gph", scheme(s1mono)  
graph export "${path}/Results/Figures/Fig_A12.eps", replace as(eps)
graph export "${path}/Results/Figures/Fig_A12.pdf", replace as(pdf)

foreach dep in `graph_list' { 
erase "${path}/Results/Figures/Fig_`dep'.gph"
}

clear

		
**********************************************************************************************************
***************      Figure A.15   *********************************************
**********************************************************************************************************

use "${path}/Data/generated_data/diagnoza_replicate.dta", clear

graph twoway (lfit  perc_lan_polish1900 share_autochthons) (scatter  perc_lan_polish1900 share_autochthons, msymbol(o)), ytitle("Share of Polish speaking population in 1900") xtitle("Share of autochthons in 1950") legend(off) scheme(s1mono) 
graph export "${path}/Results/Figures/Fig_A15.pdf", replace as(pdf)
graph export "${path}/Results/Figures/Fig_A15.eps", replace as(eps)

/* get coeff, std err and R2 */
regress perc_lan_polish1900 share_autochthons, cluster(powiaty_code)

**********************************************************************************************************
***************      Figure A.16    ******************************************
**********************************************************************************************************

merge m:1 woj using "${path}/Data/original_data/emigrants_census2011.dta"
drop _merge

gen sh_migrants=  number_emigrants/population_2011

preserve
collapse sh_migrants intend_go_abroad, by(woj)
label var sh_migrants "Share of migrants in population, 2011 Census" 
label var intend_go_abroad "Intend to go abroad"
reg  intend_go_abroad_for_work sh_migrants , cl(woj)
twoway (line sh_migrants sh_migrants, sort) (scatter intend_go_abroad_for_work sh_migrants, msymbol(o)), xtitle("Share of respondents who intend to emigrate, Diagnoza") ytitle("Share of people who emigrated, Census 2011") legend(off) scheme(s1mono)
graph export "${path}/Results/Figures/Fig_A16.eps",replace as(eps)
graph export "${path}/Results/Figures/Fig_A16.pdf",replace as(pdf)
restore

********************************************************************************************************************************************************************************************************************
***************      TABLES IN THE PAPER   ************************************************************************************************************************
********************************************************************************************************************************************************************************************************************	

**********************************************************************************************************
***************      Table 1 - is not generated by a do file, it is raw data from the census 1950     *********************************************
**********************************************************************************************************


**********************************************************************************************************
***************      Table 2     *********************************************
**********************************************************************************************************
use "${path}/Data/generated_data/diagnoza_replicate.dta", clear

local list_edu "edu_years secondary_edu higher_edu"
local i=1

foreach y in `list_edu' {
estimates clear

/*1*/eststo: reg `y' anybody_from_kresy , cl(hh)
estadd ysumm

/*2*/eststo: areg `y' anybody_from_kresy $base_controls  pow_FE_indicator , cl(hh) absorb(powiaty_code)
estadd ysumm

/*3*/eststo: areg `y' anybody_from_kresy $base_controls  gminy_FE_indicator, cl(hh) absorb(gminy_code)
estadd ysumm

/*4*/eststo: areg `y' anybody_from_kresy $base_controls  pow_FE_indicator if rural==1 , cl(hh) absorb(powiaty_code)
estadd ysumm

/*5*/eststo: areg `y' anybody_from_kresy $base_controls  pow_FE_indicator if rural==0 , cl(hh) absorb(powiaty_code)
estadd ysumm                                             
                                                         
/*6*/eststo: areg `y' anybody_from_kresy $base_controls  pow_FE_indicator if WT==0 , cl(hh) absorb(powiaty_code)
estadd ysumm                                             
                                                         
/*7*/eststo: areg `y' anybody_from_kresy $base_controls  pow_FE_indicator if WT==1 , cl(hh) absorb(powiaty_code)
estadd ysumm



estout using "${path}/Results/Tables/Table_2_`y'.tex", replace ///
				keep($show anybody_from_kresy) label ///
                order($show ) stats(ymean N, layout(@ "{@}") fmt(2 %9.0gc) labels("Mean Dep. Var." "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par)) style(tex) collabels(none)

}

*Note in text:
reg edu_years anybody_from_kresy , cl(hh)
tab anybody_from_kresy if e(sample)

** Footnote 12 of the online Appendix: with region FE to compare with LiTS estimates 

foreach y in `list_edu' {
  areg `y' anybody_from_kresy $base_controls, cl(hh) absorb(woj)
}

**********************************************************************************************************
***************      Table 5     *********************************************
**********************************************************************************************************

*Cols 1-6
estimates clear
local list1 "high_aspiration_edu material_goods_lifesuccess_d successful_life_freedom"
foreach  x in  `list1' {
eststo: areg `x' anybody_from_kresy           $base_controls pow_FE_indicator if edu_years~=., cl(hh) absorb(powiaty_code)
estadd ysumm
eststo: areg `x' anybody_from_kresy edu_years $base_controls pow_FE_indicator, cl(hh) absorb(powiaty_code)
estadd ysumm
}
*Cols 7-8
eststo: areg share_not_owned_NFR anybody_from_kresy           $base_controls pow_FE_indicator if edu_years~=., cl(hh) absorb(powiaty_code)
estadd ysumm
eststo: areg share_not_owned_NFR anybody_from_kresy edu_years $base_controls pow_FE_indicator, cl(hh) absorb(powiaty_code)
estadd ysumm
estout using "${path}/Results/Tables/Table_5.tex", replace ///
				keep($show anybody_from_kresy edu_years) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R-squared" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))   style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female " "\\[-0.75cm] Respondent County FE=pow_FE_indicator", labels("{\checkmark}" "{ }"))


				

**********************************************************************************************************
***************      Table 6     *********************************************
**********************************************************************************************************

* In-text note Section VI.B, subsection on "Congestion":
foreach x in median mean {
egen `x'_share_autochthons=`x'(share_autochthons) if WT==1
su `x'_share_autochthons
}

egen share_autochthons_std = std(share_autochthons) if WT==1
label var share_autochthons_std "Share Autochthons, 1950 (std)"
gen i_kresy_autochthons_std = anybody_from_kresy*share_autochthons_std
label var i_kresy_autochthons_std "Sh Autochthons (std) $\times$ Kresy"
egen perc_lan_polish1900_std = std(perc_lan_polish1900) if WT==1
label var perc_lan_polish1900_std "\% Polish speakers, 1900 (std)"
gen i_kresy_Polish1900_std = anybody_from_kresy*perc_lan_polish1900_std
label var i_kresy_Polish1900_std "\% Polish sp (std) $\times$ Kresy"


areg log_hhincome anybody_from_kresy edu_years $base_controls pow_FE_indicator if pensioner_status==0 , cl(hh) absorb(powiaty_code)
gen sample_income=e(sample)
egen edu_years_std = std(edu_years) if sample_income
label var edu_years_std "Years education (std)"
gen i_kresy_edu_std = anybody_from_kresy*edu_years_std
label var i_kresy_edu_std "Years edu (std) $\times$ Kresy"

label var intend_go_abroad "Intend to go abroad"


estimates clear
*Col 1: Congestion?
/*1*/eststo: areg edu_years    anybody_from_kresy  i_kresy_autochthons_std       $base_controls pow_FE_indicator if WT==1, cl(powiaty_code) absorb(powiaty_code)
estadd ysumm
*Cols 2-3: differential return to schooling?
/*2*/eststo: areg log_hhincome anybody_from_kresy edu_years_std i_kresy_edu_std  $base_controls pow_FE_indicator  if pensioner_status==0 , cl(hh) absorb(powiaty_code)
estadd ysumm
/*3*/eststo: areg log_hhincome anybody_from_kresy edu_years_std i_kresy_edu_std  $base_controls pow_FE_indicator  if pensioner_status==0 & WT==1, cl(hh) absorb(powiaty_code)
estadd ysumm
*Cols 4-5: differential return to schooling?
/*4*/eststo: areg intend_go_abroad anybody_from_kresy                               $base_controls pow_FE_indicator, cl(hh) absorb(powiaty_code)
estadd ysumm
/*5*/eststo: areg intend_go_abroad anybody_from_kresy edu_years_std i_kresy_edu_std $base_controls pow_FE_indicator, cl(hh) absorb(powiaty_code)
estadd ysumm
*Cols 6-7: different fertiltity?
/*6*/eststo: areg share_younger_16HH anybody_from_kresy $base_controls pow_FE_indicator if edu_years~=., cl(hh) absorb(powiaty_code)
estadd ysumm
/*7*/eststo: areg share_younger_16HH anybody_from_kresy $base_controls pow_FE_indicator if nb_childrenless16_hh~=0 & edu_years~=., cl(hh) absorb(powiaty_code)
estadd ysumm	
estout using "${path}/Results/Tables/Table_6.tex", replace ///
				keep($show anybody_from_kresy    i_kresy_autochthons_std edu_years_std i_kresy_edu_std) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R-squared" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par)) style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female " "\\[-0.75cm] Respondent County FE=pow_FE_indicator", labels("{\checkmark}" "{ }"))		

				

********************************************************************************************************************************************************************************************************************
***************      APPENDIX TABLES     ************************************************************************************************************************
********************************************************************************************************************************************************************************************************************	
		
		
**********************************************************************************************************
***************      Table A.1   *********************************************
**********************************************************************************************************
cap log close
log using "${path}/Results/Tables/Table_A1.smcl", replace 
sum edu_years secondary_edu higher_edu  if anybody_from_kresy!=.
log close

**********************************************************************************************************
***************      Table A.2   *********************************************
**********************************************************************************************************

cap log close
log using "${path}/Results/Tables/Table_A2.smcl" , replace
*** Table A.2 (Panel A) 
sum anybody_from_kresy   if (edu_years!=.| secondary_edu!=.| higher_edu!=.)

*** Table A.2 (Panel B) 
sum anybody_from_kresy   if WT&(edu_years!=.| secondary_edu!=.| higher_edu!=.)

*** Table A.2 (Panel C) 
sum anybody_from_kresy   if !WT&(edu_years!=.| secondary_edu!=.| higher_edu!=.)

log close

*****************************************************************************************************************
***************      Table A.3   *********************************************
*****************************************************************************************************************

local list_birth_cohort "birth_pre1930 birth_1930s birth_1940s birth_1950s birth_1960s birth_1970s birth_1980s"

local list_edu "edu_years secondary_edu higher_edu"

foreach y in `list_edu' { 

estimates clear
foreach  x in  `list_birth_cohort' {
/*1-7*/eststo: areg `y' anybody_from_kresy $base_controls pow_FE_indicator if `x'==1 , cl(hh) absorb(powiaty_code)
estadd ysumm
}
*Drop students among the 1990 birth cohort
/*8*/ eststo: areg `y' anybody_from_kresy $base_controls pow_FE_indicator if birth_1990s==1 & student_status==0, cl(hh) absorb(powiaty_code)
estadd ysumm

estout using "${path}/Results/Tables/Table_A3_`y'.tex", replace ///
				keep($show anybody_from_kresy) label ///
                order($show ) stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R-squared" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))   style(tex) collabels(none)
}


*****************************************************************************************************************
***************      Table A.4   *********************************************
*****************************************************************************************************************

estimates clear
/*1*/eststo: areg log_hhincome anybody_from_kresy                 $base_controls  pow_FE_indicator if pensioner_status==0 , cl(hh) absorb(powiaty_code)
estadd ysumm
/*2*/eststo: areg log_hhincome anybody_from_kresy edu_years       $base_controls  pow_FE_indicator if pensioner_status==0 , cl(hh) absorb(powiaty_code)
estadd ysumm
/*3*/eststo: areg white_collar anybody_from_kresy                 $base_controls  pow_FE_indicator if pensioner_status==0 , cl(hh) absorb(powiaty_code)
estadd ysumm
/*4*/eststo: areg white_collar anybody_from_kresy edu_years       $base_controls  pow_FE_indicator if pensioner_status==0 , cl(hh) absorb(powiaty_code)
estadd ysumm
/*5*/eststo: areg unemployed_status anybody_from_kresy            $base_controls  pow_FE_indicator if pensioner_status==0 , cl(hh) absorb(powiaty_code)
estadd ysumm
/*6*/eststo: areg unemployed_status anybody_from_kresy edu_years  $base_controls  pow_FE_indicator if pensioner_status==0 , cl(hh) absorb(powiaty_code)
estadd ysumm
estout using "${path}/Results/Tables/Table_A4.tex", replace ///
				keep($show anybody_from_kresy edu_years) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R-squared" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))   style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female " "\\[-0.75cm] Respondent County FE=pow_FE_indicator", labels("{\checkmark}" "{ }"))
				
**********************************************************************************************************
***************      Table A.10   *********************************************
**********************************************************************************************************

estimates clear
local poly_lat_long "latitude_running longitude_running latitude_running_sq longitude_running_sq lat_x_long"
/*1*/eststo: reg edu_years anybody_from_kresy $base_controls if abs(max_dist_CurzLine)<150, cl(hh)
estadd ysumm
/*2*/eststo: reg edu_years anybody_from_kresy $base_controls `poly_lat_long' if abs(max_dist_CurzLine)<150, cl(hh)
estadd ysumm
/*3*/eststo: reg edu_years anybody_from_kresy $base_controls `poly_lat_long' if abs(max_dist_CurzLine)<100, cl(hh)
estadd ysumm
/*4*/eststo: reg secondary_edu anybody_from_kresy $base_controls `poly_lat_long' if abs(max_dist_CurzLine)<150, cl(hh)
estadd ysumm
/*5*/eststo: reg higher_edu anybody_from_kresy $base_controls `poly_lat_long' if abs(max_dist_CurzLine)<150, cl(hh)
estadd ysumm
estout using "${path}/Results/Tables/Table_A10.tex", replace ///
				keep($show anybody_from_kresy) label ///
                order($show ) stats(ymean N, layout(@ "{@}") fmt(2 %9.0gc) labels("Mean Dep. Var." "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))   style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female " "\\[-0.75cm] RD Polynomial$^{\#}$=latitude_running", labels("{\checkmark}" "{ }"))

**********************************************************************************************************
***************      Table A.16  *********************************************
**********************************************************************************************************

gen WarsawKrakow = 1 if powiaty_code==1465 | powiaty_code==1261 //Warszawa and Krakow powiaty
recode WarsawKrakow .=0
label var WarsawKrakow "Warsaw or Krakow"


label var WT "Dummy for Western Territories"
estimates clear
local list1 "edu_years secondary_edu higher_edu"
foreach  x in  `list1' {
eststo: reg `x'  WT  female rural city age_birth* age_sq_birth*              if anybody_from_kresy==1, cl(hh)
estadd ysumm
eststo: reg `x'  WT  female rural city age_birth* age_sq_birth* WarsawKrakow if anybody_from_kresy==1, cl(hh)
estadd ysumm
}
estout using "${path}/Results/Tables/Table_A16.tex", replace ///
				keep($show WT WarsawKrakow) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R-squared" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))  style(tex) collabels(none)  ///
    			indicate("Baseline Controls$^{\ddag}$=female " , labels("{\checkmark}" "{ }"))		
 
* In-text note in Section V.B., subsection on "Selection of Forced Kresy Migrants into Destinations?":
reg secondary_edu  WT  $base_controls if anybody_from_kresy==1, cl(hh)
tab WT if e(sample)
				
**********************************************************************************************************
***************      Table A.19  *********************************************
**********************************************************************************************************

estimates clear
eststo: areg hh_savings            anybody_from_kresy log_hhincome edu_years $base_controls pow_FE_indicator, cl(hh) absorb(powiaty_code)
estadd ysumm
foreach num in 1 3 9 11 {
eststo: areg purpose`num'_savings  anybody_from_kresy log_hhincome edu_years $base_controls pow_FE_indicator, cl(hh) absorb(powiaty_code)
estadd ysumm
}
eststo: areg have_insurance        anybody_from_kresy log_hhincome edu_years $base_controls pow_FE_indicator , cl(hh) absorb(powiaty_code)
estadd ysumm

estout using "${path}/Results/Tables/Table_A19.tex", replace ///
				keep($show anybody_from_kresy) label ///
                order($show ) prefoot("\hline") stats(ymean N, layout(@ "{@}") fmt(2 %9.0gc) labels("Mean Dep. Var." "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))  style(tex) collabels(none) ///
    			indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.75cm]Education and HH income=log_hhincome" "\\[-0.75cm] Respondent County FE=pow_FE_indicator", labels("{\checkmark}" "{ }"))		

************************************************************************************************************************************************************************************************
***************      TABLE A.21  ************************************************************************************************************
************************************************************************************************************************************************************************************************	
label var smoking "Smoking"

estimates clear
		
/* 1 */ eststo: areg smoking       anybody_from_kresy             $base_controls pow_FE_indicator , cl(hh)	absorb(powiaty_code)
estadd ysumm
/*Control for smoking*/
/* 2 */ eststo: areg edu_years     anybody_from_kresy smoking     $base_controls pow_FE_indicator , cl(hh)	absorb(powiaty_code)	
estadd ysumm
/* 3 */ eststo: areg secondary_edu anybody_from_kresy smoking     $base_controls pow_FE_indicator , cl(hh)	absorb(powiaty_code)	
estadd ysumm
/* 4 */ eststo: areg higher_edu    anybody_from_kresy smoking     $base_controls pow_FE_indicator , cl(hh)	absorb(powiaty_code)	
estadd ysumm
		
estout using "${path}/Results/Tables/Table_A21.tex", replace ///
				keep($show anybody_from_kresy smoking) label ///
                order($show ) prefoot("\hline") stats(ymean N, layout(@ "{@}") fmt(2 %9.0gc) labels("Mean Dep. Var." "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))  style(tex) collabels(none) ///
	    		indicate("Baseline Controls$^{\ddag}$=female " "\\[-0.75cm] Respondent County FE=pow_FE_indicator", labels("{\checkmark}" "{ }"))		


************************************************************************************************************************************************************************************************
***************      TABLE A.22   ************************************************************************************************************
************************************************************************************************************************************************************************************************	

merge m:1 powiaty_code using "${path}/Data/original_data/rail_lines_stations_1946_by_powiat.dta"   
drop if _merge==2

drop _merge
merge m:1 powiaty_code using "${path}/Data/original_data/powiaty_area.dta"  
drop if _merge==2

gen dens_station1946=nb_railway_stations_1946/(pow_area_ha)*100
label var dens_station1946 "number of rail stations per km^2, by powiat, 1946"

drop _merge
merge m:1 powiaty_code using "${path}/Data/original_data/war_destruction_final.dta" 
tab _merge

drop _merge
merge m:1 name_wojewodztwa1952 using "${path}/Data/original_data/industrial_production_1954_ready.dta" 

rename nb_railway_stations_1946 rail_stations1946
rename nb_rail_lines_1946 rail_lines_1946
rename perc_destroyed_rural_scale perc_destr_rural_sc

rename perc_vol_urban_destroyed perc_vol_urban_destr

rename ind_prod_1954_per_population ind_prod_1954_per_pop
rename ind_prod_1954_per_urban_pop ind_prod_1954_per_urbp

foreach var in dens_station1946 ind_prod_1954_per_pop perc_destroyed_rural perc_vol_urban_destr  {
  egen `var'_std = std(`var') 
  gen i_kr_`var'_std = anybody_from_kresy * `var'_std
}

label var dens_station1946_std      "Railway station density 1946 (std)"
label var ind_prod_1954_per_pop_std "Log Industrial Production per capita 1954 (std)"
label var perc_destroyed_rural_std  "\% rural buildings damg'd or destr'd in WWII (std)"
label var perc_vol_urban_destr_std  "\% urban real est. damg'd or destr'd in WWII (std) "

label var i_kr_dens_station1946_std      "Railway station density 1946 (std) X Kresy"
label var i_kr_ind_prod_1954_per_pop_std "Log Industrial Production per capita 1954 (std) X Kresy"
label var i_kr_perc_destroyed_rural_std  "\% rural buildings damg'd or destr'd in WWII (std) X Kresy"
label var i_kr_perc_vol_urban_destr_std  "\% urban real est. damg'd or destr'd in WWII (std) X Kresy"


foreach var in dens_station1946 ind_prod_1954_per_pop perc_destroyed_rural perc_vol_urban_destr {
	
estimates clear

/* 1 */ eststo:  reg edu_years anybody_from_kresy `var'_std                  $base_controls                  , cl(hh)
estadd ysumm
/* 2 */ eststo: areg edu_years anybody_from_kresy           i_kr_`var'_std   $base_controls pow_FE_indicator , cl(hh)	absorb(powiaty_code)	
estadd ysumm
/* 3 */ eststo: areg edu_years anybody_from_kresy 			i_kr_`var'_std   $base_controls pow_FE_indicator if WT==0 , cl(hh) absorb(powiaty_code)	
estadd ysumm                                       			
/* 4 */ eststo: areg edu_years anybody_from_kresy 			i_kr_`var'_std   $base_controls pow_FE_indicator if WT==0 & powiaty_code!=1465, cl(hh) absorb(powiaty_code)	
estadd ysumm                                       			
/* 5 */ eststo: areg edu_years anybody_from_kresy 			i_kr_`var'_std   $base_controls pow_FE_indicator if WT==1  , cl(hh) absorb(powiaty_code)	
estadd ysumm

estout using "${path}/Results/Tables/Table_A22_`var'.tex", replace ///
				keep($show anybody_from_kresy `var'_std i_kr_`var'_std) label ///
                order($show ) prefoot("\hline") stats(ymean N, layout(@ "{@}") fmt(2 %9.0gc) labels("Mean Dep. Var." "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))   style(tex) collabels(none) ///
			    indicate("Baseline Controls$^{\ddag}$=female " "\\[-0.75cm] Respondent County FE=pow_FE_indicator", labels("{\checkmark}" "{ }"))		
}
************************************************************************************************************************************************************************************************
***************      TABLE A.24   ************************************************************************************************************
**** merge data on % of ukrainians who were forced to move to USSR as a part of population exchange  
**********************************************************************

use "${path}/Data/generated_data/diagnoza_replicate.dta", clear

gen prcnt_latecomers=migr_ussr_1955_1959/(migr_ussr_1955_1959+ussr_1939)
egen pc_latecomers_std = std(prcnt_latecomers)
label var pc_latecomers_std "Share 1955-59 migrants among Kresy migrants (std)"
gen i_kr_pc_latecomers_std = anybody_from_kresy * pc_latecomers_std
label var i_kr_pc_latecomers_std "Share 1955-59 migrants among Kresy migrants (std) x Kresy"

* In-text note in Section VI.B. subsection "Moving as Communities and Other Population Movements":
su prcnt_latecomers 

merge m:1 powiaty_code using "${path}/Data/original_data/ukrainians_forced_to_move_to_USSR.dta"  
drop _merge

replace pc_evac_ukrainians=0 if pc_evac_ukrainians==.
egen pc_evac_ukrainians_std = std(pc_evac_ukrainians) 
label var pc_evac_ukrainians_std "Share Ukrainians expelled (std)"
gen i_kr_pc_evac_ukrainians_std = anybody_from_kresy * pc_evac_ukrainians_std
label var i_kr_pc_evac_ukrainians_std "Share Ukrainians expelled (std) x Kresy"

estimates clear

eststo: areg edu_years anybody_from_kresy                             $base_controls pow_FE_indicator if pc_evac_ukrainians==0, cl(hh) absorb(powiaty_code)
estadd ysumm
eststo: areg edu_years anybody_from_kresy i_kr_pc_evac_ukrainians_std $base_controls pow_FE_indicator                         , cl(hh) absorb(powiaty_code)
estadd ysumm
eststo: areg edu_years anybody_from_kresy i_kr_pc_latecomers_std      $base_controls pow_FE_indicator                         , cl(hh) absorb(powiaty_code)
estadd ysumm

estout using "${path}/Results/Tables/Table_A24.tex", replace ///
				keep($show anybody_from_kresy i_kr_pc_evac_ukrainians_std i_kr_pc_latecomers_std) label ///
                order($show ) prefoot("\hline") stats(ymean N, layout(@ "{@}") fmt(2 %9.0gc) labels("Mean Dep. Var." "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))  style(tex) collabels(none) ///
    			indicate("Baseline Controls$^{\ddag}$=female " "\\[-0.75cm] Respondent County FE=pow_FE_indicator", labels("{\checkmark}" "{ }"))		
