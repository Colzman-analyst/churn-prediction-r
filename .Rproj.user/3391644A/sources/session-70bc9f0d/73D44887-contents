# ============================================================
# CUSTOMER CHURN PREDICTION — FINTECH/BANKING
# Author: Collins Iorbee
# Tool: R
# Step 3: Exploratory Data Analysis & Visualisations
# ============================================================

# NOTE: Run Steps 1 & 2 first, or load the clean data directly:
df <- read_csv("data/telco_churn_clean.csv") %>%
  mutate(across(where(is.character), as.factor),
         churn = as.factor(churn))

# Create output folder for saving plots
dir.create("plots", showWarnings = FALSE)


# ---- 3.1 Churn Distribution (Target Variable) ----

p1 <- df %>%
  count(churn) %>%
  mutate(pct = round(n / sum(n) * 100, 1),
         label = paste0(pct, "%")) %>%
  ggplot(aes(x = churn, y = n, fill = churn)) +
  geom_col(width = 0.5) +
  geom_text(aes(label = label), vjust = -0.5, size = 4.5, fontface = "bold") +
  scale_fill_manual(values = c("No" = "#1F4E79", "Yes" = "#D85A30")) +
  labs(title = "Customer Churn Distribution",
       subtitle = "26.5% of customers churned — dataset is imbalanced",
       x = "Churned?", y = "Number of Customers") +
  theme_minimal(base_size = 13) +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold"))

print(p1)
ggsave("plots/01_churn_distribution.png", p1, width = 6, height = 4, dpi = 150)
cat("✅ Plot 1 saved: churn distribution\n")


# ---- 3.2 Churn by Contract Type ----

p2 <- df %>%
  count(contract, churn) %>%
  group_by(contract) %>%
  mutate(pct = round(n / sum(n) * 100, 1)) %>%
  filter(churn == "Yes") %>%
  ggplot(aes(x = reorder(contract, -pct), y = pct, fill = contract)) +
  geom_col(width = 0.5) +
  geom_text(aes(label = paste0(pct, "%")), vjust = -0.5, size = 4, fontface = "bold") +
  scale_fill_manual(values = c("#1F4E79", "#378ADD", "#85B7EB")) +
  labs(title = "Churn Rate by Contract Type",
       subtitle = "Month-to-month customers churn at a much higher rate",
       x = "Contract Type", y = "Churn Rate (%)") +
  theme_minimal(base_size = 13) +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold"))

print(p2)
ggsave("plots/02_churn_by_contract.png", p2, width = 7, height = 4, dpi = 150)
cat("✅ Plot 2 saved: churn by contract type\n")


# ---- 3.3 Churn by Tenure (How Long Customer Has Been With Company) ----

p3 <- df %>%
  mutate(churn = as.numeric(churn == "Yes")) %>%
  ggplot(aes(x = tenure, fill = as.factor(churn))) +
  geom_histogram(binwidth = 3, position = "identity", alpha = 0.7) +
  scale_fill_manual(values = c("0" = "#1F4E79", "1" = "#D85A30"),
                    labels = c("Stayed", "Churned")) +
  labs(title = "Customer Tenure Distribution by Churn",
       subtitle = "New customers (low tenure) are far more likely to churn",
       x = "Tenure (Months)", y = "Count", fill = "Status") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(p3)
ggsave("plots/03_churn_by_tenure.png", p3, width = 8, height = 4, dpi = 150)
cat("✅ Plot 3 saved: tenure distribution\n")


# ---- 3.4 Churn by Monthly Charges ----

p4 <- df %>%
  ggplot(aes(x = churn, y = monthly_charges, fill = churn)) +
  geom_boxplot(alpha = 0.8, outlier.colour = "#888780") +
  scale_fill_manual(values = c("No" = "#1F4E79", "Yes" = "#D85A30")) +
  labs(title = "Monthly Charges by Churn Status",
       subtitle = "Churned customers tend to have higher monthly charges",
       x = "Churned?", y = "Monthly Charges ($)") +
  theme_minimal(base_size = 13) +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold"))

print(p4)
ggsave("plots/04_churn_by_monthly_charges.png", p4, width = 6, height = 4, dpi = 150)
cat("✅ Plot 4 saved: monthly charges boxplot\n")


# ---- 3.5 Churn by Internet Service ----

p5 <- df %>%
  count(internet_service, churn) %>%
  group_by(internet_service) %>%
  mutate(pct = round(n / sum(n) * 100, 1)) %>%
  ggplot(aes(x = internet_service, y = pct, fill = churn)) +
  geom_col(position = "dodge", width = 0.6) +
  geom_text(aes(label = paste0(pct, "%")),
            position = position_dodge(width = 0.6),
            vjust = -0.4, size = 3.5) +
  scale_fill_manual(values = c("No" = "#1F4E79", "Yes" = "#D85A30")) +
  labs(title = "Churn Rate by Internet Service Type",
       subtitle = "Fibre optic customers churn significantly more",
       x = "Internet Service", y = "Percentage (%)", fill = "Churned?") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(p5)
ggsave("plots/05_churn_by_internet_service.png", p5, width = 7, height = 4, dpi = 150)
cat("✅ Plot 5 saved: internet service churn\n")


# ---- 3.6 Correlation of Numeric Variables ----

numeric_vars <- df %>%
  select(tenure, monthly_charges, total_charges)

cor_matrix <- cor(numeric_vars, use = "complete.obs")

png("plots/06_correlation_matrix.png", width = 600, height = 500, res = 120)
corrplot(cor_matrix,
         method = "color",
         type = "upper",
         addCoef.col = "black",
         tl.col = "black",
         col = colorRampPalette(c("#D85A30", "white", "#1F4E79"))(200),
         title = "Correlation Matrix — Numeric Variables",
         mar = c(0, 0, 2, 0))
dev.off()
cat("✅ Plot 6 saved: correlation matrix\n")


# ---- 3.7 Key EDA Findings Summary ----

cat("\n", strrep("=", 55), "\n")
cat("KEY FINDINGS FROM EDA:\n")
cat(strrep("=", 55), "\n")
cat("1. 26.5% churn rate — imbalanced dataset (handle in Step 4)\n")
cat("2. Month-to-month contracts have the highest churn rate\n")
cat("3. New customers (low tenure) churn far more often\n")
cat("4. Churned customers pay higher monthly charges on average\n")
cat("5. Fibre optic internet users churn more than DSL users\n")
cat("6. Total charges is highly correlated with tenure\n")
cat(strrep("=", 55), "\n\n")


# ============================================================
# STEP 3 COMPLETE
# What we did:
#   - Visualised churn distribution (target imbalance)
#   - Explored churn vs contract type, tenure,
#     monthly charges, internet service
#   - Computed correlation matrix for numeric features
#   - Saved all 6 plots to /plots folder
#   - Identified key business insights from the data
#
# NEXT: Run Step 4 — Feature Engineering
# ============================================================
