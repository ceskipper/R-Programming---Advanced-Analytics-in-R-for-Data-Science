#---------------- Section 4: "Apply" Family of Functions

setwd("~/R Programming - Advanced Analytics in R for Data Science/Section 4 - Apply Family of Functions/SuperDataScience files")
getwd()

save.image("~/R Programming - Advanced Analytics in R for Data Science/Section 4 - Apply Family of Functions/workspaceSection4.RData")

#apply family of functions are like shortcuts for loops in R



#---------------- Project Brief: Weather Patterns - S4, L40
#You are working on a project for a meteorology bureau. You have been supplied weather data for 4 cities in the US: Chicago, NewYork, Houston and SanFrancisco.
#You are required to deliver the following outputs:
#1. A table showing the annual averages of each observed metric for every city
#2. A table showing by how much temperature fluctuates each month from min to max (in %). Take min temperature as the base
#3. A table showing the annual maximums of each observed metric for every city
#4. A table showing the annual minimums of each observed metric for every city
#5. A table showing in which months the annual maximums of each metric were observed in every city (Advanced)



#---------------- Import Data into R - S4, L41
getwd()
setwd("~/R Programming - Advanced Analytics in R for Data Science/Section 4 - Apply Family of Functions/SuperDataScience files/Weather Data")
getwd()
#setwd(".\\Weather Data")    the dot refers to the working directory you're already using

Chicago <- read.csv("Chicago-F.csv", row.names=1)    #row.names=1 takes the row names from the first col
NewYork <- read.csv("NewYork-F.csv", row.names=1)
Houston <- read.csv("Houston-F.csv", row.names=1)
SanFrancisco <- read.csv("SanFrancisco-F.csv", row.names=1)

#when you use the function read.csv(), data are imported as a data frame
#check to make sure it was imported as a DF:
is.data.frame(Chicago)
is.data.frame(NewYork)
is.data.frame(Houston)
is.data.frame(SanFrancisco)

#convert to matrices (because you don't need them to be DFs since all the data are numeric):
Chicago <- as.matrix(Chicago)
NewYork <- as.matrix(NewYork)
Houston <- as.matrix(Houston)
SanFrancisco <- as.matrix(SanFrancisco)
#check:
is.matrix(Chicago)
is.matrix(NewYork)
is.matrix(Houston)
is.matrix(SanFrancisco)

#put all of them into a list:
Weather <- list(Chicago=Chicago, NewYork=NewYork, Houston=Houston, SanFrancisco=SanFrancisco)
Weather
Weather[3]       #returns data as a list
Weather[[3]]     #returns just the component
Weather$Houston  #returns just the component



#---------------- What is the Apply Family? - S4, L42

#apply(MATRIXNAME, 1 or 2, function)     1=rows, 2=columns         function=mean, max, min, etc

#The Apply Family:
#apply - use on a matrix; either the rows or columns
#tapply - use on a vector to extract subgroups and apply a function to them
#by - use on data frames; same concepts as in group by in SQL
#eapply - use on an environment (E)
#lapply - apply a function to elements of a list (L)
#sapply - a version of lapply; can simplify (S) the result so it's not presented as a list
#vapply - has a pre-specified type of return value (V)
#replicate - run a function several times; usually used with generation of random variables; not the same as rep()
#mapply - multivariate (M) version of sapply; arguments can be recycled
#rapply - recursive (R) version of lapply



#---------------- Using apply() - S4, L43

?apply  #apply() used for matrices
apply(Chicago, 1, mean)
#check:
mean(Chicago["DaysWithPrecip",])
#analyze one city:
Chicago
apply(Chicago, 1, max)
apply(Chicago, 1, min)
#for practice:
apply(Chicago, 2, max)   #doesn't make much sense, but good exercise
apply(Chicago, 2, min)
#compare:
apply(Chicago, 1, mean)
apply(NewYork, 1, mean)
apply(Houston, 1, mean)
apply(SanFrancisco, 1, mean)

                              #<<< (nearly) deliverable 1: but there is a faster way



#---------------- Recreating the apply() Function with Loops (Advanced Topic) - S4, L44

Chicago
#find the mean of every row:
#1. via loops
output <- NULL    #preparing an empty vector for our results
for(i in 1:5){    #run cycle
  output[i] <- mean(Chicago[i,])
}
output
names(output) <- rownames(Chicago)
output

#2. via apply function
apply(Chicago, 1, mean)      #faster and simpler (less code) to use the apply() function



#---------------- Using lapply() - S4, L45

?lapply
#lapply - apply a function to a list or vector

Chicago
#transpose Chicago
t(Chicago)
Weather

#example 1: transpose all components of the Weather list
mynewlist <- lapply(Weather, t)    # same as    list(t(Weather$Chicago), t(Weather$NewYork), t(Weather$Houston), t(Weather$SanFrancisco))
mynewlist

#example 2: 
Chicago
rbind(Chicago, NewRow=1:12)
lapply(Weather, rbind, NewRow=1:12)

#example 3: 
?rowMeans    #form row and col sums and means
rowMeans(Chicago)   #identical to apply(Chicago, 1, mean)
lapply(Weather, rowMeans)
                        #<<< (nearly) deliverable 1: even better, but will improve further

#rowMeans
#colMeans
#rowSums
#colSums
lapply(Weather, colMeans)


#---------------- Combining lapply() with []- S4, L46

Weather

Weather$Chicago[1,1]
#or
Weather[[1]][1,1]

#use "[" to access each component of the list:
lapply(Weather, "[", 1, 1)    #"[" refers to the subset single bracket, so .."[", 1, 1... will give you the first row, first column
Weather
lapply(Weather, "[", 1,)      #first row of each component

lapply(Weather, "[", , 3)     #third column of each component
#or
lapply(Weather, "[", , "Mar")
#cleaner:
sapply(Weather, "[", , "Mar")



#---------------- Adding Your Own Functions - S4, L47

lapply(Weather, rowMeans)
lapply(Weather, function(x) x[1,])   #1st row of every matrix
lapply(Weather, function(x) x[5,])   #5th row of every matrix
lapply(Weather, function(x) x[,12])  #December col for each matrix
lapply(Weather, function(z) z[1,] - z[2,])  #difference between 1st and 2nd rows AKA difference between the AvgHigh_F and AvgLow_F
#cleaner:
sapply(Weather, function(z) z[1,] - z[2,])
lapply(Weather, function(z) round((z[1,]-z[2,])/z[2,], 2))   #(.... , 2) is asking for 2 decimal places
                                #<<< deliverable 2: temp fluctuations, will improve

#practice: divide AvgPrecip_inch by DaysWithPrecip
lapply(Weather, function(y) round(y[3,]/y[4,], 2))
sapply(Weather, function(y) round(y[3,]/y[4,], 2))


#---------------- Using sapply() - S4, L48

?sapply
#sapply - simpler version of lapply; for lists and vectors; returns a vector or matrix (depending on the code)

Weather
#AvgHigh_F for July
lapply(Weather, "[", 1,"Jul")
#or
lapply(Weather, "[", 1, 7)


#returns a vector (in this case) instead of a list (like lapply)
sapply(Weather, "[", 1,"Jul")
#or
sapply(Weather, "[", 1, 7)


#AvgHigh_F for 4th quarter:
lapply(Weather, "[", 1, 10:12)
sapply(Weather, "[", 1, 10:12)   #more visually pleasing!! matrix instead of a list

#another example:
lapply(Weather, rowMeans)
sapply(Weather, rowMeans)
round(sapply(Weather, rowMeans), 2)    #<<< deliverable 1: awesome!

#another example:
lapply(Weather, function(z) round((z[1,]-z[2,])/z[2,], 2))
sapply(Weather, function(z) round((z[1,]-z[2,])/z[2,], 2))  #<<< deliverable 2!

#by the way:
sapply(Weather, rowMeans, simplify=FALSE)  #same as lapply



#---------------- Nesting apply() Functions- S4, L49
Weather
lapply(Weather, rowMeans)
?rowMeans

#how do we get the row maximums?
Chicago
apply(Chicago, 1, max)  #treat this like your own function

#apply across whole list:
lapply(Weather, apply, 1, max)   #preferred approach
#or:
lapply(Weather, function(x) apply(x, 1, max))

#tidy up:
sapply(Weather, apply, 1, max)   #<<< deliverable 3
#or:
sapply(Weather, function(x) apply(x, 1, max))

sapply(Weather, apply, 1, min)   #<<< deliverable 4
       


#---------------- which.max() and which.min() (Advanced Topic) - S4, L50
#which.max() - finds the location of the maximum value of a numeric (or logical) vector
#which.min() - finds the location of the minimum value of a numeric (or logical) vector
?which.max
Chicago[1,]
which.max(Chicago[1,])
names(which.max(Chicago[1,]))  #tells you the name of the output location

#need to iterate over each row of each matrix...
#sounds like we will have to:
#lapply or sapply - to iterate over a component of the list
apply(Chicago, 1, function(x) names(which.max(x)))   #x = (Chicago[1,])
#iterate the above apply function over the entire list:
lapply(Weather, function(y) apply(y, 1, function(x) names(which.max(x))))   #see 9:15 of lecture 50 if confused!
sapply(Weather, function(y) apply(y, 1, function(x) names(which.max(x))))   #<<< deliverable 5



#---------------- Deliverables:
#1. A table showing the annual averages of each observed metric for every city
round(sapply(Weather, rowMeans), 2)    #<<< deliverable 1: awesome!

#2. A table showing by how much temperature fluctuates each month from min to max (in %). Take min temperature as the base
sapply(Weather, function(z) round((z[1,]-z[2,])/z[2,], 2))  #<<< deliverable 2!

#3. A table showing the annual maximums of each observed metric for every city
sapply(Weather, apply, 1, max)   #<<< deliverable 3

#4. A table showing the annual minimums of each observed metric for every city
sapply(Weather, apply, 1, min)   #<<< deliverable 4

#5. A table showing in which months the annual maximums of each metric were observed in every city (Advanced)
sapply(Weather, function(y) apply(y, 1, function(x) names(which.max(x))))    #<<< deliverable 5


