# =====================================================
# Netflix Content Analysis: data cleaning in R
# Dataset: Kaggle, "Netflix Movies and TV Shows"
# Output: netflix_clean.csv, netflix_countries.csv, netflix_genres.csv
# =====================================================

# ---- Step 0: Packages (install once, load every time) ----
# install.packages(c("tidyverse", "lubridate"))
library(tidyverse)
library(lubridate)

# ---- Step 1: Load the data ----
netflix <- read_csv("~/Downloads/netflix_titles - netflix_titles.csv")

glimpse(netflix)
dim(netflix)

# ---- Step 2: Check problems before fixing them ----
colSums(is.na(netflix))
sum(duplicated(netflix$show_id))

# ---- Step 3: Remove duplicates and extra spaces ----
# Why: duplicate rows would be counted twice in the charts.
# Extra spaces make "India" and "India " look like different countries.
# If skipped: counts are inflated and the same value appears as two categories.
clean <- netflix %>%
  distinct(show_id, .keep_all = TRUE) %>%
  mutate(across(where(is.character), str_trim))

# ---- Step 4: Handle missing values ----
# Why: blanks (NA) show up as "(blank)" in Power BI or drop out of charts.
# Labeling them "Unknown" keeps those titles in the counts.
# If skipped: the country chart would miss around 800 titles without warning.
clean <- clean %>%
  mutate(
    director = replace_na(director, "Unknown"),
    cast     = replace_na(cast, "Unknown"),
    country  = replace_na(country, "Unknown")
  )

# ---- Step 5: Fix the date column ----
# Why: date_added is text like "September 25, 2021". Text can't be grouped
# by year. mdy() converts it to a real date.
# If skipped: you can't build "content added per year".
clean <- clean %>%
  mutate(
    date_added  = mdy(date_added),
    year_added  = year(date_added),
    month_added = month(date_added, label = TRUE)
  )

sum(is.na(clean$year_added))   # about 10 is normal

# ---- Step 6: Fix duration ----
# Why: a few rows have the movie length typed in the rating column, and
# duration mixes "90 min" and "2 Seasons" in one text column.
# If skipped: the rating chart shows bogus values like "74 min".
clean %>%
  filter(str_detect(rating, "min")) %>%
  select(title, rating, duration)

clean <- clean %>%
  mutate(
    duration = if_else(is.na(duration) & str_detect(rating, "min"), rating, duration),
    rating   = if_else(str_detect(rating, "min"), NA_character_, rating)
  ) %>%
  separate(duration, into = c("duration_num", "duration_unit"),
           sep = " ", convert = TRUE)

# Safety check: keep only valid types (removes any shifted rows)
clean <- clean %>% filter(type %in% c("Movie", "TV Show"))

# ---- Step 7: Split multi-value columns ----
# Why: one cell can hold "India, United States, UK". Splitting gives one row
# per country (and per genre), so each is counted properly.
# If skipped: "Top 10 countries" and "Top 10 genres" will be wrong.
countries <- clean %>%
  separate_rows(country, sep = ",\\s*") %>%
  select(show_id, type, country, year_added)

genres <- clean %>%
  separate_rows(listed_in, sep = ",\\s*") %>%
  select(show_id, type, genre = listed_in, year_added)

# ---- Step 8: Quick checks ----
glimpse(clean)
count(clean, type)
count(clean, rating, sort = TRUE)
head(countries); head(genres)
sum(is.na(clean$year_added))
dim(clean); dim(countries); dim(genres)

# ---- Step 9: Export the cleaned files for Power BI ----
write_csv(clean, "netflix_clean.csv")
write_csv(countries, "netflix_countries.csv")
write_csv(genres, "netflix_genres.csv")

#Quick checks
sum(is.na(clean$year_added))
count(clean, type)
count(clean, rating, sort = TRUE)
dim(clean); dim(countries); dim(genres)
