#food composition tables
# https://dzvoti.github.io/r4hces/fct_standardisation.html
#### day 1 ####
rm(list = ls())

# loading libraries

library(readxl)
library(stringr)
library(dplyr)
library(here)


f <- "https://www.fao.org/fileadmin/user_upload/faoweb/2020/WAFCT_2019.xlsx"


download.file(f, 
              destfile = here::here("data", # data folder
                                    'WA19', #FCT folder
                                    #FCT file
                                    "WAFCT_2019.xlsx"),  
              method="curl", #use "curl" for OS X / Linux, "wininet" for Windows
              mode="wb")

# This identifies the file and file path, and saves it as a variable
FCT_file_location <- here::here('data','WA19', "WAFCT_2019.xlsx") 

# This is an example of the name 
FCT_id <- 'WA19'# Change two first letter for your ISO 2 code & the two digits for the last two digits of the year of publication.


# Checking the sheets

readxl::excel_sheets(FCT_file_location)

data.df <- readxl::read_excel(FCT_file_location, #The file location, as identified in section 2.1
                              sheet = 5  # Change to the excel sheet where the FCT is stored in the excel file
) %>%  
  mutate(source_fct = FCT_id)  #Creates the source_fct column and fills with a id for this FCT, as filled in in section 2.2. 


# Checking the dataframe
head(data.df) 

dim(data.df)

# Structure (variable names, class, etc.)
str(data.df)

# Checking the last rows and columns
tail(data.df) 
names(data.df)

print(data.df %>% slice(1:5) %>% knitr::kable())

# Storing the variables you want to keep
columns_to_keep <- c('Scientific name', 'Energy\r\n(kJ)')

# Selecting the variables
data.df %>% select(columns_to_keep) %>% 
  head(5) 

columns_to_remove <- c('Food name in French', 'Sum of proximate components\r\n(g)') 

data.df %>% select(!columns_to_remove) %>% 
  head(5) 


#Creates a list of the food groups using their unique row structure in the table to identify them

fgroup <- data.df %>% 
  filter(is.na(`Food name in English`), !is.na(Code)) %>%
  pull(Code) %>%
  stringr::str_split_fixed( '/', n = 2) %>% 
  as_tibble() %>%
  pull(V1) 

group.id <-  unique(str_extract(data.df$Code, "^[:digit:]{2}\\_"))[-1]



# Removes any rows without a food description entry (the food group name rows, and a row that have already been used for naming)

data.df <- data.df %>% #Identifies the food group number from the fdc_id, and applies the correct food_group from the fgroup list to the food_group column 
  mutate(food_group = ifelse(grepl("01_", Code), fgroup[1],
                             ifelse(grepl("02_", Code), fgroup[2],
                             ifelse(grepl("03_", Code), fgroup[3],
                             ifelse(grepl("04_", Code), fgroup[4],
                             ifelse(grepl("05_", Code), fgroup[5],
                             ifelse(grepl("06_", Code), fgroup[6],
                             ifelse(grepl("07_", Code), fgroup[7],
                             ifelse(grepl("08_", Code), fgroup[8],
                             ifelse(grepl("09_", Code), fgroup[9], 
                             ifelse(grepl("10_", Code), fgroup[10], 
                             ifelse(grepl("11_", Code), fgroup[11], 
                             ifelse(grepl("12_", Code), fgroup[12],
                             ifelse(grepl("13_", Code), fgroup[13],
                             ifelse(grepl("14_", Code), fgroup[14], 
                             'NA')))))))))))))))


#### day 2 ####