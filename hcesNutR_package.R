# hcesNutR packages
#
# install.packages("devtools")
# devtools::install_github("dzvoti/hcesNutR")
#

library(hcesNutR)

ls("package:hcesNutR")

hcesNutR::combined_food_list
View(hcesNutR::consumption_unit_matches_v4_20092023)
View(hcesNutR::hh_mod_a_filt_vMAPS)

? hcesNutR::which_labelled

sample_hces <- haven::read_dta(here::here("mwi-ihs5-sample-data",
                                          "HH_MOD_G1_vMAPS.dta"))
# Rename the variables
sample_hces <- hcesNutR::rename_hces(sample_hces,
                                     country_name = "MWI",
                                     survey_name = "IHS5")


# Remove unconsumed food items 

sample_hces <- hcesNutR::remove_unconsumed(sample_hces,
                                           consCol = "consYN",
                                           consVal = 1)
# Split dbl+lbl columns
sample_hces <- hcesNutR::create_dta_labels(sample_hces)


# Merge food item names
sample_hces <-
  hcesNutR::concatenate_columns(sample_hces,
                                c("item_code_name",
                                  "item_oth"),
                                "SPECIFY",
                                "item_code_name")
View()


sample_hces <- sample_hces |>
  dplyr::select(
    case_id,
    hhid,
    item_code_name,
    item_code_code,
    cons_unit_name,
    cons_unitA,
    cons_quant
  ) |>
  dplyr::rename(food_name = item_code_name,
                food_code = item_code_code,
                cons_unit_code = cons_unitA)

#### workflow ####

ls("package:hcesNutR")

sample_hces <- haven::read_dta(here::here("mwi-ihs5-sample-data",
                                          "HH_MOD_G1_vMAPS.dta"))


# Trim the data to total consumption
sample_hces <- sample_hces |>
  dplyr::select(case_id:HHID,
                hh_g01:hh_g03c_1)


# Rename the variables
sample_hces <- hcesNutR::rename_hces(sample_hces,
                                     country_name = "MWI",
                                     survey_name = "IHS5")

# Remove unconsumed food items
sample_hces <- hcesNutR::remove_unconsumed(sample_hces,
                                           consCol = "consYN",
                                           consVal = 1)

# Split dbl+lbl columns
sample_hces <- hcesNutR::create_dta_labels(sample_hces)

# Merge food item names
sample_hces <-
  hcesNutR::concatenate_columns(sample_hces,
                                c("item_code_name",
                                  "item_oth"),
                                "SPECIFY",
                                "item_code_name")


# Merge consumption unit names. For units it is essential to remove parentesis as they are the major cause of duplicate units
sample_hces <-
  hcesNutR::concatenate_columns(
    sample_hces,
    c(
      "cons_unit_name",
      "cons_unit_oth",
      "cons_unit_size_name",
      "hh_g03c_1_name"
    ),
    "SPECIFY",
    "cons_unit_name",
    TRUE
  )

sample_hces <- sample_hces |>
  dplyr::select(
    case_id,
    hhid,
    item_code_name,
    item_code_code,
    cons_unit_name,
    cons_unitA,
    cons_quant
  ) |>
  dplyr::rename(food_name = item_code_name,
                food_code = item_code_code,
                cons_unit_code = cons_unitA)


sample_hces <-
  match_food_names_v2(
    sample_hces,
    country = "MWI",
    survey = "IHS5",
    food_name_col = "food_name",
    food_code_col = "food_code",
    overwrite = FALSE
  )

sample_hces <-
  match_food_units_v2(
    sample_hces,
    country = "MWI",
    survey = "IHS5",
    unit_name_col = "cons_unit_name",
    unit_code_col = "cons_unit_code",
    matches_csv = NULL,
    overwrite = FALSE
  )



# Import household identifiers from the hh_mod_a_filt.dta file
household_identifiers <-
  haven::read_dta(here::here(
                             "mwi-ihs5-sample-data",
                             "hh_mod_a_filt_vMAPS.dta")) |>
  # subset the identifiers and keep only the ones needed.
  dplyr::select(case_id,
                HHID,
                region) |>
  dplyr::rename(hhid = HHID)

# Add the identifiers to the data
sample_hces <-
  dplyr::left_join(sample_hces,
                   household_identifiers,
                   by = c("hhid", "case_id"))


# Create measure id column
sample_hces <-
  create_measure_id(
    sample_hces,
    country = "MWI",
    survey = "IHS5",
    cols = c("region",
             "matched_cons_unit_code",
             "matched_food_code"),
    include_ISOs = FALSE
  )
# Import food conversion factors file
IHS5_conv_fct <-
  readr::read_csv(
    here::here(

      "mwi-ihs5-sample-data",
      "IHS5_UNIT_CONVERSION_FACTORS_vMAPS.csv"
    )
  )

# Check conversion factors 
check_conv_fct(hces_df = sample_hces, 
               conv_fct_df = IHS5_conv_fct)

sample_hces <-
  apply_wght_conv_fct(
    hces_df = sample_hces,
    conv_fct_df = IHS5_conv_fct,
    factor_col = "factor",
    measure_id_col = "measure_id",
    wt_kg_col = "wt_kg",
    cons_qnty_col = "cons_quant",
    allowDuplicates = TRUE
  )
