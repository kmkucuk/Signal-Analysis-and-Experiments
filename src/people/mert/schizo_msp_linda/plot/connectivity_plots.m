cd('F:\Backups\Matlab Directory\2021_LindaSchizo_ReviseGraphs\data\grandAverage');
load('schizo_connectivity_percepts.mat');
%% Decibel Modulation
channels = [1 2 3 4 5 6 7 8];

freqs = [1 12];

% plot vertical percept ITC - healthy
figure(1)
clim = [-1 1];
set(gcf,'NumberTitle','off','Name','vertical percept ITC - healthy');

convolutionPlotSameFigure(conv2,channels,[1],'ersp','chaninfo',[-500 1000],clim,freqs);

% plot vertıcal percept ITC - patient
figure(2)
set(gcf,'NumberTitle','off','Name','vertical percept ITC - patient');

convolutionPlotSameFigure(conv2,channels,[3],'ersp','chaninfo',[-500 1000],clim,freqs);

% plot horizontal percept ITC - healthy 
figure(3)
set(gcf,'NumberTitle','off','Name','horizontal percept ITC - healthy ');

convolutionPlotSameFigure(conv2,channels,[2],'ersp','chaninfo',[-500 1000],clim,freqs);

% plot horizontal percept ITC - patient
figure(4)
set(gcf,'NumberTitle','off','Name','horizontal percept ITC - patient');

convolutionPlotSameFigure(conv2,channels,[4],'ersp','chaninfo',[-500 1000],clim,freqs);
%% Decibel Modulation PERCEPT DIFFERENCE
channels = [1 2 3 4 5 6 7 8];

freqs = [1 12];

% plot vertical percept ITC - healthy
figure(1)
clim = [-1 1];
set(gcf,'NumberTitle','off','Name','vertical percept ITC - healthy');

convolutionPlotSameFigure(conv2,channels,[5],'ersp','chaninfo',[-500 1000],clim,freqs);

% plot vertıcal percept ITC - patient
figure(2)
set(gcf,'NumberTitle','off','Name','vertical percept ITC - patient');

convolutionPlotSameFigure(conv2,channels,[6],'ersp','chaninfo',[-500 1000],clim,freqs);

%% Inter trial Coherence

channels = [1 2 3 4 5 6 7 8];

freqs = [13 28];

% plot vertical percept ITC - healthy
figure(10)
clim = [0 .35];
set(gcf,'NumberTitle','off','Name','lap vertical percept ITC - healthy');

convolutionPlotSameFigure(itpc_lap,channels,[1],'itpc_lap','chaninfo',[-500 750],clim,freqs);

% plot vertıcal percept ITC - patient
figure(2)
set(gcf,'NumberTitle','off','Name','vertical percept ITC - patient');

convolutionPlotSameFigure(itpc_lap,channels,[2],'itpc_lap','chaninfo',[-500 750],clim,freqs);

% plot horizontal percept ITC - healthy 
figure(3)
set(gcf,'NumberTitle','off','Name','horizontal percept ITC - healthy ');

convolutionPlotSameFigure(itpc_lap,channels,[2],'itpc_lap','chaninfo',[-500 1000],clim,freqs);

% plot horizontal percept ITC - patient
figure(4)
set(gcf,'NumberTitle','off','Name','horizontal percept ITC - patient');

convolutionPlotSameFigure(itpc_lap,channels,[5],'itpc_lap','chaninfo',[-500 1000],clim,freqs);

%% non laplacian

% plot vertical percept ITC - healthy
figure(1)
clim = [0 .4];
freqs = [13 48];
set(gcf,'NumberTitle','off','Name','std vertical percept ITC - healthy');

convolutionPlotSameFigure(itpc,channels,[1],'itpc','chaninfo',[-500 1000],clim,freqs);

% plot vertıcal percept ITC - patient
figure(2)
set(gcf,'NumberTitle','off','Name','vertical percept ITC - patient');

convolutionPlotSameFigure(itpc,channels,[4],'itpc','chaninfo',[-500 1000],clim,freqs);

% plot horizontal percept ITC - healthy 
figure(3)
set(gcf,'NumberTitle','off','Name','horizontal percept ITC - healthy ');

convolutionPlotSameFigure(itpc,channels,[2],'itpc','chaninfo',[-500 1000],clim,freqs);

% plot horizontal percept ITC - patient
figure(4)
set(gcf,'NumberTitle','off','Name','horizontal percept ITC - patient');

convolutionPlotSameFigure(itpc,channels,[5],'itpc','chaninfo',[-500 1000],clim,freqs);
%% Parieto occipital inter hemispheric connectivity

phemi = 23;
ohemi = 28;
p3o2 = 25;
p4o1 = 26;

interhemi_posterior = [phemi ohemi];% p4o1 p3o2];

freqs = [1 48];

% plot wpli laplacian connectivity
figure(1)
clim = [0 25];
set(gcf,'NumberTitle','off','Name','WPLI + Laplacian');

ispcPlotSameFigure(convStats,interhemi_posterior,[1 3],'pli_lap_change','chaninfo',[-200 1000],clim,freqs);


%% Contralateral Parieto-occipital connectivity


p4o1 = [26 27];

contra_posterior = [p4o1];% p4o1 p3o2];

freqs = [1 48];

% plot wpli laplacian connectivity
figure(1)
clim = [0 25];
set(gcf,'NumberTitle','off','Name','WPLI + Laplacian');
ispcPlotSameFigure(convStats,contra_posterior,[1 3],'pli_lap_change','chaninfo',[-200 1000],clim,freqs);


%% long range fronto-parietal / fronto-occipital connectivity


f4o2 = 13;
f4p4 = 11;
long_frontoposterior = [f4p4 f4o2];% p4o1 p3o2];

freqs = [1 12];

% plot wpli laplacian connectivity
figure(1)
clim = [0 25];
set(gcf,'NumberTitle','off','Name','WPLI + Laplacian');
ispcPlotSameFigure(convStats,long_frontoposterior,[1 3],'pli_lap_change','chaninfo',[-200 1000],clim,freqs);
%% long & short range fronto-cortical connectivity
f4c4 = 9;
f4p4 = 11;
f4o2 = 13;

f3c3 = 2;
f3p3 = 4;
f3o1 = 6;
frontoCorticalright = [f4c4 f4p4 f4o2];
frontoCorticalleft = [f3c3 f3p3 f3o1];

freqs = [1 48];

% plot wpli laplacian connectivity
figure(1)
clim = [0 25];
set(gcf,'NumberTitle','off','Name','WPLI + Laplacian');
ispcPlotSameFigure(convStats,frontoCorticalright,[1 3],'pli_lap_change','chaninfo',[-700 1000],clim,freqs);

figure(2)
clim = [0 25];
set(gcf,'NumberTitle','off','Name','WPLI + Laplacian');
ispcPlotSameFigure(convStats,frontoCorticalleft,[1 3],'pli_lap_change','chaninfo',[-700 1000],clim,freqs);


%% Topographical ITC with max values

% load('F:\Backups\Matlab Directory\2021_LindaSchizo_ReviseGraphs\data\processed\ispc_lap_linda_percepts_stim.mat')

% eeglab
clim=[0 25];
timewin = [0 750];
%% delta
figure(1)
mert_topoplot_schizo(wholeData,[5 6],2,'itpcChange',clim,'max',{'con','pat'},20)
%% theta
figure(2)
mert_topoplot_schizo(wholeData,[5 6],5.5,'itpcChange',clim,'max',{'con','pat'},20)
%% alpha
figure(3)
mert_topoplot_schizo(wholeData,[5 6],10,'itpcChange',clim,'max',{'con','pat'},20)
%% gamma
figure(4)
mert_topoplot_schizo(wholeData,[5 6],40,'itpcChange',clim,'max',{'con','pat'},20)

