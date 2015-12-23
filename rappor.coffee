md5 = require "md5"
needle = require "needle"

params = 
	k: 16
	h: 3
	p: 0.4
	q: 0.6
	f: 0.5

bools = [
	true
	true
	false
]

# create Rappor object
class Rappor

	# hard coding m as 64
	# hard coding URL as http://rappor-js.herokuapp.com/api/v1/records
	constructor: (params, m=64, url='http://rappor-js.herokuapp.com/api/v1/records') ->
		@params = params
		@params["m"] = m
		@params["url"] = url

	generateRapporBits: (bools) ->
		# return mapping of bits
		# right now returns random array of 1s
		# note that the range will create [0 to 16], so we subtract 1
		@bits = for num in [0..@params["k"]-1]
					num = if Math.random() > 0.5 then 1 else 0

	sendToServer: ->
		# first get cohort number
		cohortNo = Math.ceil(Math.random() * @params["m"])
		data = 
			cohort: cohortNo
			bitString: @bits.join("")

		options =
			"Access-Control-Allow-Headers": "x-requested-with"

		console.log data
		needle.post(@params["url"], data, options, (err, resp) -> if err then console.log err else console.log(resp))

	print: ->
		console.log @bits
		console.log @bits.join("")
		for param, value of @params
			console.log "#{param} is #{value}"

r = new Rappor params
r.generateRapporBits(bools)
r.print()
r.sendToServer()