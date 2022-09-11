OutputDir = ./out
PdfDir = ./docs
GHC = ghc -dynamic -outputdir $(OutputDir) -no-keep-hi-files
TEX = ptex2pdf -u -l -ot "-synctex=1 -interaction=nonstopmode -file-line-error-style -shell-escape" -output-directory $(PdfDir)

all: programs cleanTex
programs: burnside

burnside: prepDir
	$(GHC) ./burnside.lhs
	$(TEX) ./burnside.lhs
	$(TEX) ./burnside.lhs

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
	find $(PdfDir)/ -type f -name '*.sagetex.scmd' -delete
	find $(PdfDir)/ -type f -name '*.sagetex.sout' -delete
docs: cleanTex
	rm -rf $(OutputDir)
program: cleanTex
	rm -rf $(PdfDir)
