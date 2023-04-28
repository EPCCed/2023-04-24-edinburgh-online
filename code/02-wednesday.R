# Wednesday, 26th April 2023

# Load tidyverse
library(tidyverse)

surveys <- read_csv("data_raw/portal_data_joined.csv")

library(lubridate)

# YYYY-MM-DD
my_date <- ymd("2023-04-26")
str(my_date)

ymd(paste("2023", "04", "26", sep = "-"))

ymd(paste(surveys$year, surveys$month, surveys$day, sep = "-"))

str(surveys)

surveys$date <- ymd(paste(surveys$year, surveys$month, surveys$day, sep = "-"))

summary(surveys$date)

str(surveys)

missing_dates <- surveys[is.na(surveys$date), c("year", "month", "day")]

head(missing_dates)

# select(): subset columns
# filter(): subset rows on conditions
# mutate(): create new columns by using information from other columns
# group_by() and summarize(): create summary statistics on grouped data
# arrange(): sort results
# count(): count discrete value

surveys

select(surveys, year, month, day)

select(surveys, -year, -month, -day)

filter(surveys, year == 1995)

select(filter(surveys, year == 1995), -year, -month, -day)

surveys %>%
  filter(year == 1995) %>% 
  select(-year, -month, -day)


# Challenge
# Using pipes, subset the surveys data to include animals collected before 1995
# and retain only the columns year, sex, and weight.

surveys %>% 
  filter(year < 1995) %>% 
  select(year, sex, weight)

# Mutate
surveys %>% 
  mutate(weight_kg = weight / 1000) %>% 
  select(weight, weight_kg, date, genus) %>% 
  head(n=20)

# Challenge
# Create a new data frame from the surveys data that meets the following
# criteria: contains only the species_id column and a new column called
# hindfoot_cm containing the hindfoot_length values (currently in mm) converted
# to centimeters. In this hindfoot_cm column, there are no NAs and all values
# are less than 3.

surveys %>% 
  filter(!is.na(hindfoot_length)) %>%
  mutate(hindfoot_cm = hindfoot_length / 10) %>%
  filter(hindfoot_cm < 3) %>% 
  select(species_id, hindfoot_cm)



surveys %>% 
  filter(!is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight, na.rm = TRUE),
            min_weight = min(weight, na.rm = TRUE)) %>% 
  arrange(desc(min_weight))

surveys %>% 
  count(sex)


summary(factor(surveys$sex))

surveys %>% 
  filter(!is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight, na.rm = TRUE),
            min_weight = min(weight, na.rm = TRUE),
            count = n())




# Challenge
# 1. How many animals were caught in each plot_type surveyed?
# 2. Use group_by() and summarize() to find the mean, min, and max hindfoot
# length for each species (using species_id). Also add the number of
# observations (hint: see ?n).
# 3. What was the heaviest animal measured in each year? Return the columns
# year, genus, species_id, and weight.

# Part 1
surveys %>% 
  group_by(plot_type) %>% 
  count()

# Part 2
surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
  group_by(species_id) %>% 
  summarise(mean_hindfoot = mean(hindfoot_length),
            min_hindfoot = min(hindfoot_length),
            max_hindfoot = max(hindfoot_length),
            number = n())

# Part 3
# 3. What was the heaviest animal measured in each year? Return the columns
# year, genus, species_id, and weight.
surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(year) %>% 
  filter(weight == max(weight)) %>% 
  select(year, genus, species, weight) %>% 
  arrange(year) %>% 
  print(n=27)




# Remove NAs
surveys_complete <- surveys %>% 
  filter(!is.na(weight),
         !is.na(hindfoot_length),
         !is.na(sex))

# Filter species where the count is less than 50
species_counts <- surveys_complete %>% 
  count(species_id) %>% 
  filter(n >= 50)

surveys_complete <- surveys_complete %>% 
  filter(species_id %in% species_counts$species_id)

surveys_complete


write_csv(surveys_complete, file = "data/surveys_complete.csv")

library(tidyverse)

surveys_complete <- read_csv("data/surveys_complete.csv")

ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))+
  geom_point()

surveys_plot <- ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))

surveys_plot + geom_point(alpha = 0.1, color = "blue")

library(hexbin)

surveys_plot + geom_hex()

surveys_plot + geom_point(alpha = 0.1, aes(color = species_id))












# Use what you just learned to create a scatter plot of weight over species_id
# with the plot types showing in different colors.

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight))+
  geom_point(aes(color = plot_type))


ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight))+
  geom_jitter(alpha = 0.2, color = "tomato")+
  geom_boxplot()


yearly_counts <- surveys_complete %>% 
  count(year, genus)

ggplot(data = yearly_counts, aes(x = year, y = n, color = genus))+
  geom_line()


ggplot(data = yearly_sex_counts, aes(x = year, y = n, color = sex))+
  geom_line()+
  facet_wrap(facets = vars(genus))


yearly_sex_counts <- surveys_complete %>% 
  count(year, genus, sex)

yearly_sex_counts

my_plot <- ggplot(data = yearly_sex_counts, aes(x = year, y = n, color = sex))+
  geom_line()+
  facet_wrap(facets = vars(genus))+
  labs(title = "Observed genera through time",
       subtitle = "Data Carpentry 2023",
       x = "Year of observation",
       y = "Number of individuals")+
  theme(axis.text.x = element_text(angle = 90))

ggsave("img/genera.png", my_plot, width = 15, height = 10)

ggsave("img/genera-300dpi.png", my_plot, width = 15, height = 10, dpi = 300)

