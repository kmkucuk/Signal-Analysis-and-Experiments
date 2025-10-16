% aging_connectivity_permutation 


% 
% ALLEEG([5 19 40 54])=[];
% % remove channels for laplacian and connectivity
% for k = 1:length(ALLEEG) %[1:20,41:60]
% ALLEEG(k).data = ALLEEG(k).data(:,[1 2 3 4 5 6 9 10],:);
% end
% 
% for k = 1:length(ALLEEG)
% ALLEEG(k).chaninfo = ALLEEG(k).chaninfo([1 2 3 4 5 6 9 10]);
% end
% 
% for i = 1:length(ALLEEG)
%     ALLEEG(i).data = permute(ALLEEG(i).data,[2,1,3]);
% end


srate = ALLEEG(1).srate;
times = ALLEEG(1).times;
% load in data
for k = [1:13, 27:39]

disp(['Processing participant: ' ALLEEG(k).subject]);
csd = ALLEEG(k).data;
csd2 = ALLEEG(k+13).data;
% useful variables for later...
npnts = size(csd,2);
ntrials = size(csd,3);

npntsbase = size(csd2,2);
ntrialsbase = size(csd2,3);

% note: too many time points, use post-analysis temporal downsampling!
times2save = 0:1/srate:1;
times2saveidx = dsearchn(times',times2save');

times2savebase = -1:1/srate:0;
times2saveidxbase = dsearchn(times',times2savebase');
% specify frequency range
min_freq = 4;
max_freq = 7.5;
num_frex = 8;

% define frequency and range
frex = linspace(min_freq,max_freq,num_frex);


% parameters for complex Morlet wavelets
wavtime  = -2:1/srate:2;
half_wav = (length(wavtime)-1)/2;
nCycles  = repmat(6,1,num_frex);%[repmat(3,1,6) repmat(6,1,8) repmat(7,1,12) repmat(9,1,28) repmat(12,1,41)];

% FFT parameters
nWave = length(wavtime);
nData = npnts*ntrials;
nConv = nWave+nData-1;

wholeData(k).convFreqs = frex;
wholeData(k).convCycles = nCycles;
wholeData(k).times = times2save;

wholeData(k+13).convFreqs = frex;
wholeData(k+13).convCycles = nCycles;
wholeData(k+13).times = times2savebase;
nDatabase = npntsbase*ntrialsbase;
nConvbase = nWave+nDatabase-1;

% and create wavelets
cmwX = zeros(num_frex,nConv);
cmwXbase = zeros(num_frex,nConvbase);
for fi=1:num_frex
    s       = nCycles(fi)/(2*pi*frex(fi)); % frequency-normalized width of Gaussian
    cmw      = exp(1i*2*pi*frex(fi).*wavtime) .* exp( (-wavtime.^2) ./ (2*s^2) );
    tempX     = fft(cmw,nConv);
    tempXbase     = fft(cmw,nConvbase);
    cmwX(fi,:) = tempX ./ max(tempX);
    cmwXbase(fi,:) = tempXbase ./ max(tempXbase);
end

tempX = [];
tempXbase = [];
wavtime = [];
%% run convolution to extract tf power. NOTE: You need to keep all the single-trial power

% spectra of data
dataX1 = nan(8,nConv);
dataX2 = nan(8,nConvbase);
for chani = 1:8
    fprintf('\nProcessing channel: %f', chani);    

    dataX1(chani,:)       = fft( reshape(csd(chani,:,:),1,[]) ,nConv); 
    dataX2(chani,:)       = fft( reshape(csd2(chani,:,:),1,[]) ,nConvbase);
end
csd = [];
csd2 = [];


% initialize output time-frequency data
% notice that here we save all trials (+8 channels)
tf = zeros(8,num_frex,nData);
tfbase = zeros(8,num_frex,nDatabase);
 fprintf('\Convolution starts'); 
for ci = 1:8
    for fi=1:num_frex

        % run convolution
        as1 = ifft(cmwX(fi,:).*dataX1(ci,:));
        as1 = as1(half_wav+1:end-half_wav);
%         as1 = reshape(as1,npnts,ntrials);

        % power on all trials from channel "1"
%         tf(ci,fi,:,:) = abs(as1(times2saveidx,:)).^2; % (note: no averaging b/c keeping all single-trial data!)
        tf(ci,fi,:) = as1;
        
        
        % run convolution
        as2 = ifft(cmwXbase(fi,:).*dataX2(ci,:));
        as2 = as2(half_wav+1:end-half_wav);
%         as2 = reshape(as2,npntsbase,ntrialsbase);

        % power on all trials from channel "2"
%         tfbase(ci,fi,:,:) = abs(as2(times2saveidxbase,:)).^2;
        tfbase(ci,fi,:) = as2;
        
   end
end
 fprintf('\Convolution finished'); 
% clear ram
cmw = [];
dataX1 = [];
dataX2 = [];
cmwX = [];
cmwXbase = [];
as1 = [];
as2 = [];
%% phase difference estimation 
phase_data = nan(size(tf));
phase_database = nan(size(tfbase));
% size(phase_data)
times      = size(phase_data,3);
timesbase  = size(phase_database,3);
freqCounts = size(phase_data,2);

for chani = 1:8
    
    for freqi = 1:freqCounts
        phase_data(chani,freqi,:) = angle(tf(chani,freqi,:));
        phase_database (chani,freqi,:) = angle(tfbase(chani,freqi,:));
    end

end
% clear ram
tf = [];
tfbase = [];
%% Actual pair indexes for checking the channels on the actual dataset
synchChannels = 1:8; 
chanVecIndex = 1:8;
pairIndex    = nchoosek(chanVecIndex,2);
%% Pair indexes for computing. Because actual indices can be [34 120], this makes convolution problematic and scripts fill in those missing channels.
% therefore, we use dummy channels indices within these functions instead of actual channels indices. 
pairIndexForComputing = 1:length(synchChannels);
pairIndexForComputing = nchoosek(pairIndexForComputing,2);

pairCount    = size(pairIndex,1);


phase_diff_pli = nan(freqCounts,times,pairCount);
phase_diff_plibase = nan(freqCounts,timesbase,pairCount);
 fprintf('\Phase connectivity starts'); 
for diffIndx = 1:pairCount
    
    phase_diff_pli(:,:,diffIndx) = sign(imag(exp(1i * (phase_data(pairIndexForComputing(diffIndx,1),:,:) - phase_data(pairIndexForComputing(diffIndx,2),:,:)))));
    
    phase_diff_plibase(:,:,diffIndx) = sign(imag(exp(1i * (phase_database(pairIndexForComputing(diffIndx,1),:,:) - phase_database(pairIndexForComputing(diffIndx,2),:,:)))));
end
fprintf('\Phase connectivity finished'); 
% clear ram
phase_data = [];
phase_database = [];


diffdata = nan(28,num_frex,2500,ntrials);
diffdatabase = nan(28,num_frex,2500,ntrialsbase);
for chpairs = 1:28
     diffdata(chpairs,:,:,:)=reshape(phase_diff_pli(:,:,chpairs),num_frex,2500,ntrials);
     diffdatabase(chpairs,:,:,:)=reshape(phase_diff_plibase(:,:,chpairs),num_frex,2500,ntrialsbase);
end
diffdata = diffdata(:,:,times2saveidx,:);
diffdatabase = diffdatabase(:,:,times2saveidxbase,:);

averaged_diff_data = mean(diffdata,4);
averaged_diff_database = mean(diffdatabase,4);

cd('F:\Backups\Matlab Directory\2020_MSP_EEG_Scrpt-Data_Mert\2020_MSPAging_EEG_Mert\Data_MertVersions\Data_Processed\ConnectivityICON\connectivityParticipantData')

save([ALLEEG(k).subject '_' ALLEEG(k).condition '.mat'],'averaged_diff_data');
save([ALLEEG(k+13).subject '_' ALLEEG(k+13).condition '.mat'],'averaged_diff_database');

wholeData(k).avg_pli = averaged_diff_data;
wholeData(k+13).avg_pli = averaged_diff_database;

% clear ram
averaged_diff_data = [];
averaged_diff_database = [];
phase_diff_pli = [];
phase_diff_plibase = [];
% for convenience, compute the difference in power between the two channels
diffmap = squeeze(mean(diffdata,4)) - squeeze(mean(diffdatabase,4));

%% some visualization of the raw power data
% 
% clim = [0 2];
% xlim = [0 1]; % for plotting
% 
% figure(2), clf
% subplot(221)
% imagesc(times2save,frex,squeeze(mean( tf(1,:,:,:),4 )))
% set(gca,'clim',clim,'ydir','n','xlim',xlim)
% xlabel('Time (ms)'), ylabel('Frequency (Hz)')
% title('Reversal ')
% 
% subplot(222)
% xlim = [-1 0]; % for plotting
% imagesc(times2savebase,frex,squeeze(mean( tfbase(2,:,:,:),4 )))
% set(gca,'clim',clim,'ydir','n','xlim',xlim)
% xlabel('Time (ms)'), ylabel('Frequency (Hz)')
% title('Baseline ')
% 
% subplot(223)
% xlim = [-1 0]+1; % for plotting
% imagesc(times2save,frex,squeeze(diffmap(1,:,:)))
% set(gca,'clim',[-1 1],'ydir','n','xlim',xlim)
% xlabel('Time (ms)'), ylabel('Frequency (Hz)')
% title('Difference: Reversal-Baseline ')

%% statistics via permutation testing

% p-value
pval = 0.05;
pvaldenominator = 1;% * 2 * 3; % 28 chans, 2 groups, 3 windows

% convert p-value to Z value
% if you don't have the stats toolbox, set zval=1.6449;
zval = abs(norminv(pval/pvaldenominator));

% number of permutations
n_permutes = 1000;

% initialize null hypothesis maps
permmaps = zeros(28,n_permutes,num_frex,length(times2saveidx));

iterationcount = 0;
firstcount = 0;
for ci = 1:28
% for convenience, tf power maps are concatenated
%   in this matrix, trials 1:ntrials are from channel "1" 
%   and trials ntrials+1:end are from channel "2"
tf3d = cat(3,squeeze(diffdata(ci,:,:,:)),squeeze(diffdatabase(ci,:,:,:)));    
    % generate maps under the null hypothesis
    for permi = 1:n_permutes
        iterationcount=iterationcount+1;
        % randomize trials, which also randomly assigns trials to channels
        randorder = randperm(size(tf3d,3));
        temp_tf3d = tf3d(:,:,randorder);

        % compute the "difference" map
        % what is the difference under the null hypothesis?
        permmaps(ci,permi,:,:) = squeeze( mean(temp_tf3d(:,:,1:ntrials),3) - mean(temp_tf3d(:,:,ntrials+1:end),3) );   
        if mod(permi,100)==0
            if firstcount == 0 
                firstcount = 1;
                f = waitbar(iterationcount/(n_permutes*28),['Permutation progress: %' num2str(100*(iterationcount/(n_permutes*28)))]);
            else
                waitbar(iterationcount/(n_permutes*28),f,['Permutation progress: %' num2str(100*(iterationcount/(n_permutes*28)))]);
            end
%             disp(['Permutation progress: %' num2str(100*(iterationcount/(n_permutes*28)))]);            
            
        end
    end
end 
close(f);
cd('F:\Backups\Matlab Directory\2020_MSP_EEG_Scrpt-Data_Mert\2020_MSPAging_EEG_Mert\Data_MertVersions\Data_Processed\ConnectivityICON\connectivityParticipantData')

save([ALLEEG(k).subject '_permutation.mat'],'permmaps');

%% compute z- and p-values based on normalized distance to H0 distributions (per pixel)

% compute mean and standard deviation maps
mean_h0 = nan(28,num_frex,length(times2save));
std_h0 = nan(28,num_frex,length(times2save));
for ci = 1:28
    mean_h0(ci,:,:) = squeeze(mean(permmaps(ci,:,:,:),2));
    std_h0(ci,:,:)  = squeeze(std(permmaps(ci,:,:,:),[],2));
 
end
clim=[0 1];
% now threshold real data...
% first Z-score
zmap = (diffmap-mean_h0) ./ std_h0;   
save([ALLEEG(k).subject '_zmap.mat'],'zmap');
wholeData(k).pli_zmap = zmap;
% threshold image at p-value, by setting subthreshold values to 0
zmap(abs(zmap)<zval) = 0;


% %%% now some plotting...
% figure(3), clf
% for ploti = 1:28
%     subplot(7,4,ploti)
%     imagesc(times2save,frex,squeeze(zmap(ploti,:,:)))
%     xlabel('Time (ms)'), ylabel('Frequency (Hz)')
%     title('z-map, thresholded')
%     set(gca,'clim',[-2 2],'xlim',xlim,'ydir','normal')
% end

% 
% 
% figure(3), clf
% 
% subplot(221)
% imagesc(times2save,frex,squeeze(diffmap(ci,:,:)));
% xlabel('Time (ms)'), ylabel('Frequency (Hz)')
% set(gca,'clim',[-mean(clim) mean(clim)],'xlim',xlim,'ydir','nor')
% title('TF map of real power values')
% 
% subplot(222)
% imagesc(times2save,frex,squeeze(zmap(ci,:,:)));
% xlabel('Time (ms)'), ylabel('Frequency (Hz)')
% set(gca,'clim',[-10 10],'xlim',xlim,'ydir','no')
% title('Thresholded TF map of Z-values')
% 
% subplot(223)
% imagesc(times2save,frex,squeeze(diffmap(ci,:,:)));
% hold on
% contour(times2save,frex,logical(squeeze(zmap(ci,:,:))),1,'linecolor','k');
% xlabel('Time (ms)'), ylabel('Frequency (Hz)')
% set(gca,'clim',[-mean(clim) mean(clim)],'xlim',xlim,'ydir','norm')
% title('Power values and outlined significance regions')

%% 
% 
%    VIDEO: Cluster correction
%
%
%

%%% Note: This code requires having run the code from the previous video.

% The goal is to create a distribution of cluster sizes
%  expected under the null hypothesis.


% initialize matrices for cluster-based correction
max_cluster_sizes = zeros(28,n_permutes);

for ci=1:28
    % loop through permutations
    for permi = 1:n_permutes

        % take each permutation map, and transform to Z
        threshimg = squeeze(permmaps(ci,permi,:,:));
        threshimg = (threshimg-squeeze(mean_h0(ci,:,:)))./squeeze(std_h0(ci,:,:));

        % threshold image at p-value
        threshimg(abs(threshimg)<zval) = 0;


        % find clusters (need image processing toolbox for this!)
        islands = bwconncomp(threshimg);
        if numel(islands.PixelIdxList)>0

            % count sizes of clusters
            tempclustsizes = cellfun(@length,islands.PixelIdxList);

            % store size of biggest cluster
            max_cluster_sizes(ci,permi) = max(tempclustsizes); 
        end
    end
end

%% show histograph of maximum cluster sizes
% 
% figure(4), clf
% cluster_thresh=nan(1,28);
% for ploti = 1:28
%     subplot(7,4,ploti)
%     histogram(max_cluster_sizes(ploti,:),20)
%     xlabel('Maximum cluster sizes'), ylabel('Number of observations')
%     title('Expected cluster sizes under the null hypothesis')
% 
% 
%     % find cluster threshold (need image processing toolbox for this!)
%     % based on p-value and null hypothesis distribution
%     cluster_thresh(1,ploti) = prctile(max_cluster_sizes(ploti,:),100-(100*pval));
% end

%% plots with multiple comparisons corrections

% now find clusters in the real thresholded zmap
% if they are "too small" set them to zero
backup_zmap = zmap;
clustercorrected_zmap = zmap;
for ci = 1:28
    islands(ci) = bwconncomp(squeeze(clustercorrected_zmap(ci,:,:)));
    for i=1:islands(ci).NumObjects
        % if real clusters are too small, remove them by setting to zero!
        if numel(islands(ci).PixelIdxList{i})<cluster_thresh(1,ci)
            backup_zmap = squeeze(clustercorrected_zmap(ci,:,:));
            backup_zmap(islands(ci).PixelIdxList{i}) = 0;
            clustercorrected_zmap(ci,:,:)=backup_zmap;
        end
    end
end
save([ALLEEG(k).subject '_zmap_clustercorrected.mat'],'clustercorrected_zmap');
wholeData(k).pli_zmap_corrected = clustercorrected_zmap;
%% plot
ci=4;
% figure(5)
% for ploti = 1:28
%     subplot(7,4,ploti)
%     imagesc(times2save,frex,squeeze(clustercorrected_zmap(ploti,:,:)))
%     xlabel('Time (ms)'), ylabel('Frequency (Hz)')
%     title('z-map, thresholded')
%     set(gca,'clim',[-2 2],'xlim',xlim,'ydir','normal')
% end
kmap = squeeze(zmap(ci,:,:));
kdiff = squeeze(diffmap(ci,:,:));

% % plot tresholded results
% figure(6), clf
% subplot(221)
% imagesc(times2save,frex,kdiff)
% xlabel('Time (ms)'), ylabel('Frequency (Hz)')
% title('TF power, no thresholding') 
% set(gca,'clim',[-mean(clim) mean(clim)],'xlim',xlim,'ydir','norm')
% 
% subplot(222)
% imagesc(times2save,frex,kdiff)
% hold on
% contour(times2save,frex,logical(kmap),1,'linecolor','k')
% xlabel('Time (ms)'), ylabel('Frequency (Hz)')
% title('TF power with contour')
% set(gca,'clim',[-mean(clim) mean(clim)],'xlim',xlim,'ydir','norm')
% 
% subplot(223)
% imagesc(times2save,frex,kmap)
% xlabel('Time (ms)'), ylabel('Frequency (Hz)')
% title('z-map, thresholded')
% set(gca,'clim',[-2 2],'xlim',xlim,'ydir','normal')


end