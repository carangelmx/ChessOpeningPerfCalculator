#Source: https://cdn.rawgit.com/chris-w-r/lichess-database-exploration/80b97acfcf566b582157f7aa847f3d6369ba350c/Project%20and%20Data%20Setup.nb.html



#set the batch size (adjust as necessary)
lines_to_read <- 10000000

#set required variables
month <- "october"
month_piece <- 1
lines_to_skip <- 0
lines_read <- lines_to_read

#once less than the set number of lines to read is returned, we know that we're at the end of the file
while (lines_read == lines_to_read)
{
  #fread is fast read from data.table
  #
  #fread assumes that it is reading a csv, but the lichess file is 1 column of text, so, the separation character is set to something we don't expect to see in the file (the backtick)
  batch_read <- fread(
    paste0(
      lichess_db_standard_rated_filepath,
      lichess_db_standard_rated_filename
    ),
    sep = "`",
    nrows = lines_to_read,
    header = FALSE,
    skip = lines_to_skip,
    quote = "",
    blank.lines.skip = TRUE
  )
  
  #capture how many rows were returned
  lines_read <- nrow(batch_read)
  
  #each game is an unknown number of lines of text (usually between 16 and 18), therefore we need a way of grouping lines together to identify a single game.  as each game starts with the Event tag, grepl looks for this tag and sets this row to TRUE which R interprets as 1; all other rows are set to FALSE or 0.  cumsum performs a cumulative sum down these identifiers which sets each row for a single game to the same number and increments the number for each game (e.g. n + 0 = n for each non-Event row; n + 1 = (n + 1) for each Event row)
  batch_read[, game_id := cumsum(grepl("^\\[Event", V1))]
  
  #if the last row read starts with a bracket, it's not movetext and therefore we know that we do not have all of the lines of the last game read.  we want to remove this partial game from this batch read so that when we cast the data into a table with multiple columns we don't have partially filled rows.  this also ensures that each batch starts at the beginning of a game's sequence of rows
  if (grepl("^\\[", batch_read[.N, 1]))
  {
    batch_read <- batch_read[game_id < max(game_id)]
  }
  
  #capture how many lines from this batch were used
  lines_to_skip <- lines_to_skip + nrow(batch_read)
  
  #computerevaluation is set to FALSE, because it is not rtequired in this algorithm (until now)
  if (computerevaluation){
    #only keep games whose movetext includes the computer evaluations
    batch_read <-
      batch_read[game_id %in% batch_read[!grepl("^\\[", V1) &
                                           grepl("eval", V1), game_id]]
  } 
  
  #split the single column into columns with the tag name and tag value then drop the original single column
  batch_read[, tag := ifelse(grepl("^\\[", V1), sub("\\[(\\w+).+", "\\1", V1), "Movetext")][, value := ifelse(grepl("^\\[", V1),
                                                                                                              sub("\\[\\w+ \\\"(.+)\\\"\\]", "\\1", V1),
                                                                                                              V1)][, V1 := NULL]
  
  #cast the data into an 18 column table containing a column for each tag with each row being a single game
  batch_read <-
    dcast(batch_read, game_id ~ tag, value.var = "value")
  
  #drop the game_id created earlier as the site URL already contains a unique id for each game
  batch_read[, game_id := NULL]
  
  
  
  
  ####### THere is a problem with opening. Its not cast 
  
  ####### reorder is removed while the solution is found
  
  if(FALSE){  
    #reorder the columns to match the original PGN order
    setcolorder(
      batch_read,
      c(
        "Event",
        "Site",
        "White",
        "Black",
        "Result",
        "UTCDate",
        "UTCTime",
        "WhiteElo",
        "BlackElo",
        "WhiteRatingDiff",
        "BlackRatingDiff",
        "WhiteTitle",
        "BlackTitle",
        "ECO",
        #    "Opening",                              <- Not working
        "TimeControl",
        "Termination",
        "Movetext"
      )
    )
  }
  
  #rename this batch with a unique name and save it
  month_piece_filename <- paste0(month, "_", month_piece)
  assign(month_piece_filename, batch_read)
  save(
    list = month_piece_filename,
    file = paste0(
      lichess_db_standard_rated_eval_stage_filepath,
      month_piece_filename,
      ".rda"
    )
  )
  
  #remove this batch from the environment to manage memory
  rm(list = month_piece_filename)
  
  #update for the next batch
  month_piece <- month_piece + 1
}
