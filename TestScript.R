dataset <- read.csv("Dataset/mnist.csv")  # read csv file 

set.seed(1)

randomRows = sample(1:1000)
trainingset = dataset[randomRows,]
testset = dataset[-c(randomRows),]
# 
# trainingset.0 <- trainingset[which(trainingset[,1] == 0),]
# trainingset.1 <- trainingset[which(trainingset[,1] == 1),]
# trainingset.2 <- trainingset[which(trainingset[,1] == 2),]
# trainingset.3 <- trainingset[which(trainingset[,1] == 3),]
# trainingset.4 <- trainingset[which(trainingset[,1] == 4),]
# trainingset.5 <- trainingset[which(trainingset[,1] == 5),]
# trainingset.6 <- trainingset[which(trainingset[,1] == 6),]
# trainingset.7 <- trainingset[which(trainingset[,1] == 7),]
# trainingset.8 <- trainingset[which(trainingset[,1] == 8),]
# trainingset.9 <- trainingset[which(trainingset[,1] == 9),]
# 
# length(trainingset.0)


density <- function(argument){
  return (rowMeans(argument))
}

# get mean per digit

digits <- as.factor(mnist$label)
agg <- aggregate(x = mnist[, 2:ncol(mnist)], by = list(digits), mean, na.rm = T)
digitMeans <- rowMeans(agg[2:ncol(agg)])
show('Digit means:');
show(digitMeans)


