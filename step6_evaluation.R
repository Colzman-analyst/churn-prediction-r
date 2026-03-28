# ============================================================
# CUSTOMER CHURN PREDICTION — FINTECH/BANKING
# Author: Collins Iorbee
# Tool: R
# Step 6: Evaluate on Test Set & Business Interpretation
# ============================================================

# Load models and test set
model_logistic <- readRDS("models/model_logistic.rds")
model_rf       <- readRDS("models/model_rf.rds")

test_set <- read_csv("data/test_set.csv") %>%
  mutate(across(where(is.character), as.factor),
         churn = as.factor(churn))


# ---- 6.1 Predictions on Test Set ----

# Logistic Regression predictions
pred_logistic_class <- predict(model_logistic, newdata = test_set)
pred_logistic_prob  <- predict(model_logistic, newdata = test_set, type = "prob")[, "Yes"]

# Random Forest predictions
pred_rf_class <- predict(model_rf, newdata = test_set)
pred_rf_prob  <- predict(model_rf, newdata = test_set, type = "prob")[, "Yes"]


# ---- 6.2 Confusion Matrices ----

cat("\n", strrep("=", 50), "\n")
cat("LOGISTIC REGRESSION — Confusion Matrix\n")
cat(strrep("=", 50), "\n")
cm_logistic <- confusionMatrix(pred_logistic_class, test_set$churn, positive = "Yes")
print(cm_logistic)

cat("\n", strrep("=", 50), "\n")
cat("RANDOM FOREST — Confusion Matrix\n")
cat(strrep("=", 50), "\n")
cm_rf <- confusionMatrix(pred_rf_class, test_set$churn, positive = "Yes")
print(cm_rf)


# ---- 6.3 ROC Curves & AUC ----

roc_logistic <- roc(test_set$churn, pred_logistic_prob, levels = c("No", "Yes"))
roc_rf       <- roc(test_set$churn, pred_rf_prob,       levels = c("No", "Yes"))

cat("\nAUC — Logistic Regression:", round(auc(roc_logistic), 4), "\n")
cat("AUC — Random Forest:      ", round(auc(roc_rf), 4), "\n")

# Plot ROC curves
png("plots/09_roc_curves.png", width = 700, height = 500, res = 130)
plot(roc_logistic, col = "#378ADD", lwd = 2,
     main = "ROC Curves — Model Comparison")
plot(roc_rf, col = "#D85A30", lwd = 2, add = TRUE)
legend("bottomright",
       legend = c(
         paste0("Logistic Regression (AUC = ", round(auc(roc_logistic), 3), ")"),
         paste0("Random Forest (AUC = ",        round(auc(roc_rf), 3), ")")
       ),
       col = c("#378ADD", "#D85A30"), lwd = 2)
dev.off()
cat("✅ Plot 9 saved: ROC curves\n")


# ---- 6.4 Model Performance Summary Table ----

performance <- tibble(
  Model     = c("Logistic Regression", "Random Forest"),
  Accuracy  = c(
    round(cm_logistic$overall["Accuracy"] * 100, 1),
    round(cm_rf$overall["Accuracy"] * 100, 1)
  ),
  Precision = c(
    round(cm_logistic$byClass["Precision"] * 100, 1),
    round(cm_rf$byClass["Precision"] * 100, 1)
  ),
  Recall    = c(
    round(cm_logistic$byClass["Recall"] * 100, 1),
    round(cm_rf$byClass["Recall"] * 100, 1)
  ),
  F1_Score  = c(
    round(cm_logistic$byClass["F1"] * 100, 1),
    round(cm_rf$byClass["F1"] * 100, 1)
  ),
  AUC       = c(
    round(auc(roc_logistic), 3),
    round(auc(roc_rf), 3)
  )
)

cat("\n", strrep("=", 55), "\n")
cat("FINAL MODEL PERFORMANCE SUMMARY\n")
cat(strrep("=", 55), "\n")
print(performance)
write_csv(performance, "data/model_performance_summary.csv")
cat("✅ Performance summary saved.\n")


# ---- 6.5 Business Interpretation ----

cat("\n", strrep("=", 55), "\n")
cat("BUSINESS INTERPRETATION\n")
cat(strrep("=", 55), "\n")
cat("
WHAT THIS MODEL TELLS THE BUSINESS:

1. WHO IS MOST LIKELY TO CHURN?
   - Customers on month-to-month contracts
   - New customers (tenure under 6 months)
   - Customers on Fibre Optic internet with no tech support
   - Customers paying higher monthly charges with no added services

2. WHAT SHOULD THE BUSINESS DO?
   - Target month-to-month customers with loyalty incentives
     to encourage switching to annual/2-year contracts
   - Create an onboarding retention programme for the first
     6 months of a customer's lifecycle
   - Offer bundled tech support & online security services
     to high-risk Fibre Optic customers
   - Identify top 20% high-risk customers monthly using this
     model and assign them to a retention team

3. FINANCIAL IMPACT ESTIMATE:
   - If the company has 7,000 customers and 26.5% churn,
     that's ~1,855 customers lost per year
   - If average revenue per customer = $65/month ($780/year)
   - Total annual churn loss = ~$1.45 million
   - Even reducing churn by 10% saves ~$145,000/year
   - This model enables targeted intervention at a fraction
     of that cost
")
cat(strrep("=", 55), "\n")


# ============================================================
# STEP 6 COMPLETE — PROJECT COMPLETE!
# What we did:
#   - Generated predictions on unseen test data
#   - Evaluated both models with confusion matrices
#   - Plotted and compared ROC curves
#   - Summarised Accuracy, Precision, Recall, F1, AUC
#   - Translated model results into real business action
#
# NEXT: Step 7 — GitHub README (see README.md)
# ============================================================
