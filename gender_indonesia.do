/*

This do file replicates the main analyses conducted in:

Nakajima, N., Jung, H., Pradhan, M., Hasan, A., Kinnell, A., & Brinkman, S. (2019). 
Gender gaps in cognitive and social‐emotional skills in early primary grades: 
Evidence from rural Indonesia. 

(https://onlinelibrary.wiley.com/doi/abs/10.1111/desc.12931) 

*/


clear

set scheme s2color, permanently

use "Gender paper cleaned data.dta", replace
			 
*********************************************************************************************************
* Table 2  - Summary of outcomes
*********************************************************************************************************

estimates drop _all

foreach y in zcompscore_lang zcompscore_math zcompscore_cog ///
			 std_short_phys std_short_soc std_short_emot std_short_langcog std_short_comgen	{

	estpost tabstat `y', by(girl) statistics(mean sd min max) columns(statistics) listwise
	est store `y'
		
}
esttab zcompscore_lang zcompscore_math zcompscore_cog ///
	   std_short_phys std_short_soc std_short_emot std_short_langcog std_short_comgen	 ///
	   using "$output/table2.csv", replace main(mean) aux(sd) 
	   
	   
estimates drop _all

foreach y in zcompscore_lang zcompscore_math zcompscore_cog ///
			 std_short_phys std_short_soc std_short_emot std_short_langcog std_short_comgen	{

	reg `y' i.girl, robust
	est store `y'
		
}
xml_tab zcompscore_lang zcompscore_math zcompscore_cog ///
	    std_short_phys std_short_soc std_short_emot std_short_langcog std_short_comgen, ///
		save("$output/table2_diff.xls") replace drop (_cons) below star(0.1 0.05 0.01) format((N2202))	   


*********************************************************************************************************
* Figure 1 - Panel A
*********************************************************************************************************

estimates drop _all
graph drop _all

reg zcompscore_lang cov7##girl, robust cluster(childid)
	margins cov7#girl
	marginsplot, title("Language", size(medsmall)) ///
	xtitle("Age") ytitle("Test score (SD)") graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(Test2)	
	
reg zcompscore_math cov7##girl, robust cluster(childid)
	margins cov7#girl
	marginsplot, title("Math", size(medsmall)) ///
	xtitle("Age") ytitle("Test score (SD)") graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(Test3)
	
reg zcompscore_cog cov7##girl, robust cluster(childid)
	margins cov7#girl
	marginsplot, title("Abstract Reasoning", size(medsmall)) ///
	xtitle("Age") ytitle("Test score (SD)") graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(Test4)

grc1leg Test2 Test3 Test4, ycommon xcommon graphregion(color(white)) rows(1)
graph export test.pdf, replace	

	
*********************************************************************************************************
* Figure 1 - Panel B
*********************************************************************************************************

estimates drop _all
graph drop _all

preserve
drop if cov7 == 9
* The EDI for 9 year-olds is not an appropriate measure


reg std_short_phys cov7##girl, robust cluster(childid)
	margins cov7#girl
	marginsplot, title("Physical health & well-being", size(medsmall)) ///
	xtitle("Age") ytitle("EDI (SD)") graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(edi1)
	
reg std_short_soc cov7##girl, robust cluster(childid)
	margins cov7#girl
	marginsplot, title("Social competence", size(medsmall)) ///
	xtitle("Age") ytitle("EDI (SD)") graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(edi2)	
	
reg std_short_emot cov7##girl, robust cluster(childid)
	margins cov7#girl
	marginsplot, title("Emotional maturity", size(medsmall)) ///
	xtitle("Age") ytitle("EDI (SD)") graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(edi3)	

reg std_short_langcog cov7##girl, robust cluster(childid)
	margins cov7#girl
	marginsplot, title("Language & cognitive development", size(medsmall)) ///
	xtitle("Age") ytitle("EDI (SD)") graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(edi4)	
	
reg std_short_comgen cov7##girl, robust cluster(childid)
	margins cov7#girl
	marginsplot, title("Communication & general knowledge", size(medsmall)) ///
	xtitle("Age") ytitle("EDI (SD)") graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(edi5)	

grc1leg edi1 edi2 edi3 edi4 edi5, ycommon xcommon graphregion(color(white)) rows(2)
graph export edi.pdf, replace	

restore


*********************************************************************************************************
* Table 3 - Summary of explanatory vars & controls
*********************************************************************************************************	

egen highquality = cut(mn_sc_totalscore_c), group(2)
lab var highquality "Village avg. quality above median (1=Yes)"


estimates drop _all

foreach y in enr_allECD enr_SD cum_ecdmth cum_prismth parenting_total_go ///
			 highquality cov7 mother_edyrs_max zwealth {

	estpost tabstat `y', by(girl) statistics(mean sd min max) columns(statistics) listwise
	est store `y'
		
}
esttab enr_allECD enr_SD cum_ecdmth cum_prismth parenting_total_go ///
	   highquality cov7 mother_edyrs_max zwealth ///
	   using "$output/table3.csv", replace main(mean) aux(sd) 
	   
	   
estimates drop _all

foreach y in enr_allECD enr_SD cum_ecdmth cum_prismth parenting_total_go ///
			 highquality cov7 mother_edyrs_max zwealth {

	reg `y' i.girl, robust
	est store `y'
		
}
xml_tab enr_allECD enr_SD cum_ecdmth cum_prismth parenting_total_go ///
	   highquality cov7 mother_edyrs_max zwealth, ///
		save("$output/table3_diff.xls") replace drop (_cons) below star(0.1 0.05 0.01) format((N2202))	   


*********************************************************************************************************
* Figure 2 - Panel A
*********************************************************************************************************	
preserve

use "enrollment history long.dta", clear

egen highquality = cut(mn_sc_totalscore_c), group(2)
lab var highquality "Village avg. quality above median (1=Yes)"

estimates drop _all
graph drop _all

drop if age==10

reg total_ecd ib4.age##girl if age<8, robust cluster(childid)
	*Age 9 is omitted bc nobody is in preschool at age 9 
	margins ib4.age#girl
	marginsplot, title("All", size(medsmall)) ///
	ytitle("Months") ylabel(0(2)10) ///
	xtitle("Age") xlabel(2(1)8) ///
	legend(order(1 "Boys" 2 "Girls")) ///
	graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) fxsize(70) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(months1)
	
reg total_ecd ib4.age##girl if age<8 & highquality == 0, robust cluster(childid)
	*Age 9 is omitted bc nobody is in preschool at age 9 
	margins ib4.age#girl
	marginsplot, title("Low quality preschool", size(medsmall)) ///
	ytitle("Months") ylabel(0(2)10) ///
	xtitle("Age") xlabel(2(1)8) ///
	legend(order(1 "Boys" 2 "Girls")) ///
	graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) fxsize(70) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(low1)

reg total_ecd ib4.age##girl if age<8 & highquality == 1, robust cluster(childid)
	*Age 9 is omitted bc nobody is in preschool at age 9 
	margins ib4.age#girl
	marginsplot, title("High quality preschool", size(medsmall)) ///
	ytitle("Months") ylabel(0(2)10) ///
	xtitle("Age") xlabel(2(1)8) ///
	legend(order(1 "Boys" 2 "Girls")) ///
	graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) fxsize(70) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(high1)	
	
grc1leg months1 low1 high1, ycommon xcommon graphregion(color(white)) rows(1)
graph export preschool.pdf, replace	


*********************************************************************************************************
* Figure 2 - Panel B
*********************************************************************************************************	

estimates drop _all
graph drop _all

reg num_month_sd ib4.age##girl if age==4 | age==5 | age==6 | age==7 | age==8, robust cluster(childid)
	*Age 2 and 3 are omitted bc nobody is in primary at age 2/3 (probit model above corrected for it but not reg so it must be done manually)
	margins ib4.age#girl
	marginsplot, title("All", size(medsmall)) ///
	ytitle("Months") ylabel(0(2)10) ///
	xtitle("Age") xlabel(2(1)8)  ///
	legend(order(1 "Boys" 2 "Girls")) ///
	graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) fxsize(70) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(months1)
	
reg num_month_sd ib4.age##girl if (age==4 | age==5 | age==6 | age==7 | age==8) & highquality == 0, robust cluster(childid)
	*Age 2 and 3 are omitted bc nobody is in primary at age 2/3 (probit model above corrected for it but not reg so it must be done manually)
	margins ib4.age#girl
	marginsplot, title("Low quality preschool", size(medsmall)) ///
	ytitle("Months") ylabel(0(2)10) ///
	xtitle("Age") xlabel(2(1)8)  ///
	legend(order(1 "Boys" 2 "Girls")) ///
	graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) fxsize(70) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(low1)

reg num_month_sd ib4.age##girl if (age==4 | age==5 | age==6 | age==7 | age==8) & highquality == 1, robust cluster(childid)
	*Age 2 and 3 are omitted bc nobody is in primary at age 2/3 (probit model above corrected for it but not reg so it must be done manually)
	margins ib4.age#girl
	marginsplot, title("High quality preschool", size(medsmall)) ///
	ytitle("Months") ylabel(0(2)10) ///
	xtitle("Age") xlabel(2(1)8)  ///
	legend(order(1 "Boys" 2 "Girls")) ///
	graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) fxsize(70) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(high1)	
	
grc1leg months1 low1 high1, ycommon xcommon graphregion(color(white)) rows(1)
graph export primary.pdf, replace
	
restore

*********************************************************************************************************
* Figure 2 - Panel C
*********************************************************************************************************

estimates drop _all
graph drop _all

reg parenting_total_go cov7##girl, robust cluster(childid)
	margins cov7#girl
	marginsplot, title("All", size(medsmall)) ///
	xtitle("Age") ytitle("Parenting score") ///
	graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) fxsize(70) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(parent)

reg parenting_total_go cov7##girl if highquality == 0, robust cluster(childid)
	margins cov7#girl
	marginsplot, title("Low quality preschool", size(medsmall)) ///
	xtitle("Age") ytitle("Parenting score") ///
	graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) fxsize(70) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(low)
	
reg parenting_total_go cov7##girl if highquality == 1, robust cluster(childid)
	margins cov7#girl
	marginsplot, title("High quality preschool", size(medsmall)) ///
	xtitle("Age") ytitle("Parenting score") ///
	graphregion(color(white)) ///
	plotopt(msize(tiny)) fysize(40) fxsize(70) ciopts(lcolor(gs0)) ///
	plot1opts(lpattern(dash) lcolor(gs0) mcolor(gs0)) ///
	plot2opts(lpattern(solid) lcolor(gs0) mcolor(gs0)) ///
	name(high)	

grc1leg parent low high, ycommon xcommon graphregion(color(white)) rows(1)
graph export parent.pdf, replace



