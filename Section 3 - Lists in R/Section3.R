#---------------- Section 3: Lists in R

setwd("~/R Programming - Advanced Analytics in R for Data Science/Section 3 - Lists in R/SuperDataScience files")
getwd()

#save workspace
save.image("~/R Programming - Advanced Analytics in R for Data Science/Section 3 - Lists in R/workspaceSection3.RData")

#any combinations of data can be stored in a list, unlike a matrix



#---------------- Project Brief: Machine Utilization - S3, L29

#You have been engaged as a Data Science consultant by a coal terminal. They would like you to investigate one of their heavy machines - RL1
#You have been supplied one month worth of data for all of their machines. The dataset shows what percentage of capacity for each machine was idle (unused) in any given hour. You are required to deliver an R list with the following components:

#1. Character: Machine name
#2. Vector: (min, mean, max) utilisation for the month (excluding unknown hours)
#3. Logical: Has utilisation ever fallen below 90%? TRUE / FALSE
#4. Vector: All hours where utilisation is unknown (NA's)
#5. Dataframe: For this machine
#6. Plot: For all machines



#---------------- Import Data - S3, L30

util <- read.csv("P3-Machine-Utilization.csv")
head(util,12)
str(util)
summary(util)

#Derive Utilization column
util$Utilization = 1 - util$Percent.Idle
head(util,12)



#---------------- Handling Date-Times in R - S3, L31

#are we dealing with American or European timestamps?
tail(util)
?POSIXct   #Portable Operating System Interface (POSIX) calendar time
#stores time as the number of seconds (integer) that passed from the start of the year 1970
#standardizes time form that is compatible between operating systems
#time format that can be interpreted by US-time and EU-time users
#time form that can be stored as a numeric rathar than text (even though it's displayed to the user as text)
#convert data into POSIXct
util$PosixTime <- as.POSIXct(util$Timestamp, format="%d/%m/%Y %H:%M")
head(util,12)
summary(util)
str(util)

#TIP: how to rearrange columns in a df:
util$Timestamp <- NULL     #remove Timestamp col
head(util,12)
util <- util[,c(4,1,2,3)]  #put PosixTime as first col



#---------------- R Programming: What is a List? - S3, L32
#What is a list?
#vector - can contain only elements of the same type
#list - can store different types of elements
summary(util)
RL1 <- util[util$Machine == "RL1",]   #subset data to only include RL1 and all columns
summary(RL1)
RL1$Machine <- factor(RL1$Machine)    #rerun the factor for RL1 to remove unwanted machines
summary(RL1)

#Construct list:
#1. Character: Machine name
#2. Vector: (min, mean, max) utilisation for the month (excluding unknown hours)
#3. Logical: Has utilisation ever fallen below 90%? TRUE / FALSE

#2. Stats vector
util_stats_rl1 <- c(min(RL1$Utilization, na.rm=TRUE),
                    mean(RL1$Utilization, na.rm=TRUE),
                    max(RL1$Utilization, na.rm=TRUE))
util_stats_rl1

#3. Utilization under 90%
which(RL1$Utilization < 0.90)               #has utilization fallen below 90%? Yes; ignores NA, shows which indices are TRUE
length(which(RL1$Utilization < 0.90))       #how MANY values of RL1$Utilization are less than 90%?
length(which(RL1$Utilization < 0.90)) > 0   # > 0 makes it into a logical vector if >0, the TRUE; if <0, then FALSE
util_under_90_flag <- length(which(RL1$Utilization < 0.90)) > 0   
util_under_90_flag

#create list
list_rl1 <- list("RL1", util_stats_rl1, util_under_90_flag)
list_rl1



#---------------- Naming Components of a List - S3, L33

list_rl1
names(list_rl1)  #NULL means there are no names; it's using the default indexation of 1,2,3
names(list_rl1) <- c("Machine", "Stats", "LowThreshold")
list_rl1

#another way. Like with DFs:
rm(list_rl1)
list_rl1 <- list(Machine="RL1", Stats=util_stats_rl1, LowThreshold=util_under_90_flag)
list_rl1



#---------------- Extracting Components of a List: [] vs [[]] vs $ - S3, L34


#three ways:
#1. [] - will always return a list
#2. [[]] - will always return the actual object within the component
#3. $ - same as [[]] but prettier

list_rl1
list_rl1[1]        #still in list form
list_rl1[[1]]      #now in vector form
list_rl1$Machine   #now in vector form

list_rl1[2]
typeof(list_rl1[2])     #list
ist_rl1[[2]]
typeof(list_rl1[[2]])   #double because it's a vector of doubles
list_rl1$Stats
typeof(list_rl1$Stats)  #double because it's a vector of doubles


#how would you access the 3rd element of the vector (maximum utilization)
list_rl1
list_rl1[[2]][3]
#or:
list_rl1$Stats[3]

list_rl1[3]
list_rl1[[3]]
list_rl1$LowThreshold



#---------------- Adding and Deleting List Components - S3, L35

list_rl1
list_rl1[4] <- "New Information"
list_rl1

#another way to add a component - via the $
#we will add: 
#4. Vector: All hours where utilization is unknown (NAs)
RL1
RL1[is.na(RL1$Utilization),"PosixTime"]

list_rl1$UnknownHours <- RL1[is.na(RL1$Utilization),"PosixTime"]
list_rl1

#Remove a component. Use the NULL method:
list_rl1[4] <- NULL
list_rl1
#notice!!: numeration has shifted (unlike DFs, where you have to reset the indices)

#Add another component
#5. Dataframe: For this machine
list_rl1$Data <- RL1   #add RL1 to list_rl1 as new Data col
list_rl1
summary(list_rl1)      #length means how many elements are in that vector
str(list_rl1)



#---------------- Subsetting a List - S3, L36

#how would you access the first time stamp within UnknownHours?
list_rl1[[4]][1]
#or:
list_rl1$UnknownHours[1]

list_rl1[1:2]

list_rl1[c(1,4)]
#or:
list_rl1[c("Machine", "UnknownHours")]

sublist_rl1 <- list_rl1[c("Machine", "Stats")]
sublist_rl1[[2]][2]
#or:
sublist_rl1$Stats[2]


# [[]] - for accessing elements within a list
# [] - for subsetting data

#list_rl1[[1:3]]   ERROR!
#^Error in list_rl1[[1:3]] : recursive indexing failed at level 2
#you can only specify one thing within [[]]



#---------------- Creating a Timeseries Plot - S3, L37

#install.packages("ggplot2")
library(ggplot2)

p <- ggplot(data=util)
p + geom_line(aes(x=PosixTime, y=Utilization,
                  colour=Machine),
              size=0.75) +
  facet_grid(Machine~.) +
  geom_hline(yintercept = 0.90,              #horizontal line at threshold
             colour="Gray", size=1.2,
             linetype=3)
?linetype
myplot <- p + geom_line(aes(x=PosixTime, y=Utilization,
                            colour=Machine),
                        size=0.75) +
  facet_grid(Machine~.) +
  geom_hline(yintercept = 0.90,              #horizontal line at threshold
             colour="Gray", size=1.2,
             linetype=3)

list_rl1$Plot <- myplot
list_rl1
summary(list_rl1)
str(list_rl1)

