# ============================================================
# CUSTOMER CHURN PREDICTION — FINTECH/BANKING
# Author: Collins Iorbee
# Tool: R
# Step 2: Data Cleaning
# ============================================================

# NOTE: Run Step 1 first before running this script

source("step1_setup_load.R")


# ---- 2.1 Clean Column Names ----
# Standardise all column names to lowercase with underscores

df <- df_raw %>%
  clean_names()

cat("✅ Column names cleaned.\n")
names(df)


# ---- 2.2 Check for Missing Values ----

missing_summary <- df %>%
  summarise(across(everything(), ~ sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "column", values_to = "missing_count") %>%
  filter(missing_count > 0) %>%
  arrange(desc(missing_count))

if (nrow(missing_summary) == 0) {
  cat("✅ No missing values found.\n")
} else {
  cat("⚠️  Missing values detected:\n")
  print(missing_summary)
}

# The TotalCharges column sometimes has blank strings instead of NA
# Let's fix that
df <- df %>%
  mutate(total_charges = as.numeric(total_charges))

# Re-check missing after conversion
cat("Missing in total_charges after conversion:",
    sum(is.na(df$total_charges)), "\n")

# Remove rows where total_charges is NA (only ~11 rows — new customers)
df <- df %>%
  filter(!is.na(total_charges))

cat("✅ Removed rows with missing total_charges.\n")
cat("Dataset now has", nrow(df), "rows.\n")


# ---- 2.3 Fix Data Types ----

# Convert SeniorCitizen from 0/1 integer to Yes/No factor (more readable)
df <- df %>%
  mutate(senior_citizen = if_else(senior_citizen == 1, "Yes", "No"))

# Convert target variable Churn to a factor
df <- df %>%
  mutate(churn = as.factor(churn))

# Convert all other character columns to factors
df <- df %>%
  mutate(across(where(is.character), as.factor))

cat("✅ Data types corrected.\n")
glimpse(df)


# ---- 2.4 Remove Irrelevant Columns ----

# customer_id is just an identifier — not useful for prediction
df <- df %>%
  select(-customer_id)

cat("✅ Removed customer_id column.\n")
cat("Final cleaned dataset:", nrow(df), "rows x", ncol(df), "columns.\n")


# ---- 2.5 Check for Duplicates ----

dupes <- df %>% duplicated() %>% sum()
cat("Duplicate rows:", dupes, "\n")

if (dupes > 0) {
  df <- df %>% distinct()
  cat("✅ Duplicates removed.\n")
} else {
  cat("✅ No duplicates found.\n")
}


# ---- 2.6 Save Clean Dataset ----

df %>% write_csv("data/telco_churn_clean.csv")
cat("✅ Clean dataset saved to data/telco_churn_clean.csv\n")


# ============================================================
# STEP 2 COMPLETE
# What we did:
#   - Standardised column names
#   - Detected and handled missing values in TotalCharges
#   - Fixed data types (factors, numeric)
#   - Removed irrelevant ID column
#   - Checked and removed duplicates
#   - Saved clean dataset
#
# NEXT: Run Step 3 — Exploratory Data Analysis & Visualisations
# ============================================================
