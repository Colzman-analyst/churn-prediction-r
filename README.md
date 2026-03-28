[README (1).md](https://github.com/user-attachments/files/26323289/README.1.md)
# Customer Churn Prediction — Fintech/Banking
### Predictive Modelling with R | Logistic Regression vs Random Forest

![R](https://img.shields.io/badge/Language-R-276DC3?style=flat&logo=r&logoColor=white)
![ML](https://img.shields.io/badge/Type-Machine%20Learning-1F4E79?style=flat)
![Status](https://img.shields.io/badge/Status-Complete-22863a?style=flat)

---

## Project Overview

Customer churn is one of the most costly problems in banking and fintech. Acquiring a new customer costs 5–7x more than retaining an existing one. This project builds and compares two machine learning models — **Logistic Regression** and **Random Forest** — to predict which customers are most likely to leave, enabling the business to intervene proactively.

**Business Question:** *Which customers are at risk of churning, and what can the business do about it?*

---

## Dataset

- **Source:** [IBM Telco Customer Churn Dataset](https://www.kaggle.com/datasets/blastchar/telco-customer-churn) (Kaggle)
- **Rows:** 7,043 customers
- **Target Variable:** `Churn` (Yes / No)
- **Class Distribution:** 73.5% No | 26.5% Yes (imbalanced — handled via upsampling)

**Key Features Include:**
- Contract type (Month-to-month, One year, Two year)
- Tenure (months with company)
- Monthly & total charges
- Internet service type (DSL, Fibre optic, None)
- Additional services (Tech support, Online security, etc.)
- Payment method & paperless billing

---

## Project Structure

```
churn-prediction/
├── data/
│   ├── telco_churn_raw_backup.csv
│   ├── telco_churn_clean.csv
│   ├── train_set.csv
│   ├── test_set.csv
│   └── model_performance_summary.csv
├── models/
│   ├── model_logistic.rds
│   └── model_rf.rds
├── plots/
│   ├── 01_churn_distribution.png
│   ├── 02_churn_by_contract.png
│   ├── 03_churn_by_tenure.png
│   ├── 04_churn_by_monthly_charges.png
│   ├── 05_churn_by_internet_service.png
│   ├── 06_correlation_matrix.png
│   ├── 07_model_comparison_cv.png
│   ├── 08_variable_importance.png
│   └── 09_roc_curves.png
├── step1_setup_load.R
├── step2_cleaning.R
├── step3_eda_visualisation.R
├── step4_feature_engineering.R
├── step5_model_building.R
├── step6_evaluation.R
└── README.md
```

---

## Methodology

### Step 1 — Setup & Data Loading
Loaded the dataset, inspected shape, data types, and target variable distribution.

### Step 2 — Data Cleaning
- Fixed missing values in `TotalCharges` (11 blank rows removed)
- Standardised column names using `janitor`
- Converted data types — characters to factors, integers to readable labels
- Removed irrelevant `customerID` column

### Step 3 — Exploratory Data Analysis
Produced 6 visualisations revealing key patterns:
- Month-to-month customers churn at **~43%** vs 11% for annual contracts
- New customers (< 6 months tenure) churn at disproportionately high rates
- Churned customers pay **higher monthly charges** on average
- Fibre Optic internet users show significantly higher churn rates

### Step 4 — Feature Engineering
Created 4 new business-relevant features:
- `avg_monthly_spend` — total charges normalised by tenure
- `is_new_customer` — tenure ≤ 6 months flag
- `is_high_value` — above median monthly charge flag
- `high_churn_risk` — combined flag (new customer + month-to-month contract)

Balanced the training set using **upsampling** to address class imbalance.
Applied **80/20 train/test split** (split before balancing to prevent data leakage).

### Step 5 — Model Building
Trained and cross-validated (5-fold) two models:
- **Logistic Regression** — interpretable baseline model
- **Random Forest** — ensemble model for improved accuracy

### Step 6 — Evaluation & Business Interpretation
Evaluated both models on the unseen test set across 5 metrics.

---

## Results

| Model | Accuracy | Precision | Recall | F1 Score | AUC |
|-------|----------|-----------|--------|----------|-----|
| Logistic Regression | ~80% | ~66% | ~57% | ~61% | ~0.85 |
| Random Forest | ~83% | ~70% | ~63% | ~66% | ~0.88 |

> **Random Forest outperforms Logistic Regression across all metrics.**
> For churn prediction, **Recall** is the most important metric — we want to catch as many actual churners as possible, even at the cost of some false positives.

---

## Key Business Insights

| Finding | Business Action |
|--------|----------------|
| Month-to-month customers churn at 43% | Offer incentives to switch to annual contracts |
| Customers churn most in first 6 months | Build a structured onboarding retention programme |
| High monthly charges + no added services = high risk | Bundle tech support & security for high-charge customers |
| Fibre Optic users show elevated churn | Investigate service quality issues for this segment |

**Financial Impact Estimate:**
- ~1,855 customers lost per year at 26.5% churn rate
- At $65/month average revenue = **~$1.45M annual churn loss**
- A 10% churn reduction = **~$145,000 saved per year**

---

## Tools & Libraries

| Tool | Purpose |
|------|---------|
| `tidyverse` | Data manipulation & visualisation |
| `caret` | Model training, cross-validation, upsampling |
| `randomForest` | Random Forest algorithm |
| `pROC` | ROC curves & AUC calculation |
| `ggplot2` | Visualisations |
| `corrplot` | Correlation matrix |
| `janitor` | Column name cleaning |
| `skimr` | Data summary statistics |

---

## How to Run

1. Clone this repository
2. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn) and save as `telco_churn.csv` in the project root
3. Create folders: `data/`, `models/`, `plots/`
4. Run scripts in order:
```r
source("step1_setup_load.R")
source("step2_cleaning.R")
source("step3_eda_visualisation.R")
source("step4_feature_engineering.R")
source("step5_model_building.R")
source("step6_evaluation.R")
```

---

## Author

**Collins Iorbee** — Data Analyst | Business Analyst | Aspiring Data Scientist

📧 iorbeeterver@gmail.com
🔗 [LinkedIn](https://www.linkedin.com/in/collins-iorbee-22a125214/)
🌐 [Portfolio](https://colzman-analyst-github-io.vercel.app/)

---

*This project is part of my data analytics portfolio. Feedback and contributions are welcome.*
