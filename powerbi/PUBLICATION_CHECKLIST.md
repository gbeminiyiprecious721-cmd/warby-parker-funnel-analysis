# Portfolio publication checklist

Repository: `warby-parker-funnel-analysis`. Review date: 22 November 2026.

## Current state

- [x] Both Power BI pages are complete and visually verified by the project author.
- [x] README covers the two pages, SQL, Python, R, Power BI, DAX and statistical testing.
- [x] Main counts and conversion rates are documented with causal-inference limitations.
- [x] Local caches, backups, binary exports, credentials and editor/environment files are excluded by Git ignore rules.
- [x] Editable PBIP/PBIR/TMDL source is available locally for review.
- [x] Replace four repeated CSV folder paths with one supported Power Query Text parameter, CSV Folder.
- [x] Replace the saved personal CSV Folder value with a documented non-personal placeholder. Every user must configure a real absolute folder before refreshing; no successful refresh with the placeholder is claimed.
- [x] Add and inspect genuine screenshots of both Power BI pages at the canonical image paths.
- [x] Convert Page 1 to genuine PNG format while preserving its dimensions and decoded pixels; verify both screenshot PNG signatures and image decoding.
- [ ] Review and commit the exact file set below, then publish only when authorised.

At the start of this review, `main` matched the locally known `origin/main` (zero commits ahead or behind), with no staged or tracked-file changes. The Power BI project, PBIX, local state and backups were untracked. No remote fetch was performed, so this comparison does not establish the current server state.

The initial publication preparation changed documentation and ignore rules. A subsequent portability update added CSV Folder and changed only the four partition file-path arguments through Microsoft Power BI Modeling MCP. Report layouts, relationships, measures, CSVs and local caches were preserved. No data was refreshed, and no files were staged, committed, pushed or published.

## Portability review

The PBIP points to its Report folder, and `definition.pbir` points to the SemanticModel through a relative path. Required local themes and model definitions are present. There are four Import tables, one customer-ID relationship and ten semantic-model DAX measures.

**Implemented:** all four table Source steps now reference the required Text parameter **CSV Folder**, defined in `definition/expressions.tmdl`. Each appends only its own CSV filename, with trailing folder separators handled. The model has one shared configuration value instead of four repeated folder paths. Its saved value is now the placeholder `C:\YOUR_CHECKOUT\warby-parker-funnel-analysis\powerbi`, which every user must replace before refreshing.

**Required setup after cloning:** set CSV Folder to the checkout's actual absolute `powerbi` directory before applying or refreshing queries. The repository's non-personal placeholder is not a working data source. Refresh can fail until it is configured; no refresh was performed during cleanup. Relative CSV paths are not automatically resolved. See [the opening guide](POWER_BI_GUIDE.md#open-the-report-on-another-computer) for setting the parameter once.

Dependencies are Python with pandas, matplotlib, seaborn and a Jupyter kernel; SQLite; R with dplyr and ggplot2; and compatible Power BI Desktop on Windows. Node.js 20+ and Microsoft Report Authoring CLI v0.5.0 are optional authoring/validation tools. No Power BI Service workspace or cloud credentials are required for local CSV-based viewing.

Local `.pbi` caches are intentionally excluded. A clean checkout must connect to its local CSVs and load them before cached report data is available. The duplicate PBIX is excluded in favour of the editable PBIP source. The `.platform` identity files and `diagramLayout.json` are portable project metadata and remain included.

## Screenshot inventory

- [Page 1](images/page1_customer_conversion.png): genuine PNG, decodes successfully at 2093 x 1185, and has readable KPI values and labels with cleared Style/Fit slicers. Lossless JPEG-to-PNG re-encoding preserved every decoded pixel; before/after pixel SHA-256 hashes matched.
- [Page 2](images/page2_offer_analysis.png): present, valid PNG at 2105 x 1197, with readable KPI values, labels, statistics and recommendations; Style is cleared.
- The supplied Page 2 original, `images/page2_customer_conversion.PNG`, is retained locally. The canonical offer-analysis image is a byte-for-byte copy; the duplicate original is ignored by Git.
- [`../dashboard.png`](../dashboard.png) remains the separate Python/matplotlib analysis summary and was not substituted for a Power BI screenshot.

Both canonical image paths are referenced in the README with captions and are not ignored. No screenshot pixels were generated or edited. Both canonical files have the PNG signature `89-50-4E-47-0D-0A-1A-0A`. The Page 2 screenshot displays 26.2 under its percentage-point label.

## Schema and publication checks

The official schema declarations were restored to the existing PBIP version 1.0 and report binding version 4.0 after backups were made. Every pre-existing property and the semantic-model binding were preserved. CLI v0.5.0 PBIP validation passed with zero errors and zero warnings. Git whitespace checks and local Markdown links passed. Common credential-name/private-key/token checks found no matches in the intended files. Final cleanup replaced the saved personal CSV Folder value with a documented placeholder. Publication-file scans found no remaining personal absolute paths or common credential patterns.

No report design, table, calculation or CSV data was changed. Nothing is staged, committed or pushed.

## Exact proposed commit set

The following 49 files are the complete proposed set of modified and untracked, non-ignored files at this review. Three existing documentation/configuration files are modified, this checklist is new, and the existing Power BI project source is new to Git. The analysis scripts, notebook, datasets and Python dashboard are already tracked and unchanged; they do not need a new commit entry.

**The source-file list is a review manifest. The placeholder is intentionally unconfigured and requires a manual setup step before refresh.** Nothing has been staged, committed or pushed. The requested publication corrections are complete; the final commit and publication remain separate authorised actions.

```text
.gitignore
README.md
powerbi/POWER_BI_GUIDE.md
powerbi/PUBLICATION_CHECKLIST.md
powerbi/Warby_Parker_Dashboard.Report/.platform
powerbi/Warby_Parker_Dashboard.Report/StaticResources/SharedResources/BaseThemes/CY24SU10.json
powerbi/Warby_Parker_Dashboard.Report/definition.pbir
powerbi/Warby_Parker_Dashboard.Report/definition/pages/2ca2c91e384a5d0d0204/page.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/2ca2c91e384a5d0d0204/visuals/2d32b8c49e2287570100/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/2ca2c91e384a5d0d0204/visuals/595c786a5f33845d4b58/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/2ca2c91e384a5d0d0204/visuals/83a60e8ee775086d8048/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/2ca2c91e384a5d0d0204/visuals/85ac194d7092e77b0513/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/2ca2c91e384a5d0d0204/visuals/8ffc42387c4ad7077cbd/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/2ca2c91e384a5d0d0204/visuals/9eb8f0675fe332d163e8/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/2ca2c91e384a5d0d0204/visuals/a1111111111111111111/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/2ca2c91e384a5d0d0204/visuals/a2222222222222222222/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/2ca2c91e384a5d0d0204/visuals/b96b80b39c4f89600e87/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/2ca2c91e384a5d0d0204/visuals/f99cd1e3521af7544972/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/2ca2c91e384a5d0d0204/visuals/fd95e96e19f858a67769/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/b8201b68d3b8e48c1513/page.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/b8201b68d3b8e48c1513/visuals/a0754ab788a4bd036c79/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/b8201b68d3b8e48c1513/visuals/b1000000000000000001/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/b8201b68d3b8e48c1513/visuals/b1000000000000000002/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/b8201b68d3b8e48c1513/visuals/b1000000000000000003/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/b8201b68d3b8e48c1513/visuals/b1000000000000000004/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/b8201b68d3b8e48c1513/visuals/b1000000000000000005/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/b8201b68d3b8e48c1513/visuals/b1000000000000000006/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/b8201b68d3b8e48c1513/visuals/b1000000000000000007/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/b8201b68d3b8e48c1513/visuals/b1000000000000000008/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/b8201b68d3b8e48c1513/visuals/b1000000000000000009/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/b8201b68d3b8e48c1513/visuals/e4f2390dc11014b62615/visual.json
powerbi/Warby_Parker_Dashboard.Report/definition/pages/pages.json
powerbi/Warby_Parker_Dashboard.Report/definition/report.json
powerbi/Warby_Parker_Dashboard.Report/definition/version.json
powerbi/Warby_Parker_Dashboard.SemanticModel/.platform
powerbi/Warby_Parker_Dashboard.SemanticModel/definition.pbism
powerbi/Warby_Parker_Dashboard.SemanticModel/definition/cultures/en-US.tmdl
powerbi/Warby_Parker_Dashboard.SemanticModel/definition/database.tmdl
powerbi/Warby_Parker_Dashboard.SemanticModel/definition/expressions.tmdl
powerbi/Warby_Parker_Dashboard.SemanticModel/definition/model.tmdl
powerbi/Warby_Parker_Dashboard.SemanticModel/definition/relationships.tmdl
powerbi/Warby_Parker_Dashboard.SemanticModel/definition/tables/funnel.tmdl
powerbi/Warby_Parker_Dashboard.SemanticModel/definition/tables/funnel_stages.tmdl
powerbi/Warby_Parker_Dashboard.SemanticModel/definition/tables/purchases.tmdl
powerbi/Warby_Parker_Dashboard.SemanticModel/definition/tables/quiz_dropoff.tmdl
powerbi/Warby_Parker_Dashboard.SemanticModel/diagramLayout.json
powerbi/Warby_Parker_Dashboard.pbip
powerbi/images/page1_customer_conversion.png
powerbi/images/page2_offer_analysis.png
```

## Excluded local material

`.gitignore` excludes `powerbi/backups/`, `*.bak`, `**/.pbi/`, `*.abf`, `*.pbix`, `*.pbit`, temporary files, the generated SQLite database, virtual environments, notebook/Python/R caches, local editor settings and common credential filenames/key files.

The existing local backup copies and cache files are retained on disk. The repository review found no credential-named candidate files or matches for the common private-key/token patterns checked; this does not justify including future local secrets. Keep `.env.example` or `.env.template` free of real credentials if those files are added later.
