
%%% This function can only be used with the .mat datasets of Bremen. It
%%% counts rejected epochs using the information inside these datasets. 
%%%
%%% x = participant code as in workspace variable name 
%%%
%%% y = condition marker. If it is y=3 then the code will run for trigger
%%% corrected exogenous data as well. 
%%%
%%%
%%% TriggerSweeplisten=the struct within which rejected and selected
%%% information about epochs are contained. 

function [epochinfo]=CountSelEp(x,y)

StabSize=size(x.TriggerSweeplisten.triggertab_stabil);

InsSize=size(x.TriggerSweeplisten.triggertab_instabil);

% unstable epochs with artifacts
InsEpochs=x.TriggerSweeplisten.triggertab_instabil(2:end,InsSize(1,2)-1); 

% stable epochs with artifacts
StabEpochs=x.TriggerSweeplisten.triggertab_stabil(2:end,StabSize(1,2)-1);




InsRejCell=strcmp('mit_A',InsEpochs);

StabRejCell=strcmp('mit_A',StabEpochs);




[Instable_Rejected,indxInst]=find(InsRejCell==1);

[Stable_Rejected,indxStab]=find(StabRejCell==1);



TrueInsEpoch=size(x.data.epochen_instabil,3);

TrueStabEpoch=size(x.data.epochen_stabil,3);



Instable_Rejected=Instable_Rejected.';

Stable_Rejected=Stable_Rejected.';


%% If you are using the clsArtDelete pipeline use this section
epochinfo={};
epochinfo(1,:)={TrueInsEpoch,length(Instable_Rejected),Instable_Rejected};
epochinfo(2,:)={TrueStabEpoch,length(Stable_Rejected),Stable_Rejected};
if y == 3
    TrigCorrSize=size(x.TriggerSweeplisten.triggertab_exo_trig_corr);
    % trig corrected unstable epochs with artifacts
    TrigCorrEpochs=x.TriggerSweeplisten.triggertab_exo_trig_corr(2:end,TrigCorrSize(1,2)-1);
    TrigCorrRejCell=strcmp('mit_A',TrigCorrEpochs);
    
    [TrigCorr_Rejected,indxTrigCorr]=find(TrigCorrRejCell==1);
    TrueTrigCorrEpoch=size(x.data.epochen_exo_trig_corr,3);
    TrigCorr_Rejected=TrigCorr_Rejected.';
    epochinfo(3,:)={TrueTrigCorrEpoch,length(TrigCorr_Rejected),TrigCorr_Rejected};
end

%% If you are using the script manually use this section
% 
% figure(1)
% 
% subplot(2,1,1)

% bar([length(indxInst);TrueInsEpoch])
% 
% fprintf('Total epochs for instable condition:    %d \n',TrueInsEpoch);
% 
% fprintf('Rejected epochs for instable condition: %d \n',length(Instable_Rejected));
% 
% % subplot(2,1,2)
% 
% fprintf('Total epochs for stable condition:    %d\n',TrueStabEpoch);
% 
% fprintf('Rejected epochs for stable condition: %d\n',length(Stable_Rejected));
% 
% assignin('base','Instable_Selected',Instable_Rejected);
% 
% assignin('base','Stable_Selected',Stable_Rejected);

% bar([length(indxStab);TrueStabEpoch])




