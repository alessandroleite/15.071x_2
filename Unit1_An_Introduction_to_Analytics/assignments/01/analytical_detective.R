# If you downloaded and installed R in a location other than the United States, you might encounter
# some formating issues later in this class due to language differences. To fix this, you will need to
# type in your R console:

Sys.setlocale("LC_ALL", "C")

# This will only change the locale for your current R session, so please make a
# note to run this command when you are working on any lectures or exercises
# that might depend on the English language (for example, the names for the
# days of the week).

# ##################################################################################################

mvt = read.csv(file = 'data/mvtWeek1.csv')

# ID: a unique identifier for each observation
# Date: the date the crime occurred
# LocationDescription: the location where the crime occurred
# Arrest: whether or not an arrest was made for the crime (TRUE if an arrest was made, and FALSE if an arrest was not made)
# Domestic: whether or not the crime was a domestic crime, meaning that it was committed against a family member (TRUE if it was domestic, and FALSE if it was not domestic)
# Beat: the area, or "beat" in which the crime occurred. This is the smallest regional division defined by the Chicago police department.
# District: the police district in which the crime occured. Each district is composed of many beats, and are defined by the Chicago Police Department.
# CommunityArea: the community area in which the crime occurred. Since the 1920s, Chicago has been divided into what are called "community areas", of which there are now 77. The community areas were devised in an attempt to create socially homogeneous regions.
# Year: the year in which the crime occurred.
# Latitude: the latitude of the location at which the crime occurred.
# Longitude: the longitude of the location at which the crime occurred.


# How many rows of data (observations) are in this dataset?
nrow(mvt)

# How many variables are in this dataset?
ncol(mvt)

# Using the "max" function, what is the maximum value of the variable "ID"?
max(mvt$ID)

# What is the minimum value of the variable "Beat"?
min(mvt$Beat)

# How many observations have value TRUE in the Arrest variable (this is the number of crimes for which an arrest was made)?
nrow(subset (mvt, Arrest == TRUE))

# How many observations have a LocationDescription value of ALLEY?
nrow(subset(mvt, LocationDescription == 'ALLEY'))

# In many datasets, like this one, you have a date field. Unfortunately, R does not automatically
# recognize entries that look like dates. We need to use a function in R to extract the date and
# time. Take a look at the first entry of Date (remember to use square brackets when looking at a
# certain entry of a variable).

# In what format are the entries in the variable Date?
mvt$Date[1] #12/31/12 23:15 -> MM/dd/YY HH:MM

# Now, let's convert these characters into a Date object in R. In your R console, type 

DateConvert = as.Date(strptime(mvt$Date, "%m/%d/%y %H:%M"))

# This converts the variable "Date" into a Date object in R. Take a look at the variable DateConvert using the summary function.
# What is the month and year of the median date in our dataset? Enter your answer
# as "Month Year", without the quotes. (Ex: if the answer was 2008-03-28, you would give the answer "March 2008", without the quotes.)

media(DateConvert) # May 2006

# Now, let's extract the month and the day of the week, and add these variables to our data frame mvt. We can do this with two simple functions. Type the following commands in R:

mvt$Month = months(DateConvert)

mvt$Weekday = weekdays(DateConvert)

# This creates two new variables in our data frame, Month and Weekday, and sets
# them equal to the month and weekday values that we can extract from the Date
# object. Lastly, replace the old Date variable with DateConvert by typing:

mvt$Date = DateConvert

# Using the table command, answer the following questions.

# In which month did the fewest motor vehicle thefts occur?
table(mvt$Month) # February, 13511

# On which weekday did the most motor vehicle thefts occur?
table(mvt$Weekday) # Friday

# Each observation in the dataset represents a motor vehicle theft, and the
# Arrest variable indicates whether an arrest was later made for this theft.
# Which month has the largest number of motor vehicle thefts for which an
# arrest was made?

table(mvt$Arrest, mvt$Month) # Janurary, 1435

# Now, let's make some plots to help us better understand how crime has
# changed over time in Chicago. Throughout this problem, and in general, you
# can save your plot to a file. For more information, this website (http://www.stat.berkeley.edu/~s133/saving.html) 
# very clearly explains the process.

# First, let's make a histogram of the variable Date. We'll add an extra argument, to specify the number of bars we want in our histogram. In your R console, type

hist(mvt$Date, breaks=100)

# Looking at the histogram, answer the following questions.

# In general, does it look like crime increases or decreases from 2002 - 2012?

# Decreases

# In general, does it look like crime increases or decreases from 2005 - 2008?

# Decreases

# In general, does it look like crime increases or decreases from 2009 - 2011?

# Increases

# Now, let's see how arrests have changed over time. Create a boxplot of the variable "Date", sorted
# by the variable "Arrest" (if you are not familiar with boxplots and would like to learn more,
# check out this tutorial (http://msenux.redwoods.edu/math/R/boxplot.php)). In a boxplot, the bold
# horizontal line is the median value of the data, the box shows the range of values between the
# first quartile and third quartile, and the whiskers (the dotted lines extending outside the box)
# show the minimum and maximum values, excluding any outliers (which are plotted as circles).
# Outliers are defined by first computing the difference between the first and third quartile
# values, or the height of the box. This number is called the Inter-Quartile Range (IQR). Any point
# that is greater than the third quartile plus the IQR or less than the first quartile minus the IQR
# is considered an outlier.

# Does it look like there were more crimes for which arrests were made in the
# first half of the time period or the second half of the time period? (Note
# that the time period is from 2001 to 2012, so the middle of the time period
# is the beginning of 2007.)

boxplot(mvt$Date ~ mvt$Arrest) # First half

# PROBLEM 3.3 - VISUALIZING CRIME TRENDS  (2 points possible)
# Let's investigate this further. Use the table function for the next few questions.

# For what proportion of motor vehicle thefts in 2001 was an arrest made?

table (mvt$Arrest, mvt$Year)

proportion <- 2152 / (18517 + 2152) # (0.1041173) It is the number of arrests made in 2001 divided by the total number of thefts in this year.


# Note: in this question and many others in the course, we are asking for an answer as a proportion. Therefore, your answer should take a value between 0 and 1.


# PROBLEM 3.4 - VISUALIZING CRIME TRENDS  (1 point possible)
# For what proportion of motor vehicle thefts in 2007 was an arrest made?

proportion <- 1212 / (13068 + 1212) # (0.08487395) It is the number of arrests made in 2007 divided by the total number of thefts in this year

# PROBLEM 3.5 - VISUALIZING CRIME TRENDS  (1 point possible)
# For what proportion of motor vehicle thefts in 2012 was an arrest made?

proportion <- 550 / (13542 + 550) # (0.03902924) It is the number of arrests made in 2007 divided by the total number of thefts in this year

# After, see the package described in this thread (http://stackoverflow.com/questions/15009011/calculate-proportions-within-subsets-of-a-data-frame)

# Since there may still be open investigations for recent crimes, this could explain the trend we
# are seeing in the data. There could also be other factors at play, and this trend should be
# investigated further. However, since we don't know when the arrests were actually made, our
# detective work in this area has reached a dead end.

# What is factor? One important way R can store data is as a factor. Often times an experiment
# includes trials for different levels of some explanatory variable. For example, when looking at
# the impact of carbon dioxide on the growth rate of a tree you might try to observe how different
# trees grow when exposed to different preset concentrations of carbon dioxide. The different levels
# are also called factors. When you use "summary" on a factor it does not print out the five point
# summary, rather it prints out the possible values and the frequency that they occur. A set of
# factors have a discrete set of possible values, and it does not make sense to try to find averages
# or other numerical descriptions.

# PROBLEM 4.1 - POPULAR LOCATIONS  (1 point possible) 

# Analyzing this data could be useful to the Chicago Police Department when deciding where to
# allocate resources. If they want to increase the number of arrests that are made for motor vehicle
# thefts, where should they focus their efforts?

# We want to find the top five locations where motor vehicle thefts occur. If you create a table of
# the LocationDescription variable, it is unfortunately very hard to read since there are 78
# different locations in the data set. By using the sort function, we can view this same table, but
# sorted by the number of observations in each category. In your R console, type:

top5MotorVehicleTheftsLocation <- sort(table(mvt$LocationDescription), decreasing = TRUE)

# Which locations are the top five locations for motor vehicle thefts, excluding the "Other"
# category? You should select 5 of the following options.

# STREET, PARKING LOT/GARAGE(NON.RESID.), ALLEY, GAS STATION, DRIVEWAY - RESIDENTIAL

# PROBLEM 4.2 - POPULAR LOCATIONS  (1 point possible)

# Create a subset of your data, only taking observations for which the theft happened in one of
# these five locations, and call this new data set "Top5". To do this, you can use the | symbol. In
# lecture, we used the & symbol to use two criteria to make a subset of the data. To only take
# observations that have a certain value in one variable or the other, the | character can be used
# in place of the & symbol. This is also called a logical "or" operation.

# Alternately, you could create five different subsets, and then merge them together into one data
# frame using rbind.

top5LocationNames <- c("STREET", "PARKING LOT/GARAGE(NON.RESID.)", "ALLEY", "GAS STATION", "DRIVEWAY - RESIDENTIAL")
Top5 <- subset(mvt, LocationDescription %in% top5LocationNames)

# How many observations are in Top5?
nrow(Top5) # 177510


# PROBLEM 4.3 - POPULAR LOCATIONS  (2 points possible)

# R will remember the other categories of the LocationDescription variable from the original
# dataset, so running table(Top5$LocationDescription) will have a lot of unnecessary output. To make
# our tables a bit nicer to read, we can refresh this factor variable. In your R console, type:

Top5$LocationDescription = factor(Top5$LocationDescription)

# If you run the str or table function on Top5 now, you should see that LocationDescription now only
# has 5 values, as we expect.

# Use the Top5 data frame to answer the remaining questions.

# One of the locations has a much higher arrest rate than the other locations. Which is it? Please
# enter the text in exactly the same way as how it looks in the answer options for Problem 4.1.

table(Top5$LocationDescription, Top5$Arrest)

#Gas station

# Explanation

# If you create a table of LocationDescription compared to Arrest, table(Top5$LocationDescription,
# Top5$Arrest), you can then compute the fraction of motor vehicle thefts that resulted in arrests at
# each location. Gas Station has by far the highest percentage of arrests, with over 20% of motor
# vehicle thefts resulting in an arrest.


# PROBLEM 4.4 - POPULAR LOCATIONS  (1 point possible)

# On which day of the week do the most motor vehicle thefts at gas stations happen?

GasStationArrests <- subset (Top5, LocationDescription == "GAS STATION")
table (GasStationArrests$Weekday)

# or in only one line

table (subset (Top5, LocationDescription == "GAS STATION")$Weekday)

# Saturday


# PROBLEM 4.5 - POPULAR LOCATIONS  (1 point possible)

# On which day of the week do the fewest motor vehicle thefts in residential driveways happen?

table(Top5$LocationDescription, Top5$Weekday) # It's Saturday
