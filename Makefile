all: init.lua coc-settings.json
	@git add -A
	@if time=$$(date +'%Y%m%d-%H%M%S') && git commit -m $$time; then git push origin main; fi

init:
	git config user.email "********@yahoo.com"
	git config user.name "Anand A."


init.lua: ~/.app/init.lua
	@cp $< .

coc-settings.json: ~/.app/coc-settings.json
	@cp $< .


