clear all
close all
clc
cd('Z:\Dan Lawler\Projects\Sleep\Odorants\SbasalControl\181219-NoFlow\data');
% load('Smoothed.mat')
% data = Smooth20_SBControl190418;

load('corrected')
load('dataSet')

%% Find start and stop positions of all sleep bouts of a given length:

boutLength = 20; %seconds
% beforeTime = 20; %seconds
% afterTime = 5; %seconds
matrixSize = size(dataSet);

regions = zeros(3,1);
counter = 1;

for i = 1:matrixSize(1)
%     j=beforeTime+1;
    j=1;
%     while j<(matrixSize(2)-(boutLength-1+afterTime))
    while j<(matrixSize(2)-(boutLength-1))
        if sum(corrected(i,j:j+(boutLength-1)))==0
            t=j;
%             while(t<(matrixSize(2)-afterTime) && corrected(i,t)<1)
            while(t<matrixSize(2) && corrected(i,t)<1)
                t = t+1;
            end
%             if t < (matrixSize(2)-afterTime)
            regions(:,counter) = [i;j;t];
            counter = counter+1;
%             end
            j=t;
        end
        j=j+1;
    end
end

data = ones(matrixSize);

for h = 1:length(regions)
    data(regions(1,h),regions(2,h):regions(3,h))=0;
%     data(regions(1,h),regions(2,h)-19:regions(2,h)-1)=-2;
%     data(regions(1,h),regions(2,h):regions(3,h)-20)=0; %To Take Away After Behavior
%     data(regions(1,h),regions(3,h)-19:regions(3,h))=-1;
end

data = transpose(data);

cd('Z:\Dan Lawler\Projects\Sleep\Odorants\SbasalControl\181219-NoFlow');
filename = '20181219T160627.avi';
load('Combined.mat');
d=4;
positionsX = TimeAnalysis(1).X; %For full arena data
positionsY = TimeAnalysis(1).Y;
if d>1
    for w=2:d
        positionsX = [positionsX;TimeAnalysis(w).X];
        positionsY = [positionsY;TimeAnalysis(w).Y];
    end
end

framewriterate = 1;

[~,datasize] = size(data);

% circles = zeros (1,4);
circles = zeros (1,3);
framescounter=zeros(matrixSize(2)/framewriterate,1);
counter=1;
for j = 1:matrixSize(2)/framewriterate
    for i = 1:datasize
        if data(j*framewriterate,i)<1 && ~isnan(positionsX(i,j*framewriterate))
%             circles(counter,:)=[positionsX(i,j*framewriterate),positionsY(i,j*framewriterate),10,data(j*framewriterate,i)];
            circles(counter,:)=[positionsX(i,j*framewriterate),positionsY(i,j*framewriterate),10];
            framescounter(j)=framescounter(j)+1;
            counter=counter+1;
        end
    end
end

outputVideo = VideoWriter('NoFlowExampleVideoAllBlue.avi','MPEG-4');
open(outputVideo)
SBCtrl = VideoReader(filename);

while hasFrame(SBCtrl)
%     I = uint8(readFrame(SBCtrl));
    I = readFrame(SBCtrl);
%     I = step(video);
    frame = round(SBCtrl.CurrentTime*30);
    roundedframe = frame/framewriterate;
    if(mod(roundedframe,1)==0)
        if framescounter(roundedframe)>0
            if(roundedframe == 1)
                start = 1;
                stop = framescounter(1);
            else
                start = sum(framescounter(1:roundedframe-1))+1;
                stop = sum(framescounter(1:roundedframe));
            end
%             temp = circles(start:stop,:);
%             [tempsize,~]=size(temp);
%             count = 0;
%             RBG=I;
%             if ismember(-2,temp(:,4))
%                 for i = 1:tempsize
%                     if temp(i,4)==-2
%                         temppre(count+1,:)=temp(i,1:3);
%                         count=count+1;
%                     end
%                 end
%             RBG = insertShape(RBG,'Circle',temppre,'Color','green','LineWidth',5);
%             end
%             count = 0;
%             if ismember(-1,temp(:,4))
%                 for i = 1:tempsize
%                     if temp(i,4)==-1
%                         temppost(count+1,:)=temp(i,1:3);
%                         count=count+1;
%                     end
%                 end
%             RBG = insertShape(RBG,'Circle',temppost,'Color','red','LineWidth',5);                
%             end
%             count = 0;
%             if ismember(0,temp(:,4))
%                 for i = 1:tempsize
%                     if temp(i,4)==0
%                         tempduring(count+1,:)=temp(i,1:3);
%                         count=count+1;
%                     end
%                 end
%             RBG = insertShape(RBG,'Circle',tempduring,'Color','blue','LineWidth',5);                
%             end            
            RBG = insertShape(I,'Circle',circles(start:stop,:),'Color','red','LineWidth',5);
            imshow(RBG)
            writeVideo(outputVideo,RBG);
%             clear temp temppre tempduring temppost tempsize
        else
            imshow(I)
            writeVideo(outputVideo,I);
        end
       
    end
end

close(outputVideo);