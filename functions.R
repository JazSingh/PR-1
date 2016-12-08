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

buildQuantiles <- function(digitData) {
  cols <- c(0,.25, .50, .75, .90, .95, .99,1)
  df <- matrix(ncol = 8)
  for(pixel in 2:ncol(digitData)){
    de <- quantile(digitData[, pixel], cols)
    df <- rbind(df, de)
  }
  data.frame(df)
}