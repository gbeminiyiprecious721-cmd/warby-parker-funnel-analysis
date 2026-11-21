# Warby Parker: Customer Conversion Funnel and A/B Test

An end-to-end analysis of a fictional Warby Parker customer journey, using **SQL, Python and R**.
It finds where customers drop off, measures conversion from the Style Quiz to Home Try-On to Purchase,
and tests whether sending **5 pairs of glasses instead of 3** changes how many customers buy.

![Dashboard](dashboard.png)

## Key findings

| Question | Result |
|---|---|
| How many quiz customers buy glasses? | **49.5%** (495 of 1,000). 750 received a home try-on box (75.0%), and 66.0% of those bought. |
| Where do customers leave the quiz? | Survey customers fall from 500 at question 1 to 270 at question 5. The biggest losses are at question 3 (20.0%) and question 5 (25.2%). |
| Does the number of pairs matter? | 5 pairs: **79.2%** bought (294 of 371). 3 pairs: **53.0%** bought (201 of 379). |
| Is the difference real? | The gap is 26.2 percentage points (95% confidence interval 19.4 to 33.0). The p-value is 6.4e-14, so chance alone is a very unlikely explanation. |
| Is it worth it? | Each box with 5 pairs brought in 28.96 more purchase value (89.03 versus 60.07). Average prices are the same, so the gain comes from more buyers. This is revenue, not profit. |

## Recommendations

1. **Move towards 5 pairs, after two checks:** compare the extra cost of two more pairs with the extra profit, and run a randomised test to confirm the cause.
2. **Review quiz questions 3 and 5**, which lose the most customers. Fix the question 3 label and test an optional or moved question 5.
3. **Investigate customers who skip the style question.** None of the 69 who received a box bought.
4. **Improve the data:** record how customers are assigned to 3 or 5 pairs, use one customer ID in every table, and correct the question 3 label.

## Limitations

- **Causation is not proven.** The data does not say how customers were given 3 or 5 pairs. The two groups have a similar mix of quiz answers, which is reassuring but is not proof of random assignment.
- **Cost is not included.** The data has prices but no costs or margins.
- **The survey cannot be linked to the funnel.** None of the 500 survey customer IDs match the quiz customers, so quiz drop-off describes a separate group.
- **Survey question 3 looks mislabelled.** It is labelled "How old are you?", but its answers are frame shapes.
- The data is fictional and comes from one time period.

## Project structure

| Path | What it is |
|---|---|
| `analysis.ipynb` | Python analysis: data inspection, cleaning checks, SQLite database, exploratory analysis, interpretation, dashboard and recommendations |
| `analysis.sql` | SQL queries: quiz drop-off, full funnel and 3 versus 5 pairs, with CTEs, `LEFT JOIN` and `GROUP BY` |
| `analysis.R` | R statistical analysis: hypotheses, two-proportion test, confidence intervals, effect sizes and a chart |
| `dashboard.png` | One-page dashboard, created by the notebook |
| `data/` | The four original CSV files (no header row, never modified) |
| `powerbi/` | Tidy data files for Power BI, and a step-by-step guide to rebuild the dashboard |
| `CLAUDE.md`, `AGENTS.md` | Working instructions for the AI assistant used on this project |

## How to run

1. **Python:** open `analysis.ipynb` in VS Code, select a Python 3 kernel and choose **Run All**. This creates `warby_parker.db`, `dashboard.png` and the files in `powerbi/`.
2. **SQL:** after step 1, run `sqlite3 -header -column warby_parker.db < analysis.sql`, or open `analysis.sql` in a SQLite viewer connected to `warby_parker.db`.
3. **R:** set the working directory to the project folder and run `Rscript analysis.R`, or run the script in VS Code.

## Methods

- **Data checks:** no duplicate rows or customers, no missing values, customer IDs match step by step across quiz, try-on and purchase, and joins keep 1,000 rows.
- **Funnel:** `LEFT JOIN` from every quiz customer, so customers who stop early are still counted.
- **A/B test:** two-sided two-proportion test at the 0.05 level, with a confidence interval for the difference, rate ratio and odds ratio. A second test without the "I'm not sure" style customers gives the same conclusion (58.8% versus 86.7%).
- **Dashboard:** a static one-page chart in matplotlib. Power BI files and instructions are in `powerbi/POWER_BI_GUIDE.md`. The guide was written from general knowledge and not tested in Power BI.

## Data

Four fictional Warby Parker datasets from a Codecademy exercise: `survey.csv`, `quiz.csv`, `home_try_on.csv` and `purchase.csv`.
The files have no column names. The notebook names the columns after inspecting the values:

| File | Columns |
|---|---|
| `survey.csv` | question, user_id, response |
| `quiz.csv` | user_id, style, fit, shape, color |
| `home_try_on.csv` | user_id, number_of_pairs, address |
| `purchase.csv` | user_id, product_id, style, model_name, color, price |

## Environment

Python 3.14.6 (pandas 3.0.3, numpy 2.4.6, matplotlib 3.11.0, seaborn 0.13.2), R 4.6.2 (dplyr 1.2.1, ggplot2 4.0.4) and SQLite 3.54.0.
`warby_parker.db` is created by the notebook and is not stored in the repository.

## Project workflow

- [x] 1. Business understanding and project objectives
- [x] 2. Development environment setup
- [x] 3. Data acquisition and initial inspection
- [x] 4. Data cleaning and quality validation
- [x] 5. SQL funnel analysis
- [x] 6. Python exploratory data analysis
- [x] 7. R statistical inference and A/B testing
- [x] 8. Business interpretation
- [x] 9. Data visualisation and dashboard development
- [x] 10. Business recommendations
- [x] 11. Executive presentation (slide deck, shared separately)
- [x] 12. Final review and documentation
