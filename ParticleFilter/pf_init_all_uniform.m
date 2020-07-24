function H=pf_init_all_uniform(sConf)
% Function to initialize particles 
% ----- Extra parameters needed: -----
% sConf.pdf_init.range= [100  200;...
%                           170 260;...
%                           -90 90;...
%                           -90 90];
% Range is the parameter specific for uniform distribution - here the
% possible range values are defined for each state element. 

% random value in interval [a, b]
a=repmat(sConf.pdf_init.range(:,1),1,sConf.K);
b=repmat(sConf.pdf_init.range(:,2),1,sConf.K);
H = round(a + (b-a).*rand(sConf.D_y,sConf.K));

end