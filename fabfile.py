from fabric.api import local

def pull():
	local("git pull")

def push(msg="default"):
	local("git add -A")
	local("git commit -m \"%s\"" % msg)
	local("git push origin master")

def linode():
	local("ssh akshjn@45.79.133.53")

def run():
	local("nodemon server.js")

def runb():
	local("browserify -t coffeeify rappor.coffee -o rappor.js")

# execute JS n times
def sim(n=100):
	server = "file:///Users/Akash/Dropbox/rappor-js/rappor.html"
	for i in range(0, int(n)):
		local("curl %s" % server)

def analyze():
	local("python mySumBits.py") # add arg1 arg2 arg3 here, where args are filenames