filterData <- function(digitData, filter){
  digitData[,-filter]
}

splitData <- function(digitData, sampleSize){
  sample <- sample(nrow(digitData),sampleSize, replace = FALSE)
}

trainData <- function(digitData, sample){
  digitData[sample,]
}

testData <- function(digitData, sample){
  digitData[-sample,]
}

loadData <- function() {
  data.frame(read.csv("Dataset/mnist.csv"))
}

getDigits <- function(digitData) {
  as.factor(digitData$label)
}

getMinimum <- function(digitData) {
  return(1)   
}

#function to determine neighbours which are inactive by looking in all 8 directions
inactiveNeighbours <- function(x, y, digitData){
  inactiveNeighbours = list()
  w = 28
  h = 28
  
  wmin = x - 1 
  wmax = x + 1 
  hmin = y - 1 
  hmax = y + 1
  
return(inactiveNeighbours)
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

getPlanes <- function(digitData) {
  #number of planes of inactive pixels
  visited = list() #counter to store already visited pixels
  planes = 0
  for( x in 1:28) {
    for(y in 1:28) {
      if (digitData[x+28*y] == 0 && visited[x+28*y] == 0){ #if a non-active has never been visited perform a bfs the get all adjacent inactive pixels
        #print "=====New Plane=====", (x,y)
        planes = planes+1
      }
      Queue = Queue$new()
      Queue.push(x+28*y) #initialize bfs-visit
      visited[x+28*y] = 1
      while (!Queue.isEmpty()){ #BFS-visit to find all adjacent inactive pixels
        current = Queue.pop()
      }
      successors = list()
      for (z in successors) {
        if (visited[z] == 0){
          Queue.push(z)
        }
      }
      visited[z] = 1 
    }
  }
  return(planes)
}
