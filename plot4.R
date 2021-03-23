library(tibble)
library(dplyr)
library(lubridate)
library(readr)

# Download and unzip the files
file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists("./power_cons.zip")){
  download.file(file_url, "./power_cons.zip", method = "curl")
  unzip("power_cons.zip")
  }

# Read file
coltypes = list(col_date(format = "%d/%m/%Y"), col_time(), col_double(), col_double(), col_double(),
             col_double(), col_double(), col_double(), col_double() )
hpc <- read_delim(file = "household_power_consumption.txt", 
                  delim = ";",
                  na = "?",
                  col_types = coltypes)

# using data from the dates 2007-02-01 and 2007-02-02
hpc <- hpc %>% filter(Date == ymd("2007-02-01") | Date == ymd("2007-02-02"))

# Add index (to get the observations one after another on a timeline)
hpc <- hpc %>% mutate(Index = row_number())


# reset par
dev.off()
plot.new()
# dev.copy doesnt work well in this case so using png instead
png(filename = "plot4.png", width = 480, height = 480)

# The plot region stay squared shaped 
par(pty="s")
# Several plot on a 2-2 disposition with reduced margins
par(mfrow = c(2, 2), mar = c(4, 4, 2, 0), oma = c(0, 0, 2, 0))


# plot 1-1
plot(hpc$Index, hpc$Global_active_power, 
     type = "l", 
     xaxt = "none",
     xlab = "",
     ylab = "Global Active Power (kilowatts)")
# Annotate (there are 1440 values per day)
axis(1, at = c(0,1440,2880), labels = c("Thu","Fri","Sat") )

# plot 1-2
plot(hpc$Index, hpc$Voltage, 
     type = "l",
     xlab = "datetime",
     ylab = "Voltage",
     xaxt = "none")
axis(1, at = c(0,1440,2880), labels = c("Thu","Fri","Sat") )

# plot 2-1
plot(hpc$Index, hpc$Sub_metering_1,
     col  = "black",
     type = "l", 
     xaxt = "none",
     xlab = "",
     ylab = "Energy Sub Metering")
lines(hpc$Index, hpc$Sub_metering_2,
      col = "red",
      type = "l")
lines(hpc$Index, hpc$Sub_metering_3,
      col = "blue",
      type = "l")
# Annotate
legend("topright" ,
       bty = "n",
       lty = 1, 
       col = c("black", "blue","red"), 
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
axis(1, at = c(0,1440,2880), labels = c("Thu","Fri","Sat") )

# Plot 4-4
plot(hpc$Index, hpc$Global_reactive_power, 
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power",
     xaxt = "none")
axis(1, at = c(0,1440,2880), labels = c("Thu","Fri","Sat") )

#dev.copy(png, filename = "plot4.png", width = 480, height = 480)
dev.off()
