# Power BI guide: Warby Parker dashboard

The completed report has two pages. Open [Warby_Parker_Dashboard.pbip](Warby_Parker_Dashboard.pbip) together with its adjacent Report and SemanticModel folders. The project author has visually verified both pages in Power BI Desktop.

## What each page shows

| Page | Purpose | Interactivity |
|---|---|---|
| Page 1: Customer conversion | Customer KPIs, the overall conversion funnel, Style Quiz Reach and the three-pair/five-pair comparison. | Style and Fit filter customer KPIs and the offer chart. The overall funnel and survey-reach charts stay static. |
| Page 2: Home Try-On Offer Analysis | Offer purchase rates, the observed difference, overall statistical evidence and business recommendations. | Style filters the KPIs and offer chart. Statistical results and overall sample counts stay fixed. |

The overall funnel contains 1,000 quiz customers, 750 Home Try-On customers and 495 purchasers. Overall purchase conversion is 49.5%. Three-pair conversion is 201/379 (53.0%); five-pair conversion is 294/371 (79.2%).

The difference card uses the existing `Purchase Rate Difference` measure through the report-only expression `100 * [Purchase Rate Difference]`. Its display format is `+0.0;-0.0;0.0`, and the label identifies percentage points. This does not add or change a semantic-model measure.

## Data and model

| CSV source | Rows | Grain |
|---|---|---|
| `funnel.csv` | 1,000 | One quiz customer, including quiz answers and try-on/purchase flags. |
| `funnel_stages.csv` | 3 | One overall funnel stage. |
| `purchases.csv` | 495 | One purchase. |
| `quiz_dropoff.csv` | 5 | One question from the separate survey cohort. |

The model uses Import mode, four tables and ten DAX measures. Its only relationship links `purchases.user_id` to `funnel.user_id`. The two summary tables remain disconnected. Do not add relationships merely to make their visuals respond to slicers.

The quiz-reach chart describes 500 survey customers, ending with 270 at question five. Their IDs cannot be matched to the 1,000-customer quiz/funnel cohort. Question three is labelled as age in the source but contains frame-shape answers.

## Open the report on another computer

1. Clone or download the complete repository. Keep the PBIP, Report and SemanticModel folders together.
2. Install a Power BI Desktop version that supports PBIP/PBIR and the report's card visuals. The Microsoft authoring CLI is only needed for programmatic editing and validation.
3. Open `powerbi/Warby_Parker_Dashboard.pbip`.
4. Open **Transform data**, then **Home > Manage Parameters** in Power Query Editor. Select the required Text parameter **CSV Folder**.
5. Set its **Current Value** to the full absolute path of your checkout's `powerbi` directory, for example `C:\Projects\warby-parker-funnel-analysis\powerbi`. Enter the folder only, without quotation marks or a CSV filename. A trailing slash or backslash is optional. All four queries reuse this value, so no individual Source steps need editing.
   The shipped value, `C:\YOUR_CHECKOUT\warby-parker-funnel-analysis\powerbi`, is a placeholder. Replace it before applying queries or refreshing. It is not a working data location supplied by this repository.
6. Choose **OK**, then **Close & Apply**. Permit local file access or set the appropriate privacy level if Desktop asks. Refresh/load the four tables when ready to populate or update the imported data. A fresh checkout does not include the original computer's `.pbi` cache.
7. Clear slicers and check the overall counts and rates shown above.

If the project was already open while the model files were edited, reopen the PBIP to load the updated definition before configuring the parameter.

## How the shared folder parameter works

`Warby_Parker_Dashboard.SemanticModel/definition/expressions.tmdl` defines the required Power Query Text parameter **CSV Folder**. Its published value is the non-personal placeholder `C:\YOUR_CHECKOUT\warby-parker-funnel-analysis\powerbi`. Every user, including the original project author, must set an actual local folder before refreshing. This is configurable, not automatic relative-path discovery.

Each query combines the parameter with its unchanged CSV filename. For example:

```powerquery
File.Contents(Text.TrimEnd(#"CSV Folder", {"\", "/"}) & "\funnel.csv")
```

The four queries are in:

- `Warby_Parker_Dashboard.SemanticModel/definition/tables/funnel.tmdl`
- `Warby_Parker_Dashboard.SemanticModel/definition/tables/funnel_stages.tmdl`
- `Warby_Parker_Dashboard.SemanticModel/definition/tables/purchases.tmdl`
- `Warby_Parker_Dashboard.SemanticModel/definition/tables/quiz_dropoff.tmdl`

**Portability status:** all four CSV sources now share one supported parameter. The report-to-model binding remains relative. Desktop does not automatically resolve these CSV paths relative to the PBIP. Set **CSV Folder** once for each clone or new checkout location. No data, delimiter, encoding, header promotion, column types, relationships, measures or report layouts were changed.

The parameter's current value is stored in the model source. The personal path has been removed. Refresh is expected to fail with the placeholder unless that location happens to exist and contains all four CSV files. No successful refresh with the placeholder is claimed or required for publication. Existing cached visuals and screenshots do not prove that a new checkout has loaded data successfully. Avoid committing a personal replacement value when saving your own configured copy.

This uses standard [Power Query parameters](https://learn.microsoft.com/en-us/power-query/power-query-query-parameters) and the documented [File.Contents](https://learn.microsoft.com/en-us/powerquery-m/file-contents) function.

The four CSVs can also be regenerated by running `analysis.ipynb` from the repository root. The notebook creates the SQLite database and Python dashboard as well.

## Statistical interpretation

The overall comparison comes from `analysis.R`: a two-sided `prop.test()` with its default continuity correction, an approximate p-value of 6.4e-14 and an approximate 95% confidence interval of 19.4 to 33.0 percentage points for the difference.

Random assignment has not been independently confirmed. Statistical significance supports an association under the test assumptions; it does not establish that the five-pair offer caused higher purchases. Costs and profit margins are not included. A randomised controlled experiment and profitability assessment are recommended.

## Screenshots and validation

`../dashboard.png` is the notebook-generated matplotlib dashboard. The actual Power BI screenshots are `images/page1_customer_conversion.png` and `images/page2_offer_analysis.png`, and both are displayed in the README. They have been opened and inspected: the KPI values and labels are readable and the slicers show All.

Page 2 was supplied as `page2_customer_conversion.PNG`; a byte-for-byte copy uses the canonical `page2_offer_analysis.png` filename. The original remains on disk and is ignored by Git to avoid publishing duplicate screenshots. Page 1 has been losslessly re-encoded from its JPEG container into genuine PNG format. Its 2093 x 1185 dimensions and every decoded pixel were preserved. Both published images now have valid PNG signatures and decode successfully.

The parameterised semantic model was exported through Microsoft Power BI Modeling MCP and loaded back successfully: four tables, one relationship, ten DAX measures and one Power Query parameter. Before/after model comparison found only the parameter addition and four source-path substitutions. The complete PBIP validation passed with zero errors and zero warnings using:

```powershell
powerbi-report-author --pretty validate "powerbi/Warby_Parker_Dashboard.pbip"
```

CLI v0.5.0 requires Node.js 20 or later. TMDL reload and CLI schema validation do not execute Power Query/M or replace a Desktop data load. No data refresh was performed during parameterisation or placeholder cleanup. The existing CSVs and local caches were retained. The project author confirmed Desktop rendering before this model change; manual parameter configuration and a load/refresh are needed to verify runtime behaviour after reopening on a new checkout.

Keep the official `$schema` declarations in the PBIP and `definition.pbir`. Desktop may remove them on save, so check validation again after a later save.

## Files kept local

Git ignores `.pbi/` state and caches, report backups, `.bak` files, local editor/environment settings, credentials and duplicate PBIX/PBIT exports. The PBIP/PBIR/TMDL source and required static resources are the version-controlled report. The `.platform` files are report/model identity metadata and should be retained.
