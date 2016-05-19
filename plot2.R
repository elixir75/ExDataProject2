setwd("~/Coursera/ExploratoryDataAnalysis/Project 2/")
library(dplyr)

#Read external to DFs
NEI <- readRDS("./Data/summarySCC_PM25.rds")
SCC <- readRDS("./Data/Source_Classification_Code.rds")

# This plot will attempt to answer question: Have total emissions from PM2.5 decreased in the 
# Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to 
# make a plot answering this question.

## Plot totals by year for Baltimore subset, to png file plot2.png
tons <- NEI %>%
    filter(NEI$fips== "24510") %>%
    group_by(year) %>%
    summarise(tons=sum(Emissions))
png(filename="plot2.png")
plot(tons$year,tons$tons, pch=20, main = "Baltimore, MD - Total Emissions By Year", xlab = "Year", ylab = "Emissions (tons)")
smoothingSpline = smooth.spline(tons$year, tons$tons, spar=.25)
lines(smoothingSpline)
dev.off()
