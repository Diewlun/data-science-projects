#set wd
setwd("C:/Users/dilli/AFI/Hypothesis Library/DCO")

#load libraries
library(car)
library(multcomp)

#read in data
in_market_version = read.csv("In Market Version Data.csv", header=TRUE, stringsAsFactors = FALSE)

#change cta to a factor and change the order
in_market_version$innovid_version_id = factor(in_market_version$innovid_version_id, levels=c("0", "37", "38", "39", "40", "41", "42", "43", "44", 
                                                                                             "45", "46", "47", "48", "49", "50", "51", "52", "53",
                                                                                             "54", "55", "56", "57", "58", "59", "60", "61", "62",
                                                                                             "63", "64", "65", "66", "67", "68", "69", "70", "71", "72"), ordered=TRUE)


#run ANCOVA
ancova_model = aov(clicks ~ innovid_version_id + impressions + spend, data = in_market_version)

Anova(ancova_model, type="III")

#post hoc testing
postHocs = glht(ancova_model, linfct = mcp(innovid_version_id = "Dunnett"))
summary(postHocs)

#run ANCOVA
ancova_model2 = aov(X3._lead._total_conversions ~ innovid_version_id + impressions + spend, data = in_market_version)

Anova(ancova_model2, type="III")

#post hoc testing
postHocs = glht(ancova_model2, linfct = mcp(innovid_version_id = "Dunnett"))
summary(postHocs)
