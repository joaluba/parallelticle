function sParticles_out=pf_resample_meanshift_cond(sConf,sParticles_in,observ,varargin)
% This is a function to execute a data-driven resampling 
% with effective particles condition.
% -----------------------------------------------------------------------
% Author: joanna.luberadzka@uni-oldenburg.de


% Condition - number of effective particles
N_eff=1/sum(sParticles_in.W.^2);
if N_eff< sConf.N_eff_tresh;
% for the current observation
% sample a state value according to 
% some defined distribution o ---> s
s_CANDIDATE = observ+sConf.pdf_obsstat.sigma.*randn(sConf.D_y,1);
% compute expectation
s_EST=sParticles_in.H*sParticles_in.W';
v_toshift=(s_CANDIDATE-s_EST);
% shift particles by the found value
sParticles_out.H=sParticles_in.H+repmat(v_toshift,[1,sConf.K]);
% resample from the shifted particles
sParticles_out.H= datasample(sParticles_out.H,sConf.K,2,'Weights',sParticles_in.W);
    
else
    sParticles_out.H=sParticles_in.H;
end
% equalize weights
%sParticles_out.W=ones(1,sConf.K)./sConf.K;
sParticles_out.W=sParticles_in.W;
end