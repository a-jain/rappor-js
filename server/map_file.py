import hashlib
import csv
import sys
import os
import struct

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

def to_big_endian(i):
	"""Convert an integer to a 4 byte big endian string.  Used for hashing."""
	# https://docs.python.org/2/library/struct.html
	# - Big Endian (>) for consistent network byte order.
	# - L means 4 bytes when using >
	return struct.pack('>L', i)

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
			val = to_big_endian(i) + c
			md5 = hashlib.md5(val)

			digest = md5.digest()
			print digest

			# double check if the + 1 is necessary
			# ones = []
			# for j in range(h):
			# 	ones.append(i * k + int(digest[4*j : 4*j+4], 16) % k + 1)

			ones = [ord(digest[i]) % k for i in xrange(h)]
			print ones

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
	candidates = ["true"]
	m = 1
	h = 2
	k = 32

	print constructMap(candidates, m, h, k)

def main():
	testing = True
	params = getParams()

	if testing:
		unitTest()
	else:
		candidates = generateCandidates(5)

		X = constructMap(candidates, int(params["m"]), int(params["h"]), int(params["k"]))
		
		writeToFile(X)

main()
