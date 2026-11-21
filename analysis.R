# Warby Parker Customer Conversion Funnel Analysis
# R statistical analysis (base R, dplyr, ggplot2)
# Run this script with the working directory set to the project folder.

library(dplyr)
library(ggplot2)


# ============================================================
# 1. Load the data
# ============================================================
# The CSV files have no header row, so we use header = FALSE and name the columns ourselves.

home_try_on <- read.csv("data/home_try_on.csv", header = FALSE,
                        col.names = c("user_id", "number_of_pairs", "address"))
purchase <- read.csv("data/purchase.csv", header = FALSE,
                     col.names = c("user_id", "product_id", "style", "model_name", "color", "price"))
quiz <- read.csv("data/quiz.csv", header = FALSE,
                 col.names = c("user_id", "style", "fit", "shape", "color"))

# Check the number of rows (expected: 750, 495 and 1000)
cat("home_try_on rows:", nrow(home_try_on), "\n")
cat("purchase rows:", nrow(purchase), "\n")
cat("quiz rows:", nrow(quiz), "\n\n")


# ============================================================
# 2. Prepare the A/B test data
# ============================================================
# Only customers who received a home try-on box were sent 3 or 5 pairs,
# so the test uses the 750 home try-on customers.
# purchased is TRUE if the customer appears in the purchase table.

ab_data <- home_try_on %>%
  mutate(purchased = user_id %in% purchase$user_id)

group_summary <- ab_data %>%
  group_by(number_of_pairs) %>%
  summarise(customers = n(),
            purchases = sum(purchased),
            purchase_rate = purchases / customers)

print(group_summary)


# ============================================================
# 3. Hypotheses
# ============================================================
# Null hypothesis (H0):        the purchase rate is the same for customers sent 3 pairs and 5 pairs.
# Alternative hypothesis (H1): the purchase rate is different for the two groups.
# Significance level: 0.05 (two-sided test).


# ============================================================
# 4. Hypothesis test: comparing two proportions
# ============================================================
# prop.test() compares two proportions. We use it because the outcome (purchased or not)
# is yes/no, and we are comparing two separate groups.
# rev() puts the 5 pairs group first, so the difference is calculated as 5 pairs minus 3 pairs.

ab_test <- prop.test(x = rev(group_summary$purchases),
                     n = rev(group_summary$customers))
print(ab_test)

# Check the test assumption: every expected count should be at least 5.
purchase_table <- table(ab_data$number_of_pairs, ab_data$purchased)
print(round(chisq.test(purchase_table)$expected, 1))

# Result:
# The 5 pairs group purchased at a higher rate: 79.2% (294 of 371) versus 53.0% (201 of 379).
# The p-value is 6.4e-14, far below 0.05, so we reject the null hypothesis.
# In simple terms: if 3 and 5 pairs really led to the same purchase rate,
# a gap this large would almost never appear by chance.
# All expected counts are well above 5, so the test is appropriate.


# ============================================================
# 5. Effect size: how big is the difference?
# ============================================================
# A p-value only says whether a difference is likely to be real, not how big it is.

three_pairs <- group_summary %>% filter(number_of_pairs == "3 pairs")
five_pairs <- group_summary %>% filter(number_of_pairs == "5 pairs")

difference <- five_pairs$purchase_rate - three_pairs$purchase_rate
rate_ratio <- five_pairs$purchase_rate / three_pairs$purchase_rate
odds_ratio <- (five_pairs$purchases / (five_pairs$customers - five_pairs$purchases)) /
  (three_pairs$purchases / (three_pairs$customers - three_pairs$purchases))

cat("\nPurchase rate, 3 pairs:", format(round(three_pairs$purchase_rate * 100, 1), nsmall = 1), "%\n")
cat("Purchase rate, 5 pairs:", format(round(five_pairs$purchase_rate * 100, 1), nsmall = 1), "%\n")
cat("Difference (5 minus 3 pairs):", round(difference * 100, 1), "percentage points\n")
cat("95% confidence interval for the difference:",
    format(round(ab_test$conf.int[1] * 100, 1), nsmall = 1), "to",
    format(round(ab_test$conf.int[2] * 100, 1), nsmall = 1), "percentage points\n")
cat("Rate ratio:", round(rate_ratio, 2), "\n")
cat("Odds ratio:", round(odds_ratio, 2), "\n")

# Result:
# The 5 pairs group purchased 26.2 percentage points more often.
# We are 95% confident that the true difference is between 19.4 and 33.0 percentage points.
# The interval does not include 0, which agrees with the test.
# The purchase rate is about 1.5 times higher with 5 pairs (rate ratio 1.49).
# The odds of purchase are about 3.4 times higher (odds ratio 3.38).


# ============================================================
# 6. Chart: purchase rate with confidence intervals
# ============================================================
# Each bar shows the purchase rate. The black line is the 95% confidence interval.

three_ci <- prop.test(three_pairs$purchases, three_pairs$customers)$conf.int
five_ci <- prop.test(five_pairs$purchases, five_pairs$customers)$conf.int

plot_data <- data.frame(
  group = c("3 pairs", "5 pairs"),
  rate = c(three_pairs$purchase_rate, five_pairs$purchase_rate) * 100,
  lower = c(three_ci[1], five_ci[1]) * 100,
  upper = c(three_ci[2], five_ci[2]) * 100)

ab_plot <- ggplot(plot_data, aes(x = group, y = rate, fill = group)) +
  geom_col(width = 0.5) +
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.15) +
  geom_text(aes(y = upper, label = paste0(format(round(rate, 1), nsmall = 1), "%")), vjust = -0.6) +
  scale_fill_manual(values = c("3 pairs" = "#2a78d6", "5 pairs" = "#eb6834")) +
  scale_y_continuous(limits = c(0, 100)) +
  labs(title = "Purchase rate by number of pairs sent",
       subtitle = "Bars show the purchase rate; lines show the 95% confidence interval",
       x = NULL, y = "Customers who purchased (%)") +
  theme_minimal() +
  theme(legend.position = "none")

print(ab_plot)

# Result:
# 3 pairs: 53.0% (95% confidence interval 47.9% to 58.1%).
# 5 pairs: 79.2% (95% confidence interval 74.7% to 83.2%).
# The two intervals do not overlap, which agrees with the test.


# ============================================================
# 7. Extra check: customers who answered "I'm not sure" to the style question
# ============================================================
# In the Python analysis, none of the 69 home try-on customers who skipped the style question purchased.
# This could affect the comparison, so we repeat the test without them.

ab_known_style <- ab_data %>%
  left_join(select(quiz, user_id, style), by = "user_id") %>%
  filter(style != "I'm not sure. Let's skip it.")

known_summary <- ab_known_style %>%
  group_by(number_of_pairs) %>%
  summarise(customers = n(),
            purchases = sum(purchased),
            purchase_rate = purchases / customers)

print(known_summary)

known_test <- prop.test(x = rev(known_summary$purchases),
                        n = rev(known_summary$customers))
cat("\np-value without the 'not sure' customers:", signif(known_test$p.value, 3), "\n")
cat("Difference (5 minus 3 pairs):",
    format(round((known_test$estimate[1] - known_test$estimate[2]) * 100, 1), nsmall = 1), "percentage points\n")
cat("95% confidence interval:",
    round(known_test$conf.int[1] * 100, 1), "to", round(known_test$conf.int[2] * 100, 1), "percentage points\n")

# Result:
# Without these customers, the purchase rate is 58.8% (3 pairs) versus 86.7% (5 pairs).
# The difference is larger (about 28 points) and still clearly significant.
# Both groups had a similar share of these customers (about 9% to 10%), so they do not explain the gap.


# ============================================================
# 8. Conclusion
# ============================================================
# Statistical significance: the difference is very unlikely to be due to chance (p = 6.4e-14).
# Practical importance: the gap is large. About 26 more customers purchase for every 100 customers
# who receive a box with 5 pairs instead of 3. Sending 5 pairs may cost more, so the extra
# cost should be compared with the extra purchases before making a decision.
#
# Limitations:
# - The data does not say how customers were given 3 or 5 pairs. If they were not assigned at random,
#   we cannot say that sending 5 pairs causes more purchases. The quiz answers of the two groups
#   look similar (see the Python analysis), which is reassuring but is not proof.
# - The test only compares purchase rates. It does not include the cost of sending extra pairs.
# - Customers who did not receive a box are not part of this test.
