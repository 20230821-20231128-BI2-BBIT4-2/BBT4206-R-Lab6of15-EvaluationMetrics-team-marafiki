# STEP 1. Install and Load the Required Packages ----
## ggplot2 ----
if (require("ggplot2")) {
  require("ggplot2")
} else {
  install.packages("ggplot2", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## mlbench ----
if (require("mlbench")) {
  require("mlbench")
} else {
  install.packages("mlbench", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## pROC ----
if (require("pROC")) {
  require("pROC")
} else {
  install.packages("pROC", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## dplyr ----
if (require("dplyr")) {
  require("dplyr")
} else {
  install.packages("dplyr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

if (!require("readr")) {
  install.packages("readr", dependencies = TRUE, 
                   repos = "https://cloud.r-project.org")
}

install.packages("mice")
library(mice)


data("BreastCancer")


breast_cancer_freq <- BreastCancer$Class
result <- cbind(frequency = table(breast_cancer_freq), percentage = prop.table(table(breast_cancer_freq)) * 100)

# Print the frequency and percentage table
print(result)

# Create a stratified train/test split (75% train, 25% test)
set.seed(7)  # Set a random seed for reproducibility
split <- createDataPartition(BreastCancer$Class, p = 0.75, list = FALSE)

# Split the data into training and test sets
breast_cancer_train <- BreastCancer[split, ]
breast_cancer_test <- BreastCancer[-split, ]

# Apply the 5-fold cross-validation resampling method
train_control <- trainControl(method = "cv", number = 5)

breast_cancer_train <- na.omit(breast_cancer_train)



# Train a Generalized Linear Model to predict the value of 'Class'
model_glm <- train(Class ~ ., data = breast_cancer_train, method = "glm",
                   metric = "Accuracy", trControl = train_control)

# View the model results
print(model_glm)


# Drop the "Id" column from the test dataset
breast_cancer_test <- breast_cancer_test[, -1]

# Predict using the trained model on the test dataset
predictions <- predict(model_glm, newdata = breast_cancer_test)



# Actual outcomes from the test dataset
actual_values <- breast_cancer_test$Class

# Ensure that both are factors with the same levels
predictions <- factor(predictions, levels = levels(actual_values))

# Create the confusion matrix
confusion_matrix <- caret::confusionMatrix(predictions, actual_values)
print(confusion_matrix)




