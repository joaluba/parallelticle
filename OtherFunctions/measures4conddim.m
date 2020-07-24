function [RMSE,RMSENORM,TAP,GAP]=measures4conddim(cond,dim,varargin)
% [rmse_cond,TAP, per_glimpse_cond, GAP]=measures4conddim(MATRMSE,MATGAS,cond,dim)
% for a given condition generate:
% RMSE - rmse in dimension dim
% RMSE - rmse in dimension dim
% TAP - trajectory assignment performance
% GAP - glimpse assignment performance

MATRMSE=varargin{1};
MATGAS=varargin{2};
MATRMSENORM=varargin{3};
% based on which measure the assignment should be done
bon=varargin{4};

for n=1:size(MATRMSE,5)% for each condition
    
    %----------------- SUMMATIONS ACROSS MATRICES -------------------
    
    % matrix where distances (in rmse) are stored
    D=MATRMSE(:,:,dim,cond,n);
    d1=(D(1,1)+D(2,2))/2;
    d2=(D(2,1)+D(1,2))/2;
    d3=(D(1,1)+D(1,2))/2;
    d4=(D(2,1)+D(2,2))/2;
    v_d=[d1 d2 d3 d4];
    
    D_alldim=sqrt(sum(MATRMSE(:,:,:,cond,n).^2,3));
    da1=(D_alldim(1,1)+D_alldim(2,2))/2;
    da2=(D_alldim(2,1)+D_alldim(1,2))/2;
    da3=(D_alldim(1,1)+D_alldim(1,2))/2;
    da4=(D_alldim(2,1)+D_alldim(2,2))/2;
    v_da=[da1 da2 da3 da4];
    
    % matrix where distances (in normalized
    % rmse) are stored
    N=MATRMSENORM(:,:,dim,cond,n);
    n1=(N(1,1)+N(2,2))/2;
    n2=(N(2,1)+N(1,2))/2;
    n3=(N(1,1)+N(1,2))/2;
    n4=(N(2,1)+N(2,2))/2;
    v_n=[n1 n2 n3 n4];
    
    N_alldim=sqrt(sum(MATRMSENORM(:,:,:,cond,n).^2,3));
%     N_alldim=mean(MATRMSENORM(:,:,:,cond,n),3);
    na1=(N_alldim(1,1)+N_alldim(2,2))/2;
    na2=(N_alldim(2,1)+N_alldim(1,2))/2;
    na3=(N_alldim(1,1)+N_alldim(1,2))/2;
    na4=(N_alldim(2,1)+N_alldim(2,2))/2;
    v_na=[na1 na2 na3 na4];
    
    % matrix where perc of correct assigned glimpses
    % is stored
    G=MATGAS(:,:,cond,n);
    ga1=(G(1,1)+G(2,2))/2;
    ga2=(G(2,1)+G(1,2))/2;
    ga3=(G(1,1)+G(1,2))/2;
    ga4=(G(2,1)+G(2,2))/2;
    v_ga=[ga1 ga2 ga3 ga4];
    
    % ----------------------- TRACK ASSIGNMENT -------------------------

        % Find the right assignment
        
    switch bon
    case 'G'
        % assignment based on the matrix G with percentage of correctly
        % assigned glimpses
       [~,ind_assign]=max(v_ga(1:2));
       [~,ind_isok]=max(v_ga);
    case 'D'
        % assignment based on the matrix D with RMSE
        % between GT and EST tracks (4 dim vector length) 
          [~,ind_assign]=min(v_da(1:2));
          [~,ind_isok]=min(v_da);
    case 'N'
        % assignment based on the matrix N with normalized RMSE 
        % between GT and EST tracks (4 dim vector length)  
        [~,ind_assign]=min(v_na(1:2));
        [~,ind_isok]=min(v_na);
    end 
        
   
    % ----------------------- MEASURES -------------------------
    
    % if the minimum not on the diagonal
    if ind_isok>2
        % correct track assignment indicator (0 or 1)
        v_CTA(n)=0;
        % glimpse assignment performance
        v_GAP(n)=v_ga(ind_assign);
        % rmse
        v_RMSE(n)=v_d(ind_assign);
        % normalized rmse
        v_RMSENORM(n)=v_na(ind_assign);
        
    else
        % correct track assignment indicator (0 or 1)
        v_CTA(n)=1;
        % glimpse assignment performance
        v_GAP(n)=v_ga(ind_assign);
        % rmse
        v_RMSE(n)=v_d(ind_assign);
        % normalized rmse
        v_RMSENORM(n)=v_na(ind_assign);
        
    end
    
    
end

% ------------ AVERAGE ACROSS SAMPLES ----------------
TAP=(sum(v_CTA)/length(v_CTA));
% GAP=(sum(v_GAP)/length(v_GAP));
GAP=nanmean(v_GAP);
RMSE=mean(v_RMSE);
RMSENORM=mean(v_RMSENORM);

end


