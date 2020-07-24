function sParticles_out=pf_resample_naivkernel(sConf,sParticles_in,varargin)
% This is a function to execute a naiv-kernel resampling 
% -----------------------------------------------------------------------
% Author: joanna.luberadzka@uni-oldenburg.de


% compute expected value 
expval=sParticles_in.H*sParticles_in.W';
% compute variance
m_expval=repmat(expval,[1,sConf.K]);
var=((sParticles_in.H-m_expval).^2)*sParticles_in.W';
% form a diagonal covariance matrix
diag_cov=diag(var);
% sample from multivariate naive gaussian
sParticles_out.H = mvnrnd(expval,diag_cov,sConf.K)';

% Check if the resampled value is in the range
% Limits of the possible values
v_A=sConf.pdf_sysdyn.range(:,1);m_A=repmat(v_A,1,sConf.K);
v_B=sConf.pdf_sysdyn.range(:,2);m_B=repmat(v_B,1,sConf.K);
Idx= (sParticles_out.H<m_A | sParticles_out.H>m_B);
% If not in the range - take old particle
sParticles_out.H(Idx)=sParticles_in.H(Idx);


% equalize weights
%sParticles_out.W=ones(1,sConf.K)./sConf.K;
sParticles_out.W=sParticles_in.W;
end