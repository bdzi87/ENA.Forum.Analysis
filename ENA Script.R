## ---------------------------
##
## Script name: Threaded_ENA_Workflow.R
##
## Purpose:
##   Create an Epistemic Network Analysis (ENA) set from threaded
##   discussion data using reply structure (thread-aware windows).
##
## Data:
##   Fully anonymised discussion forum data.
##   Platform, user, and community identifiers removed.
##
## Requirements:
##   - Each post has a unique ID
##   - Each post has a parent ID (NA or self for thread root)
##   - Binary or weighted codes per post
##
## Dependencies:
##   rENA (>= 0.4), dplyr
##
## ---------------------------

library(rENA)
library(dplyr)
str(data)
| Column name      | Description                                     |
  | ---------------- | ----------------------------------------------- |
  | `thread_id`      | Unique identifier for each discussion thread    |
  | `post_id`        | Unique identifier for each post                 |
  | `parent_post_id` | ID of parent post (NA or root ID if first post) |
  | `post_text`      | Text of the post (can be removed after coding)  |
  | `group_var`      | Analytic grouping variable (e.g. time period)   |
  | `code_*`         | Binary or weighted epistemic codes              |
  units <- data %>%
  select(group_var, thread_id)

conversation <- data %>%
  select(post_id, post_text)
#define your codes##
codes <- data %>%
  select(starts_with("code_"))
ena_data <- ena.accumulate.data(
  units = units,
  conversation = conversation,
  codes = codes,
  
  # Thread-aware window
  window = "MovingStanzaWindow",
  
  # Reply-based segmentation
  parent.id = data$parent_post_id,
  utterance.id = data$post_id,
  
  window.size.back = "INF"
)
#Thread-Aware Accumulation
ena_data <- ena.accumulate.data(
  units = units,
  conversation = conversation,
  codes = codes,
  
  # Thread-aware window
  window = "MovingStanzaWindow",
  
  # Reply-based segmentation
  parent.id = data$parent_post_id,
  utterance.id = data$post_id,
  
  window.size.back = "INF"
)
#Create ENA Set
ena_set <- ena.make.set(
  enadata = ena_data,
  groupVar = "group_var"
)
#Plot Group Differences
ena.plot(
  ena_set,
  scale.to = "points",
  title = "Threaded Epistemic Networks by Group"
)
#Mean Networks (Thread-Sensitive)
group1 <- as.matrix(ena_set$line.weights$group_var$Group1)
group2 <- as.matrix(ena_set$line.weights$group_var$Group2)

group1.mean <- colMeans(group1)
group2.mean <- colMeans(group2)

difference.network <- group1.mean - group2.mean

ena.plot(ena_set) %>%
  ena.plot.network(
    network = difference.network,
    colors = c("blue", "red")
  )
#Make a trajectory set
ena_traj_data <- ena.accumulate.data(
  units = units,
  conversation = conversation,
  codes = codes,
  
  window = "MovingStanzaWindow",
  parent.id = data$parent_post_id,
  utterance.id = data$post_id,
  window.size.back = "INF",
  
  model = "A"   # Accumulated trajectory
)
ena_traj_set <- ena.make.set(
  enadata = ena_traj_data,
  groupVar = "group_var"
)
#Plot
trajectory_points <- cbind(
  as.matrix(ena_traj_set$points)[,1],                 # ENA Dimension 1
  ena_traj_set$trajectories$ActivityNumber * 0.02     # scaled progression
)

ena.plot(ena_traj_set) %>%
  ena.plot.trajectory(
    points = trajectory_points,
    names = unique(ena_traj_set$trajectories$ENA_UNIT),
    by = ena_traj_set$trajectories$ENA_UNIT,
    labels = ""
  )
#Hypothesis testing
group1_points <- as.matrix(
  ena_set$points$group_var$Group1
)

group2_points <- as.matrix(
  ena_set$points$group_var$Group2
)
#t-Test on dimensions
t_test_d1 <- t.test(
  group1_points[,1],
  group2_points[,1]
)
t_test_d1
t_test_d2 <- t.test(
  group1_points[,2],
  group2_points[,2]
)
t_test_d2

t.test(
  group1_points[,1],
  group2_points[,1],
  var.equal = FALSE
)

#Wilcox t-test
wilcox_d1 <- wilcox.test(
  group1_points[,1],
  group2_points[,1]
)

wilcox_d2 <- wilcox.test(
  group1_points[,2],
  group2_points[,2]
)

wilcox_d1
wilcox_d2

## NOTE:
## Statistical tests are conducted on ENA unit scores (threads),
## not on individual posts or adjacency vectors.
## Welch’s t-test is used as it does not assume equal variances
## or equal group sizes.

# Extract ENA unit scores by group
group1_points <- as.matrix(
  ena_set$points$group_var$Group1
)

group2_points <- as.matrix(
  ena_set$points$group_var$Group2
)

# ----------------------------------------
# Welch’s t-tests on ENA Dimensions
# ----------------------------------------

## Dimension 1
welch_d1 <- t.test(
  group1_points[, 1],
  group2_points[, 1],
  var.equal = FALSE   # Explicit Welch correction
)

## Dimension 2
welch_d2 <- t.test(
  group1_points[, 2],
  group2_points[, 2],
  var.equal = FALSE
)

# View results
welch_d1
welch_d2

