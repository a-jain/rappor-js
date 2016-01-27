import csv
import sys
import requests
import json

params = {
	'k' : 16,
	'h' : 2,
	'm' : 64,
	'p' : 0.5,
	'q' : 0.75,
	'f' : 0.5
}

serverUrl = "http://localhost:8080/api/v1/records";

def main():
	r = requests.get(serverUrl)

	# create frequency table of different bitStrings
	totalCounts = [0] * params['m']

	# key is cohort number, values are # of times a 1 is in bitString
	bitCounts = {}
	for i in range(0, params['m']):
		bitCounts[i] = [0] * params['k']

	# populate bitCounts
	for record in r.json():
		for i in range(0, params['k']):
			bitCounts[record['cohort']][i] += ord(record['bitString'][i]) - 48

		totalCounts[record['cohort']] += 1

	for i in range(0, params['m']):
		print '{}, {}'.format(totalCounts[i], ', '.join(map(str, bitCounts[i])))


if __name__ == '__main__':
  try:
    main()
  except RuntimeError, e:
    print >>sys.stderr, e.args[0]
    sys.exit(1)