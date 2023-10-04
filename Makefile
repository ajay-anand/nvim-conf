all: init.lua coc-settings.json
	@git add -A
	time=$$(date +'%Y%m%d-%H%M%S') &&\
	git commit -m $$time
	git push origin master

init:
	git config user.email "aanand_ub@yahoo.com"
	git config user.name "Anand A."


init.lua: ~/.app/init.lua
	@cp ~/.app/init.lua .

coc-settings.json: ~/.app/coc-settings.json
	@cp ~/.app/coc-settings.json .


