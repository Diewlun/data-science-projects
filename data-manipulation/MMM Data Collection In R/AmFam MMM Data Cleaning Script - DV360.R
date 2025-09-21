##### Read in libraries and clean main data set #####
library(tidyverse)
library(dplyr)
library(lubridate)
library(stringr)
library(qdapRegex)
library(stringi)
library(readxl)
setwd("C:/Users/dilli/AFI/Hypothesis Library/2024/MMM Creative Data Backfill/Mark") #change wd to wherever you saved the files
dcm <- read_csv("DCM Creative Backfill 10.1.23-12.31.23.csv",skip=10)
dv360 <- read_csv("DV360 New Test.csv")

# Remove unnecessary rows
dcm <- head(dcm,-1)
dv360 <- head(dv360,-18)

# Change format of Date columns to Date
dcm$Date <- as.Date(dcm$Date, "%Y-%m-%d")
dv360$Date <- as.Date(dv360$Date, "%Y/%m/%d")

# # Account for "Unknown" creatives in DV360 file
# yt_ids <- read_csv("Youtube DCM Placement IDs Mapping To Unknown In DV360 Raw Data.csv")
# yt_ids$Placement_ID <- as.character(yt_ids$Placement_ID)
# ### Merge with slim DCM file to get Placement name
# dcm_yt_join <- dcm[,c(4,5)]
# dcm_yt_join <- dcm_yt_join %>% group_by(Placement) %>% unique()
# yt_ids_w_name <- merge(yt_ids,dcm_yt_join,by.x="Placement_ID",by.y="Placement ID")
# ### Merge with DV360 on Placement name to get correct CM360 Placement ID
# #dv360 <- merge(dv360,yt_ids_w_name,by.x="Line Item",by.y="Placement",all.x=TRUE)

# Drop rows with "Unknown" creatives from DV360 file
dv360 <- subset(dv360,!Creative == 'Unknown')

# Roll up DV360 data at level for merging with DCM
dv360_grouped <- dv360 %>% 
  group_by(Date,`DMA Name`,`CM360 Placement ID`) %>%
  summarize(DV360_Platform_Cost = sum(`Total Media Cost (Advertiser Currency)`))
dv360_grouped <- as.data.frame(dv360_grouped)

# Slim down data sets to necessary columns
AmFAMDCMFiltered2 <- dcm %>%
  select(`Date`,Campaign,Placement,`Placement ID`,Ad,`Site (CM360)`,Creative,`Designated Market Area (DMA)`,Impressions,Clicks,`Media Cost`,`DV360 Cost USD`)

# Load in mapping file,change DV360 DMAs to match with DCM, and slim down to only needed columns
dma_map <- read_csv("DCM DV360 DMA Mapping.csv")
dv360_grouped <- dv360_grouped %>% filter(!str_detect(dv360_grouped$`DMA Name`,"Japan"))
dv360_grouped <- merge(dv360_grouped,dma_map,by.x="DMA Name",by.y="DV360_DMA")
dv360_grouped <- dv360_grouped[,c(2:4,6)]

# Only include DV360 and bid manager from DCM data
AmFAMDCMFiltered2 <- AmFAMDCMFiltered2 %>% filter(`Site (CM360)` %in% c("DV 360","BidManager_DfaSite_4183753"))

# Rename columns to allow for join
AmFAMDCMFiltered2 <- AmFAMDCMFiltered2 %>% rename(DMA = `Designated Market Area (DMA)`,
                                                  Placement_ID = `Placement ID`)
dv360_grouped <- dv360_grouped %>% rename(DMA = `Clean_DMA`,
                                          Placement_ID = `CM360 Placement ID`)

##### Merge the datasets on Date, DMA, and CM360 Placement ID #####
combined <- merge(AmFAMDCMFiltered2,dv360_grouped,by=c("Date","DMA","Placement_ID"),all.x=TRUE)
combined$DV360_Platform_Cost[is.na(combined$DV360_Platform_Cost)] <- 0
sum(combined$DV360_Platform_Cost)
sum(combined$`DV360 Cost USD`)


# Add a week end date as a sanity check/flag to ensure that your group by later in the script is in the Monday-Sunday format (example below)
floor_date(combined$`Date`,"week") + 1  -> combined$`Start_Date` #- this gets you the Monday for the week in reference
floor_date(combined$`Date`,"week") + 7  -> combined$`End_Date` #- this gets you the Sunday for the week in reference


##### Load in data dictionary and map to the main data file #####
dict <- read_excel("American Family Insurance Taxonomy Dictionary (AmFam).xlsx",sheet="DATA DICTIONARY")

# Manipulate data dictionary column names to get matchable columns
names(dict) = gsub(pattern = ".*.Code \\(", replacement="", x=names(dict))
names(dict) = gsub(pattern = "\\)", replacement="", x=names(dict))

# Reduce dictionary data to relevant match columns
ch_dict <- dict[,c(93,94)]
ob_dict <- dict[,c(41,42)]

### Extract relevant data from campaign and map to data dictionary
# Parse taxonomy
combined$Channel = ex_between(combined$Placement, "CH~", "_",extract=TRUE)
combined$Objective <- ex_between(combined$Placement, "OB~", "_",extract=TRUE)

# Change data type to character to allow for matching
combined$Channel <- as.character(combined$Channel)
combined$Objective <- as.character(combined$Objective)

# Map main data set to data dictionary
combined <- inner_join(combined, ch_dict, by=c('Channel' = 'CH~'))
combined <- inner_join(combined, ob_dict, by=c('Objective' = 'OB~'))

# Rename output columns
combined <- combined %>% rename(Channel_Cleaned = 'Media Channel (CH~',
                                Objective_Cleaned = 'Campaign Objective (OB~')

##### Parse Creative Message, eliminating ID String #####
# Parse Creative Message value and change to character
combined$Creative_Message = ex_between(combined$Creative, "CM~", "_",extract=TRUE)
combined$Creative_Message <- as.character(combined$Creative_Message)

# Adjust Creative_Message to adjust for cases where taxonomy is missing
combined$Creative_Message <- ifelse(is.na(combined$Creative_Message),
                                          ex_between(combined$Creative, "CV~", "_",extract=TRUE),
                                          combined$Creative_Message)
combined$Creative_Message <- ifelse(is.na(combined$Creative_Message),
                                          combined$Creative,
                                          combined$Creative_Message)

# Parse out only the value before the "-"
combined$Creative_Message_Cleaned <- str_extract(combined$Creative_Message, "[^-]+")


##### Manually parse product from campaign due to weird taxonomy #####
# Parse Product using logic from usual taxonomy
case_when(stri_detect_fixed(combined$Campaign,"CN~AFAT")~"Auto",
          stri_detect_fixed(combined$Campaign,"CN~PAFA")~"Auto Programmatic",
          stri_detect_fixed(combined$Campaign,"CN~AFBO")~"Boat",
          stri_detect_fixed(combined$Campaign,"CN~AFBR")~"Brand",
          stri_detect_fixed(combined$Campaign,"CN~AFBP")~"Brand / Upper Funnel Programmatic",
          stri_detect_fixed(combined$Campaign,"CN~AFBN")~"Bundle",
          stri_detect_fixed(combined$Campaign,"CN~PAFB")~"Bundle Programmatic",
          stri_detect_fixed(combined$Campaign,"CN~AFCM")~"Commerical",
          stri_detect_fixed(combined$Campaign,"CN~AFDB")~"Dream Bank",
          stri_detect_fixed(combined$Campaign,"CN~AFFR")~"Farm/Ranch",
          stri_detect_fixed(combined$Campaign,"CN~AFFD")~"Free to Dream",
          stri_detect_fixed(combined$Campaign,"CN~DREAMLGBTQ")~"Free to Dream LGBTQ+",
          stri_detect_fixed(combined$Campaign,"CN~AFHB")~"Habitational",
          stri_detect_fixed(combined$Campaign,"CN~AFHM")~"Home",
          stri_detect_fixed(combined$Campaign,"CN~AFLF")~"Life",
          stri_detect_fixed(combined$Campaign,"CN~AFMO")~"Motorcycle",
          stri_detect_fixed(combined$Campaign,"CN~AFMP")~"Multicultural / Hispanic Pilot Programmatic",
          stri_detect_fixed(combined$Campaign,"CN~MCAA")~"Multicultural-AA",
          stri_detect_fixed(combined$Campaign,"CN~AFMC")~"Multicultural-HA",
          stri_detect_fixed(combined$Campaign,"CN~NAFS")~"NBNP Paid Social",
          stri_detect_fixed(combined$Campaign,"CN~AFPS")~"Paid Search General",
          stri_detect_fixed(combined$Campaign,"CN~AFPC")~"Paid Social General",
          stri_detect_fixed(combined$Campaign,"CN~AFPA")~"Partnerships",
          stri_detect_fixed(combined$Campaign,"CN~AFRN")~"Renters",
          stri_detect_fixed(combined$Campaign,"CN~AFRV")~"RV",
          stri_detect_fixed(combined$Campaign,"CN~AFSC")~"Secondary LOB",
          stri_detect_fixed(combined$Campaign,"CN~PAFS")~"Secondary LOB Programmatic",
          stri_detect_fixed(combined$Campaign,"CN~AFSM")~"Snowmobile",
          TRUE ~ NA) -> combined$Product

# Parse product using Digital campaign taxonomy for all other cases
ifelse(is.na(combined$Product),case_when(
  stri_detect_fixed(combined$Campaign,"Homecoming")~"Brand",
      stri_detect_fixed(combined$Campaign,"Home")~"Home",
      stri_detect_fixed(combined$Campaign,"Auto")~"Auto",
      stri_detect_fixed(combined$Campaign,"Renters")~"Renters",
      stri_detect_fixed(combined$Campaign,"Hispanic")~"Multicultural-HA",
      stri_detect_fixed(combined$Campaign,"BHM")~"Multicultural-AA",
      stri_detect_fixed(combined$Campaign,"Bundle")~"Bundle",
      stri_detect_fixed(combined$Campaign,"Partnership")~"Partnership",
      stri_detect_fixed(combined$Campaign,"AO")~"Auto",
      stri_detect_fixed(combined$Campaign,"AV")~"Auto",
      stri_detect_fixed(combined$Campaign,"BO")~"Bundle",
      stri_detect_fixed(combined$Campaign,"BV")~"Bundle",
      stri_detect_fixed(combined$Campaign,"FD")~"Free to Dream",
      stri_detect_fixed(combined$Campaign,"HO")~"Home",
      stri_detect_fixed(combined$Campaign,"HV")~"Home",
      stri_detect_fixed(combined$Campaign,"SO")~"Secondary LOB",
      stri_detect_fixed(combined$Campaign,"SV")~"Secondary LOB",
      stri_detect_fixed(combined$Campaign,"DB")~"Dream Bank",
      stri_detect_fixed(combined$Campaign,"HA")~"Multicultural-HA",
      stri_detect_fixed(combined$Campaign,"AA")~"Multicultural-AA",
      stri_detect_fixed(combined$Campaign,"RN")~"Renters",
      stri_detect_fixed(combined$Campaign,"Brand")~"Brand",
      stri_detect_fixed(combined$Campaign,"CV")~"Brand",
      stri_detect_fixed(combined$Campaign,"Local")~"Brand",
      stri_detect_fixed(combined$Campaign,"PR")~"Partnership",
      stri_detect_fixed(combined$Campaign,"AW")~"Brand",
      TRUE ~ combined$Product),combined$Product) -> combined$Product

# Account for shadow advertiser
### Separate data and manipulate to ready for join
bid_manager <- combined %>% filter(str_detect(Campaign,"BidManager"))
bid_manager$Placement <- str_sub(bid_manager$Placement, end = -22)
bid_manager <- bid_manager %>% group_by(Date,DMA,Placement) %>%
                              summarize(`BM DV360 Cost USD` = sum(`DV360 Cost USD`),
                                        BM_DV360_Platform_Cost = sum(DV360_Platform_Cost))
### Join back to main data set at Date, DMA, and Placement level
combined <- merge(combined,bid_manager,by=c("Date","DMA","Placement"),all.x=TRUE)
#select everything where Campaign doesn't contain BidManager, since we already have Impressions and Clicks, and just broke up, cleaned and joined the two potential spend types for BidManager
combined <- combined %>% filter(!str_detect(Campaign,"BidManager"))
### Create cleaned, combined spend columns
combined$DV360_Cost_USD_Combined <- ifelse(is.na(combined$`BM DV360 Cost USD`),combined$`DV360 Cost USD`,combined$`BM DV360 Cost USD`)
combined$DV360_Platform_Cost_Combined <- ifelse(is.na(combined$BM_DV360_Platform_Cost),combined$DV360_Platform_Cost,combined$BM_DV360_Platform_Cost)

# Calculate total impressions to calculate % of spend
total_imps_table <- combined %>% group_by(Date,DMA,Placement_ID) %>% summarise(Total_Imps = sum(Impressions))
combined <- merge(combined,total_imps_table,by=c("Date","DMA","Placement_ID"),all.x=TRUE)
combined$dv360_platform_perc_spend <- combined$Impressions/combined$Total_Imps*combined$DV360_Platform_Cost_Combined
#combined$dv360_dcm_perc_spend <- combined$Impressions/combined$Total_Imps*combined$DV360_Cost_USD_Combined

# Assign spend based on source of truth rules (BI reference doc)
# Use DV360 platform spend if Display/Audio
combined$Spend <- ifelse(combined$Channel_Cleaned %in% c("Digital Display","Digital Audio"),combined$dv360_platform_perc_spend,
                         # Use DV360 Cost column from DCM if Video, Innovid trafficked, and no mapping to a DFA placement
                         ifelse(combined$Channel_Cleaned %in% c("Connected TV","Digital Video","Native Video","OTT") & str_detect(combined$Placement,"AS~DCMINNOVID") &
                                  is.na(combined$`BM DV360 Cost USD`),combined$DV360_Cost_USD_Combined,
                                # Use DV360 platform spend if Video and Innovid trafficked, else use DV360 Cost from DCM (YouTube only in this bucket)
                                ifelse(combined$Channel_Cleaned %in% c("Connected TV","Digital Video","Native Video","OTT") & str_detect(combined$Placement,"AS~DCMINNOVID"),
                                combined$dv360_platform_perc_spend,combined$DV360_Cost_USD_Combined)))
# Set NAs (where DV360 Cost USD not defined) to be 0
combined$Spend[is.na(combined$Spend)] <- 0

# Group by week
combined2 <- combined %>%
  group_by(Product,Campaign,Objective_Cleaned,`Site (CM360)`,Channel_Cleaned,Creative_Message_Cleaned,DMA,`Start_Date`,`End_Date`) %>%
  summarize(Impressions = sum(Impressions),
  Clicks = sum(Clicks),
  Spend_Final = sum(Spend))

#combined2$Partner <- as.character(ex_between(combined2$Placement, "DA~", "_",extract=TRUE))
combined2 %>% group_by(Channel_Cleaned) %>% summarize(Spend_Final = sum(Spend_Final))

# Filter out unnecessary channels (only for Q2/Q3) and clean up naming conventions
#combined2 <- combined2 %>% filter(Channel_Cleaned %in% c("Connected TV","Digital Video","Native Video","OTT"))
combined2$Channel_Cleaned <- ifelse(combined2$Channel_Cleaned == "OTT","Connected TV",combined2$Channel_Cleaned)

# Output file - change your wd as needed if you want to save the cleaned file in a different location
setwd("C:/Users/dilli/AFI/Hypothesis Library/2024/MMM Creative Data Backfill/Outputs")
write.csv(combined2,"DV360 10.1.23-12.31.23.csv",row.names=FALSE)