#If the data files don't already exist, download and unzip them
if(!file.exists("./summarySCC_PM25.rds")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "./temp_data.zip")
  unzip("temp_data.zip")
  file.remove("./temp_data.zip")
}

# read the source files
pm25 <- readRDS("summarySCC_PM25.rds")

# aggregate the data using Emissions as a function of year and apply the sum() function
tot_emissions <- aggregate(Emissions ~ year, pm25, sum)

# create a new png device, plot the data, then close the device
png("plot1.png")
barplot(tot_emissions$Emissions, names.arg = tot_emissions$y, xlab = "Year", ylab = "Emission (tons)", main = "Total PM2.5 emission from all sources")
dev.off()