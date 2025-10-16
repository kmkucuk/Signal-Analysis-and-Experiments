%%% This function is used in 'FitYourDistribution' function. It plots
%%% histogram of observed values and also draws lines of theoretical
%%% distributions.

function DurationHistogram(x,YMatrix) %%% x is the observed values of dominance durations
                                      %%% Y matrix contains theoretical
                                      %%% distribution values of both gamma
                                      %%% and lognormal distributions
x=sort(x);
bincount=20;                           %%% change bincount via this variable. Because it adjusts the length of x axis in HistogramFormatCode function.
xaxismax=5;                    %%% adjusts the maximum visible x-axis of histogram
[Pdfcounts, binCenters] = hist(x,bincount);       %%% second input is bin count

Pdfcounts=Pdfcounts/sum(Pdfcounts);
PdfHistogramValid(x,YMatrix);

assignin('base','counts',Pdfcounts);
assignin('base','binCenters',binCenters);

end
