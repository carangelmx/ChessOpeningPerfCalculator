#Updated on: Jan 13, 2019
#Updated by: rangelc
#Checked on: April 6, 2019


#SUMMARY
#Get a file with PGNs (input) and calculate metrics about opening performance 
#with white and black for the selected user (output).
#The analysis is carried out under a number of ECO codes per color. 
#The number of ECO codes analyzed is determined as
#% of ECO games for color > ngamesCOLORpercentage

#Instructions: 
#1 Set Filepath
#2 Set Parameters (user, black and white threshold (e.g. ngamesblackpercentage) )
#3 Read PGN
#4 Calculate Metrics
#5 Publish Metrics

#check installed packages: 
library(data.table)
library(tidyverse)
library(dplyr)

#set user and PGN file path for analysis"
source("./src/SetUserFilepath.r")

#Set parameters
source("./src/SetParameters.r")

#Read the PGN
source("./src/ReadPGN.r")

#Calculates the opening metrics for the selected user.
source("./src/CalculateMetrics.r")

#Publish the opening metrics for the selected user.
source("./src/PublishMetrics.r")