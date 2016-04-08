HMAC       = require "create-hmac"
convertHex = require "convert-hex"
md5        = require "md5"
ByteBuffer = require "byte-buffer"
BitArray   = require "bit-array"
# needle     = require "needle"
request    = require "request"
async      = require "async"

# create Rappor object
class window.Rappor

	# hard coding m as 64
	# hard coding server as http://rappor-js.herokuapp.com/api/v1/records
	# should we be hard coding k as well?
	# note that k must be < 32
	# provide default secret
	constructor: (defaultParams = {}) ->

		baselineParams = 
			k: 32
			h: 2
			p: 0.1
			q: 0.9
			f: 0.15
			m: 8

		@params = defaultParams.params           or baselineParams
		@params["server"] = defaultParams.server or 'http://rappor-js.herokuapp.com/api/v1/records'
		@debug = defaultParams.debug             or false
		@group = defaultParams.publicKey         or ""

		@params["server"] ?= server
		@secret = "secret"

		@cohort = this._generateCohort(@params["m"])

		@debug = false

	send: (bool, n=1) ->
		if typeof bool is "object"
			this.send(s) for s in bool
		else
			@truth = bool
			this._encode()
			this._sendToServer(parseInt n)

	sendTrue: () ->
		this.send(true)

	sendFalse: () ->
		this.send(false)

	_encode: () ->
		bits = this._generateRapporBits()
		this._generatePrr(bits)
		this._generateIrr()

	_sendToServer: (n) ->
		console.log "_sendToServer called with parameter " + n
		arraySizeLimit = 200
		
		allData        = []
		splitData      = {}

		# console.log n
		for i in [1..n]
			this._encode(@truth)
			splitData[i] = this._generateJSON()

			if i % (arraySizeLimit) == 0 or i is n
				allData.push(splitData)
				splitData = {}

		options =
			"Access-Control-Allow-Headers": "X-Requested-With"

		# bind null allows passing in of server parameter
		async.forEachOfSeries(allData, this._postToServer.bind(null, arraySizeLimit, n, @params["server"]), (err) -> if err then console.log err else console.log "All " + n + " reports done!")
		
	_postToServer: (limit, n, server, reports, index, callback) ->

		options =
			"Access-Control-Allow-Headers": "X-Requested-With"
		
		data = 
			url: server,
			headers: options,
			json: reports

		request.post(data, (err, resp, body) -> 
						if err
							console.log err.message
							callback(err)
						else
							console.log body.message

							percentage = ((index*limit + Object.keys(reports).length) * 100 / n) + "%"
							$("#progBar").css("width", percentage);
							callback()
					)

	_generateJSON: () ->
		data = 
			cohort: @cohort
			irr: @irr
			params: @params
			group: @group

		if @debug
			data.truth = @truth
			data.orig = @orig.join("")
			data.prr = @prr

		return data

	_generateRapporBits: () ->
		# return mapping of bits
		# note that the range will create [0 to 16], so we subtract 1

		if typeof @truth is "boolean"
			trueString = if @truth then "true" else "false"
		else
			trueString = @truth

		
		@cohort = this._generateCohort(@params["m"])
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

		Hmac = new HMAC('sha256', @secret)
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

	_print: () ->
		for param, value of @params
			console.log "#{param} is #{value}"

		console.log "@debug is " + @debug
		console.log "@cohort is " + @cohort
		console.log "@group is " + @group

console.log "rappor.js loaded"

