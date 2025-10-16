function FitYourDistribution(x,graphOrNot)

    rng('shuffle');
    
    format long
    
    if ~isvector(x)
        error('Input must be a vector')
    end
    
    %%% Setting Figure Name and X axis for distributions%%%
    %%% X Axis is based on the maximum value of the observed values,
    %%% otherwise distribution ends prematurely or extends unnecessaryly
    
    VarName=inputname(1);
    
        %%% Call distribution fitting functions
    
        [ExpectedProbabilityLog,Logdist]=LogFit(x);

        [ExpectedProbabilityGamma,Gammadist]=GammaFit(x);
        
        %%% Plot Theoretical and Observed Distributions %%%
        %%% Star plots are our observed data, while line is our ideal
        %%% lognormal distribution. Same logic applies to gamma
        %%% distribution
        YPlotmatrix=[ExpectedProbabilityLog,ExpectedProbabilityGamma];
        if graphOrNot==1
            figure('Name',VarName,'NumberTitle','off');                
            PdfHistogramValid(x,YPlotmatrix)
        else
            
        end
        
        %%% Chi Square Goodness of fit analyses
        %%% 
       [ChiTestParameters]=ChiSqTest(x,Gammadist,Logdist);
       
       fprintf('\n %s \n %f \n %s \n %f \n','ChiSqGamma',ChiTestParameters(1,:),'ChiSqLog',ChiTestParameters(2,:));
        
        
end
    