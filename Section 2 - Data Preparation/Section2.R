#---------------- Section 2: Data Preparation

#Data from: https://www.superdatascience.com/pages/rcourse-advanced

#--The Challenge:
#You have been hired by the "Future 500" magazine*. The stakeholders have supplied you a list of 500 companies and would like you to create some draft visualisations for their upcoming online publication.
#They have requested the following charts:
#1. A scatterplot classified by industry showing revenue, expenses, profit
#2. A scatterplot that includes industry trends for the expenses~revenue relationship
#3. BoxPlots showing growth by industry
#Note that the dataset has numerous discrepancies that need to be addressed before analysis can be performed.



#---------------- Import Data into R - S2, L9

getwd()


#type out path:
#setwd("C:\\Users\\cskip\\Documents\\R Programming - Advanced Analytics in R for Data Science\\Section 2 - Data Preparation\\SuperDataScience files")

#set wd from Files on right:
setwd("~/R Programming - Advanced Analytics in R for Data Science/Section 2 - Data Preparation/SuperDataScience files")
getwd()

#Basic data import: fin <- read.csv("P3-Future-500-The-Dataset.csv")
fin <- read.csv("P3-Future-500-The-Dataset.csv", na.strings=c(""))
head(fin, 20)
tail(fin, 3)
str(fin)
summary(fin)
#many factors in this data set!



#---------------- What are Factors? (Refresher) - S6, L10

#Factor - a categorical variable in R

#ex: Industry = factor with 8 levels
#R assigns each factor level a number

#don't want/need ID and Inception variabesl recognized as integers; change to factors
#Revenue and Expenses variables recognized as factors because they have $ and , in the data - these characters prevent R from recognizing these variables as integers


#Changing from non-factor to factor:
factor(fin$ID)               #make ID a factor
fin$ID <- factor(fin$ID)     #override ID in DF with newly factored ID var
summary(fin)
str(fin)


fin$Inception <- factor(fin$Inception)
summary(fin)
str(fin)



#---------------- The Factor Variable Trap (FVT) - S2, L11

#FVT comes into play when you're trying to change a variable from a factor to a non-factor

#Converting into Numerics for Characters:
a <- c("12", "13", "14", "12", "12")
a
typeof(a)
b <- as.numeric(a)
b
typeof(b)


#Converting into Numerics for Factors:
z <- factor(c("12", "13", "14", "12", "12"))
z
typeof(z)     #PROBLEM!!: R recognizes the factorization/levels/categories of z (1, 2, 3, 1, 1) instead of the actual numbers (12, 13, 14, 12, 12)
#wrong way:
y <- as.numeric(z)
y
typeof(y)

#--Correct way to convert factor to numeric:
#convert factor var to character, then convert character to numeric:
as.character(z)
x <- as.numeric(as.character(z))
x
typeof(x)



#---------------- FVT Example - S2, L12
head(fin)
str(fin)

#need to convert Revenue and Expenses to numeric variables

#example: let's say Profit was recognized by R as a factor (even though it's numeric)
#fin$Profit <- factor(fin$Profit)      #DANEROUS!! make Profit into a factor for this example
str(fin)
head(fin)
summary(fin)
#fin$Profit <- as.numeric(fin$Profit)  #novice method: trying to change Profit from a factor to a numeric var; doesn't work!
str(fin)                               #PROBLEM!!: R just took the levels of the factorized Profit variable and kept those levels as the new data values
head(fin)                              #now you've overriden your Profit data....which is bad!



#---------------- gsub() and sub() - S2, L13

?sub
sub()         #replaces only the first match
gsub()        #replaces ALL matches

fin$Expenses <- gsub(" Dollars","", fin$Expenses)   #replace " Dollars" with "" (nothing) in the Expenses variable
fin$Expenses <- gsub(",","", fin$Expenses)
head(fin)
str(fin)   #Expenses is now a character, not a factor anymore

fin$Revenue <- gsub("\\$","", fin$Revenue)  #because $ is a special character in R, you must use an escape sequence - in this case \\
fin$Revenue <- gsub(",","", fin$Revenue)
head(fin)
str(fin)   #Revenue is now a character, not a factor anymore

fin$Growth <- gsub("%","", fin$Growth)


#Convert from character into numeric:
#these variables were already converted into charcters by the gsub() function
fin$Expenses <- as.numeric(fin$Expenses)
fin$Revenue <- as.numeric(fin$Revenue)
fin$Growth <- as.numeric(fin$Growth)
str(fin)
summary(fin)



#---------------- Dealing With Missing Data - S2, L14

#1. Predict with 100% accuracy
#2. Leave record as is
#3. Remove record entirely
#4. Replace with mean or median (median preferred because it's less affected by outliers)
#5. Fill in by exploring correlations and similarities (use regressions or models to predict values for empty cells)
#6. Introduce dummy variable for "Missingness" (used to explore missing data)

#see "P3-Future-500-Marked-Up.xlsx" file to see what we're doing



#---------------- What is NA? - S2, L15

#NA - the 3rd logical constant
?NA

#logical constants:
TRUE   #1
FALSE  #0
NA     

TRUE == FALSE      #false
TRUE == 5          #false
TRUE == 1          #true
FALSE == 4         #false
FALSE == FALSE     #true
FALSE == 0         #true
NA == TRUE         #NA
NA == FALSE        #NA
NA == 15           #NA
NA == NA           #NA; you can't compare a missing value to anything...because it's missing



#---------------- Locating Missing Data - S2, L16
head(fin,24)

#Filter for only cases with missing data:
#updated import to: fin <- read.csv("P3-Future-500-The-Dataset.csv", na.strings=c(""))
fin[!complete.cases(fin),]   #! means opposite; will only pick up NAs (won't pick up blank cells or <NA>) if you do not include na.strings= in your import!
str(fin)
#why do some NAs have brackets and some don't? - factors will have brackets (to help you see they're true NAs instead of a category with abbreviation NA), others won't



#---------------- Filtering: using which() for Non-Missing Data - S2, L17
head(fin)
#filter for 9746272:
fin[fin$Revenue == 9746272,]    #picks up NAs, and R doesn't know what to do with NAs in this case, so it provides those rows in your filter output
#which() looks through your vector and only picks out TRUE values; ignores NAs and FALSEs
which(fin$Revenue == 9746272)
fin[which(fin$Revenue == 9746272),]
head(fin)

fin[fin$Employees == 45,]         #filter for  45 employees
fin[which(fin$Employees == 45),]  #remove NAs from output



#---------------- Filtering: using is.na() for Missing Data - S2, L18
head(fin,24)
#which rows in the Expenses column have NA values?
#cannot do this because you cannot compare anything to NA: fin[fin$Expenses == NA,]

#is.na() - checks if something is an NA
is.na()

a <- c(1,24,543,NA,76,45,NA)
is.na(a)

is.na(fin$Expenses)         #TRUE/FALSE for NA in Expenses column
fin[is.na(fin$Expenses),]   #only picks out NAs in Expenses column

fin[is.na(fin$State),]



#---------------- Removing Records with Missing Data - S2, L19
#ALWAYS make a backup!!
fin_backup <- fin


fin[!complete.cases(fin),]    #find all NAs
fin[is.na(fin$Industry),]
fin[!is.na(fin$Industry),]    #opposite (which rows are not NA)

#remove rows with NAs in Industry col
fin <- fin[!is.na(fin$Industry),]   #override fin with subsetted data
fin



#---------------- Resetting the Dataframe Index - S2, L20

#when we removed the NAs from Industry, we removed two rows
#BUT the DF row numbers did not change! - because they're not row numbers; they're ROW NAMES

#option 1:
rownames(fin) <- 1:nrow(fin)
fin

#option 2:
rownames(fin) <- NULL
fin


#---------------- Replacing Missing Data: Factual Analysis Method - S2, L21
#Factual Analysis Method = restore data with 100% certainty
fin[!complete.cases(fin),]

#restore values in State col:
fin[is.na(fin$State),]   #find NAs in State col

fin[is.na(fin$State) & fin$City=="New York",]
fin[is.na(fin$State) & fin$City=="New York", "State"] <- "NY"
#check:
fin[c(11,377),]


fin[is.na(fin$State) & fin$City=="San Francisco",]
fin[is.na(fin$State) & fin$City=="San Francisco", "State"] <- "CA"
#check:
fin[c(82,265),]



#---------------- Replacing Missing Data: Median Imputation Method (Part 1) - S2, L22
#Median Imputation Method = replaces missing values with the median (or mean) value of the column
#can be used for the entire column or by a filtered version of the column (can be more specific/accurate)
fin[!complete.cases(fin),]
fin[is.na(fin$Employees),]

#Employees: Retail Industry
med_empl_retail <- median(fin[fin$Industry=="Retail","Employees"], na.rm=TRUE)  #filter for only Retail Industry rows within Employees column, removed NAs
#mean(fin[,"Employees"], na.rm=TRUE)
med_empl_retail

#Replace NAs in Employees col (within Retail Industry) with the med_empl_retail
fin[is.na(fin$Employees) & fin$Industry=="Retail",]
fin[is.na(fin$Employees) & fin$Industry=="Retail", "Employees"] <- med_empl_retail
#check:
fin[3,]


#Employees: Financial Services Industry
med_empl_finserv <- median(fin[fin$Industry=="Financial Services","Employees"], na.rm=TRUE)  #filter for only Financial Services Industry rows within Employees column, removed NAs
med_empl_finserv

#Replace NAs in Employees col (within Financial Services Industry) with the med_empl_finserv
fin[is.na(fin$Employees) & fin$Industry=="Financial Services",]
fin[is.na(fin$Employees) & fin$Industry=="Financial Services", "Employees"] <- med_empl_finserv
#check:
fin[330,]



#---------------- Replacing Missing Data: Median Imputation Method (Part 1) - S2, L23

fin[!complete.cases(fin),]
fin[is.na(fin$Growth),]

#Growth:
med_growth_constr <- median(fin[fin$Industry=="Construction","Growth"], na.rm=TRUE)  
med_growth_constr

fin[is.na(fin$Growth) & fin$Industry=="Construction",]
fin[is.na(fin$Growth) & fin$Industry=="Construction", "Growth"] <- med_growth_constr
#check:
fin[8,]

fin[!complete.cases(fin),]



#---------------- Replacing Missing Data: Median Imputation Method (Part 3) - S2, L24

fin[is.na(fin$Revenue),]

#Revenue:
med_rev_constr <- median(fin[fin$Industry=="Construction","Revenue"], na.rm=TRUE)  
med_rev_constr
fin[is.na(fin$Revenue) & fin$Industry=="Construction",]
fin[is.na(fin$Revenue) & fin$Industry=="Construction", "Revenue"] <- med_rev_constr
#check:
fin[c(8,42),]

fin[is.na(fin$Expenses),]


#Expenses:
#Be careful here! Only for certain ones
#We don't want to replace that one that's by itself (because then that row won't add up). It has a Profit number, so we can derive the Expenses from the Profit and Revenue for that row.
med_exp_constr <- median(fin[fin$Industry=="Construction","Expenses"], na.rm=TRUE)  
med_exp_constr
fin[is.na(fin$Expenses) & fin$Industry=="Construction" & is.na(fin$Profit),]
fin[is.na(fin$Expenses) & fin$Industry=="Construction" & is.na(fin$Profit), "Expenses"] <- med_exp_constr     #added layer of protection (Profit = NA) so we don't accidentally override the one row with a profit  
#check:
fin[c(8,42),]

fin[!complete.cases(fin),]



#---------------- Replacing Missing Data: Deriving Values Method - S2, L25

#Profit = Revenue - Expenses
fin[is.na(fin$Profit),]
fin[is.na(fin$Profit), "Profit"] <- fin[is.na(fin$Profit), "Revenue",] - fin[is.na(fin$Profit), "Expenses"]
#check:
fin[c(8,42),]


#Expenses = Revenue - Profit
fin[is.na(fin$Expenses),]
fin[is.na(fin$Expenses), "Expenses"] <- fin[is.na(fin$Expenses), "Revenue"] - fin[is.na(fin$Expenses), "Profit"]
#check:
fin[15,]

fin[!complete.cases(fin),]



#---------------- Visualizing Results - S2, L26

#install.packages("ggpplot2")
library(ggplot2)

#1. A scatterplot classified by industry showing revenue, expenses, profit
p <- ggplot(data=fin)
p + geom_point(aes(x=Revenue, y=Expenses, 
                   colour=Industry, size=Profit))


#2. A scatterplot that includes industry trends for the expenses~revenue relationship
d <- ggplot(data=fin, aes(x=Revenue, y=Expenses,
                        colour=Industry))

d + geom_point() +
  geom_smooth(fill=NA, size=1.2)


#3. BoxPlots showing growth by industry
f <- ggplot(data=fin, aes(x=Industry, y=Growth, 
                          color=Industry))
f + geom_jitter() + 
  geom_boxplot(size=0.75, alpha=0.5, outlier.color=NA)
