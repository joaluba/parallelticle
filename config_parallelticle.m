function [sConfPF1,sConfPF2] = config_PoC_2(datapath)
% This is a function that prepares the configuration
% structures containing parameters needed to 
% run the parallel particle filter scripts
% -----------------------------------------------------------------------
% Author: joanna.luberadzka@uni-oldenburg.de


% -------------- Common parameters for PF1 and PF2  ---------------
% names
sConfboth.condtag='demo_PPF';
sConfboth.savedir=[datapath,sConfboth.condtag];
% stepsize of data aquisition
sConfboth.step_ms=20;
% duration of the signal in ms
sConfboth.dur=2500;
% sampling frequency of particle filter
sConfboth.fs_pf=50;%Hz
% length of the state trajectory
sConfboth.N=length(0:sConfboth.step_ms:sConfboth.dur);
% number of particles
sConfboth.K=1000;
% state names and dimensionality
sConfboth.state_names={'F0','F1','F2','alpha'};
sConfboth.D_y=length(sConfboth.state_names);
% observation dimensionality
sConfboth.D_x=sConfboth.D_y;
% resampling
% sConfboth.resample.fun=@pf_resample_datasample;
% sConfboth.resample.fun=@pf_resample_naivkernel;
sConfboth.resample.fun=@pf_resample_meanshift;
% sConfboth.resample.fun=@pf_resample_combination;
% sConfboh.resample.fun=@(sConf,sParticles_in,varargin)sParticles_in;

% effective sample size used as a condition for doing/not doing resampling
% in some of the resampling techniques
sConfboth.N_eff_tresh=sConfboth.K/10;
% function to prepare the data for particle filtering
% in this case - glimpse association
sConfboth.getobs.fun=@pf_whichPF;
% Function for plotting result

% -------------- Parameters of PF1: ---------------
sConfPF1=sConfboth;
% initial distribution
sConfPF1.pdf_init.fun =@pf_init_all_uniform;
sConfPF1.pdf_init.range=[100 150;...
    300 700;...
    800 2200;...
    0 90];
% system dynamics
sConfPF1.pdf_sysdyn.fun=@pf_sysdyn_parallelticle;
sConfPF1.pdf_sysdyn.sigma=[1 5 10 0.25]';
sConfPF1.pdf_sysdyn.range=[100 300;...
    300 700;...
    800 2200;...
    -90 90];
% Observation statisitcs
sConfPF1.pdf_obsstat.fun=@pf_obsstat_parallelticle;
sConfPF1.pdf_obsstat.sigma=5*[1 5 10 0.25]';

% -------------- Parameters of PF2: ---------------
sConfPF2=sConfboth;
% initial distribution
sConfPF2.pdf_init.fun =@pf_init_all_uniform;
sConfPF2.pdf_init.range=[250 300;...
    300 700;...
    800 2200;...
    -90  0];
% system dynamics
sConfPF2.pdf_sysdyn.fun=@pf_sysdyn_parallelticle;
sConfPF2.pdf_sysdyn.sigma=[1 5 10 0.25]';
sConfPF2.pdf_sysdyn.range=[100 300;...
    300 700;...
    800 2200;...
    -90 90];
% Observation statisitcs
sConfPF2.pdf_obsstat.fun=@pf_obsstat_parallelticle;
sConfPF2.pdf_obsstat.sigma=5*[1 5 10 0.25]';

end

