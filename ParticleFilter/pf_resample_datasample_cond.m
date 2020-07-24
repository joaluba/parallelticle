function sParticles_out=pf_resample_datasample_cond(sConf,sParticles_in,varargin)
% This is a function to execute a standard resampling 
% with effective particles condition.
% -----------------------------------------------------------------------
% Author: joanna.luberadzka@uni-oldenburg.de

    % Condition - number of effective particles
    N_eff=1/sum(sParticles_in.W.^2);
    if N_eff<  sConf.N_eff_tresh;
        sParticles_out.H= datasample(sParticles_in.H,sConf.K,2,'Weights',sParticles_in.W);

    else 
        sParticles_out.H=sParticles_in.H;
        
    end
        
% equalize weights
%sParticles_out.W=ones(1,sConf.K)./sConf.K;
sParticles_out.W=sParticles_in.W;   
    
end