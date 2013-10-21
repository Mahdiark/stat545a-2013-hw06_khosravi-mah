HW #06: The Last Challenge
--------------------------




The source data from last week, i.e. "Bank Profitability Statistics" under the "Finance" subsection from [OECD.Stat Extracts](http://stats.oecd.org/)
was imported again, but better sence of cleaning and managing the data set was applied this time.  

### Data Description:  

The quantitative values of different financial indexes, in different types of banking institutions, are presented
for 33 countries in a ten year time span. Variables in the cleaned data are country, bank (commercial vs. saving,
etc.), index (interest income, provisions, loans, etc.), year, and finally values.

How to replicate my analysis

  * Essential tools:
    - Input data: [`BankProfitabilityStatistics.csv`](https://github.com/Mahdiark/stat545a-2013-hw06_khosravi-mah/blob/master/BankProfitabilityStatistics.csv). You should view it in raw version, unfortunately. GitHub doesn't show big files like this one!
    - Scripts: [`Cleaning_and_Ordering.R`](https://github.com/Mahdiark/stat545a-2013-hw06_khosravi-mah/blob/master/Cleaning_and_Ordering.R) and [`Aggregate_and_Plots.R`](https://github.com/Mahdiark/stat545a-2013-hw06_khosravi-mah/blob/master/Aggregate_and_Plots.R)
    - Makefile-like script: [`Make.R`](https://github.com/Mahdiark/stat545a-2013-hw06_khosravi-mah/blob/master/Make.R)
  * Start a fresh RStudio session, make sure the above directory is the working directory, open `Makefile.R`, and click
  * on "Source".
  * Alternatively, in a shell: `Rscript Makefile.R`.
  * When you run the pipeline the first time, you will get warnings about `file.remove()` trying to remove files that don't exist. That's OK. They will exist and will be removed and remade on subsequent runs.
  * New files you should see after running the pipeline:
    - [`barchart_totalWords.png`](https://raw.github.com/jennybc/STAT545A/master/hw06_scaffolds/01_justR/barchart_totalWords.png)
    - [`barchart_totalWordsFilmDodge.png`](https://raw.github.com/jennybc/STAT545A/master/hw06_scaffolds/01_justR/barchart_totalWordsFilmDodge.png)
    - [`lotr_clean.tsv`](https://github.com/jennybc/STAT545A/blob/master/hw06_scaffolds/01_justR/lotr_clean.tsv)
    - `stripplot_wordsByRace_FILM.png`, where FILM is one of the 3 movies. Example: [`stripplot_wordsByRace_The_Fellowship_Of_The_Ring.png`](https://raw.github.com/jennybc/STAT545A/master/hw06_scaffolds/01_justR/stripplot_wordsByRace_The_Fellowship_Of_The_Ring.png)
    - [`totalWordsByFilmRace.tsv`](https://github.com/jennybc/STAT545A/blob/master/hw06_scaffolds/01_justR/totalWordsByFilmRace.tsv)

