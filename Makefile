# Build lecture PDFs.
#   lectures/<lecture>/{handout,presentation}/<kind>.tex
#     -> out/<lecture>/<kind>.pdf          (PDFs)
#     -> out/<lecture>/build/<kind>/...    (aux files and other artifacts)
#
# make                      build everything
# make <lecture>            build handout + presentation of one lecture
# make <lecture>/<kind>     build a single document, e.g. make lattice_problems_and_lwe/handout
# make clean                remove out/ contents
# Options: ENGINE=-lualatex (default -pdf = pdflatex)

MAKEFLAGS += --keep-going   # one failing document must not block the others

LECTURES_DIR := lectures
OUT_DIR      := out
KINDS        := handout presentation
ENGINE       ?= -pdf
LATEXMK      ?= latexmk
LATEXMK_FLAGS = $(ENGINE) -interaction=nonstopmode -halt-on-error -shell-escape

ROOT     := $(CURDIR)
LECTURES := $(sort $(notdir $(patsubst %/,%,$(dir $(wildcard $(LECTURES_DIR)/*/.)))))
DOCS     := $(foreach l,$(LECTURES),$(foreach k,$(KINDS),$(if $(wildcard $(LECTURES_DIR)/$(l)/$(k)/$(k).tex),$(l)/$(k))))
PDFS     := $(foreach d,$(DOCS),$(OUT_DIR)/$(dir $(d))$(notdir $(d)).pdf)

.PHONY: all clean $(LECTURES) $(DOCS)

all: $(PDFS)

# make <lecture> -> all docs of that lecture
$(foreach l,$(LECTURES),$(eval $(l): $(filter $(l)/%,$(DOCS))))

$(DOCS): %: $(OUT_DIR)/%.pdf

# Always run latexmk (it tracks dependencies itself); \input files live in content/.
.PHONY: FORCE
FORCE:

$(OUT_DIR)/%.pdf: FORCE
	@lecture=$(word 1,$(subst /, ,$*)); kind=$(word 2,$(subst /, ,$*)); \
	mkdir -p $(ROOT)/$(OUT_DIR)/$$lecture/build/$$kind && \
	cd $(LECTURES_DIR)/$$lecture/$$kind && \
	$(LATEXMK) $(LATEXMK_FLAGS) \
	  -outdir=$(ROOT)/$(OUT_DIR)/$$lecture \
	  -auxdir=$(ROOT)/$(OUT_DIR)/$$lecture/build/$$kind \
	  $$kind.tex

clean:
	rm -rf $(OUT_DIR)/*
