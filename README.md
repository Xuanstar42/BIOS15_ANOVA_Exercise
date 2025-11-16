# Butterfly Host-Plant Experiment: Analysis Workflow

This README describes the full R workflow used to analyse how maternal and larval host plants influence three key performance traits in butterflies: development time, adult weight, and growth rate. The analysis includes both linear models and a mixed-effects model to assess fixed and random sources of variation.

## 1. Required Packages

Install required packages:

```
install.packages("ggplot2")
install.packages("lme4")
install.packages("Matrix")
```

Load packages:

```
library(Matrix)
library(lme4)
library(ggplot2)
```

## 2. Data Preparation

The dataset is loaded from `butterflies.csv`.  
Maternal and larval host plant identifiers are modified to clearly denote treatment groups:

```
dat = read.csv("butterflies.csv")
dat$MaternalHost = paste0(dat$MaternalHost, "M")
dat$LarvalHost   = paste0(dat$LarvalHost, "L")
```

## 3. Linear Model Analyses

Three offspring traits were analysed using fixed‐effects linear models:

- Development time  
- Adult weight  
- Growth rate  

Each trait was modelled as:

```
Trait ~ MaternalHost * LarvalHost + Sex
```

Example (development time):

```
model_development = lm(DevelopmentTime ~ MaternalHost * LarvalHost + Sex, data = dat)
summary(model_development)
```

## 4. Mixed-Effects Model for Development Time

Because multiple offspring originate from each mother, a mixed-effects model is used to separate:

- Fixed effects (maternal host, larval host, sex, interaction)  
- Random effect (mother identity)

Model specification:

```
DevelopmentTime ~ MaternalHost * LarvalHost + Sex + (1 | MotherID)
```

Run the model:

```
model_lme <- lmer(DevelopmentTime ~ MaternalHost * LarvalHost + Sex + (1 | MotherID), data = dat)
summary(model_lme)
anova(model_lme)
```

## 5. Random Intercept Visualization

Random effects (mother-specific deviations in development time) are extracted:

```
ranef_data <- ranef(model_lme)$MotherID
ranef_data$MotherID <- rownames(ranef_data)
```

Plotting code:

```
p <- ggplot(ranef_data, aes(x = reorder(MotherID, (Intercept)), y = (Intercept))) +
  geom_point(size = 3, color = "steelblue") +
  geom_hline(yintercept = 0, linetype = "dashed") +
  coord_flip() +
  theme_minimal(base_size = 14) +
  labs(x = "Mother ID",
       y = "Deviation in development time (days)",
       title = "Random intercepts for each mother")
```

Save a high-resolution version:

```
ggsave("random_intercepts_highres.png",
       plot = p,
       width = 8, height = 6, units = "in",
       dpi = 1200)
```

## 6. Output Files

- **random_intercepts_highres.png** — High-resolution plot of random intercepts  
- Model summaries printed to console  
- Interaction plots for each trait generated in RStudio  

## 7. Summary

This analysis evaluates:

- Fixed effects of maternal and larval host plants  
- Possible sex differences  
- Interaction effects between maternal and larval environments  
- Random variation among mothers  

Both classical linear models and a mixed-effects model were used to determine how environmental and maternal factors shape offspring performance.
