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

RapporExamine.userAgentData = (candidate) ->
	
	parser = new RapporExamine.UAParser()
	browser = parser.getBrowser()

	re = new RegExp(candidate, "i")

	if browser.name.search(re) > -1 then 1 else 0

RapporExamine.getRegularPlugins = () ->
	fprint = new RapporExamine.Fingerprint();
	plugins = fprint.getRegularPlugins();

	plugins = plugins.map((plugin) ->
		indx = plugin.indexOf("::");
		return plugin.substring(0, indx);
	)

	# to remove duplicates
	return Array.from(new Set(plugins));

RapporExamine.getAdBlock = (success, failure) ->

	if not fuckAdBlock?
		success()

	fuckAdBlock.onDetected(success)
	fuckAdBlock.onNotDetected(failure)

RapporExamine.test = () ->
	console.log "rappor-examine test"	

console.log "rappor-examine.js loaded"
