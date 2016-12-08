# COMPLETE CODE FOR PROJECT
print('Load dataset.')
digit.data <- read.csv("Dataset/mnist.csv")  # read csv file 

# create a factor of $label
digit.data$label = as.factor(digit.data$label)

print('Compute pixel density.')
# add density feature to the dataset
digit.data$density = rowMeans(digit.data[,-c(1)])

# create train- and testset
sample <- splitData(digit.data, 1000)
digit.trainset <- digit.data[sample[1:1000],]
digit.testset <- digit.data[sample[1001:2000],]

print('Compute # of planes for trainset.')
digit.trainset$planes <- apply(digit.trainset, 1, getPlanes)
print('Compute # of planes for testset.')
digit.testset$planes <- apply(digit.testset, 1, getPlanes)

print('Compute which pixels are irrelevant and removes them from the train- and testset.')
colMeans <- colMeans(digit.data[,-c(1)])
feature.filter <- which(colMeans < 1)
digit.trainset <- digit.trainset[,-c(feature.filter)]
digit.testset <- digit.testset[,-c(feature.filter)]


# setup multinomial logit model, which predicts the label using the density feature
# digit.data.multinom = multinom(digit.data$label~ scale(digit.data$density), digit.data, maxit=1000)
# 
# # predict the label of a digit using this model
# digit.data.pred <- predict(digit.data.multinom, digit.data[,-c(1)], type="class")
# 
# # create a confusion matrix from this prediction
# confmat <- table(digit.data$label, digit.data.pred)

print('Finished.')