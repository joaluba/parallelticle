function [T_o,winner_GT] = hidstat2obs_Poc_2 (T_s1_GT,T_s2_GT, sConfPF1,sConfPF2,Q,varargin)
% This is a function to generate an ARTIFICIAL
% observation sequence, not through a feature extraction from the 
% raw binaural singals, but directly from the hidden states, using 
% the assumed observation statistics for each voice and additionally
% some statistics of glimpse occurance. 
% The observation contains either glimpse from voice 1 , 
% glimpse from voice 2 or no glimpse at all. 

% observation has the same dimensionality as
% the state vector for each source
T_o=nan(sConfPF1.N,sConfPF1.D_y);
winner_GT=zeros(sConfPF1.N,1);
m_sigma1=repmat(sConfPF1.pdf_obsstat.sigma,1,sConfPF1.N)';
m_sigma2=repmat(sConfPF2.pdf_obsstat.sigma,1,sConfPF2.N)';
% Draw a sequence of iid uniformly distributed samples
if ~isempty(varargin)
z=varargin{1}; 
else
z=rand(1,sConfPF1.N);
end

% Fill the observation with glimpses - either from voice 1 or voice 2
idx_glimpsevoi1=(z<Q);
mu1=T_s1_GT(idx_glimpsevoi1,:);
T_o(idx_glimpsevoi1,:)=mu1+m_sigma1(idx_glimpsevoi1,:).*randn(size(mu1));
winner_GT(idx_glimpsevoi1)=1;
idx_glimpsevoi2=(z>1-Q);
mu2=T_s2_GT(idx_glimpsevoi2,:);
T_o(idx_glimpsevoi2,:)=mu2+m_sigma2(idx_glimpsevoi2,:).*randn(size(mu2));
winner_GT(idx_glimpsevoi2)=2;
% TO DO: Here I would like to have a better "Glimpse" model
% because i don't think the glimpses really switch like that
% independently... so something else would be better i guess





