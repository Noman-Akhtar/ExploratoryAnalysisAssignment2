library(ggplot2)

filezip <- "data.zip"
filename1 <- "summarySCC_PM25.rds"
filename2 <- "Source_Classification_Code.rds"

if (!file.exists(filename1) & !file.exists(filename2)){
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(fileUrl, filezip, method="libcurl")
        unzip(filezip) 
}


## reading data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


## subsetting for Baltimore City (fips = 24510) and Los Angeles Country (fips="06037")
BaltLAData <- subset(NEI, NEI$fips=="24510" | NEI$fips=="06037")


## subsetting from Baltimore Data and Los Angeles Country Data for "ON-ROAD" type
OnroadData <- subset(BaltLAData, BaltLAData$type=="ON-ROAD")


## aggregating data for all years for Baltimore and Los Angeles
aggData <- aggregate(OnroadData[, "Emissions"], by=list(OnroadData$year, OnroadData$fips), FUN=sum)
colnames(aggData) <- c("year", "county", "emissions")
aggData[c(1:4),2] <- "Los Angeles"
aggData[c(5:8),2] <- "Baltimore"


##plotting
png("plot6.png", width=800, height=480)
g <- ggplot(data = aggData, aes(x = as.character(year), y = emissions)) + facet_grid((. ~ county)) +
        geom_bar(stat="identity", aes(fill=county)) +
        xlab("year") + ylab("PM2.5 Emissions") + ggtitle("PM2.5 Emissions in Baltimore and Los Angeles")
print(g)
dev.off()