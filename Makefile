LATEX = latex
BIBTEX = bibtex
L2H = latex2html
PDFLATEX = ps2pdf
DVIPS = dvips 
RM = /bin/rm -f 
SPELL = ispell

RERUN = "(There were undefined references|Rerun to get (cross-references|the bars) right)"
RERUNBIB = "No file.*\.bbl|Citation.*undefined" 

GOALS = Tesis.ps
DVIFILES = Tesis.dvi 

COPY = if test -r $*.toc; then cp $*.toc $*.toc.bak; fi

main: $(DVIFILES) 

spell: Introduccion.tex EstadoDelArte.tex Solucion.tex Resultados.tex
	$(SPELL) -T latin1 -d es Introduccion.tex
	$(SPELL) -T latin1 -d es EstadoDelArte.tex
	$(SPELL) -T latin1 -d es Solucion.tex
	$(SPELL) -T latin1 -d es Resultados.tex

all: $(GOALS) 

%.dvi: %.tex 
	$(COPY);$(LATEX) $<
	egrep -c $(RERUNBIB) $*.log && ($(BIBTEX) $*;$(COPY);$(LATEX) $<) ; true
	egrep $(RERUN) $*.log && ($(COPY);$(LATEX) $<) ; true
	egrep $(RERUN) $*.log && ($(COPY);$(LATEX) $<) ; true
	if ! cmp -s $*.toc $*.toc.bak; then $(LATEX) $< ; fi
	$(RM) $*.toc.bak
# Display relevant warnings
	egrep -i "(Reference|Citation).*undefined" $*.log ; true

%.ps: %.dvi
	dvips $< -o $@

%.pdf: %.ps
	$(PDFLATEX) $<

clean:
	rm -f *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg  \
	*.inx *.ps *.dvi *.pdf *.toc *.out



Tesis.dvi: Algorithms.tex  EstadoDelArte.tex  Introduccion.tex  Resultados.tex  Solucion.tex  Tesis.tex Thanks.tex Abstract.tex

