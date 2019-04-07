#EraseFile

#Source: https://stackoverflow.com/questions/14219887/how-to-delete-a-file-with-r


EraseFile <- function(FilePath){
  #Define the file name that will be deleted
  #fn <- "foo.txt"
  fn <- FilePath
  #Check its existence
  if (file.exists(fn)) 
    #Delete file if it exist
    file.remove(fn)
}