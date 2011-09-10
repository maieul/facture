.PHONY:all clean

%.cls:%.ins %.dtx
	@xelatex $*.ins
facture.pdf:facture.cls facture.dtx
	@xelatex facture.dtx
	@makeindex -s gglo.ist -o facture.gls facture.glo
	@xelatex facture.dtx
	@xelatex facture.dtx
	
%.pdf:%.tex facture.cls
	@xelatex $*	
all:facture.pdf exemple.pdf exemplesanstva.pdf
	zip facture.zip facture.ins facture.dtx *pdf

clean:
	rm -f *out *aux *log *pdf *glo *zip *cls *ilg *idx *gls  *toc
