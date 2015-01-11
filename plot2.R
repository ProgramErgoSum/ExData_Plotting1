#
# Project 1 - Reconstruct Plot 2 of two day household energy usage 
# 
# USAGE on command line:
#   Rscript plot2.R
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
# Finally, get global active power for plotting
hpc_gap<-as.numeric(hpc_days$Global_active_power)
# Create a data frame for plotting
hpc<-data.frame(hpc_dateTime,hpc_gap)

## Begin plotting to a PNG file
# Open a PNG device
png(filename="/home/nsubrahm/data/plot2.png")
# Create the plot
plot(hpc,type="l",ylab="Global Active Power (kilowatts)",xlab="")
# Turn off the device
dev.off()