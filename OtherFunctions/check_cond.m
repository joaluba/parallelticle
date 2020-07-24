function cond_idx=check_cond(dirname,cond)
if ~ exist('m_test')
    % path where all the files are stored
    datapath=['/media/joanna/daten/user/joanna/Data/myCASA_Data/PoC_2/' ,dirname,'/'];
[a TESTMATfilename]=system(['ls ',datapath,'TESTMAT_*.mat']);
load(TESTMATfilename(1:end-1));
end

% find out indices of the desired conditions
a=regexp(m_test(4,:),cond);
indi_correct=~cellfun(@isempty,a);
cond_idx=find(indi_correct);

if length(cond_idx)==1
disp(['resampling method: ' func2str(m_test{1,cond_idx})])
disp(['Glimpse probab. Q: ' num2str(m_test{2,cond_idx})])
disp(['Obs.noise sigma: ' num2str(m_test{3,cond_idx}')])
end
end
