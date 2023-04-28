# Tuesday, 25th April 2023

sessionInfo()

weight_kg <- 55
weight_lb <- 2.2 * weight_kg
weight_kg <- 100 # This is a comment

(weight_kg <- sqrt(10))

?round

round(3.14159)

args(round)

round(3.14159, digits = 2)

round(x = 3.14159, digits = 2)

round(3.14159, 2)

round(digits = 2, x = 3.1417565654)

# Vectors

weight_g <- c(20, 40, 50, 70)
weight_g

length(weight_g)
class(weight_g)
str(weight_g)

animals <- c("cat", "dog", "mouse")

animals <- c("horse", animals)

animals


# EXERCISE

num_char <- c(1, 2, 3, "a")

str(num_char)

num_logical <- c(1, 2, 3, TRUE)

str(num_logical)

char_logical <- c("a", "b", "c", TRUE)

str(char_logical)

tricky <- c(1, 2, 3, "4"); str(tricky)




animals[animals %in% c("cat", "horse")]

# MISSING DATA

height <- c(2, 4, 5, 5, NA, 6)

height

mean(height)
max(height)

mean(height, na.rm = TRUE)
max(height, na.rm = TRUE)

# First way
height[!is.na(height)]

# Second way
na.omit(height)

# Third way
height[complete.cases(height)]



# Challenge
# Using this vector of heights in inches, create a new vector,
# heights_no_na, with the NAs removed.

heights <- c(63, 69, 60, 65, NA, 68, 61, 70, 61, 59, 64, 69, 63, 63, NA, 72, 65, 64, 70, 63, 65)
heights_no_na <- heights[!is.na(heights)]
heights_no_na

length(heights)
length(heights_no_na)

# Use the function median() to calculate the median of the heights vector.
median(heights, na.rm = TRUE)

# Use R to figure out how many people in the set are taller than 67 inches.
length(heights_no_na[heights_no_na > 67])

# STARTING WITH DATA

download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")


library(tidyverse)

surveys <- read_csv("data_raw/portal_data_joined.csv")

# Install tidyverse
install.packages("tidyverse")

# Exercise
# Create a data.frame (surveys_200) containing only the data in row 200 of the surveys dataset.
surveys_200 <- surveys[200, ]
surveys_200









# Challenge
#
# Change the columns taxa and genus in the surveys data frame into a factor.
#
# Using the functions you learned before, can you find out…
#   How many rabbits were observed?
#   How many different genera are in the genus column?

surveys$taxa <- factor(surveys$taxa)
surveys$genus <- factor(surveys$genus)
str(surveys)
summary(surveys)

summary(surveys$sex)

plot(surveys$sex)
sex <- surveys$sex
plot(sex)
sex <- addNA(sex)
plot(sex)
levels(sex)
levels(sex)[3] <- "undetermined"
levels(sex)
plot(sex)
levels(sex)[1] <- "female"
levels(sex)[2] <- "male"
plot(sex)
levels(sex)
