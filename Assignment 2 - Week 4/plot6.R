# load ggplot2
library(ggplot2)

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

# Subset the SCC codes that belong to vehicle emissions by regex against the EI.Sector column and filter pm25 by SCC code
# then aggregate and sum Emissions by year for each fips value (Baltimore 24510 or LA 06037)
vehicleSCC <- SCC[grep("vehicle", SCC$EI.Sector, ignore.case = TRUE), ]
veh_emissions <- pm25[pm25$SCC %in% vehicleSCC$SCC, ]
balt_emissions <- aggregate(Emissions ~ year, veh_emissions[veh_emissions$fips == "24510", ], sum)
LA_emissions <- aggregate(Emissions ~ year, veh_emissions[veh_emissions$fips == "06037", ], sum)
balt_emissions$city <- "Baltimore City, MD"
LA_emissions$city <- "Los Angeles County, CA"
both <- rbind(balt_emissions, LA_emissions)

# create a new png device, plot the data, then close the device
png("plot6.png")
q <- qplot(year, Emissions, data = both, color = city, geom = "line",
           xlab = "Year", ylab = "PM25 Emission (tons)", main = "Vehicle emission in Baltimore, MD and Los Angeles, CA")
q <- q + geom_point()
print(q)
dev.off()