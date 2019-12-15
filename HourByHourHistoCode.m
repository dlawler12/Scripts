clear all
close all
clc
cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\AllN2Data');
load('HourlyGroupsSmoothN2.mat');
HourSmooth_1=[HourSmooth_1;HourSmooth_2;HourSmooth_3];
HourSmooth_2=[HourSmooth_4;HourSmooth_5;HourSmooth_6];
HourSmooth_3=[HourSmooth_7;HourSmooth_8;HourSmooth_9];
HourSmooth_4=[HourSmooth_10;HourSmooth_11;HourSmooth_12];

load('HourlyGroupsN2.mat')

Hour_1=[Hour_1,Hour_2,Hour_3];
Hour_2=[Hour_4,Hour_5,Hour_6];
Hour_3=[Hour_7,Hour_8,Hour_9];
Hour_4=[Hour_10,Hour_11,Hour_12];

Hour_1(Hour_1>1)=10;
Hour_1(Hour_1==1)=0;
Hour_1(Hour_1==10)=1;
Hour_2(Hour_2>1)=10;
Hour_2(Hour_2==1)=0;
Hour_2(Hour_2==10)=1;
Hour_3(Hour_3>1)=10;
Hour_3(Hour_3==1)=0;
Hour_3(Hour_3==10)=1;
Hour_4(Hour_4>1)=10;
Hour_4(Hour_4==1)=0;
Hour_4(Hour_4==10)=1;

HS1=sum(sum(Hour_1));
HS2=sum(sum(Hour_2));
HS3=sum(sum(Hour_3));
HS4=sum(sum(Hour_4));
for i=1:4       
%% Histogram Calculation
        %Sleep
        eval(['histfile=HourSmooth_',int2str(i),';']);
        [~,animals] = size(histfile);
        newmat = zeros(10800,animals);
        for h = 1:animals
            count = 0 ;
            for u = 1:10800
                if(histfile(u,h)==0)
                    newmat(u,h)=count+1;
                    count=count+1;
                else
                    count = 0;
                end
            end
        end

        maxs = zeros(10800,animals);
        for e = 1:animals
            for g = 1:10799
                if(newmat(g+1,e)<newmat(g,e))
                    maxs(g,e)=newmat(g,e);
                end
            end
        end

        g=10800;
        for o = 1:animals
            maxs(g,o)=newmat(g,o);
        end
        maxs(maxs==0)=NaN;
        bins = [0,20,50,100,200,500,1000,10000000];
%         a = histcounts(maxs,bins);
        eval(['HistSleepHour',int2str(i),'=histcounts(maxs,bins);']);
%    end


%Sleep
        newmat = zeros(10800,animals);
        for z = 1:animals
            count = 0 ;
            for q = 1:10800
                if(histfile(q,z)==1)
                    newmat(q,z)=count+1;
                    count=count+1;
                else
                    count = 0;
                end
            end
        end

        maxs = zeros(10800,animals);
        for b = 1:animals
            for l = 1:10799
                if(newmat(l+1,b)<newmat(l,b))
                    maxs(l,b)=newmat(l,b);
                end
            end
        end

        l=10800;
        for r = 1:animals
            maxs(l,r)=newmat(l,r);
        end
        maxs(maxs==0)=NaN;
        bins = [0,20,50,100,200,500,1000,10000000];
%         a = histcounts(maxs,bins);
        eval(['HistAwakeHour',int2str(i),'=histcounts(maxs,bins);']);
end

figure

subplot(1,2,1)
for i = 1:4
    hold on
    eval(['plot(HistAwakeHour',int2str(i),'(2:6));']);
%     eval(['plot(HistAwakeHour',int2str(i),');']);
end
title('Awake')
ylim([0 1000])
ylabel('Bout Count (per animal)')
% xticks([1 2 3 4 5 6 7])
% xticklabels({'0-20','20-50','50-100','100-200','200-500','500-1000','>1000'})
xticks([1 2 3 4 5])
xticklabels({'20-50','50-100','100-200','200-500','500-1000'})
xtickangle(45)
xlabel('Bout Length (seconds)')
hold off

subplot(1,2,2)
for i = 1:4
    hold on
    eval(['plot(HistSleepHour',int2str(i),'(2:6));']);
%     eval(['plot(HistSleepHour',int2str(i),');']);
end
title('Sleep')
ylim([0 1000])
ylabel('Bout Count (per animal)')
% xticks([1 2 3 4 5 6 7])
% xticklabels({'0-20','20-50','50-100','100-200','200-500','500-1000','>1000'})
xticks([1 2 3 4 5])
xticklabels({'20-50','50-100','100-200','200-500','500-1000'})
xtickangle(45)
xlabel('Bout Length (seconds)')
hold off

sgtitle('N2 Histogram per Hour','Interpreter','none')