clear all
close all
clc
cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\NewAnalysisData\SummedData');
load('SmoothedData');
% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\AllN2Data\NewN2');
% load('corrected.mat')
clearvars -except Smooth20_N2_All
corrected=Smooth20_N2_All;


%% Sort by most sleep to least sleep
[~,animalcount]=size(corrected);
for i = 1:animalcount
    ordered(i,1)=mean(corrected(:,i));
    ordered(i,2)=i;
end

[~,idx] = sort(ordered(:,1));
corrected = corrected(:,idx);

%% Split into 4 groups by their sleepiness

splits = ceil(animalcount/4);

group1 = corrected(:,1:splits);
group2 = corrected(:,splits+1:splits*2);
group3 = corrected(:,splits*2+1:splits*3);
group4 = corrected(:,splits*3+1:end);

group1 = corrected;


%% Calculate sleep bout lengths
for a = 1:4
    
    mediangroup = 0; currentGroup = 0; countMatrix = 0; counter = 0;
    eval(['currentGroup=group',int2str(a),';']);
    [~,animalsInGroup,] = size(currentGroup);
    countMatrix = zeros(43201,animalsInGroup);
        
    for i = 1:animalsInGroup
        count = 0;
        for j = 1:43201
            if currentGroup(j,i)==0
                count=count+1;
                countMatrix(j,i)=count;
            else
                count=0;
            end
        end
    end
    
    for e = 1:animalsInGroup
        for g = 1:43200
            if(countMatrix(g+1,e)<countMatrix(g,e))
                if countMatrix(g,e)>20
                    mediangroup(counter+1)=countMatrix(g,e);
                    counter=counter+1;
                end
            end
        end
    end
    g=43201;
    for o = 1:animalsInGroup
        if countMatrix(g,o)>20
            mediangroup(counter+1)=countMatrix(g,o);
            counter=counter+1;
        end
    end
    eval(['sleepMedianGroup',int2str(a),'=mediangroup;']);
end

%% Calculate awake bout lengths
for a = 1:4
    
    mediangroup = 0; currentGroup = 0; countMatrix = 0; counter = 0;
    eval(['currentGroup=group',int2str(a),';']);
    [~,animalsInGroup,] = size(currentGroup);
    countMatrix = zeros(43201,animalsInGroup);
        
    for i = 1:animalsInGroup
        count = 0;
        for j = 1:43201
            if currentGroup(j,i)==1
                count=count+1;
                countMatrix(j,i)=count;
            else
                count=0;
            end
        end
    end
    
    for e = 1:animalsInGroup
        for g = 1:43200
            if(countMatrix(g+1,e)<countMatrix(g,e))
                if countMatrix(g,e)>20
                    mediangroup(counter+1)=countMatrix(g,e);
                    counter=counter+1;
                end
            end
        end
    end
    g=43201;
    for o = 1:animalsInGroup
        if countMatrix(g,o)>20
            mediangroup(counter+1)=countMatrix(g,o);
            counter=counter+1;
        end
    end
    eval(['awakeMedianGroup',int2str(a),'=mediangroup;']);
end