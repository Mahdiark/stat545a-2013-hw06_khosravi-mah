HW #06: The Last Challenge
--------------------------

Here is a description of how this pipeline works and what it does. The source data from last week,
i.e. "Bank Profitability Statistics" under the "Finance" subsection from [OECD.Stat Extracts](http://stats.oecd.org/)
was imported again, but a better sence of cleaning and managing the data set was applied this time.  

### Data Description:  

The quantitative values of different financial indexes, in different types of banking institutions, are presented
for 33 countries in a ten year time span. Variables in the cleaned data are country, bank (commercial vs. saving,
etc.), index (interest income, provisions, loans, etc.), year, and finally values.

### How to replicate my analysis:

  * Essential tools:
    - Input data: [`BankProfitabilityStatistics.csv`](https://github.com/Mahdiark/stat545a-2013-hw06_khosravi-mah/blob/master/BankProfitabilityStatistics.csv). You should view it in raw version, unfortunately. GitHub doesn't show big files like this one!
    - Scripts: [`Cleaning_and_Ordering.R`](https://github.com/Mahdiark/stat545a-2013-hw06_khosravi-mah/blob/master/Cleaning_and_Ordering.R) and [`Aggregate_and_Plots.R`](https://github.com/Mahdiark/stat545a-2013-hw06_khosravi-mah/blob/master/Aggregate_and_Plots.R)
    - Makefile-like script: [`Make.R`](https://github.com/Mahdiark/stat545a-2013-hw06_khosravi-mah/blob/master/Make.R)
  * `Source` the `Makefile.R` in RStudio, or alternatively, in a shell: `Rscript Makefile.R`.
  * When you run the code, you will see a number of warnings which are addressing the *missing values*. This the result of missing data (NAs) in the raw data set.
  
### Results:

New files you should see after running the pipeline and a short elaboration on each of them is presented here.
I have made a [`My_figures`](https://github.com/Mahdiark/stat545a-2013-hw06_khosravi-mah/tree/master/My_figures) 
folder here just to make the homework repository a bit tidier:

  * #### Outputs of [`Cleaning_and_Ordering.R`](https://github.com/Mahdiark/stat545a-2013-hw06_khosravi-mah/blob/master/Cleaning_and_Ordering.R):
    - [`Barchart_income_types.png`](https://github.com/Mahdiark/stat545a-2013-hw06_khosravi-mah/blob/master/My_figures/Barchart_income_types.png):
     * Shows and compares two income types in different banks.
    - [`Density_NetProvisions.png `](https://github.com/Mahdiark/stat545a-2013-hw06_khosravi-mah/blob/master/My_figures/Density_NetProvisions.png):
     * Shows density diagram for net provision index in different countries.


    - [`barchart_totalWords.png`](https://raw.github.com/jennybc/STAT545A/master/hw06_scaffolds/01_justR/barchart_totalWords.png)
    - [`barchart_totalWordsFilmDodge.png`](https://raw.github.com/jennybc/STAT545A/master/hw06_scaffolds/01_justR/barchart_totalWordsFilmDodge.png)
    - [`lotr_clean.tsv`](https://github.com/jennybc/STAT545A/blob/master/hw06_scaffolds/01_justR/lotr_clean.tsv)
