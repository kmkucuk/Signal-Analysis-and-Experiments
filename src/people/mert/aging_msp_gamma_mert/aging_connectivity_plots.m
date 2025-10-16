%% ITPC PLOTS 
channels = [2 4 6 8];
condition = [1 3];
clim = [0 .3];
freqs = [13 48];
timewin = [-.5 1];

figure(1);
convolutionPlotSameFigure(convStats_itc,channels,condition,'itpc','chaninfo',timewin,clim,freqs)

figure(2);
convolutionPlotSameFigure(convStats_itclap,channels,condition,'itpc_lap','chaninfo',timewin,clim,freqs)


%% Parieto occipital inter hemispheric connectivity

phemi = 23;
ohemi = 28;

interhemi_posterior = [phemi ohemi];% p4o1 p3o2];

freqs = [1 48];

% plot wpli laplacian connectivity
figure(1)
clim = [0 2];
set(gcf,'NumberTitle','off','Name','WPLI');

ispcPlotSameFigure(convStats_plipercent,interhemi_posterior,[1 3],'pli_percent','chaninfo',[-.5 1],clim,freqs);


%% Contralateral connectivity

FtoO = [7 12];

FtoC = [3 8];

CtoP = [16 19];

CtoO = [18 21];

PtoO = [25 26];


% PtoO = [24 25 26 27];

contra_posterior = [FtoO CtoO];

freqs = [1 18];

% plot wpli laplacian connectivity
figure(1)
clim = [-1 2];
set(gcf,'NumberTitle','off','Name','WPLI ONLY');
ispcPlotSameFigure(convStats_plipercent,contra_posterior,[1 3],'pli_percent','chaninfo',[-.5 1],clim,freqs);
% figure(2)
% clim = [0 .7];
% set(gcf,'NumberTitle','off','Name','Laplacian');
% ispcPlotSameFigure(convStats_lap,contra_posterior,[1 3],'avg_phase_diff_lap','chaninfo',[-.5 1],clim,freqs);
%% long range fronto-parietal / fronto-occipital connectivity


f4o2 = 13;
f4p4 = 11;
f3p3 = 4;
f3o1 = 6;
long_frontoposterior = [f4p4 f3p3 f4o2 f3o1];% p4o1 p3o2];

freqs = [1 14];

% plot wpli laplacian connectivity
figure(1)
clim = [-1 2];
set(gcf,'NumberTitle','off','Name','WPLI');
ispcPlotSameFigure(convStats_plipercent,long_frontoposterior,[1 3],'pli_percent','chaninfo',[-.5 1],clim,freqs);
% figure(2)
% clim = [0 .7];
% set(gcf,'NumberTitle','off','Name','Laplacian');
% ispcPlotSameFigure(convStats_lap,long_frontoposterior,[1 3],'avg_phase_diff_lap','chaninfo',[-.5 1],clim,freqs);
%% long range fronto-parietal / fronto-occipital connectivity


f4o2 = 13;
f4p4 = 11;
f3p3 = 4;
f3o1 = 6;
long_frontoposterior = [f4p4 f3p3 f4o2 f3o1];% p4o1 p3o2];

freqs = [28 48];

% plot wpli laplacian connectivity
figure(1)
clim = [-1 1];
set(gcf,'NumberTitle','off','Name','WPLI');
ispcPlotSameFigure(convStats,long_frontoposterior,[1 3],'pli_percent','chaninfo',[-.5 1],clim,freqs);
%% long & short range centra-cortical connectivity

centracorticalRight = [20 22];
centracorticalLeft = [15 17];

freqs = [4 7.5];
conditions = [1 3];
% plot wpli connectivity
figure(1)
clim = [-1 2];
set(gcf,'NumberTitle','off','Name','WPLI-Right');
ispcPlotSameFigure(convStats_plipercent,centracorticalRight,conditions,'pli_percent','chaninfo',[-.5 1],clim,freqs);

figure(2)
clim = [-1 2];
set(gcf,'NumberTitle','off','Name','WPLI-Left');
ispcPlotSameFigure(convStats_plipercent,centracorticalLeft,conditions,'pli_percent','chaninfo',[-.5 1],clim,freqs);

%% step-wise shortrange anterior posterior connectivity

stepRight = [9 20 27];
stepLeft = [2 15 24];

freqs = [4 7.5];
conditions = [1 3];
% plot wpli laplacian connectivity
figure(1)
clim = [-1 2];
set(gcf,'NumberTitle','off','Name','WPLI-Right');
ispcPlotSameFigure(convStats_plipercent,stepRight,conditions,'pli_percent','chaninfo',[-.5 1],clim,freqs);

figure(2)
clim = [-1 2];
set(gcf,'NumberTitle','off','Name','WPLI-Left');
ispcPlotSameFigure(convStats_plipercent,stepLeft,conditions,'pli_percent','chaninfo',[-.5 1],clim,freqs);
%% same hemisphere pairs
fhemi = 1;
chemi = 14;
phemi = 23;
ohemi = 28;

sameelectrode = [fhemi chemi phemi ohemi];

freqs = [3.5 7.5];
clim = [-1 2];
% standard phase clustering
figure(1)
set(gcf,'NumberTitle','off','Name','WPLI');
ispcPlotSameFigure(convStats_plipercent,sameelectrode,[1 3],'pli_percent','chaninfo',[-.5 1],clim,freqs);
% 
% figure(2)
% clim = [0 .7];
% set(gcf,'NumberTitle','off','Name','Laplacian');
% ispcPlotSameFigure(convStats_lap,sameelectrode,[1 3],'avg_phase_diff_lap','chaninfo',[-.5 1],clim,freqs);
