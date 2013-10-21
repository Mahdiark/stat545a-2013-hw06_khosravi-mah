library(ggplot2)
library(plyr)
library(xtable)
library(RColorBrewer)
library(grid)

fDat <- readRDS("finance_clean.rds")
fDatWide <- read.delim("finance_wide.tsv")

## Colors 
#---------------------------------------------------
yearColors <- c("magenta","magenta1","magenta2","magenta3","magenta4","maroon",
                "maroon4","maroon3","maroon2","maroon1","mediumvioletred")
names(yearColors)  <- as.character(unique(fDat$Year))

BankColors <- brewer.pal(n = 4, name = "Dark2")
names(BankColors) <- levels(fDatWide$Bank)

## All banks data aggregation and plots
#--------------------------------------------------
# Some countries only have data for "All banks"
jDat <- droplevels(subset(fDat, Bank == "All_banks"))

# we can see increase in loans on different years:
Fig1 <- ggplot(subset(jDat, Index == "Loans" & Country %in% c("Belgium","Canada","Norway")), 
           aes(x= Year, y= Value, col= Country)) + geom_point() + geom_line() + ggtitle("Actuall Values") + 
           ylab("Loans")
print(Fig1)
ggsave("Loans_allBanks_selectedCountries_Actual.png")
# this will be also plotted vs. normalized data later

# Average changes are different in order, logging fades away the incease in years,
# so comparing the average changes is the other option:
loanDat <- droplevels(subset(jDat, Index == "Loans"))
jloanAvg <- ddply(loanDat, ~ Country, summarise, AvgLoan = mean(Value))
AvgLoanVec <- jloanAvg$AvgLoan
names(AvgLoanVec) <- as.character(jloanAvg$Country)

jloanAvgDat <- ddply(loanDat, ~ Country + Year, function(x){
            meanVar <- as.character(x$Country[1])
            noramizedValue <- x$Value/AvgLoanVec[meanVar]
            names(noramizedValue) <- "noramizedValue"
            return(noramizedValue)
            })

Fig2 <- ggplot(subset(jloanAvgDat, Country %in% c("Belgium","Canada","Norway")), 
          aes(x= Year, y= noramizedValue, col= Country)) + geom_point() +geom_line() +
          ggtitle("Normalized Values") + ylab("Loans")
# Much better
ggsave("Loans_allBanks_selectedCountries_Normalized.png")

# I tried to put Fig1 and Fig2 aside each other but the result is not interesting after all!
pdf("Loans_allBanks_selectedCountries_NormalizedVsActual.pdf", width = 15, height = 6)
grid.newpage()
pushViewport(viewport(layout = grid.layout(1, 2)))
vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
print(Fig1, vp = vplayout(1, 1))
print(Fig2, vp = vplayout(1, 2))
dev.off()
# ggsave("Loans_allBanks_selectedCountries_NormalizedVsActual.png")

# still crappy for all the countries
ggplot(jloanAvgDat, aes(x= Year, y= noramizedValue, col= Country)) + 
  geom_point() + geom_line() + guides(col = guide_legend(ncol = 2))
ggsave("Loans_allBanks_allCountries_Normalized.png")

# Better to compare the coefficients of linear regressions:
loanFun <- function(x ,yearMin) {
  estCoefs <- coef(lm(noramizedValue ~ I(Year - yearMin), x))
  names(estCoefs) <- c("intercept", "slope")
  return(estCoefs)
}

loanCoefs <- ddply(jloanAvgDat, ~ Country, loanFun, yearMin = min(fDat$Year))
loanCoefs <- within(loanCoefs, Country <- reorder(Country, slope))
ggplot(loanCoefs, aes(x = Country, weight = slope)) + ylab("Slope") + ggtitle("Normalized Loans Data") +
  geom_bar(aes(fill = "magenta4"), position = position_dodge(width = 0.6), show_guide = FALSE) +
  theme(axis.text.x = element_text(angle=45), axis.title.x= element_text(vjust=2))
ggsave("LoansSlopes_allBanks_allCountries_Normalized.png")

# If we want to use dodging for Slope and Intercept, we need to reshape the data to tall
loanCoefsTall <- reshape(loanCoefs, direction="long", v.names="Value", idvar="Country", timevar="Coefficients",
                         varying=list(names(loanCoefs)[2:length(names(loanCoefs))]), 
                         times=c("intercept","slope"))
loanCoefsTall <- arrange(loanCoefsTall, Country, Coefficients, Value)
ggplot(loanCoefsTall, aes(x = Country, weight = Value)) + ylab("Coefficients") +
  geom_bar(aes(fill = Coefficients), position= position_dodge(width = 0.6)) +ggtitle("Normalized Loans Data")+
  theme(axis.text.x = element_text(angle=45), axis.title.x= element_text(vjust=2))
ggsave("LoansCoefs_allBanks_allCountries_Normalized.png")

# not interesting, better to see non-normalized loan data set
# barchart for not normalized, i.e. using loanDat:
loanFunTot <- function(x ,yearMin) {
  estCoefs <- coef(lm(Value ~ I(Year - yearMin), x))
  names(estCoefs) <- c("intercept", "slope")
  return(estCoefs)
}
loanCoefsTot <- ddply(loanDat, ~ Country, loanFunTot, yearMin = min(fDat$Year))
loanCoefsTot <- within(loanCoefsTot, Country <- reorder(Country, slope))
loanCoefsTotTall <- reshape(loanCoefsTot, direction="long", v.names="Value", idvar="Country", 
                         varying=list(names(loanCoefsTot)[2:length(names(loanCoefsTot))]), 
                         timevar="Coefficients", times=c("intercept","slope"))
loanCoefsTotTall <- arrange(loanCoefsTotTall, Country, Coefficients, Value)
ggplot(loanCoefsTotTall, aes(x = Country, weight = Value)) + scale_y_log10() + ylab("Coefficients") +
  geom_bar(aes(fill = Coefficients), position = position_dodge(width = 0.6)) + ggtitle("Loans Data") + 
  theme(axis.text.x = element_text(angle=45), axis.title.x= element_text(vjust=2))
# Better. Intercepts for Russia, Estony and Slovenia are negative and not plotted here. Ditto Japan's Slope.
ggsave("LoansCoefs_allBanks_allCountries_Actual.png")

## Different banks data aggregation and plots
#-----------------------------------------------------
# Here we use the wide table we produced before, we can easily investigate correlations among indexes:
#Knittering should have been used here!!
#Dumm1 <- fDatWide[sample(nrow(fDatWide), 10),  ]
#print(xtable(Dumm1),type = "html", include.rownames = FALSE)

# Correlation of different indexes 
# Net_provisions and Interest_income for instance, for different countries:
ggplot(fDatWide, aes(x= Net_provisions, y= Interest_income, col= Country)) + geom_point(size= 2.5,alpha=(0.6))+
  scale_x_log10() + scale_y_log10() + guides(col = guide_legend(ncol = 2)) + ggtitle("Indexes Correlation")
ggsave("IndexCorrelation_interest_provisions.png")

# for a custom selection of countries and sized by loans:
facetCountries <- c("Canada","Denmark","Finland","France" ,"Spain","Mexico")
sizeIndex <- "Loans"
facetDat <- subset(fDatWide[with(fDatWide, order(-1 * Loans)), ], Country %in% facetCountries)

ggplot(facetDat, aes(x= Net_provisions, y= Interest_income, fill= Bank))+
  geom_point(aes(size = sqrt(Loans/pi)), pch = 21, show_guide = TRUE) + scale_x_log10() + 
  scale_y_log10() + facet_wrap(~ Country) + scale_fill_manual(values = BankColors) +
  scale_size_continuous(range=c(3,20), guide= guide_legend(title="Loan")) + 
  ggtitle("Indexes Correlation")
ggsave("IndexCorrelation_interest_provisions_facet.png")

# HR plots
# Some countries show a decrease in emplyees between 2002 to 2006
CustomCountries <- c("Turkey","Switzerland","Spain","Mexico","Germany","France")
ggplot(subset(fDatWide, Country %in% CustomCountries & Bank == "Commercial_banks"), 
  aes(x = Year, y = Number_of_employees, size = sqrt(Number_of_institutions/pi), fill= Country)) + 
  geom_point(pch = 21, show_guide = TRUE) + ylab("Employees") + ggtitle("Employment in Commercial Banks")+
  scale_size_continuous(range=c(3,10), guide= guide_legend(title="Institutions"))
ggsave("Employment_CommercialBanks_SelectedCounttries.png")

# Number of employees in us's commercial banks which shows a decrease after 2007 with decreasing number of
# institutions
ggplot(subset(fDatWide, Country == "US" & Bank == "Commercial_banks"), aes(x = Year, y = Number_of_employees,
  size = sqrt(Number_of_institutions/pi))) + geom_point(pch = 21) + 
  scale_size_continuous(range=c(5,12), guide= guide_legend(title="Institutions")) + ylab("Employees") +
  aes(fill="magenta1", show_guide = FALSE) + ggtitle("Employment in US's Commercial Banks")
ggsave("Employment_CommercialBanks_USA.png")

## Write the Loans Coefficient table to file:
#--------------------------------------------------------
write.table(loanCoefs, "LoansVsYear_lmCoefficients.tsv", quote = FALSE,
            sep = "\t", row.names = FALSE)
