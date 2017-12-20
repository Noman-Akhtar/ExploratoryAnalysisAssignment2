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


## SSC with rows containing "coal sources"
coalSourcesSCC <- SCC[grepl("coal", SCC$Short.Name, ignore.case=TRUE),]


## merging SCC with NEI
mergeData <- merge(NEI, coalSourcesSCC, by="SCC")


## aggregating data for all years
aggData <- aggregate(mergeData[, "Emissions"], by=list(mergeData$year), FUN=sum)
colnames(aggData) <- c("year", "emissions")


## plotting
png('plot4.png')
barplot(height=aggData$emissions, names.arg=aggData$year, xlab="Year", ylab="PM2.5 Emissions", main="PM2.5 Emissions over the years from Coal Sources")
dev.off()