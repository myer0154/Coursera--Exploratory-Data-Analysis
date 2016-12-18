# check for the existence of the data file.  If not present, download and unzip.
if(!file.exists("household_power_consumption.txt")) {
   download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
   			  destfile = "HPCdata.zip")
   unzip("HPCdata.zip")
}

# read the file, as.is to prevent characters (i.e., the date and time columns) converting to factors
HPC <- read.table("household_power_consumption.txt", sep = ";", na.strings = "?", header=TRUE, as.is = TRUE)

# convert the Date column from charcater to date type, then subset out 2007-02-01 and 2007-02-02
HPC$Date <- as.Date(HPC$Date, format="%d/%m/%Y")
HPC <- subset(HPC, Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02"))

# create a png device, plot the data to it, and then close the device to save the image
png(filename = "plot1.png")
hist(HPC$Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kilowatts)", col = "red")
dev.off()