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

# reset par()
dev.off()

# The plot region stay squared shaped 
par(pty="s")

# Plot
plot(hpc$Index, hpc$Global_active_power, 
     type = "l", 
     xaxt = "none",
     xlab = "",
     ylab = "Global Active Power (kilowatts)")
# Annotate (there are 1440 values per day)
axis(1, at = c(0,1440,2880), labels = c("Thu","Fri","Sat") )

dev.copy(png, filename = "plot2.png", width = 480, height = 480)
dev.off()






