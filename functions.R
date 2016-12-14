filterData <- function(digitData, filter){
  digitData[,-filter]
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

getMinimum <- function(digitData) {
  return(1)   
}

Queue <- setRefClass(Class = "Queue",
   fields = list(
     name = "character",
     data = "list"
   ),
   methods = list(
     size = function() {
       'Returns the number of items in the queue.'
       return(length(data))
     },
     #
     push = function(item) {
       'Inserts element at back of the queue.'
       data[[size()+1]] <<- item
     },
     #
     pop = function() {
       'Removes and returns head of queue (or raises error if queue is empty).'
       if (size() == 0) stop("queue is empty!")
       value <- data[[1]]
       data[[1]] <<- NULL
       value
     },
     #
     poll = function() {
       'Removes and returns head of queue (or NULL if queue is empty).'
       if (size() == 0) return(NULL)
       else pop()
     },
     #
     peek = function(pos = c(1)) {
       'Returns (but does not remove) specified positions in queue (or NULL if any one of them is not available).'
       if (size() < max(pos)) return(NULL)
       #
       if (length(pos) == 1) return(data[[pos]])
       else return(data[pos])
     },
     initialize=function(...) {
       callSuper(...)
       #
       # Initialise fields here (place holder)...
       #
       .self
     }
   )
)

#function to determine neighbours which are inactive by looking in all 8 directions
inactiveNeighbours <- function(index, digit){
  inactive <- c()
  
  start <- 2
  
  i <- index - 2
  x <- i %% 28 + 1
  y <- i %/% 28 + 1
  
  left <- index - 1
  right <- index + 1
  up <- index - 28
  down <- index + 28
  
  lup <- up - 1
  rup <- up + 1
  ldown <- down - 1
  rdown <- down + 1
  
  if(x - 1 > 0 && digit[left] == 0) {
    inactive <- c(inactive, left)
  }
  if(x + 1 < 29 && digit[right] == 0) {
    inactive <- c(inactive, right)
  }
  if(y - 1 > 0 && digit[up] == 0) {
    inactive <- c(inactive, up)
  }
  if(y + 1 < 29 && digit[down] == 0) {
    inactive <- c(inactive, down)
  }
  
  if(x - 1 > 0 && y - 1 > 0 && digit[lup] == 0) {
    inactive <- c(inactive, lup)
  }
  
  if(x + 1 < 29 && y - 1 > 0 && digit[rup] == 0) {
    inactive <- c(inactive, rup)
  }
  
  if(x - 1 > 0 && y + 1 < 29 && digit[ldown] == 0) {
    inactive <- c(inactive, ldown)
  }
  
  if(x + 1 < 29 && y + 1 < 29 && digit[rdown] == 0) {
    inactive <- c(inactive, rdown)
  }
  inactive <- sort(inactive)
  return(inactive)
}

getPlanes <- function(digit) {
  visited <- c(1)
  planes <- 0
  start <- 2
  for(x in 2:length(digit)) {
    if(digit[x] == 0 && !is.element(x, visited)) {
      planes <- planes + 1
      queue <- Queue$new()
      queue$push(x)
      visited <- c(visited, x)
      while(queue$size() != 0) {
        current <- queue$pop()
        successors <- inactiveNeighbours(current, digit)
        for(z in successors){
          if(!is.element(z, visited)){
            queue$push(z)
            visited <- c(visited, z)
          }
        }
      }
    }
  }
  return(planes)
}
splitData <- function(digitData, sampleSize){
  sample <- sample(nrow(digitData),2*sampleSize, replace = FALSE)
  return(sample)
}

boundingBoxRatio <- function(digitData) {
  xmax <- 0
  ymax <- 0
  xmin <- 28
  ymin <- 28
  
  for(p in 2:length(digitData)) {
    if(digitData[p] > 0) {
      x <- p %% 28
      y <- p %/% 28
      xmin <- min(xmin, x)
      xmax <- max(xmax, x)
      ymax <- max(ymax, y)
      ymin <- min(ymin, y)
    }
  }
  bbox <- ((xmax - xmin)  * (ymax - ymin))
  return(log(sum(digitData)) / bbox)
}

acc <- function(confmat) {
  return(sum(diag(confmat))/sum(confmat))
}

nnExec <- function(trainset, testset, kn) {
  print(paste("kNN:", kn, sep=" "))
  
  trainset.knn <- knn(train = trainset, test = trainset, cl = trainset$label, k =  kn)
  trainset.confm <-  table(trainset$label, trainset.knn)
  trainset.acc <- acc(trainset.confm)
  
  testset.knn <- knn(train = trainset, test = testset, cl = trainset$label, k =  kn)
  testset.confm <-  table(testset$label, testset.knn)
  testset.acc <- acc(testset.confm)
  
  return(c(trainset.acc, testset.acc))
}

nnExecAll <- function(trainset, testset, kns){
  library(class)
  k <- c()
  train.acc <- c()
  test.acc <- c()
  for(kn in kns){
    res <- nnExec(trainset, testset, kn)
    k <- c(k,kn)
    train.acc <- c(train.acc, res[1])
    test.acc <- c(test.acc, res[2])
  }
  return(data.frame(k,train.acc, test.acc))
}

svmExec <- function(trainset, testset){
  library(e1071)
  
  print(paste("SVM:", c, sep=" "))
  
  model <- svm(label ~ ., data = trainset)
  tuneResult <- tune(model, label ~.,  data = trainset, kernel= "radial", ranges = list(gamma = 2^(-1:1), epsilon = seq(0,1,0.1), cost = 2^(2:9), tunecontrol = tune.control(sampling = "fix")))
  
  trainset.svm <-  predict(model, trainset[,c(-1)])
  trainset.confm <-  table(trainset$label, trainset.svm)
  trainset.acc <- acc(trainset.confm)
  
  testset.svm <-  predict(model, testset[,c(-1)])
  testset.confm <-  table(testset$label, testset.svm)
  testset.acc <- acc(testset.confm)
  
  return(c(trainset.acc, testset.acc))
}

svmExecAll <- function(trainset, testset, costRange) {
  library(e1071)
  cost <- c()
  train.acc <- c()
  test.acc <- c()
  for(c in costRange){
    res <- svmExec(trainset, testset, c)
    cost <- c(cost,c)
    train.acc <- c(train.acc, res[1])
    test.acc <- c(test.acc, res[2])
  }
  return(data.frame(cost,train.acc, test.acc))
}