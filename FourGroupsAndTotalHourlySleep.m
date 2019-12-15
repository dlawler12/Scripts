clear all
close all
clc
cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\NewAnalysisData\SummedData')
load('SmoothedData');
load('Raw');

clearvars -except Smooth20_N2_All Raw_N2_All



%% Sort by most sleep to least sleep
[~,animalcount]=size(Smooth20_N2_All);
for i = 1:animalcount
    ordered(i,1)=mean(Smooth20_N2_All(:,i));
    ordered(i,2)=i;
end

[~,idx] = sort(ordered(:,1));
Smooth20_N2_All = Smooth20_N2_All(:,idx);
Raw_N2_All = Raw_N2_All(:,idx);

%% Split into 4 groups by their sleepiness

groupsplit = ceil(animalcount/4);

group1 = Smooth20_N2_All(:,1:groupsplit); group1r = Raw_N2_All(:,1:groupsplit);
group2 = Smooth20_N2_All(:,groupsplit+1:groupsplit*2); group2r = Raw_N2_All(:,groupsplit+1:groupsplit*2);
group3 = Smooth20_N2_All(:,groupsplit*2+1:groupsplit*3); group3r = Raw_N2_All(:,groupsplit*2+1:groupsplit*3);
group4 = Smooth20_N2_All(:,groupsplit*3+1:end); group4r = Raw_N2_All(:,groupsplit*3+1:end);

%% Calculate hourly sleep fraction
hourlySleepFractions = zeros(12,5);
hourlySEM = zeros(12,5);
for t=0:11
    clear AllAnimals G1 G2 G3 G4 val1 val2 val3 val4 val5
    outlier = 1/12; %Exclude all data with less than x of behavior data
    hourstart = t;
    hourend = t+1;
    starting = hourstart*3600+1;
    ending = hourend*3600+1;

    AllAnimals(:,1) = sum(Raw_N2_All(starting:ending,:)  > 1);
    AllAnimals(:,2) = sum(Smooth20_N2_All(starting:ending,:) == 0);
    AllAnimals(AllAnimals(:,1)<((ending-starting)*outlier),:) = [];
    val1 = AllAnimals(:,2)./AllAnimals(:,1);
    
    G1(:,1) = sum(group1r(starting:ending,:)  > 1);
    G1(:,2) = sum(group1(starting:ending,:) == 0);
    G1(G1(:,1)<((ending-starting)*outlier),:) = [];
    val2 = G1(:,2)./G1(:,1);
    
    G2(:,1) = sum(group2r(starting:ending,:)  > 1);
    G2(:,2) = sum(group2(starting:ending,:) == 0);
    G2(G2(:,1)<((ending-starting)*outlier),:) = [];
    val3 = G2(:,2)./G2(:,1);

    G3(:,1) = sum(group3r(starting:ending,:)  > 1);
    G3(:,2) = sum(group3(starting:ending,:) == 0);
    G3(G3(:,1)<((ending-starting)*outlier),:) = [];
    val4 = G3(:,2)./G3(:,1);

    G4(:,1) = sum(group4r(starting:ending,:)  > 1);
    G4(:,2) = sum(group4(starting:ending,:) == 0);
    G4(G4(:,1)<((ending-starting)*outlier),:) = [];
    val5 = G4(:,2)./G4(:,1);
    
    hourlySleepFractions(t+1,:) = [mean(val1),mean(val2),mean(val3),mean(val4),mean(val5)];
    hourlySEM(t+1,:) = [std(val1)/sqrt(length(val1)),std(val2)/sqrt(length(val2)),std(val3)/sqrt(length(val3)),std(val4)/sqrt(length(val4)),std(val5)/sqrt(length(val5))];
end