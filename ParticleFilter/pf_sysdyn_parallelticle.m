function H_pred=pf_sysdyn_PoC_2(sConf,Particles_old,Particles_oldold)
% This is the function in which  the system dynamics pdf is defined, it is 
% used in the state prediction step (for each particle a new, predicted
% value is sampled from a distribution).
% -----------------------------------------------------------------------
% Author: joanna.luberadzka@uni-oldenburg.de

% check if sParticles is a struct or just one state value
if isstruct(Particles_old)
H_old=Particles_old.H;
H_oldold=Particles_oldold.H;
[D_y Kk]=size(H_old);
else
H_old=Particles_old;
H_oldold=Particles_oldold;
[D_y Kk]=size(H_old);
end

% difference between last two particle sets
H_diff=H_old-H_oldold;

% 1) Limits of how far it can get from a previous value
m_sigma=repmat(sConf.pdf_sysdyn.sigma,1,Kk);
% If difference bigger then allowed step - set difference to zero 
idx_interptoobig=(abs(H_diff)>5*m_sigma);
H_diff(idx_interptoobig)=0;
% extrapolated value
H_tilde=H_old+H_diff;

% 2) Limits of the possible values
v_A=sConf.pdf_sysdyn.range(:,1);
m_A=repmat(v_A,1,Kk);
v_B=sConf.pdf_sysdyn.range(:,2);
m_B=repmat(v_B,1,Kk);
% If not in possible range - set to previous
idx_overalltoobig= (H_tilde<m_A | H_tilde>m_B);
% If extrapolated outside limits - take previous particle
H_tilde(idx_overalltoobig)=H_old(idx_overalltoobig);


% Add system noise (here Gaussian)
H_pred=H_tilde+m_sigma.*randn(D_y,Kk);

% Check if the sampled value is in the range
% Here think about the circular statistics or some truncated gaussian
% instead of this condition?
Idx=true(D_y,Kk);
Z=false(D_y,Kk);
bla=0;
while any(any(Idx~=Z,1)) && bla<1000
Idx= (H_pred<m_A | H_pred>m_B | H_pred<H_tilde-5*m_sigma | H_pred>H_tilde+5*m_sigma);
% If not in the range - take new sample
H_pred(Idx)=H_tilde(Idx)+m_sigma(Idx).*randn(size(H_pred(Idx)));
end