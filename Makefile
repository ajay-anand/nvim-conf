all: init.lua coc-settings.json
	@git add -A
	time=$$(date +'%Y%m%d-%H%M%S') &&\
	git commit -m $$time
	git push origin main

init:
	git config user.email "********@yahoo.com"
	git config user.name "Anand A."


init.lua: ~/.app/init.lua
	@cp ~/.app/init.lua .

coc-settings.json: ~/.app/coc-settings.json
	@cp ~/.app/coc-settings.json .


