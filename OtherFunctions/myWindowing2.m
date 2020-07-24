function [matFrames, vTime]= myWindowing2(vSignal, SamplingRate, FrameLength, FrameShift)
%% function which splits the signal into overlapping time frames
% INPUT:
% vSignal          signal
% SamplingRate     sampling frequency in Hz
% FrameLength      frame length in miliseconds
% FrameShift       frame shift in miliseconds
% OUTPUT:
% matFrames        matrix, where subsequent frames are stored in columns
% vTime            vector containing time instants around which the frames
%                  are centered


SamplingRate=SamplingRate/1000;
FrameShift==2*floor((FrameShift*SamplingRate)/2);
FrameLength=2*floor((FrameLength*SamplingRate)/2)


matFrames=zeros(FrameLength,floor((length(vSignal)-FrameLength)/FrameShift)+1); 
vTime=zeros(1,round((length(vSignal)-FrameLength)/FrameShift));
for i=1:floor((length(vSignal)-FrameLength)/FrameShift)+1;
    v_idx=vSignal((1+(i-1)*FrameShift):((i-1)*FrameShift +FrameLength));
    matFrames(:,i)=v_idx;  %each frame is stored in one column of the matrix
    vTime(i)= ((i-1)*FrameShift+FrameLength/2)/(SamplingRate*1000);  %row vector
end
end
