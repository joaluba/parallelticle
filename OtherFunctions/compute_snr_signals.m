function [sig, noise]=compute_snr_signals(SNR,signal,noise,L_sig)
% INPUT:
% SNR - desired SNR
% signal - target signal
% noise - noise signal
% L_sig - desired level of the target signal


% what is the rms level of the original signal
L_old=20*log10(rms(signal)/(2*10^-5));
% change the level to desired level
v_signal_new=signal*10^((L_sig-L_old)/20);

% compute gain for the noise 
P_sig=sum(mean(v_signal_new.^2));
P_noise=sum(mean(noise.^2));
G=P_sig/(10^(SNR/10));
G=sqrt(G/P_noise);


noise=noise*G;
sig=v_signal_new;

% L_sig=20*log10(rms(sig)/(2*10^-5));
% L_noise=20*log10(rms(noise)/(2*10^-5));

end