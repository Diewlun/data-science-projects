#install and load necessary packages
install.packages("sqldf")
install.packages("stringr")
library(sqldf)
library(stringr)

setwd("C:/Users/dli89/QQ Studio Data Analytics Work/Base Stock Analysis/Base Stock Rehaul")

#read in data
df = read.csv("Base Stock Analysis Rehaul Raw Data January 2025.csv", header=TRUE, check.names=FALSE, stringsAsFactors = FALSE)

#impute NA values with 0
df[is.na(df)] = 0

#calculations
df$TotalDemand = rowSums(df[, 5:length(df)])
df$MeanDailyDemand = df$TotalDemand/(ncol(df) - 5)
df$SDMeanDailyDemand = apply(df[, 5:(length(df)-2)], 1, sd)
#Combo$SDMeanDailyDemand[is.na(Combo$SDMeanDailyDemand)] = 0
df$AvgLeadTime = 117
df$SDLeadTime = 31
df$ReviewPeriod = 50
df$MeanDemandOverLTRP = df$MeanDailyDemand *(df$ReviewPeriod + df$AvgLeadTime)
df$SDMeanDemandOverLTRP = sqrt((df$ReviewPeriod + df$AvgLeadTime) * (df$SDMeanDailyDemand^2) + (df$MeanDailyDemand^2) * (df$SDLeadTime^2))
df$SafetyStock = 1.282 * df$SDMeanDemandOverLTRP #80% confidence interval
df$BaseStock = ((df$ReviewPeriod + df$AvgLeadTime) * df$MeanDailyDemand) + df$SafetyStock

#change product dimensions to numeric
df$length_cm = as.numeric(df$length_cm)
df$width_cm = as.numeric(df$width_cm)
df$height_cm = as.numeric(df$height_cm)

df$CubicMeter = (df$length_cm * df$width_cm * df$height_cm) /(100*100*100)

write.csv(df, "Base Stock Analysis Rehaul Edition February 2025.csv", row.names=FALSE)
