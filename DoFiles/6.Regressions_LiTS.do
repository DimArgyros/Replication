		
clear all
set matsize 5000
set more off

**********************************************************************************************************
	
	
use "${path}/Data/generated_data/LiTS_replicate.dta", clear


global base_controls "WT age_birth* age_sq_birth* female urban_mother urban_father urban" 



**********************************************************************************************************
****   Table A9   Replication of Education results    ********************************
**********************************************************************************************************


estimates clear


/*LiTS: Columns 1 to 3 Replication of Education results*/
/*1*/eststo:  reg edu_years     anybody_from_kresy  $base_controls i.woj woj_FE_indicator, cl(PSU_name)
	estadd ysumm
/*2*/eststo:  reg secondary_edu anybody_from_kresy  $base_controls i.woj woj_FE_indicator, cl(PSU_name)
	estadd ysumm
/*3*/eststo:  reg higher_edu    anybody_from_kresy  $base_controls i.woj woj_FE_indicator, cl(PSU_name)
	estadd ysumm

estout using "${path}/Results/Tables/Table_A9.tex", replace ///
				keep($show anybody_from_kresy) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))   style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.85cm] Region FE=woj_FE_indicator", labels("{\checkmark}" "{ }"))

**********************************************************************************************************
*****   Table A15: Robustness of Education Results in LiTS and WWII Victimization: ************************
**********************************************************************************************************

estimates clear

** war victimization is correlated with Kresy origin 
/*1*/eststo:  reg killed_injured_WWII_full anybody_from_kresy  $base_controls i.woj woj_FE_indicator, cl(PSU_name)
	estadd ysumm
**replicate our main result controlling for war victimization (missing = zero)
/*2*/eststo:  reg edu_years anybody_from_kresy killed_injured_WWII_full  $base_controls i.woj woj_FE_indicator, cl(PSU_name)
	estadd ysumm
**replicate our main result controlling for war victimization without (missing = zero).
/*3*/eststo:  reg edu_years anybody_from_kresy killed_injured_WWII  $base_controls i.woj woj_FE_indicator, cl(PSU_name)
	estadd ysumm

estout using "${path}/Results/Tables/Table_A15.tex", replace ///
				keep($show anybody_from_kresy killed_injured_WWII_full anybody_from_kresy killed_injured_WWII) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))   style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.85cm] Region FE=woj_FE_indicator", labels("{\checkmark}" "{ }"))


** Footnote 18 in Appendix: estimates when Secondary and Higher are the dep var  
foreach y in secondary_edu  higher_edu {
 reg `y' anybody_from_kresy                           $base_controls i.woj, cl(PSU_name)
 reg `y' anybody_from_kresy killed_injured_WWII_full  $base_controls i.woj, cl(PSU_name)
}

 
******************************************************************************************************************************** 
*****  Table A20: Education and Risk-Aversion in the 2016 Life in Transition Survey (LiTS)
******************************************************************************************************************************** 

gen take_risk=q428 
replace take_risk=. if take_risk<0
label var take_risk "Willingness to take risk (scale 1-10)"

gen take_risk_dummy=(take_risk>4)
replace take_risk_dummy=. if q428<0
label var take_risk_dummy "Willingness to take risk - above median"

estimates clear

**** Following regressions shows that people from Kresy insignificantly more risk averse
/*1*/ 
eststo: reg take_risk anybody_from_kresy $base_controls i.woj, cl(PSU_name) 
estadd ysumm

*** Main result controling for RA
/*2*/eststo:  reg edu_years     anybody_from_kresy  $base_controls i.woj take_risk, cl(PSU_name)
	estadd ysumm
/*3*/eststo:  reg secondary_edu anybody_from_kresy  $base_controls i.woj take_risk, cl(PSU_name)
	estadd ysumm
/*4*/eststo:  reg higher_edu    anybody_from_kresy  $base_controls i.woj take_risk, cl(PSU_name)
	estadd ysumm

	estout using "${path}/Results/Tables/Table_A20.tex", replace ///
				keep($show anybody_from_kresy take_risk) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))  style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.85cm] Region FE=age_birth_1950s", labels("{\checkmark}" "{ }"))
