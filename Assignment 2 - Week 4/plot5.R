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

# Subset the SCC codes that belong to vehicle emissions by regex against the EI.Sector column
# then filter pm25 by SCC code and Baltimore fips value, and aggregate and sum resulting Emissions by year
vehicleSCC <- SCC[grep("vehicle", SCC$EI.Sector, ignore.case = TRUE), ]
veh_emissions <- pm25[pm25$fips == "24510" & pm25$SCC %in% vehicleSCC$SCC, ]
veh_emissions <- aggregate(Emissions ~ year, veh_emissions, sum)

# create a new png device, plot the data, then close the device
png("plot5.png")
barplot(veh_emissions$Emissions, names.arg = veh_emissions$year, xlab = "Year", ylab = "PM25 emission (tons)", main = "Total PM2.5 emission from vehicle sources in Baltimore, MD")
dev.off()