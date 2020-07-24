function sParticles_out=pf_resample_datasample(sConf,sParticles_in,varargin)
    % Always resample
    sParticles_out.H= datasample(sParticles_in.H,sConf.K,2,'Weights',sParticles_in.W);
% equalize weights
%sParticles_out.W=ones(1,sConf.K)./sConf.K;
sParticles_out.W=sParticles_in.W;
    
end