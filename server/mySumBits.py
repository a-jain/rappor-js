import csv
import sys
import requests
import json
import os

subDir      = os.path.join(os.getcwd(), "outputs/" + sys.argv[1])

if not os.path.exists(subDir):
	os.makedirs(subDir)

countsFile  = os.path.join(subDir, "counts.csv")
paramsFile  = os.path.join(subDir, "params.csv")

def getSumBits(params, jsonResponse):
	# create frequency table of different bitStrings
	totalCounts = [0] * params['m']
	
	# key is cohort number, values are # of times a 1 is in bitString
	bitCounts = {}
	for i in range(0, params['m']):
		bitCounts[i] = [0] * params['k']

	# populate bitCounts, trueCounts
	for record in jsonResponse:
		for i in range(0, params['k']):
			bitCounts[record['cohort']][i] += ord(record['irr'][i]) - 48

		totalCounts[record['cohort']] += 1

	# prints out counts
	fo = open(countsFile, "w")
	
	for i in range(0, params['m']):
		fo.write( '{},{}\n'.format(totalCounts[i], ','.join(map(str, bitCounts[i]))) )
	
	fo.close()

def getTrueCounts(params, jsonResponse):
	trueCounts  = [0] * params['m']

	for record in jsonResponse:
		# now calculate trueCounts
		if record['truth'] or str(record['truth']).lower() == "true":
			trueCounts[record['cohort']] += 1

	# need some way of printing out originals
	# print in format of:
	# m   numTrue
	# -----------
	# 0   5
	# 1   7
	# 2   4
	# etc

	fo = open(cohortsFile, "w")

	for i in range(0, params['m']):
		fo.write( '{}, {}\n'.format(i, trueCounts[i]) )

	fo.write( '\nTotal, {}'.format(sum(trueCounts)))

	fo.close()


# finally, handle creation of params.csv file
# check - this is not correct python rn
# also check if this comes in alphabetical order or what
def getParams(params):

	fo = open(paramsFile, "w")

	fo.write( "\"k\",\"h\",\"m\",\"p\",\"q\",\"f\"\n" )
	fo.write( "{},{},{},{},{},{}\n".format(params['k'], params['h'], params['m'], params['p'], params['q'], params['f']))

	fo.close()


# change from printing to std out to printing to a given filename
# sumBits.csv for first one, trueBits.csv for second one, params.csv for third one
def main():
	serverUrl = "http://localhost:8080/api/v1/records";
	privateKey  = sys.argv[1]

	if privateKey is not "":
		serverUrl += ("/credentials/" + privateKey)

	r = requests.get(serverUrl, timeout=120)

	# cache JSON response
	try:
		jsonResponse = r.json()
	except:
		print "The private key wasn't found"

	# get parameter info from first response
	# NB: assuming all params are the same, checking would be trivial
	#     but unclear how to handle cases where they differ
	params = jsonResponse[0]["params"]

	getSumBits(params, jsonResponse)
	# getTrueCounts(params, jsonResponse)
	getParams(params)


if __name__ == '__main__':
	try:
		main()
	except RuntimeError, e:
		print >>sys.stderr, e.args[0]
		sys.exit(1)
