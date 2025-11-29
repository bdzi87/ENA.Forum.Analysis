# ENA.Forum.Analysis
Overview

This repository accompanies the article [insert article title] and provides reproducible materials for the Social Network Analysis (SNA) and Epistemic Network Analysis (ENA) conducted in the study. Because the original forum data cannot be shared for ethical and copyright reasons, this repository includes:

anonymised codebook

synthetic example dataset

SNA preprocessing scripts

ENA modelling scripts

package versions and workflow documentation

These resources demonstrate the complete analytic pipeline while protecting participant privacy.
Ethical Note

The original dataset consists of posts from a public online teacher forum. Redistribution of the raw text is prohibited due to:

ethical requirements of the institutional ethics committee

user anonymity considerations

UK copyright regulations for text and data mining

All analyses in this repository use synthetic example data, created solely to demonstrate the workflow.

oftware and Package Versions
Core software

R: 4.3.x

Gephi: 0.10.1

rENA: 0.3.x

R packages

tidyverse (≥ 2.0)

igraph (≥ 2.0)

data.table (≥ 1.14)

ggplot2 (≥ 3.4)

renv (optional: for dependency management)

A complete list of package versions is stored in sessionInfo.txt.

Reproducing the Workflow
1. SNA Preprocessing

The script scripts/sna_preprocessing.R demonstrates how to:

import textual data

extract participation metadata

construct 2-mode (people × threads) matrices

create 1-mode (people × people) projections

compute centrality scores using igraph

export adjacency matrices for visualisation in Gephi
