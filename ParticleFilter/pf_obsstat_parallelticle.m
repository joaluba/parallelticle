function W=pf_obsstat_PoC_2(sConf,sParticles,obs_tmp)
% Observation statistics for the case when all dimensions of the
% observation belong either to source 1, source 2 or are nans.
% sParticles - either struct with particles and weights or 
%              just a state value for which the likelihood has 
%              to be evaluated 
% -----------------------------------------------------------------------
% Author: joanna.luberadzka@uni-oldenburg.de

% check if sParticles is a struct or just one state value
if isstruct(sParticles)
H=sParticles.H;
% W=sParticles.W;
[D_y Kk]=size(H);
else
H=sParticles;
[D_y Kk]=size(H);
% W=nan(1,Kk);
end

m_obs_tmp=repmat(obs_tmp,1,Kk);
m_sigma=repmat(sConf.pdf_obsstat.sigma,1,Kk);
m_gauss_prob=gauss_probability(m_obs_tmp,H,m_sigma,1);
W=sum(log(m_gauss_prob));

factor=1;
while abs(min(W)-max(W))>1440
    factor=factor/10;
    W=W*factor;
end

% Correct for overflow, otherwise - numerical error!
    if max(W)<-740            
        bl=-740-min(W);
    elseif  max(W)>700
        bl=700-max(W);
    else
        bl=0;
    end
    
    W=W+bl;
    W=exp(W);
    
end

