function sParticles_out=pf_resample_meanshift(sConf,sParticles_in,observ,varargin)
% This is a function to execute data-driven resampling. 
% -----------------------------------------------------------------------
% Author: joanna.luberadzka@uni-oldenburg.de

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