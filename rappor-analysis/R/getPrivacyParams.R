library("Metrics")
library("plotrix")
library("Hmisc")

source('R/decode.R')

# p, q, f, h, N
alpha = 0.05
N = 10000
ln_3 = 1.0986

n = 9*9*9*2

ps <- numeric(n)
qs <- numeric(n)
fs <- numeric(n)
hs <- numeric(n)
cs <- numeric(n)
mins <- numeric(n)

params = list(p=0, q=0, f=0, h=1)

i = 0
for (pZ in seq(0.1, 0.5, by=0.1)) {
	params$p = pZ

	for (qZ in seq(0.5, 0.9, by=0.1)) {
		params$q = qZ

		for (fZ in seq(0.8, 0.9, by=0.01)) {
			params$f = fZ

			for (hZ in 2:3) {
				params$h = hZ
				c = ComputePrivacyGuarantees(params, alpha, N)
				# print(c)
				
				ps[i] = params$p
				qs[i] = params$q
				fs[i] = params$f
				hs[i] = params$h
				cs[i] = c[4,2]
				mins[i] = c[7,2]
				
				i = i + 1
				
				# r = c(params$p, params$q, params$f, params$h, c[6,2])
				
        # stop()
			}
	  } 
	}
}

r = data.frame(ps, qs, fs, hs, cs, mins)
# r = data.frame(fs, hs, cs)
r = r[r$ps != r$qs,]
r = r[r$cs < ln_3,]
r = r[r$cs > 1,]

r = r[with(r, order(-cs, mins, ps, qs)),]
r

c = ComputePrivacyGuarantees(list(p=0.1, q=0.8, f=0.81, h=2), alpha, N)
# r = r[1:10,]
# r = r[with(r, order(ps, qs)),]
###
# generate q/epsilon graph
###

t = seq(0.01, 0.99, 0.01)
epsilon = log((1+t) / (1-t))

plot(epsilon, t, main="t as a function of epsilon")

###
# chi^2 tests
###

predicted = c(5276, 4732)
actual    = c(5000, 5000)
rmse(actual, predicted)

###
# exponential coefficients
###

exps = seq(1, 5) / 10
allExps = round(exp(exps)*1467)
allExps

###
# Generate algo graph
###
dat = read.csv("false-true-ba62807905c7.csv")
plot(dat$false, type='l', xlab="Index of A/A*", ylab="A/A* value", main="Inferring Turning Point", col=c("blue"))
lines(dat$true, col=c("red"))
abline(v=57, col=3, lty="dashed")
legend(1, 0.8, legend=c("A (false)", "A* (true)"), col=c("red", "blue"), lty=1, cex=1.5, bty = "n")

###
# Find thresholds
###
dat2 = read.csv("thesis-threshold-determination.csv", header=TRUE)
plot(dat2$z_score / 2, ylim=c(0, 1), xlab="T", ylab="max_difference", main="Threshold for H_0 rejection", type="l", xaxt = "n", col="blue")
arrows(seq(1, 199), dat2$diff_mean-dat2$diff_dev, seq(1, 199), dat2$diff_mean+dat2$diff_dev, code=3, length=0.02, angle=90, col="gray90")
arrows(seq(1, 199), dat2$same_mean-dat2$diff_dev, seq(1, 199), dat2$same_mean+dat2$diff_dev, code=3, length=0.02, angle=90, col="gray90")
lines(dat2$diff_mean, col="black", lty=5)
lines(dat2$same_mean, col="black", lty=1)


abline(v=10, col="red", lty="dashed")
abline(v=158, col="red", lty="dashed")
abline(h=1.65 / 2, col="red", lty="dashed")
legend(140, 0.65, legend=c("mean different strings", "mean same strings", "z-score of difference", "intersections of note"), col=c("black", "black", "blue", "red"), lty=c(5, 1, 1, 2), cex=0.8, text.width=45)
axis(side = 1, at = c(1, 10, 25, 50, 75, 100, 125, 150, 158, 175, 200))
axis(side = 4, at = seq(0.0, 1.0, 0.2), labels=seq(0.0, 2.0, 0.4))
mtext("Z-score", side=4, line=2.5)

dat2 = dat2[c("diff_mean", "diff_dev", "same_mean", "same_dev", "z_score")]
dat2[,] <-round(dat2[,],3)
dat2 = dat2[1:NROW(dat2) %% 10 == 0, ]
write.csv(dat2, file="thesis-thresholds-final.csv")

# resultsSameBound = c(0.35104364326375714, 0.5073313782991202, 0.32258064516129037, 0.2824561403508772, 0.24301075268817207, 0.13777089783281737, 0.11111111111111116, 0.24242424242424243, 0.23529411764705882, 0.14564564564564564, 0.21091811414392062, 0.18013468013468015, 0.15954415954415957, 0.1785714285714286, 0.2, 0.3815580286168521, 0.2698412698412699, 0.21875, 0.1680672268907563, 0.2887700534759358, 0.20445344129554655, 0.15426497277676943, 0.3140350877192982, 0.23809523809523808, 0.43589743589743585, 0.4032258064516129, 0.16191904047976013, 0.31066176470588236, 0.12790697674418605, 0.21333333333333332, 0.40909090909090906, 0.20454545454545453, 0.3611111111111111, 0.2559139784946237, 0.19122807017543864, 0.32055749128919864, 0.2380952380952381, 0.13695090439276492, 0.23949579831932766, 0.190990990990991, 0.1711711711711712, 0.19444444444444442, 0.35714285714285715, 0.29411764705882354, 0.1201079622132254, 0.2717391304347826, 0.20588235294117652, 0.29605263157894735, 0.157495256166983, 0.12522686025408347, 0.3517241379310345, 0.16849816849816845, 0.16216216216216217, 0.3445945945945946, 0.20238095238095233, 0.4166666666666667, 0.4431239388794567, 0.28365384615384615, 0.22546419098143233, 0.2611111111111112, 0.22943722943722944, 0.17777777777777776, 0.21703296703296698, 0.2943548387096774, 0.18614718614718612, 0.19103313840155944, 0.3969696969696969, 0.16959064327485374, 0.26315789473684204, 0.125, 0.2562724014336918, 0.13882063882063883, 0.2761904761904762, 0.2055555555555556, 0.22999999999999998, 0.32352941176470584, 0.31417624521072796, 0.21862348178137653, 0.21929824561403505, 0.19999999999999996, 0.28214285714285714, 0.14848484848484847, 0.2950310559006212, 0.30833333333333335, 0.35, 0.22777777777777775, 0.32352941176470584, 0.14135338345864668, 0.17468805704099832, 0.23502304147465436, 0.35317460317460314, 0.22394678492239461, 0.21710526315789475, 0.1785714285714286, 0.20588235294117646, 0.2142857142857143, 0.22899728997289975, 0.1470588235294118, 0.29761904761904767, 0.15476190476190474)
# resultsDiffBound = c(0.33999999999999997, 0.2921739130434783, 0.30654761904761907, 0.35052910052910047, 0.33000000000000007, 0.5276923076923077, 0.40476190476190477, 0.3075862068965517, 0.4070660522273425, 0.21693121693121697, 0.19826086956521738, 0.40552995391705066, 0.29103448275862065, 0.4532967032967033, 0.2820512820512821, 0.5517241379310345, 0.542608695652174, 0.38530734632683655, 0.1904761904761904, 0.5, 0.2365217391304348, 0.5993589743589743, 0.3353846153846154, 0.37037037037037035, 0.23333333333333328, 0.532608695652174, 0.3256410256410256, 0.5516666666666666, 0.22962962962962963, 0.3149350649350649, 0.435, 0.41565217391304343, 0.5252173913043479, 0.22166666666666662, 0.37318840579710144, 0.2962962962962963, 0.3939393939393939, 0.43162393162393164, 0.31818181818181823, 0.31521739130434784, 0.38833333333333336, 0.20714285714285707, 0.2630769230769231, 0.24505928853754944, 0.2891737891737891, 0.3602941176470588, 0.5113960113960114, 0.2375, 0.39619047619047615, 0.4476923076923077, 0.2859259259259259, 0.5138339920948616, 0.22938530734632684, 0.29802955665024633, 0.475095785440613, 0.29166666666666663, 0.313782991202346, 0.5403726708074534, 0.3571428571428572, 0.5734265734265734, 0.465034965034965, 0.19191919191919193, 0.4750733137829912, 0.3533333333333334, 0.587991718426501, 0.30000000000000004, 0.3785714285714285, 0.4715099715099715, 0.3333333333333333, 0.35555555555555557, 0.16666666666666663, 0.48611111111111116, 0.32065217391304346, 0.5466666666666666, 0.4715099715099715, 0.41818181818181815, 0.3007407407407408, 0.5533333333333333, 0.25, 0.3083333333333333, 0.39398496240601505, 0.23851851851851846, 0.37913043478260866, 0.43726708074534165, 0.2852292020373514, 0.48210526315789476, 0.24965517241379315, 0.5921325051759835, 0.3846153846153846, 0.5166666666666666, 0.5158730158730158, 0.1318840579710145, 0.6072727272727273, 0.30681818181818177, 0.5837037037037037, 0.5264423076923077, 0.4568421052631578, 0.3587096774193549, 0.5032467532467533, 0.48260869565217396)
# plot(sort(resultsSameBound), ylim=c(0.1, 0.6))
# plot(sort(resultsDiffBound), ylim=c(0.1, 0.6))
# 
# diffs = resultsSameBound - resultsDiffBound
# summary(diffs)
# mean(as.vector(diffs)) + 1.67 * sd(as.vector(diffs))

library(car)
dat3 = read.csv("thesis-sample-d.csv")
X = as.vector(dat3$X.)
Xall  = car::recode(X, '"true" = 1; "-" = 0; "false" = -1')
Xtrue = car::recode(X, '"true" = 1; "-" = 0; "false" = 0')
Xfalse = car::recode(X, '"true" = 0; "-" = 0; "false" = -1')


plot(rep(0, 50), type="h", lwd=5, yaxt="n", ylab="Inferred string", xlab="Index of d", main="MLE of true/false in d")
axis(side = 2, at = c(-1, 0, 1), labels=c("false", "pass", "true"))
lines(Xtrue, lwd=6, type="h", col="green")
lines(Xfalse, lwd=6, type="h", col="red")
lines(rep(0, 50), type="h", lwd=5)

######
## timing tests
#####

dat5 = read.csv("thesis-exp-timing-tests.csv", header=TRUE)
mean(dat5[dat5$N==1000,]$refreshes)
sd(dat5[dat5$N==1000,]$refreshes) / sqrt(5)

mean(dat5[dat5$N==10000,]$refreshes)
sd(dat5[dat5$N==10000,]$refreshes) / sqrt(5)
mean(dat5[dat5$N==20000,]$refreshes)
sd(dat5[dat5$N==20000,]$refreshes) / sqrt(5)
mean(dat5[dat5$N==30000,]$refreshes, na.rm=TRUE)
sd(dat5[dat5$N==30000,]$refreshes, na.rm=TRUE) / sqrt(5)
mean(dat5[dat5$N==40000,]$refreshes)
sd(dat5[dat5$N==40000,]$refreshes) / sqrt(5)
mean(dat5[dat5$N==50000,]$refreshes)
sd(dat5[dat5$N==50000,]$refreshes) / sqrt(5)