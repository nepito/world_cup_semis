library(tidyverse)
library(wcSemis)
path_data <- "tests/data/semis.csv"
semis <- wcSemis::read_csv(path_data) %>%
  select(-c(mundial, equipo))

intercept_only <- glm(semifinal ~ 1, data = semis, family = "binomial")

all <- glm(semifinal ~ ., data = semis, family = "binomial")

both <- step(intercept_only, direction = "both", scope = formula(all), trace = 0)

path_to_solution <- "tests/data/to_test.csv"
to_solution <- wcSemis::read_csv(path_to_solution)
to_solution$prob_semis <- predict(both, newdata = to_solution, type = "response")
to_solution <- to_solution %>%
  arrange(-prob_semis) %>%
  select(1) %>%
  mutate(semis = c(rep(TRUE, 4), rep(FALSE, 12))) %>%
  arrange(id)

treshold <- 0.5
semis <- semis %>%
  mutate(pred_semis = ifelse(prob_semis > treshold, TRUE, FALSE))
test_roc <- pROC::roc(semis$semifinal ~ semis$prob_semis)
treshold <- coords(test_roc, "best")$threshold

caret::confusionMatrix(factor(solution_mexico_86$semifinal), factor(to_solution$semis))
