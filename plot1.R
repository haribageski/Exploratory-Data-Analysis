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
#where 24510 is the code for Baltimore City
qplot(year,TotalEmission, data= Total_Emission_Baltimore,color=type)


#4. Across the United States, how have emissions from coal combustion-related 
#sources changed from 1999-2008?
colnames(SCC)[4]<- "Sector" #the initial name EI.Sector produces error in SQL
SCC_COAL_COMBUST_RELATED <- sqldf("select SCC from SCC 
                                  where Sector like '%Coal%'
                                  and Sector like '%Comb%'")

Total_Emission_Coal <- sqldf("select year,sum(Emissions) as TotalEmission
                            from NEI 
                            where SCC in SCC_COAL_COMBUST_RELATED
                            group by year")
qplot(year,TotalEmission, data= Total_Emission_Coal)
#We can see a drastic decrease from 2005 to 2008


#5. How have emissions from motor vehicle sources changed from 1999-2008
#in Baltimore City?
SCC_motor_vhc <- sqldf("select SCC from SCC 
                                  where Sector like '%Vehicle%'")

Total_Emission_Vehic_Balt <- sqldf("select year,sum(Emissions) as TotalEmission
                            from NEI 
                            where SCC in SCC_motor_vhc
                            and fips == '24510'
                            group by year")
qplot(year,TotalEmission, data= Total_Emission_Vehic_Balt)
#The graph shows biggest decrease in 1999 and decrease in overall


#Compare emissions from motor vehicle sources in Baltimore City with 
#emissions from motor vehicle sources in Los Angeles County, 
#California (fips == "06037"). Which city has seen greater changes over time 
#in motor vehicle emissions?

j<-2:4
    Emission_change_Baltimore = -Total_Emission_Vehic_Balt[j-1,]$TotalEmission+
      Total_Emission_Vehic_Balt[j,]$TotalEmission

Emission_change_Baltimore=sum(Emission_change_Baltimore)
Emission_change_Baltimore
#That is the emition decrease for Baltimore.


#We do the same for LA (fips == "06037")
Total_Emission_Vehic_LA <- sqldf("select year,sum(Emissions) as TotalEmission
                            from NEI 
                            where  fips == '06037'
                            and SCC in SCC_motor_vhc
                            group by year")


Emission_change_LA = -Total_Emission_Vehic_LA[j-1,]$TotalEmission + 
  Total_Emission_Vehic_LA[j,]$TotalEmission

Emission_change_LA=sum(Emission_change_LA)
Emission_change_LA
#We get that there is an incease in overall emission in LA.
