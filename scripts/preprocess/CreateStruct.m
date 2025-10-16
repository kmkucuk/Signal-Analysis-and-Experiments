
%%% you may notice sometimes parameter of for loops (e.g. i) is changed.
%%% This is because I created EEG part by part and wanted to match the row 
%%% within EEG variable.

lowestepoch={'sgo034_Kn','sgo064_Kn','sgo144_Kn'};


EEG(1).subject='sgo014_Kn';
EEG(2).subject='sgo024_Kn';
EEG(3).subject='sgo034_Kn';
EEG(4).subject='sgo044_Kn';
EEG(5).subject='sgo064_Kn';
EEG(6).subject='sgo084_Kn';
EEG(7).subject='sgo104_Kn';
EEG(8).subject='sgo124_Kn';
EEG(9).subject='sgo144_Kn';
EEG(10).subject='sgo154_Kn';
EEG(11).subject='sgo164_Kn';
EEG(12).subject='sgo214_Kn';
EEG(13).subject='sgo224_Kn';
EEG(14).subject='sgo234_Kn';
EEG(15).subject='sgo244_Kn';

% elderly instable endogenous data
EEG(1).data=sgo014_Kn.data.epochen_instabil;
EEG(2).data=sgo024_Kn.data.epochen_instabil;
EEG(3).data=sgo034_Kn.data.epochen_instabil;
EEG(4).data=sgo044_Kn.data.epochen_instabil;
EEG(5).data=sgo064_Kn.data.epochen_instabil;
EEG(6).data=sgo084_Kn.data.epochen_instabil;
EEG(7).data=sgo104_Kn.data.epochen_instabil;
EEG(8).data=sgo124_Kn.data.epochen_instabil;
EEG(9).data=sgo144_Kn.data.epochen_instabil;
EEG(10).data=sgo154_Kn.data.epochen_instabil;
EEG(11).data=sgo164_Kn.data.epochen_instabil;
EEG(12).data=sgo214_Kn.data.epochen_instabil;
EEG(13).data=sgo224_Kn.data.epochen_instabil;
EEG(14).data=sgo234_Kn.data.epochen_instabil;
EEG(15).data=sgo244_Kn.data.epochen_instabil;

% elderly endogenous stable data

EEG(47).data=A_RejectedData.data.epochen_stabil;
%%% Endogenous IDs
ElderSubjIDendo={'sgo014_Kn';'sgo024_Kn';'sgo034_Kn';'sgo044_Kn';'sgo064_Kn';'sgo084_Kn';...
            'sgo104_Kn';'sgo124_Kn';'sgo144_Kn';'sgo154_Kn';'sgo164_Kn';'sgo214_Kn';...
            'sgo224_Kn';'sgo234_Kn';'sgo244_Kn'};
        
%%% Exogenous Elderly IDSs
ElderSubjIDexo={'sgo013_Kn';'sgo023_Kn';'sgo033_Kn';'sgo043_Kn';'sgo063_Kn';'sgo083_Kn';...
            'sgo103_Kn';'sgo123_Kn';'sgo143_Kn';'sgo153_Kn';'sgo163_Kn';'sgo213_Kn';...
            'sgo223_Kn';'sgo233_Kn';'sgo243_Kn'};   

%%% Endogenous Young IDs

YSubjIDendo={'sgy014_Kn', 'sgy034_Kn', 'sgy044_Kn', 'sgy054_Kn',...
    'sgy064_Kn', 'sgy084_Kn', 'sgy094_Kn', 'sgy124_Kn', 'sgy154_Kn',...
    'sgy174_Kn', 'sgy254_Kn', 'sgy264_Kn', 'sgy274_Kn', 'sgy284_Kn', 'sgy294_Kn'};
        
secTimes=-3:.002:1.998;

secTimes(:,end)=[];

for i = 1:15
    
    i=i+75;
    EEG(i).srate=500;
    EEG(i).times=secTimes;
    EEG(i).condition='stable_endogenous';
    EEG(i).chaninfo={'F3';'F4';'C3';'C4';'P3';'P4';'T5';'T6';'O1';'O2';'leer';'leer';'WechsTrig';'Knopf';'ArtTrigStab';'EOG'};
    EEG(i).subject=YSubjIDendo{i-75};

    EEG(i).group='young';
    

end

