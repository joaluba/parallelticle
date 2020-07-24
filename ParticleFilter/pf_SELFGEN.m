function [q1, q2, winner]=pf_SELFGEN(sConfPF1,sConfPF2,T_o,s1_ESTold, s1_ESToldold, s2_ESTold, s2_ESToldold)
% This is a function which prepares the observation for both particle 
% filters based on the observation coming from mixture: T_o
% sConfPF1 & sConfPF2 - parameters (models) for both particle
%                       filters (voices)
% T_o                 - observation sequence
% s1_EST              - last state estimation for voice 1
% s1_EST              - last state estimation for voice 2
% q1,q2               - observations that will be forwarded to PF1 and PF2 

obs_tmp=T_o(sConfPF1.n,:)';
zeta1=pf_sysdyn_PoC_2(sConfPF1,s1_ESTold,s1_ESToldold);
zeta2=pf_sysdyn_PoC_2(sConfPF2,s2_ESTold,s2_ESToldold);

% ---------- IF obs_tmp is NOT a GLIMPSE ---------
if any(isnan(obs_tmp))>0
winner=0;

% self-generated glimpses
q1=zeta1+sConfPF1.pdf_obsstat.sigma.*randn(sConfPF1.D_y,1);
q2=zeta2+sConfPF2.pdf_obsstat.sigma.*randn(sConfPF1.D_y,1);

% ---------- IF obs_tmp is a GLIMPSE ---------
else 

delta1=log(sConfPF1.pdf_obsstat.fun(sConfPF1,s1_ESTold,obs_tmp));
delta2=log(sConfPF2.pdf_obsstat.fun(sConfPF2,s2_ESTold,obs_tmp));

% 1st STRATEGY - WINNER TAKES ALL 

if(delta1-delta2)>0
% PF1 wins
winner=1;
q1=obs_tmp;
q2=zeta2+sConfPF2.pdf_obsstat.sigma.*randn(sConfPF1.D_y,1);
elseif(delta1-delta2)<0
% PF2 wins
winner=2;
q1=zeta1+sConfPF1.pdf_obsstat.sigma.*randn(sConfPF2.D_y,1);
q2=obs_tmp;
else
q1=obs_tmp;
q2=obs_tmp;
winner=0;
% error('probabilities the same for both voices')
end


% Depending on the quality measure - repellent behavior
Quality=abs(delta1-delta2);




end
