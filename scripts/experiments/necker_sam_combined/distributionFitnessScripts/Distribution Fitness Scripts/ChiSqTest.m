function [ChiSquareParameters]=ChiSqTest(x,Gammadist,Logdist,Normdist)

%%% Chi Square goodness of fit for both lognormal and gamma distributions
[LogHypothesis,LogSignificance,LogStats]=chi2gof(x,'CDF',Logdist); 
[GammaHypothesis,GammaSignificance,GammaStats]=chi2gof(x,'CDF',Gammadist);
% [NormHypothesis,NormSignificance,NormStats]=chi2gof(x,'CDF',Normdist);

%%% Chi Square test statistics and more parameters

ChiStatsGamma=GammaStats.chi2stat;
ChiStatsLog=LogStats.chi2stat;
% ChiStatsNorm=NormStats.chi2stat;

%%% Grouping parameters for saving into workspace

ChiGamma=[GammaHypothesis,GammaSignificance,ChiStatsGamma];

ChiLog=[LogHypothesis,LogSignificance,ChiStatsLog];

% ChiNorm=[NormHypothesis,NormSignificance,ChiStatsNorm];


ChiSquareParameters=[ChiGamma;ChiLog];

%%% Save Parameters into base workspace

assignin('base','ChiTestParameters',ChiSquareParameters);
end