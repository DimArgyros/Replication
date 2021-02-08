clear all
set matsize 5000
set more off

/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/
/*********************** RESPONDENT LEVEL ******************************/
/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/


use "${path}/Data/generated_data/ancestry_resplevel_replicate.dta", clear

global base_controls "age_birth* age_sq_birth* female rural city" 

******************
set more off
********************************************************************************************************************************************************************************************************************
***************      TABLES    ************************************************************************************************************************
********************************************************************************************************************************************************************************************************************

**********************************************************************************************************
***************      Table 3: panel A  *******************************************
**********************************************************************************************************


estimates clear
/*1*/eststo: reg  edu_years PL_kresy_origin , r
estadd ysumm
/*2*/eststo: reg  edu_years PL_kresy_origin $base_controls i.powiaty_code pow_FE_indicator , r
estadd ysumm
/*3*/eststo: reg  edu_years PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean $base_controls i.powiaty_code pow_FE_indicator  , r
estadd ysumm
/*4*/eststo: reg  edu_years PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean $base_controls i.gminy_code gminy_FE_indicator , r
estadd ysumm
/*5*/eststo: reg  edu_years PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean $base_controls i.powiaty_code pow_FE_indicator  if rural==1 , r
estadd ysumm
/*6*/eststo: reg  edu_years PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean $base_controls i.powiaty_code pow_FE_indicator  if rural==0 , r
estadd ysumm
/*7*/eststo: reg  secondary_edu PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean $base_controls i.powiaty_code pow_FE_indicator  , r
estadd ysumm
/*8*/eststo: reg  higher_edu PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean $base_controls i.powiaty_code pow_FE_indicator  , r
estadd ysumm
estout using "${path}/Results/Tables/Table_3_panel_A.tex", replace ///
				keep($show PL_kresy_origin PL_kresy_origin_mean PL_wt_origin_mean rural_origin_mean abroad_origin_mean) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))  style(tex) collabels(none) 
				
				
				
**For Footnote 19:
/*same spec as 2, without other anc shares*/ reg edu_years PL_kresy_origin_mean $base_controls i.powiaty_code pow_FE_indicator , r
				

****************************************************************************************************************************************************************************
**************     Table A.1 and Table A.2 : CBOS *************
****************************************************************************************************************************************************************************

cap log close
log using "${path}/Results/Tables/Tables_A1_A2_CBOS.smcl", replace
 
*** Table A.1 (Panel B) 
svyset numer_ankiety [pweight=weight2]
svy: mean edu_years secondary_edu higher_edu if PL_kresy_origin_mean!=.
estat sd

**For footnote 2 in Appendix -- unweighted:
sum edu_years secondary_edu higher_edu if PL_kresy_origin_mean!=.

*** Table A.2 (Panel D) 
svyset numer_ankiety [pweight=weight2]
svy: mean PL_kresy_origin PL_kresy_origin_mean PL_central_poland_origin_mean PL_wt_origin_mean if PL_kresy_origin_mean!=.
estat sd
svy: mean abroad_origin_mean if PL_kresy_origin_mean!=.
estat sd
svy: mean rural_origin_mean if PL_kresy_origin_mean!=.
estat sd

	
**For footnote 3 in Appendix -- unweighted:
sum PL_kresy_origin PL_kresy_origin_mean if PL_kresy_origin_mean!=.
		
*For note in Appendix text in Appendix Section IV.C "Comparing Coefficients at the Respondent vs. Ancestor Level in the Ancestry Survey":
tab PL_kresy_origin_mean if PL_kresy_origin==1	
tab PL_kresy_origin_mean
sum PL_kresy_origin_mean if (PL_kresy_origin==0 & PL_kresy_origin_mean==0)	

log close

**********************************************************************************************************
***************      Table A.5: (Table 3 with weights)   *********************************
**********************************************************************************************************

estimates clear
/*1*/eststo: reg  edu_years PL_kresy_origin [pw=weight2] , r
estadd ysumm
/*2*/eststo: reg  edu_years PL_kresy_origin $base_controls i.powiaty_code pow_FE_indicator [pw=weight2] , r
estadd ysumm
/*3*/eststo: reg  edu_years PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean $base_controls i.powiaty_code pow_FE_indicator  [pw=weight2] , r
estadd ysumm
/*4*/eststo: reg  edu_years PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean $base_controls i.gminy_code gminy_FE_indicator [pw=weight2] , r
estadd ysumm
/*5*/eststo: reg  edu_years PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean $base_controls i.powiaty_code pow_FE_indicator  [pw=weight2] if rural==1 , r
estadd ysumm
/*6*/eststo: reg  edu_years PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean $base_controls i.powiaty_code pow_FE_indicator  [pw=weight2] if rural==0 , r
estadd ysumm
/*7*/eststo: reg  secondary_edu PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean $base_controls i.powiaty_code pow_FE_indicator  [pw=weight2] , r
estadd ysumm
/*8*/eststo: reg  higher_edu PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean $base_controls i.powiaty_code pow_FE_indicator  [pw=weight2] , r
estadd ysumm
estout using "${path}/Results/Tables/Table_A5.tex", replace ///
				keep($show PL_kresy_origin PL_kresy_origin_mean PL_wt_origin_mean rural_origin_mean abroad_origin_mean) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))  style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.85cm] Respondent County FE=pow_FE_indicator" "\\[-0.85cm] Respondent Municipality FE=gminy_FE_indicator", labels("{\checkmark}" "{ }"))

**********************************************************************************************
***************      Table A.6: Any ancestor from Kresy vs share  *********************
**********************************************************************************************

gen self       = Q0a==1
gen parent     = (M_CP!=. | F_CP!=.)
gen grand      = (MM_CP!=. | MF_CP!=. | FF_CP!=. | FM_CP!=.)
gen greatgrand = (MMM_CP!=. | MMF_CP!=. | MFF_CP!=. | MFM_CP!=. | FFF_CP!=. | FFM_CP!=. | FMF_CP!=. | FMM_CP!=.)

gen PL_kresy_origin_mean_50andabove = PL_kresy_origin_mean>=0.5
label var PL_kresy_origin_mean_50andabove "Share of Kresy ancestors $\geq$ 50\%"

estimates clear
/*1*/eststo: reg  edu_years PL_kresy_origin PL_kresy_origin_mean_50andabove $base_controls i.powiaty_code pow_FE_indicator , r
estadd ysumm
/*2*/eststo: reg  edu_years PL_kresy_origin PL_kresy_origin_mean_50andabove $base_controls i.powiaty_code pow_FE_indicator self grand greatgrand, r
estadd ysumm
/*3*/eststo: reg  edu_years PL_kresy_origin PL_kresy_origin_mean_50andabove $base_controls i.gminy_code gminy_FE_indicator self grand greatgrand, r
estadd ysumm
estout using "${path}/Results/Tables/Table_A6.tex", replace ///
				keep($show PL_kresy_origin PL_kresy_origin_mean_50andabove) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par)) style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "Generation Controls$^{\ddag}$=self" "\\[-0.85cm] Respondent County FE=pow_FE_indicator" "\\[-0.85cm] Respondent Municipality FE=gminy_FE_indicator", labels("{\checkmark}" "{ }"))


**********************************************************************************
***************      Table A.7: Shares by generation  ************* 
**********************************************************************************

estimates clear
/*1*/eststo: reg  edu_years PL_kresy_origin_mean $base_controls i.powiaty_code pow_FE_indicator , r
estadd ysumm
/*2*/eststo: reg  edu_years PL_kresy_origin_mean $base_controls i.powiaty_code pow_FE_indicator if parent==1, r
estadd ysumm
/*3*/eststo: reg  edu_years PL_kresy_origin_mean $base_controls i.powiaty_code pow_FE_indicator if grand==1 , r
estadd ysumm
/*4*/eststo: reg  edu_years PL_kresy_origin_mean $base_controls i.powiaty_code pow_FE_indicator if greatgrand==1 , r
estadd ysumm
estout using "${path}/Results/Tables/Table_A7.tex", replace ///
				keep($show PL_kresy_origin_mean) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par)) style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.85cm] Respondent County FE=pow_FE_indicator", labels("{\checkmark}" "{ }"))
													
/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/
/*********************** ANCESTOR LEVEL ******************************/
/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/

use "${path}/Data/generated_data/ancestry_anclevel_replicate.dta", clear

global base_controls "age_birth* age_sq_birth* female rural city" 
global anc_controls "anc_in_wt anc_abroad rural_anc2 d_anc2 d_anc3" 

*********************************************************************************************
*** sumstats
**********************************************************************************************************
***************      Table A2: panel E *********************************************
**********************************************************************************************************				
cap log close
log using "${path}/Results/Tables/Table_A2_panel_E.smcl", replace

*** Table A.2 (Panel E) 
sum anc_in_kresy anc_in_cp anc_in_wt rural_anc2 anc_female_share  d_anc1 d_anc2 d_anc3 if anc_in_kresy!=.
log close

**********************************************************************************************************
***************      Table 3: panel B *********************************************
**********************************************************************************************************				
*In-text Section IV.B., subsection on "Ancestor-Level Analysis in the Ancestry Survey": share of parents, grandparents, great-grandparents
su d_anc1  d_anc2 d_anc3  

estimates clear
/*1*/eststo: reg edu_years     anc_in_kresy                d_anc2 d_anc3                                , cl(numer_ankiety)
estadd ysumm
/*1*/eststo: reg edu_years     anc_in_kresy $base_controls d_anc2 d_anc3 i.powiaty_code pow_FE_indicator, cl(numer_ankiety)
estadd ysumm
/*3*/eststo: reg edu_years     anc_in_kresy $base_controls $anc_controls i.powiaty_code pow_FE_indicator, cl(numer_ankiety)
estadd ysumm
/*4*/eststo: reg edu_years     anc_in_kresy $base_controls $anc_controls i.gminy_code gminy_FE_indicator, cl(numer_ankiety)  
estadd ysumm
/*5*/eststo: reg edu_years     anc_in_kresy $base_controls $anc_controls i.powiaty_code pow_FE_indicator if rural==1, cl(numer_ankiety)   
estadd ysumm
/*6*/eststo: reg edu_years     anc_in_kresy $base_controls $anc_controls i.powiaty_code pow_FE_indicator if rural==0, cl(numer_ankiety)   
estadd ysumm
/*7*/eststo: reg secondary_edu anc_in_kresy $base_controls $anc_controls i.powiaty_code pow_FE_indicator, cl(numer_ankiety)
estadd ysumm
/*8*/eststo: reg higher_edu    anc_in_kresy $base_controls $anc_controls i.powiaty_code pow_FE_indicator, cl(numer_ankiety)
estadd ysumm
estout using "${path}/Results/Tables/Table_3_panel_B.tex", replace ///
				keep($show anc_in_kresy anc_in_wt anc_abroad rural_anc2 d_anc2 d_anc3) label ///
                order($show anc_in_kresy anc_in_wt anc_abroad rural_anc2 d_anc2 d_anc3) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))   style(tex) collabels(none) 
				
				
**********************************************************************************************************
***************      Table 4               ****************************************
**********************************************************************************************************		
	
gen anc_POL_Kresy=1 if anc_POL_origin==1 & anc_in_kresy==1 
gen anc_UKR_Kresy=1 if anc_in_kresy==1 & anc_UKR_origin==1
recode anc_UKR_Kresy .=0 if  anc_in_kresy==0 & anc_UKR_origin~=.
label var anc_UKR_Kresy "Ancestor from Kresy, Ukraine"
gen sample_Ukraine=1 if anc_BLR_origin==0 & anc_LTU_origin==0 & anc_POL_Kresy~=1 & anc_UKR_Kresy~=.

estimates clear
*Ancestors from all of Kresy 
/*1*/eststo: reg edu_years anc_in_kresy $base_controls $anc_controls  i.powiaty_code pow_FE_indicator, cl(numer_ankiety)
estadd ysumm
/*2*/eststo: reg edu_years anc_in_kresy $base_controls $anc_controls  i.powiaty_code pow_FE_indicator if  rural_anc2==0, cl(numer_ankiety)
estadd ysumm
/*3*/eststo: reg edu_years anc_in_kresy $base_controls $anc_controls  i.powiaty_code pow_FE_indicator if  rural_anc2==1, cl(numer_ankiety) 
estadd ysumm
*Urban origin AND destination
/*4*/eststo: reg edu_years anc_in_kresy $base_controls $anc_controls i.powiaty_code pow_FE_indicator if  rural_anc2==0 & rural==0, cl(numer_ankiety)
estadd ysumm
*Only Ukraine -- exclude those from  //note: exactly same results with anc_UKR_Kresy as expl. var. 
/*5*/eststo: reg edu_years anc_in_kresy $base_controls $anc_controls i.powiaty_code pow_FE_indicator if sample_Ukraine==1, cl(numer_ankiety)
estadd ysumm
/*6*/eststo: reg edu_years anc_in_kresy $base_controls $anc_controls i.powiaty_code pow_FE_indicator if sample_Ukraine==1 & rural_anc2==0, cl(numer_ankiety)
estadd ysumm
/*7*/eststo: reg edu_years anc_in_kresy $base_controls $anc_controls i.powiaty_code pow_FE_indicator if sample_Ukraine==1 & rural_anc2==1, cl(numer_ankiety)
estadd ysumm
*Urban origin AND destination
/*8*/eststo: reg edu_years anc_in_kresy $base_controls $anc_controls i.powiaty_code pow_FE_indicator if sample_Ukraine==1 &  rural_anc2==0 & rural==0, cl(numer_ankiety)
estadd ysumm
estout using "${path}/Results/Tables/Table_4.tex", replace ///
				keep($show anc_in_kresy) label ///
                order($show ) stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))   style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.85cm] Ancestor Controls$^{\dag}$=d_anc2"  "\\[-0.85cm] Respondent County FE=pow_FE_indicator", labels("{\checkmark}" "{ }"))	


********************************************************************************************************************************************************************************************************************
***************      ADDITIONAL APPENDIX TABLES     ************************************************************************************************************************
********************************************************************************************************************************************************************************************************************	

************************************************************************************************************************ 
***************      Table A.8: Uniform Ancestry  (All ancestors from Kresy, or all from control group)  *********** 
************************************************************************************************************************ 

estimates clear
/*1*/eststo: reg  edu_years anc_in_kresy $base_controls i.powiaty_code pow_FE_indicator if ((anc_in_kresy==0 & PL_kresy_origin_mean==0) | anc_in_kresy==1), cl(numer_ankiety)
estadd ysumm
/*2*/eststo: reg  edu_years anc_in_kresy $base_controls i.powiaty_code pow_FE_indicator if ((anc_in_kresy==0 & PL_kresy_origin_mean==0) | anc_in_kresy==1) & d_anc1==1, cl(numer_ankiety)
estadd ysumm
/*3*/eststo: reg  edu_years anc_in_kresy $base_controls i.powiaty_code pow_FE_indicator if ((anc_in_kresy==0 & PL_kresy_origin_mean==0) | anc_in_kresy==1) & d_anc2==1, cl(numer_ankiety)
estadd ysumm
/*4*/eststo: reg  edu_years anc_in_kresy $base_controls i.powiaty_code pow_FE_indicator if ((anc_in_kresy==0 & PL_kresy_origin_mean==0) | anc_in_kresy==1) & d_anc3==1, cl(numer_ankiety)
estadd ysumm
estout using "${path}/Results/Tables/Table_A8.tex", replace ///
				keep($show anc_in_kresy) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))  style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.85cm] Respondent County FE=pow_FE_indicator", labels("{\checkmark}" "{ }"))				

**********************************************************************************************************
***************      Table A.11   *********************************************
**********************************************************************************************************

**************************************************************************************

/* merge ancestor information at Curzon border */
merge 1:1 id_ancestor using "${path}/Data/original_data/anc_id_curzon_line_distance.dta"
drop _merge

replace disCursLineKm=-disCursLineKm if anc_in_kresy==0
gen disCursLineKm_kresy=disCursLineKm*anc_in_kresy

gen anc_latitude1939_sq=anc_latitude1939_use*anc_latitude1939_use
gen anc_longitude1939_sq=anc_longitude1939_use*anc_longitude1939_use

gen anc_latitude_longitude=anc_latitude1939_use*anc_longitude1939_use

gen disCursLine_sq=disCursLineKm*disCursLineKm
gen disCursLine_sq_kresy=disCursLine_sq*anc_in_kresy			


estimates clear
/*1*/eststo: reg edu_years anc_in_kresy $base_controls i.powiaty_code pow_FE_indicator  if  abs(disCursLineKm)<150&(PL_kresy_origin_mean==0|PL_kresy_origin_mean==1)& wt_origin_mean==0, cl(numer_ankiety)
estadd ysumm
/*2*/eststo: reg edu_years anc_in_kresy $base_controls $anc_controls i.powiaty_code pow_FE_indicator  anc_latitude1939_use anc_longitude1939_use anc_latitude1939_sq anc_longitude1939_sq anc_latitude_longitude if  abs(disCursLineKm)<150&(PL_kresy_origin_mean==0|PL_kresy_origin_mean==1)& wt_origin_mean==0, cl(numer_ankiety)
estadd ysumm
/*3*/eststo: reg edu_years anc_in_kresy $base_controls $anc_controls i.gminy_code gminy_FE_indicator  anc_latitude1939_use anc_longitude1939_use anc_latitude1939_sq anc_longitude1939_sq anc_latitude_longitude if  abs(disCursLineKm)<150&(PL_kresy_origin_mean==0|PL_kresy_origin_mean==1)& wt_origin_mean==0, cl(numer_ankiety)
estadd ysumm
/*4*/eststo: reg edu_years anc_in_kresy $base_controls $anc_controls i.gminy_code gminy_FE_indicator  anc_latitude1939_use anc_longitude1939_use anc_latitude1939_sq anc_longitude1939_sq anc_latitude_longitude if  abs(disCursLineKm)<100&(PL_kresy_origin_mean==0|PL_kresy_origin_mean==1)& wt_origin_mean==0, cl(numer_ankiety)
estadd ysumm
/*5*/eststo: reg secondary_edu     anc_in_kresy $base_controls $anc_controls i.gminy_code gminy_FE_indicator  anc_latitude1939_use anc_longitude1939_use anc_latitude1939_sq anc_longitude1939_sq anc_latitude_longitude if  abs(disCursLineKm)<150&(PL_kresy_origin_mean==0|PL_kresy_origin_mean==1)& wt_origin_mean==0, cl(numer_ankiety)
estadd ysumm
/*6*/eststo: reg higher_edu        anc_in_kresy $base_controls $anc_controls i.gminy_code gminy_FE_indicator  anc_latitude1939_use anc_longitude1939_use anc_latitude1939_sq anc_longitude1939_sq anc_latitude_longitude if  abs(disCursLineKm)<150&(PL_kresy_origin_mean==0|PL_kresy_origin_mean==1)& wt_origin_mean==0, cl(numer_ankiety)
estadd ysumm

estout using "${path}/Results/Tables/Table_A11.tex", replace ///
				keep($show anc_in_kresy) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))   style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.85cm] Ancestor Controls$^{\dag}$=d_anc2" "\\[-0.75cm] RD Polynomial$^{\#}$=anc_latitude1939_use" ///
				"\\[-0.85cm] Respondent County FE=pow_FE_indicator" "\\[-0.85cm] Respondent Municipality FE=gminy_FE_indicator", labels("{\checkmark}" "{ }"))		

**********************************************************************************************************
***************      Table A.12 Contested Border Counties   *****************************************
**********************************************************************************************************

quietly{ 
	// generate variables and contested border sample
	
**** Generate dummy for the sample of ancestors who come from contested powiats close to the border
gen contested_sample_anc=0

local contested_powiaty_north   	"P1105	P1102	P1101	P1207	P1204	P0809	P0812	P0811	P0810	P0802	P0808	P0806	P0813	P0807	P1109	P0803	P0805"
local contested_powiaty_south   	"P1019	P1026	P1018	P1011	P1010	P1009	P1012	P1008	P1007	P1024	P1021	P1017	P1013	P1023	P1006	P1027	P1022 P1507 P1020"

foreach powcode in  `contested_powiaty_north' `contested_powiaty_south' {
replace contested_sample_anc=1 if anc_pow_code1931_use=="`powcode'" //ancestor is from contested county 
}

***** generate condition for ALL ancestors came from the Kresy part of the contested sample, or from the CP part of the contested sample:
egen mean_contested_sample_anc=mean(contested_sample_anc), by(numer_ankiety)
egen mean_anc_in_kresy_cont_sample=mean(anc_in_kresy), by(numer_ankiety), if mean_contested_sample_anc==1 //mean of Kresy origin across all ancestors, for those respondents where ALL ancestors came from contested counties
gen contested_county_sample = 1 if mean_contested_sample_anc==1 & (mean_anc_in_kresy==1 | mean_anc_in_kresy==0) //either ALL ancestors came from the Kresy part of the contested sample, or ALL from the CP part of the contested sample

label var contested_county_sample "All ancestors from contested counties"

sort numer_ankiety

**** Generate dummy for respondent sample (1 obs per respondent)
gen respondent_sample=0
replace respondent_sample=1 if numer_ankiety!=numer_ankiety[_n-1]
}
  
*****************************************************************************************************************
estimates clear
/*1*/eststo: xi: vcemway reg anc_lit_rcath_1921    anc_in_kresy $base_controls i.powiaty_code pow_FE_indicator  if contested_county_sample==1, cl(numer_ankiety anc_pow_code1931_use_cl)
estadd ysumm
/*2*/eststo: reg edu_years  anc_in_kresy  $base_controls i.powiaty_code pow_FE_indicator  if contested_county_sample==1 , cl(numer_ankiety)
estadd ysumm
/*3*/eststo: reg edu_years  anc_in_kresy  $base_controls $anc_controls i.powiaty_code pow_FE_indicator  if contested_county_sample==1, cl(numer_ankiety)
estadd ysumm
estout using "${path}/Results/Tables/Table_A12.tex", replace ///
				keep($show anc_in_kresy) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))   style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.85cm] Ancestor Controls$^{\dag}$=d_anc2"  "\\[-0.85cm] Respondent County FE=pow_FE_indicator", labels("{\checkmark}" "{ }"))	
	
/*For footnote 13  in Appendix  */
xi: vcemway reg anc_r_rcatholic_1931  anc_in_kresy  $base_controls i.powiaty_code pow_FE_indicator  if contested_county_sample==1, cl(numer_ankiety anc_pow_code1931_use_cl)
xi: vcemway reg anc_Lang_polish_1931  anc_in_kresy  $base_controls i.powiaty_code pow_FE_indicator  if contested_county_sample==1, cl(numer_ankiety anc_pow_code1931_use_cl)
 

**********************************************************************************************************
***************      Table A.13   *********************************************
**********************************************************************************************************	

*****  interactions with conditions at the origin ***************************************

foreach var in anc_Lang_ukranian_1931 anc_r_rcatholic_1931 anc_Lang_polish_1931 anc_Lang_russian_1931  anc_literate_1931 anc_urbanization_1931 anc_literate_1921 anc_lit_rcath_1921 anc_r_catholic_1921    {
  egen `var'_std = std(`var') 
  gen i_kr_`var'_std = anc_in_kresy * `var'_std
*  gen i_wt_`var'_std = anc_in_wt * `var'_std
}

*Above/Below Median Polish Speakers
xtile anc_Lang_polish_AM = anc_Lang_polish_1931_std, nquantiles(2)
replace anc_Lang_polish_AM = anc_Lang_polish_AM-1 //share of Polish speakers in 1931 above median
label var anc_Lang_polish_AM "Share Polish Speakers (1931) above median"
gen anc_Lang_polish_BM = 1-anc_Lang_polish_AM //share of Polish speakers in 1931 below median
label var anc_Lang_polish_BM "Share Polish Speakers (1931) below median"

gen i_kr_anc_Lang_Polish_BM = anc_in_kresy * anc_Lang_polish_BM
gen i_kr_anc_Lang_Polish_AM = anc_in_kresy * anc_Lang_polish_AM
label var i_kr_anc_Lang_Polish_AM "Share Polish Speakers (1931) above median $\times$ Kresy"
label var i_kr_anc_Lang_Polish_BM "Share Polish Speakers (1931) below median $\times$ Kresy"

label var anc_r_rcatholic_1931_std        "Share Rom. Cath., 1931 (std)"
label var i_kr_anc_r_rcatholic_1931_std   "Rom. Cath., 1931 (std) $\times$ Kresy"

label var anc_Lang_polish_1931_std        "Share Polish speakers, 1931 (std)"
label var i_kr_anc_Lang_polish_1931_std   "Polish speakers, 1931 (std) $\times$ Kresy"

label var anc_Lang_ukranian_1931_std	 "Share Ukrainian speakers, 1931 (std)"
label var i_kr_anc_Lang_ukranian_1931_std   "Ukrainian speakers, 1931 (std) $\times$ Kresy"
 
label var anc_Lang_russian_1931_std       "Share Russian speakers, 1931 (std)"
label var i_kr_anc_Lang_russian_1931_std  "Russian speakers, 1931 (std) $\times$ Kresy"

label var anc_literate_1931_std           "Literacy rate, 1931 (std)"
label var i_kr_anc_literate_1931_std      "Literacy rate, 1931 (std) $\times$ Kresy"

label var anc_urbanization_1931_std       "Urbanization rate, 1931 (std)"
label var i_kr_anc_urbanization_1931_std  "Urbanization rate, 1931 (std) $\times$ Kresy"

label var anc_literate_1921_std           "Literacy rate, 1921 (std)"
label var i_kr_anc_literate_1921_std      "Literacy rate, 1921 (std) $\times$ Kresy"

label var anc_lit_rcath_1921_std          "Literacy rate Rom. Cath., 1921 (std)"
label var i_kr_anc_lit_rcath_1921_std     "Literacy rate Rom. Cath., 1921 (std) $\times$ Kresy"

label var anc_r_catholic_1921_std         "Share Rom. Cath., 1921 (std)"
label var i_kr_anc_r_catholic_1921_std    "Rom. Cath., 1921 (std) $\times$ Kresy"




estimates clear

foreach var in anc_r_rcatholic_1931 anc_Lang_polish_1931   {
  eststo: vcemway reg edu_years anc_in_kresy `var'_std i_kr_`var'_std $base_controls $anc_controls  i.powiaty_code if anc_in_wt==0& anc_abroad==0, cl(numer_ankiety anc_pow_code1931_use_cl)
  estadd ysumm
}

eststo: vcemway reg  edu_years anc_in_kresy anc_Lang_polish_AM i_kr_anc_Lang_Polish_AM $base_controls $anc_controls i.powiaty_code if anc_in_wt==0& anc_abroad==0, cl(numer_ankiety anc_pow_code1931_use_cl)
estadd ysumm

foreach var in anc_Lang_ukranian_1931 anc_Lang_russian_1931 anc_literate_1931 anc_urbanization_1931 anc_literate_1921 anc_lit_rcath_1921   {
  eststo: vcemway reg  edu_years anc_in_kresy `var'_std i_kr_`var'_std $base_controls $anc_controls  i.powiaty_code if anc_in_wt==0& anc_abroad==0, cl(numer_ankiety anc_pow_code1931_use_cl)
  estadd ysumm
}

estout using "${path}/Results/Tables/Table_A13.tex", replace ///
				keep($show anc_in_kresy ///
				anc_r_rcatholic_1931_std	  i_kr_anc_r_rcatholic_1931_std   ///
				anc_Lang_polish_1931_std      i_kr_anc_Lang_polish_1931_std   ///
				anc_Lang_polish_AM 			  i_kr_anc_Lang_Polish_AM         ///
				anc_Lang_ukranian_1931_std    i_kr_anc_Lang_ukranian_1931_std ///
				anc_Lang_russian_1931_std     i_kr_anc_Lang_russian_1931_std  ///
				anc_literate_1931_std         i_kr_anc_literate_1931_std      ///
				anc_urbanization_1931_std     i_kr_anc_urbanization_1931_std  ///
				anc_literate_1921_std         i_kr_anc_literate_1921_std      ///
				anc_lit_rcath_1921_std        i_kr_anc_lit_rcath_1921_std     ///
				) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))  style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.75cm] Ancestor Controls$^{\dag}$=d_anc2" "\\[-0.75cm] Respondent County FE=age_birth_1950s ", labels("{\checkmark}" "{ }"))	

				
**********************************************************************************************************
***************      Table A.14   *********************************************
**********************************************************************************************************					
				
********* No heterogeneous effects w.r.t. soil quality at origin *********************************
********* climate conditions at the origin *************************************************************

***** merge soil quality of the origin location
gen powiaty_code_1931_str=anc_pow_code1931_use
label var  powiaty_code_1931_str "powiaty code 1931 at origin"
merge m:1 powiaty_code_1931_str using "${path}/Data/original_data/pow_1931_geo.dta"
drop if  _merge==2
drop _merge

foreach var in ann_prcp_cv ann_prcp_pet ann_prcp_sd ann_prcp ann_temp barley elevation grow_per potato q1_prcp_pet q2_prcp_pet q3_prcp_pet q4_prcp_pet rice ruggedness sunflower wheat {
rename `var' orig_`var'
}

label var orig_wheat        "Land suitability for wheat at origin"
label var orig_ann_temp     "Annual temperature at origin"
label var orig_ann_prcp_pet "Precip.-evatranspiration ratio at origin"
label var orig_ruggedness   "Ruggedness at origin"

foreach var in orig_wheat orig_ann_temp orig_ann_prcp_pet orig_ruggedness {
    egen `var'_std = std(`var') 
    gen i_kr_`var'_std = anc_in_kresy * `var'_std
    gen i_wt_`var'_std = anc_in_wt * `var'_std
}	

label var orig_wheat_std              "Land suitability for wheat at origin (std)"
label var i_kr_orig_wheat_std         "Land suit. for wheat (std) $\times$ Kresy"

label var orig_ann_temp_std           "Annual temperature at origin (std)"
label var i_kr_orig_ann_temp_std      "Annual temperature (std) $\times$ Kresy"

label var orig_ann_prcp_pet_std       "Precip.-evatranspiration ratio at origin (std)"
label var i_kr_orig_ann_prcp_pet_std  "Precip.-evatranspiration ratio (std) $\times$ Kresy"

label var orig_ruggedness_std         "Ruggedness at origin (std)"
label var i_kr_orig_ruggedness_std    "Ruggedness (std) $\times$ Kresy"

estimates clear

foreach var in orig_wheat orig_ann_temp orig_ann_prcp_pet orig_ruggedness {
  eststo: vcemway reg edu_years anc_in_kresy `var'_std i_kr_`var'_std i_wt_`var'_std $base_controls $anc_controls i.powiaty_code if anc_in_wt==0& anc_abroad==0, r cl(numer_ankiety anc_pow_code1931_use_cl)
  estadd ysumm
}

estout using "${path}/Results/Tables/Table_A14.tex", replace ///
				keep($show anc_in_kresy          ///
				orig_wheat_std          i_kr_orig_wheat_std    ///
				orig_ann_temp_std       i_kr_orig_ann_temp_std     ///
				orig_ann_prcp_pet_std   i_kr_orig_ann_prcp_pet_std ///
				orig_ruggedness_std     i_kr_orig_ruggedness_std   ///
				) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))   style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.75cm] Ancestor Controls$^{\dag}$=d_anc2" "\\[-0.75cm] Respondent County FE=age_birth_1950s ", labels("{\checkmark}" "{ }"))				
	
**********************************************************************************************************
***************      Table A.17   *************************************************
**********************************************************************************************************	

******************************* Table A.17 - Panel A *******************************************************				
estimates clear
eststo: reg secondary_edu anc_in_kresy  rural_anc2   d_anc2 d_anc3 $base_controls i.powiaty_code pow_FE_indicator if anc_lit_rcath_1921!=. & anc_in_wt==0 & anc_abroad==0, cl(numer_ankiety)
estadd ysumm
eststo: vcemway reg anc_lit_rcath_1921 anc_in_kresy  rural_anc2   d_anc2 d_anc3 $base_controls i.powiaty_code pow_FE_indicator if  anc_in_wt==0 & anc_abroad==0, cl(numer_ankiety anc_pow_code1931_use_cl)
estadd ysumm
eststo: reg secondary_edu anc_in_kresy  $base_controls   d_anc2 d_anc3 i.powiaty_code pow_FE_indicator if rural_anc2==1 & anc_lit_rcath_1921!=. &  anc_in_wt==0 & anc_abroad==0, cl(numer_ankiety)
estadd ysumm
eststo: vcemway reg anc_lit_rcath_1921 anc_in_kresy  $base_controls   d_anc2 d_anc3 i.powiaty_code pow_FE_indicator if rural_anc2==1  & anc_in_wt==0 & anc_abroad==0, cl(numer_ankiety anc_pow_code1931_use_cl)
estadd ysumm
eststo: reg secondary_edu anc_in_kresy  $base_controls   d_anc2 d_anc3 i.powiaty_code pow_FE_indicator if urban_anc2==1 & anc_lit_rcath_1921!=.  & anc_in_wt==0 & anc_abroad==0, cl(numer_ankiety)
estadd ysumm
eststo: vcemway reg anc_lit_rcath_1921 anc_in_kresy  $base_controls   d_anc2 d_anc3 i.powiaty_code pow_FE_indicator if urban_anc2==1 & anc_in_wt==0 & anc_abroad==0, cl(numer_ankiety anc_pow_code1931_use_cl)
estadd ysumm

estout using "${path}/Results/Tables/Table_A17_Panel_A.tex", replace ///
				keep($show anc_in_kresy rural_anc2) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}")	fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))  style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.85cm] Ancestor Controls$^{\dag}$=d_anc2"  "\\[-0.85cm] Respondent County FE=pow_FE_indicator", labels("{\checkmark}" "{ }"))

************************** Merge with Russian Census for Panel B ************************************
quietly{
preserve
use "${path}/Data/original_data/1897_russiancensus.dta", clear

local polish_literacy_var "litotherrate_mp litotherrate_fp litotherrate_p educrate_p litrusrate_p" 

keep  ID_powiaty_code_1931  `polish_literacy_var' 
rename  ID_powiaty_code_1931 anc_pow_code1931_str

collapse (mean) `polish_literacy_var' , by(anc_pow_code1931_str)


foreach var in `polish_literacy_var' {
rename `var' `var'1897
}

tempfile census_1897
save "`census_1897'", replace
restore

merge m:1 anc_pow_code1931_str using "`census_1897'"
drop _merge
gen anc_lit_pol_gend_1897= litotherrate_mp1897 if  anc_gender==2
replace anc_lit_pol_gend_1897= litotherrate_fp1897 if  anc_gender==1

rename litotherrate_p1897 anc_lit_pol_1897
label var anc_lit_pol_1897 "literacy of polish native speakers in non-russian language 1897"
label var anc_lit_pol_gend_1897 "literacy of polish native speakers in non-russian language 1897, gender specific"
label var anc_in_kresy "Ancestor from Kresy"
label var rural_anc2 "Ancestor from rural area"
}

******************************* Table A17 - Panel B *******************************************************

estimates clear
eststo: reg secondary_edu anc_in_kresy  rural_anc2 d_anc2 d_anc3 $base_controls i.powiaty_code pow_FE_indicator if anc_lit_pol_1897!=. & anc_in_wt==0 & anc_abroad==0, cl(numer_ankiety)
estadd ysumm
eststo: vcemway reg anc_lit_pol_1897 anc_in_kresy  rural_anc2 d_anc2 d_anc3 $base_controls i.powiaty_code pow_FE_indicator if anc_in_wt==0 & anc_abroad==0, cl(numer_ankiety anc_pow_code1931_use_cl)
estadd ysumm
eststo: reg secondary_edu anc_in_kresy  d_anc2 d_anc3 $base_controls i.powiaty_code pow_FE_indicator if rural_anc2==1&anc_lit_pol_1897!=. & anc_in_wt==0 & anc_abroad==0, cl(numer_ankiety)
estadd ysumm
eststo: vcemway reg anc_lit_pol_1897 anc_in_kresy  d_anc2 d_anc3 $base_controls i.powiaty_code pow_FE_indicator if rural_anc2==1 & anc_in_wt==0 & anc_abroad==0, cl(numer_ankiety anc_pow_code1931_use_cl)
estadd ysumm
eststo: reg secondary_edu anc_in_kresy  d_anc2 d_anc3 $base_controls i.powiaty_code pow_FE_indicator if urban_anc2==1&anc_lit_pol_1897!=. & anc_in_wt==0 & anc_abroad==0, cl(numer_ankiety)
estadd ysumm
eststo: vcemway reg anc_lit_pol_1897 anc_in_kresy  d_anc2 d_anc3 $base_controls i.powiaty_code pow_FE_indicator if urban_anc2==1 & anc_in_wt==0 & anc_abroad==0, cl(numer_ankiety anc_pow_code1931_use_cl)
estadd ysumm

estout using "${path}/Results/Tables/Table_A17_Panel_B.tex", replace ///
				keep($show anc_in_kresy rural_anc2) label ///
                order($show ) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))   style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.85cm] Ancestor Controls$^{\dag}$=d_anc2"  "\\[-0.85cm] Respondent County FE=pow_FE_indicator", labels("{\checkmark}" "{ }"))	
				

**********************************************************************************************************
***************      Table A.25    *******************************************
**********************************************************************************************************
	
******** missing information on kresy origin: Create variables

foreach var in anc_in_kresy anc_in_wt{
	replace `var'=0 if abroad_anc1==1
}
				
egen n_info=count(anc_in_kresy), by(numer_ankiety) 
egen sum_kresy=sum(anc_in_kresy), by(numer_ankiety) //total number of Kresy Ancestors for each respondent
egen sum_cp=sum(anc_in_cp), by(numer_ankiety)
egen sum_wt=sum(anc_in_wt), by(numer_ankiety)
egen sum_abroad=sum(abroad_anc1), by(numer_ankiety)

gen share_non_missing=n_info/2 if  anc_depth==1 //Parent generation
replace share_non_missing=n_info/4 if  anc_depth==2 //Grandparent generation
replace share_non_missing=n_info/8 if  anc_depth==3 //Great-grandparent generation
replace share_non_missing=1 if share_non_missing>1

gen share_kresy_total=sum_kresy/2 if  anc_depth==1
replace share_kresy_total=sum_kresy/4 if  anc_depth==2
replace share_kresy_total=sum_kresy/8 if  anc_depth==3
replace share_kresy_total=sum_kresy/n_info if  share_non_missing>1
replace share_kresy_total=1 if share_kresy_total>1

foreach var in cp wt abroad{
gen share_`var'_total=sum_`var'/2 if  anc_depth==1
replace share_`var'_total=sum_`var'/4 if  anc_depth==2
replace share_`var'_total=sum_`var'/8 if  anc_depth==3
replace share_`var'_total=sum_`var'/n_info if  share_non_missing>1
replace share_`var'_total=1 if share_`var'_total>1
}

gen share_missing=1-share_non_missing

**
label var share_missing "Share missing ancestor info$^{\dag}$"
label var share_non_missing "Share of ancestors with non-missing origin info"
label var share_kresy_total "Share of ancestors from Kresy out of all potential ancestors"
label var share_wt_total "Share of ancestors from WT out of all potential ancestors"
label var share_abroad_total "Share of ancestors from abroad out of all potential ancestors"
label var share_cp_total "Share of ancestors from CP out of all potential ancestors"

label var PL_kresy_origin_mean "Share of Ancestors, Kresy"
label var PL_wt_origin_mean "Share of Ancestors, WT"
label var abroad_origin_mean "Share of Ancestors, abroad" 
label var rural_origin_mean "Share of Ancestors, rural" 

** In-text note in Section VI.B., subsection on "Recall Bias: Missing Information About Ancestor Origin Locations":
sum share_missing


estimates clear
/*1*/eststo: reg share_missing PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean               $base_controls i.powiaty_code pow_FE_indicator if respondent_sample==1 , r
estadd ysumm
/*2*/eststo: reg edu_years                                                                                 share_missing $base_controls i.powiaty_code pow_FE_indicator if e(sample) & respondent_sample==1 , r
estadd ysumm
/*3*/eststo: reg edu_years     PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean share_missing $base_controls i.powiaty_code pow_FE_indicator if respondent_sample==1 , r
estadd ysumm
/*4*/eststo: reg secondary_edu PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean share_missing $base_controls i.powiaty_code pow_FE_indicator if respondent_sample==1 , r
estadd ysumm
/*5*/eststo: reg higher_edu    PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean share_missing $base_controls i.powiaty_code pow_FE_indicator if respondent_sample==1 , r
estadd ysumm
estout using "${path}/Results/Tables/Table_A25.tex", replace ///
				keep(PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean share_missing) label ///
                order(PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean share_missing) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))   style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.85cm] Respondent County FE=pow_FE_indicator", labels("{\checkmark}" "{ }"))		

**********************************************************************************************************
***************      Table A.26    *******************************************
**********************************************************************************************************

estimates clear
/*1*/eststo: reg share_missing PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean               $base_controls i.powiaty_code pow_FE_indicator [pw=weight2] if respondent_sample==1 , r
estadd ysumm
/*2*/eststo: reg edu_years                                                                                 share_missing $base_controls i.powiaty_code pow_FE_indicator [pw=weight2] if e(sample) & respondent_sample==1 , r
estadd ysumm
/*3*/eststo: reg edu_years     PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean share_missing $base_controls i.powiaty_code pow_FE_indicator [pw=weight2] if respondent_sample==1 , r
estadd ysumm
/*4*/eststo: reg secondary_edu PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean share_missing $base_controls i.powiaty_code pow_FE_indicator [pw=weight2] if respondent_sample==1 , r
estadd ysumm
/*5*/eststo: reg higher_edu    PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean share_missing $base_controls i.powiaty_code pow_FE_indicator [pw=weight2] if respondent_sample==1 , r
estadd ysumm
estout using "${path}/Results/Tables/Table_A26.tex", replace ///
				keep(PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean share_missing) label ///
                order(PL_kresy_origin_mean PL_wt_origin_mean abroad_origin_mean rural_origin_mean share_missing) prefoot("\hline") stats(ymean r2 N, layout(@ "{@}") fmt(2 2 %9.0gc) labels("Mean Dep. Var." "R$^2$" "Observations")) ///
                mlabels(, title prefix(%) begin(%)) postfoot("\addlinespace[0.15cm] ") end("\\[-0.15cm]") varlabels(, end("\addlinespace[0.15cm] ")) ///
                cells(b(fmt(3) nostar) se(fmt(3) par))  style(tex) collabels(none) ///
				indicate("Baseline Controls$^{\ddag}$=female" "\\[-0.85cm] Respondent County FE=pow_FE_indicator", labels("{\checkmark}" "{ }"))		
				
		
*************************************************************************************************************************************************************************
************          FIGURES          *************************************************************************************
*************************************************************************************************************************************************************************	

**********************************************************************************************************
************     Figure 5   *********************************************
**********************************************************************************************************

preserve
	keep if (PL_kresy_origin_mean==0|PL_kresy_origin_mean==1)& wt_origin_mean==0

	reg edu_years i.gminy_code city rural age age_sq female 
	cap drop imp_yedu_resid
	predict imp_yedu_resid, resid
	label var imp_yedu_resid "Years of education in 2016 (residuals)"
	
set seed 123456789 /* just for bins on the graph, not needed for the actual results */
set sortseed 123456789 /* just for bins on the graph, not needed for the results */

	capture drop bins 

	local binsize 8
	
	gen bins=int((disCursLineKm+`binsize')/`binsize') if disCursLineKm>0
	replace bins=int((disCursLineKm-`binsize')/`binsize') if disCursLineKm<0

	local width 149

	capture drop sum_bins_* count_bins_* vot_bins_*
	egen sum_bins_imp_yedu_resid=sum(imp_yedu_resid) if (disCursLineKm!=.), by( bins) 
	egen count_bins_imp_yedu_resid=count(imp_yedu_resid) if (disCursLineKm!=.), by( bins) 
	gen vot_bins_imp_yedu_resid=sum_bins_imp_yedu_resid/count_bins_imp_yedu_resid

	label var vot_bins_imp_yedu_resid "mean by distance bins of `binsize'km"
	sort disCursLineKm bins vot_bins_imp_yedu_resid 
	cap drop flag
	gen flag=1 if bins==bins[_n-1]&vot_bins_imp_yedu_resid==vot_bins_imp_yedu_resid[_n-1]
	replace vot_bins_imp_yedu_resid =. if flag==1


	******************************* Figure 5 *******************************************************
	twoway (lfitci imp_yedu_resid disCursLineKm if (disCursLineKm)<`width'&(disCursLineKm)>0&(disCursLineKm!=.), ///
	fcolor(gs14) level(90) xline(0) title(`: variable label imp_yedu_resid') clpattern(solid) alpattern(dash) ///
	xtitle("Migrants with ancestors from CP (left) and Kresy (right)") lcolor(black) lpattern(dash) xlabel(-150(25)150)) ///
	|| ( lfitci imp_yedu_resid disCursLineKm if (disCursLineKm)>-`width'&(disCursLineKm)<0&(disCursLineKm!=.),  level(90) ///
	lcolor(black) fcolor(gs14) clpattern(solid) alpattern(dash)) ///
	 || (scatter vot_bins_imp_yedu_resid disCursLineKm if abs(disCursLineKm)<`width'&(disCursLineKm!=.), msymbol(smcircle_hollow)) , legend(off) scheme(s1mono)

	graph export "${path}/Results/Figures/Fig_5.pdf", as(pdf) replace
	graph export "${path}/Results/Figures/Fig_5.eps", as(eps) replace 
restore
  
  
