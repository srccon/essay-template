source=sections/*.md
title='TITLE'
filename='tmp/FILENAME'
bibliography=./bibliography.bib

all: rtf pdf doc 

markdown:
	awk 'FNR==1{print ""}{print}' $(source) > $(filename).md
	sed 's/<!--[\s\S]*?-->//g' $(filename).md

check: markdown
	find sections -exec write-good '{}' \;

rtf: markdown
	pandoc --filter pandoc-citeproc -s $(filename).md -o $(filename).rtf \
		--title-prefix $(title) \
		--normalize \
		--smart \
		--bibliography=$(bibliography)
pdf: markdown
	# You need `pdflatex`
	# OS X: http://www.tug.org/mactex/
	# Then find its path: find /usr/ -name "pdflatex"
	# Then symlink it: ln -s /path/to/pdflatex /usr/local/bin
	pandoc --filter pandoc-citeproc -s $(filename).md -o $(filename).pdf \
		--title-prefix $(title) \
		--normalize \
		--smart \
		--toc \
		--latex-engine=`which xelatex` \
		--bibliography=$(bibliography)

doc: markdown
	pandoc --filter pandoc-citeproc -s $(filename).md -o $(filename).doc \
		--title-prefix $(title) \
		--normalize \
		--smart \
		--bibliography=$(bibliography)
