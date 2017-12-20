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
aggData <- aggregate(BaltimoreData[, "Emissions"], by=list(BaltimoreData$year), FUN=sum)
colnames(aggData) <- c("year", "emissions")


## plotting
png('plot2.png')
barplot(height=aggData$emissions, names.arg=aggData$year, xlab="Year", ylab="PM2.5 Emissions", main="PM2.5 Emissions in Baltimore City over the years")
dev.off()