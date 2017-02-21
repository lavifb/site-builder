# Makefile for site building

# Dirs
SASS := src/sass
TSC  := src/tsc
PUG  := src/pug

TEST := test
PUB  := public
OUTDIRS = $(TEST) $(PUB)

export PATH := node_modules/.bin:$(PATH)

# ANSI Colors
BLUE =\033[0;34m
GREEN=\033[0;32m
NC   =\033[0m

# MAKE commands

default: test-prod

clean:
	-@rm $(TEST)/*.html
	-@rm $(TEST)/css/*
	-@rm $(TEST)/js/*

clean-prod:
	-@rm $(PUB)/*.html
	-@rm $(PUB)/css/*
	-@rm $(PUB)/js/*

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
	@echo "Compiling $(BLUE)$<$(NC) to $(GREEN)$@$(NC)"
	@pug --pretty --silent -o $(@D) $<

$(PUB)/%.html: $(PUG)/%.pug
	@echo "Compiling $(BLUE)$<$(NC) to $(GREEN)$@$(NC)"
	@pug --silent -o $(@D) $<

# Compile sass to css
$(TEST)/css/%.css: $(SASS)/%.sass
	@echo "Compiling $(BLUE)$<$(NC) to $(GREEN)$@$(NC)"
	@sass $< $@

$(PUB)/css/%.css: $(SASS)/%.sass
	@echo "Compiling $(BLUE)$<$(NC) to $(GREEN)$@$(NC)"
	@sass --style compressed --sourcemap=none $< $@

# Compile typescript to js
$(TEST)/js/%.js: $(TSC)/%.ts
	@echo "Compiling $(BLUE)$<$(NC) to $(GREEN)$@$(NC)"
	@tsc --outFile $@ --sourcemap $<

$(PUB)/js/%.js: $(TSC)/%.ts
	@echo "Compiling $(BLUE)$<$(NC) to $(GREEN)$@$(NC)"
	@tsc --outFile $@ $<
