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

# load ggplot2
library(ggplot2)

# Subset the Baltimore (fips 24510) data, aggregate using Emissions by year + type, and apply the sum() function
balt_emissions <- aggregate(Emissions ~ year+type, pm25[pm25$fips == "24510",], sum)

# create a new png device, plot the data, then close the device
png("plot3.png")
q <- qplot(year, Emissions, data = balt_emissions, color = type, geom = "line", xlab = "Year", ylab = "Emission (tons)", 
      main = "Total emission in Baltimore, MD by year and emission source")
print(q)
dev.off()