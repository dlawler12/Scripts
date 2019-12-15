% Works after you run Neural Imaging Summary based on raw neuron position
close all

%% Take in positions
position = raw(:,2:3,:);
for i = 1:numfiles
    for j = 1:299-1
        diffs(j,i)=sqrt((position(j,1,i)-position(j+1,1,i))^2+(position(j,2,i)-position(j+1,2,i))^2);
    end
end
tdiffs=transpose(diffs);

tdiffs=tdiffs*4;

%% Sort by average movement in first 5 seconds
for k = 1:numfiles
    firstfive(k,1)=mean(tdiffs(k,1:50));
    firstfive(k,2)=k;
end

[~,idx] = sort(firstfive(:,1));
sortedfive = firstfive(idx,:);

%% Set up a cap for pixel change and a peak color
newvalues = tdiffs(idx,:);
cap = 40;
% cap = 10;
newvalues(newvalues>cap)=cap;

c = copper;
%specify here what the upper color bound at 10 pixels will be:
upper = [252/255,85/255,13/255]; % Burnt Orange

%% Create non-linear color scale

%create a linear path between the top of copper to the upper color (1/10th
%is copper)
cop = 10; % designates as 1/10th of the data being copper
move = (upper-c(end,:))/(64*(cop-1));
map = zeros(64*cop,3);
map(1:64,:)=c;

for i = 65:cop*64
    map(i,:)=map(i-1,:)+move;
end
colormap(map)
% caxis([0,10])
heatmap(newvalues);
% heatmap(newvalues,'GridVisible','off','Colormap',copper);


% colormap gray
% 
% cdata = transpose(a);
% xvalues = 1:12;
% yvalues = 1:97;
% h = heatmap(cdata);
% 
% h.Title = 'Flow Rate Effect on Sleep Frequency';
% h.XLabel = 'Hour';
% h.YLabel = 'Animal Number';
% 
% spacer = ones(43201,10);
% % spacer(spacer==0)=0.93;
% test=[Smooth20_N2_Diacetyl1,Smooth20_N2_Diacetyl2,spacer,Smooth20_Mec4_Diacetyl1,Smooth20_Mec4_Diacetyl2,spacer,Smooth20_Tax4_Diacetyl1,Smooth20_Tax4_Diacetyl2,spacer,Smooth20_Odr10_Diacetyl1,Smooth20_Odr10_Diacetyl2];
% colormap gray
% heatmap(transpose(test))