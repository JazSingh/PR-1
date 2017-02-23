# COMPLETE CODE FOR PROJECT
# print('Load dataset.')
# source('functions.R')
# digit.data <- read.csv("Dataset/mnist.csv")  # read csv file
# 
# # create train- and testset
# set.seed(1)
# sample <- splitData(digit.data, 1000)
# digit.trainset <- digit.data[sample[1:1000],]
# digit.testset <- digit.data[sample[1001:2000],]
# 
# print('Compute # of planes for trainset. (3-4 min max) grab a coffee in the meanwhile')
# train.planes <- apply(digit.trainset, 1, getPlanes)
# print('Compute # of planes for testset. (3-4 min max) grab a coffee in the meanwhile')
# test.planes <- apply(digit.testset, 1, getPlanes)
# 
# print('Compute density of bounding box ratio for trainset.')
# train.boundingboxratio <- apply(digit.trainset, 1, boundingBoxRatio)
# print('Compute density ofbounding box ratio for testset.')
# test.boundingboxratio <- apply(digit.testset, 1, boundingBoxRatio)
# 
# print('Compute pixel density.')
# # add density feature to the dataset
# train.density = apply(digit.trainset[,-c(1)], 1, mean)
# test.density = apply(digit.testset[,-c(1)], 1, mean)
# 
# print('Create Data frames from calculated feature data.')
# digit.trainset.features <- data.frame(label = digit.trainset$label, boundingboxratio = train.boundingboxratio, density = train.density, planes = train.planes)
# digit.testset.features <- data.frame(label = digit.testset$label, boundingboxratio = test.boundingboxratio, density = test.density, planes = test.planes)
# 
# # create a factor of $label
# digit.data$label = as.factor(digit.data$label)
# digit.trainset$label = as.factor(digit.trainset$label)
# digit.testset$label = as.factor(digit.testset$label)
# digit.trainset.features$label = as.factor(digit.trainset.features$label)
# digit.testset.features$label = as.factor(digit.testset.features$label)
# 
# print('Compute which pixels are irrelevant and remove them from the train- and testset. (max == 0)')
# feature.filter <- which(apply(digit.data, 2, max) == 0)
# digit.trainset <- digit.trainset[,-c(feature.filter)]
# digit.testset <- digit.testset[,-c(feature.filter)]
# 
# library(nnet)
# print("Multinomial classification")
# # setup multinomial logit model, which predicts the label using the density feature
# digit.multinom.density <- multinom(label~ scale(density), digit.trainset.features, maxit=1000)
# # predict the labels in the trainset using the multinom model (Density)
# digit.trainset.pred.density <- predict(digit.multinom.density, digit.trainset.features[,-c(1)], type="class")
# # predict the labels in the testset using the multinom model (Density)
# digit.testset.pred.density <- predict(digit.multinom.density, digit.testset.features[,-c(1)], type="class")
# # compute and save the test set accuracy
# digit.testset.pred.density.acc <- acc(table(digit.testset.features$label, digit.testset.pred.density))
# 
# # setup multinomial logit model, which predicts the label using the plane feature
# digit.multinom.planes <- multinom(label~ planes, digit.trainset.features, maxit=1000)
# # predict the labels in the trainset using the multinom model (Plane)
# digit.trainset.pred.planes <- predict(digit.multinom.planes, digit.trainset.features[,-c(1)], type="class")
# # predict the labels in the testset using the multinom model (Plane)
# digit.testset.pred.planes <- predict(digit.multinom.planes, digit.testset.features[,-c(1)], type="class")
# # compute and save the test set accuracy
# digit.testset.pred.planes.acc <- acc(table(digit.testset.features$label, digit.testset.pred.planes))
# 
# # setup multinomial logit model, which predicts the label using the plane feature
# digit.multinom.boundingboxratio <- multinom(label~ boundingboxratio, digit.trainset.features, maxit=1000)
# # predict the labels in the trainset using the multinom model (Plane)
# digit.trainset.pred.boundingboxratio<- predict(digit.multinom.boundingboxratio, digit.trainset.features[,-c(1)], type="class")
# # predict the labels in the testset using the multinom model (Plane)
# digit.testset.pred.boundingboxratio <- predict(digit.multinom.boundingboxratio, digit.testset.features[,-c(1)], type="class")
# # compute and save the test set accuracy
# digit.testset.pred.boundingboxratio.acc <- acc(table(digit.testset.features$label, digit.testset.pred.boundingboxratio))
# 
# # setup multinomial logit model, which predicts the label using both features
# digit.multinom.combi <- multinom(label~ scale(density)+ planes, digit.trainset.features, maxit=1000)
# # predict the labels in the trainset using the multinom model (Density & Plane)
# digit.trainset.pred.combi <- predict(digit.multinom.combi, digit.trainset.features[,-c(1)], type="class")
# # predict the labels in the testset using the multinom model (Density & Plane)
# digit.testset.pred.combi <- predict(digit.multinom.combi, digit.testset.features[,-c(1)], type="class")
# # compute and save the test set accuracy
# digit.testset.pred.combi.acc <- acc(table(digit.testset.features$label, digit.testset.pred.combi))
# 
# # setup multinomial logit model, which predicts the label using both features
# digit.multinom.combi.2 <- multinom(label~ boundingboxratio+planes, digit.trainset.features, maxit=1000)
# # predict the labels in the trainset using the multinom model (Density & Plane)
# digit.trainset.pred.combi.2 <- predict(digit.multinom.combi.2, digit.trainset.features[,-c(1)], type="class")
# # predict the labels in the testset using the multinom model (Density & Plane)
# digit.testset.pred.combi.2 <- predict(digit.multinom.combi.2, digit.testset.features[,-c(1)], type="class")
# # compute and save the test set accuracy
# digit.testset.pred.combi.2.acc <- acc(table(digit.testset.features$label, digit.testset.pred.combi.2))
# 
# digit.multinom.all <- multinom(label~ scale(density)+ planes + boundingboxratio, digit.trainset.features, maxit=1000)
# # predict the labels in the trainset using the multinom model (Density & Plane)
# digit.trainset.pred.all <- predict(digit.multinom.all, digit.trainset.features[,-c(1)], type="class")
# # predict the labels in the testset using the multinom model (Density & Plane)
# digit.testset.pred.all <- predict(digit.multinom.all, digit.testset.features[,-c(1)], type="class")
# # compute and save the test set accuracy
# digit.testset.pred.all.acc <- acc(table(digit.testset.features$label, digit.testset.pred.all))
# 
# print("Multinom logit with LASSO")
# library(glmnet)
# digit.lasso.cv <- cv.glmnet(as.matrix(digit.trainset.features[,-c(1)]), digit.trainset.features[,1], family="multinomial", type.measure="class")
# digit.lasso.cv.pred <- predict(digit.lasso.cv, as.matrix(digit.testset.features[,-c(1)]), type="class")
# digit.lasso.cv.pred.acc <- acc(table(digit.testset.features$label, digit.lasso.cv.pred))
# 
# pixel.digit.lasso.cv <- cv.glmnet(as.matrix(digit.trainset[,-c(1)]), digit.trainset[,1], family="multinomial", type.measure="class")
# pixel.digit.lasso.cv.pred <- predict(pixel.digit.lasso.cv, as.matrix(digit.testset[,-c(1)]), type="class")
# pixel.digit.lasso.cv.pred.acc <- acc(table(digit.testset$label, pixel.digit.lasso.cv.pred))


# print("kNN")
# # kNN <- nnExecAll(digit.trainset.features, 1:100)
# # pixel.kNN <- nnExecAll(digit.trainset, 1:100)
# library(class)
# ks <- 1:100
# test.knn.accs <- c()
# ktjes <- c()
# for(kk in ks)
# {
#   testset.knn <- knn(train = digit.trainset.features[,c(-1)], test = digit.testset.features[,c(-1)], cl = digit.trainset.features$label, k = kk)
#   testset.confm <-  table(digit.testset.features$label, testset.knn)
#   testset.knn.acc <- acc(testset.confm)
#   test.knn.accs <- c(test.knn.accs, testset.knn.acc)
#   ktjes <- c(ktjes,kk)
# }
# 
# print(testset.knn.acc)
# 
# pixel.testset.knn <- knn(train = digit.trainset[,c(-1)], test = digit.testset[,c(-1)], cl = digit.trainset$label, k = 1)
# pixel.testset.confm <-  table(digit.testset$label, pixel.testset.knn)
# pixel.testset.knn.acc <- acc(pixel.testset.confm)
# print(pixel.testset.knn.acc)
print("SVM")
library(e1071)
#Radial kernel
print("Radial kernel feature data")
svm.radial <- svm(digit.trainset.features[,-c(1)], digit.trainset.features[,1], kernel = "radial")

svm.radial.pred.train <- predict(svm.radial, digit.trainset.features[,-c(1)])
svm.radial.pred.train.acc <- sum(diag(table(digit.trainset.features$label,svm.radial.pred.train)))/nrow(digit.trainset.features)
print(paste0("Accuracy feature trainset: ", svm.radial.pred.train.acc))

svm.radial.pred <-  predict(svm.radial, digit.testset.features[,-c(1)])
svm.radial.pred.acc <- sum(diag(table(digit.testset.features$label,svm.radial.pred)))/nrow(digit.testset.features)
print(paste0("Accuracy feature testset: ", svm.radial.pred.acc))

# print("Tuned Radial kernel feature data")
# svm.radial.tune <- tune.svm(digit.trainset.features[, -c(1)],digit.trainset.features[,1],cost=1:25, kernel = "radial")
# print(svm.radial.tune$performances)
# svm.radial.tuned <- svm(label ~ ., data = digit.trainset.features, cost = 12, kernel = "radial")
# svm.radial.pred.tune <- predict(svm.radial.tuned, digit.testset.features[,-c(1)])
# svm.radial.pred.acc.tune <- sum(diag(table(digit.testset.features$label,svm.radial.pred.tune)))/nrow(digit.testset.features)
# print(paste0("Accuracy tuned radial kernel feature testset: ", svm.radial.pred.acc.tune))

print("Linear kernel feature data")
svm.linear <- svm(label ~ ., data = digit.trainset.features, kernel = "linear")
svm.linear.pred <-  predict(svm.linear, digit.testset.features[,-c(1)])
svm.linear.pred.acc <- sum(diag(table(digit.testset.features$label,svm.linear.pred)))/nrow(digit.testset.features)
print(paste0("Accuracy linear kernel feature testset: ", svm.linear.pred.acc))

print("Tuned linear kernel feature data")
svm.linear.tune <- tune.svm(digit.trainset.features[, -c(1)],digit.trainset.features[,1], cost=1:10, kernel="linear")
svm.linear.tuned <- svm(label ~ ., data = digit.trainset.features, cost=1, kernel="linear")
svm.linear.pred.tune <- predict(svm.linear.tuned, digit.testset.features[,-c(1)])
svm.linear.pred.acc.tune <- sum(diag(table(digit.testset.features$label,svm.linear.pred.tune)))/nrow(digit.testset.features)
print(paste0("Accuracy tuned linear kernel feature testset: ", svm.linear.pred.acc.tune))

# Radial kernel
# print("Radial kernel pixel data")
# pixel.svm.radial <- svm(digit.trainset[,-c(1)], digit.trainset[,1], kernel = "radial")
# 
# # predict the trainset
# pixel.svm.radial.pred.train <- predict(pixel.svm.radial, digit.trainset[,-c(1)])
# pixel.svm.radial.pred.train.acc <- sum(diag(table(digit.trainset$label, pixel.svm.radial.pred.train)))/nrow(digit.trainset)
# print(paste0("Accuracy trainset: ", pixel.svm.radial.pred.train.acc))
# 
# # predict the testset
# pixel.svm.radial.pred <-  predict(pixel.svm.radial, digit.testset[,-c(1)])
# pixel.svm.radial.pred.acc <- sum(diag(table(digit.testset$label,pixel.svm.radial.pred)))/nrow(digit.testset)
# print(paste0("Accuracy testset: ", pixel.svm.radial.pred.acc))

# print("Tune Radial kernel pixel data")
# pixel.svm.radial.tune <- tune.svm(digit.trainset[, -c(1)],digit.trainset$label,cost=c(2^(-5:15)), gamma = c(2^(-12:3)))
# pixel.svm.radial.tuned <- svm(label ~ ., data = digit.trainset, cost = 0.5, gamma =  0.0002441406)
# pixel.svm.radial.pred.tune <- predict(pixel.svm.radial.tuned, digit.testset[,-c(1)])
# pixel.svm.radial.pred.acc.tune <- sum(diag(table(digit.testset$label,pixel.svm.radial.pred.tune)))/nrow(digit.testset)
# print(pixel.svm.radial.pred.acc.tune)

print("Linear kernel pixel data")
pixel.svm.linear <- svm(label ~ ., data = digit.trainset, kernel = "linear")
pixel.svm.linear.pred <-  predict(pixel.svm.linear, digit.testset[,-c(1)])
pixel.svm.linear.pred.acc <- sum(diag(table(digit.testset$label,pixel.svm.linear.pred)))/nrow(digit.testset)
print(paste0("Accuracy linear kernel pixel testset: ", pixel.svm.linear.pred.acc))

print("Tuned linear kernel pixel data")
pixel.svm.linear.tune <- tune.svm(digit.trainset[, -c(1)],digit.trainset[,1],cost=1:10, kernel="linear")
pixel.svm.linear.tuned <- svm(label ~ ., data = digit.trainset, cost=1, kernel="linear")
pixel.svm.linear.pred.tune <- predict(pixel.svm.linear.tuned, digit.testset[,-c(1)])
pixel.svm.linear.pred.acc.tune <- sum(diag(table(digit.testset$label,pixel.svm.linear.pred.tune)))/nrow(digit.testset)
print(paste0("Accuracy tuned linear kernel pixel testset: ", pixel.svm.linear.pred.acc.tune))

print('Finished.')