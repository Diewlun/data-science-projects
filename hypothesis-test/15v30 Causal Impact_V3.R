#set wd
setwd("C:/Users/dilli/OneDrive - Publicis Groupe/Desktop/Onboarding/AFTG/American Family/2022 Testing/Local TV 15s vs. 30s")

#load library
library(CausalImpact)
library(readxl)
library(lubridate)
library(ggplot2)

org_visits= read_excel("Causal Impact Raw_V2.xlsx", sheet="Organic Test Visits")

#convert dates
org_visits$Date = as.Date(org_visits$Date, origin = "1899-12-30")

#define intervention periods
pre = as.Date(c("2022-01-03", "2022-03-28"))
post = as.Date(c("2022-04-04", '2022-06-13'))

impact1 = CausalImpact(zoo(org_visits[, -1], org_visits$Date), pre, post)

#store causal impact prediction series in dataframe
impact1_preds = as.data.frame(impact1[[1]])

#plot the results for organic test
png("Organic Visits Causal Impact.png", width = 1500, height = 700)
plot(impact1, c("original")) +
  labs(
    x="Time",
    y="Adobe Visits",
    title="Analysis Of Observed Organic Visits vs. Predicted Visits Without Intervention (Test)") +
  theme(plot.title=element_text(hjust = 0.5, size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12)) +
  ylim(0, 150000)

dev.off()

#show summary (stat sig p-value = 0.019, 25% lift, 150,160 cumulative additional visits as a result of intervention)
summary(impact1, "report")


#paid search visits
paid_visits = read_excel("Causal Impact Raw_V2.xlsx", sheet="Paid Search Test Visits")
paid_visits$Date = as.Date(paid_visits$Date, origin = "1899-12-30")

impact2 = CausalImpact(zoo(paid_visits[, -1], paid_visits$Date), pre, post)

png("Paid Search Visits Causal Impact.png", width = 1500, height = 700)
plot(impact2, c("original")) +
  labs(
    x="Time",
    y="Adobe Visits",
    title="Analysis Of Observed Paid Search Visits vs. Predicted Visits Without Intervention (Test)") +
  theme(plot.title=element_text(hjust = 0.5, size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12))

dev.off()

# stat sig, 9% lift, 2280 visit cumulative increase, p-value = 0.001
summary(impact2, "report")
(142.82-141.75)/141.75 #0.7% lift

#organic leads
org_leads = read_excel("Causal Impact Raw_V2.xlsx", sheet="Organic Test Leads")

#convert dates
org_leads$Date = as.Date(org_leads$Date, origin = "1899-12-30")

impact3 = CausalImpact(zoo(org_leads[, -1], org_leads$Date), pre, post)

png("Organic Leads Causal Impact.png", width = 1500, height = 700)
plot(impact3, c("original")) +
  labs(
    x="Time",
    y="Adobe Leads",
    title="Analysis Of Observed Organic Leads vs. Predicted Leads Without Intervention (Test)") +
  theme(plot.title=element_text(hjust = 0.5, size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12))

dev.off()

#stat sig, 14% lift, 8.5k cumulative increase in visits, p-value = 0.004
summary(impact3, "report")

plot(impact4$model$bsts.model, "coefficients")

#lift %
(6.20-5.36)/5.36 #15.67%

#paid search leads
paid_search_leads = read_excel("Causal Impact Raw_V2.xlsx", sheet="Paid Search Test Leads")

#convert dates
paid_search_leads$Date = as.Date(paid_search_leads$Date, origin = "1899-12-30")

impact4 = CausalImpact(zoo(paid_search_leads[, -1], paid_search_leads$Date), pre, post)

png("Paid Search Leads Causal Impact.png", width = 1500, height = 700)
plot(impact4, c("original")) +
  labs(
    x="Time",
    y="Adobe Leads",
    title="Analysis Of Observed Paid Search Leads vs. Predicted Leads Without Intervention (Test)") +
  theme(plot.title=element_text(hjust = 0.5, size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12))

dev.off()

#stat sig, 16% lift, 330 cumulative lead increase, p-value = 0.003
summary(impact4, "report")

org_t1_visits = read_excel("Causal Impact Raw_V2.xlsx", sheet="Organic T1 Test Visits")

#convert dates
org_t1_visits$Date = as.Date(org_t1_visits$Date, origin = "1899-12-30")

impact5 = CausalImpact(zoo(org_t1_visits[, -1], org_t1_visits$Date), pre, post)

#stat sig, 16% lift, 330 cumulative lead increase, p-value = 0.003
summary(impact5, "report")

org_t2_visits = read_excel("Causal Impact Raw_V2.xlsx", sheet="Organic T2 Test Visits")

#convert dates
org_t2_visits$Date = as.Date(org_t2_visits$Date, origin = "1899-12-30")

impact6 = CausalImpact(zoo(org_t2_visits[, -1], org_t2_visits$Date), pre, post)

#stat sig, 16% lift, 330 cumulative lead increase, p-value = 0.003
summary(impact6, "report")

org_t3_visits = read_excel("Causal Impact Raw_V2.xlsx", sheet="Organic T3 Test Visits")

#convert dates
org_t3_visits$Date = as.Date(org_t3_visits$Date, origin = "1899-12-30")

impact7 = CausalImpact(zoo(org_t3_visits[, -1], org_t3_visits$Date), pre, post)

#stat sig, 16% lift, 330 cumulative lead increase, p-value = 0.003
summary(impact7, "report")

search_t1_visits = read_excel("Causal Impact Raw_V2.xlsx", sheet="Paid Search T1 Test Visits")

#convert dates
search_t1_visits$Date = as.Date(search_t1_visits$Date, origin = "1899-12-30")

impact8 = CausalImpact(zoo(search_t1_visits[, -1], search_t1_visits$Date), pre, post)

#stat sig, 16% lift, 330 cumulative lead increase, p-value = 0.003
summary(impact8, "report")

search_t2_visits = read_excel("Causal Impact Raw_V2.xlsx", sheet="Paid Search T2 Test Visits")

#convert dates
search_t2_visits$Date = as.Date(search_t2_visits$Date, origin = "1899-12-30")

impact9 = CausalImpact(zoo(search_t2_visits[, -1], search_t2_visits$Date), pre, post)

#stat sig, 16% lift, 330 cumulative lead increase, p-value = 0.003
summary(impact9, "report")

search_t3_visits = read_excel("Causal Impact Raw_V2.xlsx", sheet="Paid Search T3 Test Visits")

#convert dates
search_t3_visits$Date = as.Date(search_t3_visits$Date, origin = "1899-12-30")

impact10 = CausalImpact(zoo(search_t3_visits[, -1], search_t3_visits$Date), pre, post)

#stat sig, 16% lift, 330 cumulative lead increase, p-value = 0.003
summary(impact10, "report")

search_t1_leads = read_excel("Causal Impact Raw_V2.xlsx", sheet="Paid Search T1 Test Leads")

#convert dates
search_t1_leads$Date = as.Date(search_t1_leads$Date, origin = "1899-12-30")

impact11 = CausalImpact(zoo(search_t1_leads[, -1], search_t1_leads$Date), pre, post)

#stat sig, 16% lift, 330 cumulative lead increase, p-value = 0.003
summary(impact11, "report")

search_t2_leads = read_excel("Causal Impact Raw_V2.xlsx", sheet="Paid Search T2 Test Leads")

#convert dates
search_t2_leads$Date = as.Date(search_t2_leads$Date, origin = "1899-12-30")

impact12 = CausalImpact(zoo(search_t2_leads[, -1], search_t2_leads$Date), pre, post)

#stat sig, 16% lift, 330 cumulative lead increase, p-value = 0.003
summary(impact12, "report")

search_t3_leads = read_excel("Causal Impact Raw_V2.xlsx", sheet="Paid Search T3 Test Leads")

#convert dates
search_t3_leads$Date = as.Date(search_t3_leads$Date, origin = "1899-12-30")

impact13 = CausalImpact(zoo(search_t3_leads[, -1], search_t3_leads$Date), pre, post)

#stat sig, 16% lift, 330 cumulative lead increase, p-value = 0.003
summary(impact13, "report")
