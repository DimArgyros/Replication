**************************************************************************************
clear all
set matsize 5000
set more off

**************************************************************************************
*********** 	Figure A.9					 *****************************
**************************************************************************************

**************************************************************************************
*****  1. Prepare CBOS data for powiaty flows
**************************************************************************************


use "${path}/Data/generated_data/ancestry_anclevel_replicate.dta", clear

set matsize 11000

keep if typ_proby==1

keep anc_in_wt  anc_in_kresy  anc_in_cp powiaty_code anc_pow_code1931_use

gen pow_code1931_use_wt=anc_pow_code1931_use

replace pow_code1931_use_wt="WT" if anc_in_wt==1

replace pow_code1931_use_wt = "Other" if pow_code1931_use_wt == ""


keep powiaty_code pow_code1931_use_wt
rename pow_code1931_use_wt pow_code1931_use

duplicates tag, generate(number)



replace number = number + 1

label var number "number of ancestors who came powiaty_1931 to powiaty_code" 

duplicates drop 

reshape wide number, i(powiaty_code) j(pow_code1931_use) string

local varnames "numberOther numberP0000 numberP0101 numberP0102 numberP0103 numberP0104 numberP0105 numberP0107 numberP0108 numberP0109 numberP0110 numberP0111 numberP0112 numberP0113 numberP0114 numberP0115 numberP0116 numberP0117 numberP0118 numberP0119 numberP0120 numberP0201 numberP0202 numberP0203 numberP0204 numberP0205 numberP0206 numberP0207 numberP0209 numberP0210 numberP0211 numberP0212 numberP0213 numberP0215 numberP0216 numberP0217 numberP0218 numberP0219 numberP0220 numberP0222 numberP0225 numberP0226 numberP0227 numberP0229 numberP0230 numberP0232 numberP0233 numberP0234 numberP0235 numberP0236 numberP0237 numberP0238 numberP0301 numberP0302 numberP0303 numberP0304 numberP0305 numberP0306 numberP0307 numberP0308 numberP0309 numberP0310 numberP0311 numberP0312 numberP0313 numberP0314 numberP0315 numberP0316 numberP0317 numberP0318 numberP0319 numberP0320 numberP0321 numberP0322 numberP0323 numberP0401 numberP0402 numberP0403 numberP0404 numberP0405 numberP0406 numberP0407 numberP0408 numberP0409 numberP0410 numberP0411 numberP0413 numberP0414 numberP0501 numberP0502 numberP0503 numberP0504 numberP0505 numberP0506 numberP0507 numberP0508 numberP0509 numberP0510 numberP0511 numberP0601 numberP0602 numberP0603 numberP0604 numberP0605 numberP0606 numberP0607 numberP0608 numberP0609 numberP0610 numberP0611 numberP0612 numberP0613 numberP0614 numberP0615 numberP0616 numberP0617 numberP0618 numberP0619 numberP0620 numberP0701 numberP0702 numberP0703 numberP0704 numberP0705 numberP0706 numberP0708 numberP0709 numberP0710 numberP0711 numberP0713 numberP0714 numberP0715 numberP0716 numberP0719 numberP0720 numberP0721 numberP0723 numberP0801 numberP0802 numberP0803 numberP0804 numberP0805 numberP0806 numberP0807 numberP0808 numberP0809 numberP0810 numberP0811 numberP0812 numberP0813 numberP0901 numberP0902 numberP0903 numberP0904 numberP0905 numberP0906 numberP0908 numberP0909 numberP0910 numberP0912 numberP0913 numberP0914 numberP0915 numberP0916 numberP0917 numberP0918 numberP0919 numberP0920 numberP1001 numberP1002 numberP1003 numberP1004 numberP1005 numberP1006 numberP1007 numberP1008 numberP1009 numberP1010 numberP1011 numberP1012 numberP1013 numberP1014 numberP1015 numberP1016 numberP1017 numberP1018 numberP1019 numberP1020 numberP1021 numberP1022 numberP1023 numberP1024 numberP1025 numberP1026 numberP1027 numberP1101 numberP1102 numberP1103 numberP1104 numberP1105 numberP1106 numberP1107 numberP1108 numberP1109 numberP1202 numberP1203 numberP1204 numberP1205 numberP1206 numberP1207 numberP1208 numberP1301 numberP1302 numberP1304 numberP1305 numberP1306 numberP1307 numberP1308 numberP1309 numberP1401 numberP1402 numberP1403 numberP1404 numberP1405 numberP1406 numberP1407 numberP1408 numberP1409 numberP1410 numberP1411 numberP1501 numberP1502 numberP1503 numberP1504 numberP1505 numberP1506 numberP1507 numberP1508 numberP1509 numberP1510 numberP1511 numberP1512 numberP1513 numberP1514 numberP1515 numberP1516 numberP1517 numberP1602 numberP1603 numberP1604 numberP1605 numberP1607 numberP1609 numberP1611 numberP1612 numberP1613 numberP1614 numberP1615 numberWT"



foreach var in `varnames' {
		label var `var' "number of ancestors who came powiaty_1931 to powiaty_code" 
		replace `var' = 0 if `var' == .
} 

gen all = 0 

**** generate row sum

foreach var in `varnames' {
	replace all = all + `var'
} 

label var all "all ancestors who came to this powiat"

foreach var in `varnames' {
	replace `var' = `var'/all 
}


foreach var in `varnames' {
	label var `var' "(ancestors from pow_1931)/(all ancestors in powiat)"
	local newvar  = substr("`var'", 7, .)
	rename `var' `newvar'

}



* --------------------------------------------------
***** data on flows from CBOS:

tempfile share_flows_pow
save "`share_flows_pow'", replace

* --------------------------------------------------



**************************************************************************************
*****  2. Prepare CBOS data for woj flows
**************************************************************************************




**** Use census data to get the names of woj

import excel "${path}/Data/original_data/pow_1931_center_in_1952_woj.xlsx", sheet("Sheet1") firstrow  clear

keep POW_CODE_1931 WOJ_1952

rename POW_CODE_1931 pow_code_1931 
rename WOJ_1952	     woj_name_1951

replace pow_code_1931 = subinstr(pow_code_1931," ","",.)
replace woj_name_1951 = subinstr(woj_name_1951," ","",.)

gen id = 1  

drop if pow_code_1931 == "" 

reshape wide woj_name_1951, i(id) j(pow_code_1931) string

local wojnames "woj_name_1951P0000 woj_name_1951P0101 woj_name_1951P0102 woj_name_1951P0103 woj_name_1951P0104 woj_name_1951P0105 woj_name_1951P0107 woj_name_1951P0108 woj_name_1951P0109 woj_name_1951P0110 woj_name_1951P0111 woj_name_1951P0112 woj_name_1951P0113 woj_name_1951P0114 woj_name_1951P0115 woj_name_1951P0116 woj_name_1951P0117 woj_name_1951P0118 woj_name_1951P0119 woj_name_1951P0120 woj_name_1951P0201 woj_name_1951P0202 woj_name_1951P0203 woj_name_1951P0204 woj_name_1951P0205 woj_name_1951P0206 woj_name_1951P0207 woj_name_1951P0209 woj_name_1951P0210 woj_name_1951P0211 woj_name_1951P0212 woj_name_1951P0213 woj_name_1951P0215 woj_name_1951P0216 woj_name_1951P0217 woj_name_1951P0218 woj_name_1951P0219 woj_name_1951P0220 woj_name_1951P0222 woj_name_1951P0225 woj_name_1951P0226 woj_name_1951P0227 woj_name_1951P0229 woj_name_1951P0230 woj_name_1951P0232 woj_name_1951P0233 woj_name_1951P0234 woj_name_1951P0235 woj_name_1951P0236 woj_name_1951P0237 woj_name_1951P0238 woj_name_1951P0301 woj_name_1951P0302 woj_name_1951P0303 woj_name_1951P0304 woj_name_1951P0305 woj_name_1951P0306 woj_name_1951P0307 woj_name_1951P0308 woj_name_1951P0309 woj_name_1951P0310 woj_name_1951P0311 woj_name_1951P0312 woj_name_1951P0313 woj_name_1951P0314 woj_name_1951P0315 woj_name_1951P0316 woj_name_1951P0317 woj_name_1951P0318 woj_name_1951P0319 woj_name_1951P0320 woj_name_1951P0321 woj_name_1951P0322 woj_name_1951P0323 woj_name_1951P0401 woj_name_1951P0402 woj_name_1951P0403 woj_name_1951P0404 woj_name_1951P0405 woj_name_1951P0406 woj_name_1951P0407 woj_name_1951P0408 woj_name_1951P0409 woj_name_1951P0410 woj_name_1951P0411 woj_name_1951P0413 woj_name_1951P0414 woj_name_1951P0501 woj_name_1951P0502 woj_name_1951P0503 woj_name_1951P0504 woj_name_1951P0505 woj_name_1951P0506 woj_name_1951P0507 woj_name_1951P0508 woj_name_1951P0509 woj_name_1951P0510 woj_name_1951P0511 woj_name_1951P0601 woj_name_1951P0602 woj_name_1951P0603 woj_name_1951P0604 woj_name_1951P0605 woj_name_1951P0606 woj_name_1951P0607 woj_name_1951P0608 woj_name_1951P0609 woj_name_1951P0610 woj_name_1951P0611 woj_name_1951P0612 woj_name_1951P0613 woj_name_1951P0614 woj_name_1951P0615 woj_name_1951P0616 woj_name_1951P0617 woj_name_1951P0618 woj_name_1951P0619 woj_name_1951P0620 woj_name_1951P0701 woj_name_1951P0702 woj_name_1951P0703 woj_name_1951P0704 woj_name_1951P0705 woj_name_1951P0706 woj_name_1951P0708 woj_name_1951P0709 woj_name_1951P0710 woj_name_1951P0711 woj_name_1951P0713 woj_name_1951P0714 woj_name_1951P0715 woj_name_1951P0716 woj_name_1951P0719 woj_name_1951P0720 woj_name_1951P0721 woj_name_1951P0723 woj_name_1951P0801 woj_name_1951P0802 woj_name_1951P0803 woj_name_1951P0804 woj_name_1951P0805 woj_name_1951P0806 woj_name_1951P0807 woj_name_1951P0808 woj_name_1951P0809 woj_name_1951P0810 woj_name_1951P0811 woj_name_1951P0812 woj_name_1951P0813 woj_name_1951P0901 woj_name_1951P0902 woj_name_1951P0903 woj_name_1951P0904 woj_name_1951P0905 woj_name_1951P0906 woj_name_1951P0907 woj_name_1951P0908 woj_name_1951P0909 woj_name_1951P0910 woj_name_1951P0912 woj_name_1951P0913 woj_name_1951P0914 woj_name_1951P0915 woj_name_1951P0916 woj_name_1951P0917 woj_name_1951P0918 woj_name_1951P0919 woj_name_1951P0920 woj_name_1951P1001 woj_name_1951P1002 woj_name_1951P1003 woj_name_1951P1004 woj_name_1951P1005 woj_name_1951P1006 woj_name_1951P1007 woj_name_1951P1008 woj_name_1951P1009 woj_name_1951P1010 woj_name_1951P1011 woj_name_1951P1012 woj_name_1951P1013 woj_name_1951P1014 woj_name_1951P1015 woj_name_1951P1016 woj_name_1951P1017 woj_name_1951P1018 woj_name_1951P1019 woj_name_1951P1020 woj_name_1951P1021 woj_name_1951P1022 woj_name_1951P1023 woj_name_1951P1024 woj_name_1951P1025 woj_name_1951P1026 woj_name_1951P1027 woj_name_1951P1101 woj_name_1951P1102 woj_name_1951P1103 woj_name_1951P1104 woj_name_1951P1105 woj_name_1951P1106 woj_name_1951P1107 woj_name_1951P1108 woj_name_1951P1109 woj_name_1951P1201 woj_name_1951P1202 woj_name_1951P1203 woj_name_1951P1204 woj_name_1951P1205 woj_name_1951P1206 woj_name_1951P1207 woj_name_1951P1208 woj_name_1951P1301 woj_name_1951P1302 woj_name_1951P1303 woj_name_1951P1304 woj_name_1951P1305 woj_name_1951P1306 woj_name_1951P1307 woj_name_1951P1308 woj_name_1951P1309 woj_name_1951P1401 woj_name_1951P1402 woj_name_1951P1403 woj_name_1951P1404 woj_name_1951P1405 woj_name_1951P1406 woj_name_1951P1407 woj_name_1951P1408 woj_name_1951P1409 woj_name_1951P1410 woj_name_1951P1411 woj_name_1951P1501 woj_name_1951P1502 woj_name_1951P1503 woj_name_1951P1504 woj_name_1951P1505 woj_name_1951P1506 woj_name_1951P1507 woj_name_1951P1508 woj_name_1951P1509 woj_name_1951P1510 woj_name_1951P1511 woj_name_1951P1512 woj_name_1951P1513 woj_name_1951P1514 woj_name_1951P1515 woj_name_1951P1516 woj_name_1951P1517 woj_name_1951P1602 woj_name_1951P1603 woj_name_1951P1604 woj_name_1951P1605 woj_name_1951P1606 woj_name_1951P1607 woj_name_1951P1609 woj_name_1951P1611 woj_name_1951P1612 woj_name_1951P1613 woj_name_1951P1614 woj_name_1951P1615"

foreach var in `wojnames' {
	local newvar  = substr("`var'", 14, .)
	rename `var' `newvar'
}

drop id 

gen Other = "Other"

gen WT = "WT"

* --------------------------------------------------

tempfile pow1931_woj1952
save "`pow1931_woj1952.dta'", replace

* --------------------------------------------------

use "`share_flows_pow'", clear 

gen autochtons_t = 0

gen from_Warsaw_t = 0
gen from_woj_warszawskie_t = 0
gen from_woj_bydgoskie_t = 0
gen from_woj_poznanskie_old_t = 0
gen from_woj_poznanskie_wt_t = 0 //*
gen from_Lodz_t = 0
gen from_woj_lodzkie_t = 0
gen from_woj_kieleckie_t = 0
gen from_woj_lubelskie_t = 0
gen from_woj_bialostockie_old_t = 0
gen from_woj_bialostockie_wt_t = 0
gen from_woj_olsztynskie_old_t = 0
gen from_woj_olsztynskie_wt_t = 0
gen from_woj_gdanskie_old_t = 0
gen from_woj_gdanskie_wt_t = 0
gen from_woj_koszalinskie_t = 0
gen from_woj_szczecinskie_t = 0
gen from_woj_zielonogorskie_t = 0
gen from_woj_wroclawskie_t = 0
gen from_woj_opolskie_t = 0
gen from_woj_katowickie_old_t = 0
gen from_woj_katowickie_wt_t  = 0
gen from_woj_krakowskie_t = 0
gen from_woj_rzeszowskie_t = 0
gen from_USRR_t = 0


tempfile share_flows_woj
save "`share_flows_woj.dta'", replace

**** sum up flows from powiaty to woj

local powiaty "Other P0000 P0101 P0102 P0103 P0104 P0105 P0107 P0108 P0109 P0110 P0111 P0112 P0113 P0114 P0115 P0116 P0117 P0118 P0119 P0120 P0201 P0202 P0203 P0204 P0205 P0206 P0207 P0209 P0210 P0211 P0212 P0213 P0215 P0216 P0217 P0218 P0219 P0220 P0222 P0225 P0226 P0227 P0229 P0230 P0232 P0233 P0234 P0235 P0236 P0237 P0238 P0301 P0302 P0303 P0304 P0305 P0306 P0307 P0308 P0309 P0310 P0311 P0312 P0313 P0314 P0315 P0316 P0317 P0318 P0319 P0320 P0321 P0322 P0323 P0401 P0402 P0403 P0404 P0405 P0406 P0407 P0408 P0409 P0410 P0411 P0413 P0414 P0501 P0502 P0503 P0504 P0505 P0506 P0507 P0508 P0509 P0510 P0511 P0601 P0602 P0603 P0604 P0605 P0606 P0607 P0608 P0609 P0610 P0611 P0612 P0613 P0614 P0615 P0616 P0617 P0618 P0619 P0620 P0701 P0702 P0703 P0704 P0705 P0706 P0708 P0709 P0710 P0711 P0713 P0714 P0715 P0716 P0719 P0720 P0721 P0723 P0801 P0802 P0803 P0804 P0805 P0806 P0807 P0808 P0809 P0810 P0811 P0812 P0813 P0901 P0902 P0903 P0904 P0905 P0906 P0908 P0909 P0910 P0912 P0913 P0914 P0915 P0916 P0917 P0918 P0919 P0920 P1001 P1002 P1003 P1004 P1005 P1006 P1007 P1008 P1009 P1010 P1011 P1012 P1013 P1014 P1015 P1016 P1017 P1018 P1019 P1020 P1021 P1022 P1023 P1024 P1025 P1026 P1027 P1101 P1102 P1103 P1104 P1105 P1106 P1107 P1108 P1109 P1202 P1203 P1204 P1205 P1206 P1207 P1208 P1301 P1302 P1304 P1305 P1306 P1307 P1308 P1309 P1401 P1402 P1403 P1404 P1405 P1406 P1407 P1408 P1409 P1410 P1411 P1501 P1502 P1503 P1504 P1505 P1506 P1507 P1508 P1509 P1510 P1511 P1512 P1513 P1514 P1515 P1516 P1517 P1602 P1603 P1604 P1605 P1607 P1609 P1611 P1612 P1613 P1614 P1615 WT"



foreach pow in `powiaty' {
		
	* Autochtons 
	use "`pow1931_woj1952.dta'", clear
	display "`pow'"
	
	if "`pow'" == "WT" {
		display `pow'
		use "`share_flows_woj.dta'", clear 
		replace autochtons_t = autochtons_t + `pow'
		save "`share_flows_woj.dta'", replace
	}
	
	* From_Warsaw_t
	use "`pow1931_woj1952.dta'", clear
	if `pow' == "Miasto_Stoleczne_Warszawa" {
		display `pow'
		use "`share_flows_woj.dta'", clear 
		replace from_Warsaw_t = from_Warsaw_t + `pow'
		save "`share_flows_woj.dta'", replace
	}
	
	* from_woj_warszawskie_t
	use "`pow1931_woj1952.dta'", clear
	if `pow' == "warszawskie" {
		display `pow'
		use "`share_flows_woj.dta'", clear 
		replace from_woj_warszawskie_t = from_woj_warszawskie_t + `pow'
		save "`share_flows_woj.dta'", replace
	}
	
	* from_woj_bydgoskie_t
	use "`pow1931_woj1952.dta'", clear
	if `pow' == "bydgoskie" {
		display `pow'
		use "`share_flows_woj.dta'", clear 
		replace from_woj_bydgoskie_t = from_woj_bydgoskie_t + `pow'
		save "`share_flows_woj.dta'", replace
	}
	
	* from_woj_poznanskie_old_t 
	use "`pow1931_woj1952.dta'", clear
	if `pow' == "poznanskie" {
		display `pow'
		use "`share_flows_woj.dta'", clear 
		replace from_woj_poznanskie_old_t = from_woj_poznanskie_old_t + `pow'
		save "`share_flows_woj.dta'", replace
	}
	
	* from_Lodz_t 
	use "`pow1931_woj1952.dta'", clear
	if `pow' == "Miasto_Lodz" {
		display `pow'
		use "`share_flows_woj.dta'", clear 
		replace from_Lodz_t = from_Lodz_t + `pow'
		save "`share_flows_woj.dta'", replace
	}
	
	* from_woj_lodzkie_t 
	use "`pow1931_woj1952.dta'", clear
	if `pow' == "lodzkie" {
		display `pow'
		use "`share_flows_woj.dta'", clear 
		replace from_woj_lodzkie_t = from_woj_lodzkie_t + `pow'
		save "`share_flows_woj.dta'", replace
	}
	
	* from_woj_kieleckie_t 
	use "`pow1931_woj1952.dta'", clear
	if `pow' == "kieleckie" {
		display `pow'
		use "`share_flows_woj.dta'", clear  
		replace from_woj_kieleckie_t = from_woj_kieleckie_t + `pow'
		save "`share_flows_woj.dta'", replace
	}
	
	* from_woj_lubelskie_t 
	use "`pow1931_woj1952.dta'", clear
	if `pow' == "lubelskie" {
		display `pow'
		use "`share_flows_woj.dta'", clear 
		replace from_woj_lubelskie_t = from_woj_lubelskie_t + `pow'
		save "`share_flows_woj.dta'", replace
	}
	
	* from_woj_bialostockie_old_t 
	use "`pow1931_woj1952.dta'", clear
	if `pow' == "bialostockie" {
		display `pow'
		use "`share_flows_woj.dta'", clear  
		replace from_woj_bialostockie_old_t = from_woj_bialostockie_old_t + `pow'
		save "`share_flows_woj.dta'", replace
	}
	
	* from_woj_olsztynskie_old_t 
	use "`pow1931_woj1952.dta'", clear
	if `pow' == "olsztynskie" {
		display `pow'
		use "`share_flows_woj.dta'", clear 
		replace from_woj_olsztynskie_old_t = from_woj_olsztynskie_old_t + `pow'
		save "`share_flows_woj.dta'", replace
	}
	
	* from_woj_gdanskie_old_t 
	use "`pow1931_woj1952.dta'", clear
	if `pow' == "gdanskie" {
		display `pow'
		use "`share_flows_woj.dta'", clear 
		replace from_woj_gdanskie_old_t = from_woj_gdanskie_old_t + `pow'
		save "`share_flows_woj.dta'", replace
	}
	
	* from_woj_krakowskie_t 
	use "`pow1931_woj1952.dta'", clear
	if `pow' == "krakowskie" {
		display `pow'
		use "`share_flows_woj.dta'", clear  
		replace from_woj_krakowskie_t = from_woj_krakowskie_t + `pow'
		save "`share_flows_woj.dta'", replace
	}
	
	* from_woj_katowickie_old_t 
	use "`pow1931_woj1952.dta'", clear
	if `pow' == "stalinogrodzkie" {
		display `pow'
		use "`share_flows_woj.dta'", clear  
		replace from_woj_katowickie_old_t = from_woj_katowickie_old_t + `pow'
		save "`share_flows_woj.dta'", replace
	}

	* from_woj_rzeszowskie_t 
	use "`pow1931_woj1952.dta'", clear
	if `pow' == "rzeszowskie" {
		display `pow'
		use "`share_flows_woj.dta'", clear  
		replace from_woj_rzeszowskie_t = from_woj_rzeszowskie_t + `pow'
		save "`share_flows_woj.dta'", replace
	}
	
	* Kresy from_USRR_t
	use "`pow1931_woj1952.dta'", clear
	if (`pow' == "" ) | (`pow' == "Other"){
		display `pow'
		use "`share_flows_woj.dta'", clear 
		replace from_USRR_t = from_USRR_t + `pow'
		save "`share_flows_woj.dta'", replace
	}
}


	use "`share_flows_woj.dta'", clear
	
drop from_woj_koszalinskie_t from_woj_szczecinskie_t from_woj_zielonogorskie_t from_woj_wroclawskie_t from_woj_opolskie_t from_woj_bialostockie_wt_t from_woj_poznanskie_wt_t from_woj_olsztynskie_wt_t from_woj_gdanskie_wt_t from_woj_katowickie_wt_t all Other P0000 P0101 P0102 P0103 P0104 P0105 P0107 P0108 P0109 P0110 P0111 P0112 P0113 P0114 P0115 P0116 P0117 P0118 P0119 P0120 P0201 P0202 P0203 P0204 P0205 P0206 P0207 P0209 P0210 P0211 P0212 P0213 P0215 P0216 P0217 P0218 P0219 P0220 P0222 P0225 P0226 P0227 P0229 P0230 P0232 P0233 P0234 P0235 P0236 P0237 P0238 P0301 P0302 P0303 P0304 P0305 P0306 P0307 P0308 P0309 P0310 P0311 P0312 P0313 P0314 P0315 P0316 P0317 P0318 P0319 P0320 P0321 P0322 P0323 P0401 P0402 P0403 P0404 P0405 P0406 P0407 P0408 P0409 P0410 P0411 P0413 P0414 P0501 P0502 P0503 P0504 P0505 P0506 P0507 P0508 P0509 P0510 P0511 P0601 P0602 P0603 P0604 P0605 P0606 P0607 P0608 P0609 P0610 P0611 P0612 P0613 P0614 P0615 P0616 P0617 P0618 P0619 P0620 P0701 P0702 P0703 P0704 P0705 P0706 P0708 P0709 P0710 P0711 P0713 P0714 P0715 P0716 P0719 P0720 P0721 P0723 P0801 P0802 P0803 P0804 P0805 P0806 P0807 P0808 P0809 P0810 P0811 P0812 P0813 P0901 P0902 P0903 P0904 P0905 P0906 P0908 P0909 P0910 P0912 P0913 P0914 P0915 P0916 P0917 P0918 P0919 P0920 P1001 P1002 P1003 P1004 P1005 P1006 P1007 P1008 P1009 P1010 P1011 P1012 P1013 P1014 P1015 P1016 P1017 P1018 P1019 P1020 P1021 P1022 P1023 P1024 P1025 P1026 P1027 P1101 P1102 P1103 P1104 P1105 P1106 P1107 P1108 P1109 P1202 P1203 P1204 P1205 P1206 P1207 P1208 P1301 P1302 P1304 P1305 P1306 P1307 P1308 P1309 P1401 P1402 P1403 P1404 P1405 P1406 P1407 P1408 P1409 P1410 P1411 P1501 P1502 P1503 P1504 P1505 P1506 P1507 P1508 P1509 P1510 P1511 P1512 P1513 P1514 P1515 P1516 P1517 P1602 P1603 P1604 P1605 P1607 P1609 P1611 P1612 P1613 P1614 P1615 WT


rename autochtons_t var1
rename from_Warsaw_t var2 
rename from_woj_warszawskie_t var3
rename from_woj_bydgoskie_t var4
rename from_woj_poznanskie_old_t var5
rename from_Lodz_t var6
rename from_woj_lodzkie_t var7
rename from_woj_kieleckie_t var8
rename from_woj_lubelskie_t var9
rename from_woj_bialostockie_old_t var10
rename from_woj_olsztynskie_old_t var11
rename from_woj_gdanskie_old_t var12
rename from_woj_katowickie_old_t var13
rename from_woj_krakowskie_t var14
rename from_woj_rzeszowskie_t var15
rename from_USRR_t var16

reshape long var, i(powiaty_code) j(id) 

rename var share_our

label var share_our "(anc in this pow from woj_1950 X)/(all anc in this pow)"


* --------------------------------------------------

save "`share_flows_woj.dta'", replace

* --------------------------------------------------


**************************************************************************************
*****  3. Get census data
**************************************************************************************

		
use "${path}/Data/original_data/powiaty_history_geography.dta", clear

keep powiaty_code population_powiat_1950_t autochtons_t incoming_population_total_t from_Warsaw_t from_woj_warszawskie_t from_woj_bydgoskie_t from_woj_poznanskie_old_t from_woj_poznanskie_wt_t from_Lodz_t from_woj_lodzkie_t from_woj_kieleckie_t from_woj_lubelskie_t from_woj_bialostockie_old_t from_woj_bialostockie_wt_t from_woj_olsztynskie_old_t from_woj_olsztynskie_wt_t from_woj_gdanskie_old_t from_woj_gdanskie_wt_t from_woj_koszalinskie_t from_woj_szczecinskie_t from_woj_zielonogorskie_t from_woj_wroclawskie_t from_woj_opolskie_t from_woj_katowickie_old_t from_woj_katowickie_wt_t from_woj_krakowskie_t from_woj_rzeszowskie_t from_USRR_t from_other_countries_t unknown_origin_t

drop if population_powiat_1950_t == .

replace autochtons_t = autochtons_t + from_woj_koszalinskie_t + from_woj_szczecinskie_t + from_woj_zielonogorskie_t + from_woj_wroclawskie_t + from_woj_opolskie_t + from_woj_bialostockie_wt_t + from_woj_poznanskie_wt_t + from_woj_olsztynskie_wt_t + from_woj_gdanskie_wt_t + from_woj_katowickie_wt_t

drop from_other_countries_t unknown_origin_t from_woj_koszalinskie_t from_woj_szczecinskie_t from_woj_zielonogorskie_t from_woj_wroclawskie_t from_woj_opolskie_t from_woj_bialostockie_wt_t from_woj_poznanskie_wt_t from_woj_olsztynskie_wt_t from_woj_gdanskie_wt_t from_woj_katowickie_wt_t

local varnames2 "autochtons_t incoming_population_total_t from_Warsaw_t from_woj_warszawskie_t from_woj_bydgoskie_t from_woj_poznanskie_old_t from_Lodz_t from_woj_lodzkie_t from_woj_kieleckie_t from_woj_lubelskie_t from_woj_bialostockie_old_t from_woj_olsztynskie_old_t from_woj_gdanskie_old_t from_woj_katowickie_old_t from_woj_krakowskie_t from_woj_rzeszowskie_t from_USRR_t"


foreach var in `varnames2' {
	replace `var' = `var'/population_powiat_1950_t
}

drop population_powiat_1950_t incoming_population_total_t

rename autochtons_t var1
rename from_Warsaw_t var2 
rename from_woj_warszawskie_t var3
rename from_woj_bydgoskie_t var4
rename from_woj_poznanskie_old_t var5
rename from_Lodz_t var6
rename from_woj_lodzkie_t var7
rename from_woj_kieleckie_t var8
rename from_woj_lubelskie_t var9
rename from_woj_bialostockie_old_t var10
rename from_woj_olsztynskie_old_t var11
rename from_woj_gdanskie_old_t var12
rename from_woj_katowickie_old_t var13
rename from_woj_krakowskie_t var14
rename from_woj_rzeszowskie_t var15
rename from_USRR_t var16

reshape long var, i(powiaty_code) j(id) 

rename var share_hist

**************************************************************************************
*****  4. Merge CBOS flows with census data 
**************************************************************************************


merge 1:1 powiaty_code id using "`share_flows_woj.dta'"


keep if _merge == 3
drop _merge


**************************************************************************************
*****  5. Generate graphs and regressions 
**************************************************************************************



reg share_hist share_our, cl(powiaty_code)

mat mcoeff = e(b)
mat var = e(V) 
scalar sterr = round(sqrt(var[1,1])*1000)/1000
scalar coef = round(mcoeff[1,1]*1000)/1000
scalar tstat = round((mcoeff[1,1])/(sqrt(var[1,1]))*100)/100
scalar pval = ttail(462,abs(coef/sterr))*2
scalar R_sq = round(e(r2_a)*1000)/1000

local myNote = "coef="+string(coef) + ";   Robust SE="+ string(sterr) + ";   t=" + string(tstat) + ";   R-sq=" +string(R_sq) +"  (Cluster by county)"



graph twoway (lfit share_hist share_our) (scatter share_hist share_our, msymbol(o)), title("County-level shares of migrants from 16 origins") ytitle("Census 1950 shares") xtitle("Ancestry Survey data shares") ///
legend(off) scheme(s1mono)
graph export "${path}/Results/Figures/Fig_A9_Panel_A.eps", replace as(eps)
graph export "${path}/Results/Figures/Fig_A9_Panel_A.pdf", replace as(pdf)



***********************************************************************************************
***** RELATIONSHIPS FOR KRESY ORIGIN LOCATION:	
	 
		
reg share_hist share_our, cluster(powiaty_code)


reg share_hist share_our

label var share_hist "migrants in this pow from woj_1950 X)/(all pop in this pow in 1950)"

label var share_hist "Census 1950 shares"
label var share_our "Ancestry Survey data shares"

label var id "woj 1950"

 
label define woj_id 1 "WT" 2 "Warsaw city" 3 "Warszawskie Voivodeship" 4 "Bydgoskie Voivodeship" 5 "Poznanskie Voivodeship" 6 "Lodz city" 7 "Lodzkie Voivodeship" 8 "Kieleckie Voivodeship" 9 "Lubelskie Voivodeship" 10 "Bialostockie Voivodeship" 11 "Olsztynskie Voivodeship" 12 "Gdanskie Voivodeship" 13 "Katowickie Voivodeship" 14 "Krakowskie Voivodeship" 15 "Rzeszowskie Voivodeship" 16 "From Kresy"

label values id woj_id

tempfile for_reg
save "`for_reg.dta'", replace


forvalues x = 16/16 {
	use "`for_reg.dta'", clear 
	keep if id == `x'
	
	if `x' == 1 { 
		local title "WT"
	}
	
	if `x' == 2 { 
		local title "Warsaw city"
	}
	
	if `x' == 3 { 
		local title "Warszawskie Voivodeship"
	}
	
	if `x' == 4 { 
		local title "Bydgoskie Voivodeship"
	}
	
	if `x' == 5 { 
		local title "Poznanskie Voivodeship"
	}
	
	if `x' == 6 { 
		local title "Lodz city"
	}
	
	if `x' == 7 { 
		local title "Lodzkie Voivodeship"
	}
	
	if `x' == 8 { 
		local title "Kieleckie Voivodeship"
	}
	
	if `x' == 9 { 
		local title "Lubelskie Voivodeship"
	}
	
	if `x' == 10 { 
		local title "Bialostockie Voivodeship"
	}
	
	if `x' == 11 { 
		local title "Olsztynskie Voivodeship"
	}
	
	if `x' == 12 { 
		local title "Gdanskie Voivodeship"
	}
	
	if `x' == 13 { 
		local title "Katowickie Voivodeship"
	}
	
	if `x' == 14 { 
		local title "Krakowskie Voivodeship"
	}
	
	if `x' == 15 { 
		local title "Rzeszowskie Voivodeship"
	}
	
	if `x' == 16 { 
		local title "From Kresy"
	}

	 clear matrix
	reg share_hist share_our, r

	
	
mat mcoeff = e(b)
mat var = e(V) 
scalar sterr = round(sqrt(var[1,1])*1000)/1000
scalar coef = round(mcoeff[1,1]*1000)/1000
scalar tstat = round((mcoeff[1,1])/(sqrt(var[1,1]))*100)/100
scalar pval = ttail(462,abs(coef/sterr))*2
scalar R_sq = round(e(r2_a)*1000)/1000

	local myNote = "coef="+string(coef) + ";   Robust SE="+ string(sterr) + ";   t=" + string(tstat) + ";   R-sq=" +string(R_sq)

graph twoway (lfit share_hist share_our) (scatter share_hist share_our, msymbol(o)), title("Shares of Kresy migrants in WT counties") ytitle("Census 1950 shares") legend(off) scheme(s1mono)
graph export "${path}/Results/Figures/Fig_A9_Panel_B.eps", replace as(eps)
graph export "${path}/Results/Figures/Fig_A9_Panel_B.pdf", replace as(pdf)
}
