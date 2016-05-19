setwd("~/Coursera/ExploratoryDataAnalysis/Project 2/")
library(dplyr)
library(ggplot2)
library(sqldf)
library(data.table)


# Plot should answer question: How have emissions from motor vehicle sources changed 
#from 1999-2008 in Baltimore City?


#Read external datasets
NEI <- readRDS("./Data/summarySCC_PM25.rds")
SCCD <-readRDS("./Data/Source_Classification_Code.rds")



#Subset NEI, Grabbing the 4 needed columns, and the records where Baltimore criteria is met
NEI_bmore <- NEI %>% 
    select(fips, SCC,Emissions,year) %>%
    filter(grepl("24510",fips))



#Subset SCCD, retaining just the SCC Codes related to Motor Vehicle Emissions
SCCDF <- data.table(SCCD)[EI.Sector %like% "Vehicle"]
mv_scc_codes <- sqldf('select SCC from SCCDF')



# Subset NEI_bmore for motor vehicle sources
NEI_mv <- sqldf('select Emissions, year from NEI_bmore where SCC in mv_scc_codes')



## Plot totals by year for Baltimore subset, to png file plot5.png
    pl5 <- NEI_mv %>%
    group_by(year) %>%
    summarise(tons=sum(Emissions))

png("plot5.png")
ggplot(pl5, aes(x=factor(year), y=tons)) +
    geom_bar(stat="identity") +
    xlab("year") +
    ylab(expression("total PM"[2.5]*" emissions (tons)")) +
    ggtitle("Baltimore Emissions From Motor Vehicle Sources")
dev.off()


    