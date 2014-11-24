setwd("D:/HARI/university\ subjects/COMPUTER\ SCIENCE/Fun\ staf/Exploratory\ Data\ Analysis/Project\ 2")

#downloading
library(utils)
setInternet2(use = TRUE)
temp <- tempfile()    #temporary file "temp" is created
download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

unlink(temp)

#1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#Using the base plotting system, make a plot showing the total PM2.5 emission 
#from all sources for each of the years 1999, 2002, 2005, and 2008.
library("sqldf")
#base plot
Total_Emission_Grouped <- sqldf("select year,sum(Emissions) as TotalEmission
                       from NEI 
                       group by year")
with(Total_Emission_Grouped, plot(year,TotalEmission))
#The amount has decreased


#2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 
#Use the base plotting system to make a plot answering this question.
Total_Emission_Baltimore <- sqldf("select year,sum(Emissions) as TotalEmission
                       from NEI 
                       where fips == 24510
                       group by year")
with(Total_Emission_Baltimore, plot(year,TotalEmission))
#The amount in overall has decreased with some fluxuations.



#3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
#which of these four sources have seen decreases in emissions from 1999-2008 
#for Baltimore City? Which have seen increases in emissions from 1999-2008? 
#Use the ggplot2 plotting system to make a plot answer this question.
library("ggplot2")
Total_Emission_Baltimore <- sqldf("select year,type,sum(Emissions) as TotalEmission
                       from NEI 
                       where fips == 24510
                       group by year,type")
qplot(year,TotalEmission, data= Total_Emission_Baltimore,color=type)


#4. Across the United States, how have emissions from coal combustion-related 
#sources changed from 1999-2008?
Total_Emission_Coal <- sqldf("select year,SCC as num_name,sum(Emissions) as TotalEmission
                       from NEI 
                       where num_name in SCC$
                       group by year")

with(Total_Emission_Coal, plot(year,TotalEmission))
