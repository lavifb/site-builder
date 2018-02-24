# Makefile for site building
#
# Uses fswatch to watch for file changes and npm's live-server to serve and reload changes automatically

# Dirs
SASS := src/sass
TSC  := src/tsc
PUG  := src/pug

TEST := test
PUB  := public
OUTDIRS = $(TEST) $(PUB)

SHELL := /bin/zsh
export PATH := node_modules/.bin:$(PATH)

# ANSI Colors
BLUE =\033[0;34m
GREEN=\033[0;32m
NC   =\033[0m

# MAKE commands

default: test-prod

.PHONY: setup
setup:
	@mkdir -p $(TEST)
	@mkdir -p $(TEST)/css
	@mkdir -p $(TEST)/js
	@mkdir -p $(PUB)
	@mkdir -p $(PUB)/css
	@mkdir -p $(PUB)/js
	@mkdir -p $(PUB)/img
	@ln -shf ../$(PUB)/img $(TEST)/img

.PHONY: clean clean-prod
clean:
	-@rm $(TEST)/*.html
	-@rm $(TEST)/css/*
	-@rm $(TEST)/js/*
clean-prod:
	-@rm $(PUB)/*.html
	-@rm $(PUB)/css/*
	-@rm $(PUB)/js/*

.PHONY: prod test-prod
prod: html-prod css-prod js-prod
test-prod: html css js

.PHONY: watch
watch:
	watchman-make -p 'src/**/*' -t test-prod

.PHONY: serve
serve:
	live-server test

.PHONY: test
test: test-prod
	live-server test & watchman-make -p 'src/**/*' -t test-prod

.PHONY: html html-prod
html: $(patsubst $(PUG)/%.pug, $(TEST)/%.html, $(wildcard $(PUG)/[^_]*.pug))
html-prod: $(patsubst $(PUG)/%.pug, $(PUB)/%.html, $(wildcard $(PUG)/[^_]*.pug))

.PHONY: css css-prod
css: $(patsubst $(SASS)/%.sass, $(TEST)/css/%.css, $(wildcard $(SASS)/[^_]*.sass)) $(patsubst $(SASS)/%.scss, $(TEST)/css/%.css, $(wildcard $(SASS)/[^_]*.scss))
css-prod: $(patsubst $(SASS)/%.sass, $(PUB)/css/%.css, $(wildcard $(SASS)/[^_]*.sass)) $(patsubst $(SASS)/%.scss, $(TEST)/css/%.css, $(wildcard $(SASS)/[^_]*.scss))

.PHONY: js js-prod
js: $(patsubst $(TSC)/%.ts, $(TEST)/js/%.js, $(wildcard $(TSC)/[^_]*.ts))
js-prod: $(patsubst $(TSC)/%.ts, $(PUB)/js/%.js, $(wildcard $(TSC)/[^_]*.ts))

# Compile pug to html
# $(foreach dir, $(OUTDIRS),$(dir)/%.html): $(PUG)/%.pug
$(TEST)/%.html: $(PUG)/%.pug
	@echo -e "Compiling $(BLUE)$<$(NC) to $(GREEN)$@$(NC)"
	@pug --pretty --silent -o $(@D) $<

$(PUB)/%.html: $(PUG)/%.pug
	@echo -e "Compiling $(BLUE)$<$(NC) to $(GREEN)$@$(NC)"
	@pug --silent -o $(@D) $<

# Compile sass to css
$(TEST)/css/%.css: $(SASS)/%.s[ac]ss
	@echo -e "Compiling $(BLUE)$<$(NC) to $(GREEN)$@$(NC)"
	@node-sass -q $< $@

$(PUB)/css/%.css: $(SASS)/%.s[ac]ss
	@echo -e "Compiling $(BLUE)$<$(NC) to $(GREEN)$@$(NC)"
	@node-sass -q $< $@

# Compile typescript to js
$(TEST)/js/%.js: $(TSC)/%.ts
	@echo -e "Compiling $(BLUE)$<$(NC) to $(GREEN)$@$(NC)"
	@tsc --outFile $@ --sourcemap $<

$(PUB)/js/%.js: $(TSC)/%.ts
	@echo -e "Compiling $(BLUE)$<$(NC) to $(GREEN)$@$(NC)"
	@tsc --outFile /dev/stdout $< | uglifyjs -o $@
