filterData <- function(digitData, filter){
  digitData[,-filter]
}

splitData <- function(digitData, sampleSize){
  sample <- sample(nrow(digitData),sampleSize, replace = FALSE)
  c(digitData[sample,], digitData[-sample,])
}

loadData <- function() {
  data.frame(read.csv("Dataset/mnist.csv"))
}

getDigits <- function(digitData) {
  as.factor(digitData$label)
}