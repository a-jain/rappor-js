import hashlib
import csv
import sys
import os

subDir      = os.path.join(os.getcwd(), "server/outputs")
paramsFile  = os.path.join(subDir, sys.argv[1])
mapFile     = os.path.join(subDir, sys.argv[2])

def getParams():
	params = {}

	f = open(paramsFile, "r")
	reader = csv.reader(f)

	rownum = 0
	for row in reader:
		if rownum == 0:
			header = row
		else:
			colnum = 0
			for col in row:
				params[header[colnum]] = col
				colnum += 1

		rownum += 1

	return params

# generate test strings
def generateCandidates(n):
	candidates = ["true", "false"]

	for i in range(0, n):
		candidates.append("fake" + str(i))

	return candidates


# format is:
# "true",  [1..k], [1..k], ..., [1..k] {m times} and must start with a 1!
# "false", [1..k], [1..k], ..., [1..k] {m times}
# ...
# "test3", [1..k], [1..k], ..., [1..k] {m times}
def constructMap(candidates, m, h, k):
	X = {}
	for c in candidates:
		candidateOnes = []
		for i in range(m):
			x = hashlib.md5("" + c + str(i)).hexdigest()

			# double check if the + 1 is necessary
			ones = []
			for j in range(h):
				ones.append(i * k + int(x[4*j : 4*j+4], 16) % k + 1)

			# bloom = [0] * int(params["k"])
			# for i in range(int(params["k"])):
			# 	if i in ones:
			# 		bloom[i] = 1

			# make absolute value??


			candidateOnes.extend(sorted(ones))

		X[c] = candidateOnes

	return X


# print X into appropriate design matrix format
def writeToFile(X):
	fo = open(mapFile, "w")

	for key, val in X.iteritems():
		fo.write("\"{}\"".format(key))

		for v in val:
			fo.write(",{}".format(v))

		fo.write("\n")

	fo.close()


def unitTest():
	X = ["true"]


def main():

	params = getParams()
	candidates = generateCandidates(8)

	X = constructMap(candidates, int(params["m"]), int(params["h"]), int(params["k"]))
	
	writeToFile(X)

main()
