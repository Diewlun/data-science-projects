#set wd
setwd("C:/Users/dli89/QQ Studio Data Analytics Work/Customer Churn Model")

#load libraries
library(dplyr)
library(caTools)
library(caret)
library(ROCR)
library(sqldf)

df = read.csv("QQ Studio Churn Analysis Training Data.csv", header=TRUE, stringsAsFactors=FALSE)
email = data.frame(df$email)
names(email)[1] = "email"
data = data.frame(df[,2:11])

#convert target variable to factor
data$churn = as.factor(data$churn)

#convert categorical variables to factor
data$state = as.factor(data$state)

#create training and test datasets
split = sample.split(data$churn, SplitRatio = 0.75)
train_data = subset(data, split == TRUE)
test_data = subset(data, split == FALSE)

#build logistic regression model
churn_model = glm(churn ~ ., data = train_data, family = binomial())
summary(churn_model)

#model evaluation - predicting on the test data
predictions = predict(churn_model, test_data, type = "response")
predicted_classes = ifelse(predictions > 0.5, 1, 0)

confusion_matrix = table(Predicted = predicted_classes, Actual = test_data$churn)
print(confusion_matrix)

#check accuracy
accuracy = sum(diag(confusion_matrix)) / sum(confusion_matrix)
print(paste("Accuracy:", accuracy))

#run predictions over entire dataset, convert to dataframe and join back to actual dataset
preds = predict(churn_model, data, type = "response")
pred_classes = ifelse(preds > 0.5, 1, 0)
pred_classes = data.frame(pred_classes)

final = cbind(email, data, pred_classes)

#select full list of emails where churn is 0 and predictions is 1
high_risk = sqldf("select *
                  from final
                  where churn = 0 and pred_classes = 1")
write.csv(high_risk, "QQ Studio.com Customers At Risk Of Churning November 2024.csv", row.names=FALSE)

