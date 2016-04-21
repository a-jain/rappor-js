import hashlib
import csv
import sys
import os
import struct
import json

testing = False

if not testing:
	subDir      = os.path.join(os.getcwd(), "outputs/" + sys.argv[1])
	paramsFile  = subDir + "/params.csv"
	mapFile     = subDir + "/map.csv"

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
		candidates.append("zzfake" + str(i))

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
			
			ones = [k-((ord(digest[j]) % k))+i*k for j in xrange(h)]
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
	candidates = ["true", "false"]
	m = 1
	h = 2
	k = 32
	# p = 0.1
	# q = 0.8
	# f = 0.81

	print constructMap(candidates, m, h, k)

def main():
	if testing:
		unitTest()
	else:
		params = getParams()
		# candidates = generateCandidates(6)

		candidates = json.loads(sys.argv[2])["strs"]
		# print candidates

		X = constructMap(candidates, int(params["m"]), int(params["h"]), int(params["k"]))
		
		writeToFile(X)

main()
