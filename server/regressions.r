#!/usr/bin/env Rscript 
# args passed in are countFile, truthFile, paramFile
# args = commandArgs(TRUE)
args = c("outputs/cohorts.csv", "outputs/counts.csv", "outputs/params.csv")

# first step is to read in params
params = as.data.frame(read.csv(args[3]))

# second step is to reconstruct normalized vector from counts csv file
counts = as.matrix(read.csv(args[2], header=FALSE))

## slice total counts from individual position counts
totalCounts = counts[,1]
bitCounts   = counts[,-1]

## get random numerator and denominator coefficients
numeratorCoeff   = as.matrix((params["p"] + 0.5*params["f"]*params["q"] - 0.5*params["f"]*params["p"]))[1]
denominatorCoeff = as.matrix((1-params["f"])*(params["q"]-params["p"]))[1]

for (i in 1:as.integer(params["m"])) {
  for (j in 1:as.integer(params["k"])) {
    bitCounts[i, j] = (bitCounts[i, j] - numeratorCoeff*totalCounts[i]) / denominatorCoeff
  }
}

## then update bitCounts:
## bitCounts[i, j] = (bitCounts[i, j] - numeratorCoeff*totalCounts[i]) / denominatorCoeff

# third step is to generate the candidates
## we should have one, zero, other(?)
## investigate if we need to add jitter

## concatenate candidates into design matrix

# fourth step is to perform regression and get coefficients

# fifth step is to compare these inferred values with true values
trueVals = read.from.csv()
trueVals = trueVals/totalCounts

## plot, for each cohort, trueVals and inferred coefficients

# 6th step is to quantify difference
## get average MSE of coeffs and trueVals, averaged over each cohort