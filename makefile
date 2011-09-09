all:
	xelatex facture.ins
	xelatex facture.dtx
	xelatex exemple.tex
	xelatex exemplesanstva.tex
	zip facture.zip facture.ins facture.dtx *pdf

clean:
	rm -f *out *aux *log *pdf *glo *zip
