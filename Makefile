pdflatex := /Library/TeX/texbin/pdflatex
xelatex := /Library/TeX/texbin/xelatex
tlmgr := /Library/TeX/texbin/tlmgr

resume_pkgs := ucs sectsty helvetic
letter_pkgs := enumitem xifthen ifmtarg fontspec fontawesome sourcesanspro tcolorbox environ trimspaces


.PHONY: watch_resume
watch_resume:
	@watcher -cmd="xargs $(pdflatex) -interaction=nonstopmode" -keepalive -pipe=true *resume.tex

.PHONY: watch_letter
watch_letter:
	@watcher -cmd="xargs $(xelatex) -interaction=nonstopmode" -keepalive -pipe=true *letter.tex

.PHONY: build_resume
build_resume:
	$(pdflatex) *resume.tex

.PHONY: build_letter
build_letter:
	$(xelatex) letter.tex

.PHONY: versions
versions:
	$(pdflatex) -version
	@printf "\n"
	$(xelatex) -version
	@printf "\n"
	watcher -version

.PHONY: install
install: get_basictex get_latex_pkgs get_watcher

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
uninstall: uninstall_latex_pkgs uninstall_basictex

.PHONY: uninstall_basictex
uninstall_basictex:
	@brew cask uninstall basictex

.PHONY: uninstall_latex_pkgs
uninstall_latex_pkgs: uninstall_resume_pkgs uninstall_letter_pkgs

.PHONY: uninstall_resume_pkgs
uninstall_resume_pkgs:
	@sudo $(tlmgr) uninstall $(resume_pkgs)

.PHONY: uninstall_letter_pkgs
uninstall_letter_pkgs:
	@sudo $(tlmgr) uninstall $(letter_pkgs)