file.create("data/test.txt")# ============================================================
# CUSTOMER CHURN PREDICTION — FINTECH/BANKING
# Author: Collins Iorbee
# Tool: R
# Step 1: Project Setup & Data Loading
# ============================================================

# ---- 1.1 Install & Load Required Packages ----
# Run this block once to install all packages needed for the project

packages <- c(
  "tidyverse",   # data manipulation & visualisation
  "readr",       # fast CSV reading
  "skimr",       # quick data summaries
  "janitor",     # clean column names
  "corrplot",    # correlation matrix plots
  "caret",       # model training & evaluation
  "randomForest",# Random Forest model
  "pROC",        # ROC curve & AUC
  "ggplot2",     # visualisations
  "scales",      # axis formatting
  "gridExtra"    # arrange multiple plots
)

# Install any packages not already installed
installed <- packages %in% rownames(installed.packages())
if (any(!installed)) {
  install.packages(packages[!installed])
}

# Load all packages
lapply(packages, library, character.only = TRUE)

cat("✅ All packages loaded successfully.\n")


# ---- 1.2 Load the Dataset ----
# Dataset: IBM Telco Customer Churn
# Download from: https://www.kaggle.com/datasets/blastchar/telco-customer-churn
# Save the CSV as 'telco_churn.csv' in your working directory

# Set your working directory (update this path to your project folder)
# setwd("C:/Users/Collins/Projects/churn-prediction")

# Load the data
df_raw <- read_csv("telco_churn.csv")

cat("✅ Dataset loaded.\n")
cat("Rows:", nrow(df_raw), "\n")
cat("Columns:", ncol(df_raw), "\n")


# ---- 1.3 First Look at the Data ----

# View first 6 rows
head(df_raw)

# Column names and data types
glimpse(df_raw)

# Quick statistical summary of all columns
skim(df_raw)


# ---- 1.4 Check the Target Variable ----
# Our target: 'Churn' — did the customer leave? (Yes/No)

df_raw %>%
  count(Churn) %>%
  mutate(percentage = round(n / sum(n) * 100, 1)) %>%
  print()

# Expected output:
# Churn   n  percentage
# No     5174   73.5
# Yes    1869   26.5
# --> This tells us our dataset is imbalanced (more non-churners than churners)
#     We will handle this in Step 4 (Feature Engineering)


# ---- 1.5 Save a Clean Copy of Raw Data ----
# Always preserve the original before making changes

df_raw %>% write_csv("data/telco_churn_raw_backup.csv")
cat("✅ Raw data backup saved to data/telco_churn_raw_backup.csv\n")


# ============================================================
# STEP 1 COMPLETE
# What we did:
#   - Installed and loaded all project packages
#   - Loaded the Telco Customer Churn dataset
#   - Inspected shape, columns, data types
#   - Checked our target variable distribution
#   - Saved a raw backup
#
# NEXT: Run Step 2 — Data Cleaning
# ============================================================
