import math
import requests
import numpy as np
from scipy.stats import binom

def test():

	url = "http://localhost:8080/api/v1/records/credentials/ba62807905c7"
	json = requests.get(url).json()

	# print maps
	irrs = []

	for js in json:
		irrs.append(js["irr"])

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

	results = []
	for i in range(len(irrs)):
		# print irrs[i]
		if mse(trueMap, irrs[i]) > mse(falseMap, irrs[i]):
			results.append("true")
		elif mse(trueMap, irrs[i]) < mse(falseMap, irrs[i]):
			results.append("false")
		else:
			results.append("idk")

	pr(irrs, results)
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
	if maxA1 > 0: x = [float(val) / maxA1 for val in a1]
	else: x = a1
	if maxA2 > 0: y = [float(val) / maxA2 for val in a2]
	else: y = a2

	maxDiff = 0
	indDiff = -1
	c = 0
	for i, j in zip(x, y):
		if (i-j)*(i-j) >= maxDiff:
			maxDiff = (i-j)*(i-j)
			indDiff = c
		c += 1

	# pr(x, y)
	# print indDiff
	return (indDiff, math.sqrt(maxDiff))

def pr(a1, a2):
	c = 0
	for i, j in zip(a1, a2):
		print str(c) + ": " + str(i) + " " + str(j)
		c += 1

# case where we have two true strings, want to find max range that our algo will return
def getBoundSameString(T=1000):
	# true -> true  w prob 0.46
	# true -> pass  w prob 0.36
	# true -> false w prob 0.18

	listTrue  = [0.0] * T
	listFalse = [0.0] * T

	for i in range(0, T):
		rnd = np.random.uniform()
		if rnd < 0.4173:
			listTrue[i] = 1.0
		elif rnd < 0.4173+0.2184:
			listFalse[i] = 1.0

	# print listFalse

	cumTrue  = np.cumsum(listTrue) 
	cumFalse = np.cumsum(listFalse)

	# print cumFalse

	if cumTrue[-1] > 0: cumTrue  /= cumTrue[-1]
	if cumFalse[-1] > 0: cumFalse /= cumFalse[-1]

	stacked = np.column_stack((cumTrue, cumFalse))
	diffs   = np.apply_along_axis(myF, 1, stacked)
	# print diffs
	return math.sqrt(np.amax(diffs))

def myF(a):
	return (a[1]-a[0])*(a[1]-a[0])

# case where we have false -> true, want to find estimates of mean and variance of estimate of k
def getBoundDiffString(T=1000):

	k=T/2

	# generate IRRs
	results = [""] * T
	for i in range(0, T):
		rnd = np.random.uniform()
		if i < k:
			if rnd < 0.2184:
				results[i] = "true"
			elif rnd < 0.2184 + 0.3643:
				results[i] = "idk"
			else:
				results[i] = "false"
		else:
			if rnd < 0.2184:
				results[i] = "false"
			elif rnd < 0.2184 + 0.3643:
				results[i] = "idk"
			else:
				results[i] = "true"


	# print trueMap
	# print falseMap

	# pr(irrs, results)
	# print results
	cumT = cum(results, "true")
	cumF = cum(results, "false")

	(predK, maxDiff) = getMaxIndex(cumT, cumF)

	return (predK, maxDiff)

def getMaxIndex2(T):
	results = [""] * T
	k = T / 2

	# generate data
	listTrue  = [0.0] * T
	listFalse = [0.0] * T

	listAll = [""] * T

	for i in range(0, T):
		rnd = np.random.uniform()
		if i < k:
			if rnd < 0.417:
				listTrue[i] = 1
				listAll[i] = "false"
			elif rnd < 0.218 + 0.417:
				listFalse[i] = 1
				listAll[i] = "true"
			else:
				listAll[i] = "-"
		else:
			if rnd < 0.417:
				listFalse[i] = 1
				listAll[i] = "true"
			elif rnd < 0.218 + 0.417:
				listTrue[i] = 1
				listAll[i] = "false"
			else:
				listAll[i] = "-"

	# print listAll

	cumTrue  = np.cumsum(listTrue) 
	cumFalse = np.cumsum(listFalse)

	if cumTrue[-1] > 0: cumTrue  /= cumTrue[-1]
	if cumFalse[-1] > 0: cumFalse /= cumFalse[-1]

	maxP = 0
	bestInd = -1
	
	for i in range(1, T-1):
		numStr1 = cumTrue[i]
		numStr2 = cumFalse[T-1] - cumFalse[i+1]

		# p_val = binom.pmf(numStr1, i, 0.417) + binom.pmf(numStr2, T-i, 0.417)
		p_val = numStr1 + numStr2

		print listAll[i]

		if p_val > maxP:
			maxP = p_val
			bestInd = i

	return bestInd


def main():
	# test()

	numTests = 5000
	T = 50

	results = []
	for i in range(0, 5000):
		results.append(getBoundDiffString(157)[0])
	print np.mean(results)
	print np.std(results)

	getMaxIndex2(T)

	print "t, diff_mean, diff_dev, same_mean, same_dev, z_score"

	for t in range(1, T):

		resultsSameBound = [0] * numTests
		resultsDiffBound = [0] * numTests
		resultsDiffBound_maxdiff = [0] * numTests
		newMethod = [0] * numTests

		for i in range(0, numTests):
			resultsSameBound[i] = getBoundSameString(t)
			resultsDiffBound[i], resultsDiffBound_maxdiff[i] = getBoundDiffString(t)
			# newMethod[i] = getMaxIndex2(T)

		# print resultsSameBound
		# print resultsDiffBound_maxdiff

		resultsSameBound          = np.array(resultsSameBound)
		resultsDiffBound          = np.array(resultsDiffBound)
		resultsDiffBound_maxdiff  = np.array(resultsDiffBound_maxdiff)

		sBmean  = np.mean(resultsSameBound)
		sBstdev = np.std(resultsSameBound)

		dBmean  = np.mean(resultsDiffBound)
		dBstdev = np.std(resultsDiffBound)

		dbMDmean  = np.mean(resultsDiffBound_maxdiff)
		dbMDstdev = np.std(resultsDiffBound_maxdiff)

		# print resultsSameBound
		# print resultsDiffBound_maxdiff
		same_diff = resultsSameBound - resultsDiffBound_maxdiff
		sameDiffMean = sBmean - dbMDmean
		SameDiffDev  = math.sqrt(sBstdev*sBstdev + dbMDstdev*dbMDstdev)
		SameDiffDev2 = math.sqrt(sBstdev*sBstdev/T + dbMDstdev*dbMDstdev/T)
		# var1 = sBstdev*sBstdev
		# var2 = dbMDstdev*dbMDstdev
		# df = (var1/T + var2/T)*(var1/T + var2/T) / ((var1/T)*(var1/T)/(T-1) + (var2/T)*(var2/T)/(T-1))

		# print "Test: " + str(t)
		# print "Same bound:"
		# print "Mean: " + str(sBmean)
		# print "Std Dev: " + str(sBstdev)

		# print "UB: " + str(sBmean + 1.65 * sBstdev) + "\n"

		# print "Diff bound:"
		# print "Mean: " + str(dBmean)
		# print "Std Dev: " + str(dBstdev)

		# print "LB: " + str(dBmean - 1.96 * dBstdev)
		# print "UB: " + str(dBmean + 1.96 * dBstdev) + "\n"

		# print "Diff bound max diff:"
		# print "Mean: " + str(dbMDmean)
		# print "Std Dev: " + str(dbMDstdev)

		# print "LB: " + str(dbMDmean - 1.67 * dbMDstdev) + "\n"

		# print "Same - Diff:"
		# print "Mean: " + str(sameDiffMean)
		# print "Std Dev thry: " + str(SameDiffDev)
		# print sameDiffMean + 1.67 * SameDiffDev

		# print "Two-tailed stuff:"
		# print "z_obs: " + str(-sameDiffMean / SameDiffDev) + "\n"

		# print "\nNew test: "
		# print "Mean: " + str(np.mean(newMethod))
		# print "Std Dev: " + str(np.std(newMethod)) + "\n"

		
		# print ""
		print str(t) + ", " + str(dbMDmean) + ", " + str(dbMDstdev)+ ", " + str(sBmean) + ", " + str(sBstdev) + ", " + str(-sameDiffMean / SameDiffDev)

		# print resultsDiffBound

main()