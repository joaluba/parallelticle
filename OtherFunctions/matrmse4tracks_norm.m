function matrmse_norm=matrmse4tracks_norm(sResult)

range=sResult.sConfPF1.pdf_sysdyn.range;
%initialize matrices
here_T_s1_GT=zeros(size(sResult.T_s1_GT));
here_T_s1_EST=here_T_s1_GT;here_T_s2_EST=here_T_s1_GT;here_T_s1_GT=here_T_s1_GT;
%normalize values in all dimensions
for dim=1:4
here_T_s1_GT(:,dim)=(sResult.T_s1_GT(:,dim)-range(dim,1))*(1-0)./(range(dim,2)-range(dim,1)) + 0;
here_T_s1_EST(:,dim)=(sResult.T_s1_EST(:,dim)-range(dim,1))*(1-0)./(range(dim,2)-range(dim,1)) + 0;
here_T_s2_GT(:,dim)=(sResult.T_s2_GT(:,dim)-range(dim,1))*(1-0)./(range(dim,2)-range(dim,1)) + 0;
here_T_s2_EST(:,dim)=(sResult.T_s2_EST(:,dim)-range(dim,1))*(1-0)./(range(dim,2)-range(dim,1)) + 0;
end

d11=sqrt(mean((here_T_s1_GT-here_T_s1_EST).^2));
d12=sqrt(mean((here_T_s1_GT-here_T_s2_EST).^2));
d21=sqrt(mean((here_T_s2_GT-here_T_s1_EST).^2));
d22=sqrt(mean((here_T_s2_GT-here_T_s2_EST).^2));

matrmse_norm(1,1,:)=d11;
matrmse_norm(1,2,:)=d12;
matrmse_norm(2,1,:)=d21;
matrmse_norm(2,2,:)=d22;

end