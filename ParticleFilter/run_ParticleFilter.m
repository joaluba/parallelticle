% This is a function run a particle filter and save/plot the results
%
% ------------------ INPUT: -----------------
% sConfPF      - parameters of the PF
% b_saveresult - boolean indicating if you want to save results
% b_plot       - boolean indicating if you want to plot results
% ------------------ OUTPUT: -----------------
% sResult                   - data structure with following fields:
% sResult.H                 - matrix containing evolution of the particles 
%                             for PF1 and PF2
% sResult.W                 - matrix containing evolution of the weights 
%                             for PF1 and PF2
% sResult.q                 - matrix containing input data that 
%                             each PF receives
% sResult.T_s_EST           - matrix containing evolution of the expected
%                             value of the state for voice 1 and 2
%
% ------------------ USAGE: -----------------
% my_sResult=run_ParticleFilter(sConf,0,0)
% my_sResult=run_ParticleFilter(sConf,1,1,'runname')
% --------------------------------------------------------
% Author: joanna.luberadzka@uni-oldenburg.de


function sResult=run_ParticleFilter(sConfPF,b_saveresult,b_plot,varargin)

% there might be an extra tag (string)
% for the current run of particle filter
if nargin>3
    sConfPF.runtag=varargin{1};
else
    sConfPF.runtag='';
end


%% ALLOCATE MEMORY
N=sConfPF.N;
K=sConfPF.K;
D_y=sConfPF.D_y;
D_x=sConfPF.D_x;
% evolution of particles set
sResult.H=nan(N,D_y,K);
% evolution of weights
sResult.W=nan(N,K);
% evolution of state estimations
sResult.T_s_EST=nan(N,D_y);
% observation
sResult.q=nan(N,D_x);

%% INITIALIZATION

% Initialize particle set H at time n-1 by drawing
% samples from the initial distributions ~ p(y_0)
Particles_old.H=sConfPF.pdf_init.fun(sConfPF);
% Give all particles the same weights
Particles_old.W=1/K*ones(1,K);

% Initialize particles and weigths (at time n-2)
% by copying the values from time n-1
Particles_oldold.H=Particles_old.H;
Particles_oldold.W=Particles_old.W;

% Store the initial data
sResult.H(1,:,:)=Particles_old.H;
sResult.W(1,:)=Particles_old.W;
sResult.T_s_EST=Particles_old.W*Particles_old.H';


%% ITERATIVE ESTIMATION
for n=2:N
    
    sConfPF.n=n;
     
    % *** PREDICT STATE:
    % Draw samples from the transition pdf
    % given two previous states ~ p(y_n|y_n-1,y_n-2).
    Particles_temp.H=sConfPF.pdf_sysdyn.fun(sConfPF,Particles_old,Particles_oldold);
    Particles_temp.W=Particles_old.W;
    
    % *** AQUIRE DATA:
    % Generate or read in observation for this iteration:
    q=sConfPF.getobs.fun(sConfPF);
    
    % *** UPDATE WEIGHTS:
    % Evaluate observation statistics given observation and
    % hypothetical state (particle)
    % p(x=q|y=h)
    Particles_temp.W=sConfPF.pdf_obsstat.fun(sConfPF,Particles_temp,q);

    % *** NORMALIZE WEIGHTS:
    Particles_temp.W=(Particles_temp.W/sum(Particles_temp.W));
    
    % Note: After this step H & W form an approximate
    % posterior pdf p(y_n|x_0:n)
    
    % *** COMPUTE EXPECTATION
    s_EST=Particles_temp.W*Particles_temp.H';
    
    % *** STORE RESULTS
    sResult.H(n,:,:)=Particles_temp.H;
    sResult.W(n,:)=Particles_temp.W;
    sResult.T_s_EST(n,:)=s_EST;
    sResult.q(n,:)=q;


    % *** RESAMPLE 
    % shift old by one
    Particles_oldold=Particles_old;
    % resample 
    Particles_old=sConfPF.resample.fun(sConfPF,Particles_temp,q);

    
end

% ------------------ Saving results and plotting :-----------------


if b_saveresult
    % if doesnt exist - create directory to store
    if 7~=exist(sConfPF.savedir,'dir')
        system(['mkdir ', sConfPF.savedir]);
        addpath(sConfPF.savedir);
    end
    save([sConfPF.savedir,'/PF_',sConfPF.runtag,'.mat'],'sResult','-v7.3');
end

end


