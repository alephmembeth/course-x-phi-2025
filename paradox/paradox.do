/* header */
version 19.5
set more off, permanently


/* data cleaning */
use "paradox.dta", clear

forvalues i = 1/3 {
   replace g`i'f1 = "0" if g`i'f1 == "N"
   replace g`i'f1 = "1" if g`i'f1 == "Y"
   }

forvalues i = 1/3 {
   replace g`i'f2 = "0" if g`i'f2 == "N"
   replace g`i'f2 = "1" if g`i'f2 == "Y"
   }

forvalues i = 1/3 {
   destring g`i'f1, replace
   }

forvalues i = 1/3 {
   destring g`i'f2, replace
   }


/* quality checks */
keep if kontrolle == 1
keep if lastpage == 8


/* sample */
sum alter

label define geschlecht_lb 1 "Männlich" ///
                           2 "Weiblich" ///
                           3 "Divers", replace
   label values geschlecht geschlecht_lb

tab geschlecht


/* question 1 */
preserve
   rename (g1f1 g2f1 g3f1) (g1 g2 g3)
   
   reshape long g, i(id) j(gruppe)
   
   rename g antwort
   
   label define gruppe_lb 1 "Widerspruch" ///
                          2 "Paradoxie" ///
                          3 "Lüge", replace
      label values gruppe gruppe_lb
   
   label define antwort_lb 0 "Nein" 1 "Ja"
      label values antwort antwort_lb
   
   histogram antwort, percent discrete by(gruppe, rows(1) note("") graphregion(fcolor(white))) ///
             xtitle("Antwort") ///
             xlabel(0 "Nein" 1 "Ja") ///
             ytitle("Prozent") ///
             yscale(range(0 100))
      graph export paradox_q1.pdf, replace
   
   tab gruppe antwort, chi2
restore


/* question 2 */
preserve
   rename (g1f2 g2f2 g3f2) (g1 g2 g3)
   
   reshape long g, i(id) j(gruppe)
   
   rename g antwort
   
   label define gruppe_lb 1 "Widerspruch" ///
                          2 "Paradoxie" ///
                          3 "Lüge", replace
      label values gruppe gruppe_lb
   
   label define antwort_lb 0 "Nein" 1 "Ja"
      label values antwort antwort_lb
   
   histogram antwort, percent discrete by(gruppe, rows(1) note("") graphregion(fcolor(white))) ///
             xtitle("Antwort") ///
             xlabel(0 "Nein" 1 "Ja") ///
             ytitle("Prozent") ///
             yscale(range(0 100))
      graph export paradox_q2.pdf, replace
   
   tab gruppe antwort, chi2
restore


/* question 1 vs question 2 */
forvalues i = 1/3 {
   tab g`i'f1 g`i'f2, chi2
   }


exit
