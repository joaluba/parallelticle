function sig_out=normalize(sig_in,a,b) 
sig_in_v=sig_in(:);
sig_out = (sig_in_v-min(sig_in_v))*(b-a)./(max(sig_in_v)-min(sig_in_v)) + a;
sig_out=reshape(sig_out,size(sig_in));
end
