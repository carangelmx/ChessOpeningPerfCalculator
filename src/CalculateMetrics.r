#provides a simpler format for batch_red
games <- tbl_df(batch_read)

#removes registers with non numeric ELOs
games <- games %>% filter(!is.numeric(BlackElo) | !is.numeric(WhiteElo))

#turns ELO to numeric
games <- games %>% mutate(BlackElo = as.numeric(BlackElo), WhiteElo = as.numeric(WhiteElo))


#Determines the winning value of the game
finalres <- function(gameresult){
  ifelse(gameresult == "1-0", result <- 1,
         ifelse(gameresult == "0-1", result <- 0,
                ifelse(gameresult == "1/2-1/2", result <- 0.5, result <- 3)))
  result
}

library(purrr)

#Next command doesn't work probably because finalres cannot operate with a vector
#games <- games %>% mutate(finalresult = finalres(Result))
games <- games %>% mutate(finalresult = as.numeric(map(Result,finalres)))




##############Calculates de most frequent ECO games for black, along with some statistics


#calculates Black games qty
BlackGamesQty <- games %>% filter(Black == user) %>% 
  summarise(n()) %>%
  as.numeric()

#calculates the minimum number of games per ECO to include the ECO in the analysis
ngamesblack <- floor(ngamesblackpercentage * BlackGamesQty)

#Calculates numer of registries with ECO>ngames
BlackECOQty <- games %>% filter(Black == user) %>% 
  group_by(ECO) %>%
  summarise(n()) %>%
  summarise(n()) %>%
  as.numeric()

#ECO Analyzed
BlackECOAnalized <- games %>% filter(Black == user) %>% 
  group_by(ECO) %>%
  mutate(qty = n()) %>%
  #remove ECO with just two games
  filter(qty > ngamesblack) %>%
  mutate(OpeningFrequency = qty/BlackGamesQty) %>%
  filter(OpeningFrequency > ECOFrequencyBlack) %>%
  summarise(n()) %>%
  summarise(n()) %>%
  as.numeric()

#Games Analized
BlackGamesAnalized <- games %>% filter(Black == user) %>% 
  group_by(ECO) %>%
  mutate(qty = n()) %>%
  #remove ECO with just two games
  filter(qty > ngamesblack) %>%
  mutate(OpeningFrequency = qty/BlackGamesQty) %>%
  filter(OpeningFrequency > ECOFrequencyBlack) %>%
  ungroup(ECO) %>%
  summarise(n()) %>%
  as.numeric()

cat("Game Ratio Black= ", BlackGamesAnalized, "/", BlackGamesQty, "=", BlackGamesAnalized/BlackGamesQty)
cat("ECO Ratio Black:", BlackECOAnalized, "/", BlackECOQty, "=", BlackECOAnalized/BlackECOQty)


#Perform full analysis on the Black ECO data base Filteres with ECO>ngames. The avg ELO difference is taken into accout 
PerformanceByECOBlack <- games %>% filter(Black == user) %>% 
  select(BlackElo, ECO, Result, WhiteElo, finalresult) %>%
  group_by(ECO) %>%
  mutate(qty = n()) %>%
  #remove ECO with just ngames games
  filter(qty > ngamesblack) %>%
  summarise(BlackEloAvg = mean(BlackElo), WhiteEloAvg = mean(WhiteElo), WhitePerf = mean(finalresult), qty = n()) %>%
  mutate(ElodiffAvgWhiteminusBlack = WhiteEloAvg - BlackEloAvg, BlackPerf = 1 - WhitePerf) %>%
  
  mutate(ExpectedScoreBlackbyELO = 1/(1+10^(ElodiffAvgWhiteminusBlack/400))) %>% #Source: https://www.reddit.com/r/chess/comments/2y6ezm/how_to_guide_converting_elo_differences_to/
  mutate(BlackOpeningBonus = BlackPerf - ExpectedScoreBlackbyELO) %>%
  #arrange(desc(BlackPerf))
  mutate(OpeningFrequency = qty/BlackGamesQty) %>%
  select(ECO, OpeningFrequency, ElodiffAvgWhiteminusBlack, BlackOpeningBonus) %>%
  filter(OpeningFrequency > ECOFrequencyBlack) %>%
  arrange(desc(BlackOpeningBonus))

##Conclusions for Black
# B21 ansd A04 have to be checked, since they have 41% and 35% performance (under the average)



####Analysis for white

##############Calculates de most frequent ECO games for White, along with some statistics


#calculates White games qty
WhiteGamesQty <- games %>% filter(White == user) %>% 
  summarise(n()) %>%
  as.numeric()

#calculates the minimum number of games per ECO to include the ECO in the analysis
ngameswhite <- floor(ngameswhitepercentage * WhiteGamesQty)

#Calculates numer of registries with ECO>ngames
WhiteECOQty <- games %>% filter(White == user) %>% 
  group_by(ECO) %>%
  summarise(n()) %>%
  summarise(n()) %>%
  as.numeric()

#ECO Analized
WhiteECOAnalized <- games %>% filter(White == user) %>% 
  group_by(ECO) %>%
  mutate(qty = n()) %>%
  #remove ECO with just two games
  filter(qty > ngameswhite) %>%
  mutate(OpeningFrequency = qty/WhiteGamesQty) %>%
  filter(OpeningFrequency > ECOFrequencyWhite) %>%
  summarise(n()) %>%
  summarise(n()) %>%
  as.numeric()

#Games Analized
WhiteGamesAnalized <- games %>% filter(White == user) %>% 
  group_by(ECO) %>%
  mutate(qty = n()) %>%
  #remove ECO with just two games
  filter(qty > ngameswhite) %>%
  mutate(OpeningFrequency = qty/WhiteGamesQty) %>%
  filter(OpeningFrequency > ECOFrequencyWhite) %>%
  ungroup(ECO) %>%
  summarise(n()) %>%
  as.numeric()

#Perform full analysis on the White ECO data base Filteres with ECO>ngames. The avg ELO difference is taken into accout 
PerformanceByECOWhite <- games %>% filter(White == user) %>% 
  select(BlackElo, ECO, Result, WhiteElo, finalresult) %>%
  group_by(ECO) %>%
  mutate(qty = n()) %>%
  #remove ECO with just ngames games
  filter(qty > ngameswhite) %>%
  summarise(BlackEloAvg = mean(BlackElo), WhiteEloAvg = mean(WhiteElo), WhitePerf = mean(finalresult), qty = n()) %>%
  mutate(ElodiffAvgBlackminusWhite = BlackEloAvg - WhiteEloAvg , BlackPerf = 1 - WhitePerf) %>%
  mutate(ExpectedScoreWhitebyELO = 1/(1+10^(ElodiffAvgBlackminusWhite/400))) %>%  #Source: https://www.reddit.com/r/chess/comments/2y6ezm/how_to_guide_converting_elo_differences_to/
  mutate(WhiteOpeningBonus = WhitePerf - ExpectedScoreWhitebyELO) %>%
  #arrange(desc(WhitePerf))
  mutate(OpeningFrequency = qty/WhiteGamesQty) %>%
  select(ECO, OpeningFrequency, ElodiffAvgBlackminusWhite, WhiteOpeningBonus) %>%
  filter(OpeningFrequency > ECOFrequencyWhite) %>%
  arrange(desc(WhiteOpeningBonus))


##Conclusions for Black and White

library(scales)

#BLACK


#WHITE
# The top 8 openings have a ratio>50%. Not interesting to work on them. So, the analysis is widened to 17.
# In top17 there are three openings under 50%: B71, B76 and C41.
cat("Number of games analyzed with White:", WhiteGamesQty, "\n")
cat("ECO Frequency White analyzed: >", percent(ECOFrequencyWhite), "\n")
cat("Game Ratio White= ", WhiteGamesAnalized, "/", WhiteGamesQty, "=", percent(WhiteGamesAnalized/WhiteGamesQty), "\n")
cat("ECO Ratio White:", WhiteECOAnalized, "/", WhiteECOQty, "=", percent(WhiteECOAnalized/WhiteECOQty), "\n")

cat("Number of games analyzed with Black:", BlackGamesQty, "\n")
cat("ECO Frequency Black analyzed: >", percent(ECOFrequencyBlack), "\n")
cat("Game Ratio Black= ", BlackGamesAnalized, "/", BlackGamesQty, "=", percent(BlackGamesAnalized/BlackGamesQty), "\n")
cat("ECO Ratio Black:", BlackECOAnalized, "/", BlackECOQty, "=", percent(BlackECOAnalized/BlackECOQty), "\n")



#Add adjustments due to ELO difference in ECOs.
#Source: https://www.reddit.com/r/chess/comments/2y6ezm/how_to_guide_converting_elo_differences_to/


#Add Opening Description to the Report

#Load Eco Codes
source("./src/LoadEcoCodesBasic.r")

PerformanceByECOWhiteOpening <- merge(PerformanceByECOWhite, ECO, by = "ECO") %>%
  mutate(OpeningFreq = OpeningFrequency, EloDifBW = ElodiffAvgBlackminusWhite, OpeningBonus = WhiteOpeningBonus) %>%
  #merge test
  #  merge(PerformanceByECOWhiteOpening,ECO, by = "Opening") %>%
  select(ECO, Opening, OpeningFreq, EloDifBW, OpeningBonus) %>%
  arrange(desc(OpeningFreq))

PerformanceByECOBlackOpening <- merge(PerformanceByECOBlack, ECO, by = "ECO") %>%
  mutate(OpeningFreq = OpeningFrequency, EloDifWB = ElodiffAvgWhiteminusBlack, OpeningBonus = BlackOpeningBonus) %>%
  select(ECO, Opening, OpeningFreq, EloDifWB, OpeningBonus) %>%
  arrange(desc(OpeningFreq))


#Add lichess link and create html report
library("googleVis")
library("R2HTML")


PerformanceByECOWhiteOpening <- merge(PerformanceByECOWhite, ECO, by = "ECO") %>%
  mutate(OpeningFreq = OpeningFrequency, EloDifBW = ElodiffAvgBlackminusWhite, OpeningBonus = WhiteOpeningBonus) %>%
  #merge test
  #  merge(PerformanceByECOWhiteOpening,ECO, by = "Opening") %>%
  select(ECO, Opening, OpeningFreq, EloDifBW, OpeningBonus, lichess) %>%
  arrange(desc(OpeningFreq))

PerformanceByECOBlackOpening <- merge(PerformanceByECOBlack, ECO, by = "ECO") %>%
  mutate(OpeningFreq = OpeningFrequency, EloDifWB = ElodiffAvgWhiteminusBlack, OpeningBonus = BlackOpeningBonus) %>%
  select(ECO, Opening, OpeningFreq, EloDifWB, OpeningBonus, lichess) %>%
  arrange(desc(OpeningFreq))
