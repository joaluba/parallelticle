function bin_sig=tsc_createbinfile(monofilename,outputfilename,traj,time,fs, r,render)
javaaddpath netutil-1.0.0.jar
addpath /usr/share/tascar/matlab/
% This is a function which transforms a monaural signal into
% binaural signal in which a source is moving according to the predefined
% trajectory. This function uses TASCAR to create the binaural file.
% In the TASCAR scene the monaural signal is placed as a sound source
% located r meter away from the receiver. The source is moving on a circle
% - only the direction of arrival varies.
% -----------------INPUT:----------------
% monofilenme - name of the mono wav file
% outputfilename - name of the output binaural file
% traj        - trajectory in angles!
% time       - trajectory sampling times
% r - distance from the source
% fs - to audiowrite
% ----------------OUTPUT:-----------------
% bin_sig   - binaural file (two channel signal)
% -----------------------------------------------------------------------
% Author: joanna.luberadzka@uni-oldenburg.de


% save angle trajectory in cartesian coordinates in the csv file
% to be later loaded into tascar
if exist('source_traj.csv','file') ~= 2
    error('source_traj.csv not provided');
end
fileID = fopen('source_traj.csv','w');
for l=1:length(traj)
    %traj must be in radians!
    [x, y, z,]=sph2cart(-1*traj(l),0,r);
    fprintf(fileID,'%4.2f , %4.2f , %4.2f,  %4.2f\r\n',time(l)/1000,x,y,z);
end
fclose(fileID);

if strcmp(render,'tsc_ortf')
    
    % offline rendering of a tascar scene
    system(['LD_LIBRARY_PATH=" " tascar_renderfile -d -f 1 -i ', monofilename,' -o ',outputfilename, ' moving_speaker_ortf.tsc']);
    bin_sig=audioread(outputfilename);
    system(['rm ', outputfilename]);
    
elseif strcmp(render,'tsc_hrir')
    
    % ----------- Edit .tsc file using tascar xml tools ----------:
    % get working directory string
    [a b]=system('pwd');
    % define doc node 
    doc = tascar_xml_open(strcat(b,'/moving_speaker_hrir.tsc'));
    % edit name of sndfile
    doc = tascar_xml_edit_elements(doc,'sndfile','name',monofilename);
    % save the edited scene definition file
    tascar_xml_save(doc,strcat(b,'/','edited.tsc'))
    % open jack 
    [c d]=system('LD_LIBRARY_PATH=" " qjackctl -s &');
    pause(2)
    % loading a scene into tascar
    h_temp=tascar_ctl('load','edited.tsc');
    signal=zeros(0.001*time(end)*fs,1);
    % [a b]=system(['tascar_jackio  -o ',wavfiledir,outputfile,' ',wavfiledir,'moving_F0.wav hrirconv.tascar:out_0 hrirconv.tascar:out_1' ])
    [bin_sig,~,~,~,~,~]=tascar_jackio(signal,'output' ,'render.scene:speaker1.0' , 'input',  {'hrirconv:out_0', 'hrirconv:out_1'}, 'starttime', 0);
    tascar_ctl('kill',h_temp);
    [e f]=system('killall qjackctl');
    system(['rm ', strcat(b,'/','edited.tsc')]);
end

bin_sig= mynormalize(bin_sig,-1,1);

% % save files needed to reproduce the scene  
% system(['mv ', strcat(b,'/',[sStimParam.runtag,'.tsc']),' ', sStimParam.savedir,'/',sStimParam.runtag,'.tsc']);
% system(['cp ', strcat(b,'/','source_traj.csv'),' ', sStimParam.savedir,'/traj_',sStimParam.runtag,'.csv']);
% system('rm *.tsc.* ');

end





