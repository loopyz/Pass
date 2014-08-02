default: webserver

webserver:
	bundle exec jekyll serve --watch --detach

build:
	bundle exec jekyll build

kill:
	kill -9 $$( ps aux | awk '/[j]ekyll serve/ {print $$2}' )
