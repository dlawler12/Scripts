clear all
close all
clc
cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\NewAnalysisData\SummedData');
load('SmoothedData');
% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\AllN2Data\NewN2');
% load('corrected.mat')
clearvars -except Smooth20_N2_All
corrected=Smooth20_N2_All;
Smooth20_N2_1 = corrected(1:10800,:);
Smooth20_N2_2 = corrected(10801:21600,:);
Smooth20_N2_3 = corrected(21601:32400,:);
Smooth20_N2_4 = corrected(32401:43200,:);

Smooth20_N2_Sub1 = Smooth20_N2_1(1:10799,:)-Smooth20_N2_1(2:10800,:);
Smooth20_N2_Sub2 = Smooth20_N2_2(1:10799,:)-Smooth20_N2_2(2:10800,:);
Smooth20_N2_Sub3 = Smooth20_N2_3(1:10799,:)-Smooth20_N2_3(2:10800,:);
Smooth20_N2_Sub4 = Smooth20_N2_4(1:10799,:)-Smooth20_N2_4(2:10800,:);


WakeToSleep = [sum(sum(Smooth20_N2_Sub1(Smooth20_N2_Sub1==1))),sum(sum(Smooth20_N2_Sub2(Smooth20_N2_Sub2==1))),sum(sum(Smooth20_N2_Sub3(Smooth20_N2_Sub3==1))),sum(sum(Smooth20_N2_Sub4(Smooth20_N2_Sub4==1)))];
WakeToSleep = WakeToSleep./[sum(sum(Smooth20_N2_1==1)),sum(sum(Smooth20_N2_2==1)),sum(sum(Smooth20_N2_3==1)),sum(sum(Smooth20_N2_4==1))];

SleepToWake = [sum(sum(Smooth20_N2_Sub1(Smooth20_N2_Sub1==-1))),sum(sum(Smooth20_N2_Sub2(Smooth20_N2_Sub2==-1))),sum(sum(Smooth20_N2_Sub3(Smooth20_N2_Sub3==-1))),sum(sum(Smooth20_N2_Sub4(Smooth20_N2_Sub4==-1)))];
SleepToWake = -SleepToWake./[sum(sum(Smooth20_N2_1==0)),sum(sum(Smooth20_N2_2==0)),sum(sum(Smooth20_N2_3==0)),sum(sum(Smooth20_N2_4==0))];

%Keep analyzing by binning less and trying to automate the binning to
%assess this. Basically what it is, is diving the number of wake to sleep
%events by the number of wake events. So you see the frequency of a wake
%event being translated into a sleep event. And then vice-versa

% boutLength = 20;
%% Medians by time
for str = 1:4

%% Histogram Calculation
        %Sleep
        mediangroup = 0;
        counter = 0;
        eval(['histfile=Smooth20_N2_',int2str(str),';']);
        [~,animals] = size(histfile);
        newmat = zeros(10800,animals);
        for h = 1:animals
            count = 0 ;
            for u = 1:10800
                if(histfile(u,h)==0)
                    newmat(u,h)=count+1;
                    count=count+1;
                else
                    count = 0;
                end
            end
        end

        maxs = zeros(10800,animals);
        for e = 1:animals
            for g = 1:10799
                if(newmat(g+1,e)<newmat(g,e))
                    maxs(g,e)=newmat(g,e);
                    if newmat(g,e)>20
                        mediangroup(counter+1)=newmat(g,e);
                        counter=counter+1;
                    end
                end
            end
        end

        g=10800;
        for o = 1:animals
            maxs(g,o)=newmat(g,o);
        end
        maxs(maxs==0)=NaN;
        temp = maxs(1:10799,:);
        t=temp(:);
        eval(['MedianSleep_',int2str(str),'=mediangroup;']);
        bins = [0,20,50,100,200,500,1000,10000000];
%         a = histcounts(maxs,bins);
        eval(['HistSleep20_N2_',int2str(str),'=histcounts(maxs,bins);']);
%    end
        %SumData
        hists=[20,50,100,200,500,1000,10000000];
        maxs(isnan(maxs))=0;
        eval(['SumOfSleep20_N2_',int2str(str),'=zeros(1,7);']);
        
        multiplier = zeros(10800,535);
        multiplier(maxs<=20)=1;
        tempo=maxs.*multiplier;
        eval(['SumOfSleep20_N2_',int2str(str),'(1)=sum(sum(tempo));']);
        
        for b=2:7
            multiplier = zeros(10800,535);
            parta=maxs>hists(b-1);
            partb=maxs<=hists(b);
            tryit=parta.*partb;
            multiplier(tryit==1)=1;
            tempo=maxs.*multiplier;
            eval(['SumOfSleep20_N2_',int2str(str),'(b)=sum(sum(tempo));']);
        end
        
        


%Sleep
        mediangroup = 0;
        counter = 0;
        newmat = zeros(10800,animals);
        for z = 1:animals
            count = 0 ;
            for q = 1:10800
                if(histfile(q,z)==1)
                    newmat(q,z)=count+1;
                    count=count+1;
                else
                    count = 0;
                end
            end
        end

        maxs = zeros(10800,animals);
        for b = 1:animals
            for l = 1:10799
                if(newmat(l+1,b)<newmat(l,b))
                    maxs(l,b)=newmat(l,b);
                    if newmat(l,b)>20
                        mediangroup(counter+1)=newmat(l,b);
                        counter=counter+1;
                    end
                end
            end
        end

        l=10800;
        for r = 1:animals
            maxs(l,r)=newmat(l,r);
        end
        maxs(maxs==0)=NaN;
        temp = maxs(1:10799,:);
        t=temp(:);
        eval(['MedianAwake_',int2str(str),'=mediangroup;']);
        bins = [0,20,50,100,200,500,1000,10000000];
%         a = histcounts(maxs,bins);
        eval(['HistAwake20_N2_',int2str(str),'=histcounts(maxs,bins);']);

        %SumData
        hists=[20,50,100,200,500,1000,10000000];
        maxs(isnan(maxs))=0;
        eval(['SumOfAwake20_N2_',int2str(str),'=zeros(1,7);']);
        
        multiplier = zeros(10800,535);
        multiplier(maxs<=20)=1;
        tempo=maxs.*multiplier;
        eval(['SumOfAwake20_N2_',int2str(str),'(1)=sum(sum(tempo));']);
        
        for b=2:7
            multiplier = zeros(10800,535);
            parta=maxs>hists(b-1);
            partb=maxs<=hists(b);
            tryit=parta.*partb;
            multiplier(tryit==1)=1;
            tempo=maxs.*multiplier;
            eval(['SumOfAwake20_N2_',int2str(str),'(b)=sum(sum(tempo));']);
        end


end

