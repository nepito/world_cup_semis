library(tidyverse)
path_data <- "tests/data/semis.csv"
semis <- read_csv(path_data, show_col_types = FALSE) %>%
  select(-c(mundial, equipo))

intercept_only <- glm(semifinal ~ 1, data=semis, family="binomial")

all <- glm(semifinal ~ ., data=semis, family="binomial")

both <- step(intercept_only, direction='both', scope=formula(all), trace=0)

semis$prob_semis <- predict(both, newdata = semis, type = "response")

semis <- semis %>%
  mutate(pred_semis = ifelse(prob_semis > treshold, TRUE, FALSE))
test_roc = roc(semis$semifinal ~ semis$prob_semis)
treshold <- coords(test_roc, "best")$threshold