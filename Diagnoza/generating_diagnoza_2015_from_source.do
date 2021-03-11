clear
clear matrix

global directory_diagnoza "${path}/Original_source_data/Diagnoza"

set mem 1g
set more off


******* TRANSLATION ******************************xv
* NOTE ON INCODING unicode encoding set ibm-921_P100-1995
******************************************xv

cd "$directory_diagnoza/source_diagnoza_files"


***********************************************************
**** Use individual survey data

use ds_0_15_ind_14112015.dta, clear

quietly { 
sort numer150730
merge 1:1 numer150730 using powiaty_individual_data.dta

drop _merge

rename NUMER_GD hh

gen powiaty_code=WOJEWODZTWO*100+POWIAT
rename WOJEWODZTWO woj

rename numer150730 number
 
gen female=PLEC_ALL
recode female 1=0 2=1
cap label variable female `"female "'

*****marital_status
recode HC11 1=1 2 6=2 3=3 4 5=4
recode GC11 1=1 2 6=2 3=3 4 5=4
recode fC11 1=1 2 6=2 3=3 4 5=4 
recode ec11 1=1 2 6=2 3=3 4 5=4
recode dc10 1=1 2 6=2 3=3 4 5=4
recode cc10 1=1 2 6=2 3=3 4 5=4
recode bc10 1=1 2=2 3=3 4 5=4
recode ac8  1=1 2=2 3=3 4 5=4

***********************************************************
*** Create the consistent variables across waves (the same questions appear under different numbers):

#delimit;

capture gen satisfaction_my_education2015=HP63_11; capture gen satisfaction_my_education2013=GP62_11; capture gen satisfaction_my_education2011=fp63_11;capture gen satisfaction_my_education2009=ep64_14; capture gen satisfaction_my_education2007=dp61_14; capture gen satisfaction_my_education2005=cp67_14; capture gen satisfaction_my_education2003=bp67_14; capture gen satisfaction_my_education2000=ap77_17;

capture gen aspiration_educhildren2015=HH2; capture gen aspiration_educhildren2013=GH2; capture gen aspiration_educhildren2011= fh2; capture gen aspiration_children2009=eh2; capture gen aspiration_educhildren2007=.;  capture gen aspiration_educhildren2005=.;  capture gen aspiration_educhildren2003=.;  capture gen aspiration_educhildren2000 =.; 
capture gen children_year_of_birth2015=HC9; capture gen children_year_of_birth2013=GC9; capture gen children_year_of_birth2011=fc9; capture gen children_year_of_birth2009=ec9;  capture gen children_year_of_birth2007=.;  capture gen children_year_of_birth2005=.;  capture gen children_year_of_birth2003=.;  capture gen children_year_of_birth2000=.; 
capture gen children_education_achieved2015=HC17; capture gen children_education_achieved2013=GC17; capture gen children_education_achieved2011=.; capture gen children_education_achieved2009=.; capture gen children_education_achieved2007=.;  capture gen children_education_achieved2005=.;  capture gen children_education_achieved2003=.; capture gen children_education_achieved2000=.; 
capture gen father_education_level2015=; capture gen father_education_level2013=; capture gen father_education_level2011=fp49; capture gen father_education_level2009=ep51; gen father_education_level2007=dp48;  capture gen father_education_level2005=cp56;  capture gen father_education_level2003=.; capture gen father_education_level2000=.;  
capture gen material_goods_lifesuccess2015=HP57_04; capture gen material_goods_lifesuccess2013=GP54_04; capture gen material_goods_lifesuccess2011=fp58_4; capture gen material_goods_lifesuccess2009=ep56_4;  capture gen material_goods_lifesuccess2007=dp50_2;  capture gen material_goods_lifesuccess2005=cp54_3;  capture gen material_goods_lifesuccess2003=.; capture gen material_goods_lifesuccess2000=.; 
 
 
capture gen satisfaction_country_sit2015=HP63_06;capture gen satisfaction_country_sit2013= GP62_06;capture gen satisfaction_country_sit2011=fp63_6; capture gen satisfaction_countrysit2009=ep64_8;capture gen satisfaction_country_sit2007=dp61_8;capture gen satisfaction_country_sit2005=cp67_8;capture gen satisfaction_country_sit2003=bp67_8;capture gen satisfaction_country_sit2000=ap77_11;
capture gen satisfaction_finsituation2015=HP63_02;capture gen satisfaction_finsituation2013= GP62_02;capture gen satisfaction_finsituation2011=fp63_2; capture gen satisfaction_finsituation2009=ep64_2;capture gen satisfaction_finsituation2007=dp61_2;capture gen satisfaction_finsituation2005=cp67_2;capture gen satisfaction_finsituation2003=bp67_2;capture gen satisfaction_finsituation2000=ap77_2;
capture gen satisfaction_safety2015=HP63_16;capture gen satisfaction_safety2013=GP62_16; capture gen satisfaction_safety2011=fp63_16;capture gen satisfaction_safety2009=ep64_20;capture gen satisfaction_safety2007=dp61_20 ;capture gen satisfaction_safety2005=cp67_20;capture gen satisfaction_safety2003=bp67_20;capture gen satisfaction_safety2000=ap77_23; 
capture gen death_penalty_restored2015=HP57_18; capture gen death_penalty_restored2013=.;capture gen death_penalty_restored2011=.;capture gen death_penalty_restored2009=.;capture gen death_penalty_restored2007=.;capture gen death_penalty_restored2005=.;capture gen death_penalty_restored2003=.;capture gen death_penalty_restored2000=.;
capture gen civil_partnership_legalized2015=HP57_20;capture gen civil_partnership_legalized2013=.;capture gen civil_partnership_legalized2011=.;capture gen civil_partnership_legalized2009=.;capture gen civil_partnership_legalized2007=.;capture gen civil_partnership_legalized2005=.;capture gen civil_partnership_legalized2003=.;capture gen civil_partnership_legalized2000=.; 
capture gen true_polish_patriot2015=HP57_09;capture gen true_polish_patriot2013=GP54_10; capture gen true_polish_patriot2011=fp58_11; capture gen true_polish_patriot2009=ep56_13; capture gen true_polish_patriot2007=.; capture gen true_polish_patriot2005=.; capture gen true_polish_patriot2003=.; capture gen true_polish_patriot2000=.;   
capture gen smolensk_accident_attack2015= HP109_2; capture gen smolensk_accident_attack2013=GP110_2; capture gen smolensk_accident_attack2011=fp105_2; capture gen smolensk_accident_attack2009=.; capture gen smolensk_accident_attack2007=.; capture gen smolensk_accident_attack2005=.; capture gen smolensk_accident_attack2004=.; capture gen smolensk_accident_attack2000=.; 


capture gen  norms_taxes2015=HP67_1;capture gen  norms_taxes2013=GP66_1; capture gen norms_taxes2011=fp67_1; capture gen norms_taxes2009=ep65_1; capture gen  norms_taxes2007=dp70_1; capture gen  norms_taxes2005=cp75_1; capture gen  norms_taxes2003=; capture gen  norms_taxes2000=; 
capture gen  norms_transport2015=HP67_2; capture gen norms_transport2013=GP66_2; capture gen norms_transport2011=fp67_2; capture gen norms_transport2009=ep65_2; capture gen  norms_transport2007=dp70_2; capture gen  norms_transport2005=cp75_2; capture gen  norms_transport2003=; capture gen  norms_transport2000=; 
capture gen  norms_electricity2015=.; capture gen  norms_electricity2013=.; capture gen norms_electricity2011=.; capture gen norms_electricity2009=ep65_3; capture gen  norms_electricity2007=dp70_3; capture gen  norms_electricity2005=cp75_3; capture gen  norms_electricity2003=; capture gen  norms_electricity2000=; 
capture gen  norms_unempbenefits2015=HP67_3; capture gen norms_unempbenefits2013=GP66_3; capture gen norms_unempbenefits2011=fp67_3; capture gen norms_unempbenefits2009=ep65_4; capture gen  norms_unempbenefits2007=dp70_4; capture gen  norms_unempbenefits2005=cp75_4; capture gen  norms_unempbenefits2003=; capture gen  norms_unempbenefits2000=; 
capture gen  norms_rent2015=HP67_4; capture gen norms_rent2013=GP66_4; capture gen norms_rent2011=fp67_4; capture gen norms_rent2009=ep65_5; capture gen  norms_rent2007=dp70_5; capture gen  norms_rent2005=cp75_5; capture gen  norms_rent2003=; capture gen  norms_rent2000=; 
capture gen  norms_tariffs2015=.;  capture gen  norms_tariffs2013=.; capture gen norms_tariffs2011=.; capture gen norms_tariffs2009=ep65_6; capture gen  norms_tariffs2007=dp70_6; capture gen  norms_tariffs2005=cp75_8; capture gen  norms_tariffs2003=; capture gen  norms_tariffs2000=; 
capture gen  trust2015=HP58;  capture gen  trust2013=GP55; capture gen trust2011=fp62; capture gen trust2009=ep60; capture gen  trust2007=dp65; capture gen  trust2005=cp70; capture gen  trust2003=bp100; capture gen  trust2000=; 
capture gen  trust_president2015=HP105_04; capture gen trust_president2013=GP104_04; capture gen trust_president2011=fp98_4; capture gen trust_president2009=ep101_3; capture gen  trust_president2007=; capture gen  trust_president2005=; capture gen  trust_president2003=; capture gen  trust_president2000=; 
capture gen  trust_sejm2015=HP105_03; capture gen  trust_sejm2013=GP104_03; capture gen trust_sejm2011=fp98_3; capture gen trust_sejm2009=ep101_2; capture gen  trust_sejm2007=; capture gen  trust_sejm2005=; capture gen  trust_sejm2003=; capture gen  trust_sejm2000=; 
capture gen  trust_police2015=HP105_06; capture gen  trust_police2013=GP104_06; capture gen trust_police2011=fp98_6; capture gen trust_police2009=ep101_7; capture gen  trust_police2007=; capture gen  trust_police2005=; capture gen  trust_police2003=; capture gen  trust_police2000=; 
capture gen  trust_government2015=HP105_07; capture gen  trust_government2013=GP104_07; capture gen trust_government2011=fp98_7; capture gen trust_government2009=ep101_8; capture gen  trust_government2007=; capture gen  trust_government2005=; capture gen  trust_government2003=; capture gen  trust_government2000=; 
capture gen  going_tomess_everyweek2015=HP38; capture gen going_tomess_everyweek2013=GP38; capture gen going_tomess_everyweek2011=fp39; capture gen going_tomess_everyweek2009=ep39; capture gen  going_tomess_everyweek2007=dp43; capture gen  going_tomess_everyweek2005=cp45; capture gen  going_tomess_everyweek2003=bp59; capture gen  going_tomess_everyweek2000=ap82; 
capture gen  intend_emigrate2015=HP96; capture gen  intend_emigrate2013=GP96; capture gen intend_emigrate2011=fp96; capture gen intend_emigrate2009=ep95; capture gen  intend_emigrate2007=dp102; capture gen  intend_emigrate2005=; capture gen  intend_emigrate2003=; capture gen  intend_emigrate2000=; 
capture gen  engaged_local2015=HP46; capture gen  engaged_local2013=GP46;capture gen engaged_local2011=fp47; capture gen engaged_local2009=ep49; capture gen  engaged_local2007=dp52; capture gen  engaged_local2005=cp66; capture gen  engaged_local2003=bp70; capture gen  engaged_local2000=ap118; 

capture gen  participated_meeting2015=HP55; capture gen  participated_meeting2013=GP53; capture gen participated_meeting2011=fp50; capture gen participated_meeting2009=ep52; capture gen  participated_meeting2007=dp62; capture gen  participated_meeting2005=cp68; capture gen  participated_meeting2003=bp105; capture gen  participated_meeting2000=; 
capture gen  materialsat2015=;  capture gen  materialsat2013=; capture gen  materialsat2011=; capture gen materialsat2009=ep34; capture gen  materialsat2007=dp38; capture gen  materialsat2005=cp38; capture gen  materialsat2003=bp38; capture gen  materialsat2000=ap46; 
capture gen  lastyear_successful2015=HP60; capture gen  lastyear_successful2013=GP57; capture gen lastyear_successful2011=fp59; capture gen lastyear_successful2009=ep57; capture gen  lastyear_successful2007=dp59; capture gen  lastyear_successful2005=cp64; capture gen  lastyear_successful2003=bp68; capture gen  lastyear_successful2000=ap75; 

capture gen  lifesatcurrent2015=HP34; capture gen  lifesatcurrent2013=GP34; capture gen lifesatcurrent2011=fp35; capture gen lifesatcurrent2009=ep35; capture gen  lifesatcurrent2007=dp39; capture gen  lifesatcurrent2005=cp39; capture gen  lifesatcurrent2003=bp40; capture gen  lifesatcurrent2000=ap48; 
capture gen  lifesat2015=HP3;  capture gen  lifesat2013=GP3; capture gen lifesat2011=fp3; capture gen lifesat2009=ep3; capture gen  lifesat2007=dp3; capture gen  lifesat2005=cp3; capture gen  lifesat2003=bp3; capture gen  lifesat2000=ap3; 
capture gen  reform1989pos_yourlife2015=; capture gen  reform1989pos_yourlife2013=; capture gen reform1989pos_yourlife2011=; capture gen reform1989pos_yourlife2009=; capture gen  reform1989pos_yourlife2007=dp55; capture gen  reform1989pos_yourlife2005=cp59; capture gen  reform1989pos_yourlife2003=bp63; capture gen  reform1989pos_yourlife2000=ap80; 
capture gen  reform1989succeeded2015=HP42; capture gen  reform1989succeeded2013=GP42; capture gen reform1989succeeded2011=fp43; capture gen reform1989succeeded2009=ep43; capture gen  reform1989succeeded2007=dp51; capture gen  reform1989succeeded2005=cp57; capture gen  reform1989succeeded2003=bp61; capture gen  reform1989succeeded2000=ap78; 
capture gen  lifebetterthan19892015=.; capture gen  lifebetterthan19892013=.; capture gen lifebetterthan19892011=fp4; capture gen lifebetterthan19892009=ep39; capture gen  lifebetterthan19892007=dp43; capture gen  lifebetterthan19892005=cp45; capture gen  lifebetterthan19892003=bp59; capture gen  lifebetterthan19892000=ap82; 

capture gen  trust_ZUS2015=HP105_08; capture gen  trust_ZUS2013=GP104_08; capture gen  trust_ZUS2011=fp98_8; capture gen trust_ZUS2009=ep101_9; capture gen  trust_ZUS2007=dp108_7; capture gen  trust_ZUS2005=; capture gen  trust_ZUS2003=; capture gen  trust_ZUS2000=; 
capture gen  trust_banks2015=HP105_01; capture gen  trust_banks2013=GP104_01; capture gen  trust_banks2011=fp98_1; capture gen trust_banks2009=ep101_1; capture gen  trust_banks2007=dp108_1; capture gen  trust_banks2005=cp46_1; capture gen  trust_banks2003=bp48_1; capture gen  trust_banks2000=; 
capture gen  trust_stockexchange2015=HP105_09; capture gen  trust_stockexchange2013=GP104_09;  capture gen  trust_stockexchange2011=; capture gen trust_stockexchange2009=; capture gen  trust_stockexchange2007=dp108_6; capture gen  trust_stockexchange2005=cp46_6; capture gen  trust_stockexchange2003=bp48_6; capture gen  trust_stockexchange2000=; 
capture gen  membership2015=HP48; capture gen  membership2013=GP48; capture gen membership2011=fp52; capture gen membership2009=ep61; capture gen  membership2007=dp68; capture gen  membership2005=cp103; capture gen  membership2003=bp102; capture gen  membership2000=; 
capture gen  prefer_democracy2015=HP64;  capture gen  prefer_democracy2013=GP63; capture gen prefer_democracy2011=fp64; capture gen prefer_democracy2009=ep102; capture gen  prefer_democracy2007=dp71; capture gen  prefer_democracy2005=cp102; capture gen  prefer_democracy2003=bp99; capture gen  prefer_democracy2000=; 

capture gen  voted2015=HP28; capture gen  voted2013=GP28; capture gen voted2011=fp28; capture gen voted2009=ep28; capture gen  voted2007=dp32; capture gen  voted2005=; capture gen  voted2003=; capture gen  voted2000=; 
capture gen  revenues_equal2015=HP57_14; capture gen  revenues_equal2013=GP54_18; capture gen revenues_equal2011=fp58_21; capture gen revenues_equal2009=ep56_26; capture gen  revenues_equal2007=dp50_14; capture gen  revenues_equal2005=cp54_12; capture gen  revenues_equal2003=; capture gen  revenues_equal2000=; 
capture gen  norms_satisfaction2015=; capture gen  norms_satisfaction2013=; capture gen norms_satisfaction2011=; capture gen norms_satisfaction2009=ep64_16; capture gen  norms_satisfaction2007=dp61_16; capture gen  norms_satisfaction2005=cp67_16; capture gen  norms_satisfaction2003=bp67_16; capture gen  norms_satisfaction2000=ap77_19; 
capture gen  EUpos_yourlife2015=;  capture gen  EUpos_yourlife2013=; capture gen EUpos_yourlife2011=; capture gen EUpos_yourlife2009=ep45; capture gen  EUpos_yourlife2007=; capture gen  EUpos_yourlife2005=; capture gen  EUpos_yourlife2003=; capture gen  EUpos_yourlife2000=; 
capture gen  xenophobia2015=HP57_10; capture gen  xenophobia2013=GP54_12; capture gen xenophobia2011=fp58_13; capture gen xenophobia2009=ep56_15; capture gen  xenophobia2007=; capture gen  xenophobia2005=; capture gen  xenophobia2003=; capture gen  xenophobia2000=; 
capture gen  tolerance_homo2015=HP57_08; capture gen  tolerance_homo2013=GP54_9; capture gen tolerance_homo2011=fp58_10; capture gen tolerance_homo2009=ep56_11; capture gen  tolerance_homo2007=; capture gen  tolerance_homo2005=; capture gen  tolerance_homo2003=; capture gen  tolerance_homo2000=; 
capture gen  successful_life_money2015=HP2_01;  capture gen  successful_life_money2013=GP2_01; capture gen successful_life_money2011=fp2_1; capture gen successful_life_money2009=ep2_1; capture gen  successful_life_money2007=dp2_1; capture gen  successful_life_money2005=cp2_1; capture gen  successful_life_money2003=; capture gen  successful_life_money2000=; 
capture gen  successful_life_God2015=HP2_06; capture gen  successful_life_God2013=GP2_06; capture gen successful_life_God2011=fp2_6; capture gen successful_life_God2009=ep2_6; capture gen  successful_life_God2007=dp2_6; capture gen  successful_life_God2005=cp2_6; capture gen  successful_life_God2003=; capture gen  successful_life_God2000=; 
capture gen  successful_life_freedom2015=HP2_10;  capture gen  successful_life_freedom2013=GP2_10; capture gen successful_life_freedom2011=fp2_10; capture gen successful_life_freedom2009=ep2_10; capture gen  successful_life_freedom2007=dp2_10; capture gen  successful_life_freedom2005=cp2_10; capture gen  successful_life_freedom2003=; capture gen  successful_life_freedom2000=; 
capture gen  successful_life_work2015=HP2_04; capture gen  successful_life_work2013=GP2_04; capture gen successful_life_work2011=fp2_4; capture gen successful_life_work2009=ep2_4; capture gen  successful_life_work2007=dp2_4; capture gen  successful_life_work2005=cp2_4; capture gen  successful_life_work2003=; capture gen  successful_life_work2000=; 
capture gen  some_notdeserve_respect2015=HP57_13;capture gen  some_notdeserve_respect2013=GP54_17; capture gen some_notdeserve_respect2011=fp58_20; capture gen some_notdeserve_respect2009=ep56_24; capture gen  some_notdeserve_respect2007=dp50_13; capture gen  some_notdeserve_respect2005=cp54_11; capture gen  some_notdeserve_respect2003=; capture gen  some_notdeserve_respect2000=; 
capture gen  stable_residence2015=; capture gen  stable_residence2013=; capture gen stable_residence2011=; capture gen stable_residence2009=; capture gen  stable_residence2007=dp31; capture gen  stable_residence2005=; capture gen  stable_residence2003=; capture gen  stable_residence2000=;
capture gen  have_mobile2015=.; capture gen  have_mobile2013=.; capture gen have_mobile2011=fC29; capture gen have_mobile2009=ec25; capture gen  have_mobile2007=dc24; capture gen  have_mobile2005=; capture gen  have_mobile2003=bc16; capture gen  have_mobile2000=; 

capture gen  used_bribes2015=HP26; capture gen  used_bribes2013=GP26; capture gen used_bribes2011=fp26; capture gen used_bribes2009=ep26; capture gen  used_bribes2007=dp29; capture gen  used_bribes2005=cp29; capture gen  used_bribes2003=bp29; capture gen  used_bribes2000=ap33; 
capture gen  number_friends2015=HP39; capture gen  number_friends2013=GP39; capture gen number_friends2011=fp40; capture gen number_friends2009=ep40; capture gen  number_friends2007=dp44; capture gen  number_friends2005=cp48; capture gen  number_friends2003=bp53; capture gen number_friends2000=ap65; 

capture gen fear_criminality2015=HP19; capture gen fear_criminality2013=GP19; capture gen fear_criminality2011=fP19; capture gen fear_criminality2009=ep20; capture gen fear_criminality2007=dp23; capture gen fear_criminality2005=cp23; capture gen fear_criminality2003=bp23; capture gen fear_criminality2000=ap25; 

gen occupation_isco_active2009= E_10GRUP_ZAWODOWYCH_AKTYWNI;gen occupation_isco_active2011= F_10GRUP_ZAWODOWYCH_AKTYWNI; gen occupation_isco_active2013= G_10GRUP_ZAWODOWYCH_AKTYWNI; gen occupation_isco_active2015= H_10GRUP_ZAWODOWYCH_AKTYWNI;
gen occupation_isco_passive2009= E_10GRUP_ZAWODOWYCH_BIERNI;gen occupation_isco_passive2011= F_10GRUP_ZAWODOWYCH_BIERNI; gen occupation_isco_passive2013= G_10GRUP_ZAWODOWYCH_BIERNI; gen occupation_isco_passive2015= H_10GRUP_ZAWODOWYCH_BIERNI;


*** marital status;
#delimit cr
capture gen marital_status2015=HC11
capture gen marital_status2013=GC11
capture gen marital_status2011=fC11
capture gen marital_status2009=ec11
capture gen marital_status2007=dc10
capture gen marital_status2005=cc10
capture gen marital_status2003=bc10
capture gen marital_status2000=ac8

*** attitudes
capture gen people_equal2011=fp58_16
capture gen people_equal2013=GP54_16

foreach time in 2000 2003 2005 2007 2009 2015{
capture gen people_equal`time'=.
}
capture gen trust_courts2015=HP105_10
capture gen trust_courts2013=GP104_11
capture gen trust_courts2011=fp98_11
foreach time in 2000 2003 2005 2007 2009 {
capture gen trust_courts`time'=.
}

capture gen trust_myfamily2013=GP104_14
capture gen trust_myfamily2011=fp98_13
foreach time in 2000 2003 2005 2007 2009 2015 { 
capture gen trust_myfamily`time'=.
}
capture gen trust_neighbors2015=HP105_13
capture gen trust_neighbors2013=GP104_15
capture gen trust_neighbors2011=fp98_14
foreach time in 2000 2003 2005 2007 2009 {
capture gen trust_neighbors`time'=.
}
capture gen trust_Euparliament2015=HP105_05
capture gen trust_Euparliament2013=GP104_05
capture gen trust_Euparliament2011=fp98_5
foreach time in 2000 2003 2005 2007 2009 {
capture gen trust_Euparliament`time'=.
}
capture gen trust_NBP2015=HP105_02
capture gen trust_NBP2013=GP104_02
capture gen trust_NBP2011=fp98_2
foreach time in 2000 2003 2005 2007 2009 {
capture gen trust_NBP`time'=.
}

capture gen party_preferences2015=HP101
capture gen party_preferences2013=GP98
capture gen party_preferences2011=fp106
foreach time in 2000 2003 2005 2007 2009 {
capture gen party_preferences`time'=.
}

capture gen problems_ask_for_help2015=HP47_1
capture gen problems_ask_for_help2013=GP47_1
capture gen problems_ask_for_help2011=fp48_1
foreach time in 2000 2003 2005 2007 2009 {
capture gen problems_ask_for_help`time'=.
}

capture gen problems_mobilize_and_act2015=HP47_2
capture gen problems_mobilize_and_act2013=GP47_2
capture gen problems_mobilize_and_act2011=fp48_2
foreach time in 2000 2003 2005 2007 2009 {
capture gen problems_mobilize_and_act`time'=.
}

capture gen problems_alcohol2015=HP47_3
capture gen problems_alcohol2013=GP47_3
capture gen problems_alcohol2011=fp48_3
foreach time in 2000 2003 2005 2007 2009 {
capture gen problems_alcohol`time'=.
}

capture gen problems_it_couldbeworse2015=HP47_4
capture gen problems_it_couldbeworse2013=GP47_4
capture gen problems_it_couldbeworse2011=fp48_4
foreach time in 2000 2003 2005 2007 2009 {
capture gen problems_comfort_couldbeworse`time'=.
}

capture gen problems_give_up2015=HP47_5
capture gen problems_give_up2013=GP47_5
capture gen problems_give_up2011=fp48_5
foreach time in 2000 2003 2005 2007 2009 {
capture gen problems_give_up`time'=.
}

capture gen problems_use_tranquilizers2015=HP47_6
capture gen problems_use_tranquilizers2013=GP47_6
capture gen problems_use_tranquilizers2011=fp48_6
foreach time in 2000 2003 2005 2007 2009 {
capture gen problems_use_tranquilizers`time'=.
}

capture gen problems_pray2015=HP47_7
capture gen problems_pray2013=GP47_7
capture gen problems_pray2011=fp48_7
foreach time in 2000 2003 2005 2007 2009 {
capture gen problems_pray`time'=.
}

capture gen problems_escape2015=HP47_8
capture gen problems_escape2013=GP47_8
capture gen problems_escape2011=fp48_8
foreach time in 2000 2003 2005 2007 2009 {
capture gen problems_escape`time'=.
}

capture gen voluntary_work2015=HP59
capture gen voluntary_work2013=GP56
capture gen voluntary_work2011=fp51
foreach time in 2000 2003 2005 2007 2009 {
capture gen voluntary_work`time'=.
}

capture gen membership_religious_org2015=HP51_11
capture gen membership_religious_org2013=GP51_12
foreach time in 2000 2003 2005 2007 2009 2011{
capture gen membership_religious_org`time'=.
}

capture gen membership_parents_asso2015=HP51_08
capture gen membership_parents_asso2013=GP51_08
foreach time in 2000 2003 2005 2007 2009 2011{
capture gen membership_parents_asso`time'=.
}
capture gen membership_sport_asso2015=HP51_01
capture gen membership_sport_asso2013=GP51_02
foreach time in 2000 2003 2005 2007 2009 2011{
capture gen membership_sport_asso`time'=.
}

foreach time in 2000 2003 2005 2007 2009 2011 2013 2015{
capture gen internet_access`time'=.
}

capture gen nb_family_meetregularly2015=HP68_1
capture gen nb_family_meetregularly2013=GP67_1
capture gen nb_family_meetregularly2011=fp68_1
capture gen nb_family_meetregularly2005=cp112_1
foreach time in 2000 2003 2007 2009 {
capture gen nb_family_meetregularly`time'=.
}
capture gen nb_friends_meetregularly2015=HP68_2
capture gen nb_friends_meetregularly2013=GP67_2
capture gen nb_friends_meetregularly2011=fp68_2
capture gen nb_friends_meetregularly2005=cp112_2
foreach time in 2000 2003 2007 2009 {
capture gen nb_friends_meetregularly`time'=.
}

capture gen nb_acquaint_meetregularly2015=HP68_3
capture gen nb_acquaint_meetregularly2013=GP67_3
capture gen nb_acquaint_meetregularly2011=fp68_3
capture gen nb_acquaint_meetregularly2005=cp112_3
foreach time in 2000 2003 2007 2009 {
capture gen nb_acquaint_meetregularly`time'=.
}
capture gen nb_regularcontacts_upto10km2013=GP68
capture gen nb_regularcontacts_upto10km2011=fp69
capture gen nb_regularcontacts_upto10km2005=cp113
foreach time in 2000 2003 2007 2009 2015 {
capture gen nb_regularcontacts_upto10km`time'=.
}
capture gen nb_regularcontacts_abroad2005=cp114
foreach time in 2000 2003 2007 2009 2011 2013 2015{
capture gen nb_regularcontacts_abroad`time'=.
}


***** Do you plan to go abroad within the next two years, in order to work? 1=yes, to European Union, 2: yes outside the EU, 3: no

capture gen intend_go_abroad_for_work2015=HP96A
capture gen intend_go_abroad_for_work2013=GP96A
capture gen intend_go_abroad_for_work2011=fp96
capture gen intend_go_abroad_for_work2009=ep95
capture gen intend_go_abroad_for_work2007=dp102

foreach time in 2000 2003 2005 {
capture gen intend_go_abroad_for_work`time'=.
}


foreach year in  2000 2003 2005 2007 2009 2011 2013 2015{
rename WAGA_`year'_OSOBY waga_osoby`year' 
rename WAGA_`year'_IND waga_ind`year' 
}

 
rename variabl0  poziom_wyksztalcenia_2009
rename variabl00 poziom_wyksztalcenia_2011
rename variabl01 poziom_wyksztalcenia_2013
rename variabl02 poziom_wyksztalcenia_2015


rename L_OSOB_* l_osob_*
foreach time in 2000 2003 2005 2007 2009 2011 2013 2015{
capture rename eduk4_`time' eduk4`time'
}


********party preferences in 2011, 2013 and 2015

gen PiS_closest2011=0
replace PiS_closest2011=1 if fp106==1
gen PiS_closest2013=0
replace PiS_closest2013=1 if GP98==1
gen PiS_closest2015=0
replace PiS_closest2015=1 if HP101==2
foreach time in 2000 2003 2007 2009 {
capture gen PiS_closest`time'=.
}

gen PSL_closest2011=0
replace PSL_closest2011=1 if fp106==2
gen PSL_closest2013=0
replace PSL_closest2013=1 if GP98==2
gen PSL_closest2015=0
replace PSL_closest2015=1 if HP101==3
foreach time in 2000 2003 2007 2009 {
capture gen PSL_closest`time'=.
}

gen SLD_closest2011=0
replace SLD_closest2011=1 if fp106==3
gen SLD_closest2013=0
replace SLD_closest2013=1 if GP98==3
gen SLD_closest2015=0
replace SLD_closest2015=1 if HP101==4
foreach time in 2000 2003 2007 2009 {
capture gen SLD_closest`time'=.
}

gen PO_closest2011=0
replace PO_closest2011=1 if fp106==5
gen PO_closest2013=0
replace PO_closest2013=1 if GP98==5
gen PO_closest2015=0
replace PO_closest2015=1 if HP101==1
foreach time in 2000 2003 2007 2009 {
capture gen PO_closest`time'=.
}

gen other_closest2011=0
replace other_closest2011 =1 if fp106==6|fp106==4
gen other_closest2013=0
replace other_closest2013 =1 if GP98==5|GP98==4|GP98==8
gen other_closest2015=0
replace other_closest2015 =1 if HP101==5|HP101==6|GP98==8
foreach time in 2000 2003 2007 2009 {
capture gen other_closest`time'=.
}

gen none_closest2011=0
replace none_closest2011=1 if fp106==7
gen none_closest2013=0
replace none_closest2013=1 if GP98==9
gen none_closest2015=0
replace none_closest2015=1 if HP101==7
foreach time in 2000 2003 2007 2009 {
capture gen none_closest`time'=.
}

gen difficult_to_say2011=0
replace difficult_to_say2011=1 if fp106==8
gen difficult_to_say2013=0
replace difficult_to_say2013=1 if GP98==10
gen difficult_to_say2015=0
replace difficult_to_say2015=1 if HP101==8
foreach time in 2000 2003 2007 2009 2011 2013{
capture gen difficult_to_say`time'=.
}

******************************************
****Variables describing financial assets: Do you have insurance? If yes, what kind of insurance: 
**1. group insurance policy in the workplace
**2. private life insurance
**3. third person liability insurance in private life
**4. motor insurance
**5. health insurance related to traveling abroad

gen have_insurance2015=HP107
foreach time in 2000 2003 2005 2007 2009 2011 2013{
capture gen have insurance`time'=.
}

gen have_ins_group2015=HP108_1
foreach time in 2000 2003 2005 2007 2009 2011 2013{
capture gen have ins_group`time'=.
}

gen have_ins_life2015=HP108_2
foreach time in 2000 2003 2005 2007 2009 2011 2013{
capture gen have ins_life`time'=.
}

gen have_ins_3rdpers2015=HP108_3
foreach time in 2000 2003 2005 2007 2009 2011 2013{
capture gen have ins_3rdpers`time'=.
}
gen have_ins_car2015=HP108_4
foreach time in 2000 2003 2005 2007 2009 2011 2013{
capture gen have ins_car`time'=.
}

gen have_ins_healthtravel2015=HP108_5
foreach time in 2000 2003 2005 2007 2009 2011 2013{
capture gen have ins_healthtravel`time'=.
}

foreach var in have_insurance2015 have_ins_group2015 have_ins_life2015 have_ins_3rdpers2015 have_ins_car2015 have_ins_healthtravel2015{
recode `var' 2=0
}

******* trust institutions

 foreach var in  trust_NBP2013 trust_Euparliament2013 trust_neighbors2013 trust_myfamily2013 trust_courts2013 trust_stockexchange2013 trust_banks2013 trust_ZUS2013 trust_sejm2013 trust_police2013 trust_president2013 trust_government2013   {
 recode `var' (1 2=1) (3=2) (4=3)
}

foreach var in  trust_NBP2015 trust_Euparliament2015 trust_neighbors2015  trust_courts2015 trust_stockexchange2015 trust_banks2015 trust_ZUS2015 trust_sejm2015 trust_police2015 trust_president2015 trust_government2015   {
 recode `var' (1 2=1) (3=2) (4=3)
}

foreach var in intend_go_abroad_for_work2007 intend_go_abroad_for_work2009 intend_go_abroad_for_work2011 intend_go_abroad_for_work2013 intend_go_abroad_for_work2015 {
 recode `var' (1 2=1) (3=0) (-8=.)
}


*trust_myfamily2015

****** generate type of household and the relation of the respondent to the HH-head and family head only for 2015*****

gen type_hh_8cat2015= Htyp_GD_8 
gen type_hh_10cat2015=Htyp_GD_10
gen type_hh_11cat2015=Htyp_GD_11

foreach time in 2000 2003 2005 2007 2009 2011 2013{
capture gen type_hh_8cat`time'=.
capture gen type_hh_10cat`time'=.
capture gen type_hh_11cat`time'=.
}

gen relation_hh_head2015=HC4
gen relation_family_head2015=HC6

foreach time in 2000 2003 2005 2007 2009 2011 2013{
capture gen relation_hh_head`time'=.
capture gen relation_family_head`time'=.
}

gen smoking2015=HP43
gen nb_cigarettes2015=HP44
gen ever_smoked2015=HP45


foreach time in 2000 2003 2005 2007 2009 2011 2013{
capture gen smoking`time'=.
capture gen nb_cigarettes`time'=.
capture gen ever_smoked`time'=.

}

********** smoking

keep F* smoking* nb_cigarettes* ever_smoked* have_insurance*  have_ins_group* have_ins_life* have_ins_3rdpers* have_ins_car* have_ins_healthtravel* relation_hh_head* relation_family_head* type_hh_8cat* type_hh_10cat* type_hh_11cat*  intend_go_abroad_for_work*  aspiration_educhildren* children_year_of_birth* children_education_achieved* father_education_level* material_goods_lifesuccess*  satisfaction_my_education* satisfaction_country_sit* satisfaction_finsituation*  satisfaction_safety* death_penalty_restored* civil_partnership_legalized* true_polish_patriot* smolensk_accident_attack* fear_criminality* membership_parents_ass* membership_religious_org* membership_sport_asso* voluntary_work* PiS_closest* PSL_closest* SLD_closest* PO_closest* other_closest* difficult_to_say* none_closest*  nb_family_meetregularly* nb_friends_meetregularly* nb_acquaint_meetregularly* nb_regularcontacts_upto10km* nb_regularcontacts_abroad* number_friends* party_preferences*  marital_status* occupation_isco_active* occupation_isco_passive* used_bribes* number norms_taxes* norms_transport*  norms_electricity* norms_unempbenefits* norms_rent* norms_tariffs* trust* trust_president* trust_sejm* trust_police* trust_government* going_tomess_everyweek* intend_emigrate* engaged_local* participated_meeting* materialsat* lastyear_successful* lifesatcurrent* lifesat* reform1989pos_yourlife* reform1989succeeded* lifebetterthan1989* trust_ZUS* trust_banks* trust_stockexchange* membership* prefer_democracy* voted* revenues_equal* norms_satisfaction* EUpos_yourlife* xenophobia* tolerance_homo* successful_life_money* successful_life_God* successful_life_freedom* successful_life_work* some_notdeserve_respect* stable_residence* waga_osoby* waga_ind* wiek*  wiek6_*  l_osob_*   lata_nauki_*   poziom_wyksztalcenia_*  eduk4* status9_*  trust_myfamily* trust_neighbors* trust_Euparliament* trust_NBP* trust_courts*  problems_ask_for_help* problems_mobilize_and_act* problems_alcohol* problems_it_couldbeworse* problems_give_up* problems_use_tranquilizers* problems_pray* problems_escape*  have_mobile*

reshape long  F smoking nb_cigarettes ever_smoked have_insurance have_ins_group have_ins_life have_ins_3rdpers have_ins_car have_ins_healthtravel relation_hh_head relation_family_head type_hh_8cat type_hh_10cat type_hh_11cat intend_go_abroad_for_work  aspiration_educhildren children_year_of_birth children_education_achieved father_education_level material_goods_lifesuccess satisfaction_my_education satisfaction_country_sit satisfaction_finsituation  satisfaction_safety death_penalty_restored civil_partnership_legalized true_polish_patriot smolensk_accident_attack  fear_criminality membership_parents_asso membership_religious_org membership_sport_asso voluntary_work PiS_closest   PSL_closest SLD_closest PO_closest other_closest difficult_to_say none_closest            nb_family_meetregularly nb_friends_meetregularly nb_acquaint_meetregularly nb_regularcontacts_upto10km nb_regularcontacts_abroad number_friends party_preferences          marital_status occupation_isco_active occupation_isco_passive used_bribes          norms_taxes norms_transport  norms_electricity norms_unempbenefits norms_rent norms_tariffs      trust trust_president trust_sejm trust_police trust_government       going_tomess_everyweek intend_emigrate engaged_local participated_meeting materialsat lastyear_successful lifesatcurrent lifesat reform1989pos_yourlife          reform1989succeeded  lifebetterthan1989 trust_ZUS trust_banks trust_stockexchange membership prefer_democracy voted revenues_equal norms_satisfaction EUpos_yourlife xenophobia tolerance_homo successful_life_money successful_life_God successful_life_freedom successful_life_work                    some_notdeserve_respect stable_residence waga_osoby waga_ind wiek  wiek6_ l_osob_           lata_nauki_   poziom_wyksztalcenia_  eduk4  status9_  trust_myfamily trust_neighbors trust_Euparliament trust_NBP  trust_courts problems_ask_for_help problems_mobilize_and_act problems_alcohol problems_it_couldbeworse problems_give_up problems_use_tranquilizers problems_pray problems_escape  have_mobile , i(number) j(year)

 
**** recode values (missings, dummies)
 
 foreach var in  aspiration_educhildren children_year_of_birth children_education_achieved father_education_level material_goods_lifesuccess  true_polish_patriot smolensk_accident_attack satisfaction_finsituation satisfaction_country_sit satisfaction_safety membership_religious_org voluntary_work PiS_closest PSL_closest SLD_closest PO_closest     other_closest difficult_to_say none_closest   nb_family_meetregularly nb_friends_meetregularly nb_acquaint_meetregularly nb_regularcontacts_upto10km nb_regularcontacts_abroad number_friends party_preferences          marital_status occupation_isco_active occupation_isco_passive used_bribes  norms_taxes norms_transport  norms_electricity norms_unempbenefits norms_rent norms_tariffs       trust trust_president trust_sejm trust_police trust_government       going_tomess_everyweek intend_emigrate engaged_local participated_meeting materialsat lastyear_successful lifesatcurrent lifesat reform1989pos_yourlife    reform1989succeeded   lifebetterthan1989 trust_ZUS trust_banks trust_stockexchange membership prefer_democracy voted revenues_equal norms_satisfaction EUpos_yourlife xenophobia tolerance_homo successful_life_money successful_life_God successful_life_freedom successful_life_work  some_notdeserve_respect stable_residence waga_osoby waga_ind wiek  wiek6_  l_osob_          lata_nauki_   poziom_wyksztalcenia_  eduk4  status9_  trust_myfamily trust_neighbors trust_Euparliament trust_NBP  trust_courts  have_mobile problems_ask_for_help problems_mobilize_and_act problems_alcohol problems_it_couldbeworse problems_give_up problems_use_tranquilizers problems_pray problems_escape{
 recode `var' -8=.
}


foreach var in satisfaction_my_education satisfaction_finsituation satisfaction_country_sit satisfaction_safety norms_satisfaction{
recode `var' 1 2 3=1 4 5 6=0 7=.
}

recode smoking 2=0
recode ever_smoked 2=0


 recode father_education_level  9=. 
 
 gen father_eduk4=.
 replace father_eduk4=1 if father_education_level<3
 replace father_eduk4=2 if father_education_level==3 |father_education_level==4 |father_education_level==5 
 replace father_eduk4=3 if father_education_level==6
 replace father_eduk4=4 if father_education_level==7 |father_education_level==8
 
 *** cap label vars
 
 cap label variable father_education_level "education level of your father when you were 14"
 cap label variable father_eduk4 " four education categories of your father when you were 14"

label define eduk4l 1 "primary or less" 2 "vocational and less than secondary" 3 "secondary" 4 "more than secondary" 
label values eduk4 eduk4l

label define father_eduk4l 1 "primary or less" 2 "vocational and less than secondary" 3 "secondary" 4 "more than secondary" 
label values father_eduk4 father_eduk4l


**** death penalty should be restored, civil partnership should be legalized true polish patriot should not speak badly about Poland or Poles
foreach var in  death_penalty_restored true_polish_patriot {
gen `var'_d=`var'
recode `var'_d 1 2 3=1 5 6 7=0 4=0
}
foreach var in   civil_partnership_legalized some_notdeserve_respect material_goods_lifesuccess{
gen `var'_d = `var'  
recode `var'_d 1 2 3=1 5 6 7=0 4=1
}

**** smolensk attack
recode smolensk_accident_attack 2=0

 *** cap label vars

cap label var civil_partnership_legalized  "civil partnership should be legalized in Poland"
cap label var satisfaction_safety "satisfied with safety in my place of living"
cap label var death_penalty_restored "death penalty should be restored in Poland"
cap label var true_polish_patriot "true polish patriot should not speak badly about Poland or Poles"
cap label var smolensk_accident_attack "the most likely reason of accident in Smolensk 2010" 
cap label var material_goods_lifesuccess "possession of various material goods is a good measure of successful life"

 *** rename vars

rename wiek age
rename wiek6_ age6
rename  l_osob_ nbperson_hh
rename lata_nauki_ edu_years
rename poziom_wyksztalcenia_ edu_level
rename status9_ empl_status
rename  waga_osoby weight_person
rename waga_ind weight_individ

 *** recode vars

recode membership_parents_asso 2=0
recode membership_religious_org 2=0
recode membership_sport_asso 2=0

replace membership_religious_org=0 if membership!=.&membership_religious_org==.
replace membership_parents_asso=0 if membership!=.&membership_parents_asso==.
replace membership_sport_asso=0 if membership!=.&membership_sport_asso==.

recode used_bribes 1 2 = 1 3=0
recode fear_criminality 2 3=0 -8=.

 foreach var in problems_ask_for_help problems_mobilize_and_act problems_alcohol problems_it_couldbeworse problems_give_up problems_use_tranquilizers problems_pray problems_escape {
 recode `var' (1=1) (2=0) (3=.)
}

****  foreigners have too much to say
recode  xenophobia (1 2 3=1) (4=1) (5 6 7 =0)

****   homosexual should be able to arrange their life as they wish
recode  tolerance_homo (1 2 3=1) (4=1) (5 6 7 =0)

recode EUpos_yourlife (3 4 =1)(1 2=0) (3=.)

foreach var in trust_banks trust_stockexchange trust_ZUS trust trust_courts trust_myfamily trust_neighbors trust_NBP trust_Euparliament trust_president trust_sejm trust_police trust_government {
recode `var' (1=1) (2=0) (3=.)
}
***some people do not deserve respect
recode some_notdeserve_respect (1 2 3= 1) (4 =0) (5 6 7 = 0)
***live in the same place as at the age of 14
recode stable_residence (1=1) (2 3=0)
recode voted 2=0 1=1 3=. -8=.

*whole life satisfaction
recode lifesat (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1) 
gen lifesat_d=lifesat
recode lifesat_d (5 6 7=1) (4=.) (1 2 3=0)

*material satisfaction
recode materialsat (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1)
gen materialsat_d=materialsat
recode materialsat_d (4=.) (5 6 7=1) (1 2 3=0)

*life satisfaction these days
recode lifesatcurrent (1=4) (2=3) (3=2) (4=1) 
gen lifesatcurrent_d= lifesatcurrent
recode lifesatcurrent_d (3 4=1) (1 2=0)

*now I live better than before 1989
recode lifebetterthan1989 (1=1) (2=0) (3=.)

*reforms after 1989 were generally successful
recode  reform1989succeeded (1=1) (2=0)  (3=.)

* changes since 1989 have affected your life 
recode reform1989pos_yourlife (3 4=1) (5=.) (1 2=0)

***social capital
* engagement in local community activities last two years
recode engaged_local (1=1) (2=0)
***did you do last work any work for free for the benefit of somebody not from family or for some social organization	
recode voluntary_work 1 2=1 3=0 if year==2015|year==2013
recode voluntary_work 2=0 if year==2011

****************************************************************************

recode membership (1 2 3=1) (4=0)

* participated in a public meeting last year (not at workplace)
recode participated_meeting 1=1 2=0 3=.

* organized a public meeting last year (not at workplace)
recode participated_meeting 1=1 2=0

*last year in your life was successful
recode lastyear_successful 1=1 2=0

****religious activity: how often per month do you participate in masses, or other religious meetings? 0=less than once a month, 4= every week n∞

recode going_tomess_everyweek   (0 1 2 3=0) (4/74=1)

*intent to emigrate because of work next two years
recode intend_emigrate (1 2=1) (3=0)

recode successful_life_work (1=1) (2=0) 
recode successful_life_freedom (1=1) (2=0) 
recode successful_life_God (1=1) (2=0) 
recode successful_life_money (1=1) (2=0) 

recode prefer_democracy (1 =1) (5 =.) (2 3 4=0) 

replace age=. if age<0
replace norms_tariffs=. if norms_tariffs==8
replace trust_banks=. if trust_banks==4
recode have_mobile (2=0) if year==2003| year==2007
recode have_mobile 1 2 3=1 if year==2009| year==2011
recode have_mobile 4=0 if year==2009| year==2011

***************recoding norms*****************
foreach var in norms_tariffs norms_rent norms_unempbenefits norms_electricity norms_transport norms_taxes{
replace `var'=. if `var' >4|`var'==-8
}

foreach var in norms_taxes norms_transport norms_electricity norms_unempbenefits norms_rent norms_tariffs {
gen `var'_d=`var'
replace `var'_d=. if (`var'>4)
recode  `var'_d (3 4= 1) (1 2=0) 
}


recode revenues_equal (1 2 3=1) (5 6 7=0)  (4=1)

gen secondary_edu=.
replace secondary_edu=1 if eduk4==3|eduk4==4
replace secondary_edu=0 if eduk4==1|eduk4==2
gen higher_edu=.
replace higher_edu=1 if eduk4==4
replace higher_edu=0 if eduk4<4


gen employee_status=.
replace employee_status=1 if empl_status==1 | empl_status==2
replace employee_status=0 if empl_status!=. & employee_status!=1

gen entrepreneur_status=.
replace entrepreneur_status=1 if empl_status==3
replace entrepreneur_status=0 if empl_status!=. & entrepreneur_status!=1

gen farmer_status=.
replace farmer_status=1 if empl_status==4
replace farmer_status=0 if empl_status!=. & farmer_status!=1

gen pensioner_status=.
replace pensioner_status=1 if empl_status==5 | empl_status==6
replace pensioner_status=0 if empl_status!=. & pensioner_status!=1

gen student_status=.
replace student_status=1 if empl_status==7
replace student_status=0 if empl_status!=. & student_status!=1

gen unemployed_status=.
replace unemployed_status=1 if empl_status==8
replace unemployed_status=0 if empl_status!=. &unemployed_status!=1 

gen not_working_status=.
replace not_working_status=1 if empl_status==9
replace not_working_status=0 if empl_status!=. & not_working_status!=1

cap label var employee_status "employment status of the respondent"
cap label var entrepreneur_status "employment status of the respondent"
cap label var farmer_status "employment status of the respondent"
cap label var pensioner_status "employment status of the respondent"
cap label var student_status "employment status of the respondent"
cap label var unemployed_status "employment status of the respondent"
cap label var not_working_status "employment status of the respondent"

cap label var smoking "do you smoke"
cap label var ever_smoked "have you ever smoked"
cap label var nb_cigarettes "how many cigarettes a day"

compress
sort number

}

******************************************xv
*** SAVING individual data in the long form

tempfile diagnoza_ind_long
save `diagnoza_ind_long', replace

****************************************************************************hh**************************************
**** Use individual survey: 


use ds_0_15_ind_14112015.dta, clear

quietly { 

sort numer150730
merge 1:1 numer150730 using powiaty_individual_data.dta

drop _merge

rename NUMER_GD hh
rename numer150730 number

gen powiaty_code=WOJEWODZTWO*100+POWIAT

rename WOJEWODZTWO woj 
rename KLASA_MIEJSCOWOSCI location_type 
rename PODREGION58 podregion58
rename PODREGION66 podregion66
 
gen female=PLEC_ALL
recode female 1=0 2=1
cap label variable female `"female "'

keep number hh number female powiaty_code location_type woj POWIAT podregion58 podregion66 WAGA_2013_OSOBY WAGA_2015_OSOBY waga_p1315_osoby WAGA_2013_IND WAGA_2015_IND waga_p1315_ind

gen rural=1 if location_type==6
replace rural=0 if location_type<6 & location_type!=.
gen big_towns=1 if location_type<4
replace big_towns=0 if location_type>3 & location_type!=.
gen small_towns=1 if location_type==4|location_type==5
replace small_towns=0 if small_towns==. & location_type!=.

sort number
compress

sort number

*************************************************
**** SAVINGindividual data in the form of x-section

tempfile diagnoza_ind_xsection_vars
save `diagnoza_ind_xsection_vars', replace

*************************************************
**** Use HH survey: 

use ds_0_15_GD_14112015, clear
rename numer_gd hh
merge 1:1 hh using powiaty_gminy_hh_data.dta
drop _merge


rename KLASA_MIEJSCOWOSCI location_type
replace location_type=. if location_type==-8
rename WOJEWODZTWO woj


capture gen anybody_from_kresy=HN1
recode anybody_from_kresy (1=1) (2=0)
label var anybody_from_kresy "Anybody from Kresy"
label define anybody_from_kresy 0 "No" 1 "Yes"
label values anybody_from_kresy anybody_from_kresy
*************************************************
***correcting a mistake in the data: HN1 for hh 4330 -- the place of origin was Lvov

replace anybody_from_kresy=1 if hh==43305

capture gen place1_kresy= HN2 
capture gen place2_kresy=HN2_b
label var place1_kresy "Place of origin in Kresy"
label var place2_kresy "Second Place of origin in Kresy"


keep hh  location_type woj gminy_code powiaty_code anybody_from_kresy place1_kresy place2_kresy f2000 f2003 f2005 f2007 f2009 f2011 f2013 f2015 WAGA_GD_2013_2015 WAGA_GD_2013 WAGA_GD_2015

******cities>500000=1, 200-500000=2, 100-200000=3, 20-100000=4, <20000=5, rural=6
gen rural=1 if location_type==6
replace rural=0 if location_type<6 & location_type!=.
gen big_towns=1 if location_type<4
replace big_towns=0 if location_type>3 & location_type!=.
gen small_towns=1 if location_type==4|location_type==5
replace small_towns=0 if small_towns==. & location_type!=.

compress
sort hh
}

********************************************************************
**** SAVING x-section at HH level

tempfile diagnoza_hh_xsection_vars
save `diagnoza_hh_xsection_vars', replace

******************************************xv
**** Dataset available from the website (Household survey):

use ds_0_15_GD_14112015.dta, clear

quietly { 

rename numer_gd hh
rename WOJEWODZTWO woj

***** recode and rename variables at HH level
foreach var in HL2 GL2 fL2 el2 dl2 cl3 bl3 ae3 {
recode `var' -8=.
}


foreach var in HL2 GL2 fL2 el2 dl2 cl3 bl3 ae3 {
recode `var' -8=.
}


foreach time in 2000 2003 2005 2007 2009 2011 2013{
capture gen nb_pers_hh`time'=.
capture gen nb_persmore15_hh`time'=.
capture gen child1_number`time'=.
capture gen child2_number`time'=.
capture gen child3_number`time'=.
capture gen child4_number`time'=.
capture gen child5_number`time'=.
capture gen child6_number`time'=.
capture gen child1_edu`time'=.
capture gen child2_edu`time'=.
capture gen child3_edu`time'=.
capture gen child4_edu`time'=.
capture gen child5_edu`time'=.
capture gen child6_edu`time'=.

}
 

gen nb_pers_hh2015=HA7
gen nb_persmore15_hh2015=HA8

gen child1_number2015=HH1_1
gen child2_number2015=HH1_2
gen child3_number2015=HH1_3
gen child4_number2015=HH1_4
gen child5_number2015=HH1_5
gen child6_number2015=HH1_6

/*
HH2_1 - HH2_6: What level of education would you like your children to attain?
(For each child choose one of the levels of education given below, by entering the appropriate number in the box in the line “level of education)”
level of education:
1. basic vocational school
2. profiled secondary school
3. technical or vocational secondary school
4. higher education (Bachelor’s degree)
5. higher education (Master’s degree)
*/

gen child1_edu2015=HH2_1
gen child2_edu2015=HH2_2
gen child3_edu2015=HH2_3
gen child4_edu2015=HH2_4
gen child5_edu2015=HH2_5
gen child6_edu2015=HH2_6

****** make variables consistent across waves (The same questions are numbered differently in different waves)

#delimit;
capture gen main_source_income2015=HA6_BEZ7; capture gen main_source_income2013=ga6_bez7; capture gen main_source_income2011=fA6_bez7; capture gen main_source_income2009=ea5; capture gen main_source_income2007=dgse; capture gen main_source_income2005=czug;capture gen main_source_income2003=bzug; capture gen main_source_income2000=azug;
capture gen hhincome2015=HL2; capture gen hhincome2013=GL2; capture gen hhincome2011=FL2; capture gen hhincome2009=el2; capture gen hhincome2007=dl2; capture gen hhincome2005=cl3; capture gen hhincome2003=bl3; capture gen hhincome2000=ae3;
capture gen own_wash_machine2015=HF19A_01;capture gen own_wash_machine2013=.;capture gen own_wash_machine2011=.;capture gen own_wash_machine2009=.;capture gen own_wash_machine2007=.;capture gen own_wash_machine2005=.;capture gen own_wash_machine2003=.;capture gen own_wash_machine2000=.;
capture gen no_washmachine_nofin2015= HF19B_01; capture gen no_washmachine_nofin2013=.; capture gen no_washmachine_nofin2011=.; capture gen no_washmachine_nofin2009=.; capture gen no_washmachine_nofin2007=.; capture gen no_washmachine_nofin2005=.; capture gen no_washmachine_nofin2003=.; capture gen no_washmachine_nofin2000=.;
capture gen own_dishwasher2015=HF19A_02; capture gen own_dishwasher2013=.; capture gen own_dishwasher2011=.;capture gen own_dishwasher2009=. ;capture gen own_dishwashe2007=.;capture gen own_dishwashe2005=.;capture gen own_dishwashe2003=.;capture gen own_dishwashe2000=.;
capture gen no_dishwasher_nofin2015=HF19B_02; capture gen no_dishwasher_nofin2013=.;capture gen no_dishwasher_nofin2011=.;capture gen no_dishwasher_nofin2009=.;capture gen no_dishwasher_nofin2007=.;capture gen no_dishwasher_nofin2005=.;capture gen no_dishwasher_nofin2003=.;capture gen no_dishwasher_nofin2000=.;
capture gen own_microwave2015=HF19A_03;capture gen own_microwave2013=.;capture gen own_microwave2011=.;capture gen own_microwave2009=.;capture gen own_microwave2007=.;capture gen own_microwave2005=.;capture gen own_microwave2003=.;capture gen own_microwave2000=.;
capture gen no_microwave_nofin2015=HF19B_03; capture gen no_microwave_nofin2013=.;capture gen no_microwave_nofin2011=.;capture gen no_microwave_nofin2009=.;capture gen no_microwave_nofin2007=.;capture gen no_microwave_nofin2005=.;capture gen no_microwave_nofin2003=.;capture gen no_microwave_nofin2000=.;
capture gen own_plasmaTV2015=HF19A_04;capture gen own_plasmaTV2013=.;capture gen own_plasmaTV2011=.;capture gen own_plasmaTV2009=.;capture gen own_plasmaTV2007=.;capture gen own_plasmaTV2005=.;capture gen own_plasmaTV2003=.;capture gen own_plasmaTV2000=.;
capture gen no_plasmaTV_nofin2015= HF19B_04; capture gen no_plasmaTV_nofin2013= .;capture gen no_plasmaTV_nofin2011= .;capture gen no_plasmaTV_nofin2009= .;capture gen no_plasmaTV_nofin2007= .;capture gen no_plasmaTV_nofin2005= .;capture gen no_plasmaTV_nofin2003= .;capture gen no_plasmaTV_nofin2000= .;
capture gen own_cable_satelliteTV2015=HF19A_05;capture gen own_cable_satelliteTV2013=.;capture gen own_cable_satelliteTV2011=.;capture gen own_cable_satelliteTV2009=.;capture gen own_cable_satelliteTV2007=.;capture gen own_cable_satelliteTV2005=.;capture gen own_cable_satelliteTV2003=.;capture gen own_cable_satelliteTV2000=.;
capture gen no_cableTV_nofin2015= HF19B_05; capture gen no_cableTV_nofin2013= .;capture gen no_cableTV_nofin2011= .;capture gen no_cableTV_nofin2009= .;capture gen no_cableTV_nofin2007= .;capture gen no_cableTV_nofin2005= .;capture gen no_cableTV_nofin2003= .;capture gen no_cableTV_nofin2000= .;
capture gen own_DVDplayer2015=HF19A_06;capture gen own_DVDplayer2013=.;capture gen own_DVDplayer2011=.;capture gen own_DVDplayer2009=.;capture gen own_DVDplayer2007=.;capture gen own_DVDplayer2005=.;capture gen own_DVDplayer2003=.;capture gen own_DVDplayer2000=.;
capture gen no_DVDplayer_nofin2015=HF19B_06; capture gen no_DVDplayer_nofin2013=.;capture gen no_DVDplayer_nofin2011=.;capture gen no_DVDplayer_nofin2009=.;capture gen no_DVDplayer_nofin2007=.;capture gen no_DVDplayer_nofin2005=.;capture gen no_DVDplayer_nofin2003=.;capture gen no_DVDplayer_nofin2000=.;
capture gen own_homecinema2015=HF19A_07;capture gen own_homecinema2013=.;capture gen own_homecinema2011=.;capture gen own_homecinema2009=.;capture gen own_homecinema2007=.;capture gen own_homecinema2005=.;capture gen own_homecinema2003=.;capture gen own_homecinema2000=.;
capture gen no_homecinema_nofin2015=HF19B_07; capture gen no_homecinema_nofin2013=.;capture gen no_homecinema_nofin2011=.;capture gen no_homecinema_nofin2009=.;capture gen no_homecinema_nofin2007=.;capture gen no_homecinema_nofin2005=.;capture gen no_homecinema_nofin2003=.;capture gen no_homecinema_nofin2000=.;
capture gen own_summer_house2015=HF19A_08;capture gen own_summer_house2013=.;capture gen own_summer_house2011=.;capture gen own_summer_house2009=.;capture gen own_summer_house2007=.;capture gen own_summer_house2005=.;capture gen own_summer_house2003=.;capture gen own_summer_house2000=.;
capture gen no_summer_house_nofin2015=HF19B_08;capture gen no_summer_house_nofin2013=.;capture gen no_summer_house_nofin2011=.;capture gen no_summer_house_nofin2009=.;capture gen no_summer_house_nofin2007=.;capture gen no_summer_house_nofin2005=.;capture gen no_summer_house_nofin2003=.;capture gen no_summer_house_nofin2000=.;
capture gen own_desktop_computer2015=HF19A_09;capture gen own_desktop_computer2013=.;capture gen own_desktop_computer2011=.;capture gen own_desktop_computer2009=.;capture gen own_desktop_computer2007=.;capture gen own_desktop_computer2005=.;capture gen own_desktop_computer2003=.;capture gen own_desktop_computer2000=.;
capture gen no_deskcomputer_nofin2015=HF19B_09;capture gen no_deskcomputer_nofin2013=.;capture gen no_deskcomputer_nofin2011=.;capture gen no_deskcomputer_nofin2009=.;capture gen no_deskcomputer_nofin2007=.;capture gen no_deskcomputer_nofin2005=.;capture gen no_deskcomputer_nofin2003=.;capture gen no_deskcomputer_nofin2000=.;
capture gen own_laptop_computer2015=HF19A_10;capture gen own_laptop_computer2013=.;capture gen own_laptop_computer2011=.;capture gen own_laptop_computer2009=.;capture gen own_laptop_computer2007=.;capture gen own_laptop_computer2005=.;capture gen own_laptop_computer2003=.;capture gen own_laptop_computer2000=.;
capture gen no_laptop_nofin2015=HF19B_10 ;capture gen no_laptop_nofin2013=. ;capture gen no_laptop_nofin2011=. ;capture gen no_laptop_nofin2009=. ;capture gen no_laptop_nofin2007=. ;capture gen no_laptop_nofin2005=. ;capture gen no_laptop_nofin2003=. ;capture gen no_laptop_nofin2000=. ;
capture gen own_tablet2015=HF19A_11;capture gen own_tablet2013=.;capture gen own_tablet2011=.;capture gen own_tablet2009=.;capture gen own_tablet2007=.;capture gen own_tablet2005=.;capture gen own_tablet2003=.;capture gen own_tablet2000=.;
capture gen no_tablet_nofin2015=HF19B_11;capture gen no_tablet_nofin2013=.;capture gen no_tablet_nofin2011=.;capture gen no_tablet_nofin2009=.;capture gen no_tablet_nofin2007=.;capture gen no_tablet_nofin2005=.;capture gen no_tablet_nofin2003=.;capture gen no_tablet_nofin2000=.;
capture gen own_car2015=HF19A_12;capture gen own_car2013=.;capture gen own_car2011=.;capture gen own_car2009=.;capture gen own_car2007=.;capture gen own_car2005=.;capture gen own_car2003=.;capture gen own_car2000=.;
capture gen no_car_nofin2015= HF19B_12;capture gen no_car_nofin2011= .;capture gen no_car_nofin2009= .;capture gen no_car_nofin2007= .;capture gen no_car_nofin2007= .;capture gen no_car_nofin2005= .;capture gen no_car_nofin2003= .;capture gen no_car_nofin2000= .;
capture gen own_ebook2015=HF19A_13;capture gen own_ebook2013=.;capture gen own_ebook2011=.;capture gen own_ebook2009=.;capture gen own_ebook2007=.;capture gen own_ebook2005=.;capture gen own_ebook2003=.;capture gen own_ebook2000=.;
capture gen no_ebook_nofin2015=HF19B_13;capture gen no_ebook_nofin2013=.;capture gen no_ebook_nofin2011=.;capture gen no_ebook_nofin2009=.;capture gen no_ebook_nofin2007=.;capture gen no_ebook_nofin2005=.;capture gen no_ebook_nofin2003=.;capture gen no_ebook_nofin2000=.;
capture gen own_internet_access2015=HF19A_14;capture gen own_internet_access2013=GF19_14;capture gen own_internet_access2011=.;capture gen own_internet_access2009=.;capture gen own_internet_access2007=.;capture gen own_internet_access2005=.;capture gen own_internet_access2003=.;capture gen own_internet_access2000=.;
capture gen no_internetacc_nofin2015=HF19B_14;capture gen no_internetacc_nofin2013=.;capture gen no_internetacc_nofin2011=.;capture gen no_internetacc_nofin2009=.;capture gen no_internetacc_nofin2007=.;capture gen no_internetacc_nofin2005=.;capture gen no_internetacc_nofin2003=.;capture gen no_internetacc_nofin2000=.;
capture gen own_landphone2015=HF19A_15;capture gen own_landphone2013=.;capture gen own_landphone2011=.;capture gen own_landphone2009=.;capture gen own_landphone2007=.;capture gen own_landphone2005=.;capture gen own_landphone2003=.;capture gen own_landphone2000=.;
capture gen no_landphone_nofin2015= HF19B_15;capture gen no_landphone_nofin2013= .;capture gen no_landphone_nofin2011= .;capture gen no_landphone_nofin2009= .;capture gen no_landphone_nofin2007= .;capture gen no_landphone_nofin2005= .;capture gen no_landphone_nofin2003= .;capture gen no_landphone_nofin2000= .;
capture gen own_boat2015=HF19A_16;capture gen own_boat2013=.;capture gen own_boat2011=.;capture gen own_boat2009=.;capture gen own_boat2007=.;capture gen own_boat2005=.;capture gen own_boat2003=.;capture gen own_boat2000=.;
capture gen no_boat_nofin2015=HF19B_16;capture gen no_boat_nofin2013=.;capture gen no_boat_nofin2011=.;capture gen no_boat_nofin2009=.;capture gen no_boat_nofin2007=.;capture gen no_boat_nofin2005=.;capture gen no_boat_nofin2003=.;capture gen no_boat_nofin2000=.;
capture gen own_garden_plot2015=HF19A_17;capture gen own_garden_plot2013=.;capture gen own_garden_plot2011=.;capture gen own_garden_plot2009=.;capture gen own_garden_plot2007=.;capture gen own_garden_plot2005=.;capture gen own_garden_plot2003=.;capture gen own_garden_plot2000=.;
capture gen no_garden_plot_nofin2015=HF19B_17;capture gen no_garden_plot_nofin2013=.;capture gen no_garden_plot_nofin2011=.;capture gen no_garden_plot_nofin2009=.;capture gen no_garden_plot_nofin2007=.;capture gen no_garden_plot_nofin2005=.;capture gen no_garden_plot_nofin2003=.;capture gen no_garden_plot_nofin2000=.;
capture gen own_flat2015=HF19A_18;capture gen own_flat2013=.;capture gen own_flat2011=.;capture gen own_flat2009=.;capture gen own_flat2007=.;capture gen own_flat2005=.;capture gen own_flat2003=.;capture gen own_flat2000=.;
capture gen no_flat_nofin2015= HF19B_18;capture gen no_flat_nofin2013= .;capture gen no_flat_nofin2011= .;capture gen no_flat_nofin2009= .;capture gen no_flat_nofin2007= .;capture gen no_flat_nofin2005= .;capture gen no_flat_nofin2003= .;capture gen no_flat_nofin2000= .;
capture gen own_house2015=HF19A_19;capture gen own_house2013=.;capture gen own_house2011=.;capture gen own_house2009=.;capture gen own_house2007=.;capture gen own_house2005=.;capture gen own_house2003=.;capture gen own_house2000=.;
capture gen no_house_nofin2015=HF19B_19;capture gen no_house_nofin2013=.;capture gen no_house_nofin2011=.;capture gen no_house_nofin2009=.;capture gen no_house_nofin2007=.;capture gen no_house_nofin2005=.;capture gen no_house_nofin2003=.;capture gen no_house_nofin2000=.;
capture gen own_other_property2015=HF19A_20;capture gen own_other_property2013=.;capture gen own_other_property2011=.;capture gen own_other_property2009=.;capture gen own_other_property2007=.;capture gen own_other_property2005=.;capture gen own_other_property2003=.;capture gen own_other_property2000=.;
capture gen no_other_property_nofin2015=HF19B_20;capture gen no_other_property_nofin2013=.;capture gen no_other_property_nofin2011=.;capture gen no_other_property_nofin2009=.;capture gen no_other_property_nofin2007=.;capture gen no_other_property_nofin2005=.;capture gen no_other_property_nofin2003=.;capture gen no_other_property_nofin2000=.;
capture gen hh_savings2015=HF6; capture gen hh_savings2013=.; capture gen hh_savings2011=.;capture gen hh_savings2009=.;capture gen hh_savings2007=.;capture gen hh_savings2005=.;capture gen hh_savings2003=.;capture gen hh_savings2000=.;
capture gen bank_deposit_PLN2015=HF6_01;capture gen bank_deposit_PLN2013=.;capture gen bank_deposit_PLN2011=.;capture gen bank_deposit_PLN2009=.;capture gen bank_deposit_PLN2007=.;capture gen bank_deposit_PLN2005=.;capture gen bank_deposit_PLN2003=.;capture gen bank_deposit_PLN2000=.;
capture gen bank_deposit_foreign2015=HF6_02;capture gen bank_deposit_foreign2013=.;capture gen bank_deposit_foreign2011=.; capture gen bank_deposit_foreign2009=.; capture gen bank_deposit_foreign2007=.; capture gen bank_deposit_foreign2005=.; capture gen bank_deposit_foreign2003=.; capture gen bank_deposit_foreign2000=.;
capture gen bonds2015=HF6_03;capture gen bonds2013=.;capture gen bonds2011=.;capture gen bonds2009=.;capture gen bonds2007=.;capture gen bonds2005=.;capture gen bonds2003=.;capture gen bonds2000=.;
capture gen invest_funds2015=HF6_04;capture gen invest_funds2013=.;capture gen invest_funds2011=.;capture gen invest_funds2009=.;capture gen invest_funds2007=.;capture gen invest_funds2005=.;capture gen invest_funds2003=.;capture gen invest_funds2000=.;
capture gen ind_pension_fund2015=HF6_05;capture gen ind_pension_fund2013=.;capture gen ind_pension_fund2011=.;capture gen ind_pension_fund2009=.;capture gen ind_pension_fund2007=.;capture gen ind_pension_fund2005=.;capture gen ind_pension_fund2003=.;capture gen ind_pension_fund2000=.;
capture gen employee_pension_fund2015=HF6_06;capture gen employee_pension_fund2013=.;capture gen employee_pension_fund2011=.;capture gen employee_pension_fund2009=.;capture gen employee_pension_fund2007=.;capture gen employee_pension_fund2005=.;capture gen employee_pension_fund2003=.;capture gen employee_pension_fund2000=.;
capture gen securities_SE2015=HF6_07;capture gen securities_SE2013=.;capture gen securities_SE2011=.;capture gen securities_SE2009=.;capture gen securities_SE2007=.;capture gen securities_SE2005=.;capture gen securities_SE2003=.;capture gen securities_SE2000=.;
capture gen securities_not_SE2015=HF6_08;capture gen securities_not_SE2013=.;capture gen securities_not_SE2011=.;capture gen securities_not_SE2009=.;capture gen securities_not_SE2007=.;capture gen securities_not_SE2005=.;capture gen securities_not_SE2003=.;capture gen securities_not_SE2000=.;
capture gen investment_property2015=HF6_09;capture gen investment_property2013=.;capture gen investment_property2011=.;capture gen investment_property2009=.;capture gen investment_property2007=.;capture gen investment_property2005=.;capture gen investment_property2003=.;capture gen investment_property2000=.;
capture gen investment_material_goods2015=HF6_10;capture gen investment_material_goods2013=.;capture gen investment_material_goods2011=.;capture gen investment_material_goods2009=.;capture gen investment_material_goods2007=.;capture gen investment_material_goods2005=.;capture gen investment_material_goods2003=.;capture gen investment_material_goods2000=.;
capture gen cash2015=HF6_11;capture gen cash2013=.;capture gen cash2011=.;capture gen cash2009=.;capture gen cash2007=.;capture gen cash2005=.;capture gen cash2003=.;capture gen cash2000=.;
capture gen insurance_policy2015=HF6_12;capture gen insurance_policy2013=.;capture gen insurance_policy2011=.;capture gen insurance_policy2009=.;capture gen insurance_policy2007=.;capture gen insurance_policy2005=.;capture gen insurance_policy2003=.;capture gen insurance_policy2000=.;
capture gen long_term_savings2015=HF6_13;capture gen long_term_savings2013=.;capture gen long_term_savings2011=.;capture gen long_term_savings2009=.;capture gen long_term_savings2007=.;capture gen long_term_savings2005=.;capture gen long_term_savings2003=.;capture gen long_term_savings2000=.;
capture gen savings_account2015=HF6_14;capture gen savings_account2013=.;capture gen savings_account2011=.;capture gen savings_account2009=.;capture gen savings_account2007=.;capture gen savings_account2005=.;capture gen savings_account2003=.;capture gen savings_account2000=.;
capture gen personal_current_account2015=HF6_15;capture gen personal_current_account2013=.;capture gen personal_current_account2011=.;capture gen personal_current_account2009=.;capture gen personal_current_account2007=.;capture gen personal_current_account2005=.;capture gen personal_current_account2003=.;capture gen personal_current_account2000=.;
capture gen other_savings2015=HF6_16;capture gen other_savings2013=.;capture gen other_savings2011=.;capture gen other_savings2009=.;capture gen other_savings2007=.;capture gen other_savings2005=.;capture gen other_savings2003=.;capture gen other_savings2000=.;
capture gen value_of_savings2015=HF7;capture gen value_of_savings2013=.;capture gen value_of_savings2011=.;capture gen value_of_savings2009=.;capture gen value_of_savings2007=.;capture gen value_of_savings2005=.;capture gen value_of_savings2003=.;capture gen value_of_savings2000=.;
capture gen purpose1_savings2015=HF8_01; capture gen purpose1_savings2013=.;capture gen purpose1_savings2011=.;capture gen purpose1_savings2009=.;capture gen purpose1_savings2007=.;capture gen purpose1_savings2005=.;capture gen purpose1_savings2003=.;capture gen purpose1_savings2000=.;
capture gen purpose2_savings2015=HF8_02; capture gen purpose2_savings2013=.;capture gen purpose2_savings2011=.;capture gen purpose2_savings2009=.;capture gen purpose2_savings2007=.;capture gen purpose2_savings2005=.;capture gen purpose2_savings2003=.;capture gen purpose2_savings2000=.;
capture gen purpose3_savings2015=HF8_03; capture gen purpose3_savings2013=.;capture gen purpose3_savings2011=.;capture gen purpose3_savings2009=.;capture gen purpose3_savings2007=.;capture gen purpose3_savings2005=.;capture gen purpose3_savings2003=.;capture gen purpose3_savings2000=.;
capture gen purpose4_savings2015=HF8_04; capture gen purpose4_savings2013=.;capture gen purpose4_savings2011=.;capture gen purpose4_savings2009=.;capture gen purpose4_savings2007=.;capture gen purpose4_savings2005=.;capture gen purpose4_savings2003=.;capture gen purpose4_savings2000=.;
capture gen purpose5_savings2015=HF8_05; capture gen purpose5_savings2013=.;capture gen purpose5_savings2011=.;capture gen purpose5_savings2009=.;capture gen purpose5_savings2007=.;capture gen purpose5_savings2005=.;capture gen purpose5_savings2003=.;capture gen purpose5_savings2000=.;
capture gen purpose6_savings2015=HF8_06; capture gen purpose6_savings2013=.;capture gen purpose6_savings2011=.;capture gen purpose6_savings2009=.;capture gen purpose6_savings2007=.;capture gen purpose6_savings2005=.;capture gen purpose6_savings2003=.;capture gen purpose6_savings2000=.;
capture gen purpose7_savings2015=HF8_07; capture gen purpose7_savings2013=.;capture gen purpose7_savings2011=.;capture gen purpose7_savings2009=.;capture gen purpose7_savings2007=.;capture gen purpose7_savings2005=.;capture gen purpose7_savings2003=.;capture gen purpose7_savings2000=.;
capture gen purpose8_savings2015=HF8_08; capture gen purpose8_savings2013=.;capture gen purpose8_savings2011=.;capture gen purpose8_savings2009=.;capture gen purpose8_savings2007=.;capture gen purpose8_savings2005=.;capture gen purpose8_savings2003=.;capture gen purpose8_savings2000=.;
capture gen purpose9_savings2015=HF8_09; capture gen purpose9_savings2013=.;capture gen purpose9_savings2011=.;capture gen purpose9_savings2009=.;capture gen purpose9_savings2007=.;capture gen purpose9_savings2005=.;capture gen purpose9_savings2003=.;capture gen purpose9_savings2000=.;
capture gen purpose10_savings2015=HF8_10;capture gen purpose10_savings2013=.;capture gen purpose10_savings2011=.;capture gen purpose10_savings2009=.;capture gen purpose10_savings2007=.;capture gen purpose10_savings2005=.;capture gen purpose10_savings2003=.;capture gen purpose10_savings2000=.;
capture gen purpose11_savings2015=HF8_11;capture gen purpose11_savings2013=.;capture gen purpose11_savings2011=.;capture gen purpose11_savings2009=.;capture gen purpose11_savings2007=.;capture gen purpose11_savings2005=.;capture gen purpose11_savings2003=.;capture gen purpose11_savings2000=.;
capture gen purpose12_savings2015=HF8_12;capture gen purpose12_savings2013=.;capture gen purpose12_savings2011=.;capture gen purpose12_savings2009=.;capture gen purpose12_savings2007=.;capture gen purpose12_savings2005=.;capture gen purpose12_savings2003=.;capture gen purpose12_savings2000=.;
capture gen purpose13_savings2015=HF8_13;capture gen purpose13_savings2013=.;capture gen purpose13_savings2011=.;capture gen purpose13_savings2009=.;capture gen purpose13_savings2007=.;capture gen purpose13_savings2005=.;capture gen purpose13_savings2003=.;capture gen purpose13_savings2000=.;
capture gen purpose14_savings2015=HF8_14;capture gen purpose14_savings2013=.;capture gen purpose14_savings2011=.;capture gen purpose14_savings2009=.;capture gen purpose14_savings2007=.;capture gen purpose14_savings2005=.;capture gen purpose14_savings2003=.;capture gen purpose14_savings2000=.;


keep hh woj purpose*_savings* value_of_savings* hh_savings* bank_deposit_PLN* bank_deposit_foreign* bonds* invest_funds* ind_pension_fund* employee_pension_fund* securities_SE* securities_not_SE* investment_property* investment_material_goods* cash* insurance_policy* long_term_savings* savings_account* personal_current_account* other_savings* bank_deposit_PLN* bank_deposit_foreign* bonds* invest_funds* ind_pension_fund* employee_pension_fund* nb_pers_hh* nb_persmore15_hh* child1_number* child2_number* child3_number* child4_number* child5_number* child6_number* child1_edu* child2_edu* child3_edu* child4_edu* child5_edu* child6_edu* hhincome* main_source_income* own_wash_machine* no_washmachine_nofin* own_dishwasher* no_dishwasher_nofin* own_microwave* no_microwave_nofin* own_plasmaTV* no_plasmaTV_nofin* own_cable_satelliteTV* no_cableTV_nofin* own_DVDplayer* no_DVDplayer_nofin* own_homecinema* no_homecinema_nofin* own_summer_house* no_summer_house_nofin* own_desktop_computer* no_deskcomputer_nofin* own_laptop_computer* no_laptop_nofin* own_tablet* no_tablet_nofin* own_car* no_car_nofin* own_ebook* no_ebook_nofin* own_internet_access* no_internetacc_nofin* own_landphone* no_landphone_nofin* own_boat* no_boat_nofin* own_garden_plot* no_garden_plot_nofin* own_flat* no_flat_nofin* own_house* no_house_nofin* own_other_property* no_other_property_nofin*;
 
reshape long purpose1_savings purpose2_savings purpose3_savings purpose4_savings purpose5_savings purpose6_savings purpose7_savings purpose8_savings purpose9_savings purpose10_savings purpose11_savings purpose12_savings purpose13_savings purpose14_savings value_of_savings hh_savings bank_deposit_PLN bank_deposit_foreign bonds invest_funds ind_pension_fund employee_pension_fund securities_SE securities_not_SE investment_property investment_material_goods cash insurance_policy long_term_savings savings_account personal_current_account other_savings nb_pers_hh nb_persmore15_hh child1_number child2_number child3_number child4_number child5_number child6_number child1_edu child2_edu child3_edu child4_edu child5_edu child6_edu  hhincome main_source_income own_wash_machine no_washmachine_nofin own_dishwasher no_dishwasher_nofin own_microwave no_microwave_nofin own_plasmaTV no_plasmaTV_nofin own_cable_satelliteTV no_cableTV_nofin own_DVDplayer no_DVDplayer_nofin own_homecinema no_homecinema_nofin own_summer_house no_summer_house_nofin own_desktop_computer no_deskcomputer_nofin own_laptop_computer no_laptop_nofin own_tablet no_tablet_nofin own_car no_car_nofin own_ebook no_ebook_nofin own_internet_access no_internetacc_nofin own_landphone no_landphone_nofin own_boat no_boat_nofin own_garden_plot no_garden_plot_nofin own_flat no_flat_nofin own_house no_house_nofin own_other_property no_other_property_nofin, i(hh) j(year);

#delimit cr

foreach var in purpose1_savings purpose2_savings purpose3_savings purpose4_savings purpose5_savings purpose6_savings purpose7_savings purpose8_savings purpose9_savings purpose10_savings purpose11_savings purpose12_savings purpose13_savings purpose14_savings hh_savings bank_deposit_PLN bank_deposit_foreign bonds invest_funds ind_pension_fund employee_pension_fund securities_SE securities_not_SE investment_property investment_material_goods cash insurance_policy long_term_savings savings_account personal_current_account other_savings{
recode `var' 2=0
}
foreach var in  main_source_income hhincome own_wash_machine no_washmachine_nofin own_dishwasher no_dishwasher_nofin own_microwave no_microwave_nofin own_plasmaTV no_plasmaTV_nofin own_cable_satelliteTV no_cableTV_nofin own_DVDplayer no_DVDplayer_nofin own_homecinema no_homecinema_nofin own_summer_house no_summer_house_nofin own_desktop_computer no_deskcomputer_nofin own_laptop_computer no_laptop_nofin own_tablet no_tablet_nofin own_car no_car_nofin own_ebook no_ebook_nofin own_internet_access no_internetacc_nofin own_landphone no_landphone_nofin own_boat no_boat_nofin own_garden_plot no_garden_plot_nofin own_flat no_flat_nofin own_house no_house_nofin own_other_property no_other_property_nofin {
 recode `var' -8=. 2=0
}

recode purpose1_savings 7=.


gen log_hhincome=log(hhincome)
 
 foreach var in  main_source_income  {
 recode `var' -8 =.
}


*** cap label vars

label define value_of_savingsl 1 "up to household's monthly income" 2 "from 1 to 3 monthly income" 3 "from 3 to 6 monthly income" 4 "from 6 to 12 monthly income" 5 "from 1 to 3 year income" 6 "more than 3 year income" 7 "missing (hard to say)"
label values value_of_savings value_of_savingsl


cap label var purpose1_savings "reserves for everyday consumer needs"
cap label var purpose2_savings "regular fees (e.g. home payments)"
cap label var purpose3_savings "purchase of consumer durables"
cap label var purpose4_savings "purchase of a house or an apartment"
cap label var purpose5_savings "renovation of the house or apartment"
cap label var purpose6_savings "medical treatment"
cap label var purpose7_savings "medical rehabilitation"
cap label var purpose8_savings "leisure"
cap label var purpose9_savings "reserves for unexpected events"
cap label var purpose10_savings "securing the children’s future"
cap label var purpose11_savings "security for the old age"
cap label var purpose12_savings "to develop one's own business"
cap label var purpose13_savings "other purposes"
cap label var purpose14_savings "no special purpose"



cap label var value_of_savings "approximate total amount of your household savings"     
cap label var hh_savings "does your hh have any of the following forms of savings"
cap label var bank_deposit_PLN "bank deposits in PLN"
cap label var bank_deposit_foreign "bank deposits in foreign currencies"
cap label var invest_funds "investment funds"
cap label var ind_pension_fund "individual pension fund/pension security"
cap label var employee_pension_fund "employee pension fund"
cap label var securities_SE "securities listed on the stock exchange"
cap label var securities_not_SE "shares and stocks in companies not listed on the stock exchange"
cap label var investment_property "investments in real estate"
cap label var investment_material_goods "investments in material goods other than real estate"
cap label var cash "cash"
cap label var insurance_policy "insurance policy"
cap label var long_term_savings "long-term savings programme"
cap label var savings_account "savings account"
cap label var personal_current_account "personal current account"
cap label var other_savings "otheer forms of savings"

cap label var own_summer_house "does your household possess summer house"
cap label var own_car "does your household possess a car"
cap label var own_boat "does your household possess a boat"
cap label var own_other_property "does your household possess another property"
cap label var own_flat "does your household possess a flat "
cap label var own_house "does your household possess a house "
cap label var own_wash_machine "does your household possess washing machine"

cap label var no_washmachine_nofin "no washing machine for financial reasons"
cap label var no_dishwasher_nofin "no dishwasher for financial reasons"
cap label var no_microwave_nofin  "no microwave for financial reasons"               
cap label var no_plasmaTV_nofin "no plasma TV for financial reasons"
cap label var no_cableTV_nofin "no cable TV for financial reasons"
cap label var no_DVDplayer_nofin "no DVD player for financial reasons"
cap label var no_homecinema_nofin  " no home cinema for financial reasons"
cap label var no_summer_house_nofin "no summer house for financial reasons"
cap label var no_deskcomputer_nofin "no desktop computer for financial reasons"
cap label var no_laptop_nofin "no laptop for financial reasons"
cap label var no_tablet_nofin "no tablet for financial reasons"
cap label var no_car_nofin "no car for financial reasons"
cap label var no_ebook_nofin "no ebook for financial reasons"
cap label var no_internetacc_nofin "no internat access for financial reasons"
cap label var no_landphone_nofin "no landline phone for financial reasons"
cap label var no_boat_nofin "no boat for financial reasons"
cap label var no_garden_plot_nofin "no garden plot for financial reasons"
cap label var no_flat_nofin "no flat for financial reasons"
cap label var no_house_nofin "no house for financial reasons"
cap label var no_other_property_nofin "no other property for financial reasons"

****recode in the following way: 1=employees + employees in agriculture, 2=farmers, 3=pensioners and disabled with pension, 4=entrepreneurs (and "free" professions), 5=not working, 6= having several main sources of income 

gen entrepreneur_hh_income=0
replace entrepreneur_hh_income=1 if (main_source_income==3)&(year==2015)|(main_source_income==3)&(year==2013)|(main_source_income==3)&(year==2011)|(main_source_income==3)&(year==2009)|(main_source_income==6)&(year==2007)|(main_source_income==4)&(year==2005)|(main_source_income==4)&(year==2003)|(main_source_income==4)&(year==2000)

gen employee_hh_income=0
replace employee_hh_income=1     if (main_source_income==1)&(year==2015)|(main_source_income==1)&(year==2013)|(main_source_income==1)&(year==2011)|(main_source_income==1)&(year==2009)|(main_source_income==1)&(year==2007)|(main_source_income==3)&(year==2007)|(main_source_income==1)&(year==2005)|(main_source_income==1)&(year==2003)|(main_source_income==2)&(year==2003)|(main_source_income==1)&(year==2000)

gen farmer_hh_income=0
replace farmer_hh_income=1       if (main_source_income==2)&(year==2015)|(main_source_income==2)&(year==2013)|(main_source_income==2)&(year==2011)|(main_source_income==2)&(year==2009)|(main_source_income==2)&(year==2007)|(main_source_income==2)&(year==2005)|(main_source_income==3)&(year==2005)|(main_source_income==3)&(year==2003)|(main_source_income==2)&(year==2000)|(main_source_income==3)&(year==2000)

gen pensioner_hh_income=0
replace pensioner_hh_income=1    if (main_source_income==4)&(year==2015)|(main_source_income==5)&(year==2015)|(main_source_income==4)&(year==2013)|(main_source_income==5)&(year==2013)|(main_source_income==4)&(year==2011)|(main_source_income==5)&(year==2011)|(main_source_income==4)&(year==2009)|(main_source_income==5)&(year==2009)|(main_source_income==4)&(year==2007)|(main_source_income==5)&(year==2007)|(main_source_income==5)&(year==2005)|(main_source_income==5)&(year==2003)|(main_source_income==6)&(year==2003)|(main_source_income==5)&(year==2000)

gen not_working_hh_income=0
replace not_working_hh_income=1  if (main_source_income==6)&(year==2015)|(main_source_income==6)&(year==2013)|(main_source_income==6)&(year==2011)|(main_source_income==6)&(year==2009)|(main_source_income==7)&(year==2007)|(main_source_income==6)&(year==2005)|(main_source_income==7)&(year==2003)|(main_source_income==6)&(year==2000)


cap label variable entrepreneur_hh_income "from main source of income"
cap label variable pensioner_hh_income "from main source of income"
cap label variable farmer_hh_income "from main source of income"
cap label variable employee_hh_income "from main source of income"
cap label variable not_working_hh_income "from main source of income"

}
********************************
** saving HH survey in the long form

sort hh year
compress
sort hh year
tempfile diagnoza_hh_long
save `diagnoza_hh_long', replace


****************************************************************************hh**************************************
****************************************************************************hh**************************************
**** MERGING DATA TOGETHER
****************************************************************************hh**************************************
****************************************************************************hh**************************************

clear
set mem 1g
use `diagnoza_ind_long'
merge number using `diagnoza_ind_xsection_vars', update 
tab _merge
drop _merge

sort hh year

merge hh year using `diagnoza_hh_long', update
tab _merge
drop if _merge==2
drop _merge

sort hh
merge hh using `diagnoza_hh_xsection_vars', update
drop if _merge==2
drop _merge

gen woj_center=0
replace woj_center=1 if powiaty_code==264|powiaty_code==461|powiaty_code==663|powiaty_code==861
replace woj_center=1 if powiaty_code==1061|powiaty_code==1261|powiaty_code==1465|powiaty_code==1661
replace woj_center=1 if powiaty_code==1863|powiaty_code==2061|powiaty_code==2261|powiaty_code==2469
replace woj_center=1 if powiaty_code==2661|powiaty_code==2862|powiaty_code==3064|powiaty_code==3262

***************************************************************************************************************

sort powiaty_code 


*******************************************************************************************************
*** label variables and recode a few remaining variables

cap label var number "unique ID of individual respondent"
cap label var weight_person "weight person in household"
cap label var weight_individ "weight individual"

cap label var age "age"
cap label var age6 "age, 6 categories"
cap label var nbperson_hh "size of the household"

cap label var edu_years "years of education"
replace edu_years=. if edu_years==99
drop edu_level
cap label var eduk4 "education level"

/* 1 - primary and less; 2 - professional or middle school; 3 - secondary education (high school); 4 - more than secondary */ 

cap label var F "dummy for being present in diagnoza wave"
cap label var empl_status "employment status"
/* 1 - public sector; 2 - private sector; 3- entrepreneur; 4-farmer; 5 - pensioner; 6 - disabled; 7 - study; 8-unemployed; 9 - out of labor force, other */

cap label var F_ZAWOD_AKTYWNI_SKR "occupation (shortened), working"
cap label var F_ZAWOD_BIERNI_SKR "occupation (shortened) in the last place of work, passive, not working"
cap label var F_ZAWOD_OGOLEM_SKR "occupation (shortened), all"
cap label var F_10GRUP_ZAWODOWYCH_AKTYWNI "10 groups, occupation, working"
cap label var F_10GRUP_ZAWODOWYCH_BIERNI "10 groups, occupation in the last place of work, not working"
cap label var F_10GRUP_ZAWODOWYCH_OGOLEM "10 groups, occupation, all"

cap label var F_ZAWOD_AKTYWNI "occupation ISCO 2011, working"
cap label var F_ZAWOD_BIERNI "occupation ISCO 2011 in the last place of work, passive, not working"
cap label var F_ZAWOD_OGOLEM "occupation ISCO 2011, all"
cap label var FK2 "was in the hospital last year"
recode FK2 2=0
cap label var satisfaction_country_sit "are you satisfied with country situation"
cap label var satisfaction_finsituation  "are you satisfied with your family financial situation"
cap label var smolensk_accident_attack "0-accident; 1=terrorist attack"
cap label var satisfaction_safety "are you satisfied with how secure is your place of living"
cap label var norms_taxes "concerned with cheating on taxes" 
cap label var norms_transport "concerned with cheating on public transport" 
cap label var norms_electricity "concerned with cheating on paying for electricity" 
cap label var norms_unempbenefits "concerned with cheating on getting unempl. benefits" 
cap label var norms_rent "concerned with cheating on paying rent" 
cap label var norms_tariffs "concerned with cheating on custom duties" 

cap label var norms_taxes_d "dummy concerned with cheating on taxes" 
cap label var norms_transport_d "dummy concerned with cheating on public transport" 
cap label var norms_electricity_d "dummy concerned with cheating on paying for electricity" 
cap label var norms_unempbenefits_d "dummy concerned with cheating on getting unempl. benefits" 
cap label var norms_rent_d "dummy concerned with cheating on paying rent" 
cap label var norms_tariffs_d "dummy concerned with cheating on custom duties" 

cap label var trust "generalized trust"
cap label var trust_president "trust president"
cap label var trust_sejm "trust parliament"
cap label var trust_police "trust police"
cap label var trust_government "trust government"

cap label var engaged_local "engaged in local community"
cap label var participated_meeting "particitated in meeting"
cap label var going_tomess_everyweek "going to mass everyweek"
rename going_tomess_everyweek going_tomass_everyweek

cap label var lastyear_successful "last year - successful"
cap label var lifesatcurrent "currect life satisfaction"
cap label var lifesat "overall life satisfaction"
cap label var reform1989succeeded "reforms after 1989 succedded" 
cap label var lifebetterthan1989 "life now better than in 1989"
cap label var trust_ZUS "trust state social insurance"
cap label var trust_banks "trust banks"
cap label var trust_stockexchange "trust stockexchange"

cap label var membership "member of associations" 
cap label var prefer_democracy "prefer democracy"
cap label var voted "voted in last elections"
cap label var revenues_equal "we should try to make revenues of all people equal"
cap label var xenophobia "strangers/foreigners have too much to say in this country"
cap label var tolerance_homo "homosexuals should be allowed to live their lives as they want" 

cap label var successful_life_money "main condition of successful life: money" 
cap label var successful_life_God "main condition of successful life: God" 
cap label var successful_life_freedom "main condition of successful life: freedom" 
cap label var successful_life_work "main condition of successful life: work" 

cap label var have_mobile "has cell phone"
cap label var used_bribes "did you have to use special ways to deal with administrative matters last months"   
cap label var number_friends "number of friends"
cap label var fear_criminality "fear of criminality"

cap label var some_notdeserve_respect "do you agree that some group of people do not deserve respect" 

cap label var occupation_isco_active "10 groups, occupation among working, ISCO"
replace occupation_isco_active=. if occupation_isco_active==911
cap label var occupation_isco_passive "10 groups, occupation among non-working, ISCO"

cap label var marital_status "marital status, 4 categories"
cap label var trust_courts "trust courts"
cap label var trust_myfamily "trust family members"
cap label var trust_Euparliament  "trust europarliament" 
cap label var trust_NBP "trust national bank of poland"
cap label var trust_neighbors "trust neighbors"

cap label var problems_ask_for_help "if problems: ask for help"
cap label var problems_mobilize_and_act "if problems: mobilize and act"
cap label var problems_alcohol "if problems: drink"
cap label var problems_it_couldbeworse "if problems: stay cool, could be worse"
cap label var problems_give_up "if problems: give up"
cap label var problems_use_tranquilizers "if problems: tranquilizers"
cap label var problems_pray "if problems: pray"
cap label var problems_escape "if problems: escape"
  
cap label var voluntary_work "voluntary work"
cap label var membership_religious_org  "membership religious organizations"
cap label var membership_parents_asso "membership parents associations"
cap label var membership_sport_asso "membership sports associations"

cap label var nb_family_meetregularly "number of family members you meet regularly"
cap label var nb_friends_meetregularly "number of friends you meet regularly"
cap label var nb_acquaint_meetregularly "number of acquaintances you meet regularly"
cap label var nb_regularcontacts_upto10km "number of people you meet regularly living less than10km from you" 
cap label var nb_regularcontacts_abroad "number of people living abroad you are in touch with " 

cap label var PiS_closest "party preference, religious center-right"
cap label var PSL_closest "party preference, peasants' party"
cap label var SLD_closest "party preference, left-wing (former socialist)"
cap label var PO_closest "party preference, pro-european, social liberals, center"
drop other_closest none_closest difficult_to_say none_closest

cap label var intend_emigrate "intend to immigrate"
cap label var materialsat "material satisfaction"
cap label var reform1989pos_yourlife "have changes since 1989 positively affected your life "  
cap label var norms_satisfaction "are you satisfied with moral norms in your environment "  
cap label var EUpos_yourlife "did Poland's EU accession positively affect your life"
cap label var stable_residence "is your place of living the same as whan you were 14 years old"

cap label var lifesat_d "life satisfaction dummy"
cap label var materialsat_d "material satisfaction dummy"
cap label var lifesatcurrent_d "current life satisfaction dummy"
cap label var secondary_edu "at least secondary education"
cap label var higher_edu "higher or more than high school education"

cap label var hh "unique hh ID"
cap label var name "powiat name in diagnoza"
cap label var rural "rural"
cap label var big_towns "big town more than 100000 inhabitants"
cap label var small_towns  "small town less than 100000 inhabitants"
cap label var main_source_income "employee, farmer, pensioner, entrepreneur, not working"

cap label var hhincome "HH income"
cap label var log_hhincome  "log HH income"
cap label var intend_go_abroad_for_work  "do you plan to go abroad to work, next two years"

cap label var gminy_code "gminy_code"

cap label var year "year"
cap label var aspiration_educhildren "aspiration for children's education"
cap label var have_insurance "has insurance" 
cap label var have_ins_group "has group insurance"
cap label var have_ins_life "has life insurance"
cap label var have_ins_3rdpers "has 3rd party insurance"
cap label var have_ins_car "has car insurance"
cap label var have_ins_healthtravel "has travel health insurance" 
cap label var material_goods_lifesuccess_d "material goods bring success"
cap label var powiaty_code "powiaty code"
cap label var nb_pers_hh "number of people in the HH"
cap label var nb_persmore15_hh "number of people above 15 years old in the HH"
cap label var own_dishwasher "own dishwasher"
cap label var own_microwave "own microwave"
cap label var own_plasmaTV "own plasma TV"
cap label var own_cable_satelliteTV "own satellite TV"
cap label var own_DVDplayer "own DVD player"
cap label var own_homecinema "own hiome cinema"
cap label var own_desktop_computer "own desktop computer"
cap label var own_laptop_computer "own laptop computer"
cap label var own_tablet "own tablet"
cap label var own_ebook "own ebook"
cap label var own_internet_access "own inerternet access"
cap label var own_landphone "own landphone"
cap label var own_garden_plot "own garden plot"
cap label var bonds "own bonds"
 
quietly { 
 
*** drop not used variables

sort powiaty_code
replace rural=0 if gminy_code==226301  /* this is a rural gmina */
gen age_sq=age*age
label var age_sq "Age squared" 
drop if year!=2015
drop if f2015!=1
compress

drop stable_residence number_friends     
drop lifesatcurrent satisfaction_finsituation lastyear_successful materialsat norms_satisfaction 
drop problems_ask_for_help problems_mobilize_and_act problems_alcohol problems_it_couldbeworse problems_give_up problems_use_tranquilizers 
drop problems_pray problems_escape    
drop PiS_closest PSL_closest SLD_closest PO_closest nb_cigarettes ever_smoked father_education_level father_eduk4 
drop death_penalty_restored_d true_polish_patriot_d civil_partnership_legalized_d some_notdeserve_respect_d 
drop lifesat_d  lifesatcurrent_d norms_taxes_d norms_transport_d norms_electricity_d  norms_unempbenefits_d norms_rent_d norms_tariffs_d 
drop child1_number child2_number child3_number child4_number child5_number child6_number 
drop child1_edu child2_edu child3_edu child4_edu child5_edu child6_edu 
drop nb_acquaint_meetregularly nb_regularcontacts_upto10km nb_regularcontacts_abroad
drop norms_taxes norms_transport norms_electricity norms_unempbenefits norms_rent norms_tariffs engaged_local participated_meeting membership 
drop voluntary_work membership_religious_org membership_parents_asso membership_sport_asso voted tolerance_homo xenophobia revenues_equal prefer_democracy 
drop true_polish_patriot smolensk_accident_attack trust trust_myfamily trust_neighbors  trust_president trust_sejm trust_police 
drop trust_courts trust_government trust_ZUS trust_Euparliament trust_NBP trust_banks trust_stockexchange reform1989succeeded lifebetterthan1989 
drop satisfaction_country_sit reform1989pos_yourlife EUpos_yourlife
drop F FK2
drop satisfaction_safety death_penalty_restored civil_partnership_legalized some_notdeserve_respect used_bribes fear_criminality
drop  weight_person weight_individ have_mobile nb_family_meetregularly nb_friends_meetregularly 
drop satisfaction_my_education children_year_of_birth children_education_achieved party_preferences 
drop type_hh_8cat type_hh_10cat type_hh_11cat relation_hh_head relation_family_head 
drop WAGA_2013_OSOBY WAGA_2015_OSOBY waga_p1315_osoby WAGA_2013_IND WAGA_2015_IND waga_p1315_ind
}

*******************************************************************************************************
*** merge with powiaty codes from 1931 that we manually found from the places of kresy ancestors

merge 1:1 number using unique_id_powiaty_code_1931_for_kresy_ancestors.dta
tab _merge
drop _merge

*******************************************************************************************************
*** drop unnecessary var 

drop podregion58 f2000 f2003 f2005 f2007 f2009 f2011 f2013 f2015 WAGA_GD_2013 WAGA_GD_2015 WAGA_GD_2013_2015 

*******************************************************************************************************
*** save the Diagnoza data set, which is the input for the analysis:

save "${path}/Data/original_data/diagnoza_2015.dta", replace
*******************************************************************************************************
