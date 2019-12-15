clear all
close all
cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\AllN2Data\ErrorBarN2\BeforeAfter');

% cd('Z:\Dan Lawler\Projects\Sleep\Odorants\SbasalControl\190418\data');

load('corrected.mat')
load('dataSet.mat')
load('speed.mat')

%% Find start and stop positions of all sleep bouts of a given length:

boutLength = 60; %seconds
beforeTime = 60; %seconds
afterTime = 60; %seconds
matrixSize = size(dataSet);

regions = zeros(3,1);
counter = 1;

for i = 1:matrixSize(1)
    j=beforeTime+1;
    while j<(matrixSize(2)-(boutLength-1+afterTime))
        if sum(corrected(i,j:j+(boutLength-1)))==0&&sum(corrected(i,j-boutLength:j-1))==boutLength
            t=j;
            while(t<(matrixSize(2)-afterTime) && corrected(i,t)<1)
                t = t+1;
            end
            if t < (matrixSize(2)-afterTime)&&sum(corrected(i,t+1:t+boutLength))==boutLength
                regions(:,counter) = [i;j;t];
                counter = counter+1;
            end
            j=t;
        end
        j=j+1;
    end
end
%% if you only count fwd
fwd = dataSet == 2;
speed = speed .* fwd;

%% Combine OmF and F
dataSet(dataSet==6)=2;

%%
regionSize = size(regions);
beforeMatrix = zeros(regionSize(2),beforeTime);
afterMatrix = zeros(regionSize(2),afterTime);
beforeMatrixCheck = zeros(regionSize(2),beforeTime);
afterMatrixCheck = zeros(regionSize(2),afterTime);
duringMatrixfirst30 = zeros(regionSize(2),30);
duringMatrixlast30 = zeros(regionSize(2),30);
beforeSpeed = zeros(regionSize(2),beforeTime);
afterSpeed = zeros(regionSize(2),afterTime);

for n = 1:regionSize(2)
    beforeMatrix(n,:)=dataSet(regions(1,n),regions(2,n)-beforeTime:regions(2,n)-1);
    afterMatrix(n,:)=dataSet(regions(1,n),regions(3,n)+1:regions(3,n)+afterTime);
    beforeMatrixCheck(n,:)=corrected(regions(1,n),regions(2,n)-beforeTime:regions(2,n)-1);
    afterMatrixCheck(n,:)=corrected(regions(1,n),regions(3,n)+1:regions(3,n)+afterTime);
    beforeSpeed(n,:)=speed(regions(1,n),regions(2,n)-beforeTime:regions(2,n)-1);
    afterSpeed(n,:)=speed(regions(1,n),regions(3,n)+1:regions(3,n)+afterTime);
    duringMatrixfirst30(n,:)=dataSet(regions(1,n),regions(2,n):regions(2,n)+29);
    duringMatrixlast30(n,:)=dataSet(regions(1,n),regions(3,n)-29:regions(3,n));

end

beforeSummary = zeros(7,beforeTime);
afterSummary = zeros(7,afterTime);
beforeCheck = zeros(2,beforeTime);
afterCheck = zeros(2,afterTime);
beforeSpSummary = zeros(1,beforeTime);
afterSpSummary = zeros(1,afterTime);



for u=0:6
    for p=1:beforeTime
        beforeSummary(u+1,p)=sum(beforeMatrix(:,p)==u);
        afterSummary(u+1,p)=sum(afterMatrix(:,p)==u);
    end
end

for q = 1:beforeTime
    beforeSpSummary(q)=mean(beforeSpeed(:,q));
    afterSpSummary(q)=mean(afterSpeed(:,q));
    
    %Normalize to # of behaviors
    
    beforeSpSummary(q)=beforeSpSummary(q)/(beforeSummary(3,q)/regionSize(2));
    afterSpSummary(q)=afterSpSummary(q)/(afterSummary(3,q)/regionSize(2));
end

for y = 0:1
    for g = 1:beforeTime
        beforeCheck(y+1,g)=sum(beforeMatrixCheck(:,g)==y);
        afterCheck(y+1,g)=sum(afterMatrixCheck(:,g)==y);
    end
end
%% Find sets that have no unknowns
% unknownbefore=beforeMatrix<2;
% unknownafter=afterMatrix<2;
% unknown=[beforeMatrix<2,duringMatrixfirst30<2,duringMatrixlast30<2,afterMatrix<2];
unknown=[beforeMatrix<2,afterMatrix<2];
unknowncount=1;
knownBefore=zeros(1,beforeTime);
knownAfter=zeros(1,afterTime);
knownFirst=zeros(1,30);
knownLast=zeros(1,30);
for e=1:regionSize(2)
%     if (sum(unknownbefore(e,:))+sum(unknownafter(e,:)))==0
    if sum(unknown(e,:))<10
        knownBefore(unknowncount,:)=beforeMatrix(e,:);
        knownAfter(unknowncount,:)=afterMatrix(e,:);
        knownFirst(unknowncount,:)=duringMatrixfirst30(e,:);
        knownLast(unknowncount,:)=duringMatrixlast30(e,:);
        unknowncount=unknowncount+1;
    end
end


%% Grab n random animals
n=100;
randBefore=zeros(n,beforeTime);
randAfter=zeros(n,afterTime);
firstMiddle=zeros(n,30);
lastMiddle=zeros(n,30);
rval=0;
used = zeros(1,1);
for v=1:n
    i=1;
    while i == 1
        rval=randi(unknowncount-1);
        if ismember(rval,used)
        
        else
            used(v)=rval;
            i=0; 
        end
    end
    randBefore(v,:)=knownBefore(rval,:);
    randAfter(v,:)=knownAfter(rval,:);
    firstMiddle(v,:)=knownFirst(rval,:);
    lastMiddle(v,:)=knownLast(rval,:);
end

%Sort by most sleep to least
sortfile=zeros(n,2);
for a = 1:n
    sortfile(a,1)=mean(randBefore(a,:));
    sortfile(a,2)=n;
end
[~,idx] = sort(sortfile(:,1));
randBefore=randBefore(idx,:);


%Sort by most sleep to least
sortfile=zeros(n,2);
for a = 1:n
    sortfile(a,1)=mean(randAfter(a,:));
    sortfile(a,2)=n;
end
[~,idx] = sort(sortfile(:,1));
randAfter=randAfter(idx,:);
    
    
spacer=zeros(n,8);
% allrand=[randBefore,spacer,firstMiddle,spacer,lastMiddle,spacer,randAfter];
allrand=[randBefore,spacer,randAfter];
% cmap = [1 1 1; 0.9 0.9 0.9; .7 .7 .7; .3 .3 .3; 0 0 0; .6 0 0; 1 .2 .2];
cmap = [1 1 1; 0.9 0.9 0.9; .7 .7 .7; .3 .3 .3; 0 0 0; .6 0 0];
colormap(cmap)
heatmap(allrand)
set(gca,'Visible','off')
