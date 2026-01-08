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

label define geschlecht_lb 1 "Männlich" ///
                           2 "Weiblich" ///
                           3 "Divers", replace
   label values geschlecht geschlecht_lb

tab geschlecht


/* understanding */
label define sterbehilfe_lb 0 "Nein" ///
                            1 "Ja", replace
   label values sterbehilfe sterbehilfe_lb

tab sterbehilfe


/* question */
preserve
   reshape long g, i(id) j(gruppe)
   
   rename g antwort
   
   label define gruppe_lb 1 "Alt; Tödlich" ///
                          2 "Alt; Nicht Tödlich" ///
                          3 "Mittel; Tödlich" ///
                          4 "Mittel; Nicht Tödlich" ///
                          5 "Jung; Tödlich" ///
                          6 "Jung; Nicht Tödlich", replace
      label values gruppe gruppe_lb
   
   label define antwort_lb 0 "Nein" 1 "Ja"
      label values antwort antwort_lb
   
   histogram antwort, percent discrete by(gruppe, rows(3) note("") graphregion(fcolor(white))) ///
             xtitle("Antwort") ///
             xlabel(0 "Nein" 1 "Ja") ///
             ytitle("Prozent") ///
             yscale(range(0 100))
      graph export euthanasia.pdf, replace
   
   tab gruppe antwort, chi2 V
   
   recode gruppe (5 6 = 0 "Jung") (3 4 = 1 "Mittel") (1 2 = 2 "Alt"), gen(altersgruppe)
   
   tab altersgruppe antwort, chi2 V
   
   recode gruppe (2 4 6 = 0 "Nicht Tödlich") (1 3 5 = 1 "Tödlich"), gen(toedlich)
   
   tab toedlich antwort, chi2 V
   
   tab alter_kat antwort, chi2 V
restore


exit
