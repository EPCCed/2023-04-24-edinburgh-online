# Thursday, 27th April 2023

# Download file
download.file(url = "https://ndownloader.figshare.com/files/2292171",
              destfile = "data_raw/portal_mammals.sqlite", mode = "wb")

# Load libraries
library(dplyr)
library(dbplyr)

# DB connection
mammals <- DBI::dbConnect(RSQLite::SQLite(), "data_raw/portal_mammals.sqlite")

# Desc
src_dbi(mammals)

# Query
tbl(mammals, sql("SELECT year, species_id, plot_id FROM surveys"))

# Query with dplyr syntax
surveys <- tbl(mammals, "surveys")
surveys %>%
  select(year, species_id, plot_id)


show_query(head(surveys, n = 10))
