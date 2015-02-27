source=sections/*.md
title='TITLE'
filename='tmp/FILENAME'
bibliography=./bibliography.bib

all: html epub rtf pdf mobi

markdown:
	awk 'FNR==1{print ""}{print}' $(source) > $(filename).md
	sed 's/<!--[\s\S]*?-->//g' $(filename).md

check: markdown
	find sections -exec write-good '{}' \;

html: markdown
	pandoc --filter pandoc-citeproc -s $(filename).md -t html5 -o index.html -c style.css \
		--include-in-header $(include_dir)/head.html \
		--include-before-body $(include_dir)/author.html \
		--include-before-body $(include_dir)/share.html \
		--include-after-body $(include_dir)/stats.html \
		--title-prefix $(title) \
		--normalize \
		--smart \
		--toc \
		--bibliography=$(bibliography)

epub: markdown
	pandoc --filter pandoc-citeproc -s $(filename).md --normalize --smart -t epub -o $(filename).epub \
		--epub-metadata $(include_dir)/metadata.xml \
		--epub-stylesheet epub.css \
		--epub-cover-image img/cover.jpg \
		--title-prefix $(title) \
		--normalize \
		--smart \
		--toc \
		--bibliography=$(bibliography)

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

mobi: epub
	# Download: http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000765211
	# Symlink bin: ln -s /path/to/kindlegen /usr/local/bin
	kindlegen $(filename).epub
	

doc: markdown
	pandoc --filter pandoc-citeproc -s $(filename).md -o $(filename).doc \
		--title-prefix $(title) \
		--normalize \
		--smart \
		--bibliography=$(bibliography)
