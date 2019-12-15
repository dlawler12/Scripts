clear all
close all
cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\AllN2Data\NewN2');
load('corrected')
load('dataSet')

matrixSize = size(dataSet);
segments = 3600; %Split by 60 minute segments
behaviors = zeros(matrixSize(1),(matrixSize(2)-1)/segments); 
sleep = zeros(matrixSize(1),(matrixSize(2)-1)/segments);
for u = 1:(matrixSize(2)-1)/segments
    temp1=dataSet(:,(u-1)*segments+1:u*segments) > 1;
    temp2=corrected(:, (u-1)*segments+1:u*segments) == 0;
    behaviors(:,u) = sum(temp1,2);
    sleep(:,u) = sum(temp2,2);
end

for i = 1:12
    count = 1;
    for j = 1:matrixSize(1)
        if behaviors(j,i)>300
            eval(['hour',int2str(i),'(count) = sleep(j,i)/behaviors(j,i);']);
            count = count+1;
        end
    end
end
errors = zeros(1,12);
for i = 1:12
    eval(['errors(i) = std(hour',int2str(i),');']);
end