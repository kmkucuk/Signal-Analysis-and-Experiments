function [RmseValues]=FitYourDistribution(x,y)

    rng('shuffle');
    
    format long
    
    if ~isvector(x)
        error('Input must be a vector')
    end
    
    %%% Setting Figure Name and X axis for distributions%%%
    %%% X Axis is based on the maximum value of the observed values,
    %%% otherwise distribution ends prematurely or extends unnecessarily
    
    VarName=inputname(1);  
    emp_x_axis=sort(x).';
    
        %%% Call distribution fitting functions
    
        [ExpectedProbabilityLog,Logdist]=LogFit(x);

        [ExpectedProbabilityGamma,Gammadist]=GammaFit(x);
        
%         [ExpectedProbabilityNorm,Normdist]=NormFit(x,emp_x_axi    s);
        %%% Plot Theoretical and Observed Distributions %%%
        %%% Star plots are our observed data, while line is our ideal
        %%% lognormal distribution. Same logic applies to gamma
        %%% distribution 
        YPlotmatrix=[ExpectedProbabilityLog,ExpectedProbabilityGamma];
                assignin('base','Yplots',YPlotmatrix);
        if y==1
            figure('Name',VarName,'NumberTitle','off');                
            DurationHistogram(x,YPlotmatrix)
        else
            
        end
        
        %%% Chi Square Goodness of fit analyses  below
        %%% 
       [ChiTestParameters]=ChiSqTest(x,Gammadist,Logdist);
       
       fprintf('\n %s \n %f \n %s \n %f \n %s \n %f \n','ChiSqGamma',ChiTestParameters(1,:),'ChiSqLog',ChiTestParameters(2,:));
%         fprintf('\n %s \n %f \n ','ChiSqNorm',ChiTestParameters(3,:));
%         Plot for normal distribution is the line above
        

        assignin('base','Observed_X_Values',emp_x_axis);
        
%         RmseValues=[rmseLog;rmseGamma];
%         
        
        
       end
    