# # COMPLETE CODE FOR PROJECT
# print('Load dataset.')
# source('functions.R')
# digit.data <- read.csv("Dataset/mnist.csv")  # read csv file
# 
# print('Compute pixel density.')
# # add density feature to the dataset
# digit.data$density = rowMeans(digit.data[,-c(1)])
# 
# # create train- and testset
# set.seed(1)
# sample <- splitData(digit.data, 1000)
# digit.trainset <- digit.data[sample[1:1000],]
# digit.testset <- digit.data[sample[1001:2000],]
# 
# print('Compute # of planes for trainset.')
# digit.trainset$planes <- apply(digit.trainset, 1, getPlanes)
# print('Compute # of planes for testset.')
# digit.testset$planes <- apply(digit.testset, 1, getPlanes)
# 
# print('Compute density of bounding box ratio for trainset.')
# digit.trainset$boundingboxratio <- apply(digit.trainset, 1, boundingBoxRatio)
# print('Compute density ofbounding box ratio for testset.')
# digit.testset$boundingboxratio <- apply(digit.testset, 1, boundingBoxRatio)
# 
# # create a factor of $label
# digit.data$label = as.factor(digit.data$label)
# digit.trainset$label = as.factor(digit.trainset$label)
# digit.testset$label = as.factor(digit.testset$label)
# 
# print('Compute which pixels are irrelevant and removes them from the train- and testset. (max == 0)')
# #feature.filter <- which(apply(digit.data, 2, max) == 0) - 2
# #digit.trainset <- digit.trainset[,-c(feature.filter)]
# #digit.testset <- digit.testset[,-c(feature.filter)]
# label <- digit.trainset$label
# boundingboxratio <- digit.trainset$boundingboxratio
# density <- digit.trainset$density
# planes <- digit.trainset$planes
# digit.trainset.features <- data.frame(label, boundingboxratio, density, planes)
# 
# label <- digit.testset$label
# boundingboxratio <- digit.testset$boundingboxratio
# density <- digit.testset$density
# planes <- digit.testset$planes
# digit.testset.features <- data.frame(label, boundingboxratio, density, planes)

library(nnet)
print("Multinomial classification")
# setup multinomial logit model, which predicts the label using the density feature
digit.multinom.density <- multinom(label~ scale(density), digit.trainset, maxit=1000)
# predict the labels in the trainset using the multinom model (Density)
digit.trainset.pred.density <- predict(digit.multinom.density, digit.trainset[,-c(1)], type="class")
# predict the labels in the testset using the multinom model (Density)
digit.testset.pred.density <- predict(digit.multinom.density, digit.testset[,-c(1)], type="class")
# compute and save the test set accuracy
digit.testset.pred.density.acc <- acc(table(digit.testset$label, digit.testset.pred.density))

# setup multinomial logit model, which predicts the label using the plane feature
digit.multinom.planes <- multinom(label~ planes, digit.trainset, maxit=1000)
# predict the labels in the trainset using the multinom model (Plane)
digit.trainset.pred.planes <- predict(digit.multinom.planes, digit.trainset[,-c(1)], type="class")
# predict the labels in the testset using the multinom model (Plane)
digit.testset.pred.planes <- predict(digit.multinom.planes, digit.testset[,-c(1)], type="class")
# compute and save the test set accuracy
digit.testset.pred.planes.acc <- acc(table(digit.testset$label, digit.testset.pred.planes))

# setup multinomial logit model, which predicts the label using the plane feature
digit.multinom.boundingboxratio <- multinom(label~ boundingboxratio, digit.trainset, maxit=1000)
# predict the labels in the trainset using the multinom model (Plane)
digit.trainset.pred.boundingboxratio<- predict(digit.multinom.boundingboxratio, digit.trainset[,-c(1)], type="class")
# predict the labels in the testset using the multinom model (Plane)
digit.testset.pred.boundingboxratio <- predict(digit.multinom.boundingboxratio, digit.testset[,-c(1)], type="class")
# compute and save the test set accuracy
digit.testset.pred.boundingboxratio.acc <- acc(table(digit.testset$label, digit.testset.pred.boundingboxratio))

# setup multinomial logit model, which predicts the label using both features
digit.multinom.combi <- multinom(label~ scale(density)+ planes, digit.trainset, maxit=1000)
# predict the labels in the trainset using the multinom model (Density & Plane)
digit.trainset.pred.combi <- predict(digit.multinom.combi, digit.trainset[,-c(1)], type="class")
# predict the labels in the testset using the multinom model (Density & Plane)
digit.testset.pred.combi <- predict(digit.multinom.combi, digit.testset[,-c(1)], type="class")
# compute and save the test set accuracy
digit.testset.pred.combi.acc <- acc(table(digit.testset$label, digit.testset.pred.combi))

# setup multinomial logit model, which predicts the label using both features
digit.multinom.combi.2 <- multinom(label~ boundingboxratio+planes, digit.trainset, maxit=1000)
# predict the labels in the trainset using the multinom model (Density & Plane)
digit.trainset.pred.combi.2 <- predict(digit.multinom.combi.2, digit.trainset[,-c(1)], type="class")
# predict the labels in the testset using the multinom model (Density & Plane)
digit.testset.pred.combi.2 <- predict(digit.multinom.combi.2, digit.testset[,-c(1)], type="class")
# compute and save the test set accuracy
digit.testset.pred.combi.2.acc <- acc(table(digit.testset$label, digit.testset.pred.combi.2))

digit.multinom.all <- multinom(label~ scale(density)+ planes + boundingboxratio, digit.trainset, maxit=1000)
# predict the labels in the trainset using the multinom model (Density & Plane)
digit.trainset.pred.all <- predict(digit.multinom.all, digit.trainset[,-c(1)], type="class")
# predict the labels in the testset using the multinom model (Density & Plane)
digit.testset.pred.all <- predict(digit.multinom.all, digit.testset[,-c(1)], type="class")
# compute and save the test set accuracy
digit.testset.pred.all.acc <- acc(table(digit.testset$label, digit.testset.pred.all))

print("Multinom logit with LASSO")
library(glmnet)
digit.lasso.cv <- cv.glmnet(as.matrix(digit.trainset[,-c(1)]), digit.trainset[,1], family="multinomial", type.measure="class")
digit.lasso.cv.pred <- predict(digit.lasso.cv, as.matrix(digit.testset[,-c(1)]), type="class")
digit.lasso.cv.pred.acc <- acc(table(digit.testset$label, digit.lasso.cv.pred))

# print("kNN")
# kNN <- nnExecAll(digit.trainset.features, digit.testset.features, 1:11)
# kNN.plot <- plot(kNN)
# 
# print("SVM")
# #Radial kernel
# print("Radial kernel")
# svm.radial <- svm(label ~ ., data = digit.trainset.features, kernel = "radial")
# svm.radial.pred <-  predict(svm.radial, digit.testset.features[,-c(1)])
# svm.radial.pred.acc <- sum(diag(table(digit.testset$label,svm.radial.pred)))/nrow(digit.testset.features)
# #print("Tune Radial kernel")
# #svm.radial.tune <- tune.svm(digit.trainset.features[, -c(1)],digit.trainset.features[,1],cost=c(1:25, 50, 10^(1:3)), gamma = c(10^(-5:3)))
# #optimal cost = 8, gamma = 0.1
# svm.radial.tuned <- svm(label ~ ., data = digit.trainset.features, cost = 8, gamma = 0.1)
# svm.radial.pred.tune <- predict(svm.radial.tuned, digit.testset.features[,-c(1)])
# svm.radial.pred.acc.tune <- sum(diag(table(digit.testset$label,svm.radial.pred.tune)))/nrow(digit.testset.features)

# print("Linear kernel")
# svm.linear <- svm(label ~ ., data = digit.trainset.features, kernel = "linear")
# svm.linear.pred <-  predict(svm.linear, digit.testset.features[,-c(1)])
# svm.linear.pred.acc <- sum(diag(table(digit.testset$label,svm.linear.pred)))/nrow(digit.testset.features)
# #print("Tune linear kernel")
# #svm.linear.tune <- tune.svm(digit.trainset.features[, -c(1)],digit.trainset.features[,1],cost=c(1:25, 50, 10^(1:3)))
# #optimal cost = 3
# svm.linear.tuned <- svm(label ~ ., data = digit.trainset.features, cost = 3)
# svm.linear.pred.tune <- predict(svm.linear.tuned, digit.testset.features[,-c(1)])
# svm.linear.pred.acc.tune <- sum(diag(table(digit.testset$label,svm.linear.pred.tune)))/nrow(digit.testset.features)
# print('Finished.')