# ============================================================
# CUSTOMER CHURN PREDICTION — FINTECH/BANKING
# Author: Collins Iorbee
# Tool: R
# Step 5: Build & Compare Models
#         Model 1: Logistic Regression
#         Model 2: Random Forest
# ============================================================

# Load train and test sets
train_set <- read_csv("data/train_set.csv") %>%
  mutate(across(where(is.character), as.factor),
         churn = as.factor(churn))

test_set <- read_csv("data/test_set.csv") %>%
  mutate(across(where(is.character), as.factor),
         churn = as.factor(churn))

# Set up cross-validation (5-fold)
ctrl <- trainControl(
  method          = "cv",
  number          = 5,
  classProbs      = TRUE,
  summaryFunction = twoClassSummary,
  savePredictions = TRUE
)

set.seed(42)


# ---- 5.1 Model 1: Logistic Regression ----

cat("Training Logistic Regression model...\n")

model_logistic <- train(
  churn ~ .,
  data      = train_set,
  method    = "glm",
  family    = "binomial",
  trControl = ctrl,
  metric    = "ROC"
)

cat("✅ Logistic Regression trained.\n")
print(model_logistic)


# ---- 5.2 Model 2: Random Forest ----

cat("\nTraining Random Forest model...\n")

model_rf <- train(
  churn ~ .,
  data      = train_set,
  method    = "rf",
  trControl = ctrl,
  metric    = "ROC",
  tuneLength = 3,          # try 3 values of mtry
  importance = TRUE
)

cat("✅ Random Forest trained.\n")
print(model_rf)


# ---- 5.3 Compare Models on Cross-Validation ----

results <- resamples(list(
  Logistic_Regression = model_logistic,
  Random_Forest       = model_rf
))

cat("\nModel Comparison (Cross-Validation):\n")
summary(results)

# Plot comparison
png("plots/07_model_comparison_cv.png", width = 700, height = 400, res = 120)
bwplot(results, metric = "ROC",
       main = "Model Comparison — ROC AUC (5-fold CV)")
dev.off()
cat("✅ Plot 7 saved: model comparison\n")


# ---- 5.4 Variable Importance (Random Forest) ----

importance_df <- varImp(model_rf)$importance %>%
  as.data.frame() %>%
  rownames_to_column("Feature") %>%
  arrange(desc(Overall)) %>%
  head(15)

p_importance <- importance_df %>%
  ggplot(aes(x = reorder(Feature, Overall), y = Overall)) +
  geom_col(fill = "#1F4E79", width = 0.6) +
  coord_flip() +
  labs(title = "Top 15 Most Important Features",
       subtitle = "Random Forest Variable Importance",
       x = NULL, y = "Importance Score") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

print(p_importance)
ggsave("plots/08_variable_importance.png", p_importance,
       width = 8, height = 5, dpi = 150)
cat("✅ Plot 8 saved: variable importance\n")


# ---- 5.5 Save Both Models ----

saveRDS(model_logistic, "models/model_logistic.rds")
saveRDS(model_rf,       "models/model_rf.rds")
cat("✅ Both models saved to /models folder\n")

dir.create("models", showWarnings = FALSE)


# ============================================================
# STEP 5 COMPLETE
# What we did:
#   - Built Logistic Regression with 5-fold cross-validation
#   - Built Random Forest with 5-fold cross-validation
#   - Compared both models on ROC AUC score
#   - Plotted top 15 most important features (Random Forest)
#   - Saved both trained models as .rds files
#
# NEXT: Run Step 6 — Evaluate on Test Set & Business Interpretation
# ============================================================
