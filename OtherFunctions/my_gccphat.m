function [tau G]=my_gccphat(sig,refsig,fs)

% upsampling factor
Factor=8;

% fft 
X_1=fft(sig);
X_2=fft(refsig);
% take half of the spectrum
X_1=X_1(1:end/2);
X_2=X_2(1:end/2);
% cross power spectrum
X_corr=X_1.*conj(X_2);
X_norm=max(abs(X_corr),eps);
% normalization
G=(X_corr./X_norm);
% zero padding
G=[G;zeros(length(G)*(Factor-1),1)];
% reconstruct mirror freqs
G = [G;  conj(G(end:-1:1,:))];
% ifft with shift 
G=fftshift(ifft(G,'symmetric'));
% find index
[~, tau_idx]=max(G);
zero_idx=round(length(G)/2);
% find time
tau=(tau_idx-1-zero_idx)/(fs*Factor);

end
