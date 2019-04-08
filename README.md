# ChessOpeningPerfCalculator
Calculate metrics about chess opening performance for an user based in a PGN file.\
How is my performance in openings? This program will answer this question!

## SUMMARY

Get a file with PGNs (input) and calculate metrics about opening performance with white and black for the selected user (output). The analysis is carried out on the most frequent ECO codes used by the user.

## PREREQUISITES:
- R and Rstudio
- wkhtmltopdf.exe (this program should be downloaded in the local computer; the path to yopur local .exe file has to be updated in the file "html2pdf.r"). This program is optional. If it is not installed, the pdf report won't be created.

## TO REPLICATE/ RUN THE ANALYSIS:
- Go to https://github.com/carangelmx/ChessOpeningPerfCalculator
- Click in "Clone or download"; Download zip; Extract in the local computer.
- Go to the folder "ChessOpeningPerfCalculator-master" and open "ChessOpeningPerfCalculator.Rproj" with Rstudio.
- Run ChessOpeningPerfCalculator.R
- The code should run smoothly. After that, the report should be published in the web browser and in the "output" folder.

## PROGRAM FLOW
- Set Filepath - Set the name of the user we want to analyze. Set the pgn file name where the games of the user are.
- Set Parameters - Set the minimum frequency of a processed ECO code. ECO codes less frequently used in the database won't be analyzed. For example, ECOFrequencyWhite of 0.025 means a 2.5% limit for the ECO codes of the user playing with White pieces.
- Read PGN - Reads the pgn
- Calculate Metrics - Calculate the metrics
- Publish Metrics - Export the results to html and pdf.

## ALGORITHM
- Calculate the winning probability for the user in a specific ECO code, by means of the average ELO difference between the players (e.g. **ExpectedScoreWhitebyELO = 1/(1+10^(ElodiffAvgBlackminusWhite/400))**).
- Calculate the actual user performance in the ECO code, using the game results and the elo difference between the players (e.g. **WhitePerf = mean(finalresult)**).
- Calculate The relative performance in the ECO code as the difference (**WhiteOpeningBonus = WhitePerf - ExpectedScoreWhitebyELO)**
See implementation in CalculateMetrics.R
  
## RESULTS 
![alt text](https://github.com/carangelmx/ChessOpeningPerfCalculator/blob/master/img/ReportWhite.PNG)
***Figure 1. Report white***

![alt text](https://github.com/carangelmx/ChessOpeningPerfCalculator/blob/master/img/ReportBlack.PNG)
***Figure 2. Report white***

**Results explained**
  The output files are two: One for white and other for black.\
  - ECO: ECO code
  - Opening: Opening Name
  - OpeningFreq: Opening Frequency (decimal)
  - EloDifWB: ELO difference white user - black user
  - OpeningBonus: Additional probability to win in a specific ELO code for the user (decimal, above the expected statistical performance)
  - lichess: Link to the ECO code setup in lichess.org
 
**An example**
  - carangelmx with black has an OpeningBonus of 4.8% (0.048) in the B70 - Sicilian Dragon Variation. 
  - 4.3% (0.043 - OpeningFreq) of those games (with black) are B70 - Sicilian Dragon Variation.
  - The average Elo Difference in B70 is -32 ELO points. So, he plays against a bit weaker opponents in this variation.
  - carangelmx should improve his B01 Scandinavian playing with white, used in 5% of the games. His performance is -3.3%!
