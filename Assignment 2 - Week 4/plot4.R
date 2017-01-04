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
if(!exists("SCC")) {
  SCC <- readRDS("Source_Classification_Code.rds")
}

# Subset the SCC codes that belong to coal combustion by using a regex in the EI.Sector column
# then aggregate Emissions by year and sum, as in previous plots
coalSCC <- SCC[grep("coal", SCC$EI.Sector, ignore.case = TRUE), ]
coal_emissions <- aggregate(Emissions ~ year, pm25[pm25$SCC %in% coalSCC$SCC, ], sum)

# create a new png device, plot the data, then close the device
png("plot4.png")
barplot(coal_emissions$Emissions, names.arg = coal_emissions$year, xlab = "Year", ylab = "PM25 emission (tons)", main = "Total PM2.5 emission from coal combustion sources")
dev.off()