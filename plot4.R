#
# Project 1 - Reconstruct Plot 3 of two day household energy usage 
# 
# USAGE on command line:
#   Rscript plot3.R
#
# Note: Path to data and PNG files are hard-coded
# --------------------------------------------------------------------------------------------------
## Load libraries
library(lubridate) # For date manipulation
library(dplyr)     # For fixing the data sets

## Read file into a data frame
# Read CSV file; noting that the separator is a semi-colon and header are present
x<-read.csv2("/home/nsubrahm/data/household_power_consumption.txt",header=TRUE,sep=";",stringsAsFactors=FALSE)
# Get the data set into a data frame for manipulation with dplyr
hpc_raw<-tbl_df(x)

## Apply filters
# Filter off the rows whose values are not available. As mentioned in the project description, NA is denoted with ?
hpc_filtered<-filter(hpc_raw,Global_active_power!="?" & Global_reactive_power!="?" & Voltage!="?" & Global_intensity!="?" & Sub_metering_1!="?" & Sub_metering_2!="?" & Sub_metering_3!="?")
# Re-format the string data in data set into a Date object
hpc_mutated<-mutate(hpc_filtered,Date=dmy(Date))
# Then, get only those rows that correspond to 2007-02-01 and 2007-02-02
hpc_days<-filter(hpc_mutated,Date==ymd("2007-02-01") | Date==ymd("2007-02-02"))

# Create time-series with date and time columns
hpc_dateTime<-strptime(paste(hpc_days$Date,hpc_days$Time),format="%Y-%m-%d %H:%M:%S")
# Get global active power
hpc_gap<-as.numeric(hpc_days$Global_active_power)
# Get global reactive power
hpc_grap<-as.numeric(hpc_days$Global_reactive_power)
# Get voltage
hpc_volt<-as.numeric(hpc_days$Voltage)
# Get energy sub metering 1
hpc_sm1<-as.numeric(hpc_days$Sub_metering_1)
# Get energy sub metering 2
hpc_sm2<-as.numeric(hpc_days$Sub_metering_2)
# Get energy sub metering 3
hpc_sm3<-as.numeric(hpc_days$Sub_metering_3)
# Create a data frame for plotting
hpc<-data.frame(hpc_dateTime,hpc_gap,hpc_grap,hpc_volt,hpc_sm1,hpc_sm2,hpc_sm3)

## Begin plotting to a PNG file (Here, labels have been set to exactly what has been shown in the graphic.)
# Open a PNG device
png(filename="/home/nsubrahm/data/plot4.png")
#
par(mfrow=c(2,2))                                                                  # 2 x 2 matrix for fitting the four plots
#
plot(hpc_dateTime,hpc_gap,type="l",ylab="Global Active Power (kilowatts)",xlab="") # First plot - Global Active Power
#
plot(hpc_dateTime,hpc_volt,type="l",ylab="Voltage",xlab="datetime")                # Second plot - Voltage
#
with(hpc, {                                                                        # Third plot  - Energy sub metering
 plot(hpc_dateTime,hpc_sm1,type="l",col="black",ylab="Energy metering",xlab="")
 lines(hpc_dateTime,hpc_sm2,col="red")
 lines(hpc_dateTime,hpc_sm3,col="blue")
 legend("topright",col=c("black","red","blue"),legend=c("Sub metering 1","Sub metering 2","Sub metering 3"),lty=c(1,1,1))
})
#
plot(hpc_dateTime,hpc_grap,type="l",ylab="Global_reactive_power",xlab="datetime")  # Fourth plot - Global Reactive Power
# Turn off device
dev.off()