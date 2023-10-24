#NutritionTools Examples
# website link: https://tomcodd.github.io/NutritionTools/


## Setup ----

# website link: https://tomcodd.github.io/NutritionTools/

devtools::install_github("TomCodd/NutritionTools")

library(NutritionTools)
library(hcesNutR)
library(tidyverse)
library(janitor)


## ENERCKcal_standardised/ENERCKj_standardised Examples ----

help("ENERCKcal_standardised")
help("ENERCKj_standardised")


#Its worth noting that this function (ENERCKcal_standardised) and
#ENERCKj_standardised are structurally extremely similar, and examples that work
#on this function will also work on that one.


#Three examples will be covered - two variants for a one-off calculation, and to
#create a column with the calculated results.



### Single calculation

#Bread, wheat, white, unfortified

Protein_value <- 7.5
Fat_value <- 1.3
Carb_value <- 50.5
Fibre_value <- 2.9
Alcohol_value <- 0

standardised_kcal <- ENERCKcal_standardised(PROT = Protein_value, FAT = Fat_value,
                                            CHOAVLDF = Carb_value, FIBTG = Fibre_value, ALC = Alcohol_value)

#alternatively:

standardised_kcal <- ENERCKcal_standardised(PROT = 7.5, FAT = 1.3,
                                            CHOAVLDF = 50.5, FIBTG = 2.9, ALC = 0)



### data.frame calculation

#First, an example dataframe is outlined and created -

test_df_WAFCT2019 <- data.frame(
  c("Bread, wheat, white, unfortified",
    "Beer, European (4.6% v/v alcohol)",
    "Maize, yellow, meal, whole grains, unfortified",
    "Sweet potato, yellow flesh, raw",
    "Cassava, tuber, white flesh, raw"),
  c(7.5, 0.3, 9.4, 1.5, 1.3),
  c(1.3, 0, 3.7, 0.2, 0.3),
  c(50.5, 3.7, 65.2, 25.5, 31.6),
  c(2.9, 0, 9.4, 3, 3.7),
  c(0, 3.6, 0, NA, 0))

#Then, the columns are renamed:

colnames(test_df_WAFCT2019) <- c("food_name", "protein", "fat", "carbs",
                                 "fb", "alcohol")

#Once renamed, the function is applied. the assigned output is a new column
#in the data.frame, and the inputs are the different columns detailing the
#relevant food nutrient values.

test_df_WAFCT2019$ENERCKcal_stnd <- ENERCKcal_standardised(
  test_df_WAFCT2019$protein,
  test_df_WAFCT2019$fat,
  test_df_WAFCT2019$carbs,
  test_df_WAFCT2019$fb,
  test_df_WAFCT2019$alcohol)

print(test_df_WAFCT2019)





## CARTBEQ_standardised example ----
#The most common usage scenario will be covered. First we will create a test
#data.frame with dummy data to use the function on. This function is designed
#to be able to be used with patchy data - if certain columns are incomplete
#then then the best calculation will be used on a row-by-row basis.

help("CARTBEQ_standardised")

test_df_cartbeq <- data.frame(
  ID = c(
    "test_01",
    "test_02",
    "test_03",
    "test_04",
    "test_05",
    "test_06",
    "test_07",
    "test_08",
    "test_09",
    "test_10"
  ),
  food_name
  = c(
    "Bread (wholemeal)",
    "Pepper, ground, black",
    "Milk, cow, whole, fresh,
raw",
    "Orange Juice",
    "Butter (cow milk), salted",
    "Salt, Iodized",
    "Egg,
chicken, whole, raw",
    "Tomato, red, ripe, raw",
    "Mushroom, fresh, raw",
    "Parsley, fresh, raw"
  ),
  "CART B (mcg)" = c(NA, 105, "", 130, NA, "", 111, NA,
                     112, 101),
  "CART A (mcg)" = c(0, 35, 23, 27, 6, 34, NA, 18, "", 40),
  "CRYPXB
(mcg)" = c(110, 67, 72, NA, 160, 102, 98, 37, 28, 60),
  "CART B eq (std) (mcg)"
  = c("", 107, 102, NA, "", NA, 72, "", "", 143),
  "CART B eq (mcg)" = c(159,
                        103, 132, NA, "", "", "", 78, NA, 92),
  "Vit A RAE (mcg)" = c(13, 8, NA, 15,
                        13, NA, NA, NA, 7, 10),
  "Vit A (mcg)" = c(12, 11, 8, 13, 3, 1, 10, 15, 3, 6),
  "Retinol (mcg)" = c(0, 7, 12, NA, 5, 2, 10, 6, "", 1),
  "comments" = c(
    "Imaginary values",
    "Completely fictional values",
    "Fictional values #2",
    "More fictional values",
    "Fictional #4",
    "Fictional no. 5",
    "fictional 6",
    "more fiction",
    "again, fiction",
    "Fictional number 9"
  ),
  check.names = F
)

#In this case the data.frame we want to run through is called test_df.
#However the standard INFOODS names haven't been used, so the assumed nutrient
#column names won't work, and they will have to be manually assigned. However,
#the comment column is named the default name (comments) and so even if left
#out will still be valid.

output_df_test_df_cartbeq <- CARTBEQ_standardised(df = test_df_cartbeq, item_ID = 'ID', CARTAmcg =
                                                    'CART A (mcg)', CARTBmcg = 'CART B (mcg)', CARTBEQmcg = 'CART B eq (mcg)',
                                                  CARTBEQmcg_std = 'CART B eq (std) (mcg)',  CRYPXBmcg = 'CRYPXB (mcg)',
                                                  VITAmcg = 'Vit A (mcg)',  VITA_RAEmcg = 'Vit A RAE (mcg)',  RETOLmcg =
                                                    'Retinol (mcg)')

#The resulting output will have a modified comments column, and a new column -
#recalculated_CARTBEQmcg_std




## Decimal_System_Checker example ----

help("Decimal_System_Checker")


#Two examples will be covered - one that results in the output error table,
#another that produces the output messages only (not recommended for large
#dataframes).

#First, we must create a test dataframe:
test_df_DSC <-
  data.frame(
    c(
      "Merlot",
      "pinot grigio",
      "Chateauneuf-du-Pape",
      "Tokaji",
      "Champagne",
      "Sauvignon Blanc",
      "Chardonnay",
      "Malbec"
    ),
    c("01",
      "01", "01", "01", "02", "02", "02", "02"),
    c(
      "02.01",
      "01.01",
      "01.02",
      "01.02",
      "02.01",
      "02.01",
      "02.02",
      "02.02"
    ),
    c(
      "02.01.0111",
      "01.01.0131",
      "01.02.0001",
      "01.02.2031",
      "02.01.1001",
      "02.01.1001",
      "02.02.3443",
      "02.03.4341"
    ),
    c(
      "02.01.0111.01",
      "01.01.0131.04",
      "01.02.0001.01",
      "01.02.2031.03",
      "02.01.1001.06",
      "02.01.1001.06",
      "02.01.3443.02",
      "02.02.4341.03"
    )
  )

#Then we should rename the columns of the dataframe:

colnames(test_df_DSC) <-
  c("Wine names",
    "ID1",
    "ID2",
    "ID3",
    "ID4")

#This first line runs the dataframe, and has an output variable listed. This
#means that as well as putting a message in the console when an error is
#found, all the error reports will be saved to a dataframe too.

output_test_DSC <-
  Decimal_System_Checker(
    test_df_DSC,
    first = "ID1",
    second =
      "ID2",
    third = "ID3",
    fourth = "ID4"
  )

#However, if we only want to get the readouts and not have an error
#dataframe to refer back to, then the code can be run like so:

Decimal_System_Checker(
  test_df_DSC,
  first = "ID1",
  second = "ID2",
  third =
    "ID3",
  fourth = "ID4"
)

#This will do the same thing as the previous run, producing error printouts,
#but it will not create an error report dataframe.



## Group_Summariser example ----

help("Group_Summariser")

test_df_GS <- data.frame(
  food_id = c(0001, 0002, 0003, 0004, 0005, 0006, 0007, 0008,0009,0010, 0011, 0012, 0013,0014,0015,0016,0017,0018,0019,0020),
  food_name = c("wheat", "maize", "rice", "oats", "beef", "lamb", "chicken", "broccoli", "carrot", "garden pea", "beans", "orange", "apple", "pineapple", "grape", "mango", "banana", "milk", "cheese", "butter"),
  food_group = c("Cereals","Cereals","Cereals","Cereals","Meat","Meat","Meat","Vegetables","Vegetables","Vegetables","Vegetables","Fruit","Fruit","Fruit","Fruit","Fruit","Fruit","Dairy Products","Dairy Products","Dairy Products"),
  Energy_kcal = c(300, 276, 295, 230, 330, 320, 270, 35, 70, 40, 65, 80, 95, 110, 53, 92, 122, 120, 620, 580),
  Protein_g = c(8, 3, 5, 6, 40, 30, 28, 35, 2, 3, 2, 6, 1, 2, 2, 1, 4, 3, 10, 13),
  Iron_mg = c(1, 3, 2, 5, 3, 7, 2, 6, 7, 2, 9, 10, 13, 16, 15, 18, 10, 14, 12, 13)
)



output_df_GS <- Group_Summariser(test_df_GS, group_ID_col = "food_group", blank_cols = c("food_id", "food_name"), sep_row = T)

## Fuzzy Matcher Example ----

# MAPS dictionary dataset

MAPS_dict <-
  read.csv("https://raw.githubusercontent.com/LuciaSegovia/fct/repro/metadata/MAPS_food-dictionary_v3.0.3.csv") #Import MAPS dictionary

Maps_dict_subset <- MAPS_dict %>%
  select(ID_3, FoodName_3)                        #Subset columns to only include ID and food name

Maps_dict_subset <-
  Maps_dict_subset[!apply(is.na(Maps_dict_subset) | Maps_dict_subset == "", 1, all), ] #Removes empty rows



# IHS5 food item list

# ihs5_consumption <- hcesNutR::combined_food_list 
# 
# ihs5_consumption_subset <- ihs5_consumption %>% 
#   select(standard_original_food_id, standard_original_food_name) %>% 
#   unique() %>% 
#   slice(1:132)


ihs5_consumption <-
  read_dta(here::here("r4hces-data", "mwi-ihs5-sample-data", "HH_MOD_G1_vMAPS.dta")) #reads data in 

ihs5_consumption <-
  hcesNutR::create_dta_labels(ihs5_consumption)   #extracts labels to a column


ihs5_consumption_subset <- ihs5_consumption %>%
  select(hh_g02_code, hh_g02_name) %>%                              #select only the ID and food name columns
  rename(item_code = hh_g02_code, item_name = hh_g02_name) %>%      #renames the column names
  unique()                                                          #extracts only unique rows



# Fuzzy Matching

Fuzzy_Matcher(ihs5_consumption_subset, Maps_dict_subset) #Match items between lists
