# DEMOGRAPHICS AND EMPLOYMENT IN THE UNITED STATES

# In the wake of the Great Recession of 2009, there has been a good deal of focus on employment
# statistics, one of the most important metrics policymakers use to gauge the overall strength of
# the economy. In the United States, the government measures unemployment using the Current
# Population Survey (CPS), which collects demographic and employment information from a wide range
# of Americans each month. In this exercise, we will employ the topics reviewed in the lectures as
# well as a few new techniques using the September 2013 version of this rich, nationally
# representative dataset (available online).

# The observations in the dataset represent people surveyed in the September 2013 CPS who actually
# completed a survey. While the full dataset has 385 variables, in this exercise we will use a more
# compact version of the dataset, CPSData.csv, which has the following variables:

# PeopleInHousehold: The number of people in the interviewee's household.

# Region: The census region where the interviewee lives.

# State: The state where the interviewee lives.

# MetroAreaCode: A code that identifies the metropolitan area in which the interviewee lives
# (missing if the interviewee does not live in a metropolitan area). The mapping from codes to names
# of metropolitan areas is provided in the file MetroAreaCodes.csv.

# Age: The age, in years, of the interviewee. 80 represents people aged 80-84, and 85 represents
# people aged 85 and higher.

# Married: The marriage status of the interviewee.

# Sex: The sex of the interviewee.

# Education: The maximum level of education obtained by the interviewee.

# Race: The race of the interviewee.

# Hispanic: Whether the interviewee is of Hispanic ethnicity.

# CountryOfBirthCode: A code identifying the country of birth of the interviewee. The mapping from
# codes to names of countries is provided in the file CountryCodes.csv.

# Citizenship: The United States citizenship status of the interviewee.

# EmploymentStatus: The status of employment of the interviewee.

# Industry: The industry of employment of the interviewee (only available if they are employed).

# ##################################################################################################

Sys.setlocale("LC_ALL", "C")

# PROBLEM 1.1 - LOADING AND SUMMARIZING THE DATASET  (1 point possible)

# Load the dataset from CPSData.csv into a data frame called CPS, and view the dataset with the summary() and str() commands.

CPS <- read.csv (file = "data/CPSData.csv")

# How many interviewees are in the dataset?

str(CPS) # 131302

# PROBLEM 1.2 - LOADING AND SUMMARIZING THE DATASET  (1 point possible)

# Among the interviewees with a value reported for the Industry variable, what is the most common
# industry of employment? Please enter the name exactly how you see it.

summary (CPS) # Educational and health services

# PROBLEM 1.3 - LOADING AND SUMMARIZING THE DATASET  (2 points possible)

# Recall from the homework assignment "The Analytical Detective" that you can call the sort()
# function on the output of the table() function to obtain a sorted breakdown of a variable. For
# instance, sort(table(CPS$Region)) sorts the regions by the number of interviewees from that
# region.

sort(table(CPS$State))

# Which state has the fewest interviewees?

# New Mexico

# Which state has the largest number of interviewees?

# California

# PROBLEM 1.4 - LOADING AND SUMMARIZING THE DATASET  (1 point possible)

# What proportion of interviewees are citizens of the United States?

USACitizens <- nrow(subset (CPS, Citizenship == "Citizen, Native")) + nrow(subset (CPS, Citizenship
== "Citizen, Naturalized")) USACitizens / nrow(CPS) # 0.9421943

# PROBLEM 1.5 - LOADING AND SUMMARIZING THE DATASET  (1 point possible)

# The CPS differentiates between race (with possible values American Indian, Asian, Black, Pacific
# Islander, White, or Multiracial) and ethnicity. A number of interviewees are of Hispanic
# ethnicity, as captured by the Hispanic variable. For which races are there at least 250
# interviewees in the CPS dataset of Hispanic ethnicity? (Select all that apply.)

table (CPS$Race, CPS$Hispanic)

#American Indian, Black, Multiracial, 16731

# PROBLEM 2.1 - EVALUATING MISSING VALUES  (1 point possible)

# Which variables have at least one interviewee with a missing (NA) value? (Select all that apply.)

for (i in 1:ncol(CPS)) {
	NumberOfMissingValues <- nrow (subset(CPS, is.na(get (colnames (CPS)[i]))))	
	if (NumberOfMissingValues > 0) {
		print(c(colnames (CPS)[i], NumberOfMissingValues), zero.print = ".")
	}	
}

# MetroAreaCode, Married, Education, EmploymentStatus, Industry

# PROBLEM 2.2 - EVALUATING MISSING VALUES  (1 point possible)

# Often when evaluating a new dataset, we try to identify if there is a pattern in the missing
# values in the dataset. We will try to determine if there is a pattern in the missing values of the
# Married variable. The function is.na(CPS$Married) returns a vector of TRUE/FALSE values for
# whether the Married variable is missing. We can see the breakdown of whether Married is missing
# based on the reported value of the Region variable with the function 

table(CPS$Region, is.na(CPS$Married))

# Which is the most accurate:

# The Married variable being missing is related to the Age value for the interviewee

# We can test the relationship between these four variable values and whether the Married variable
# is missing with the following commands:

table(CPS$Region, is.na(CPS$Married))
table(CPS$Sex, is.na(CPS$Married))
table(CPS$Age, is.na(CPS$Married))
table(CPS$Citizenship, is.na(CPS$Married))

# For each possible value of Region, Sex, and Citizenship, there are both interviewees with missing
# and non-missing Married values. However, Married is missing for all interviewees Aged 0-14 and is
# present for all interviewees aged 15 and older. This is because the CPS does not ask about
# marriage status for interviewees 14 and younger.


# PROBLEM 2.3 - EVALUATING MISSING VALUES  (2 points possible)

# As mentioned in the variable descriptions, MetroAreaCode is missing if an interviewee does not
# live in a metropolitan area. Using the same technique as in the previous question, answer the
# following questions about people who live in non-metropolitan areas.

# How many states had all interviewees living in a non-metropolitan area (aka they have a missing
# MetroAreaCode value)? For this question, treat the District of Columbia as a state (even though it
# is not technically a state).

Inteviewees <- as.data.frame(table(CPS$State, is.na(CPS$MetroAreaCode)))

StatesWithAllNonMetropolitanInteviewees <- subset (Inteviewees, Var2 == FALSE & Freq == 0)
nrow (StatesWithAllNonMetropolitanInteviewees) # 2

# How many states had all interviewees living in a metropolitan area? Again, treat the District of
# Columbia as a state.

nrow(subset (Inteviewees, Var2 == TRUE & Freq == 0)) # 3


# PROBLEM 2.4 - EVALUATING MISSING VALUES  (1 point possible)

# Which region of the United States has the largest proportion of interviewees living in a non-
# metropolitan area?

table(CPS$Region, is.na(CPS$MetroAreaCode))

# RegionMetroAreaCodeMatrix      <- as.matrix(table(CPS$Region, is.na(CPS$MetroAreaCode)))
# RegionsNonMissingValuesRecords <- RegionMetroAreaCodeMatrix[, 1]
# RegionsMissingValuesRecords    <- RegionMetroAreaCodeMatrix[, 2]

# Midwest = 10674 / (10674 + 20010) = 0.34, and so on


# PROBLEM 2.5 - EVALUATING MISSING VALUES  (4 points possible)

# While we were able to use the table() command to compute the proportion of interviewees from each
# region not living in a metropolitan area, it was somewhat tedious (it involved manually computing
# the proportion for each region) and isn't something you would want to do if there were a larger
# number of options. It turns out there is a less tedious way to compute the proportion of values
# that are TRUE. The mean() function, which takes the average of the values passed to it, will treat
# TRUE as 1 and FALSE as 0, meaning it returns the proportion of values that are true. For instance,
# mean(c(TRUE, FALSE, TRUE, TRUE)) returns 0.75. Knowing this, use tapply() with the mean function
# to answer the following questions:

# Which state has a proportion of interviewees living in a non-metropolitan area closest to 30%?

sort(tapply(is.na(CPS$MetroAreaCode), CPS$State, mean)) # Wisconsin 

# Which state has the largest proportion of non-metropolitan interviewees, ignoring states where all
# interviewees were non-metropolitan?

#Montana 0.83607908

# PROBLEM 3.1 - INTEGRATING METROPOLITAN AREA DATA  (2 points possible)

# Codes like MetroAreaCode and CountryOfBirthCode are a compact way to encode factor variables with
# text as their possible values, and they are therefore quite common in survey datasets. In fact,
# all but one of the variables in this dataset were actually stored by a numeric code in the
# original CPS datafile.

# When analyzing a variable stored by a numeric code, we will often want to convert it into the
# values the codes represent. To do this, we will use a dictionary, which maps the the code to the
# actual value of the variable. We have provided dictionaries MetroAreaCodes.csv and
# CountryCodes.csv, which respectively map MetroAreaCode and CountryOfBirthCode into their true
# values. Read these two dictionaries into data frames MetroAreaMap and CountryMap.

MetroAreaMap <- read.csv (file = "data/MetroAreaCodes.csv")
CountryMap <- read.csv (file = "data/CountryCodes.csv")

# How many observations (codes for metropolitan areas) are there in MetroAreaMap?

nrow(MetroAreaMap) # 271

# How many observations (codes for countries) are there in CountryMap?

nrow(CountryMap) # 149


# PROBLEM 3.2 - INTEGRATING METROPOLITAN AREA DATA  (2 points possible)

# To merge in the metropolitan areas, we want to connect the field MetroAreaCode from the CPS data
# frame with the field Code in MetroAreaMap. The following command merges the two data frames on
# these columns, overwriting the CPS data frame with the result:

CPS = merge(CPS, MetroAreaMap, by.x = "MetroAreaCode", by.y = "Code", all.x = TRUE)

# The first two arguments determine the data frames to be merged (they are called "x" and "y",
# respectively, in the subsequent parameters to the merge function). by.x = "MetroAreaCode" means we're
# matching on the MetroAreaCode variable from the "x" data frame (CPS), while by.y = "Code" means we're
# matching on the Code variable from the "y" data frame (MetroAreaMap). Finally, all.x = TRUE means we
# want to keep all rows from the "x" data frame (CPS), even if some of the rows' MetroAreaCode doesn't
# match any codes in MetroAreaMap (for those familiar with database terminology, this parameter makes
# the operation a left outer join instead of an inner join).

# Review the new version of the CPS data frame with the summary() and str() functions. What is the
# name of the variable that was added to the data frame by the merge() operation?

#One. It is the MetroArea variable

# How many interviewees have a missing value for the new metropolitan area variable? Note that all
# of these interviewees would have been removed from the merged data frame if we did not include the
# all.x = TRUE parameter

nrow(subset(CPS, is.na(MetroArea))) # 34238

# PROBLEM 3.3 - INTEGRATING METROPOLITAN AREA DATA  (1 point possible)

# Which of the following metropolitan areas has the largest number of interviewees?

sort(table(CPS$MetroArea))

# PROBLEM 3.4 - INTEGRATING METROPOLITAN AREA DATA  (2 points possible)

# Which metropolitan area has the highest proportion of interviewees of Hispanic ethnicity? Hint:
# Use tapply() with mean, as in the previous subproblem. Calling sort() on the output of tapply()
# could also be helpful here.

sort( tapply (CPS$Hispanic, CPS$MetroArea, mean)) #  Laredo, TX (96%)

# PROBLEM 3.5 - INTEGRATING METROPOLITAN AREA DATA  (2 points possible)

# Remembering that CPS$Race == "Asian" returns a TRUE/FALSE vector of whether an interviewee is
# Asian, determine the number of metropolitan areas in the United States from which at least 20% of
# interviewees are Asian.

sort(tapply (CPS$Race == "Asian", CPS$MetroArea, mean))

# Vallejo-Fairfield, CA                                          0.203007519
# San Jose-Sunnyvale-Santa Clara, CA                             0.241791045
# San Francisco-Oakland-Fremont, CA                              0.246753247
# Honolulu, HI                                                   0.501903553


# PROBLEM 3.6 - INTEGRATING METROPOLITAN AREA DATA  (1 point possible)

# Normally, we would look at the sorted proportion of interviewees from each metropolitan area who
# have not received a high school diploma with the command:

sort(tapply(CPS$Education == "No high school diploma", CPS$MetroArea, mean))

# However, none of the interviewees aged 14 and younger have an education value reported, so the
# mean value is reported as NA for each metropolitan area. To get mean (and related functions, like
# sum) to ignore missing values, you can pass the parameter na.rm = TRUE. Passing na.rm = TRUE to
# the tapply function, determine which metropolitan area has the smallest proportion of interviewees
# who have received no high school diploma.

sort(tapply(CPS$Education == "No high school diploma", CPS$MetroArea, mean, na.rm = TRUE),
decreasing = TRUE) #  Iowa City, IA  0.02912621

