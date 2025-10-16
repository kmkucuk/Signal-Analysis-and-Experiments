

function EEG=fftEEG(EEG,channels,conditions,datatype,timewindow)


times=EEG(1).times;

srate=EEG(1).srate;

if exist('timewindow','var')
    
    windowIndices=findIndices(times,timewindow);

    timewindow=windowIndices(1):windowIndices(2);
else
    timewindow=1:size(EEG(1).(datatype),1);
end

condCount=length(conditions);

fourrMeanData=[];

fourrData=[];


for i = 1:condCount
    
    pScalar=(conditions(i)-1)*15;      

        for pti = 1:15
            
            pIndx=pti+pScalar;
            
            fprintf('Processing participant: %s \ngroup: %s \ncondition: %s\n',EEG(pIndx).subject, EEG(pIndx).group,EEG(pIndx).condition);
            
            for ci = 1:length(channels)

                data=EEG(pIndx).(datatype)(timewindow,channels(ci));
                
                N=max(size(data)); % max indexes the times, because it has the largest length most of time. (16 channels, maybe 100 trials? But length milliseconds are usually much larger around 600>
                
                frex=findNyquistFreq(data,srate);
                
                transformation=fft(data)/N;
                
                fourrData(:,ci)=transformation.';
%%% uncomment below selections if you want to obtain FFT for averages of
%%% all channels.
%                 fourrMeanData=cat(2,fourrMeanData,transformation);                
% 
%                 fourrMeanData=mean(fourrMeanData,2);
            
            end
        
%         EEG(pIndx).fourrTransform=fourrMeanData.';
        
        EEG(pIndx).fourrTransform=fourrData;
        
        EEG(pIndx).fourrFreqs=frex;
        
%         fourrMeanData=[];
        
        fourrData=[];
        end
        
end
            
            

            
            
