Looking under rocks for beta.

_TODO_
* What channels are good for Parker?
* How do I correlate behavior, what file is that in?
* Compile FDAtool >compilefma;

_REMEMBER ME_
* fdatool
* http://fmatoolbox.sourceforge.net/
* http://chronux.org/chronux/images/chronux_data/manual.pdf
* http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2934871/
* use common avg across all 32 ch, subtract from all
* Iron man, May31, Run002

__Fix for Figure PDF__
    h=figure(1);
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])