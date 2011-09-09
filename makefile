.PHONY:all clean

facture.pdf:facture.ins facture.dtx
	@xelatex facture.ins
	@xelatex facture.dtx
	@makeindex -s gglo.ist -o facture.gls facture.glo
	@xelatex facture.dtx

	
%.pdf:%.tex
	@xelatex $*	
all:facture.pdf exemple.pdf exemplesanstva.pdf
	zip facture.zip facture.ins facture.dtx *pdf

clean:
	rm -f *out *aux *log *pdf *glo *zip *cls
