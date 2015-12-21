from fabric.api import local

def pull():
	local("git pull")

def push(msg="default"):
	local("git add -A")
	local("git commit -m \"%s\"" % msg)
	local("git push origin master")

def linode():
	local("ssh akshjn@45.79.133.53")