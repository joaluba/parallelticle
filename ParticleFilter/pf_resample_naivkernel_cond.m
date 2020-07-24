function sParticles_out=pf_resample_naivkernel_cond(sConf,sParticles_in,varargin)
% This is a function to execute a naiv-kernel resampling 
% with effective particles condition
% -----------------------------------------------------------------------
% Author: joanna.luberadzka@uni-oldenburg.de

% Condition - number of effective particles
N_eff=1/sum(sParticles_in.W.^2);
if N_eff< sConf.N_eff_tresh;
% compute expected value 
expval=sParticles_in.H*sParticles_in.W';
% compute variance
m_expval=repmat(expval,[1,sConf.K]);
var=((sParticles_in.H-m_expval).^2)*sParticles_in.W';
% form a diagonal covariance matrix
diag_cov=diag(var);
% sample from multivariate naive gaussian
sParticles_out.H = mvnrnd(expval,diag_cov,sConf.K)';
else
    sParticles_out.H=sParticles_in.H;
end
% equalize weights
sParticles_out.W=ones(1,sConf.K)./sConf.K;
end