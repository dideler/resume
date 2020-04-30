pdflatex := /Library/TeX/texbin/pdflatex
tlmgr := /Library/TeX/texbin/tlmgr

resume_pkgs := ucs sectsty helvetic

.PHONY: watch
watch:
	@watcher -cmd="xargs $(pdflatex) -interaction=nonstopmode" -keepalive -pipe=true *.tex

.PHONY: compile
compile:
	$(pdflatex) -interaction=nonstopmode DennisIdeler-resume.tex

.PHONY: versions
versions:
	$(pdflatex) -version
	@printf "\n"
	watcher -version

.PHONY: install
install: get_basictex get_resume_latex_pkgs get_watcher

.PHONY: get_watcher
get_watcher:
	@curl -sSL https://github.com/dideler/watcher/releases/latest/download/watcher_macOS_64-bit.tar.gz > watcher.tar.gz
	@tar --gzip -xvf watcher.tar.gz --directory ~/bin &>/dev/null
	@rm watcher.tar.gz
	@echo "installed watcher $(shell watcher -version)"

.PHONY: get_basictex
get_basictex:
	@brew cask install basictex

.PHONY: get_resume_latex_pkgs
get_resume_latex_pkgs:
	@sudo $(tlmgr) install $(resume_pkgs)

.PHONY: clean_latex_pkgs
clean_latex_pkgs:
	@sudo $(tlmgr) uninstall $(resume_pkgs)