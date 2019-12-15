clear all
close all
clc
cd('Z:\Dan Lawler\Projects\Sleep\Stimulations\RIS\6-20-19\DanRISTest25msExposure2fps_2')
files = dir('*.txt');
minVal=0;
maxVal=0;
totalTimecourse = zeros(60,1);
allTimecourse = zeros(60,length(files));
totalMovement = zeros(59,1);
allIntegrated = zeros(60,length(files));
for i = 1:length(files)
    all=load(files(i).name);
    minVal = min(all(1:10,11));
    maxVal = max(all(:,11));
    integratedData = all(:,11);
    xy = all(:,2:3);
    movementFile = zeros(59,1);
    for j = 1:59
        movementFile(j) = sqrt((xy(j,1)-xy(j+1,1))^2+(xy(j,2)-xy(j+1,2))^2);
    end
    allTimecourse(:,i)=integratedData;
    integratedData=integratedData-minVal;
    integratedData = integratedData/(maxVal-minVal);
    allIntegrated(:,i)=integratedData;
    totalTimecourse = totalTimecourse + integratedData;   
    totalMovement = totalMovement + movementFile;
end
averageTimecourse = totalTimecourse/i;
averageMovement = totalMovement/i;
% plot(averageTimecourse)
% figure
% plot(averageMovement)
semIntegrated=zeros(60,1);
for i = 1:60
    semIntegrated(i)=std(allIntegrated(i,:))/sqrt(length(files));
end

allIntegrated(allIntegrated<0)=NaN;

colormap([.7 .7 .7; jet(254)]);
caxis([0 1])
heatmap(allIntegrated')