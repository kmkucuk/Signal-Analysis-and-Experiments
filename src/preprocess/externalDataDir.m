driveName={'F','E','D','G'};
for k = 1:length(driveName)
pathname=[driveName{k},':\Backups\Matlab Directory\2020_MSP_EEG_Scrpt-Data_Mert\2020_MSPAging_EEG_Mert\Data_MertVersions'];
    if isfolder(pathname)
        cd(pathname);
        disp(['Your data folder: ' pathname]);
        break
    end
end
