library(httr)
library(readr)

source("R/read_input.R")

pK = "b39c20be623d"

url_csvs = paste("http://rappor-js.herokuapp.com/api/v1/getCSV/", pK, "/map", sep="")

x = GET(url_csvs)
counts = content(x, col_names=FALSE, as.is = TRUE)
counts2 = ReadMapFile(counts, listx, readCSV=FALSE)

# devtools::install_github("hadley/httr") is needed