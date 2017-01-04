#If the data files don't already exist, download and unzip them
if(!file.exists("./summarySCC_PM25.rds")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "./temp_data.zip")
  unzip("temp_data.zip")
  file.remove("./temp_data.zip")
}

# read the source files (if pm25 object does not already exist)
if(!exists("pm25")) {
  pm25 <- readRDS("summarySCC_PM25.rds")
}

# aggregate the data from Baltimore (fips 24510) using Emissions as a function of year and apply the sum() function
balt_emissions <- aggregate(Emissions ~ year, pm25[pm25$fips == "24510",], sum)

# create a new png device, plot the data, then close the device
png("plot2.png")
barplot(balt_emissions$Emissions, names.arg = balt_emissions$y, xlab = "Year", ylab = "PM25 emission (tons)", main = "Total PM2.5 emission in Baltimore, MD (all sources)")
dev.off()