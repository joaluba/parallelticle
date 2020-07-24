function plottracks_PoC_2(sResult)


color1=[208 208 208]/255;
color2=[0 0 0];
myredL=[255 200 102]/255;
myblueL=[0 200 255]/255;

% myred=[255 102 102]/255;
% myblue=[0 128 255]/255;
% mygreen=[60,179,113]/255;
% myorange=[255,140,0]/255;

% myred=[139,0,0]/255;
% myblue=[0 0 205]/255;
myred=[128,0,0]/255;
myblue=[0 0 128]/255;
myorange=[255,127,0]/255;
mygreen=[55,200,113]/255;





if ~isfield(sResult,'q1')
    sResult.q1=nan(size(sResult.T_o));
    sResult.q2=nan(size(sResult.T_o));
    sResult.q1(sResult.winner_EST==1,:)=sResult.T_o(sResult.winner_EST==1,:);
    sResult.q2(sResult.winner_EST==2,:)=sResult.T_o(sResult.winner_EST==2,:);
end

if ~isfield(sResult,'q1_gt')
    sResult.q1_gt=nan(size(sResult.T_o));
    sResult.q2_gt=nan(size(sResult.T_o));
    sResult.q1_gt(sResult.winner_GT==1,:)=sResult.T_o(sResult.winner_GT==1,:);
    sResult.q2_gt(sResult.winner_GT==2,:)=sResult.T_o(sResult.winner_GT==2,:);
end
    
    

%% PLOTS
M = floor((sResult.sConfPF1.D_y+1)/2)
f=figure;
x0=100;
y0=100;
width=900;
height=500;
set(f,'units','points','position',[x0,y0,width,height])
for i=1:sResult.sConfPF1.D_y;
subplot(M,2,i)
plot(sResult.T_s1_GT(:,i),'-','LineWidth',1.5,'Color',myred)
hold on
plot(sResult.T_s2_GT(:,i),'-','LineWidth',1.5,'Color',myblue)
hold on
plot(sResult.T_s1_EST(:,i),'LineWidth',1.5,'Color',mygreen)
hold on
plot(sResult.T_s2_EST(:,i),'LineWidth',1.5,'Color',myorange)
% hold on
% GT glimpses
plot(sResult.q1_gt(:,i),'o','LineWidth',1,'Markersize',7.5,'MarkerFaceColor',myred, 'MarkerEdgeColor',myred)
hold on
plot(sResult.q2_gt(:,i),'o','LineWidth',1,'Markersize',7.5,'MarkerFaceColor',myblue,'MarkerEdgeColor',myblue)
hold on
% Associated glimpses
plot(sResult.q1(:,i),'o','LineWidth',1,'Markersize',4.5,'MarkerFaceColor',mygreen, 'MarkerEdgeColor',mygreen)
hold on
plot(sResult.q2(:,i),'o','LineWidth',1,'Markersize',4.5,'MarkerFaceColor',myorange,'MarkerEdgeColor',myorange)
%plot(sResult.T_o(:,i),'ko','LineWidth',1.5,'Markersize',8)
ylim([sResult.sConfPF1.pdf_sysdyn.range(i,1) sResult.sConfPF2.pdf_sysdyn.range(i,2)])
%  title(['tracks for ',sResult.sConfPF1.state_names{i},'; ',sResult.sConfPF1.runtag],'Interpreter','none') 
 title(['tracks for ',sResult.sConfPF1.state_names{i}],'Interpreter','none') 
end
legend('GT trajectory voice 1', 'GT trajectory voice 2',...
 'EST trajectory voice 1' , 'EST trajectory voice 2',...
'glimpse from GT 1','glimpse from GT 2', 'glimpse assoc. to PF1','glimpse assoc. to PF2');

%plot3d 
%All formants on one plot:
figure;
plot3(sResult.T_s1_GT(:,1),sResult.T_s1_GT(:,2),sResult.T_s1_GT(:,3),'Linewidth',1.5,'Color',myred)
hold on
plot3(sResult.T_s2_GT(:,1),sResult.T_s2_GT(:,2),sResult.T_s2_GT(:,3),'Linewidth',1.5,'Color',myblue)
hold on 
plot3(sResult.T_s1_EST(:,1),sResult.T_s1_EST(:,2),sResult.T_s1_EST(:,3),'Linewidth',1.5,'Color',mygreen)
hold on
plot3(sResult.T_s2_EST(:,1),sResult.T_s2_EST(:,2),sResult.T_s2_EST(:,3),'Linewidth',1.5,'Color',myorange)
hold on
plot3(sResult.q1_gt(:,1),sResult.q1_gt(:,2),sResult.q1_gt(:,3),'o','LineWidth',1,'Markersize',7.5,'MarkerFaceColor',myred, 'MarkerEdgeColor',myred)
hold on
plot3(sResult.q2_gt(:,1),sResult.q2_gt(:,2),sResult.q2_gt(:,3),'o','LineWidth',1,'Markersize',7.5,'MarkerFaceColor',myblue,'MarkerEdgeColor',myblue)
hold on
plot3(sResult.q1(:,1),sResult.q1(:,2),sResult.q1(:,3),'o','LineWidth',1,'Markersize',4.5,'MarkerFaceColor',mygreen, 'MarkerEdgeColor',mygreen)
hold on
plot3(sResult.q2(:,1),sResult.q2(:,2),sResult.q2(:,3),'o','LineWidth',1,'Markersize',4.5,'MarkerFaceColor',myorange,'MarkerEdgeColor',myorange)
grid on
title(['First 3 dimensions of the state space; : ',sResult.sConfPF1.runtag],'Interpreter','none')
legend('GT trajectory voice 1', 'GT trajectory voice 2',...
 'EST trajectory voice 1' , 'EST trajectory voice 2',...
'glimpse from GT 1','glimpse from GT 2', 'glimpse assoc. to PF1','glimpse assoc. to PF2');
% xlim([100 350]);ylim([300 700]);zlim([800 2400])
xlabel('F0')
ylabel('F1')
zlabel('F2')






end
