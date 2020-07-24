function [rmse, bool_assign]=rmse_condition(MATRMSE,cond)
% This function looks at the distances between GT (ground truth) 
% and EST (estimated) trajectory and assigns only one estimated sequence to
% each trajectory
% rmse - root mean square error of the assignment 
% bool_assign - measure if the assignment was done correctly 

d11=sqrt(mean((sResult.T_s1_GT-sResult.T_s1_EST).^2));
d12=sqrt(mean((sResult.T_s1_GT-sResult.T_s2_EST).^2));
d21=sqrt(mean((sResult.T_s2_GT-sResult.T_s1_EST).^2));
d22=sqrt(mean((sResult.T_s2_GT-sResult.T_s2_EST).^2));

assign1=(d11+d22)/2;
assign2=(d21+d12)/2;
assign3=(d11+d12)/2;
assign4=(d21+d22)/2;
A=[assign1 assign2 assign3 assign4];

[~,ind1]=min(A);
[val_rmse,~]=min(A(1:2));
if ind>2
bool_assign=0;
rmse=val_rmse;
else 
bool_assign=1;
rmse=val_rmse;
end


end