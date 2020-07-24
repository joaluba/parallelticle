function matrmse=matrmse4tracks(sResult)

d11=sqrt(mean((sResult.T_s1_GT-sResult.T_s1_EST).^2));
d12=sqrt(mean((sResult.T_s1_GT-sResult.T_s2_EST).^2));
d21=sqrt(mean((sResult.T_s2_GT-sResult.T_s1_EST).^2));
d22=sqrt(mean((sResult.T_s2_GT-sResult.T_s2_EST).^2));

matrmse(1,1,:)=d11;
matrmse(1,2,:)=d12;
matrmse(2,1,:)=d21;
matrmse(2,2,:)=d22;

end