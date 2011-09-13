.PHONY:all clean

all:facture.pdf exemple.pdf exemplesansTVA.pdf
	zip facture.zip facture.ins facture.dtx *pdf README makefile *.tex



%.cls:%.ins %.dtx
	@xelatex $*.ins
facture.pdf:facture.cls facture.dtx
	@xelatex facture.dtx
	@makeindex -s gglo.ist -o facture.gls facture.glo
	@xelatex facture.dtx
	@xelatex facture.dtx
	
%.pdf:%.tex facture.cls
	@xelatex $*	

clean:
	rm -f *out *aux *log *pdf *glo *zip *cls *ilg *idx *gls  *toc

