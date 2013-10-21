## clean out any previous work
outputs <- c(list.files(pattern = "*.tsv$"),        # This is alright since my raw data is  ".csv"
             list.files(pattern = "*.rds$"),
             list.files(pattern = "*.png$"),
             list.files(pattern = "*.pdf$"))
file.remove(outputs)

## run my scripts
source("Cleaning_and_Ordering.R")
source("Aggregate_and_Plots.R")
