setwd("~/Coursera/ExploratoryDataAnalysis/Project 2/")
library(dplyr)

#Read external to DFs
NEI <- readRDS("./Data/summarySCC_PM25.rds")
SCC <- readRDS("./Data/Source_Classification_Code.rds")

#This plot will attempt to answer: Have total emissions from PM2.5 decreased in the United States 
#from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from 
#all sources for each of the years 1999, 2002, 2005, and 2008.

## Plot totals for year, to png file plot1.png
tons <- NEI %>%
    group_by(year) %>%
    summarise(tons=sum(Emissions))
png(filename="plot1.png")
plot(tons$year,tons$tons, pch=20, main = "Total Emissions By Year", xlab = "Year", ylab = "Emissions (tons)")
smoothingSpline = smooth.spline(tons$year, tons$tons, spar=.25)
lines(smoothingSpline)
dev.off()
