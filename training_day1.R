# R for HCES training 
# MAPS team
# https://dzvoti.github.io/r4hces/fct_standardisation.html
library(dplyr)
library(readr)
library(haven)
library(here)

food_name <- "Maize"
food_subname <- "Meal"

full_name <- paste(food_name, food_subname)

food_quantity_g <- 60
food_quantity_mg <- food_quantity_g*1000


# Create character vectors
food_name <- "Maize"
food_name2 <- "Maize"
food_name3 <- "Rice"

# Test equality
food_name == food_name2
food_name == food_name3

# test inequality

food_name != food_name2
food_name != food_name3



# Create numeric object
age <- c(18,19,20,1,2,3,4,5,65)
# Test whether age is greater than 18

for(item in age){
  if(item >= 18) {
    print("You are an adult")
  }else{
    print("You are not an adult")
  }
}


food_name == food_name2 & food_quantity_g >10



##### Data structures
# Create a vector of character values
food_names <-
  c("Rice",
    "Maize",
    "Beans",
    "Cassava",
    "Potatoes",
    "Sweet potatoes",
    "Wheat")

#Create a vector of numeric values
consumpution <- c(0.5, 0.4, 0.3, 0.2, 0.1, 0.05, 0.01)

# Create a vector of logical values
is_staple <- c(TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE)

# Create a vector of mixed values
mixture <- c(5.2, TRUE, "CA")


length(food_names)
food_names[8]


##### data frames

# Create a data frame
food_df <-
  data.frame(
    food_names = c(
      "Rice",
      "Maize",
      "Beans",
      "Cassava",
      "Potatoes",
      "Maize",
      "Wheat"
    ),
    consumption = c(0.5, 0.4, 0.3, 0.2, 0.1, 0.05, 0.01),
    is_staple = c(TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, FALSE),
    stringsAsFactors = TRUE
  )

# Print the data frame
print(food_df)
tail(food_df)

food_df <- data.frame(food_names, consumption, is_staple, stringsAsFactors = TRUE)


# Create a tibble
food_tb <- tibble::tibble(
  food_names = c(
    "Rice",
    "Maize",
    "Beans",
    "Cassava",
    "Potatoes",
    "Maize",
    "Wheat"
  ),
  consumption = c(0.5, 0.4, 0.3, 0.2, 0.1, 0.05, 0.01),
  is_staple = c(TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, FALSE)
)
# check which class they are in 
class(food_t)
class(food_tb)


#### vectors as factors
food_names_factor <- factor(food_names)
# Create a factor from a vector of character values
food_names_factor_2 <-
  factor(
    food_names,
    levels = c(
      "Beans",
      "Rice",
      "Maize",

      "Cassava",
      "Potatoes",
      "Sweet potatoes",
      "Wheat"
    )
  )

# Print the factor
print(food_names_factor_2)


food_tb <- food_tb %>% 
  dplyr::mutate(food_names = factor(food_names))





### create functions

# Define a function
multiply <- function(arg1, arg2, ...) {
  # Function body
  return_value <- arg1 * arg2
  # Return value
  return(return_value)
}





#### Input and output ----------------------------------------------------------

ihs5_roster <- haven::read_dta(here::here("mwi-ihs5-sample-data", "hh_mod_a_filt_vMAPS.dta"))

# Import unit conversion factors data 
ihs5_unit_conversion_factors <- read_csv(here::here("mwi-ihs5-sample-data", "IHS5_UNIT_CONVERSION_FACTORS_vMAPS.csv"))
head(ihs5_unit_conversion_factors)

# Consumption data

ihs5_consumption <- 
head(ihs5_consumption)
dim(ihs5_consumption)

# Subset the data
ihs5_consumption <-
  read_dta(here::here("mwi-ihs5-sample-data/HH_MOD_G1_vMAPS.dta")) %>% 
  dplyr::select(
    case_id,
    HHID,
    hh_g01,
    hh_g01_oth,
    hh_g02,
    hh_g03a,
    hh_g03b,
    hh_g03b_label,
    hh_g03b_oth,
    hh_g03c,
    hh_g03c_1
  ) %>% 
  dplyr::rename(
       consumedYN = hh_g01,
       food_item = hh_g02,
       food_item_other = hh_g01_oth,
       consumption_quantity = hh_g03a,
       consumption_unit = hh_g03b,
       consumption_unit_label = hh_g03b_label,
       consumption_unit_other = hh_g03b_oth, 
       consumption_subunit_1 = hh_g03c, 
       consumption_subunit_2 = hh_g03c_1
       ) %>% 
  filter(consumedYN == 1)

ihs5_consumption <- ihs5_consumption %>% 
  dplyr::mutate(hh_members = sample(1:10, nrow(ihs5_consumption), replace = TRUE))


ihs5_consumption <- ihs5_consumption |>
  mutate(consumption_per_person = consumption_quantity / hh_members)
### assuming a 7-day recall

ihs5_consumption <- ihs5_consumption %>% 
  mutate(consumption_per_person_per_day = consumption_per_person/7)




