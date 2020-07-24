function [signal_mono, signal_bin] = auralise_hidden_states(T,fs_pf,fs_sig,r,render)
% This is a function to auralise (synthesise) the hidden state sequence. 
% T - multidimensional state trajectory (sequence) 
% fs_pf - sampling of the particle filter
% fs_sig - sampling frequency of the signal we want to produce
% r- distance to the receiver 
% render - type of rendering in tascar 

% change nans to zeros (synthesiser does not take nans)
T(isnan(T))=0;

step=1/fs_pf*1000;%ms
dur=(length(T))*step;%ms
% ------------------------------------------------------------------------
changespk=1;%change to 1.5 to get female voice
% Constant Parameters
defPars = struct('DU',dur, 'SR',16000, 'UI', 2, 'TL', 0, 'SS', 2);
defPars.F3=2500*changespk;
defPars.F4=3250*changespk;
defPars.F5=3700*changespk;
defPars.AV=50;
% Varying Parameters
varPars = {'F0','F1','F2'};
% time vector for parameter update
time= step:step:dur;
% create matrix score(used in Klatt) 
score=[time' T];
% F0 in Klatt  has to be in tens of Hz
score(:,2)=score(:,2)*10;
% Klatt synthesis
signal= mlsyn(defPars, varPars, score(:,1:4));
% int16 --> double
signal = double(signal);
%signal=signal./(4*max(abs(signal)));%???
% resample
[P,Q] = rat(fs_sig/16000);
signal=resample(signal,P,Q);
% 0 dB
signal_mono=mynormalize(signal,-1,1);
%save mono signal
monofilename='tmp_mono.wav';
audiowrite(monofilename,signal_mono,fs_sig);
% use synthesised signals and alpha trajectory to generate 
% binaural files using tascar 
binfilename='tmp_bin.wav';

if size(score,2)>4
signal_bin=tsc_createbinfile(monofilename,binfilename,deg2rad(score(:,5)),score(:,1),fs_sig,r,render);
else 
signal_bin=[signal_mono signal_mono];
end
end