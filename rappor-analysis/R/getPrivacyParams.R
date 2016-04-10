source('R/decode.R')

# ComputePrivacyGuarantees <- function(params, alpha, N)

# p, q, f, h, N
alpha = 0.05
N = 2000
ln_3 = 1.0986

n = 9*9*9*2

ps <- numeric(n)
qs <- numeric(n)
fs <- numeric(n)
hs <- numeric(n)
cs <- numeric(n)

params = list(p=0, q=0, f=0, h=1)

i = 0
for (pZ in seq(0.1, 0.9, by=0.1)) {
	params$p = pZ

	for (qZ in seq(0.1, 0.9, by=0.1)) {
		params$q = qZ

		for (fZ in seq(0.1, 0.9, by=0.1)) {
			params$f = fZ

			for (hZ in 2:3) {
				params$h = hZ
				c = ComputePrivacyGuarantees(params, alpha, N)
				# print(c[6,2])
				
				ps[i] = params$p
				qs[i] = params$q
				fs[i] = params$f
				hs[i] = params$h
				cs[i] = c[6,2]
				
				i = i + 1
				
				# r = c(params$p, params$q, params$f, params$h, c[6,2])
				
        # stop()
			}
		}
	}
}

r = data.frame(ps, qs, fs, hs, cs)
r = r[r$ps != r$qs,]
print(r[r$cs < ln_3,])