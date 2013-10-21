## clean out any previous work
outputs <- c(list.files(pattern = "*.tsv$"),
             list.files(pattern = "*.rds$"),
             list.files(pattern = "*.png$"))
file.remove(outputs)

## run my scripts
source("HW06_Cleaning_and_Ordering.R")
source("HW06_Aggregate_and_Plots.R")
