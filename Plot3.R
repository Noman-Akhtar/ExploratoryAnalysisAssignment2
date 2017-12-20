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

## subsetting for Baltimore City (fips = 24510)
BaltimoreData <- subset(NEI, NEI$fips=="24510")

## aggregating data for all years
aggData <- aggregate(BaltimoreData[, c("Emissions")], by=list(BaltimoreData$year, BaltimoreData$type), FUN=sum)
colnames(aggData) <- c("year", "type", "emissions")

## plotting
png("plot3.png", width=800, height=480)
g <- ggplot(data = aggData, aes(x = as.character(year), y = emissions)) + facet_grid((. ~ type)) +
        geom_bar(stat="identity", aes(fill=type)) +
        xlab("year") + ylab("PM2.5 Emissions") + ggtitle("PM2.5 Emissions in Baltimore City")
print(g)
dev.off()