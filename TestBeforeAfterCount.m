clear all
close all
cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\AllN2Data\ErrorBarN2\BeforeAfter');

% cd('Z:\Dan Lawler\Projects\Sleep\Odorants\SbasalControl\190418\data');

load('corrected.mat')

%% Find start and stop positions of all sleep bouts of a given length:

boutLength = 60; %seconds
beforeTime = 60; %seconds
afterTime = 60; %seconds
matrixSize = size(corrected);

counter = 0;
before = 0;
after = 0;

for i = 1:matrixSize(1)
    j=beforeTime+1;
    while j<(matrixSize(2)-(boutLength-1+afterTime))
        if sum(corrected(i,j:j+(boutLength-1)))==0
            t=j;
            while(t<(matrixSize(2)-afterTime) && corrected(i,t)<1)
                t = t+1;
            end
            if t < (matrixSize(2)-afterTime)
                if sum(corrected(i,j-boutLength:j-1))~=boutLength
                    before=before+1;
                end
                if sum(corrected(i,t+1:t+boutLength))~=boutLength
                    after = after+1;
                end
                counter = counter+1;
            end
            j=t;
        end
        j=j+1;
    end
end