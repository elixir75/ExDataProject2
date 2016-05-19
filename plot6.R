setwd("~/Coursera/ExploratoryDataAnalysis/Project 2/")
library(dplyr)
library(ggplot2)
library(sqldf)
library(data.table)

#Compare emissions from motor vehicle sources in Baltimore City with emissions 
#from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
#Which city has seen greater changes over time in motor vehicle emissions?


#Read external datasets
NEI <- readRDS("./Data/summarySCC_PM25.rds")
SCCD <-readRDS("./Data/Source_Classification_Code.rds")


#Subset NEI, Grabbing the 4 needed columns, and the records for specified cities
NEI_bmore <- NEI %>% 
    select(fips, SCC,Emissions,year) %>%
    filter(grepl("24510",fips))

NEI_la <- NEI %>% 
    select(fips, SCC,Emissions,year) %>%
    filter(grepl("06037",fips))



#Subset SCCD, retaining just the SCC Codes related to Motor Vehicle Emissions
SCCDF <- data.table(SCCD)[EI.Sector %like% "Vehicle"]
mv_scc_codes <- sqldf('select SCC from SCCDF')



# Subset both cities for motor vehicle sources
NEI_Bmv <- sqldf('select Emissions, year from NEI_bmore where SCC in mv_scc_codes')
NEI_LAmv <- sqldf('select Emissions, year from NEI_la where SCC in mv_scc_codes')


BM <- NEI_mv %>%
    group_by(year) %>%
    summarise(tons=sum(Emissions)) %>%
    mutate(City="Baltimore")
LA <- NEI_la %>%
    group_by(year) %>%
    summarise(tons=sum(Emissions)) %>%
    mutate(City="LA")
# Combine LA and Baltimore Summaries (tons per year)
combined <- rbind(BM, LA)



# plot 
png("plot6.png")
ggplot(combined, aes(x=year, y=tons, fill=City)) +
    geom_bar(stat="identity") + 
    facet_grid(City ~ ., scales="free") +
    xlab("Year") +
    ylab(expression("Total PM"[2.5]*" emissions (tons)")) +
    ggtitle(expression("Motor Vehicle Emission Comparison:\nBaltimore vs Los Angeles"))
dev.off()
