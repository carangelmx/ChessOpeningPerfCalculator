library(bigchess)
  
Sys.time()
#f <- system.file(".","data", "raw", lichess_db_standard_rated_filename, package = "bigchess")
f <- paste("./data/raw/",lichess_db_standard_rated_filename,sep = "")
con <- file(f,encoding = "latin1")
df <- read.pgn(con,quiet = TRUE,ignore.other.games = TRUE,extract.moves = 0, stat.moves = FALSE, add.tags = c("WhiteElo", "BlackElo", "ECO"))
Sys.time()

#source: http://www.sthda.com/english/wiki/saving-data-into-r-data-format-rds-and-rdata  
filepath <- paste("./data/processed/",user,".rda",sep = "")
saveRDS(df, file = filepath)

#from file ExtractGamesfromPGN.r
filepath <- paste("./data/processed/",user,".rda",sep = "")
batch_read <- readRDS(filepath)