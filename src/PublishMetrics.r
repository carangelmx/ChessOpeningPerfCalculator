#Plot table in HTML and PDF
WhiteReport <- transform(PerformanceByECOWhiteOpening,
                         lichess = paste('<a href = ',
                                         shQuote(lichess), '>', "link white", '</a>')) 
x = gvisTable(WhiteReport, options = list(allowHTML = TRUE))
x$html$header <- paste("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"\n  \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\ ......", "<h2>PerformanceByECOWhiteOpening</h2>", "</head>\n<body>\n")
plot(x)

source("./src/EraseFile.r")
EraseFile('./output/whitereport.html')
HTML(WhiteReport, file='./output/whitereport.html')

BlackReport <- transform(PerformanceByECOBlackOpening,
                         lichess = paste('<a href = ',
                                         shQuote(lichess), '>', "link black", '</a>')) 
x = gvisTable(BlackReport, options = list(allowHTML = TRUE))
x$html$header <- paste("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"\n  \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\ ......", "<h2>PerformanceByECOBlackOpening</h2>", "</head>\n<body>\n")
plot(x)

EraseFile('./output/blackreport.html')
HTML(BlackReport, file='./output/blackreport.html')

#export to pdf
source("./src/html2pdf.R")
EraseFile('./output/whitereport.pdf')
html2pdf("./output/whitereport.html","./output/whitereport.pdf")

EraseFile('./output/blackreport.pdf')
html2pdf("./output/blackreport.html","./output/blackreport.pdf")
