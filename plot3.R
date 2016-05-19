setwd("~/Coursera/ExploratoryDataAnalysis/Project 2/")
library(dplyr)
library(ggplot2)

#Read external to DFs
NEI <- readRDS("./Data/summarySCC_PM25.rds")
SCC <- readRDS("./Data/Source_Classification_Code.rds")

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? 
# Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make 
# a plot answer this question.




## Plot totals by year for Baltimore subset, to png file plot3.png, Showing panels by type

bmore <- NEI %>%
    filter(NEI$fips== "24510") 

# Group data by year and type of the source
bmore <- aggregate(Emissions ~ year + type,
                                  data=bmore,
                                  FUN=sum)
#plot bar graphs: for each type of emission, show yearly totals
png(filename="plot3.png")
ggplot(bmore, aes(x=factor(year), y=Emissions, fill=type)) +
    geom_bar(stat="identity") +
    facet_grid(. ~ type) +
    xlab("year") +
    ylab(expression("total PM"[2.5]*" emission (tons)")) +
    ggtitle(expression("PM"[2.5]*paste(" emissions in Baltimore ",
                                       "City by various source types", sep="")))
dev.off()


