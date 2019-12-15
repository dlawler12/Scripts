clear all
cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\OldN2');
load('BrightfieldSmallArena.mat')
load('LargeArena.mat')
[S_animals,~] = size(BrightfieldSmallArena);
[L_animals,~] = size(temp);

HourlySmall = zeros(S_animals,12);
HourlyLarge = zeros(L_animals,12);

for i = 1:S_animals
    for j = 1:11
        beg = (j-1)*360+1;
        en = j*360;
        HourlySmall(i,j) = mean(mean(BrightfieldSmallArena(i,beg:en)));
    end
    j = 12;
    beg = (j-1)*360+1;
    HourlySmall(i,j) = mean(mean(BrightfieldSmallArena(i,beg:end)));
end

for i = 1:L_animals
    for j = 1:11
        beg = (j-1)*3600+1;
        en = j*3600;
        HourlyLarge(i,j) = mean(mean(temp(i,beg:en)));
    end
    j = 12;
    beg = (j-1)*3600+1;
    HourlyLarge(i,j) = mean(mean(temp(i,beg:end)));
end

HourlyLarge = 1 - HourlyLarge;
HourlySmall = 1 - HourlySmall;

MeanLarge = mean(HourlyLarge);
MeanSmall = mean(HourlySmall);
StdLarge = std(HourlyLarge);
StdSmall = std(HourlySmall);