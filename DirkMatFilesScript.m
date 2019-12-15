clear all
close all
clc

cd('Z:\Dan Lawler\Projects\Sleep')
load('N2HourlyBoutLengths.mat');
load('SleepWakeBoutLengths.mat')

for h =1:12
    slp(h,:) = histcounts(N2HourlySleepLengths(:,h),0:60:3600);
    wak(h,:) = histcounts(N2HourlyAwakeLengths(:,h),0:60:3600);
end
normslp = slp ./ repmat(sum(slp,2),1,size(slp,2));
normwak = wak ./ repmat(sum(wak,2),1,size(wak,2));

figure(1); clf; 
subplot(211); imagesc(log10(normslp)); colorbar; set(gca,'Clim',[-3,-.5]);
subplot(212); imagesc(log10(normwak)); colorbar; set(gca,'Clim',[-3,-.5]);
colormap(jet)

figure(3); clf; 
subplot(211); imagesc(log10(cumsum(normslp,2,'reverse'))); colorbar; set(gca,'Clim',[-3,0]);
subplot(212); imagesc(log10(cumsum(normwak,2,'reverse'))); colorbar; set(gca,'Clim',[-2,0]);
colormap([[1 1 1];jet(64)])

figure(4); clf; 
subplot(121); imagesc(log10(cumsum(normslp,2,'reverse'))'); hc(1) = colorbar; set(gca,'Clim',[-3,0],'FontSize',10,'FontName','arial'); axis xy
xlabel('{\it t} (h)','FontSize',12); ylabel('{\it t}','FontSize',12);
subplot(122); imagesc(log10(cumsum(normwak,2,'reverse'))'); hc(2) = colorbar; set(gca,'Clim',[-1.5,0],'FontSize',10,'FontName','arial'); axis xy
xlabel('{\it t} (h)','FontSize',12); ylabel('{\it t}','FontSize',12);
title('Probability (bout duration > {\it t})','FontSize',12);

j =jet(64);
colormap([[1 1 1];[linspace(1,0,10)',linspace(1,0,10)',ones(10,1)]; j(11:end,:)])

l = [0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2,0.5,1];
set(hc,'Ticks',log10(l),'TickLabels',100*l)
%set(hc,'Ticks',log10(l),'TickLabels',l)

r = 0:60:3600;
flow_slp(1,:) = histcounts(min(N2BoutLengths_Sleep,max(r)),r);
flow_slp(2,:) = histcounts(min(NoFlow_Sleep,max(r)),r);
flow_slp(3,:) = histcounts(min(SulfiteBouts_Sleep,max(r)),r);
flow_slp(4,:) = histcounts(min(SulfateSleepBouts,max(r)),r);
normflow_slp = flow_slp ./ repmat(sum(flow_slp,2),1,size(flow_slp,2));

r = 0:(60*5):(3600*5);
flow_wak(1,:) = histcounts(min(N2BoutLengths_Awake,max(r)),r);
flow_wak(2,:) = histcounts(min(NoFlow_Awake,max(r)),r);
flow_wak(3,:) = histcounts(min(SulfiteBouts_Awake,max(r)),r);
flow_wak(4,:) = histcounts(min(SulfateAwakeBouts,max(r)),r);
normflow_wak = flow_wak ./ repmat(sum(flow_wak,2),1,size(flow_wak,2));

figure(2); clf; 
%subplot(211); imagesc(log10(normflow_slp)); colorbar; 
subplot(221); plot(log10(normflow_slp([1,3],:)'),'o-'); ylim([-5,0]);
yticklabels({'0.001%','0.01%','0.1%','1%','10%','100%'});
subplot(222); plot(log10(cumsum(normflow_slp([1,3],:),2,'reverse')'),'o-'); ylim([-5,0]);
yticklabels({'0.001%','0.01%','0.1%','1%','10%','100%'});
xlabel('Sleep duration (min)'); ylabel({'Cumulative frequency','(% longer bouts)'});

subplot(223); plot(log10(normflow_wak([1,3],:)'),'o-'); ylim([-3,0]);
set(gca,'YTick',-3:0,'YTicklabels',{'0.1%','1%','10%','100%'});
subplot(224); plot(log10(cumsum(normflow_wak([1,3],:),2,'reverse')'),'o-'); ylim([-3,0]);
set(gca,'YTick',-3:0,'YTicklabels',{'0.1%','1%','10%','100%'});
xlabel('Awake duration (min)'); ylabel({'Cumulative frequency','(% longer bouts)'});

figure(5); plot([prctile(N2HourlySleepLengths,50)/60;prctile(N2HourlyAwakeLengths,50)/60;sum(~isnan(N2HourlySleepLengths))/535]','o-');
xlabel('Time (h)'); ylabel('Median duration (min)');

figure(6); clf;
set(gca,'FontSize',10,'FontName','arial');
subplot(311); plot(prctile(N2HourlySleepLengths,50)/60,'o-','Color',[0,0,1]);
m = get(gca,'YLim'); set(gca,'YLim',[0,m(2)],'FontName','arial','FontSize',10); ylabel('Median sleep \newline duration (min)','FontSize',12); 
subplot(312); plot(prctile(N2HourlyAwakeLengths,50)/60,'o-','Color',[1,0,0]);
m = get(gca,'YLim'); set(gca,'YLim',[0,m(2)],'FontName','arial','FontSize',10); ylabel('Median awake \newline duration (min)','FontSize',12);
subplot(313); plot(sum(~isnan(N2HourlySleepLengths))/535,'o-','Color',[0,0,0]);
m = get(gca,'YLim'); set(gca,'YLim',[0,m(2)],'FontName','arial','FontSize',10); xlabel('Time (h)','FontSize',12); ylabel('Mean sleep \newline bouts per h','FontSize',12);

figure(7); clf; 

% %subplot(211); imagesc(log10(normflow_slp)); colorbar; 
% subplot(221); plot(log10(normflow_slp([1,3],:)'),'o-'); ylim([-5,0]);
% yticklabels({'0.001%','0.01%','0.1%','1%','10%','100%'});
subplot(211); plot(log10(cumsum(normflow_slp([4,3],:),2,'reverse')'),'o-'); ylim([-5,0]);
set(gca,'FontSize',10,'FontName','arial');
yticklabels({'0.001%','0.01%','0.1%','1%','10%','100%'});
xlabel('{\it t} (min)','FontSize',12); ylabel({'Probability','(Sleep bout > {\it t})'},'FontSize',12);
% 
% subplot(223); plot(log10(normflow_wak([1,3],:)'),'o-'); ylim([-3,0]);
% set(gca,'YTick',-3:0,'YTicklabels',{'0.1%','1%','10%','100%'});
subplot(212); plot(log10(cumsum(normflow_wak([4,3],:),2,'reverse')'),'o-'); ylim([-3,0]);
set(gca,'YTick',-3:0,'YTicklabels',{'0.1%','1%','10%','100%'},'FontSize',10,'FontName','arial');
xlabel('{\it t} (min)','FontSize',12); ylabel({'Probability','(Awake bout > {\it t})'},'FontSize',12);