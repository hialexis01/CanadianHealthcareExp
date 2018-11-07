#install.packages("readxl")
#install.packages("timeSeries")
#install.packages("readxl")
#install.packages("xlsx")
#install.packages("tidyverse")
library(readxl)
library(timeSeries)
library(ggplot2)
library(dplyr)
library(reshape2)
library(tidyverse)

#Total Expenditure; This is the data sent from Trevor
CPIHealthcare <- read.xlsx("._CPI private health care index - monthly nsa.xlsx", sheetIndex = 1)
Physiciandata <- read.csv("Physician workforce SMDB Historical Dataa.csv")

projectdata <- read_excel("project731.xlsx")
attach(projectdata)

projectdata <- melt(projectdata, 'Year')
names(projectdata) <- c('Year', 'Province', 'Total Expenditure')
ggplot(projectdata, aes(x= Year., y = value, colour= variable))+geom_line()

write.csv(projectdata, "Public Total Expenditure.csv")

#Function to read all data sheets
read_excel_allsheets <- function(filename, tibble = FALSE) {
  sheets <- readxl::excel_sheets(filename)
  x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
  if(!tibble) x <- lapply(x, as.data.frame)
  names(x) <- sheets
  x
}
#Cleaning data for private expendiutre
SeriesD2.sheets <- read_excel_allsheets("Series D2-nhex2017-en.xlsx", tibble =  FALSE)

Provincesname <- c("N.L.", "P.E.I.", "N.S.", "Que.", "Ont.", "Man.", "Sask.", "Alta.", "B.C.", "Y.T.", "N.W.T.", "Nun.")
FullnameProvince <- c("Newfoundland and Labrador", "Prince Edward Island", "Nova Scotia", "Quebec", "Ontario", "Manitoba", "Saskatchewan", "Alberta", "British Columbia", "Yukon", "Northwest Territories", "Nunavut")

`Newfoundland and Labrador`$Province <- FullnameProvince[1]
`Prince Edward Island`$Province <- FullnameProvince[2]
`Nova Scotia`$Province <- FullnameProvince[3]
Quebec$Province <- FullnameProvince[4]
Ontario$Province <- FullnameProvince[5]
Manitoba$Province <- FullnameProvince[6]
Saskatchewan$Province <- FullnameProvince[7]
Alberta$Province <- FullnameProvince[8]
`British Columbia`$Province <- FullnameProvince[9]
Yukon$Province <- FullnameProvince[10]
`Northwest Territories`$Province <- FullnameProvince[11]
Nunavut$Province <- FullnameProvince[12]

variablenames <- names(Manitoba)

PrivateHealthExpenditure <- list(`Newfoundland and Labrador`, `Prince Edward Island`, `Nova Scotia`, Quebec, Ontario, Manitoba, Saskatchewan, Alberta, `British Columbia`, Yukon, `Northwest Territories`, Nunavut) %>% reduce(full_join, by= variablenames)
PrivateHealthExpenditure <- PrivateHealthExpenditure[,c(1,12, 2:11)]

attach(PrivateHealthExpenditure)

write.csv(PrivateHealthExpenditure, "Private Health Expenditure.csv")
