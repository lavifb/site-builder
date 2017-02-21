# Makefile for site building

# Dirs
SASS := src/sass
TSC  := src/tsc
PUG  := src/pug

TEST := test
PUB  := public
OUTDIRS = $(TEST) $(PUB)

export PATH := node_modules/.bin:$(PATH)

# MAKE commands

default: test-prod

clean:
	rm $(TEST)/*.html
	rm $(TEST)/css/*
	rm $(TEST)/js/*

clean-prod:
	rm $(PUB)/*.html
	rm $(PUB)/css/*
	rm $(PUB)/js/*

prod: html-prod css-prod js-prod

test-prod: html css js

.PHONY: test
test:
	@echo "Test"

html: $(patsubst $(PUG)/%.pug, $(TEST)/%.html, $(wildcard $(PUG)/[^_]*.pug))
html-prod: $(patsubst $(PUG)/%.pug, $(PUB)/%.html, $(wildcard $(PUG)/[^_]*.pug))

css: $(patsubst $(SASS)/%.sass, $(TEST)/css/%.css, $(wildcard $(SASS)/[^_]*.sass))
css-prod: $(patsubst $(SASS)/%.sass, $(PUB)/css/%.css, $(wildcard $(SASS)/[^_]*.sass))

js: $(patsubst $(TSC)/%.ts, $(TEST)/js/%.js, $(wildcard $(TSC)/[^_]*.ts))
js-prod: $(patsubst $(TSC)/%.ts, $(PUB)/js/%.js, $(wildcard $(TSC)/[^_]*.ts))

# Compile pug to html
# $(foreach dir, $(OUTDIRS),$(dir)/%.html): $(PUG)/%.pug
$(TEST)/%.html: $(PUG)/%.pug
	@echo Compiling $@ into html
	pug -P -o $(@D) $<

$(PUB)/%.html: $(PUG)/%.pug
	@echo Compiling $@ into published html
	pug -o $(@D) $<

# Compile sass to css
$(TEST)/css/%.css: $(SASS)/%.sass
	@echo Compiling $@ into css
	sass $< $@

$(PUB)/css/%.css: $(SASS)/%.sass
	@echo Compiling $@ into published css
	sass -t compressed --sourcemap=none $< $@

# Compile typescript to js
$(TEST)/js/%.js: $(TSC)/%.ts
	@echo Compiling $@ into js
	tsc --outFile $@ --sourcemap $<

$(PUB)/js/%.js: $(TSC)/%.ts
	@echo Compiling $@ into published js
	tsc --outFile $@ $<
