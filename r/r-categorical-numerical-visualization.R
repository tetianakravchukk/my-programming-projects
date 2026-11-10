# Installing and loading the necessary packages
install.packages("tidyverse")
install.packages("RColorBrewer")
install.packages("fmsb")
install.packages("viridis")
install.packages("igraph")

library(tidyverse)      # For data processing and plotting
library(dplyr)          # For data manipulation
library(ggplot2)        # For creating graphs
library(stringr)        # For working with text
library(RColorBrewer)   # For color palettes
library(fmsb)           # For radar charts
library(viridis)        # For color scales
library(igraph)         # For network graphs

# Loading data about mental disorders
m_ill <- read.csv("datasets/mental_ill.csv")
View(m_ill)             # Viewing the data

# Selecting data for 2019 for specific regions
year_selected <- 2019
regions <- c("Africa (IHME GBD)", "America (IHME GBD)", "Asia (IHME GBD)", "Europe (IHME GBD)", "Ukraine")

d <- m_ill %>%
  filter(Year == year_selected, Entity %in% regions) %>%          
  mutate(
    Depressive = as.numeric(Depressive),
    CleanEntity = str_replace(Entity, " \\(IHME GBD\\)", ""),
    CleanEntity = factor(CleanEntity, 
                         levels = c("Africa", "America", "Asia", "Europe", "Ukraine"))
  )

# Creating a bar chart
ggplot(d, aes(x = CleanEntity, y = Depressive, fill = CleanEntity)) +
  geom_bar(stat = "identity", color = "black", linewidth = 1.1) +
  scale_fill_brewer(palette = "Paired") +
  theme_bw() +
  labs(title = paste("Depressive Disorders Across World Regions in", year_selected),
       x = "World Region",
       y = "Prevalence of Depressive Disorders (%)",
       fill = "Region") +
  theme(plot.title = element_text(size = 16, face = "bold"),
        axis.text.x = element_text(angle = 25, hjust = 1))

# Creating a long-format dataset for the Ukraine pie chart
ua_long <- m_ill %>%
  filter(Year == 2019, Entity == "Ukraine") %>%
  select(Depressive, Schizophrenia, Bipolar, Eating.disorders, Anxiety) %>% 
  pivot_longer(cols = everything(),
               names_to = "Disorder",
               values_to = "Value") %>%
  mutate(Value = as.numeric(Value))

# Creating a pie chart
ggplot(ua_long, aes(x = "", y = Value, fill = Disorder)) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  coord_polar("y", start = 0) +
  geom_text(aes(label = round(Value, 1)), 
            position = position_stack(vjust = 0.4), 
            size = 3, fontface = "bold") +
  scale_fill_brewer(palette = "Set1") +
  theme_void() +
  labs(title = "Prevalence of Mental Disorders in Ukraine (2019)", 
       fill = "Type of Disorder") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16))

# Loading data about stress-coping strategies
data <- read.csv("datasets/dealing.csv", stringsAsFactors = FALSE)

ua20 <- subset(data, Entity == "Ukraine" & Year == 2020)

ua20 <- ua20[, c("religious.spiritual.activities",
                 "Improved.healthy.lifestyle.behaviors",
                 "change.to.work.situation",
                 "change.to.personal.relationshipsl",
                 "Talked.to.friends.or.family",
                 "Took.prescribed.medication",
                 "Spent.time.in.nature.the.outdoors",
                 "Talked.to.mental.health.professional")]

colnames(ua20) <- c("Religious/Spiritual Practices",
                    "Improving Healthy Habits",
                    "Changes in Work Situation",
                    "Changes in Relationships",
                    "Communication with Family/Friends",
                    "Taking Prescribed Medication",
                    "Spending Time in Nature",
                    "Consulting a Mental Health Professional")

# Setting maximum and minimum values for the radar chart
maxv <- max(ua20, na.rm = TRUE)
minv <- 0
ua20 <- rbind(rep(maxv, 8), rep(minv, 8), ua20)

# Creating a radar chart
par(mar = c(4, 4, 4, 4))
radarchart(ua20,
           pcol = "black",
           pfcol = rgb(0.2, 0.2, 0.9, 0.3),
           plwd = 2,
           cglcol = "grey", cglty = 3, cglwd = 0.7,
           axislabcol = "grey20",
           caxislabels = seq(0, maxv, length.out = 5),
           vlcex = 0.8)

title(main = "Stress-Coping Strategies in Ukraine (2020)", cex.main = 1.3)
box()

# Loading data about phone addiction
df <- read.csv("datasets/phone_addiction.csv", stringsAsFactors = FALSE)

# Categorizing sleep duration for the heatmap
df$sleep_cat <- cut(df$Sleep_Hours,
                    breaks = 5,
                    labels = c("Very Low", "Low", "Medium", "High", "Very High"),
                    include.lowest = TRUE)

# Calculating the average anxiety level
heat <- df %>%
  group_by(Phone_Usage_Purpose, sleep_cat) %>%
  summarise(mean_anxiety = mean(Anxiety_Level, na.rm = TRUE)) %>%
  ungroup()

# Creating a heatmap
ggplot(heat, aes(x = Phone_Usage_Purpose, y = sleep_cat, fill = mean_anxiety)) +
  geom_tile(color = "white") +
  scale_fill_viridis_c(option = "plasma", na.value = "grey90") +
  geom_text(aes(label = round(mean_anxiety, 2)), color = "black", size = 4) +
  labs(title = "Average Anxiety Level by Phone Usage Purpose and Sleep Duration",
       x = "Phone Usage Purpose",
       y = "Sleep Duration (Categories)",
       fill = "Average Anxiety Level") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Creating a scatter plot of phone usage
ggplot(df, aes(x = Phone_Usage_Purpose, y = Daily_Usage_Hours, color = Phone_Usage_Purpose)) +
  geom_jitter(width = 0.2, height = 0, size = 2, alpha = 0.7) +
  theme_minimal() +
  labs(title = "Daily Phone Usage by Category",
       x = "Phone Usage Purpose",
       y = "Daily Usage Hours") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Network graph of the top 5 names
girls <- data.frame(
  Name = c("Sofiia", "Anna", "Mariia", "Olivia", "Viktoriia"),
  Gender = "Female",
  Count = c(8500, 7200, 6500, 5800, 5100)
)

boys <- data.frame(
  Name = c("Artem", "Maksym", "Oleksandr", "Dmytro", "Matvii"),
  Gender = "Male",
  Count = c(9200, 8100, 7400, 6700, 6000)
)

names_data <- rbind(girls, boys)

# Identifying the most popular name among boys and girls
top_female <- names_data$Name[names_data$Gender == "Female"][
  which.max(names_data$Count[names_data$Gender == "Female"])
]

top_male <- names_data$Name[names_data$Gender == "Male"][
  which.max(names_data$Count[names_data$Gender == "Male"])
]

# Creating network nodes and edges
nodes <- c("Popular Names", "Male", "Female", names_data$Name)

edges <- data.frame(
  from = c(rep("Popular Names", 2), names_data$Gender),
  to = c("Male", "Female", names_data$Name)
)

g <- graph_from_data_frame(
  edges,
  vertices = data.frame(name = nodes),
  directed = FALSE
)

# Node sizes
V(g)$size <- ifelse(
  V(g)$name %in% names_data$Name,
  sqrt(names_data$Count[match(V(g)$name, names_data$Name)]) / 2.5,
  25
)

# Node colors: the most popular names are highlighted
V(g)$color <- sapply(V(g)$name, function(x) {
  if (x == top_female) {
    "red"
  } else if (x == top_male) {
    "blue"
  } else if (x %in% names_data$Name) {
    "grey"
  } else if (x == "Male") {
    "lightblue"
  } else if (x == "Female") {
    "pink"
  } else if (x == "Popular Names") {
    "orange"
  } else {
    "lightgrey"
  }
})

# Creating the network layout
set.seed(123)
layout <- layout_with_fr(g)

layout[V(g)$name %in% names_data$Name, 1] <-
  layout[V(g)$name %in% names_data$Name, 1] * 1.5

layout[V(g)$name %in% names_data$Name, 2] <-
  layout[V(g)$name %in% names_data$Name, 2] * 1.5

# Visualizing the network
plot(g,
     layout = layout,
     vertex.label.cex = 0.8,
     vertex.label.color = "black",
     vertex.frame.color = "darkgrey",
     edge.width = 1,
     edge.color = "grey50",
     main = "Top 5 Most Popular Names (2025)")

