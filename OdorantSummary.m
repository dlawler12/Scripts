clear all
close all
clc
% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\AnalyzedDataSets')
% load('SmoothedData')
% load('SummaryData')
% load('NewN2Smoothed')
% load('SmoothedDataDiacetyl')
% load('Smooth20_N2Comparison')
% load('SmoothedSulfiteNew')
% load('SummarySulfiteNew')
% load('Summary20_N2Comparison')
% load('SummaryDataDiacetyl')
% 
% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\AllN2Data\NewN2')
% load('SmoothedN2')

cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\NewAnalysisData\SummedData')
load('SmoothedData')
load('SummaryData')

%ShortenNames
SBasal = Smooth20_N2_All; %1
SBasal_ = SummaryData20_N2_All; %1

Diacetyl = Smooth20_N2_Diacetyl10e_7; %2
Diacetyl_ = SummaryData20_N2_Diacetyl10e_7; %2

NA22 = Smooth20_N2_NA22_OD600_0; %3
NA22_ = SummaryData20_N2_NA22_OD600_0; %3

Serotonin = Smooth20_N2_Serotonin10uM; %4
Serotonin_ = SummaryData20_N2_Serotonin10uM; %4


% Sulfite = Smooth20_N2_SodiumSulfite30mM; %5
Sulfite = Smooth20_SodiumSulfite30mM4CoreWithoutCorrection; %5
Sulfite_ = SummaryData20_SodiumSulfite30mM4CoreWithoutCorrection; %5


Sulfate = Smooth20_N2_SodiumSulfate30mM; %6
Sulfate_ = SummaryData20_N2_SodiumSulfate30mM; %6


NoFlow = Smooth20_N2_NoFlow; %7
NoFlow_ = SummaryData20_N2_NoFlow; %7


OnOffFlow = Smooth20_N2_OnOffFlow; %8
OnOffFlow_ = SummaryData20_N2_OnOffFlow; %8


D_N2 = Smooth20_N2_CombinedTestOnly_Diacetyl10e_7; %1
D_N2_ = SummaryData20_N2_CombinedTestOnly_Diacetyl10e_7; %1

D_Mec4 = Smooth20_Mec4_Diacetyl10e_7; %2
D_Mec4_ = SummaryData20_Mec4_Diacetyl10e_7; %2

D_Tax4 = Smooth20_Tax4_Diacetyl10e_7; %3
D_Tax4_ = SummaryData20_Tax4_Diacetyl10e_7; %3

D_Odr10 = Smooth20_Odr10_Diacetyl10e_7; %4
D_Odr10_ = SummaryData20_Odr10_Diacetyl10e_7; %4

% Food_N2 = Smooth20_SBControl190418;
Food_N2 = Smooth20_N2Comparison;
Food_N2_ = SummaryData20_N2Comparison;

Food_NA22 = NA22;
Food_NA22_ = NA22_;

Food_Serotonin = Serotonin;
Food_Serotonin_ = Serotonin_;

Food_Diacetyl = Smooth20_CombinedDiacetyl190129;
Food_Diacetyl_ = SummaryData20_CombinedDiacetyl190129;

cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\ManuscriptNewExperiments')
load('SmoothedData')
load('SummaryData')

Hour0 = Smooth20_0HourStarvation;
Hour0_ = SummaryData20_0HourStarvation;

Hour2 = Smooth20_2HourStarvation;
Hour2_ = SummaryData20_2HourStarvation;

Hour4 = Smooth20_4HourStarvation;
Hour4_ = SummaryData20_4HourStarvation;

Hour8 = Smooth20_8HourStarvation;
Hour8_ = SummaryData20_8HourStarvation;


    [~,animals] = size(Food_N2);

    test = transpose(Food_N2);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(test(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    test=test(idx,:);
    Food_N2 = transpose(test);


%% Sort Everything
    SBasal = transpose(SBasal);
    [animals,~] = size(SBasal);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(SBasal(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    SBasal=SBasal(idx,:);
    SBasal = transpose(SBasal);

    Diacetyl = transpose(Diacetyl);
    [animals,~] = size(Diacetyl);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(Diacetyl(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    Diacetyl=Diacetyl(idx,:);
    Diacetyl = transpose(Diacetyl);
    
    NA22 = transpose(NA22);
    [animals,~] = size(NA22);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(NA22(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    NA22=NA22(idx,:);
    NA22 = transpose(NA22);
    
    Serotonin = transpose(Serotonin);
    [animals,~] = size(Serotonin);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(Serotonin(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    Serotonin=Serotonin(idx,:);
    Serotonin = transpose(Serotonin);
    
    Sulfite = transpose(Sulfite);
    [animals,~] = size(Sulfite);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(Sulfite(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    Sulfite=Sulfite(idx,:);
    Sulfite = transpose(Sulfite);
    
    Sulfate = transpose(Sulfate);
    [animals,~] = size(Sulfate);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(Sulfate(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    Sulfate=Sulfate(idx,:);
    Sulfate = transpose(Sulfate);
    
    NoFlow = transpose(NoFlow);
    [animals,~] = size(NoFlow);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(NoFlow(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    NoFlow=NoFlow(idx,:);
    NoFlow = transpose(NoFlow);
    
    OnOffFlow = transpose(OnOffFlow);
    [animals,~] = size(OnOffFlow);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(OnOffFlow(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    OnOffFlow=OnOffFlow(idx,:);
    OnOffFlow = transpose(OnOffFlow);
    
    D_N2 = transpose(D_N2);
    [animals,~] = size(D_N2);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(D_N2(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    D_N2=D_N2(idx,:);
    D_N2 = transpose(D_N2);    
    
    D_Mec4 = transpose(D_Mec4);
    [animals,~] = size(D_Mec4);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(D_Mec4(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    D_Mec4=D_Mec4(idx,:);
    D_Mec4 = transpose(D_Mec4);    

    D_Tax4 = transpose(D_Tax4);
    [animals,~] = size(D_Tax4);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(D_Tax4(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    D_Tax4=D_Tax4(idx,:);
    D_Tax4 = transpose(D_Tax4);   

    D_Odr10 = transpose(D_Odr10);
    [animals,~] = size(D_Odr10);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(D_Odr10(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    D_Odr10=D_Odr10(idx,:);
    D_Odr10 = transpose(D_Odr10);
    
    Food_N2 = transpose(Food_N2);
    [animals,~] = size(Food_N2);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(Food_N2(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    Food_N2=Food_N2(idx,:);
    Food_N2 = transpose(Food_N2); 
    
    Food_NA22 = transpose(Food_NA22);
    [animals,~] = size(Food_NA22);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(Food_NA22(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    Food_NA22=Food_NA22(idx,:);
    Food_NA22 = transpose(Food_NA22); 
    
    Food_Serotonin = transpose(Food_Serotonin);
    [animals,~] = size(Food_Serotonin);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(Food_Serotonin(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    Food_Serotonin=Food_Serotonin(idx,:);
    Food_Serotonin = transpose(Food_Serotonin); 
    
    Food_Diacetyl = transpose(Food_Diacetyl);
    [animals,~] = size(Food_Diacetyl);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(Food_Diacetyl(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    Food_Diacetyl=Food_Diacetyl(idx,:);
    Food_Diacetyl = transpose(Food_Diacetyl);     
%% Time Course
%timecourse
spbin = 4; %4 will make it 1 hour at a time
basalminutebin = zeros(48/spbin,8);
dibined = zeros(48/spbin,4);
fobined = zeros(48/spbin,4);
stbined = zeros(48/spbin,4);
for t = 1:48/spbin
    
    
    basalminutebin(t,1)=sum(SBasal_(3,spbin*(t-1)+1:spbin*t))/sum(SBasal_(1,spbin*(t-1)+1:spbin*t));
    basalminutebin(t,2)=sum(Diacetyl_(3,spbin*(t-1)+1:spbin*t))/sum(Diacetyl_(1,spbin*(t-1)+1:spbin*t));
    basalminutebin(t,3)=sum(NA22_(3,spbin*(t-1)+1:spbin*t))/sum(NA22_(1,spbin*(t-1)+1:spbin*t));
    basalminutebin(t,4)=sum(Serotonin_(3,spbin*(t-1)+1:spbin*t))/sum(Serotonin_(1,spbin*(t-1)+1:spbin*t));
    basalminutebin(t,5)=sum(Sulfite_(3,spbin*(t-1)+1:spbin*t))/sum(Sulfite_(1,spbin*(t-1)+1:spbin*t));
    basalminutebin(t,6)=sum(Sulfate_(3,spbin*(t-1)+1:spbin*t))/sum(Sulfate_(1,spbin*(t-1)+1:spbin*t));
    basalminutebin(t,7)=sum(NoFlow_(3,spbin*(t-1)+1:spbin*t))/sum(NoFlow_(1,spbin*(t-1)+1:spbin*t));
    basalminutebin(t,8)=sum(OnOffFlow_(3,spbin*(t-1)+1:spbin*t))/sum(OnOffFlow_(1,spbin*(t-1)+1:spbin*t));
    
    
    dibined(t,1)=sum(D_N2_(3,spbin*(t-1)+1:spbin*t))/sum(D_N2_(1,spbin*(t-1)+1:spbin*t));
    dibined(t,2)=sum(D_Odr10_(3,spbin*(t-1)+1:spbin*t))/sum(D_Odr10_(1,spbin*(t-1)+1:spbin*t));
    dibined(t,3)=sum(D_Tax4_(3,spbin*(t-1)+1:spbin*t))/sum(D_Tax4_(1,spbin*(t-1)+1:spbin*t));
    dibined(t,4)=sum(D_Mec4_(3,spbin*(t-1)+1:spbin*t))/sum(D_Mec4_(1,spbin*(t-1)+1:spbin*t));
  

    fobined(t,1)=sum(Food_N2_(3,spbin*(t-1)+1:spbin*t))/sum(Food_N2_(1,spbin*(t-1)+1:spbin*t));
    fobined(t,2)=sum(Food_NA22_(3,spbin*(t-1)+1:spbin*t))/sum(Food_NA22_(1,spbin*(t-1)+1:spbin*t));
    fobined(t,3)=sum(Food_Serotonin_(3,spbin*(t-1)+1:spbin*t))/sum(Food_Serotonin_(1,spbin*(t-1)+1:spbin*t));
    fobined(t,4)=sum(Food_Diacetyl_(3,spbin*(t-1)+1:spbin*t))/sum(Food_Diacetyl_(1,spbin*(t-1)+1:spbin*t));
    
    stbined(t,1)=sum(Hour0_(3,spbin*(t-1)+1:spbin*t))/sum(Hour0_(1,spbin*(t-1)+1:spbin*t));
    stbined(t,2)=sum(Hour2_(3,spbin*(t-1)+1:spbin*t))/sum(Hour2_(1,spbin*(t-1)+1:spbin*t));
    stbined(t,3)=sum(Hour4_(3,spbin*(t-1)+1:spbin*t))/sum(Hour4_(1,spbin*(t-1)+1:spbin*t));
    stbined(t,4)=sum(Hour8_(3,spbin*(t-1)+1:spbin*t))/sum(Hour8_(1,spbin*(t-1)+1:spbin*t));
end

% % spacer = ones(43201,10)*.93;
% % test = [SBasal,spacer,NA22,spacer,Serotonin,spacer,Diacetyl];


% figure
% subplot(12,1,[1,2])
% colormap gray
% heatmap(transpose(SBasal))
% title('S. Basal')
% 
% subplot(12,1,3)
% plot(basalminutebin(:,1))
% 
% subplot(12,1,[4,5])
% heatmap(transpose(NA22))
% title('NA22 \it	E. coli')
% 
% subplot(12,1,6)
% plot(basalminutebin(:,3))
% 
% subplot(12,1,[7,8])
% heatmap(transpose(Serotonin))
% title('Serotonin 10\mu M')
% 
% subplot(12,1,9)
% plot(basalminutebin(:,4))
% 
% subplot(12,1,[10,11])
% heatmap(transpose(Diacetyl))
% title('Diacetyl 1.1\mu M')
% 
% subplot(12,1,12)
% plot(basalminutebin(:,2))
% 
% figure
% plot(dibined)
% 
figure
spacer = zeros(43201,10);
diacetyl = [(1-D_N2),spacer,(1-D_Odr10)*2,spacer,(1-D_Tax4)*3,spacer,(1-D_Mec4)*4];
map = [1,1,1;0,0,0;.4,0,0;0,.4,.8;0,.8,.4];
colormap(map)
heatmap(transpose(diacetyl))
set(gca,'Visible','off')

figure
spacer = zeros(43201,10);
food = [(1-Food_N2),spacer,(1-Food_NA22)*2,spacer,(1-Food_Serotonin)*3,spacer,(1-Food_Diacetyl)*4];
map = [1,1,1;0,0,0;0,0,0;0,0,0;0,0,0];
colormap(map)
heatmap(transpose(food))
set(gca,'Visible','off')
% 
% figure
% spacer = zeros(43201,10);
% sulf =[(1-Food_N2),spacer,(1-Sulfite),spacer,(1-Sulfate)];
% map = [1,1,1;0,0,0];
% colormap(map)
% heatmap(transpose(sulf))
% set(gca,'Visible','off')

figure

NF =[1-NoFlow];
map = [1,1,1;0,0,0];
colormap(map)
heatmap(transpose(NF))
set(gca,'Visible','off')

figure

OF =[1-OnOffFlow];
map = [1,1,1;0,0,0];
colormap(map)
heatmap(transpose(OF))
set(gca,'Visible','off')

% figure
% spacer = zeros(43201,10);
% sulf =[(1-Food_N2),spacer,(1-Sulfite),spacer,(1-Sulfate)];
% map = [1,1,1;0,0,0];
% colormap(map)
% heatmap(transpose(sulf))
% set(gca,'Visible','off')


figure
spacer = zeros(43201,10);
sulf =[(1-Sulfite),spacer,(1-Sulfate)];
map = [1,1,1;0,0,0];
colormap(map)
heatmap(transpose(sulf))
set(gca,'Visible','off')


figure

N2 =[1-SBasal];
map = [1,1,1;0,0,0];
colormap(map)
heatmap(transpose(N2))
% set(gca,'Visible','off')