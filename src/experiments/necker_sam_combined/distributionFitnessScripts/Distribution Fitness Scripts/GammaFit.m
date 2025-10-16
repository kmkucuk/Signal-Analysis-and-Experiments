function [ExpectedProbabilityGamma,Gammadist]=GammaFit(x)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Observational Gamma Distribution %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%% Creates a Probability Density Function from observed
        %%% variable. This transforms our raw frequency data into probabilistic
        %%% values that correspond to our observed data such as: 5 presses
        %%% happens %10 of the time. While raw data says 5 presses happened 4
        %%% times within our sample.
        
        Gammadist=fitdist(x,'Gamma');
        Scaleparam=Gammadist.a;
        Shapeparam=Gammadist.b; 
        %%% Y Axis for observed distribution
        
        obs_y_axis=gampdf(x,Scaleparam,Shapeparam);
        ExpectedProbabilityGamma=obs_y_axis;
        
        %%% Parameters of gamma distribution obtained from data.
        %%% mean and standard deviation
        
   
        
        assignin('base','GammaExpectedPDF',ExpectedProbabilityGamma);
end
        
        

