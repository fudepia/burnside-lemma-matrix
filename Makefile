OutputDir = ./out
PdfDir = ./docs
GHCd = ghc -dynamic -outputdir $(OutputDir) -no-keep-hi-files
PTEX = ptex2pdf -u -l -ot "-synctex=1 -interaction=nonstopmode -file-line-error-style -shell-escape" -output-directory $(PdfDir)
SAGE = sage -t

all: programs cleanTex cleanSage
programs: burnside

burnside: prepDir
	$(GHCd) ./burnside.lhs
	touch burnside.pyg # Temp fix
	$(PTEX) ./burnside.lhs
	$(SAGE) $(PdfDir)/burnside.sagetex.sage
	$(PTEX) ./burnside.lhs

prepDir:
	mkdir -p $(OutputDir)
	mkdir -p $(PdfDir)

clean:; rm -rf $(OutputDir) $(PdfDir)

cleanTex: prepDir
	find $(PdfDir)/ -type f -name '*.aux' -delete
	find $(PdfDir)/ -type f -name '*.log' -delete
	find $(PdfDir)/ -type f -name '*.out' -delete
	find $(PdfDir)/ -type f -name '*.pyg' -delete
	find $(PdfDir)/ -type f -name '*.synctex.gz' -delete
	find $(PdfDir)/ -type f -name '*.toc' -delete
cleanSage: prepDir
	find $(PdfDir)/ -type f -name '*.sagetex.scmd' -delete
	find $(PdfDir)/ -type f -name '*.sagetex.sout' -delete
docs: cleanTex
	rm -rf $(OutputDir)
program: cleanTex
	rm -rf $(PdfDir)
keepSage: programs cleanTex
