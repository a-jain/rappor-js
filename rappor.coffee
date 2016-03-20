needle     = require "needle"
HMAC       = require "create-hmac"
convertHex = require "convert-hex"
md5        = require "md5"
struct     = require "struct"
ByteBuffer = require "byte-buffer"
BitArray   = require "bit-array"

params = 
	k: 32
	h: 2
	p: 0.1
	q: 0.9
	f: 0.15
	m: 8

bool = true

# create Rappor object
class window.Rappor

	# hard coding m as 64
	# hard coding server as http://rappor-js.herokuapp.com/api/v1/records
	# should we be hard coding k as well?
	# note that k must be < 32
	# provide default secret
	constructor: (@params=params, server='http://localhost:8080/api/v1/records', cohort=3) ->
		# @params = params
		@params["server"] ?= server
		@params["secret"] ?= "secret"

		@cohort ?= cohort
		# @cohort = Math.floor(Math.random() * @params["m"])

		# check endianness (big endian is 2^3, 2^2, 2^1, 2^0)
		@params["bigEndian"] = if parseInt("1110", 2) is 14 then true else false

	send: (bool) ->
		this.encode(bool)
		this.sendToServer()

	sendTrue: () ->
		this.send(true)

	sendFalse: () ->
		this.send(false)

	encode: (bool) ->
		@truth = bool
		bits = this._generateRapporBits()
		this._generatePrr(bits)
		this._generateIrr()

	sendToServer: () ->
		
		data = 
			bool: @truth
			cohort: @cohort
			orig: @orig.join("")
			prr: @prr
			irr: @irr
			params: @params

		options =
			"Access-Control-Allow-Headers": "X-Requested-With"

		# console.log "orig is"
		# console.log @orig

		console.log data
		# needle.post(@params["server"], data, options, (err, resp) -> if err then console.log err.message else console.log resp.body.message)

	_generateRapporBits: () ->
		# return mapping of bits
		# note that the range will create [0 to 16], so we subtract 1
		# where we need to think about encodings
		# bits = for num in [0..@params["k"]-1]
		# 			num = if Math.random() > 0.5 then 1 else 0

		# HmacMap = new HMAC('sha1', @params["secret"])
		# HmacMap.update("" + @truth)
		# HmacMap.update("" + @cohort)

		# HmacMap.update("" + true)
		# HmacMap.update("" + 17)

		# val = "" + @truth + (@cohort)

		trueString = if @truth then "TRUE" else "FALSE"

		b = this._to_big_endian(@cohort)

		b.implicitGrowth = true
		# b.prepend(3)
		b.writeString(trueString)
		val = new Buffer(b.raw)

		# console.log "md5 is " + md5(val)

		# console.log md5(val)
		# console.log md5(val)[0..3]
		# console.log parseInt(md5(val)[0..3], 16)

		# ones = [ord(digest[i]) % k for i in xrange(h)]

		digest = md5(val)

		ones = [parseInt("0x" + digest[2*i..2*i+1]) % @params["k"] for i in [0..@params["h"]-1]][0]

		# console.log ones

		# ones = for num in [0..@params["h"]-1]
		# 			num = parseInt(md5(val)[4*num..4*num+3], 16) % @params["k"]

		# to ensure big-endianness
		@orig = for num in [@params["k"]-1..0]
					num = if num in ones then 1 else 0

		bloom = 0
		for bit_to_set in ones
			bloom |= (1 << bit_to_set)

		# console.log "orig is " + @orig
		# console.log "bloom is " + bloom
		# console.log "bloom to big endian is " + this._to_big_endian(bloom).toHex()

		return bloom

	# port of google code
	# note that the data is the array stringified
	# note that the hmac similarity to python needs to be tested
	# note that big endianness might be an issue
	# problem with cohort 4, 6 and true for params k=32, f=0.25, p=0.3, q=0.7
	_generatePrr: (bits) ->
		
		joinedBits = this._to_big_endian(bits)
		val = new Buffer(joinedBits.raw)

		# console.log joinedBits

		# bloom = parseInt(joinedBits, 2)

		Hmac = new HMAC('sha256', @params["secret"])
		Hmac.update(val)
		digest = Hmac.digest('hex')

		# console.log digest

		# Use 32 bits.  If we want 64 bits, it may be fine to generate another 32
		# bytes by repeated HMAC.  For arbitrary numbers of bytes it's probably
		# better to use the HMAC-DRBG algorithm.
		if @params["k"] > digest.length
			console.log("Error: too big k")

		digestBytes = convertHex.hexToBytes(digest)

		# console.log digestBytes

		threshold128 = @params["f"] * 128

		uniform = 0
		f_mask = 0

		# generate f_mask and uniform
		for i in [0..@params["k"]-1]
			byte = digestBytes[i]
			ch = parseInt(byte, 16)
			
			# console.log byte
			# console.log ch

			u_bit = byte & 0x01  # 1 bit of entropy
			uniform |= (u_bit << i)  # maybe set bit in mask

			# console.log uniform

			rand128 = byte >> 1  # 7 bits of entropy
			noise_bit = (rand128 < threshold128)
			f_mask |= (noise_bit << i)  # maybe set bit in mask

		# needed to handle negative numbers
		# console.log "orig f_mask is " + f_mask + " or " + f_mask.toString(2)

		# if f_mask < 0
		# 	console.log "neg case entered"
		# 	f_mask = ~f_mask
		# 	f_mask -= 1
		# 	f_mask = f_mask >>> 0


		# console.log "**"
		# console.log "bits is " + bits + " or " + bits.toString(2)
		# console.log "f_mask is " + f_mask + " or " + f_mask.toString(2)

		# console.log "uniform is " + uniform + " or " + uniform.toString(2)
		
		@prr = (bits & ~f_mask) | (uniform & f_mask)
		
		# console.log "@prr is " + @prr + " or " + @prr.toString(2)

		# @prr = Math.abs @prr

		# console.log "prr: " + @prr + " or as bin: " + parseInt(@prr, 10).toString(2) + " with length: " + parseInt(@prr, 10).toString(2).length
		@prr = this._zfill(@prr)

	_generateIrr: () ->

		# # first generate bitstrings where each bit has prob p,q of being 1
		# irrp = 0
		# irrq = 0

		# for i in [0..@params["k"]]
		# 	# console.log i
		# 	bit = Math.random() < @params["p"]
		# 	irrp |= (bit << i)  # using bool as int
			
		# 	bit = Math.random() < @params["q"]
		# 	irrq |= (bit << i)  # using bool as int

		# @irr = (irrp & ~@prr) | (irrq & @prr)

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

		# console.log "irr is " + @irr + " with length " + @irr.length

	_to_big_endian: (num) ->
		b = new ByteBuffer(4, ByteBuffer.BIG_ENDIAN)
		b.writeInt(Number(num))

		return b

	# javascript gets weird handling 32-bit bitstrings
	_zfill: (val) ->
		# console.log "zfill called on " + val

		# val = val.replace /-/, ""
		# zeroes = "0"
		# padding = @params["k"]-val.length
		# zeroes += "0" for i in [0..padding]

		# console.log "zfill called"
		# console.log val
		# console.log padding
		# console.log zeroes
		# console.log val.length
		# console.log "--"
		# console.log zeroes
		# console.log val
		# console.log (zeroes + val)
		# console.log "returns: " + (zeroes + val).slice(2) + "  and length is " + (zeroes + val).slice(2).length
		# console.log "***"

		# (zeroes + val).slice(2).replace /-/, "0"

		# console.log val
		b = new ByteBuffer(@params["k"] / 8, ByteBuffer.BIG_ENDIAN)
		b.writeInt(val)
		# console.log(b.toHex())

		stripped = b.toHex().replace(/ /g,'')
		# console.log(stripped)

		bi = new BitArray(@params["k"], stripped)
		# bi.toHexString()
		# bi.toString()

		# now reverse
		bi.toString().split('').reverse().join('')

	_print: ->
		for param, value of @params
			console.log "#{param} is #{value}"

console.log "rappor.js loaded"

