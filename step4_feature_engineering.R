# ============================================================
# CUSTOMER CHURN PREDICTION — FINTECH/BANKING
# Author: Collins Iorbee
# Tool: R
# Step 4: Feature Engineering & Train/Test Split
# ============================================================

# Load clean data
df <- read_csv("data/telco_churn_clean.csv") %>%
  mutate(across(where(is.character), as.factor),
         churn = as.factor(churn))


# ---- 4.1 Create New Features ----

df <- df %>%
  mutate(
    # Average monthly spend per tenure month
    avg_monthly_spend = if_else(tenure > 0, total_charges / tenure, monthly_charges),

    # Flag customers who are new (less than 6 months)
    is_new_customer = if_else(tenure <= 6, "Yes", "No"),

    # Flag high-value customers (above median monthly charge)
    is_high_value = if_else(monthly_charges > median(monthly_charges), "Yes", "No"),

    # Combined risk flag: new customer on month-to-month contract
    high_churn_risk = if_else(
      tenure <= 6 & contract == "Month-to-month", "Yes", "No"
    )
  ) %>%
  mutate(
    is_new_customer  = as.factor(is_new_customer),
    is_high_value    = as.factor(is_high_value),
    high_churn_risk  = as.factor(high_churn_risk)
  )

cat("✅ New features created:\n")
cat("   - avg_monthly_spend\n")
cat("   - is_new_customer\n")
cat("   - is_high_value\n")
cat("   - high_churn_risk\n")


# ---- 4.2 Handle Class Imbalance with Oversampling (ROSE) ----
# Our data has 73.5% No vs 26.5% Yes — we need to balance this
# We'll use upsampling via caret to avoid bias toward "No"

set.seed(42)

# First split the data BEFORE balancing (to avoid data leakage)
train_index <- createDataPartition(df$churn, p = 0.80, list = FALSE)
train_raw   <- df[ train_index, ]
test_set    <- df[-train_index, ]

cat("✅ Train/test split done.\n")
cat("Training rows:", nrow(train_raw), "\n")
cat("Test rows:", nrow(test_set), "\n")

# Check class balance in training set before fixing
cat("\nClass distribution BEFORE balancing:\n")
table(train_raw$churn)

# Upsample the minority class (Yes = churned) in training set only
train_set <- upSample(
  x = train_raw %>% select(-churn),
  y = train_raw$churn,
  yname = "churn"
)

cat("\nClass distribution AFTER balancing:\n")
table(train_set$churn)
cat("✅ Training set balanced using upsampling.\n")


# ---- 4.3 Save Train & Test Sets ----

train_set %>% write_csv("data/train_set.csv")
test_set  %>% write_csv("data/test_set.csv")

cat("✅ train_set.csv saved\n")
cat("✅ test_set.csv saved\n")


# ============================================================
# STEP 4 COMPLETE
# What we did:
#   - Engineered 4 new business-relevant features
#   - Split data 80/20 into train and test sets
#   - Balanced the training set using upsampling
#     (prevents model from ignoring churners)
#   - Saved both sets for modelling
#
# NEXT: Run Step 5 — Build & Compare Models
# ============================================================
