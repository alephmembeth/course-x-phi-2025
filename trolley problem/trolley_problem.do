cd "/Users/amb/Desktop/GitHub/course-x-phi-2025/trolley problem"

/* header */
version 19.5
set more off, permanently


/* data cleaning */
use "trolley_problem.dta", clear

forvalues i = 1/4 {
   replace g`i' = "0" if g`i' == "N"
   replace g`i' = "1" if g`i' == "Y"
   }

forvalues i = 1/4 {
   destring g`i', replace
   }


/* quality checks */
keep if kontrolle == 1
keep if lastpage == 10


/* sample */
sum alter

label define gender_lb 1 "Männlich" ///
                       2 "Weiblich" ///
                       3 "Divers", replace
   label values gender gender_lb

tab gender


/* question */
preserve
   reshape long g, i(id) j(gruppe)
   
   rename g antwort
   
   label define gruppe_lb 1 "Fremd; Würde" ///
                          2 "Fremd; Sollte" ///
                          3 "Eingeladen; Würde" ///
                          4 "Eingeladen; Sollte", replace
      label values gruppe gruppe_lb
   
   label define antwort_lb 0 "Nein" 1 "Ja"
      label values antwort antwort_lb
   
   histogram antwort, percent discrete by(gruppe, note("") graphregion(fcolor(white))) ///
             xtitle("Antwort") ///
             xlabel(0 "Nein" 1 "Ja") ///
             ytitle("Prozent") ///
             yscale(range(0 100))
      graph export trolley_problem.pdf, replace
   
   tab gruppe antwort, chi2 V
   
   recode gruppe (1 2 = 0 "Fremd") (3 4 = 1 "Eingeladen"), gen(verhaeltnis)
   
   tab verhaeltnis antwort, chi2 V
   
   recode gruppe (1 3 = 0 "Würde") (2 4 = 1 "Sollte"), gen(formulierung)
   
   tab formulierung antwort, chi2 V
   
   tab gruppe antwort if inlist(gruppe, 1, 2), chi2 V
   
   tab gruppe antwort if inlist(gruppe, 3, 4), chi2 V
   
   tab gruppe antwort if inlist(gruppe, 1, 3), chi2 V
   
   tab gruppe antwort if inlist(gruppe, 2, 4), chi2 V
restore


exit
