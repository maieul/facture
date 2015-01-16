.PHONY:all clean

all:facture.pdf exemple.pdf exemplesansTVA.pdf exemplesansremise.pdf
	rm -f ../facture.zip
	rm -rf facture
	mkdir facture
	ln *pdf *ins *dtx  *tex README makefile facture
	zip -r ../facture.zip facture



%.cls:%.ins %.dtx
	$(RM) $*.cls
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
	rm -rf facture

