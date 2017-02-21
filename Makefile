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

clean-prod:
	rm $(PUB)/*.html
	rm $(PUB)/css/*

prod: html-prod css-prod

test-prod: html css

.PHONY: test
test:
	@echo "Test"
	@echo $(foreach dir, $(OUTDIRS),$(dir)/index.html)

html: $(patsubst $(PUG)/%.pug, $(TEST)/%.html, $(wildcard $(PUG)/[^_]*.pug))

html-prod: $(patsubst $(PUG)/%.pug, $(PUB)/%.html, $(wildcard $(PUG)/[^_]*.pug))

css: $(patsubst $(SASS)/%.sass, $(TEST)/css/%.css, $(wildcard $(SASS)/[^_]*.sass))

css-prod: $(patsubst $(SASS)/%.sass, $(PUB)/css/%.css, $(wildcard $(SASS)/[^_]*.sass))

# Compile pug to html
# $(foreach dir, $(OUTDIRS),$(dir)/%.html): $(PUG)/%.pug
$(TEST)/%.html: $(PUG)/%.pug
	@echo Compiling $@
	@pug -P -o $(@D) $<

$(PUB)/%.html: $(PUG)/%.pug
	@echo Compiling $@
	@pug -o $(@D) $<

# Compile sass to css
$(TEST)/css/%.css: $(SASS)/%.sass
	@echo Compiling $@
	@sass $< $@

$(PUB)/css/%.css: $(SASS)/%.sass
	@echo Compiling $@
	@sass -t compressed --sourcemap=none $< $@