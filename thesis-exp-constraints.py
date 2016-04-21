import math
import requests

def test():

	url = "http://localhost:8080/api/v1/records/credentials/ba62807905c7"
	json = requests.get(url).json()

	# maps = {'false': [13, 30], 'true': [4, 11]}

	trueMap = [0] * 32
	trueMap[4] = 1
	trueMap[11] = 1
	trueMap = "".join(str(x) for x in trueMap)

	falseMap = [0] * 32
	falseMap[13] = 1
	falseMap[30] = 1
	falseMap = "".join(str(x) for x in falseMap)

	print trueMap
	print falseMap

	# print maps
	irrs = []

	for js in json:
		irrs.append(js["irr"])

	results = []
	for i in range(len(irrs)):
		# print irrs[i]
		if mse(trueMap, irrs[i]) > mse(falseMap, irrs[i]):
			results.append("true")
		elif mse(trueMap, irrs[i]) < mse(falseMap, irrs[i]):
			results.append("false")
		else:
			results.append("idk")

	print results
	cumT = cum(results, "true")
	cumF = cum(results, "false")

	getMaxIndex(cumT, cumF)



def mse(l1, l2):
	sum = 0
	for i in range(0, len(l1)):
		if l1[i] != l2[i]:
			sum += 1

	return sum

def cum(arr, s):
	ret = []
	cnt = 0
	for i in arr:
		if i == s:
			cnt += 1
			ret.append(cnt)
		else:
			ret.append(cnt)

	return ret

def getMaxIndex(a1, a2):
	maxA1 = a1[len(a1) - 1]
	maxA2 = a2[len(a2) - 1]
	x = [float(val) / maxA1 for val in a1]
	y = [float(val) / maxA2 for val in a2]

	maxDiff = 0
	indDiff = -1
	c = 0
	for i, j in zip(x, y):
		if (i-j)*(i-j) > maxDiff:
			maxDiff = (i-j)*(i-j)
			indDiff = c
		c += 1

	pr(x, y)
	print indDiff
	print math.sqrt(maxDiff)

def pr(a1, a2):
	c = 0
	for i, j in zip(a1, a2):
		print str(c) + ": " + str(i) + " " + str(j)
		c += 1

def main():
	test()

main()