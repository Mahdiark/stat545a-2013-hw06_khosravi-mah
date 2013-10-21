## clean out any previous work
outputs <- c(list.files(pattern = "*.tsv$"),
             list.files(pattern = "*.rds$"),
             list.files(pattern = "*.png$"))
file.remove(outputs)

## run my scripts
source("Cleaning_and_Ordering.R")
source("Aggregate_and_Plots.R")
