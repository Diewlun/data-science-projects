#set working directory
setwd("C:/Users/dilli/Desktop/Onboarding/Vonage/Brand Campaigns/Global Market Measurement/Log Level Analysis/Log Files")

library(tidyverse)
library(reshape2)
library(ggthemes)
library(ggrepel)
library(RColorBrewer)
library(ChannelAttribution)
library(markovchain)
library(visNetwork)
library(expm)
library(stringr)
library(purrrlyr)
library(sqldf)

Data = read.csv("CC_MTA.csv", stringsAsFactors=FALSE, header=TRUE)

#build heuristic model with function, see if any channels need to be further processed with regex
Heuristic = heuristic_models(Data, var_path = 'platformflow', var_conv = 'totalconversions')

#calculate the heuristic model manually to check
HeuristicCalc <- Data %>%
  mutate(channel_name_ft = sub('>.*', '', platformflow),
         channel_name_ft = sub(' ', '', channel_name_ft),
         channel_name_lt = sub('.*>', '', platformflow),
         channel_name_lt = sub(' ', '', channel_name_lt))

Test = sqldf("select distinct channel_name_ft from HeuristicCalc")
Test2 = sqldf("select distinct channel_name_lt from HeuristicCalc")

Data$platformflow = gsub("\\<ASD\"", "ASD", Data$platformflow) #forces exact match for strings with single end quote
Data$platformflow = gsub("SDH", "SD", Data$platformflow)
Data$platformflow = gsub("SDO", "Spotify", Data$platformflow)
Data$platformflow = gsub("ASD", "Amobee", Data$platformflow)
Data$platformflow = gsub("SD", "SDH", Data$platformflow) 
Data$platformflow = gsub("Spotify", "SDO", Data$platformflow)
Data$platformflow = gsub("SB Nonbrand", "SBNonbrand", Data$platformflow)
Data$platformflow = gsub("SB Brand", "SBBrand", Data$platformflow)
Data$platformflow = gsub("SG Nonbrand", "SGNonbrand", Data$platformflow)
Data$platformflow = gsub("SG Brand", "SGBrand", Data$platformflow)


# first-touch conversions
HeuristicFT <- HeuristicCalc %>%
  group_by(channel_name_ft) %>%
  summarise(first_touch_conversions = sum(totalconversions)) %>%
  ungroup()
# last-touch conversions
HeuristicLT <- HeuristicCalc %>%
  group_by(channel_name_lt) %>%
  summarise(last_touch_conversions = sum(totalconversions)) %>%
  ungroup()

Heuristic2 <- merge(HeuristicFT, HeuristicLT, by.x = 'channel_name_ft', by.y = 'channel_name_lt')

#decide what order to use based off the data that we have (order=2 in this case)
choose_order(Data, var_path = 'platformflow', var_conv = 'totalconversions', var_null = 'nullconversions', max_order=10)

#build markov model and run 10 simulations
Markov = markov_model(Data, var_path = 'platformflow', var_conv = 'totalconversions', var_null = 'nullconversions', order=1)
Markov2 = markov_model(Data, var_path = 'platformflow', var_conv = 'totalconversions', var_null = 'nullconversions', order=1)
Markov3 = markov_model(Data, var_path = 'platformflow', var_conv = 'totalconversions', var_null = 'nullconversions', order=1)
Markov4 = markov_model(Data, var_path = 'platformflow', var_conv = 'totalconversions', var_null = 'nullconversions', order=1)
Markov5 = markov_model(Data, var_path = 'platformflow', var_conv = 'totalconversions', var_null = 'nullconversions', order=1)
Markov6 = markov_model(Data, var_path = 'platformflow', var_conv = 'totalconversions', var_null = 'nullconversions', order=1)
Markov7 = markov_model(Data, var_path = 'platformflow', var_conv = 'totalconversions', var_null = 'nullconversions', order=1)
Markov8 = markov_model(Data, var_path = 'platformflow', var_conv = 'totalconversions', var_null = 'nullconversions', order=1)
Markov9 = markov_model(Data, var_path = 'platformflow', var_conv = 'totalconversions', var_null = 'nullconversions', order=1)
Markov10 = markov_model(Data, var_path = 'platformflow', var_conv = 'totalconversions', var_null = 'nullconversions', order=1)

#stack the results and take the average
MarkovMaster = rbind(Markov, Markov2, Markov3, Markov4, Markov5, Markov6, Markov7, Markov8, Markov9, Markov10)
MarkovMaster = sqldf("select channel_name, avg(total_conversions) as total_conversions from MarkovMaster group by channel_name")

#build markov model and show transition probabilities
Markov2 = markov_model(Clickthrough, var_path = 'channelflow', var_conv = 'totalconversions', var_null = 'nullconversions', order=2, out_more=TRUE)
Markov2Results = Markov2$result
Markov2TransitionMatrix = Markov2$transition_matrix %>% dmap_at(c(1,2), as.character)

Markov2Trans <- Markov2$transition_matrix

cols = c("#e7f0fa", "#c9e2f6", "#95cbee", "#0099dc", "#4ab04a", "#ffd73e", "#eec73a",
          "#e29421", "#e29421", "#f05336", "#ce472e")
t = max(Markov2Trans$transition_probability)

ggplot(Markov2Trans, aes(y = channel_from, x = channel_to, fill = transition_probability)) +
  theme_minimal() +
  geom_tile(colour = "white", width = .9, height = .9) +
  scale_fill_gradientn(colours = cols, limits = c(0, t),
                       breaks = seq(0, t, by = t/4),
                       labels = c("0", round(t/4*1, 2), round(t/4*2, 2), round(t/4*3, 2), round(t/4*4, 2)),
                       guide = guide_colourbar(ticks = T, nbin = 50, barheight = .5, label = T, barwidth = 10)) +
  geom_text(aes(label = round(transition_probability, 2)), fontface = "bold", size = 4) +
  theme(legend.position = 'bottom',
        legend.direction = "horizontal",
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_text(size = 16, face = "bold", vjust = 0.5, hjust = 0.5, color = 'black', lineheight = 0.8),
        axis.title.x = element_text(size = 16, face = "bold"),
        axis.title.y = element_text(size = 16, face = "bold"),
        axis.text.y = element_text(size = 8, face = "bold", color = 'black'),
        axis.text.x = element_text(size = 8, angle = 90, hjust = 0.5, vjust = 0.5, face = "plain")) +
  ggtitle("Vonage Digital Marketing Transition Matrix Heatmap")+ 
  xlab("Destination Channel/Platform") + 
  ylab("Starting Channel/Platform")

#create markov chain transition state visual network
edges =
  data.frame(
    from = Markov2TransitionMatrix$channel_from,
    to = Markov2TransitionMatrix$channel_to,
    label = round(Markov2TransitionMatrix$transition_probability, 2),
    font.size = Markov2TransitionMatrix$transition_probability * 100,
    width = Markov2TransitionMatrix$transition_probability * 15,
    shadow = TRUE,
    arrows = "to",
    color = list(color = "#95cbee", highlight = "red")
  )

nodes = data_frame(id = c( c(Markov2TransitionMatrix$channel_from), c(Markov2TransitionMatrix$channel_to) )) %>%
  distinct(id) %>%
  arrange(id) %>%
  mutate(
    label = id,
    color = ifelse(
      label %in% c('(start)', '(conversion)'),
      '#4ab04a',
      ifelse(label == '(null)', '#ce472e', '#ffd73e')
    ),
    shadow = TRUE,
    shape = "box"
  )

visNetwork(nodes,
           edges,
           height = "2000px",
           width = "100%",
           main = "Markov Chain Model Transition Matrix") %>%
  visIgraphLayout(randomSeed = 123) %>%
  visNodes(size = 5) %>%
  visOptions(highlightNearest = TRUE)

Markov2TransitionMatrix2 = Markov2$transition_matrix
Markov2TransitionMatrix2 <- dcast(Markov2TransitionMatrix2, channel_from ~ channel_to, value.var = 'transition_probability')
Markov2TransitionMatrix2[is.na(Markov2TransitionMatrix2)] = 0

#merge the heuristic and markov model on the channel_name column
MergeModel = merge(Heuristic, MarkovMaster, by='channel_name')
colnames(MergeModel) <- c('channel_name', 'first_touch', 'last_touch', 'linear_touch', 'markov_model')
MergeModel = melt(MergeModel, id='channel_name')

# Plot the total conversions
ggplot(MergeModel, aes(channel_name, value, fill = variable)) +
  geom_bar(stat="identity", position="dodge") +
  ggtitle("Conversion Attribution Difference Between Heuristic Models & Markov Model") + 
  xlab("Channel") + 
  ylab("Conversion") +
  theme(axis.text.x=element_text(size=8, angle=90), axis.text.y=element_text(size=8)) +
  theme(plot.title = element_text(hjust = 0.5))
  theme(axis.title.x = element_text(vjust = -2)) +
  theme(axis.title.y = element_text(vjust = +2)) +
  theme(title = element_text(size = 16)) +
  theme(plot.title=element_text(size = 20))
  
#export the merged models data frame as a CSV
write.csv(MergeModel, "UCaaS 100+ Seat Cohorts Markov Chain Attribution Results.csv", row.names=FALSE)

####measuring how many days it took to get 95% of our cumulative conversions and optimal frequency#####
TimeToConvert = read.csv("TimeToConvert_April2020.csv", stringsAsFactors=FALSE, header=TRUE)
OptimalFrequency = read.csv("OptimalFrequency_April2020.csv", stringsAsFactors=FALSE, header=TRUE)

#distribution plot (total conversions & time elapsed)
ggplot(TimeToConvert %>% filter(totalconversions >= 1), aes(x = totaltimelapsed)) +
  theme_minimal() +
  geom_histogram(fill = '4e79a7', binwidth = 1)

#cumulative distribution plot (total conversions & time elapsed)
ggplot(TimeToConvert %>% filter(totalconversions >= 1), aes(x = totaltimelapsed)) +
  ggtitle("Cumulative Distribution Plot Of Conversions Over Days Elapsed") +
  xlab("Days Elapsed") +
  ylab(" % Of Total Conversions") +
  theme(plot.title = element_text(hjust = 0.5)) +
  stat_ecdf(geom = 'line', color= '#4e79a7', size = 2, alpha = 0.7) +
  geom_hline(yintercept = 0.95, color = '#e15759', size = 1.5) +
  geom_vline(xintercept = 21, color = '#e15759', size = 1.5, linetype = 2)

#distribution plot (total conversions & impressions)
ggplot(OptimalFrequency %>% filter(totalconversions >= 1), aes(x = impression)) +
  theme_minimal() +
  geom_histogram(fill = '4e79a7', binwidth = 1)

#cumulative distribution plot (total conversions & impression frequency)
ggplot(OptimalFrequency %>% filter(totalconversions >= 1), aes(x = impression)) +
  ggtitle("Cumulative Distribution Plot Of Conversions Over Impressions Served Per Converting User") +
  xlab("Impression") +
  ylab(" % Of Total Conversions") +
  theme(plot.title = element_text(hjust = 0.5)) +
  stat_ecdf(geom = 'line', color= '#FF9933', size = 2, alpha = 0.7) +
  geom_hline(yintercept = 0.95, color = '#9933FF', size = 1.5) +
  geom_vline(xintercept = 41, color = '#9933FF', size = 1.5, linetype = 2)

#modeling how many conversions we can obtain for each channel if 10000 users interacted with a certain channel
dfdummy = data.frame(channel_from = c('(start)', '(conversion)', '(null)'),
                       channel_to = c('(start)', '(conversion)', '(null)'),
                       n = c(0, 0, 0),
                       tot_n = c(0, 0, 0),
                       perc = c(0, 1, 1))

TransitionMatrix = rbind(Markov2TransitionMatrix, dfdummy %>%
                        mutate(transition_probability = perc) %>%
                        select(channel_from, channel_to, transition_probability))
TransitionMatrix = dcast(TransitionMatrix, channel_from ~ channel_to, value.var = 'transition_probability')
TransitionMatrix[is.na(TransitionMatrix)] = 0
rownames(TransitionMatrix) = TransitionMatrix$channel_from
TransitionMatrix = as.matrix(TransitionMatrix[, -1])

#create empty matrix for the model
ModelMatrix = matrix(data = 0, 
                     nrow = nrow(TransitionMatrix), ncol = 1,
                     dimnames = list(c(rownames(TransitionMatrix)), '(start)'))
ModelMatrix['Search Brand', ] = 10000

c(ModelMatrix) %*% (TransitionMatrix %^% 5) # after 5 steps
c(ModelMatrix) %*% (TransitionMatrix %^% 100000) # after 100000 steps

#read in assisting value to search file for paid search
SearchAssist = read.csv("TwoChannelAssistSearch.csv", header=TRUE)

ggplot(SearchAssist, aes(x = reorder(usermediamix, -convertedusers), y=convertedusers)) +
  geom_col(aes(y=convertedusers), size=1, color="purple", fill="purple") +
  geom_line(aes(y=(10000*conversionrate) + 500), size=1.5, color="orange", group=1) +
  scale_y_continuous(sec.axis = sec_axis(~./10000-.05, name="Conversion Rate", labels = scales::percent)) +
  ggtitle("Conversion & CVR By Platform & Paid Search Combo") + 
  xlab("Media Mix") + 
  ylab("Converted Users") +
  theme(axis.text.x=element_text(size=8, angle=90), axis.text.y=element_text(size=8)) +
  theme(axis.text.x=element_text(size=8, angle=90), axis.text.y=element_text(size=8)) +
  theme(plot.title = element_text(hjust = 0.5))
  theme(axis.title.x = element_text(vjust = -2)) +
  theme(axis.title.y = element_text(vjust = +2)) +
  theme(title = element_text(size = 16)) +
  theme(plot.title=element_text(size = 20))

