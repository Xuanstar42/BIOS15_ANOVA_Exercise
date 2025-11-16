
# ---- Package Installation and Loading ----
install.packages("ggplot2")
install.packages("lme4")
install.packages("Matrix")

library(Matrix)
library(lme4)
library(ggplot2)

# ---- Data Loading ----
dat = read.csv("butterflies.csv")
names(dat)
dat$MaternalHost = paste0(dat$MaternalHost,"M")
dat$LarvalHost = paste0(dat$LarvalHost,"L")


# ---- Development Time Analysis ----
model_development = lm(DevelopmentTime ~ MaternalHost * LarvalHost + Sex, data = dat)
summary(model_development)
ggplot(dat, aes(x = LarvalHost, y = DevelopmentTime, color = MaternalHost)) +
  stat_summary(fun = mean, geom = "point", position = position_dodge(width = 0.2), size = 3) +
  stat_summary(fun = mean, geom = "line", aes(group = MaternalHost),
               position = position_dodge(width = 0.2), size = 1) +
  stat_summary(fun.data = mean_se, geom = "errorbar",
               width = 0.1, position = position_dodge(width = 0.2)) +
  theme_minimal(base_size = 14) +
  labs(x = "Larval host plant", y = "Mean development time (days)",
       color = "Maternal host") +
  theme(legend.position = "top")

# ---- Adult Weight Analysis ----
model_weight = lm(AdultWeight ~ MaternalHost * LarvalHost + Sex, data = dat)
summary(model_weight)
ggplot(dat, aes(x = LarvalHost, y = AdultWeight, color = MaternalHost)) +
  stat_summary(fun = mean, geom = "point", position = position_dodge(width = 0.2), size = 3) +
  stat_summary(fun = mean, geom = "line", aes(group = MaternalHost),
               position = position_dodge(width = 0.2), size = 1) +
  stat_summary(fun.data = mean_se, geom = "errorbar",
               width = 0.1, position = position_dodge(width = 0.2)) +
  theme_minimal(base_size = 14) +
  labs(x = "Larval host plant", y = "Mean adult weight (mg)",
       color = "Maternal host") +
  theme(legend.position = "top")

# ---- Growth Rate Analysis ----
model_growth = lm(GrowthRate ~ MaternalHost * LarvalHost + Sex, data = dat)
summary(model_growth)
ggplot(dat, aes(x = LarvalHost, y = GrowthRate, color = MaternalHost)) +
  stat_summary(fun = mean, geom = "point", position = position_dodge(width = 0.2), size = 3) +
  stat_summary(fun = mean, geom = "line", aes(group = MaternalHost),
               position = position_dodge(width = 0.2), size = 1) +
  stat_summary(fun.data = mean_se, geom = "errorbar",
               width = 0.1, position = position_dodge(width = 0.2)) +
  theme_minimal(base_size = 14) +
  labs(x = "Larval host plant", y = "Mean growth rate",
       color = "Maternal host") +
  theme(legend.position = "top")

# ---- Graph Plotting ----
model_lme <- lmer(DevelopmentTime ~ MaternalHost * LarvalHost + Sex + (1 | MotherID), data = dat)
summary(model_lme)
anova(model_lme)

ranef_data <- ranef(model_lme)$MotherID
ranef_data$MotherID <- rownames(ranef_data)

p <- ggplot(ranef_data, aes(x = reorder(MotherID, `(Intercept)`), y = `(Intercept)`)) +
  geom_point(size = 3, color = "steelblue") +
  geom_hline(yintercept = 0, linetype = "dashed") +
  coord_flip() +
  theme_minimal(base_size = 14) +
  labs(x = "Mother ID", y = "Deviation in development time (days)",
       title = "Random intercepts for each mother")


ggsave("random_intercepts_highres.png",
       plot = p,
       width = 8, height = 6, units = "in",
       dpi = 1200)
