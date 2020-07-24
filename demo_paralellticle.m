clc
clear all
close all

% This is a script that presents the parallel particle filtering
% for tracking two competing events. In this example the observation space
% is the same as the state space. The system receives noisy data every once
% in a while (probability of occurance Q). It associates the incoming
% observations with one of two events and sequentially estimates the state
% of both events. 

% Context: This is a 'proof of concept' system which I developed as a 
% preparation for solving a real task of tracking one of two competing 
% voices. In the real task, in contrast to the example provided here, the 
% observation space (features extracted from the binaural signal)
% is very different than the state space (voice parameters). In order to
% solve the task the relation between the observation and state space still 
% has to be found (the likelihood of observed acoustic feature
% given a hypothetical state).


% Author: Joanna Luberadzka (joanna.luberadzka@uni-oldenburg.de)


% add this path 
datapath=[pwd,'/'];
addpath(genpath(datapath))

% generate configuration structures for two particle filters
[sConfPF1,sConfPF2] = config_parallelticle(datapath);


%% -------- Generate hidden (ground truth) states: --------
% voice 1
T_s1_GT = gen_hidstat_parallelticle(sConfPF1);
% voice 2
T_s2_GT = gen_hidstat_parallelticle(sConfPF2);

%% -------- Generate artificial glimpsed observation from hidden states: --------
% probability of glimpse occuring
Q=0.3; 
[T_o, winner_GT]= hidstat2obs_parallelticle(T_s1_GT,T_s2_GT,sConfPF1,sConfPF2,Q);

%% -------- Parallel Particle Filtering : --------

bplot=1; % should particle filtering be plotted while running?
         % What will be plotted? --> You will be able to observe how the
         % particles of the 'parallelticle' system evolve over time.
         
bstore=0; % should tracking results be stored in a directory 

sResult=run_multiple_PF(sConfPF1,sConfPF2,T_o,bplot,bstore,['run_' datestr(now,'ddmmmyy_HHMMSS')]);
% store observation
sResult.T_o=T_o;
sResult.winner_GT=winner_GT;
% store ground truth sequences
sResult.T_s1_GT=T_s1_GT;sResult.T_s2_GT=T_s2_GT;


%% -------- Plot ground truth and estimation : --------
plottracks_parallelticle(sResult);









