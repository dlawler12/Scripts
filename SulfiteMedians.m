clear all
close all
clc
cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\NewAnalysisData\SummedData');
load('SmoothedData');
corrected=Smooth20_N2_SodiumSulfate30mM;
% corrected=Smooth20_SodiumSulfite30mM4CoreWithoutCorrection;
[~,animalcount]=size(corrected);

    
    mediangroup = 0; currentGroup = 0; countMatrix = 0; counter = 0;
    currentGroup=corrected;
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
    sleepMedianGroup=mediangroup;

%% Calculate awake bout lengths
    
    mediangroup = 0; currentGroup = 0; countMatrix = 0; counter = 0;
    currentGroup=corrected;
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
    awakeMedianGroup=mediangroup;