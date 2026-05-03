# ShuttleSet EDA — Step-by-Step Workflow
---

## Step 1: Cloned the dataset into project repo root

```bash
git clone https://github.com/wywyWang/CoachAI-Projects.git data/CoachAI-Projects
```

Project Structure:
```
Cognitive-Modeling-Captsone-Project/
├── EDA/
│   ├── EDA-WORKFLOW.md                        
│   ├── 00_data_loading.ipynb
│   ├── 01_schema_and_quality.ipynb
│   ├── 02_player_selection.ipynb
│   └── data/                           
│       ├── * .csv   <-- added in later steps     
│       └── *.parquet  <-- added in later steps                    
└── data/
    └── CoachAI-Projects/   <-- cloned ShuttleSet dataset (added to .gitignore)
        └── ShuttleSet/
            └── set/
                ├── An_Se_Young_.../
                │   ├── set1.csv
                │   └── set2.csv
                └── ...
```

---


## Step 2: Added cloned dataset to .gitignore

```
data/CoachAI-Projects/
```

---

## Step 3: Ran theese notebooks IN ORDER

### `step00_data_loading.ipynb`
- Crawls all match folders
- Concatenates every set CSV into one master dataframe
- Generates `player_map.csv` with parsed A/B player names
- Saves `shuttleset_master.parquet`

### `step01_schema_and_quality.ipynb`
- Verifies all expected columns are present
- Audits nulls
- Removes incomplete/corrupted rallies (missing winner, missing coordinates)
- Saves `shuttleset_clean.parquet`

### `step02_player_selection.ipynb`
- Joins real player names onto every stroke (replaces Player A, player B from original dataset)
- Counts strokes per player across ALL matches
- Applies ≥ 200 stroke threshold
- Documents excluded players with reasons
- Saves `shuttleset_filtered_players.parquet` — the final selected players file

### `step03_feature_engineering.ipynb`
- Maps all 18 shot types to binary offensive (1) / defensive (0) label with documented reasoning for ambiguous cases; services set to NaN
- Computes court-center distance per stroke: √((x − x̄)² + (y − ȳ)²) using grand mean of all player positions
- Defines easy/hard binary split using median distance as threshold; records threshold value
- Computes inter-shot interval (reaction time) as frame difference between opponent's previous stroke and current stroke, converted to seconds using FPS = 30
- Filters implausible reaction times (RT < 100ms or RT > 3s) and documents how many were dropped
- Saves shuttleset_final_features.parquet — dataset with all engineered features

### `step04_eda_plots.ipynb`
- Plots RT distributions per player (histogram + KDE) for easy vs hard conditions
- Plots offensive shot rate per player as a bar chart; notes most and least offensive players
- Plots shot type frequency heatmap for all players combined
- Plots shot type frequency heatmap split by gender; confirms gender is not a meaningful grouping variable
- Plots court-center distance distribution with median split threshold marked
- Checks class imbalance between offensive and defensive strokes overall and by gender
- Exports dataset.csv with columns: player_id, trial_id, choice, RT, difficulty_bin, distance, gender
- Exports player_id_legend.csv mapping integer player IDs to real names
- Saves all figures to EDA/figs/
---

## Final Dataset: 

located at:
```
EDA/data/dataset.csv
```

Every row is one stroke (trial) from one player. Columns are:

- `player_id` — integer ID for the player who hit the stroke (see player_id_legend.csv for name mapping)
- `trial_id` — unique integer ID for each row
- `choice` — whether the stroke was offensive (1) or defensive (0); services excluded
- `RT` — reaction time in seconds (time between opponent's previous stroke and this stroke)
- `difficulty_bin` — whether the stroke was hit from a hard position (1) or easy position (0), defined by median court-center distance split
- `distance` — raw court-center distance in court units at the moment of the stroke
- `gender` — gender of the player who hit the stroke (Men or Women)