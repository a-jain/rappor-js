# Copyright 2014 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

library(limSolve)
library(Matrix)

# The next two functions create a matrix (G) and a vector (H) encoding
# linear inequality constraints that a solution vector (x) must satisfy:
#                       G * x >= H

# Currently represent three sets of constraints on the solution vector:
#  - all solution coefficients are nonnegative
#  - the sum total of all solution coefficients is no more than 1
MakeG <- function(n, X) {
  d <- Diagonal(n)
  last <- rep(-1, n)
  last2 <- rep(1, n)

  XX = rbind2(d, last)
  
  # this condition ensures we map *all* of samples
  # XX = rbind2(XX, last2)
  # XX = rbind2(rbind2(d, last), -X)

}

MakeH <- function(n, Y, stds) {
  # set the floor at 0.01 to avoid degenerate cases
  YY <- apply(Y + 3 * stds,  # in each bin don't overshoot by more than 3 stds
              1:2,
              function(x) min(1, max(0.000001, x)))  # clamp the bound to [0.01,1]

#  YY <- c(rep(0, n),  # non-negativity condition
#    -1,         # coefficients sum up to no more than 1
#    -as.vector(t(YY))   # t is important!
#    )

  YY <- c(rep(0, n), -1)  # non-negativity condition
  
  # this condition ensures we map *all* of samples
  # YY <- c(YY, 1)
}

MakeLseiModel <- function(X, Y, stds) {
  m <- dim(X)[1]
  n <- dim(X)[2]

  w <- as.vector(t(1 / stds))
  w_median <- median(w[!is.infinite(w)])
  if(is.na(w_median))  # all w are infinite
    w_median <- 1
  w[w > w_median * 2] <- w_median * 2
  w <- w / mean(w)

  a = Diagonal(x = w) %*% (X + 0)
  b = as.vector(t(Y)) * w
  g = MakeG(n, X)
  h = MakeH(n, Y, stds)

  # cat(stderr(), "\nEntered the MakeLseiModel function. w is:\n")
  # print(w)

  # cat(stderr(), "\nA, B are:\n")
  # print(cbind2(a, b))

  cat(stderr(), "\nG, H are:\n")
  print(cbind2(g, h))

  list(# coerce sparse Boolean matrix X to sparse numeric matrix
       A = a,
       B = b,  # transform to vector in the row-first order
       G = g,
       H = h,
       type = 2,
       verbose = TRUE)  # Since there are no equality constraints, lsei defaults to
                  # solve.QP anyway, but outputs a warning unless type == 2.
}

# CustomLM(X, Y)
ConstrainedLinModel <- function(X,Y) {

  # cat(stderr(), "\nEntered the ConstrainedLinModel function\n")
  # cat(stderr(), "New X is:\n")
  # print(X)
  # cat(stderr(), "New Y is:\n")
  # print((Y))

  model <- MakeLseiModel(X, Y$estimates, Y$stds)
  coefsFull <- do.call(lsei, model)

  # cat(stderr(), "\nHere is some more info about the return of the lsei model:\n")
  # print(coefsFull$residualNorm)
  # print(coefsFull$solutionNorm)
  # print(coefsFull$type)
  # print(coefsFull$rankApp)
  # print(coefsFull$X)

  coefs <- coefsFull$X
  names(coefs) <- colnames(X)

  coefs
}