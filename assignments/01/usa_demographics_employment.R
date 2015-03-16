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

# Which state has the fewest interviewees?

# Which state has the largest number of interviewees?


# PROBLEM 1.4 - LOADING AND SUMMARIZING THE DATASET  (1 point possible)

# What proportion of interviewees are citizens of the United States?

USACitizens <- nrow(subset (CPS, Citizenship == "Citizen, Native")) + nrow(subset (CPS, Citizenship == "Citizen, Naturalized"))
USACitizens / nrow(CPS) # 0.9421943

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

# For each possible value of Region, Sex, and Citizenship, there are both interviewees with missing and non-missing Married values. However, Married is missing for all interviewees Aged 0-14 and is present for all interviewees aged 15 and older. This is because the CPS does not ask about marriage status for interviewees 14 and younger.
