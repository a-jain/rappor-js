RapporExamine = window.RapporExamine || {}
RapporExamine.Fingerprint = require "fingerprintjs2"
RapporExamine.UAParser    = require "ua-parser-js"
RapporExamine.fuckAdBlock = require "FuckAdBlock"
window.RapporExamine = RapporExamine

RapporExamine.getData = (result, components) ->
	# console.log(result) # a hash, representing your device fingerprint
	console.log components # an array of FP components

RapporExamine.allData = () ->
	fprint = new RapporExamine.Fingerprint()

	fprint.get(RapporExamine.getData)

	# return components

RapporExamine.getBrowser = () ->
	
	parser = new RapporExamine.UAParser()
	browser = parser.getBrowser()

	browser.name.toLowerCase()


RapporExamine.getAdBlock = (success, failure) ->

	if not fuckAdBlock?
		success()

	fuckAdBlock.onDetected(success)
	fuckAdBlock.onNotDetected(failure)

RapporExamine.getPlugins = () ->
	fprint = new RapporExamine.Fingerprint()
	plugins = fprint.getRegularPlugins()

	plugins = plugins.map((plugin) ->
		indx = plugin.indexOf("::")
		return plugin.substring(0, indx).toLowerCase()
	)

	# to remove duplicates
	plugins = Array.from(new Set(plugins))

RapporExamine.hasPlugin = (s) ->
	plugins = RapporExamine.getPlugins()

	if plugins.join("").indexOf(s.toLowerCase()) != -1 then return true else return false

RapporExamine.getLanguage = () ->
	fprint = new RapporExamine.Fingerprint()
	keys = []
	fprint.languageKey(keys)

	keys[0].value

# crude approximation - check for availability of the 'ontouchstart' property
RapporExamine.getTouchSupport = () ->
	fprint = new RapporExamine.Fingerprint()
	keys = []
	fprint.touchSupportKey(keys)

	keys[0].value[2]

RapporExamine.test = () ->
	console.log "rappor-examine test"	

console.log "rappor-examine.js loaded"
