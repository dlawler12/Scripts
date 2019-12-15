close all
clc
cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\NewAnalysisData\SummedData')
load('Raw')
load('SmoothedData')
clearvars -except Smooth20_N2_All Raw_N2_All
[~,animals]=size(Raw_N2_All);
SF = NaN(animals,12);
% for t = 0:11
    clearvars -except Smooth20_N2_All Raw_N2_All SF animals t
    outlier = 1/12; %Exclude all data with less than x of behavior data
    hourstart = t;
    hourend = t+1;
%     hourstart = 0;
%     hourend = 12;
    starting = hourstart*3600+1;
    ending = hourend*3600+1;

    N2_Ind(:,1) = sum(Raw_N2_All(starting:ending,:)  > 1);
    N2_Ind(:,2) = sum(Smooth20_N2_All(starting:ending,:) == 0);
    N2_Ind(N2_Ind(:,1)<((ending-starting)*outlier),:) = [];
    val1 = N2_Ind(:,2)./N2_Ind(:,1);
    binsize = 2; %value in decimal points
    val1 = round(val1,binsize);
    val1 = sort(val1);
    SF(1:length(val1),t+1) = val1;
% end