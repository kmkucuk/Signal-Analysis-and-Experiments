function woAdata=deleteArtifacts(x,y,z) %%% x = participant name as in variable name in workspace, 
                                %%% y = 1 or 2 [1=instabil epochs, 2=stabil epochs], 
                                %%% z = rejected epoch vector e.g. [1,2,4] 
PartVariable=x;
for i = 1:length(z)
    
    if y == 1 
    
        if i == 1
            PartVariable.data.epochen_instabil(:,:,z(i))=[];
            fprintf('Unstable epoch %d is deleted \n', z(i));            
        else 
            PartVariable.data.epochen_instabil(:,:,z(i)-i+1)=[];
            fprintf('Unstable epoch %d is deleted \n', z(i)-i+1);
        end
               
        
    elseif y==2
        
        if i == 1
            PartVariable.data.epochen_stabil(:,:,z(i))=[];
            fprintf('Stable epoch %d is deleted \n', z(i));            
        else 
            PartVariable.data.epochen_stabil(:,:,z(i)-i+1)=[];
            fprintf('Stable epoch %d is deleted \n', z(i)-i+1);
            
        end
        
     elseif y==3
        
        if i == 1
            PartVariable.data.epochen_exo_trig_corr(:,:,z(i))=[];
            fprintf('Trigger corrected epoch %d is deleted \n', z(i));            
        else 
            PartVariable.data.epochen_exo_trig_corr(:,:,z(i)-i+1)=[];
            fprintf('Trigger corrected %d is deleted \n', z(i)-i+1);
            
        end
        
        
        
    end

    
% uncomment below if you are using this manually
% assignin('base','A_RejectedData',PartVariable);
    
    
end

if y == 1
    
    woAdata=PartVariable.data.epochen_instabil;

elseif y == 2
    
    woAdata=PartVariable.data.epochen_stabil;

elseif y == 3
    
    woAdata=PartVariable.data.epochen_exo_trig_corr;

end

end
