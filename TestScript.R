# COMPLETE CODE FOR PROJECT
print('Load dataset.')
digit.data <- read.csv("Dataset/mnist.csv")  # read csv file 

# create a factor of $label
digit.data$label = as.factor(digit.data$label)

print('Compute pixel density.')
# add density feature to the dataset
digit.data$density = rowMeans(digit.data[,-c(1)])

# create train- and testset
set.seed(1)
sample <- splitData(digit.data, 1000)
digit.trainset <- digit.data[sample[1:1000],]
digit.testset <- digit.data[sample[1001:2000],]

print('Compute # of planes for trainset.')
digit.trainset$planes <- apply(digit.trainset, 1, getPlanes)
print('Compute # of planes for testset.')
digit.testset$planes <- apply(digit.testset, 1, getPlanes)

print('Compute which pixels are irrelevant and removes them from the train- and testset.')
colMeans <- colMeans(digit.data[,-c(1)])
feature.filter <- which(colMeans == 0) + 1
digit.trainset <- digit.trainset[,-c(feature.filter)]
digit.testset <- digit.testset[,-c(feature.filter)]

library(nnet)

# setup multinomial logit model, which predicts the label using the density feature
digit.multinom.density <- multinom(digit.trainset$label~ scale(digit.trainset$density), digit.trainset, maxit=1000)

# predict the labels in the trainset using the multinom model (Density)
digit.trainset.pred.density <- predict(digit.multinom.density, digit.trainset[,-c(1)], type="class")
# predict the labels in the testset using the multinom model (Density)
digit.testset.pred.density <- predict(digit.multinom.density, digit.testset[,-c(1)], type="class")

# setup multinomial logit model, which predicts the label using the plane feature
digit.multinom.planes <- multinom(digit.trainset$label~ digit.trainset$planes, digit.trainset, maxit=1000)
# predict the labels in the trainset using the multinom model (Plane)
digit.trainset.pred.planes <- predict(digit.multinom.planes, digit.trainset[,-c(1)], type="class")
# predict the labels in the testset using the multinom model (Plane)
digit.testset.pred.planes <- predict(digit.multinom.planes, digit.testset[,-c(1)], type="class")

# setup multinomial logit model, which predicts the label using both features
digit.multinom.combi <- multinom(digit.trainset$label~ scale(digit.trainset$density)+digit.trainset$planes, digit.trainset, maxit=1000)
# predict the labels in the trainset using the multinom model (Density & Plane)
digit.trainset.pred.combi <- predict(digit.multinom.combi, digit.trainset[,-c(1)], type="class")
# predict the labels in the testset using the multinom model (Density & Plane)
digit.testset.pred.combi <- predict(digit.multinom.combi, digit.testset[,-c(1)], type="class")

print('Finished.')