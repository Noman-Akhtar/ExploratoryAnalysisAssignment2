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


## Aggregating data for all years
aggData <- aggregate(NEI[, "Emissions"], by=list(NEI$year), FUN=sum)
colnames(aggData) <- c("year", "emissions")


## plotting
png('plot1.png')
barplot(height=aggData$emissions, names.arg=aggData$year, xlab="Year", ylab="PM2.5 Emissions", main="PM2.5 Emissions over the years")
dev.off()