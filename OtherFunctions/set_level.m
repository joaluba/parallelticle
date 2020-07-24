function sig_out=set_level(sig_in,L_des) 
sig_zeromean=sig_in-repmat(mean(sig_in,1),size(sig_in,1),1);
sig_norm_en=sig_zeromean./std(sig_zeromean(:));
sig_out =sig_norm_en.*10^(L_des/20);
end
