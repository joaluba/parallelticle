function T = gen_hidstat_PoC_2(sConfPF)
% This is a function to generate state trajectories given the
% state transition model. Uses function run_ParticleFilter.
% INPUT: 
% sConf - struct containing parameters of the particle filter
% OUTPUT: 
% T - state trajectory
% ------------------------------------------------------------------------
% Author: joanna.luberadzka@uni-oldenburg.de

% Draw just one particle sequence 
sConfPF.K=1;
% Functions to skip the weight update step 
sConfPF.pdf_obsstat.fun=@(sConf,Particles,s_input)Particles.W;
sConfPF.getobs.fun=@(sConf)nan;
sConfPF.resample.fun=@(sConfPF,Particles_temp,q)Particles_temp;
% generate trajectories:
sResult=run_ParticleFilter(sConfPF,0,0);
T=sResult.T_s_EST;
end




