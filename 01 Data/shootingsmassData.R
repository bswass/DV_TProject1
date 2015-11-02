require(tidyr)
require(dplyr)
require(ggplot2)

setwd("C:/Users/Chris/Desktop/DataVisualization/DV_TProject1/01 Data")

file_path <- "shootingsmass.reformatted.csv"

df <- read.csv(file_path, stringsAsFactors = FALSE)
summary(df)
head(df)