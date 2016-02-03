# first step is to read in params
params = as.data.frame(read.from.csv())

# second step is to reconstruct normalized vector from sumBits csv file
sumBits = read.from.csv()

## slice total counts from individual position counts
totalCounts = sumBits[0:1]
bitCounts   = sumBits[1:]

## get random numerator and denominator coefficients
numeratorCoeff   = (params[p] + 0.5*params[f]*params[q] - 0.5*params[f]*params[p])
denominatorCoeff = (1-params[f])*(1-params[q])

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