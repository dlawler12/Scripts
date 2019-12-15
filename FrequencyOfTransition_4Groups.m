clear all
close all
clc
cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\NewAnalysisData\SummedData')
load('SmoothedData');

% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\IndividualAnimalsFig2\AnalysisData')
% load('Smooth20_Fig2')
% 
% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\AllN2Data\NewN2')
% load('SmoothedN2')

clearvars -except Smooth20_N2_All
Smooth20_N2Comparison = Smooth20_N2_All;



%% Sort by most sleep to least sleep
[~,animalcount]=size(Smooth20_N2Comparison);
for i = 1:animalcount
    ordered(i,1)=mean(Smooth20_N2Comparison(:,i));
    ordered(i,2)=i;
end

[~,idx] = sort(ordered(:,1));
Smooth20_N2Comparison = Smooth20_N2Comparison(:,idx);

%% Split into 4 groups by their sleepiness

groupsplit = ceil(animalcount/4);

group1 = Smooth20_N2Comparison(:,1:groupsplit);
group2 = Smooth20_N2Comparison(:,groupsplit+1:groupsplit*2);
group3 = Smooth20_N2Comparison(:,groupsplit*2+1:groupsplit*3);
group4 = Smooth20_N2Comparison(:,groupsplit*3+1:end); 


splits = 12;
range = 43200/splits;
format longG

WakeToSleep = zeros(4,splits);
SleepToWake = zeros(4,splits);

startstop = [1,groupsplit;groupsplit+1,groupsplit*2;groupsplit*2+1,groupsplit*3;groupsplit*3,animalcount];
for j=1:4

    for i=1:splits
        eval(['Smooth20_N2_',int2str(i),'_',int2str(j),' = Smooth20_N2Comparison(', ...
            int2str((i-1)*range+1),':',int2str(range*i),',',int2str(startstop(j,1)),':',int2str(startstop(j,2)),');']);

        eval(['Smooth20_N2_Sub',int2str(i),' = Smooth20_N2_', ...
            int2str(i),'_',int2str(j),'(1:',int2str(range-1),',:)-Smooth20_N2_', ...
            int2str(i),'_',int2str(j),'(2:',int2str(range),',:);']);

        eval(['WTSEvents = sum(sum(Smooth20_N2_Sub',int2str(i), ...
            '(Smooth20_N2_Sub',int2str(i),'==1)));']);

        eval(['WakeEvents = sum(sum(Smooth20_N2_',int2str(i),'_',int2str(j),'==1));']);

        eval(['STWEvents = sum(sum(Smooth20_N2_Sub',int2str(i), ...
            '(Smooth20_N2_Sub',int2str(i),'==-1)));']);

        eval(['SleepEvents = sum(sum(Smooth20_N2_',int2str(i),'_',int2str(j),'==0));']);

    %     factor = 60/(WakeEvents/animals);
    %     factor2 = 60/(SleepEvents/animals);
        WakeToSleep(j,i) = WTSEvents/WakeEvents*60;
        SleepToWake(j,i) = -STWEvents/SleepEvents*60;
    end
end

%Represented by percentages


% WakeToSleep = [sum(sum(Smooth20_N2_Sub1(Smooth20_N2_Sub1==1))), ...
%     sum(sum(Smooth20_N2_Sub2(Smooth20_N2_Sub2==1))), ...
%     sum(sum(Smooth20_N2_Sub3(Smooth20_N2_Sub3==1))), ...
%     sum(sum(Smooth20_N2_Sub4(Smooth20_N2_Sub4==1)))];
% WakeToSleep = WakeToSleep./[sum(sum(Smooth20_N2_1==1)), ...
%     sum(sum(Smooth20_N2_2==1)),sum(sum(Smooth20_N2_3==1)), ...
%     sum(sum(Smooth20_N2_4==1))];
% 
% SleepToWake = [sum(sum(Smooth20_N2_Sub1(Smooth20_N2_Sub1==-1))), ...
%     sum(sum(Smooth20_N2_Sub2(Smooth20_N2_Sub2==-1))), ...
%     sum(sum(Smooth20_N2_Sub3(Smooth20_N2_Sub3==-1))), ...
%     sum(sum(Smooth20_N2_Sub4(Smooth20_N2_Sub4==-1)))];
% SleepToWake = -SleepToWake./[sum(sum(Smooth20_N2_1==0)), ...
%     sum(sum(Smooth20_N2_2==0)),sum(sum(Smooth20_N2_3==0)), ...
%     sum(sum(Smooth20_N2_4==0))];

format SHORT