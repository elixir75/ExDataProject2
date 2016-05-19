setwd("~/Coursera/ExploratoryDataAnalysis/Project 2/")
library(dplyr)
library(ggplot2)
library(sqldf)

#Read external datasets
NEI <- readRDS("./Data/summarySCC_PM25.rds")
SCCDF <-readRDS("./Data/Source_Classification_Code.rds")

# Plot should answer question: Across the United States, how have emissions from 
# coal combustion-related sources changed from 1999-2008?

# Find coal combustion-related sources and subset
SCC_sub <- SCCDF %>% 
    filter(grepl("Coal|coal", Short.Name))

coal_src <- sqldf('select SCC from SCC_sub')

# Subset NEI for coal sources
NEI_coal <- sqldf('select * from NEI where SCC in coal_src')

# group by year and summarize total emissions
NEI_coal.by.year <- NEI_coal %>%
    group_by(year)%>%
    summarise(tons=sum(Emissions))

#Plot to external file
png("plot4.png")
ggplot(NEI_coal.by.year, aes(x=factor(year), y=tons)) +
    geom_bar(stat="identity") +
    xlab("year") +
    ylab(expression("total PM"[2.5]*" emissions (tons)")) +
    ggtitle("Nationwide Emissions From Coal Sources")
dev.off()

