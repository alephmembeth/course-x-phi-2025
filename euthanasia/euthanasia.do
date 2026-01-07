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

label define geschlecht_lb 1 "Männlich" ///
                           2 "Weiblich" ///
                           3 "Divers", replace
   label values geschlecht geschlecht_lb

tab geschlecht


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
   
   tab gruppe antwort, chi2
   
   recode gruppe (5 6 = 0 "Jung") (3 4 = 1 "Mittel") (1 2 = 2 "Alt"), gen(altersgruppe)
   
   tab altersgruppe antwort, chi2
   
   recode gruppe (2 4 6 = 0 "Nicht Tödlich") (1 3 5 = 1 "Tödlich"), gen(toedlich)
   
   tab toedlich antwort, chi2
restore


exit
