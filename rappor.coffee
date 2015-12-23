needle     = require "needle"
HMAC       = require "create-hmac"
convertHex = require "convert-hex"

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
	# should we be hard coding k as well?
	# note that k must be < 32
	# provide default secret
	constructor: (params, m=64, url='http://rappor-js.herokuapp.com/api/v1/records') ->
		@params = params
		@params["m"] = m
		@params["url"] = url
		@params["secret"] ?= "randomsecret"

		# check endianness (big endian is 2^3, 2^2, 2^1, 2^0)
		@params["big-endian"] = if parseInt("1110", 2) is 14 then true else false

	encode: (bools) ->
		bits = this._generateRapporBits(bools)
		prr = this._generatePrr(bits)
		irr = this._generateIrr(prr)

	sendToServer: (bits) ->
		# first get cohort number
		cohortNo = Math.floor(Math.random() * @params["m"])

		data = 
			cohort: cohortNo
			bitString: bits

		options =
			"Access-Control-Allow-Headers": "X-Requested-With"

		console.log data
		# needle.post(@params["url"], data, options, (err, resp) -> if err then console.log err.message else console.log resp.body)

	_generateRapporBits: (bools) ->
		# return mapping of bits
		# right now returns random array of 1s
		# note that the range will create [0 to 16], so we subtract 1
		# where we need to think about encodings
		bits = for num in [0..@params["k"]-1]
					num = if Math.random() > 0.5 then 1 else 0

	# port of google code
	# note that the data is the array stringified
	# note that the hmac similarity to python needs to be tested
	# note that big endianness might be an issue
	_generatePrr: (bits) ->

		joinedBits = if @params["big-endian"] then bits.join("") else bits.reverse().join("")
		bloom = parseInt(joinedBits, 2)

		Hmac = new HMAC('sha256', @params["secret"])
		Hmac.update(joinedBits)
		digest = Hmac.digest('hex')

		digest = convertHex.hexToBytes(digest)

		threshold128 = @params["f"] * 128

		uniform = 0
		f_mask = 0

		# generate f_mask and uniform
		for i in [0..@params["k"]-1]
			byte = digest[i]

			u_bit = byte & 0x01  # 1 bit of entropy
			uniform |= (u_bit << i)  # maybe set bit in mask

			rand128 = byte >> 1  # 7 bits of entropy
			noise_bit = (rand128 < threshold128)
			f_mask |= (noise_bit << i)  # maybe set bit in mask

		prr = (bloom & ~f_mask) | (uniform & f_mask)

	_generateIrr: (prr) ->

		# first generate bitstrings where each bit has prob p,q of being 1
		irrp = 0
		irrq = 0

		for i in [0..@params["k"]-1]
			bit = Math.random() < @params["p"]
			irrp |= (bit << i)  # using bool as int
			
			bit = Math.random() < @params["q"]
			irrq |= (bit << i)  # using bool as int

		irr = (irrp & ~prr) | (irrq & prr)

	_print: ->
		for param, value of @params
			console.log "#{param} is #{value}"

r = new Rappor params
encodedBits = r.encode(bools)
r.sendToServer(encodedBits)
r._print()

