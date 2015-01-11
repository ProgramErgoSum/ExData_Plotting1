#
# Project 1 - Reconstruct Plot 1 of two day household energy usage 
# 
# USAGE on command line:
#   Rscript plot1.R
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

# Finally, get global active power for plotting
hpc<-mutate(hpc_days,Global_active_power=as.numeric(Global_active_power))

## Begin plotting to a PNG file
# Open a PNG device
png(filename="/home/nsubrahm/data/plot1.png")
# Create the histogram for the Global active power
hist(hpc$Global_active_power, col="red", main=c("Global Active Power"), xlab="Global Active Power (kilowatts)")
# Turn off the device.
dev.off()
