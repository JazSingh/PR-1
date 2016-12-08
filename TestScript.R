# COMPLETE CODE FOR PROJECT

digit.data <- read.csv("Dataset/mnist.csv")  # read csv file 
digit.data <- digit.data[,-c(feature.filter)]

# create a factor of $label
digit.data$label = as.factor(digit.data$label)

# add density feature to the dataset
digit.data$density = rowMeans(digit.data[,-c(1)])

# setup multinomial logit model, which predicts the label using the density feature
digit.data.multinom = multinom(digit.data$label~ scale(digit.data$density), digit.data$label, maxit=1000)

# predict the label of a digit using this model
digit.data.pred <- predict(digit.data.multinom, digit.data[,-c(1)], type="class")

# create a confusion matrix from this prediction
confmat <- table(digit.data$label, digit.data.pred)

# create trainingset and testset
set.seed(1)

randomRows = sample(1:1000)
digit.trainset = digit.data[randomRows,]
digit.testset = digit.data[-c(randomRows),]
rm(randomRows)