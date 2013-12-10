## clean out any previous work
outputs <- c(list.files(pattern = "*.tsv$"),        # This is alright since my raw data is  ".csv"
             list.files(pattern = "*.rds$"),
             list.files("My_figures", pattern = "*.png$", full.names = TRUE),
             list.files("My_figures", pattern = "*.pdf$", full.names = TRUE))
file.remove(outputs)

## run my scripts
source("Cleaning_and_Ordering.R")
source("Aggregate_and_Plots.R")
