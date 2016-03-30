from fabric.api import local
import webbrowser

RAPPOR_DIRECTORY = "/Users/Akash/Dropbox/rappor-js"

def run():
	local("nodemon server.js")
	webbrowser.open_new_tab("http://localhost:8080")

def analyze():
	assert_directory()
	countFile = "counts.csv"
	truthFile = "cohorts.csv"
	paramFile = "params.csv"
	mapFile   = "map.csv"

	# pull countFile from server
	local("rm -r ./server/outputs")
	local("mkdir -p ./server/outputs")
	local("python ./server/mySumBits.py {} {} {}".format(countFile, truthFile, paramFile)) # add arg1 arg2 arg3 here, where args are filenames

	# also need to create map file
	local("python ./server/map_file.py {} {}".format(paramFile, mapFile))





############################################

def pull():
	local("git pull")

def push(msg="default"):
	local("git add -A")
	local("git commit -m \"%s\"" % msg)
	local("git push origin master")
	local("git push heroku master")
	local("exec R --vanilla --slave -e \"shiny::deployApp()\"")

def linode():
	local("ssh akshjn@45.79.133.53")

def assert_directory():
	local("cd {}".format(RAPPOR_DIRECTORY))

def runb():
	assert_directory()
	local("browserify --fast -t coffeeify rappor.coffee -o rappor.js")
	local("browserify -t coffeeify rappor-examine.coffee -o rappor-examine.js")
	local("cp ./rappor.js ./public/js/rappor-js/")
	local("cp ./rappor-sim.js ./public/js/rappor-js/")
	local("cp ./rappor-examine.js ./public/js/rappor-js/")

def analyzeTest():
	assert_directory()
	paramFile = "params.csv"
	mapFile   = "map.csv"

	local("python ./server/map_file.py {} {}".format(paramFile, mapFile))