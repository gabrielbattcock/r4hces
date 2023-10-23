# R for HCES training 
# MAPS team

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
