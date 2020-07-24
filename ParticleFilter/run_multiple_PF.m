% This is a function run  parallel particle filters
%
% ------------------ INPUT: -----------------
% sConfPF1     - parameters of the first PF
% sConfPF2     - parameters of the second PF
% T_o              - sequence with glimpsed observation
% b_saveresult - boolean indicating if you want to save results
% b_plot       - boolean indicating if you want to plot the process 
% ------------------ OUTPUT: -----------------
% sResult                   - data structure with following fields:
% sResult.H1/H2             - matrices containing evolution of the particles
%                             for PF1 and PF2
% sResult.W1/W2             - matrices containing evolution of the weights
%                             for PF1 and PF2
% sResult.q1/q2             - matrices containing input data that
%                             each PF receives
% sResult.T_s1_EST/T_s2_EST - matrices containing evolution of the expected
%                             value of the state for voice 1 and 2
% sResult.winner_EST - which particle filter won each iteration
%
% ------------------ USAGE: -----------------
% my_sResult=run_multiple_PF(sConf,T_o,0,0)
% my_sResult=run_multiple_PF(sConf,T_o,1,1,'runname')
% -----------------------------------------------------------------------
% Author: joanna.luberadzka@uni-oldenburg.de

function sResult=run_multiple_PF(sConfPF1,sConfPF2,T_o,b_saveresult,b_plot,varargin)

% there might be an extra tag (string)
% for the current run of particle filter
if nargin>5
    sConfPF1.runtag=varargin{1};
    sConfPF2.runtag=varargin{1};
else
    sConfPF1.runtag='run';
    sConfPF2.runtag='run';
end


%% ALLOCATE MEMORY
N=sConfPF1.N;
K=sConfPF1.K;
D_y=sConfPF1.D_y;
D_x=sConfPF1.D_x;
% evolution of particles set
sResult.H1=nan(N,D_y,K);
sResult.H2=nan(N,D_y,K);
% evolution of weights
sResult.W1=nan(N,K);
sResult.W2=nan(N,K);
% evolution of state estimations
% observation
sResult.q1=nan(N,D_x);
sResult.q2=nan(N,D_x);

%% INITIALIZATION 

% Initialize particle set H at time n-1 by drawing
% samples from the initial distributions ~ p(y_0)
Particles1_old.H=sConfPF1.pdf_init.fun(sConfPF1);
Particles2_old.H=sConfPF1.pdf_init.fun(sConfPF2);
% Give all particles the same weights
Particles1_old.W=1/K*ones(1,K);
Particles2_old.W=1/K*ones(1,K);

% Initialize particles and weigths (at time n-2)
% by copying the values from time n-1
Particles1_oldold.H=Particles1_old.H;
Particles2_oldold.H=Particles2_old.H;
Particles1_oldold.W=Particles1_old.W;
Particles2_oldold.W=Particles2_old.W;

% Store the initial data
sResult.H1(1,:,:)=Particles1_old.H;
sResult.H2(1,:,:)=Particles2_old.H;
sResult.W1(1,:)=Particles1_old.W;
sResult.W2(1,:)=Particles2_old.W;
s1_ESTold=Particles1_old.H*Particles1_old.W';sResult.T_s1_EST(1,:)=s1_ESTold';
s2_ESTold=Particles2_old.H*Particles2_old.W';sResult.T_s2_EST(1,:)=s2_ESTold';

m_expval1=repmat(s1_ESTold,[1,sConfPF1.K]);
m_expval2=repmat(s2_ESTold,[1,sConfPF2.K]);
sResult.T_s1_var(1,:)=((Particles1_old.H-m_expval1).^2)*Particles1_old.W';
sResult.T_s2_var(1,:)=((Particles2_old.H-m_expval2).^2)*Particles2_old.W';

h=9999;
%% ITERATIVE ESTIMATION
for n=2:N
    
    sConfPF1.n=n;
    sConfPF2.n=n;
    
    Particles1_temp.W=Particles1_old.W;
    Particles2_temp.W=Particles2_old.W;
    
    % *** PREDICT STATE: -------------------------------------------------
    % Draw samples from the transition pdf
    % given two previous states ~ p(y_n|y_n-1,y_n-2).
    Particles1_temp.H=sConfPF1.pdf_sysdyn.fun(sConfPF1,Particles1_old,Particles1_oldold);
    Particles2_temp.H=sConfPF2.pdf_sysdyn.fun(sConfPF2,Particles2_old,Particles2_oldold);
    
    % *** AQUIRE DATA: ---------------------------------------------------
    % Generate or read in observation for this iteration:
    [q1, q2, winner]=sConfPF1.getobs.fun(sConfPF1,sConfPF2,T_o,s1_ESTold, s2_ESTold);
    
    % *** UPDATE WEIGHTS: ------------------------------------------------
    % Evaluate observation statistics given observation and
    % hypothetical state (particle)
    % p(x=q|y=h)
    if winner==1
        % if 1st pf responsible for the glimpse -  update 
        Particles1_temp.W=sConfPF1.pdf_obsstat.fun(sConfPF1,Particles1_temp,q1);
    elseif winner==2
        % if 2nd pf responsible for the glimpse -  update 
        Particles2_temp.W=sConfPF2.pdf_obsstat.fun(sConfPF2,Particles2_temp,q2);
    elseif isnan(winner)
        % nothing happens
    elseif  winner==0
        Particles1_temp.W=sConfPF1.pdf_obsstat.fun(sConfPF1,Particles1_temp,q1);
        Particles2_temp.W=sConfPF2.pdf_obsstat.fun(sConfPF2,Particles2_temp,q2);
    end
    
    % *** NORMALIZE WEIGHTS: ---------------------------------------------
    Particles1_temp.W=(Particles1_temp.W/sum(Particles1_temp.W));
    Particles2_temp.W=(Particles2_temp.W/sum(Particles2_temp.W));
    
    % Note: After this step H & W form an approximate
    % posterior pdf p(y_n|x_0:n)
    
    % *** COMPUTE ESTIMATE -----------------------------------------------
    
    % Expectation
    s1_EST=Particles1_temp.H*Particles1_temp.W';
    s2_EST=Particles2_temp.H*Particles2_temp.W';
    %     % MAP
    %     [~,maxind1]=max(Particles1_temp.W);
    %     [~,maxind2]=max(Particles2_temp.W);
    %     s1_EST=Particles1_temp.H(:,maxind1);
    %     s2_EST=Particles2_temp.H(:,maxind2);
    
    
    % *** RESAMPLE -------------------------------------------------------
    if winner==1
        %     resample PF1
        Particles1_resampled=sConfPF1.resample.fun(sConfPF1,Particles1_temp,q1);
        Particles2_resampled=Particles2_temp;
    elseif winner==2
        %     resample PF1
        Particles2_resampled=sConfPF2.resample.fun(sConfPF2,Particles2_temp,q2);
        Particles1_resampled=Particles1_temp;
    else
        Particles1_resampled=Particles1_temp;
        Particles2_resampled=Particles2_temp;
    end
    
    if b_plot
        % PLOT evolution of particles
        figure(h);
        stem3(Particles1_temp.H(1,:),Particles1_temp.H(2,:),Particles1_temp.W,'filled','MarkerSize',3,'Linewidth',1.5)
        hold on
        stem3(Particles2_temp.H(1,:),Particles2_temp.H(2,:),Particles2_temp.W,'filled','MarkerSize',3,'Linewidth',1.5)
        hold on
        stem3(T_o(sConfPF1.n,1),T_o(sConfPF1.n,2),0.7,'filled','MarkerSize',5,'Linewidth',2)
        hold on
        stem3([s1_EST(1);s2_EST(1)],[s1_EST(2); s2_EST(2)],[0.7; 0.7],'filled','MarkerSize',3,'Linewidth',1.5)
        hold off
        xlim([sConfPF1.pdf_sysdyn.range(1,1) sConfPF2.pdf_sysdyn.range(1,2)])
        ylim([sConfPF1.pdf_sysdyn.range(2,1) sConfPF2.pdf_sysdyn.range(2,2)])
        zlim([0 1])
        legend('PF1','PF2','observation','estimate')
        title('first two dimensions of the state space')
        drawnow
    end
    
    
    % *** STORE RESULTS --------------------------------------------------
    sResult.H1(n,:,:)=Particles1_temp.H;
    sResult.H2(n,:,:)=Particles2_temp.H;
    sResult.W1(n,:)=Particles1_temp.W;
    sResult.W2(n,:)=Particles2_temp.W;
    sResult.q1(n,:)=q1;
    sResult.q2(n,:)=q2;
    sResult.T_s1_EST(n,:)=s1_EST';
    sResult.T_s2_EST(n,:)=s2_EST';
    sResult.winner_EST(n)=winner;
    

     
    % shift time step
    Particles1_oldold=Particles1_old;
    Particles2_oldold=Particles2_old;
    Particles1_old=Particles1_resampled;
    Particles2_old=Particles2_resampled;
    s1_ESTold=s1_EST;s2_ESTold=s2_EST;
    
    
end

% ------------------ Saving results :-----------------
if b_saveresult
        % if doesnt exist - create directory to store
        if 7~=exist(sConfPF1.savedir,'dir')
            system(['mkdir ', sConfPF1.savedir]);
            addpath(sConfPF1.savedir);
        end
        save([sConfPF1.savedir,'/PF_',sConfPF1.runtag,'.mat'],'sResult','-v7.3');
end

sResult.sConfPF1=sConfPF1;
sResult.sConfPF2=sConfPF2;
    

end
    













 


