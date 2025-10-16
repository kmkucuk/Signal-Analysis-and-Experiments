function [ExpectedProbabilityNorm,Normdist]=NormFit(x,emp_x_axis)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Observational Gamma Distribution %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%% Creates a Probability Density Function from observed
        %%% variable. This transforms our raw frequency data into probabilistic
        %%% values that correspond to our observed data such as: 5 presses
        %%% happens %10 of the time. While raw data says 5 presses happened 4
        %%% times within our sample.
        
        Normdist=fitdist(x,'Normal');
        %%% Y Axis for observed distribution
        
        obs_y_axis=pdf(Normdist,emp_x_axis);
        ExpectedProbabilityNorm=obs_y_axis;
        
        
        assignin('base','NormExpectedPDF',ExpectedProbabilityNorm);
end
        
        

