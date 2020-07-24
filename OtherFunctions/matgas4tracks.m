function matgas=matgas4tracks(sResult)

% make all nans zeros
sResult.winner_EST(isnan(sResult.winner_EST))=0;

logic1_GT=(sResult.winner_GT==1);
logic2_GT=(sResult.winner_GT==2);

logic1_EST=(sResult.winner_EST==1);
logic2_EST=(sResult.winner_EST==2);

gas11=sum(and(logic1_GT,logic1_EST))/sum(logic1_GT);
gas12=sum(and(logic1_GT,logic2_EST))/sum(logic1_GT);
gas21=sum(and(logic2_GT,logic1_EST))/sum(logic2_GT);
gas22=sum(and(logic2_GT,logic2_EST))/sum(logic2_GT);

matgas(1,1)=gas11;
matgas(1,2)=gas12;
matgas(2,1)=gas21;
matgas(2,2)=gas22;

end