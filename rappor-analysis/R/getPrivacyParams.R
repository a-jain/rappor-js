library("Metrics")

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
plot(dat$false, type='l', xlab="Index of A/A*", ylab="A/A* value", main="Inferring Turning Point")
lines(dat$true)
abline(v=57, col=3, lty="dashed")
