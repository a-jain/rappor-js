import csv
import sys
import requests
import json

# params = {
# 	'k' : 16,
# 	'h' : 2,
# 	'm' : 64,
# 	'p' : 0.5,
# 	'q' : 0.75,
# 	'f' : 0.5
# }

serverUrl = "http://localhost:8080/api/v1/records";

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
	for i in range(0, params['m']):
		print '{}, {}'.format(totalCounts[i], ', '.join(map(str, bitCounts[i])))


def getTrueCounts(params, jsonResponse):
	trueCounts  = [0] * params['m']

	for record in jsonResponse:
		# now calculate trueCounts
		if record['bool']:
			trueCounts[record['cohort']] += 1

	# need some way of printing out originals
	# print in format of:
	# m   numTrue
	# -----------
	# 0   5
	# 1   7
	# 2   4
	# etc
	for i in range(0, params['m']):
		print '{}, {}'.format(i, trueCounts[i])


# finally, handle creation of params.csv file
# check - this is not correct python rn
# also check if this comes in alphabetical order or what
def getParams(params):
	print join(params.keys())
	print join(map(str, params.vals()))


# change from printing to std out to printing to a given filename
# sumBits.csv for first one, trueBits.csv for second one, params.csv for third one
def main():
	r = requests.get(serverUrl)

	# cache JSON response
	jsonResponse = r.json()

	# get parameter info from first response
	# NB: assuming all params are the same, checking would be trivial
	#     but unclear how to handle cases where they differ
	params = jsonResponse[0]["params"]

	getSumBits(params, jsonResponse)
	getTrueCounts(params, jsonResponse)
	getParams(params)


if __name__ == '__main__':
  try:
    main()
  except RuntimeError, e:
    print >>sys.stderr, e.args[0]
    sys.exit(1)