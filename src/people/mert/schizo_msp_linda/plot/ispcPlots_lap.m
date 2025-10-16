%% ISPC pair indices
load('F:\Backups\Matlab Directory\2021_LindaSchizo_ReviseGraphs\data\grandAverage\ispc_ga_stim_lap.mat');


stylename='MultiLinda';
sOption= hgexport('readstyle',stylename);
sOption.Format='tiff';
 
%% ENDOGENOUS
figure(1)

cd('F:\Backups\Matlab Directory\2021_LindaSchizo_ReviseGraphs\figures')
hgexport(gcf,'deltaTheta_endo.tiff',sOption);
%% ITPC


figure(1)
set(gcf,'NumberTitle','off','Name','Standard ITC');

convolutionPlotSameFigure(itpc,[1 2 3 4 5 6 7 8],[2],'itpc','chaninfo',[-500 1000],[0 .4],[1 48]);
title('voltage itc')

figure(2)
set(gcf,'NumberTitle','off','Name','Laplacian ITC');

convolutionPlotSameFigure(itpc_lap,[1 2 3 4 5 6 7 8],[2],'itpc_lap','chaninfo',[-500 1000],[0 .4],[1 48]);


%% short range
%% same hemisphere pairs
fhemi = 1;
chemi = 14;
phemi = 23;
ohemi = 28;

sameelectrode = [fhemi chemi phemi ohemi];

freqs = [28 48];
clim = [0 .7];
% standard phase clustering
figure(1)
set(gcf,'NumberTitle','off','Name','Standard Phase');

ispcPlotSameFigure(phasediff_s_lap,sameelectrode,[1 2],'avg_phase_diff_lap','chaninfo',[-500 1000],clim,freqs);


% standard laplacian 
figure(2)
clim = [0 .3];
set(gcf,'NumberTitle','off','Name','Standard Phase + Laplacian');

ispcPlotSameFigure(phasediff_pli_lap,sameelectrode,[1 2],'avg_phase_diff_pli_lap','chaninfo',[-500 1000],clim,freqs);

% Preliminary results 
%
% 1-4 Hz 
% control + patient F4-F4 smeared (standard), negligable difference wpli
% control P3-P4 500 to 750 ms (wpli+ standard), less and smeared in patient
% std: control O1-O2 post-stim smeread, patient 500 to 750 less and smeared
% wpli: patient O1-O2 750 ms, none in control 
%
% 4-8 Hz
% std: control F3-F4 750 ms + smeared, patient 0-200 ms way less than control
% wpli: control F3-F4 750 ms, patient 460 ms and less than control
%
% wpli: patient C3-C4, 250 to 650 ms, smeared and less in control, prestim
% control not in patient
% std: no apparent differences
%
% std: control O1-O2 200 ms, none in patient
% wpli: control O1-O2 750 to 1000 ms, less so in patient
% 
% 8-14 Hz
% std: control F3-F4 500 to 100 14 hz, none in patient
% wpli: control F3-F4 0 to 200 ms 10 Hz, 0 to 50 ms in patient (way less)
% 
% wpli: control C3-C4 200 ms 500 ms, less so in patient
% std: control C3-C4 0 to 200 ms, less so in patient
%
% wpli: control P3-P4 0 to 200 ms, 750 ms; less so in patient (750 to
% 1000ms) 
% 
% 14-28 Hz
% *std: control F3-F4 all epoch, high synch, same in patient with less synch
% wpli: no apparent differences,
%
% std: control C3-C4 smeared, same in patient with less synch
% 
% std: control O1-O2 200ms + 500 to 750 ms, patient 750 to 1000 ms with
% less synch
% wpli: control O1-O2 200ms, 500-700 ms; not apparent in patient. 
%
% 28-48 Hz
% std: control F3-F4 >.5 synch throughout, same with less synch in patient
% wpli: control F3-F4 no large diffs, bursts across time points, less so in
% patient. 
%
% std: control C3-C4, smeared synch, same for patient.
% wpli: patient C3-C4 50 ms, contro bursts across time points; no apparent
% diffs
%
% std: control O1-O2 smeared synch, patient 200 to 500 ms high synch +
% smeared as controls
%


%% short range connectivity- ipsilateral

fcleft = 2;
fcright = 9;

cpleft = 15;
cpright = 20;

poleft = 24;
poright = 27;

samehemi_short = [fcleft fcright cpleft cpright poleft poright];
freqs = [28 48];
clim = [0 .5];
% standard phase clustering
figure(1)
set(gcf,'NumberTitle','off','Name','Standard Phase');

ispcPlotSameFigure(phasediff_s_lap,samehemi_short,[1 2],'avg_phase_diff_lap','chaninfo',[-500 1000],clim,freqs);


% standard laplacian 
figure(2)
clim = [0 .3];
set(gcf,'NumberTitle','off','Name','Standard Phase + Laplacian');

ispcPlotSameFigure(phasediff_pli_lap,samehemi_short,[1 2],'avg_phase_diff_pli_lap','chaninfo',[-500 1000],clim,freqs);

% Preliminary findings
% 1-4 Hz
% control C3-P3 500 to 700 ms, none in patient
% control P3-O1 250 to 750 ms, less in patient.
% wpli also revealed the same for P4-O2. 
%
% 4-8 Hz 
% control P4-O2 200 to 500 ms,none in patient
% wpli shows similar results 
%
% 8-14 Hz 
% control P4-O2 500 to 1000 ms, none in patient
% control C4-P4 0 to 200 / 500 to 750 ms-wpli (also in standard), none in patient. 
% control F4-C4 prestimulus (wpli+standard), none in patient
%
% 14-28 Hz
% patient P4-O2 200 to 500 ms (wpli+standard), none in control
% control C4-P4 200 to 500 ms (wpli), none in paatient. 
%
% 28-48 Hz 
% control + patient F4-C4 smeared (standard)
% patient C4-P4 0 to 200 / 750 ms (wpli), 4-5 bursts in control
% patient P4-O2 750 ms (wpli+standard), none in control (very small at 220
% ms) 

%% short range connectivity - contralateral

f3c4 = 3;
f4c3 = 8;
c3p4 = 16;
c4p3 = 19; 
p3o2 = 25;
p4o1 = 26;

contrhemi_short = [f3c4 f4c3 c3p4 c4p3 p3o2 p4o1];

freqs = [18 48];
clim = [0 .5];
% standard phase clustering
figure(1)
set(gcf,'NumberTitle','off','Name','Standard Phase');

ispcPlotSameFigure(phasediff_s_lap,contrhemi_short,[1 2],'avg_phase_diff_lap','chaninfo',[-500 1000],clim,freqs);


% standard laplacian 
figure(2)
clim = [0 .4];
set(gcf,'NumberTitle','off','Name','WPLI + Laplacian');

ispcPlotSameFigure(phasediff_pli_lap,contrhemi_short,[1 2],'avg_phase_diff_pli_lap','chaninfo',[-500 1000],clim,freqs);

% Preliminary findings
%
% 1-8 Hz
% control p3-o2 250 to 1000 ms high delta synch, smeared synch in patients.
% control p4-o1 200 to 1000 ms high delta synch, way less in patients. 
%
% 8-14 Hz 
% control p4-o1 smeared synch, no synch for patients. 
% 
% 14-28 Hz
% control p4-o1 smeared synch, only at 28 for patients
%
% 28-48 Hz
% control+patient p4-o1,p3-o1 smeared, p4-o1 seems more in patient. 
% control f3-c4 seem more compared to patient 37-48Hz. 

%% long range connectivity (f-p, c-o) - ipsilateral 

foleft = 6;
foright = 13;
coleft = 17;
coright = 22;

samehemi_long = [foleft foright coleft coright];

freqs = [1 4];
clim = [0 .5];
% standard phase clustering
figure(1)
set(gcf,'NumberTitle','off','Name','Standard Phase');

ispcPlotSameFigure(phasediff_s_lap,samehemi_long,[1 2],'avg_phase_diff_lap','chaninfo',[-500 1000],clim,freqs);


% standard laplacian 
% figure(2)
% set(gcf,'NumberTitle','off','Name','Weighted Phase + Laplacian');
% 
% ispcPlotSameFigure(phasediff_pli_lap,samehemi_long,[1 2],'avg_phase_diff_pli_lap','chaninfo',[-500 1000],clim,freqs);
% Preliminary observations
%
% standard laplacian: 
% • F4-O2 healthy, 0 to 500 ms, 6 to 14 hz synchrony (even before
% stimulus)   
% • F4-O2 patient, 0 to 250 ms, 28-37 Hz synchrony,
% some more pre-stimulus but not as large
% • F4-O2 heatlhy, 200 to 400 ms, 14-20 Hz synchrony, 
% • F3-O1 patient, 0 to 200 ms, 14-20 Hz 
% • F4-O2 patient, -500 to 0 ms, 14-20 Hz
%
% • F4-O2 patient+healthy, pre+post stim, 8-14 Hz synchrony. This was not
% apparent at F3-O1 for healthy, but it was for patients. 
%
% • F4-O2 healthy, 0 to 500 ms, 6-8 Hz, 
% • F4-O2 patient, (-500 to 0 ms, 5-8 Hz), (200 to 750 ms, 6-8 Hz)
% • F3-O1 patient, (0 to 200 ms, 4-6 Hz), (200 to 750 ms, 5-8 Hz) 
%
% • F4-O2 healthy, (200 to 750 ms, 1-4 Hz, high synch), nothing in patient
% • F3-O1 patient, (750 ms, 3 Hz), nothing in healthy. 
%
% wpli laplacian: nothing apparent
% 
%% long range connectivity (f-p, c-o) - contralateral

f3o2 = 7;
f4o1 = 12;
c3o2 = 18;
c4o1 = 21;

contrhemi_long = [f3o2 f4o1 c3o2 c4o1];


freqs = [4 14];
clim = [0 .5];
% standard phase clustering
figure(1)
set(gcf,'NumberTitle','off','Name','Standard Phase');

ispcPlotSameFigure(phasediff_s_lap,contrhemi_long,[1 2],'avg_phase_diff_lap','chaninfo',[-500 1000],clim,freqs);


% standard laplacian 
figure(2)
set(gcf,'NumberTitle','off','Name','Standard Phase + Laplacian');

ispcPlotSameFigure(phasediff_pli,contrhemi_long,[1 2],'avg_phase_diff_pli','chaninfo',[-500 1000],clim,freqs);

% Preliminary observations (theta) 
% standard-laplacian: healthy f4 o1 seems a little connected at .5 scale,
% no reds though.
% wpli-laplacian: no apparent connectivity at .5 scale. 
%
% wpli: no apparent connectivty exceeding .25/.3 

%% WPLI figures
% figure(3)
% % pli 
% set(gcf,'NumberTitle','off','Name','wPLI');
% 
% ispcPlotSameFigure(gaDiffPli,samehemi_short,[1 2],'avg_phase_diff_pli','chaninfo',[-500 1000],clim,freqs);
% 
% % pli laplacian
% figure(4)
% set(gcf,'NumberTitle','off','Name','wPLI + Laplacian');
% 
% ispcPlotSameFigure(gaDiffPli_lap,samehemi_short,[1 2],'avg_phase_diff_pli_lap','chaninfo',[-500 1000],clim,freqs);


