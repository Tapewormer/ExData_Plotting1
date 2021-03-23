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

# Reset par()
dev.off()
hist(hpc$Global_active_power, 
     col  = "red", 
     xlab = "Global Active Power (kilowatts)", 
     main = "Global Active power")

dev.copy(png, filename = "plot1.png", width = 480, height = 480)
dev.off()












