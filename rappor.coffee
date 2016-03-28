needle     = require "needle"
HMAC       = require "create-hmac"
convertHex = require "convert-hex"
md5        = require "md5"
ByteBuffer = require "byte-buffer"
BitArray   = require "bit-array"

# create Rappor object
class window.Rappor

	# hard coding m as 64
	# hard coding server as http://rappor-js.herokuapp.com/api/v1/records
	# should we be hard coding k as well?
	# note that k must be < 32
	# provide default secret
	constructor: (params, server='http://localhost:8080/api/v1/records', debug=false) ->
		defaultParams = 
			k: 32
			h: 2
			p: 0.1
			q: 0.9
			f: 0.15
			m: 8

		@params = params ?= defaultParams

		@params["server"] ?= server
		@params["secret"] ?= "secret"

		@cohort = this._generateCohort(@params["m"])

		# @debug = debug
		@debug = true

	send: (bool) ->
		this._encode(bool)
		this._sendToServer()

	sendTrue: () ->
		this.send(true)

	sendFalse: () ->
		this.send(false)

	_encode: (data) ->
		bits = this._generateRapporBits(data)
		this._generatePrr(bits)
		this._generateIrr()

	_sendToServer: () ->

		data = 
			truth: @truth
			cohort: @cohort
			orig: @orig.join("")
			prr: @prr
			irr: @irr
			params: @params

		options =
			"Access-Control-Allow-Headers": "X-Requested-With"

		console.log data
		# needle.post(@params["server"], data, options, (err, resp) -> if err then console.log err.message else console.log resp.body.message)

		@cohort = this._generateCohort(@params["m"])

	_generateRapporBits: (data) ->
		# return mapping of bits
		# note that the range will create [0 to 16], so we subtract 1

		if typeof data is "boolean"
			trueString = if data then "TRUE" else "FALSE"
		else
			trueString = data

		@truth = trueString
		b = this._to_big_endian(@cohort)

		b.implicitGrowth = true
		b.writeString(trueString)
		val = new Buffer(b.raw)

		digest = md5(val)

		ones = [parseInt("0x" + digest[2*i..2*i+1]) % @params["k"] for i in [0..@params["h"]-1]][0]

		# to ensure big-endianness
		@orig = for num in [@params["k"]-1..0]
					num = if num in ones then 1 else 0

		bloom = 0
		for bit_to_set in ones
			bloom |= (1 << bit_to_set)

		return bloom

	# port of google code
	_generatePrr: (bits) ->
		
		joinedBits = this._to_big_endian(bits)
		val = new Buffer(joinedBits.raw)

		Hmac = new HMAC('sha256', @params["secret"])
		Hmac.update(val)
		digest = Hmac.digest('hex')

		# Use 32 bits.  If we want 64 bits, it may be fine to generate another 32
		# bytes by repeated HMAC.  For arbitrary numbers of bytes it's probably
		# better to use the HMAC-DRBG algorithm.
		if @params["k"] > digest.length
			console.log("Error: too big k")

		digestBytes = convertHex.hexToBytes(digest)
		threshold128 = @params["f"] * 128

		uniform = 0
		f_mask = 0

		# generate f_mask and uniform
		for i in [0..@params["k"]-1]
			byte = digestBytes[i]
			ch = parseInt(byte, 16)
			
			u_bit = byte & 0x01  # 1 bit of entropy
			uniform |= (u_bit << i)  # maybe set bit in mask

			rand128 = byte >> 1  # 7 bits of entropy
			noise_bit = (rand128 < threshold128)
			f_mask |= (noise_bit << i)  # maybe set bit in mask

		@prr = (bits & ~f_mask) | (uniform & f_mask)
		@prr = this._zfill(@prr)

	_generateIrr: () ->

		@irr = []

		for i in [0..@params["k"]-1]
			rand = Math.random()

			if @prr.charAt(i) == '0'
				if rand < @params["p"]
					# console.log "prr string is 0 and pushed 1 bc rand is " + rand
					@irr.push 1
				else
					# console.log "prr string is 0 and pushed 0 bc rand is " + rand
					@irr.push 0

			else
				if rand < @params["q"]
					# console.log "prr string is 1 and pushed 1 bc rand is " + rand
					@irr.push 1
				else
					# console.log "prr string is 1 and pushed 0 bc rand is " + rand
					@irr.push 0

		@irr = @irr.join("")

	_to_big_endian: (num) ->
		b = new ByteBuffer(4, ByteBuffer.BIG_ENDIAN)
		b.writeInt(Number(num))

		return b

	# javascript gets weird handling 32-bit bitstrings
	_zfill: (val) ->
		b = new ByteBuffer(@params["k"] / 8, ByteBuffer.BIG_ENDIAN)
		b.writeInt(val)

		stripped = b.toHex().replace(/ /g,'')

		bi = new BitArray(@params["k"], stripped)

		# now reverse
		bi.toString().split('').reverse().join('')

	_generateCohort: (m) ->
		Math.floor(Math.random() * m)

	_print: ->
		for param, value of @params
			console.log "#{param} is #{value}"

console.log "rappor.js loaded"

