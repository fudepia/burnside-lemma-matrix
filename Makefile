PdfDir = ./docs
OutputDir = ./out
GHCd = ghc -dynamic -outputdir $(OutputDir) -no-keep-hi-files
PTEX = ptex2pdf -u -l -ot "-synctex=1 -interaction=nonstopmode -file-line-error-style -shell-escape"
SAGE = sage -t

all: programs cleanSageAP cleanTeXAP cleanTeX
programs: burnside


define compileTeX
	$(PTEX) $(1).lhs
	mv $(1).pdf $(PdfDir)
endef

define compileHS
	$(GHCd) $(1).lhs
endef

burnside: prepDir
	$(call compileHS, burnside)
	$(call compileTeX, burnside)
	$(SAGE) burnside.sagetex.sage
	$(call compileTeX, burnside)

prepDir:
	mkdir -p $(OutputDir)
	mkdir -p $(PdfDir)

clean: cleanSage cleanTeX; rm -rf $(OutputDir) $(PdfDir)

cleanTeXAP: programs
	find . -type d -name '_minted*' -exec rm -rf {} +
cleanSageAP: programs
	find . -type f -name '*.sagetex.scmd' -delete
	find . -type f -name '*.sagetex.sout' -delete
	find . -type f -name '*.sagetex.sage' -delete # Recommended to clean, as it contains positional detail within TeX docs
cleanTeX: programs
	find . -type f -name '*.aux' -delete
	find . -type f -name '*.log' -delete
	find . -type f -name '*.out' -delete
	find . -type f -name '*.synctex.gz' -delete
	find . -type f -name '*.toc' -delete
	find . -type f -name '*.pyg' -delete
	find . -type d -name '_minted*' -exec rm -rf {} +
cleanSage: programs
	find . -type f -name '*.sagetex.scmd' -delete
	find . -type f -name '*.sagetex.sout' -delete
	find . -type f -name '*.sagetex.sage' -delete # Recommended to clean, as it contains positional detail within TeX docs
docs: cleanTex
	rm -rf $(OutputDir)
program: cleanTex
	rm -rf $(PdfDir)
keepSage: programs cleanTeX
