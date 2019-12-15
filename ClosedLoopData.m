clear all
close all
clc
cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\ClosedLoopData\AIB')
% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\ClosedLoopData')
load('TimeLapseCount.mat');
load('TimeLapseData.mat');
load('TimeLapseData2.mat');
% TimeLapse = TimeLapse/max(max(TimeLapse));
% TimeLapse2 = TimeLapse2/max(max(TimeLapse2));


[maxframes,pulses] = size(TimeLapse);

pulses = pulses-1; %skim off bad set

for i=1:maxframes
    for j=1:pulses
        if (TimeLapse(i,j)<0.5&&TimeLapse2(i,j)<0.5)
            TimeLapse(i,j)=0;
        else
            TimeLapse(i,j)=1;
        end
    end
end
% TimeLapseCount = TimeLapseCount-1; %maybe shift is off?
% TotalTimeLapse = zeros(4318,1);
TotalTimeLapse(1:TimeLapseCount(1))=TimeLapse(1:TimeLapseCount(1),1);
for i = 2:pulses
    beg = sum(TimeLapseCount(1:i-1))+92*(i-1)+1;
    en = beg + TimeLapseCount(i) - 1;
    TotalTimeLapse(beg-93:beg-1) = 2;
    TotalTimeLapse(beg-99:beg-94) = mod(i,2)+3;
    TotalTimeLapse(beg-93:beg-91) = mod(i,2)+5;
    TotalTimeLapse(beg:en) = TimeLapse(1:TimeLapseCount(i),i);
end

[~,ii] = sort(TimeLapseCount);
out = TimeLapseCount(ii([2,end-1]));

AlignedTimeLapse=zeros(pulses-1,out(2)+3)-1;
% Sleep = [-2,-2,-2,-2,-2,-2,-4,-4,-4];
% Sleep = [-2,-2,-2,-2,-2,-2];
% Awake = Sleep - 1;
Sleep = [0,0,0,0,0,0]; % these two lines for new no-color dual timelapse
Awake = Sleep +1;

for i = 1:pulses-1
    blank = out(2)+2-TimeLapseCount(i);
    AlignedTimeLapse(i,blank:end-3) = transpose(TimeLapse(1: ...
        TimeLapseCount(i)-1,i));
    if mod(i,2)==1
        AlignedTimeLapse(i,out(2)-2:end) = Sleep;
    else
        AlignedTimeLapse(i,out(2)-2:end) = Awake;
    end
    
end

plot(TotalTimeLapse)

TotalTimeLapse(4319:4320) = 2;
for i = 1:12
    HourTL(i,:) = TotalTimeLapse((i-1)*360+1:i*360);
end
% map = [1,0,0;0,0,1;1,.8,.8;0,0,.5;1,1,1;0,0,0;.5,.5,.5];
% map2 = [1,0,0;0,0,1;1,.8,.8;0,0,.5;.5,.5,.5;0,0,0;1,1,1];
map = [1,.8,.8;0,0,.5;1,1,1;0,0,0;.5,.5,.5];
map2 = [1,.8,.8;0,0,.5;.5,.5,.5;0,0,0;1,1,1];

map3 = [1,1,1;0,0,0;.5,.5,.5];

HourTL(HourTL<0.125)=0; %short sleep (black)
HourTL(HourTL==2)=-1; %no data (white)
HourTL(HourTL==3)=-2; %sleep precursor (light blue)
HourTL(HourTL==4)=-3; %wake precursor (light red)
HourTL(HourTL==5)=-4; %sleep pulse (blue)
HourTL(HourTL==6)=-5; %wake pulse (red)
HourTL(HourTL>0)=1; %short awake (gray)

TotalTimeLapse(TotalTimeLapse<0.125)=0; %short sleep (black)
TotalTimeLapse(TotalTimeLapse==2)=-1; %no data (white)
TotalTimeLapse(TotalTimeLapse==3)=-2; %sleep precursor (light blue)
TotalTimeLapse(TotalTimeLapse==4)=-3; %wake precursor (light red)
% TotalTimeLapse(TotalTimeLapse==5)=-4; %sleep pulse (blue)
% TotalTimeLapse(TotalTimeLapse==6)=-5; %wake pulse (red)
TotalTimeLapse(TotalTimeLapse==5)=-1; %sleep pulse (blue)
TotalTimeLapse(TotalTimeLapse==6)=-1; %wake pulse (red)
TotalTimeLapse(TotalTimeLapse>0)=1; %short awake (gray)

DualShiftTimeLapse = zeros(22,70)-1;
for i = 1:22
    if mod(i,2) == 1
        DualShiftTimeLapse((i+1),1:33)=AlignedTimeLapse(i,end-32:end);
    else
        DualShiftTimeLapse(i,end-32:end)=AlignedTimeLapse(i,end-32:end);
    end
end

figure
colormap(map)
heatmap(HourTL)
set(gca,'Visible','off')
figure
colormap(map)
heatmap(AlignedTimeLapse)
set(gca,'Visible','off')
figure
colormap(map)
heatmap(TotalTimeLapse)
set(gca,'Visible','off')
figure
colormap(map2)
heatmap(HourTL)
set(gca,'Visible','off')
figure
colormap(map2)
heatmap(AlignedTimeLapse)
set(gca,'Visible','off')
figure
colormap(map3)
heatmap(DualShiftTimeLapse)
set(gca,'Visible','off')