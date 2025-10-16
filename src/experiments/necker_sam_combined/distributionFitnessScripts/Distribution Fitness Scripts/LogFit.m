function [ExpectedProbabilityLog,Logdist]=LogFit(x)

%%% Observed and Expected Probability variables registers Y axis of both
%%% observed and randomly created lognormal distributions. They can be
%%% indexed for plotting use.

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Observational Lognormal Distribution %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%% Creates a Probability Density Function from observed
        %%% variable. This transforms our raw frequency data into probabilistic
        %%% values that correspond to our observed data such as: 5 presses
        %%% happens %10 of the time. While raw data says 5 presses happened 4
        %%% times within our sample.
        
        Logdist=fitdist(x,'Lognormal');
        LogMean=Logdist.mu;
        LogSD=Logdist.sigma;   
        %%% Y Axis for observed distribution
        
        expected_y_axis=lognpdf(x,LogMean,LogSD);
        ExpectedProbabilityLog=expected_y_axis;
        
        %%% Parameters of lognormal distribution obtained from data.
        %%% mean and standard deviation
        
 
        

        assignin('base','LogExpectedPDF',ExpectedProbabilityLog);
end
        
        

