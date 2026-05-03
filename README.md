# Cognitive-Modeling-Capstone-Project
### Badminton Shot Selection as a Two-Choice Decision Problem 
---
 
## Overview
 
This project models badminton shot selection as a rapid binary decision problem using the Drift Diffusion Model (DDM). The core question is: **how do players make fast offensive vs. defensive shot decisions, and does situational difficulty change the underlying decision process?** The goal is to examine whether a cognitive decision model can explain patterns in real sports behavior. 
 
---
 
## Research Question
 
How do players make fast binary decisions between offensive and defensive shots in badminton, and does court position (situational difficulty) change the estimated drift rate?
 
**Hypothesis:** v_easy > v_hard — when a player is near the court center (good position), the evidence for shot selection is stronger, producing a higher drift rate than when the player is far from center (difficult position).
 
---
 
## Dataset
 
**ShuttleSet** — stroke-level badminton data from professional singles matches (2018–2021).
 
- 36,000+ strokes across 44 matches between top-ranking players
- Each stroke includes: shot type, player/opponent court position (x, y), landing coordinates, frame number, rally and match identifiers
- Source: https://github.com/wywyWang/CoachAI-Projects/tree/main/ShuttleSet
---
 
## Method
 
### Binary Choice Label
 
Each of the 18 ShuttleSet shot types is mapped to a binary label:
 
| Label | Value | Examples |
|---|---|---|
| Offensive | 1 | smash, net shot, push, rush, drop, wrist smash, drive |
| Defensive | 0 | clear, lob, return net, defensive return lob/drive |
| Excluded | NaN | short service, long service |
 
### Difficulty (Easy vs. Hard)
 
Difficulty is defined as the player's distance from the court center at the moment of the stroke:
 
```
distance = √((x − x̄)² + (y − ȳ)²)
```
 
where x̄ and ȳ are the grand mean of all player positions across the dataset. The easy/hard binary split is defined by the median distance (median split).
 
- **Easy (0):** player is closer to center than the median — good court position
- **Hard (1):** player is farther from center than the median — difficult position
### Reaction Time
 
Reaction time (RT) is defined as the time between the opponent's previous stroke and the player's current stroke, computed from `frame_num`:
 
```
RT (seconds) = (frame_num_current − frame_num_previous) / 30
```
 
Implausible RTs (< 100ms or > 3s) are excluded.
 
### DDM Parameters
 
| Parameter | Description | Varies by condition? |
|---|---|---|
| v (drift rate) | Speed and quality of evidence accumulation toward a decision | Yes — v_easy vs. v_hard |
| a (boundary separation) | Response caution — how much evidence is needed before committing | No — fixed across conditions |
| t (non-decision time) | Motor execution and perception time, separate from decision | No — fixed across conditions |
 
The core test is whether **v_easy > v_hard** — i.e., whether being in a good court position produces a stronger, faster evidence accumulation process.
 
---
 
## Models
 
### Flat DDM
A standard DDM estimated across all players combined. This serves as the baseline model.
 
### Hierarchical DDM
A two-level hierarchical model that pools individual players toward a population mean:
 
```
Population
    └── Individual players (partial pooling)
```
 
Each player gets their own DDM parameters, but they are regularized toward the group mean. This eliminates individual differences through shrinkage and is the primary model of interest.
 
### Gender-Level Analysis (Exploratory)
Gender was tracked as a potential grouping variable for a three-level hierarchy. EDA showed virtually no difference in offensive rate between men (60.4%) and women (60.1%), so gender was not included as a meaningful grouping variable in the primary models.
 
---
 
## Workflow
 
Analysis done in EDA/ directory

| Notebook | Purpose | Output |
|---|---|---|
| `step00_load_data.ipynb` | Load all CSVs, parse player names | `shuttleset_master.parquet`, `player_map.csv` |
| `step01_schema_quality.ipynb` | Verify schema, remove bad rallies | `shuttleset_clean.parquet`, `removed_rallies.csv` |
| `step02_player_selection.ipynb` | Filter to players with ≥ 200 strokes | `shuttleset_filtered.parquet`, `included_players.csv` |
| `step03_feature_engineering.ipynb` | Compute choice, RT, distance, difficulty | `shuttleset_features.parquet` |
| `step04_eda_plots.ipynb` | EDA plots and final dataset export | `dataset.csv`, `EDA/figs/` |
 
### Final Dataset
 
`EDA/data/dataset.csv` — one row per stroke (trial), containing:
 
| Column | Description |
|---|---|
| `player_id` | Integer ID for the player |
| `trial_id` | Unique integer ID for each stroke |
| `choice` | 1 = offensive, 0 = defensive |
| `RT` | Reaction time in seconds |
| `difficulty_bin` | 1 = hard (far from center), 0 = easy (close to center) |
| `distance` | Raw court-center distance in court units |
| `gender` | `Male` or `Female` |

---

### Model Evaluation
 
---
 
---
 
