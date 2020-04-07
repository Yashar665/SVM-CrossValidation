library(dplyr)
library(h2o)
library(caret)
setwd("C:/Users/Yashar/Desktop/Data Science Bootcamp/R programming/Week 8")

german_bank <- read.csv('credit.csv')
german_bank$creditability <- h2o.asfactor(german_bank$creditability)

set.seed(1)
id <- createDataPartition(y = german_bank$creditability, p = 0.7, list = FALSE)
df_train <- german_bank[id, ]
df_test <- german_bank[-id, ]


# Activate h2o package for using: 
h2o.init(nthreads = 16, max_mem_size = "16g")

# Convert to h2o Frame and identify inputs and output: 
test <- as.h2o(df_test)
train <- as.h2o(df_train)

response <- "creditability"
predictors <- setdiff(names(train), response)


# Train H2O Model: 
automl <- h2o.automl(x = predictors, 
                         y = response, 
                         training_frame = train,
                         leaderboard_frame = test,
                         stopping_metric = "AUC",
                         balance_classes = TRUE,
                         seed = 123,
                         max_runtime_secs = 240
                         )
automl1 <- h2o.automl(x = predictors, 
                     y = response, 
                     training_frame = train,
                     leaderboard_frame = test,
                     stopping_metric = "AUC",
                     balance_classes = TRUE,
                     seed = 123,
                     max_runtime_secs = 240,
                     nfolds = 10
)
