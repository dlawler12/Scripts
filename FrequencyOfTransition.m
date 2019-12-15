clear all
close all
clc
cd('Z:\Dan Lawler\Projects\Sleep\Beh Device')
load('SmoothedData');
load('Raw');

onemat = ones(size(Smooth20_Frpr3));
temp = double(Smooth20_Frpr3==3);
Smooth20_N2=onemat-temp;
Raw_N2=Raw_Frpr3;

% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\IndividualAnimalsFig2\AnalysisData')
% load('Smooth20_Fig2')
% 
% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\AllN2Data\NewN2')
% load('SmoothedN2')

splits = 12;
range = 43200/splits;
format longG

WakeToSleep = zeros(1,splits);
SleepToWake = zeros(1,splits);

Smooth20_N2Comparison = Smooth20_N2;
% Smooth20_N2Comparison = Smooth20_N2_NoFlow;

[~,animals] = size(Smooth20_N2Comparison);

N2Sub = Smooth20_N2(1:43199,:)-Smooth20_N2(2:43200,:);
% NoFlowSub = Smooth20_N2_NoFlow(1:43199,:)-Smooth20_N2_NoFlow(2:43200,:);

WTSN2 = sum(N2Sub == 1);
% WTSNF = sum(NoFlowSub == 1);

WakeN2 = sum(Smooth20_N2 == 1);
% WakeNF = sum(Smooth20_N2_NoFlow == 1);

STWN2 = sum(N2Sub == -1);
% STWNF = sum(NoFlowSub == -1);

SleepN2 = sum(Smooth20_N2 == 0);
% SleepNF = sum(Smooth20_N2_NoFlow == 0);

% [~,animals2] = size(Smooth20_N2_NoFlow);
WakeToSleepN2 = zeros(animals,1);
SleepToWakeN2 = zeros(animals,1);
% WakeToSleepNF = zeros(animals2,1);
% SleepToWakeNF = zeros(animals2,1);
RawsN2 = zeros(animals,1);
% RawsNF = zeros(animals2,1);
counter1=1;
counter2=1;
for i=1:animals
    WakeToSleepN2(i) = WTSN2(i)/WakeN2(i)*60;
    SleepToWakeN2(i) = STWN2(i)/SleepN2(i)*60;
    RawsN2(i) = sum(Raw_N2(:,i)>1);
    if(RawsN2(i)>3600)
        ResultsN2(counter1,:)=[WakeToSleepN2(i),SleepToWakeN2(i)];
        counter1=counter1+1;
    end
end
% for i=1:animals2
%     WakeToSleepNF(i) = WTSNF(i)/WakeNF(i)*60;
%     SleepToWakeNF(i) = STWNF(i)/SleepNF(i)*60;
%     RawsNF(i) = sum(Raw_N2_NoFlow(:,i)>1);
%     if(RawsNF(i)>3600)
%         ResultsNF(counter2,:)=[WakeToSleepNF(i),SleepToWakeNF(i)];
%         counter2=counter2+1;
%     end
% end


for i=1:splits
    eval(['Smooth20_N2_',int2str(i),' = Smooth20_N2Comparison(', ...
        int2str((i-1)*range+1),':',int2str(range*i),',:);']);
    
    eval(['Smooth20_N2_Sub',int2str(i),' = Smooth20_N2_', ...
        int2str(i),'(1:',int2str(range-1),',:)-Smooth20_N2_', ...
        int2str(i),'(2:',int2str(range),',:);']);
    
    eval(['WTSEvents = sum(sum(Smooth20_N2_Sub',int2str(i), ...
        '(Smooth20_N2_Sub',int2str(i),'==1)));']);
    
    eval(['WakeEvents = sum(sum(Smooth20_N2_',int2str(i),'==1));']);
    
    eval(['STWEvents = sum(sum(Smooth20_N2_Sub',int2str(i), ...
        '(Smooth20_N2_Sub',int2str(i),'==-1)));']);
    
    eval(['SleepEvents = sum(sum(Smooth20_N2_',int2str(i),'==0));']);
    
%     factor = 60/(WakeEvents/animals);
%     factor2 = 60/(SleepEvents/animals);
    WakeToSleep(i) = WTSEvents/WakeEvents*60;
    SleepToWake(i) = -STWEvents/SleepEvents*60;
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