all: init.lua coc-settings.json
	@git add -A
	if time=$$(date +'%Y%m%d-%H%M%S') && git commit -m $$time; then git push origin main; else echo already up to date; fi

init:
	git config user.email "********@yahoo.com"
	git config user.name "Anand A."


init.lua: ~/.app/init.lua
	@cp ~/.app/init.lua .

coc-settings.json: ~/.app/coc-settings.json
	@cp ~/.app/coc-settings.json .


