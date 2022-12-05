# Ejemplo sacado de https://jaseziv.github.io/worldfootballR/articles/extract-fbref-data.html
library(worldfootballR)
library(tidyverse)

get_lineup_for_team_from_lineup_match <- function(lineup_match, team) {
  lineup_for_team <- lineup_match %>%
    filter(Team == team) %>%
    select(c(6, 10, 11)) %>%
    separate(Age, c("Years", "Days")) %>%
    mutate(Years = as.numeric(Years), Days = as.numeric(Days)) %>%
    mutate(age = Years + Days / 365, age_min = age * Min) %>%
    filter(!is.na(Min)) %>%
    arrange(-age_min)
  return(lineup_for_team)
}

reportes <- fb_match_report(wc_2018_urls)
a_vs_m_url <- reportes[arg_vs_mex, ]$Game_URL
fb_match_lineups(a_vs_m_url)

get_mean_age_played <- function(lineup) {
  return(sum(lineup$age_min) / sum(lineup$Min))
}

wc_2022_urls <- fb_match_urls(
  country = "",
  gender = "M",
  season_end_year = 2022,
  tier = "",
  non_dom_league_url = "https://fbref.com/en/comps/1/history/World-Cup-Seasons"
)

mexico <- fb_match_lineups(wc_2022_urls[39]) %>%
  get_lineup_for_team_from_lineup_match("Mexico")
