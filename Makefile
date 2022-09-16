PdfDir = ./docs
OutputDir = ./out
GHCd = ghc -dynamic -outputdir $(OutputDir) -no-keep-hi-files
PTEX = ptex2pdf -u -l -ot "-synctex=1 -interaction=nonstopmode -file-line-error-style -shell-escape"
SAGE = sage -t

all: programs cleanSageAP cleanTeXAP
programs: burnside

define cleanupTeX
	rm -f $(1).aux
	rm -f $(1).log
	rm -f $(1).out
	rm -f $(1).synctex.gz
	rm -f $(1).toc
	rm -f $(1).pyg
	rm -rf _minted-*
endef

define compileTeX
	$(PTEX) $(1).lhs
	mv $(1).pdf $(PdfDir)
	$(call cleanupTeX, $(1))
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

cleanTeXAP: prepDir programs
	find . -type d -name '_minted*' -exec rm -rf {} +
cleanSageAP: prepDir programs
	find . -type f -name '*.sagetex.scmd' -delete
	find . -type f -name '*.sagetex.sout' -delete
	find . -type f -name '*.sagetex.sage' -delete # Recommended to clean, as it contains positional detail within TeX docs
cleanTeX: prepDir
	find . -type d -name '_minted*' -exec rm -rf {} +
cleanSage: prepDir
	find . -type f -name '*.sagetex.scmd' -delete
	find . -type f -name '*.sagetex.sout' -delete
	find . -type f -name '*.sagetex.sage' -delete # Recommended to clean, as it contains positional detail within TeX docs
docs: cleanTex
	rm -rf $(OutputDir)
program: cleanTex
	rm -rf $(PdfDir)
keepSage: programs cleanTex
