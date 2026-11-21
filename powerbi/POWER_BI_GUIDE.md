# Power BI Guide: Warby Parker Dashboard

This guide rebuilds the one-page dashboard (`dashboard.png`) in Power BI Desktop.
All numbers come from `analysis.ipynb`. Power BI only displays them. The statistical test stays in `analysis.R`.

## The four data files

| File | Rows | What one row is |
|---|---|---|
| `funnel.csv` | 1,000 | One quiz customer (quiz answers, number of pairs, `got_home_try_on` and `purchased` as 1/0) |
| `funnel_stages.csv` | 3 | One funnel stage (Style Quiz, Home Try-On, Purchase) |
| `quiz_dropoff.csv` | 5 | One survey question and how many customers answered it |
| `purchases.csv` | 495 | One purchase |

In `funnel.csv`, customers who did not receive a box have `No box` in `number_of_pairs`.

## Step 1: Load the data

1. Open Power BI Desktop. Choose **Home > Get data > Text/CSV**.
2. Select `funnel.csv` and click **Load**. Repeat for the other three files.
3. Open **Model view**. The survey table (`quiz_dropoff`) must not be linked to the others, because survey customers cannot be matched to the funnel customers. A link between `funnel` and `purchases` on `user_id` is fine.

## Step 2: Create the measures

Select the `funnel` table, then **Home > New measure** for each one:

```
Quiz Customers = COUNTROWS(funnel)
Try-On Customers = SUM(funnel[got_home_try_on])
Purchases = SUM(funnel[purchased])
Overall Conversion = DIVIDE([Purchases], [Quiz Customers])
Try-On Purchase Rate = DIVIDE([Purchases], [Try-On Customers])
```

Select the `quiz_dropoff` table and add:

```
Quiz Finish Rate =
DIVIDE(
    CALCULATE(SUM(quiz_dropoff[customers]), quiz_dropoff[question_number] = 5),
    CALCULATE(SUM(quiz_dropoff[customers]), quiz_dropoff[question_number] = 1)
)
```

Back in the `funnel` table, add:

```
Pairs Gap =
CALCULATE([Try-On Purchase Rate], funnel[number_of_pairs] = "5 pairs")
    - CALCULATE([Try-On Purchase Rate], funnel[number_of_pairs] = "3 pairs")
```

Format the rate measures as percentages with 1 decimal place (**Measure tools > Format**).

## Step 3: Build the visuals

| Visual | Fields | Expected result |
|---|---|---|
| Card | `Overall Conversion` | 49.5% |
| Card | `Quiz Finish Rate` | 54.0% |
| Card | `Pairs Gap` | 26.2% (read as 26.2 percentage points) |
| Bar chart (or Funnel) | Axis: `funnel_stages[stage]`, Values: `funnel_stages[customers]` | 1,000, 750, 495 |
| Column chart | Axis: `quiz_dropoff[question]`, Values: `quiz_dropoff[customers]` | 500, 475, 380, 361, 270 |
| Column chart | Axis: `funnel[number_of_pairs]`, Values: `Try-On Purchase Rate` | 53.0% and 79.2% |

Tips:
- To keep the questions in order, select the `question` column, then **Column tools > Sort by column > question_number**.
- To drop "No box" from the pairs chart, add `number_of_pairs` to the visual's filters and untick "No box".
- Turn on data labels. Use blue `#2a78d6` for 3 pairs and orange `#eb6834` for 5 pairs, to match `dashboard.png`.
- Give each chart a title that states the finding, for example "5 pairs: 79.2% bought, versus 53.0% with 3".

## Step 4: Add filters (what Power BI adds over the PNG)

Add slicers using fields from the `funnel` table: `style`, `fit`, `shape`, `color`.
They filter the funnel and the 3 versus 5 pairs charts. They do not filter the quiz drop-off chart (a separate group).

Check: with no filter selected, the numbers must match the table above.

## Step 5: Add the limits as a text box

Insert a **Text box** at the bottom with the same notes as the PNG:
- Quiz drop-off comes from the survey (500 customers), a separate group that cannot be matched to the funnel customers.
- Question 3 is labelled "How old are you?" in the data, but its answers are frame shapes.
- The 3 versus 5 pairs gap is statistically significant (p < 0.001, 95% confidence interval 19.4 to 33.0 points, from the R analysis), but how customers were assigned is unknown, so it does not prove that 5 pairs causes more purchases.

## Note

These steps are written from general knowledge of Power BI Desktop. They were not tested in Power BI, and menu names can differ slightly between versions. Please check each result against the "Expected result" column.
