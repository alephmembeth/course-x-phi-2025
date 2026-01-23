/* header */
version 19.5
set more off, permanently


/* data cleaning */
use "euthanasia.dta", clear

forvalues i = 1/6 {
   replace g`i' = "0" if g`i' == "N"
   replace g`i' = "1" if g`i' == "Y"
   }

forvalues i = 1/6 {
   destring g`i', replace
   }


/* quality checks */
keep if kontrolle == 5
keep if lastpage == 12


/* sample */
sum alter

gen alter_kat = .
   replace alter_kat = 1 if alter >= 18 & alter <= 29
   replace alter_kat = 2 if alter >= 30 & alter <= 39
   replace alter_kat = 3 if alter >= 40 & alter <= 49
   replace alter_kat = 4 if alter >= 50 & alter <= 59
   replace alter_kat = 5 if alter >= 60

label define alter_kat_lb 1 "18–29" ///
                          2 "30–39" ///
                          3 "40–49" ///
                          4 "50–59" ///
                          5 "≥60", replace
   label values alter_kat alter_kat_lb

tab alter_kat

label define geschlecht_lb 1 "Male" ///
                           2 "Female" ///
                           3 "Other", replace
   label values geschlecht geschlecht_lb

tab geschlecht


/* understanding */
label define sterbehilfe_lb 0 "No" ///
                            1 "Yes", replace
   label values sterbehilfe sterbehilfe_lb

tab sterbehilfe


/* question */
preserve
   reshape long g, i(id) j(gruppe)
   
   rename g antwort
   
   label define gruppe_lb 1 "Old; Lethal" ///
                          2 "Old; Non-Lethal" ///
                          3 "Middle-Aged; Lethal" ///
                          4 "Middle-Aged; Non-Lethal" ///
                          5 "Young; Lethal" ///
                          6 "Young; Non-Lethal", replace
      label values gruppe gruppe_lb
   
   label define antwort_lb 0 "No" 1 "Yes"
      label values antwort antwort_lb
   
   histogram antwort, percent discrete by(gruppe, rows(3) note("") graphregion(fcolor(white))) ///
             xtitle("Answer") ///
             xlabel(0 "No" 1 "Yes") ///
             ytitle("Percent") ///
             yscale(range(0 100))
      graph export euthanasia.pdf, replace
   
   tab gruppe antwort, chi2 V
   
   recode gruppe (5 6 = 0 "Young") (3 4 = 1 "Middle-Aged") (1 2 = 2 "Old"), gen(altersgruppe)
   
   tab altersgruppe antwort, chi2 V
   
   recode gruppe (2 4 6 = 0 "Non-Lethal") (1 3 5 = 1 "Lethal"), gen(toedlich)
   
   tab toedlich antwort, chi2 V
   
   tab alter_kat antwort, chi2 V
restore


exit
