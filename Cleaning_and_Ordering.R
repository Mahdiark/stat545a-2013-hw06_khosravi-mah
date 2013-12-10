library(plyr)
library(ggplot2)

## Data import and names change
#-----------------------------------------------------------
gDat <- read.delim(file="BankProfitabilityStatistics.csv", as.is = c(1:3))
str(gDat)
names(gDat)
names(gDat) <- c("Country", "Bank", "Index", "Year", "Value")

## Cleaning Country Variable:
#------------------------------------------------------------
gDat$Country <- as.factor(gsub(" ","_",gDat$Country))
gDat <- within(gDat, Country <- revalue(Country, c(Russian_Federation = "Russia",Slovak_Republic = "Slovakia",
                                                   United_States = "US", Czech_Republic = "Czech",
                                                   United_Kingdom = "UK")))
levels(gDat$Country)

## Cleaning Index variable:
#-------------------------------------------------------------
# Dependant indexes and memorandum data has been omitted here:
IndexLevels <- c("1. Interest income","2. Interest expenses","4. Net non-interest income",
                 "6. Operating expenses", "8. Net provisions","10. Income tax","12. Distributed profit",
                 "13. Retained profit ", "14. Cash and balance with Central bank","15. Interbank deposits",
                 "16. Loans","17. Securities", "18. Other assets", "19. Capital and reserves",
                 "20. Borrowing from Central bank","21. Interbank deposits","22. Customer deposits",
                 "23. Bonds","24. Other liabilities", "37. Number of institutions","38. Number of branches",
                 "39. Number of employees")
gDat <- droplevels(subset(gDat, Index %in% IndexLevels))
gDat$Index <- gsub("-","_",gDat$Index)
gDat$Index <- gsub("15. Interbank deposits","Interbank deposits_asset",gDat$Index)
gDat$Index <- gsub("[[:digit:]]+. ","",gDat$Index)
gDat$Index <- gsub(" ","_",gDat$Index)
gDat <- within(gDat, Index <- revalue(Index, c(Interbank_deposits= "Interbank_deposits_liab", 
                                               Retained_profit_= "Retained_profit")))
gDat$Index <- as.factor(gDat$Index)
levels(gDat$Index)

## Cleaning bank variable:
#---------------------------------------------------------------
gDat$Bank <- gsub(" ","_",gDat$Bank)
gDat$Bank <- gsub("Co-operative","Cooperative",gDat$Bank)
gDat <- within(gDat, Bank <- revalue(Bank, c(Other_miscellaneous_monetary_institutions = "Other_monetary_ins.")))
gDat$Bank <- as.factor(gDat$Bank)

# Omitting dependant bank levels
iDat <- droplevels(subset(gDat, !(Bank %in% c("All_banks","Foreign_commercial_banks",
                                              "Large_commercial_banks"))))
# iDat rows with zero value:
NoValueIndex <- as.numeric(row.names(iDat[iDat$Value == 0, ]))

# Reshaping iDat to wide to distinguish the indexes:
iDatWide <- reshape(iDat, direction= "wide", idvar= c("Country", "Bank", "Year"), timevar= "Index")
names(iDatWide) <- gsub("Value.","",names(iDatWide))

# Reordering the Index levels based on the IndexLevels vector:
IndexLevels <- names(iDatWide)[4:length(iDatWide)]
oldLevels <- levels(gDat$Index)
newOrder <- sapply(IndexLevels, function(x) grep(x, oldLevels))
gDat <- within(gDat, Index <- factor(as.character(gDat$Index),oldLevels[newOrder]))

## make some plots
#------------------------------------------------------------------------
ggplot(subset(iDat, Index == c("Interest_income","Net_non_interest_income")), aes(x = Bank, weight = Value)) + 
    geom_bar(aes(fill = Index), position = position_dodge(width = 0.6)) + scale_y_log10() + ylab("Income") +
    ggtitle("Income Types") + theme(axis.text.x = element_text(angle=20), axis.title.x= element_text(vjust=2))
ggsave("My_figures/Barchart_income_types.png")

ggplot(iDatWide, aes(x= Net_provisions, fill= Country)) + geom_density() + scale_x_log10() 
ggsave("My_figures/Density_NetProvisions.png")

ggplot(iDatWide, aes(x = Country, y = Operating_expenses)) + geom_boxplot() + scale_y_log10() +
  theme(axis.text.x = element_text(angle=25), axis.title.x= element_text(vjust=2))
ggsave("My_figures/Expense_boxplot.png")

## write data to file
#------------------------------------------------------------------------
write.table(gDat, "finance_clean.tsv", quote = FALSE,
            sep = "\t", row.names = FALSE)
saveRDS(gDat, "finance_clean.rds")
write.table(iDatWide, "finance_wide.tsv", quote = FALSE,
            sep = "\t", row.names = FALSE)
