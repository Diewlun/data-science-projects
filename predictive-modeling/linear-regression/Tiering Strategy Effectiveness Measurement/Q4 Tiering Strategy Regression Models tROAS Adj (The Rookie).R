setwd("C:/Users/dilli/AFI/Hypothesis Library/2024/Q4 2023 Tiering Strategy Measurement")

library(readxl)
library(glmnet)
library(randomForest)
library(fastDummies)
library(caret)
library(xgboost)

#conduct analysis on data with inclusion of Q2 2023
df2 = read_excel("Q4 2023 Tiering Strategy Model Data Month Breakout (The Rookie).xlsx", sheet="Model Data Q4")

#impressions2 = df2[, C(3:14, 17)]
visits2 = df2[, c(3:14, 18)]
lead2 = df2[,c(3:14, 19)]
adobe_quote2 = df2[,c(3:14, 20)]
quote2 = df2[,c(3:14, 21)]
nbp2 = df2[,c(3:14, 22)]

#model5 = lm(Impressions ~., data=impressions2)
#summary(model5)
#model5_df = as.data.frame(coef(summary(model5)))[1]
#colnames(model5_df)[1] = "Impressions"

#model5_rf = randomForest(Impressions ~., data=impressions2)

model6 = lm(Visits ~.-1, data=visits2)
summary(model6)
model6_df = as.data.frame(coef(summary(model6)))[1]
colnames(model6_df)[1] = "Visits"

model6_rf = randomForest(Visits ~., data=visits2)

model7 = lm(Adobe_Lead ~., data=lead2)
summary(model7)
model7_df = as.data.frame(coef(summary(model7)))[1]
colnames(model7_df)[1] = "Adobe Leads"

model7_rf = randomForest(Adobe_Lead ~., data=lead2)

model8 = lm(Adobe_Quote ~., data=adobe_quote2)
summary(model8)
model8_df = as.data.frame(coef(summary(model8)))[1]
colnames(model8_df)[1] = "Adobe Quotes"

model8_rf = randomForest(Adobe_Quote ~., data=adobe_quote2)

model9 = lm(Quote ~., data=quote2)
summary(model9)
model9_df = as.data.frame(coef(summary(model9)))[1]
colnames(model9_df)[1] = "Digitally Assisted Offline Online Quotes"

model9_rf = randomForest(Quote ~., data=quote2)

model10 = lm(NBP ~.-1, data=nbp2)
summary(model10)
model10_df = as.data.frame(coef(summary(model10)))[1]
colnames(model10_df)[1] = "Digitally Assisted Offline Online NBPs"

model10_rf = randomForest(NBP ~., data=nbp2)

q1_models = cbind(model7_df, model8_df, model9_df)
q1_models2 = cbind(model6_df, model10_df)
write.csv(q1_models, "The Rookie Q4 2023 Tiering Adobe Lead Quotes & Digitally Assisted Offline Online Quotes.csv")
write.csv(q1_models2, "The Rookie Q4 2023 Tiering Visits & Digitally Assisted Offline Online NBPs.csv")

#--------------------------------------------------------------------------------------------------------------------
#prediction if tiering didn't run
df2$Date = as.character(df2$Date)
original = sqldf("select *
                 from df2
                 where Date >= '2023-10-01'")
original = original[,3:14]

df3 = read_excel("Q4 2023 Tiering Strategy Model Data Month Breakout (The Rookie).xlsx", sheet="Model Data Q4 If No Tier")
df3$Date = as.character(df3$Date)
prediction = sqldf("select *
                 from df3
                 where Date >= '2023-10-01'")
prediction = prediction[, 3:14]

#create new dataframes to store all of our predictions
train = original
test = prediction

#train$Impressions = predict(model5, newdata=original)
train$Visits = predict(model6, newdata=original)
train$Adobe_Lead = predict(model7, newdata=original)
train$Adobe_Quote = predict(model8, newdata=original)
train$Quote = predict(model9, newdata=original)
train$NBP = predict(model10, newdata=original)

#test$Impressions = predict(model5, newdata=prediction)
test$Visits = predict(model6, newdata=prediction)
test$Adobe_Lead = predict(model7, newdata=prediction)
test$Adobe_Quote = predict(model8, newdata=prediction)
test$Quote = predict(model9, newdata=prediction)
test$NBP = predict(model10, newdata=prediction)

differences = data.frame(matrix(ncol = 0, nrow = 1))
#differences$Impressions_Shift = sum(test$Impressions) - sum(train$Impressions)
differences$Visits_Shift = sum(test$Visits) - sum(train$Visits)
differences$Adobe_Lead_Shift = sum(test$Adobe_Lead) - sum(train$Adobe_Lead)
differences$Adobe_Quote_Shift = sum(test$Adobe_Quote) - sum(train$Adobe_Quote)
differences$Quote_Shift = sum(test$Quote) - sum(train$Quote)
differences$NBP_Shift = sum(test$NBP) - sum(train$NBP)
#differences$Impressions_Lift = (sum(test$Impressions) - sum(train$Impressions)) / sum(train$Impressions)
differences$Visits_Lift = (sum(test$Visits) - sum(train$Visits)) / sum(train$Visits)
differences$Adobe_Lead_Lift = (sum(test$Adobe_Lead) - sum(train$Adobe_Lead)) / sum(train$Adobe_Lead)
differences$Adobe_Quote_Lift = (sum(test$Adobe_Quote) - sum(train$Adobe_Quote)) / sum(train$Adobe_Quote)
differences$Quote_Lift = (sum(test$Quote) - sum(train$Quote)) / sum(train$Quote)
differences$NBP_Lift = (sum(test$NBP) - sum(train$NBP)) / sum(train$NBP)

#export the prediction estimates
write.csv(differences, "Q4 2023 Tiering Predictions If Tiering Didn't Run (The Rookie).csv", row.names=FALSE)

#random forest predictions
train_rf = original
test_rf = prediction

#train_rf$Impressions = predict(model5_rf, newdata=original)
train_rf$Visits = predict(model6_rf, newdata=original)
train_rf$Adobe_Lead = predict(model7_rf, newdata=original)
train_rf$Adobe_Quote = predict(model8_rf, newdata=original)
train_rf$Quote = predict(model9_rf, newdata=original)
train_rf$NBP = predict(model10_rf, newdata=original)

#test_rf$Impressions = predict(model5_rf, newdata=prediction)
test_rf$Visits = predict(model6_rf, newdata=prediction)
test_rf$Adobe_Lead = predict(model7_rf, newdata=prediction)
test_rf$Adobe_Quote = predict(model8_rf, newdata=prediction)
test_rf$Quote = predict(model9_rf, newdata=prediction)
test_rf$NBP = predict(model10_rf, newdata=prediction)

differences = data.frame(matrix(ncol = 0, nrow = 1))
#differences$Impressions_Shift = sum(test_rf$Impressions) - sum(train_rf$Impressions)
differences$Visits_Shift = sum(test_rf$Visits) - sum(train_rf$Visits)
differences$Adobe_Lead_Shift = sum(test_rf$Adobe_Lead) - sum(train_rf$Adobe_Lead)
differences$Adobe_Quote_Shift = sum(test_rf$Adobe_Quote) - sum(train_rf$Adobe_Quote)
differences$Quote_Shift = sum(test_rf$Quote) - sum(train_rf$Quote)
differences$NBP_Shift = sum(test_rf$NBP) - sum(train_rf$NBP)
#differences$Impressions_Lift = (sum(test_rf$Impressions) - sum(train_rf$Impressions)) / sum(train_rf$Impressions)
differences$Visits_Lift = (sum(test_rf$Visits) - sum(train_rf$Visits)) / sum(train_rf$Visits)
differences$Adobe_Lead_Lift = (sum(test_rf$Adobe_Lead) - sum(train_rf$Adobe_Lead)) / sum(train_rf$Adobe_Lead)
differences$Adobe_Quote_Lift = (sum(test_rf$Adobe_Quote) - sum(train_rf$Adobe_Quote)) / sum(train_rf$Adobe_Quote)
differences$Quote_Lift = (sum(test_rf$Quote) - sum(train_rf$Quote)) / sum(train_rf$Quote)
differences$NBP_Lift = (sum(test_rf$NBP) - sum(train_rf$NBP)) / sum(train_rf$NBP)

#export the random forest prediction estimates
write.csv(differences, "Q4 2023 Tiering RF Predictions If Tiering Didn't Run (The Rookie).csv", row.names=FALSE)
#--------------------------------------------------------------------------------------------------------------------

#testing model with months included
df4 = read_excel("Q3 2023 Tiering Strategy Model Data Month Breakout (The Rookie).xlsx", sheet="Model Data Q3")
df4 = dummy_cols(df4, select_columns = 'Month')
lead4 = df4[,c(3:14, 16, 20:31)]

model14 = lm(Adobe_Lead ~., data=lead4)
summary(model14)
#model with month included explains more of the variability (r-squared = 0.81 vs 0.77)

#--------------------------------------------------------------------------------------------------------------------\

#testing extreme gradient boosting (xgboost)
df2 = read_excel("Q3 2023 Tiering Strategy Model Data (The Rookie).xlsx", sheet="Model Data Q3")

#split data into training and test
lead_parts = createDataPartition(df2$Adobe_Lead, p=.9, list=F)
train_xg = df2[lead_parts, ]
test_xg = df2[-lead_parts, ]

#partition data for xgboost
train_xg_x = train_xg[, c(2:13)]
train_xg_y = train_xg[, 15]
test_xg_x = test_xg[, c(2:13)]
test_xg_y = test_xg[, 15]

xgb_train = xgb.DMatrix(data = as.matrix(sapply(train_xg_x, as.numeric)), label = as.matrix(sapply(train_xg_y, as.numeric)))
xgb_test = xgb.DMatrix(data = as.matrix(sapply(test_xg_x, as.numeric)), label = as.matrix(sapply(test_xg_y, as.numeric)))

#define watchlist
watchlist = list(train=xgb_train, test=xgb_test)

#fit model - nrounds = 78 seems optimal
xgb_model = xgb.train(data = xgb_train, max.depth = 3, watchlist=watchlist, nrounds = 100)

#define model
xgb_final = xgb.train(data = xgb_train, max.depth = 3, nrounds = 78, verbose = 0)

#predictions and MSE
test_xg_y$preds = predict(xgb_final, newdata=as.matrix(test_xg_x))
mean((test_xg_y$Adobe_Lead - test_xg_y$preds)^2)

#partition data for linear regression
train_lm = train_xg[, c(2:13, 15)]

#train linear regression
lin_reg = lm(Adobe_Lead ~., data=train_lm)
summary(lin_reg)

#linear regression predictions and MSE
test_xg_y$lm_preds = predict(lin_reg, newdata=test_xg_x)
mean((test_xg_y$Adobe_Lead - test_xg_y$lm_preds)^2)

caret::RMSE(test_xg_y$Adobe_Lead, test_xg_y$lm_preds) #rmse lin reg
caret::RMSE(test_xg_y$Adobe_Lead, test_xg_y$preds) #rmse xgboost
