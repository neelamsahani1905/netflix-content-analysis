# netflix-content-analysis
Data cleaning in R and an interactive 3-page Power BI dashboard analyzing 8,800+ Netflix titles


# Netflix Content Analysis

An end-to-end data analytics project: data cleaning in R and an interactive 3-page dashboard in Power BI.

## Objective
To understand how Netflix's content has changed over time: what it offers, where it comes from, who it targets and when it was added.

## Dataset
- Source: [Kaggle, Netflix Movies and TV Shows]([https://www.kaggle.com/datasets/shivamb/netflix-shows](https://www.kaggle.com/code/poojajain22/netflix-movies-and-tv-shows/input))
- Size: 8,807 titles, 12 columns (type, title, director, cast, country, date added, release year, rating, duration, genres, description)

## Tools
R (tidyverse, lubridate) | Google Sheets | Power BI

## Workflow
**Extract:** imported the raw CSV from Kaggle.

**Transform and clean (R):**
1. Removed duplicates and trimmed extra spaces
2. Replaced missing director, cast and country values with "Unknown"
3. Converted `date_added` from text to a date and created year and month columns
4. Fixed rows where the movie duration was typed in the rating column
5. Split `duration` into a number and a unit
6. Split the multi-value `country` and `listed_in` columns into separate tables (one row per country and per genre)
7. Removed shifted rows caused by the Google Sheets export, and checked totals against the R output

**Load:** exported `netflix_clean.csv`, `netflix_countries.csv` and `netflix_genres.csv` and loaded them into Power BI.

**EDA and visualization:** explored trends, ratings, genres, countries and release timing, then built the dashboard.

## Dashboard
- **Page 1, Overview:** top countries, ratings, movie vs TV split, additions per year, movie duration, top genres, filters
- **Page 2, Deep Dive:** KPI cards, ratings by year, releases by month, country map
- **Page 3, Trends:** movies vs TV shows over time, average movie duration, genre treemap


## Key Findings
- Movies are about 70% of the catalog (6,131 movies, 2,676 TV shows)
- Netflix added nearly 5x more titles in 2019 (2,016) than in 2016 (429)
- Content is added steadily all year, with no single busy season
- TV-MA (3,204) and TV-14 (2,157) make up about 61% of rated titles
- Content comes from 124 countries and regions, led by the US, India and the UK
- Average movie length rose from about 80 to 100 minutes

## Limitations
- 2021 is a partial year, so its dip is not a real decline
- Ten titles have no date added and are left out of time-based charts
- Years before 2014 have very few titles, so early averages are less reliable

## How to Use
1. Download the dataset from Kaggle
2. Run the R script in RStudio to create the cleaned CSVs
3. Load the CSVs into Power BI, or view the screenshots above

## Author
Neelam Sahani | [LinkedIn](https://www.linkedin.com/in/neelamsahani/) | [Portfolio](https://neelamsahani1905.github.io)
