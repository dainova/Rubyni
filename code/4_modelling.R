##----- load packs and styles
source("code/0_start.R")

set.seed(12345)

## (1) Loads data----------------------------------------------------------------
workdata <- readRDS("data/workdata.RData") %>% tbl_df()
workdata <- workdata %>% select(r_stars_1_avg, r_stars_1_cv, r_time_1_avg, r_length_1_avg, group)

## (2) Makes train/test samples--------------------------------------------------
train_index <- createDataPartition(workdata$group, p = 0.7, list = FALSE, times = 1)
train_data <- workdata[train_index, ]
test_data <- workdata[-train_index, ]

## (3) Specifies modelling parameters--------------------------------------------
my_metric <- "ROC"

## Training structure (repeated cross-validation)
ctrl <- trainControl(method = "repeatedcv",
                     repeats = 3,
                     classProbs = TRUE,
                     summaryFunction = twoClassSummary)

## (4) Learning------------------------------------------------------------------
## Partial Least Squares Discriminant Analysis (PLSDA)
model_pls <- train(group ~ .,
                data = train_data,
                method = "pls",
                tuneLength = 10,
                trControl = ctrl,
                metric = my_metric,
                preProcess = c("center", "scale"))

## Generalized Linear Model
model_glm <- train(group ~ .,
                  data = train_data,
                  method = "glm",
                  trControl = ctrl,
                  metric = my_metric)

## k-Nearest Neighbors
model_knn <- train(group~.,
                 data = train_data,
                 method = "knn",
                 preProcess=c("pca"),
                 trControl = ctrl,
                 metric = my_metric)



## (5) Validation----------------------------------------------------------------
## Partial Least Squares Discriminant Analysis (PLSDA)
predict_classes_pls <- predict(model_pls, newdata = test_data)
matrix_pls <- confusionMatrix(data = predict_classes_pls, test_data$group)

## Generalized Linear Model
predict_classes_glm <- predict(model_glm, newdata = test_data)
matrix_glm <- confusionMatrix(predict_classes_glm, test_data$group)

## k-Nearest Neighbors
predict_classes_knn <- predict(model_knn, newdata = test_data)
matrix_knn <- confusionMatrix(predict_classes_knn, test_data$group)


## (6) Comparison----------------------------------------------------------------

## Table with accuracy parameters for three models
methods <- c('pls', 'glm', 'knn')
performance_table <- do.call(rbind,
               Map(function(name) {
                 matrix <- str_c("matrix_", name)
                 c(get(matrix)$overall[1],
                   get(matrix)$byClass[1],
                   get(matrix)$byClass[2],
                   get(matrix)$byClass[3],
                   get(matrix)$byClass[4])
                 }, name = methods)
               )
saveRDS(performance_table, "data/performance_table.RData")


## Resamples to compare three models
resamps <- resamples(list(pls = model_pls, glm = model_glm, knn = model_knn))
saveRDS(resamps, "data/resamps.RData")
summary(resamps)

## paired t-test to assess the difference between the models
diffs <- diff(resamps)
summary(diffs)


