from fabric.api import local
import webbrowser
import boto
from boto.s3.key import Key

RAPPOR_DIRECTORY = "/Users/Akash/Dropbox/rappor-js"

def run():
	local("nodemon server.js")
	webbrowser.open_new_tab("http://localhost:8080")

# def analyze(privateKey=""):
# 	assert_directory()
# 	# countFile = "counts.csv"
# 	# truthFile = "cohorts.csv"
# 	paramFile = "params.csv"
# 	mapFile   = "map.csv"

# 	# pull countFile from server
# 	local("rm -r ./server/outputs")
# 	local("mkdir -p ./server/outputs")
# 	local("python ./server/mySumBits.py {}".format(privateKey)) # add arg1 arg2 arg3 here, where args are filenames

# 	# also need to create map file
# 	local("python ./server/map_file.py {} {}".format(paramFile, mapFile))

############################################

def pull():
	local("git pull")

def push(msg="default"):
	runb()
	local("npm shrinkwrap")
	pushGit(msg)
	local("git push heroku master")
	pushAWS()

def pushGit(msg="default"):
	local("git add -A")
	local("git commit -m \"%s\"" % msg)
	local("git push origin master")
	
# run in R: rsconnect::deployApp('Dropbox/rappor-js/rappor-analysis')
def pushR():
	local("exec R --vanilla --slave -e \"rsconnect::deployApp()\"")

def pushAWS():
	local("echo AWS")
	conn = boto.connect_s3()
	bucket = conn.get_bucket('rappor-js')
	k = Key(bucket)
	k.key = "rappor.min.js"
	k.set_contents_from_file(open('public/js/rappor-js/rappor.min.js', 'r+'))
	k.set_acl('public-read')

	k.key = "rappor-examine.min.js"
	k.set_contents_from_file(open('public/js/rappor-js/rappor-examine.min.js', 'r+'))
	k.set_acl('public-read')

# def linode():
# 	local("ssh akshjn@45.79.133.53")

def assert_directory():
	local("cd {}".format(RAPPOR_DIRECTORY))

def runb():
	assert_directory()
	local("browserify --fast -t coffeeify rappor.coffee -o public/js/rappor-js/rappor.js")
	local("browserify -t coffeeify rappor-examine.coffee -o public/js/rappor-js/rappor-examine.js")
	# local("browserify -t coffeeify rappor-csvs.coffee -o public/js/rappor-js/rappor-csvs.js")
	# local("coffee thesis-exp-simulation.coffee -o public/js/rappor-js/thesis-exp-simulation.js")

	local("uglifyjs public/js/rappor-js/rappor.js -o public/js/rappor-js/rappor.min.js -m --stats --keep-fnames")
	local("uglifyjs public/js/rappor-js/rappor-examine.js -o public/js/rappor-js/rappor-examine.min.js -m --stats --keep-fnames")


def scale(n=1):
	local("heroku ps:scale web=%d" % int(n))

# def analyzeTest():
# 	assert_directory()
# 	paramFile = "params.csv"
# 	mapFile   = "map.csv"

# 	local("python ./server/map_file.py {} {}".format(paramFile, mapFile))