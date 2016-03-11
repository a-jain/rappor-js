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

def main():

	params = getParams()
	candidates = ["true", "false"]

	for i in range(0, 8):
		candidates.append("fake" + str(i))

	# now must assembly map file
	# format is:
	# "true",  [1..k], [1..k], ..., [1..k] {m times} and must start with a 1!
	# "false", [1..k], [1..k], ..., [1..k] {m times}
	# ...
	# "test3", [1..k], [1..k], ..., [1..k] {m times}
	
	X = {}
	for c in candidates:
		candidateOnes = []
		for i in range(int(params["m"])):
			x = hashlib.md5("" + c + str(i)).hexdigest()

			# double check if the + 1 is necessary
			ones = []
			for j in range(int(params["h"])):
				ones.append(i * int(params["k"]) + int(x[4*j : 4*j+4], 16) % int(params["k"]) + 1)

			# bloom = [0] * int(params["k"])
			# for i in range(int(params["k"])):
			# 	if i in ones:
			# 		bloom[i] = 1

			# make absolute value??


			candidateOnes.extend(sorted(ones))

		X[c] = candidateOnes
	
	# print X into appropriate design matrix format
	fo = open(mapFile, "w")

	for key, val in X.iteritems():
		fo.write("\"{}\"".format(key))

		for v in val:
			fo.write(",{}".format(v))

		fo.write("\n")

	fo.close()

main()
