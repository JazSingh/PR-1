<<<<<<< HEAD
filterData <- function(digitData, filter){
  digitData[,-filter]
}

splitData <- function(digitData, sampleSize){
  sample <- sample(nrow(digitData),sampleSize, replace = FALSE)
  digitData[sample,]
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
=======
filterData <- function(digitData, filter){
  digitData[,-filter]
}

splitData <- function(digitData, sampleSize){
  sample <- sample(nrow(digitData),2*sampleSize, replace = FALSE)
  return(sample)
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

trainData <- function(digitData, sample){
  digitData[sample,]
}

testData <- function(digitData, sample){
  digitData[-sample,]
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
>>>>>>> d4fff1284f2396e7c9afaec23c5109825369f7f4
}