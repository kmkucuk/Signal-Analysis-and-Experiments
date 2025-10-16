





trialMatrix_chn1 = zeros(40,1301);
trialMatrix_chn2 = zeros(40,1301);
phaseData = zeros(2,1301,40);

buttonVector = zeros(40,1);
RTvector = zeros(40,1);
trimmedWave = waveData.wavelet;
trimmedTime = 0:.002:2.60;
trimmedWave(1:700)=[];

for k = 1:40
    
    first_ch_jitter = randi([5 20]);
    buttonVector(k,1) = randi([501 700]); 
    RTvector(k,1) = (buttonVector(k,1))*2;
    randamp = randi([1 6]);
    trialMatrix_chn1(k,:) = [trimmedWave(first_ch_jitter:end) trimmedWave(end-first_ch_jitter+2:end)] *randamp;
    scnd_ch_jitter = randi([5 20]);
    randamp = randi([1 3]);
    trialMatrix_chn2(k,:) = [trimmedWave(scnd_ch_jitter:end) trimmedWave(end-scnd_ch_jitter+2:end)]*randamp ;
    
    phaseData(1,:,k) = angle(trialMatrix_chn1(k,:));
    phaseData(2,:,k) = angle(trialMatrix_chn2(k,:));
end
plotwindow=1:750;
figure(1)
shiftlines=0;
% RTvector=RTvector/1000;
for k = 1:6
    plot(trimmedTime(plotwindow), (trialMatrix_chn1(k,plotwindow))-shiftlines,'r','linewidth',1);
    hold on
    plot(trimmedTime(plotwindow), (trialMatrix_chn2(k,plotwindow))-shiftlines,'b','linewidth',1);
    plot([RTvector(k) RTvector(k)], [0 .7]-shiftlines,'k','linewidth',3);
    shiftlines=shiftlines-4;
    
end
set(gca,'XColor', 'none','YColor','none')

buttonTrials_ch1=zeros(40,751);
buttonTrials_ch2=zeros(40,751);
phaseData_button = zeros(2,751,40);
figure(2)
for k = 1:40
    
    buttonTrials_ch1(k,:) = trialMatrix_chn1(k,buttonVector(k)-500:buttonVector(k)+250);
    buttonTrials_ch2(k,:) = trialMatrix_chn2(k,buttonVector(k)-500:buttonVector(k)+250);
    
    phaseData_button(1,:,k) = angle(trialMatrix_chn1(k,buttonVector(k)-500:buttonVector(k)+250));
    phaseData_button(2,:,k) = angle(trialMatrix_chn2(k,buttonVector(k)-500:buttonVector(k)+250));
end
buttonTime = -1:.002:.500;
figure(2)
shiftlines=0;
for k = 1:6
    plot(buttonTime, (buttonTrials_ch1(k,:))-shiftlines,'r','linewidth',1);
    hold on
    plot(buttonTime, (buttonTrials_ch2(k,:))-shiftlines,'b','linewidth',1);
    plot([0 0], [0 .7]-shiftlines,'k','linewidth',3);
    shiftlines=shiftlines-4;
    
end
set(gca,'XColor', 'none','YColor','none')

%% POWER ANALYSIS

avgCh1_time = mean(abs(trialMatrix_chn1),1);
avgCh2_time = mean(abs(trialMatrix_chn2),1);

avgCh1_but = mean(abs(buttonTrials_ch1),1);
avgCh2_but = mean(abs(buttonTrials_ch2),1);
figure(3)
subplot(1,2,1)
plot(trimmedTime(plotwindow),avgCh1_time(plotwindow),'r')
hold on
plot(trimmedTime(plotwindow),avgCh2_time(plotwindow),'b')
set(gca,'ylim', [0 4]) 
ylabel('Alpha Power abs(\muV)'); % 'Theta Amplitude (\muV)'
xlabel('Time (seconds)');
title('Stimulus Locked Average')
plot([.2 .2], [0 1],'k:','linewidth',3);
subplot(1,2,2)
plot(buttonTime,avgCh1_but,'r')
hold on
plot(buttonTime,avgCh2_but,'b')
ylabel('Alpha Power abs(\muV)');
xlabel('Time (seconds)');
title('Response Locked Average')
set(gca,'ylim', [0 4]) 
plot([0 0], [0 1],'k:','linewidth',3);

%% SYNCHRONY ANALYSIS

% collect "eulerized" phase angle differences
phase_synchronization = squeeze(exp(1i*( phaseData(2,:,:)-phaseData(1,:,:) )));
phase_synchronization_button = squeeze(exp(1i*( phaseData_button(2,:,:)-phaseData_button(1,:,:) )));

% compute ISPC and PLI (and average over trials!)
time_synch = abs(mean(phase_synchronization,2));
button_synch = abs(mean(phase_synchronization_button,2));



figure(4)
subplot(1,2,1)
plot(trimmedTime(plotwindow),time_synch(plotwindow),'r')
hold on
set(gca,'ylim', [0 .7]) 
ylabel('Alpha Phase Synchrony'); % 'Theta Amplitude (\muV)'
xlabel('Time (seconds)');
title('Time Locked to Reversal')
plot([.2 .2], [0 .1],'k:','linewidth',3);
subplot(1,2,2)
plot(buttonTime,button_synch,'r')
hold on
ylabel('Alpha Phase Synchrony');
xlabel('Time (seconds)');
title('Time Locked to Motor Response')
set(gca,'ylim', [0 .7]) 
plot([0 0], [0 .1],'k:','linewidth',3);

% pli(fi,:)  = abs(mean(sign(imag(cdd)),3));

%     
% h = polar([0 angle(mean_complex_vector)],[0 phase_synchronization]);
% set(h,'linewidth',6,'color','g')
%     plot(trimmedTime(plotwindow), phaseData(1,plotwindow,k));
%     hold on
%     plot(trimmedTime(plotwindow), phaseData(1,plotwindow,k));