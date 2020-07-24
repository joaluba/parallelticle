function [q1, q2, winner]=pf_whichPF(sConfPF1,sConfPF2,T_o,s1_ESTold, s2_ESTold)
% This is a function which prepares the observation for both particle 
% filters based on the observation coming from mixture: T_o
% sConfPF1 & sConfPF2 - parameters (models) for both particle
%                       filters (voices)
% T_o                 - observation sequence
% s1_ESTold              - last state estimation for voice 1
% s1_ESTold              - last state estimation for voice 2
% q1,q2               - observations that will be forwarded to PF1 and PF2
%                        EDIT - that was mostly needed for the
%                        self-generating particle filter
% winner            - which particle filter will be responsible for the
%                         current glimpse
% -----------------------------------------------------------------------
% Author: joanna.luberadzka@uni-oldenburg.de

obs_tmp=T_o(sConfPF1.n,:)';

% ---------- IF obs_tmp is NOT a GLIMPSE ---------
if any(isnan(obs_tmp))>0
winner=nan;

q1=obs_tmp;
q2=obs_tmp;
% ---------- IF obs_tmp is a GLIMPSE ---------
else 

% AFTER THE 'BUG'
DELTA12= sConfPF1.pdf_obsstat.fun(sConfPF1,[s1_ESTold s2_ESTold],obs_tmp);
delta1=DELTA12(1);delta2=DELTA12(2);

if(delta1-delta2)>0
% PF1 wins
winner=1;
q1=obs_tmp;
q2=nan(sConfPF1.D_y,1);
elseif(delta1-delta2)<0
% PF2 wins
winner=2;
q1=nan(sConfPF1.D_y,1);
q2=obs_tmp;
else
q1=obs_tmp;
q2=obs_tmp;
winner=0;
% error('probabilities the same for both voices')
end






end
