# check for the existence of the data file.  If not present, download and unzip.
if(!file.exists("household_power_consumption.txt")) {
	download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
				  destfile = "HPCdata.zip")
	unzip("HPCdata.zip")
}

# read the file, as.is to prevent characters (i.e., the date and time columns) converting to factors
HPC <- read.table("household_power_consumption.txt", sep = ";", na.strings = "?", header=TRUE, as.is = TRUE)

# combine Date and Time columns into a posix time variable in Time, then drop "Date" 
# and subset 2007-02-01 and 2007-02-02
HPC$Time <- strptime(paste(HPC$Date, HPC$Time), format = "%d/%m/%Y %X")
HPC <- subset(HPC[-1], as.Date(Time) == as.Date("2007-02-01") | as.Date(Time) == as.Date("2007-02-02"))

# create a png device, plot the data to it, and then close the device to save the image
png(filename = "plot3.png", width = 480, height = 480, units = "px")
plot(HPC$Time, HPC$Sub_metering_1, type = "l", col="black", ylab = "Energy sub metering", xlab = "")
lines(HPC$Time, HPC$Sub_metering_2, col = "red")
lines(HPC$Time, HPC$Sub_metering_3, col = "blue")
legend("topright", lty = c(1, 1, 1), col = c("black", "red", "blue"), 
	   legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()