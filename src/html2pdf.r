#html2pdf

#source: D:\13.CRT_Soft\wkhtmltopdf\bin\wkhtmltopdf.exe
#source: https://stackoverflow.com/questions/51325357/cmd-from-r-with-wkhtmltopdf

html2pdf <- function(URL,save_as){
  #  URL="https://finance.yahoo.com/"
  wkhtmltopdf_exe=file.path("c:","CR","13.CRT_Soft", "wkhtmltopdf", "bin","wkhtmltopdf.exe")
  #  save_as="D:/13.CRT_Soft/r/data/myhtml.pdf"
  x=paste0(wkhtmltopdf_exe," ",URL," ",'\"',save_as,'\"')
  system(x)
}

#example:
#source("html2pdf.r")
#html2pdf("https://finance.yahoo.com/","D:/13.CRT_Soft/r/data/myhtml.pdf")