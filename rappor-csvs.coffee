Python = require "python-runner"
 
Python.execScript(
	__dirname + "/server/test.py",
	{
		bin: "python2.7"	
	}
)
.then((data) ->
	console.log data
)
.catch((err) ->
	console.log "Error", err
)