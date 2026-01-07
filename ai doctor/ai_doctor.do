/* header */
version 19.5
set more off, permanently


/* data cleaning */
use "ai_doctor.dta", clear

forvalues i = 1/4 {
   replace g`i'f1 = "0" if g`i'f1 == "N"
   replace g`i'f1 = "1" if g`i'f1 == "Y"
   }

forvalues i = 1/4 {
   destring g`i'f1, replace
   }


/* quality checks */
keep if kontrolle == 4
keep if lastpage == 9


/* sample */
sum alter

label define geschlecht_lb 1 "Männlich" ///
                           2 "Weiblich" ///
                           3 "Divers", replace
   label values geschlecht geschlecht_lb

tab geschlecht


/* question 1 */
preserve
   rename (g1f1 g2f1 g3f1 g4f1) (g1 g2 g3 g4)
   
   reshape long g, i(id) j(gruppe)
   
   rename g antwort
   
   label define gruppe_lb 1 "Folgt; Stirbt" ///
                          2 "Folgt; Überlebt" ///
                          3 "Folgt Nicht; Stirbt" ///
                          4 "Folgt Nicht; Überlebt", replace
      label values gruppe gruppe_lb
   
   label define antwort_lb 0 "Nein" 1 "Ja"
      label values antwort antwort_lb
   
   histogram antwort, percent discrete by(gruppe, note("") graphregion(fcolor(white))) ///
             xtitle("Antwort") ///
             xlabel(0 "Nein" 1 "Ja") ///
             ytitle("Prozent") ///
             yscale(range(0 100))
      graph export ai_doctor_q1.pdf, replace
   
   tab gruppe antwort, chi2
   
   recode gruppe (3 4 = 0 "Folgt Nicht") (1 2 = 1 "Folgt"), gen(verhalten)
   
   tab verhalten antwort, chi2
   
   recode gruppe (1 3 = 0 "Stirbt") (2 4 = 1 "Überlebt"), gen(ausgang)
   
   tab ausgang antwort, chi2
restore


/* question 2 */
preserve
   rename (g1f2 g2f2 g3f2 g4f2) (g1 g2 g3 g4)
   
   reshape long g, i(id) j(gruppe)
   
   rename g antwort
   
   graph bar, over(antwort) by(gruppe)
      graph export ai_doctor_q2.pdf, replace
   
   oneway antwort gruppe, bonferroni
restore


/* question 3 */
preserve
   rename (g1f3 g2f3 g3f3 g4f3) (g1 g2 g3 g4)
   
   reshape long g, i(id) j(gruppe)
   
   rename g antwort
   
   graph bar, over(antwort) by(gruppe)
      graph export ai_doctor_q3.pdf, replace
   
   oneway antwort gruppe, bonferroni
restore


/* question 2 vs question 3 */
ttest g1f2 == g1f3

ttest g2f2 == g2f3

ttest g3f2 == g3f3

ttest g4f2 == g4f3

gen gesamt_f2 = .
   replace gesamt_f2 = g1f2
   replace gesamt_f2 = g2f2
   replace gesamt_f2 = g3f2
   replace gesamt_f2 = g4f2

gen gesamt_f3 = .
   replace gesamt_f3 = g1f3
   replace gesamt_f3 = g2f3
   replace gesamt_f3 = g3f3
   replace gesamt_f3 = g4f3

ttest gesamt_f2 == gesamt_f3


exit
