pdflatex := /Library/TeX/texbin/pdflatex
xelatex := /Library/TeX/texbin/xelatex
tlmgr := /Library/TeX/texbin/tlmgr

resume_pkgs := ucs sectsty helvetic
letter_pkgs := enumitem xifthen ifmtarg fontspec fontawesome sourcesanspro tcolorbox environ trimspaces

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build_resume
build_resume: ## Builds resume PDF
	$(pdflatex) *resume.tex

.PHONY: build_letter
build_letter: ## Builds letter PDF
	$(xelatex) letter.tex

.PHONY: watch_resume
watch_resume: ## Rebuilds resume on changes
	@watcher -cmd="xargs $(pdflatex) -interaction=nonstopmode" -keepalive -pipe=true *resume.tex

.PHONY: watch_letter
watch_letter: ## Rebuilds letter on changes
	@watcher -cmd="xargs $(xelatex) -interaction=nonstopmode" -keepalive -pipe=true *letter.tex

.PHONY: versions
versions: ## Shows installed versions of dependencies
	$(pdflatex) -version
	@printf "\n"
	$(xelatex) -version
	@printf "\n"
	watcher -version

.PHONY: install
install: get_basictex get_latex_pkgs get_watcher ## Installs dependencies

.PHONY: get_watcher
get_watcher:
	@curl -sSL https://github.com/dideler/watcher/releases/latest/download/watcher_macOS_64-bit.tar.gz > watcher.tar.gz
	@tar --gzip -xvf watcher.tar.gz --directory ~/bin &>/dev/null
	@rm watcher.tar.gz
	@echo "installed watcher $(shell watcher -version)"

.PHONY: get_basictex
get_basictex:
	@brew cask install basictex

.PHONY: get_latex_pkgs
get_latex_pkgs: get_resume_latex_pkgs get_letter_latex_pkgs

.PHONY: get_resume_latex_pkgs
get_resume_latex_pkgs:
	@sudo $(tlmgr) install $(resume_pkgs)

.PHONY: get_letter_latex_pkgs
get_letter_latex_pkgs:
	@sudo $(tlmgr) install $(letter_pkgs)

.PHONY: uninstall
uninstall: uninstall_watcher uninstall_latex_pkgs uninstall_basictex ## Uninstalls dependencies (!)

.PHONY: uninstall_basictex
uninstall_basictex:
	@brew cask uninstall basictex

.PHONY: uninstall_watcher
uninstall_watcher:
	@test -f ~/bin/watcher && rm ~/bin/watcher

.PHONY: uninstall_latex_pkgs
uninstall_latex_pkgs: uninstall_resume_pkgs uninstall_letter_pkgs

.PHONY: uninstall_resume_pkgs
uninstall_resume_pkgs:
	@sudo $(tlmgr) uninstall $(resume_pkgs)

.PHONY: uninstall_letter_pkgs
uninstall_letter_pkgs:
	@sudo $(tlmgr) uninstall $(letter_pkgs)

.PHONY: clean
clean: ## Cleans generated files
	rm *.pdf *.aux *.log