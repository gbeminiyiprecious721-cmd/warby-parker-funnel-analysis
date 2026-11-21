-- Warby Parker Customer Conversion Funnel Analysis
-- SQL queries (SQLite)
-- Database: warby_parker.db (created in analysis.ipynb)
-- Tables: survey, quiz, home_try_on, purchase


-- ============================================================
-- Query 1: Where do customers leave the Style Quiz?
-- ============================================================
-- Count the customers who answered each survey question.
-- LAG() looks at the previous row, so we can compare each question with the one before it.

WITH answers_per_question AS (
    SELECT
        question,
        COUNT(DISTINCT user_id) AS customers
    FROM survey
    GROUP BY question
)
SELECT
    question,
    customers,
    customers - LAG(customers) OVER (ORDER BY question) AS change_from_previous,
    ROUND(100.0 * customers / LAG(customers) OVER (ORDER BY question), 1) AS pct_of_previous,
    ROUND(100.0 * customers / (SELECT MAX(customers) FROM answers_per_question), 1) AS pct_of_question_1
FROM answers_per_question
ORDER BY question;

-- Result: 500 -> 475 -> 380 -> 361 -> 270 customers.
-- The biggest drops are at question 3 (-95, 80.0% of the previous question)
-- and question 5 (-91, 74.8% of the previous question).
-- Only 54.0% of customers who started the quiz reached question 5.
-- Note: the survey customers are a separate group from the quiz customers (IDs do not match).
-- Note: the text of question 3 ("How old are you?") appears to be wrong; its answers are frame shapes.


-- ============================================================
-- Query 2: The full funnel: Quiz -> Home Try-On -> Purchase
-- ============================================================
-- Start from every quiz customer and LEFT JOIN the later stages,
-- so customers who stop early are still counted.
-- COUNT(column) only counts rows that are not empty (NULL).

WITH funnel AS (
    SELECT
        quiz.user_id,
        home_try_on.user_id AS tried_at_home,
        purchase.user_id AS bought
    FROM quiz
    LEFT JOIN home_try_on ON quiz.user_id = home_try_on.user_id
    LEFT JOIN purchase ON quiz.user_id = purchase.user_id
)
SELECT
    COUNT(*) AS quiz_customers,
    COUNT(tried_at_home) AS home_try_on_customers,
    COUNT(bought) AS purchase_customers,
    ROUND(100.0 * COUNT(tried_at_home) / COUNT(*), 1) AS quiz_to_home_try_on_pct,
    ROUND(100.0 * COUNT(bought) / COUNT(tried_at_home), 1) AS home_try_on_to_purchase_pct,
    ROUND(100.0 * COUNT(bought) / COUNT(*), 1) AS quiz_to_purchase_pct
FROM funnel;

-- Result: 1,000 quiz customers -> 750 home try-on -> 495 purchase.
-- Quiz to home try-on: 75.0%. Home try-on to purchase: 66.0%. Quiz to purchase: 49.5%.


-- ============================================================
-- Query 3: Purchase rate for 3 pairs versus 5 pairs
-- ============================================================
-- Among customers who received a home try-on box,
-- how many bought, split by the number of pairs they were sent?

SELECT
    home_try_on.number_of_pairs,
    COUNT(*) AS customers,
    COUNT(purchase.user_id) AS purchases,
    ROUND(100.0 * COUNT(purchase.user_id) / COUNT(*), 1) AS purchase_rate_pct
FROM home_try_on
LEFT JOIN purchase ON home_try_on.user_id = purchase.user_id
GROUP BY home_try_on.number_of_pairs
ORDER BY home_try_on.number_of_pairs;

-- Result: 3 pairs: 201 of 379 bought (53.0%). 5 pairs: 294 of 371 bought (79.2%).
-- The difference is 26.2 percentage points (201 + 294 = 495, which matches Query 2).
-- This is a difference in the data only. A statistical test is needed to judge it.
