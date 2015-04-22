# SamsungTidyData
# Script for tidying up Samsung accelerometer data from UCI

# **_R code to pull my tidy data file_**

address <- "http://github.com/mlwenocur/SamsungTidyData/blob/master/tidiedSamsungData.csv"
data <- read.table(url(address), header = TRUE) 
View(data)
