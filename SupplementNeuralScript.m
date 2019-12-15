clear all
close all
clc

cd('Z:\Dan Lawler\Projects\Sleep\Stimulations')
load('AIBData')
load('ASHData')
load('StimulationData')
load('TimeLapseLengthsSorted')

% In this script I will create the subplots necessary to create the
% supplemental figure as described in a meeting with Dirk. This includes 6
% main panels, each of which will include behavior data (5 minutes prior to
% stimulus), heatmap of corresponding animals neural traces for both sleep
% and wake conditions, and the corresponding timecoure graphs showing an
% average trace and all of the individual traces as well. For now, the plan
% is to create every figure individually then put the panels together in
% powerpoint. So summarized what needs to be done is:
%
% 1) 5 minute behavior data for sleep and wake (2 per test, 6 tests)
% 2) Equally scaled heat maps for all traces (2 per test, 6 tests)
% 3) A timecourse plot with average and individual traces
%
% Filtered NaN to smooth to previous value

numanimals = 35;
AllSqIntNormAIB(286:300,33)=1; % Filter end of AIB in test 33
assignmentAIB = animalAIB+expAIB*2-1; assignmentASH = animalASH+expASH*2-1;

for i = 11:300
    for j = 1:numanimals
        if isnan(AllSqIntNormFiltAIB(i,j))
            AllSqIntNormFiltAIB(i,j)=mean(AllSqIntNormFiltAIB(i-10:i-1,j));
        end
        if isnan(AllSqIntNormFiltASH(i,j))
            AllSqIntNormFiltASH(i,j)=mean(AllSqIntNormFiltASH(i-10:i-1,j));
        end        
    end
end

% colormap jet
% for a = 1:max(assignmentAIB) 
%     subplotarray(6,a); 
%     imagesc(AllSqIntNormAIB(:,assignmentAIB == a)'); 
%     set(gca,'CLim',[0.5 2]); 
%     title(a); 
% end
% figure
% colormap jet
% for a = 1:max(assignmentASH) 
%     subplotarray(6,a); 
%     imagesc(AllSqIntNormASH(:,assignmentASH == a)'); 
%     set(gca,'CLim',[0.5 4]); 
%     title(a); 
% end



% AllSqIntNormFiltAIB(isnan(AllSqIntNormFiltAIB)) = 1;
% AllSqIntNormFiltASH(isnan(AllSqIntNormFiltASH)) = 1;


AIBcounts = zeros(6,1); ASHcounts = zeros(6,1);
for i = 1:6
    AIBcounts(i) = sum(assignmentAIB == i);
    ASHcounts(i) = sum(assignmentASH == i);
end
for i = 1:6
    eval(['AIB',int2str(i),' = zeros(300,AIBcounts(i));']);
    eval(['ASH',int2str(i),' = zeros(300,ASHcounts(i));']);
end

AIB = zeros(300,6); ASH = zeros(300,6);
AIBr = zeros(1,6);
ASHr = zeros(1,6);
for i = 1:35
    eval(['AIB',int2str(assignmentAIB(i)),'(:,', ...
        int2str(AIBr(assignmentAIB(i))+1),') = AllSqIntNormFiltAIB(:,i);']);
    eval(['ASH',int2str(assignmentASH(i)),'(:,', ...
        int2str(ASHr(assignmentASH(i))+1),') = AllSqIntNormFiltASH(:,i);']);
    AIBr(assignmentAIB(i))=AIBr(assignmentAIB(i))+1;
    ASHr(assignmentASH(i))=ASHr(assignmentASH(i))+1;
    AIB(:,assignmentAIB(i))=AIB(:,assignmentAIB(i))+AllSqIntNormFiltAIB(:,i);
    ASH(:,assignmentASH(i))=ASH(:,assignmentASH(i))+AllSqIntNormFiltASH(:,i);
end

for i = 1:6
    AIB(:,i) = AIB(:,i)/AIBcounts(i);
    ASH(:,i) = ASH(:,i)/ASHcounts(i);
end

%% 5 Minutes of Behavior

for e = 1:3
    eval(['[maxframesAIB,pulsesAIB] = size(TL1_AIB',int2str(e),');'])
    eval(['[maxframesASH,pulsesASH] = size(TL1_ASH',int2str(e),');'])

    pulsesAIB = pulsesAIB-1; %skim off bad set
    if e < 3
        pulsesASH = pulsesASH-1; %skim off bad set
    end
    
    eval(['TimeLapseAIB = TL1_AIB',int2str(e),';'])
    eval(['TimeLapse2AIB = TL2_AIB',int2str(e),';'])
    eval(['TimeLapseASH = TL1_ASH',int2str(e),';'])
    eval(['TimeLapse2ASH = TL2_ASH',int2str(e),';'])

    for i=1:maxframesAIB
        for j=1:pulsesAIB
            if (TimeLapseAIB(i,j)<0.5&&TimeLapse2AIB(i,j)<0.5)
                TimeLapseAIB(i,j)=0;
            else
                TimeLapseAIB(i,j)=1;
            end
        end
    end
    
    for i=1:maxframesASH
        for j=1:pulsesASH
            if (TimeLapseASH(i,j)<0.5&&TimeLapse2ASH(i,j)<0.5)
                TimeLapseASH(i,j)=0;
            else
                TimeLapseASH(i,j)=1;
            end
        end
    end
    eval(['TLCount_AIB',int2str(e),' = TLCount_AIB',int2str(e),' -1;']);
    eval(['TLCount_ASH',int2str(e),' = TLCount_ASH',int2str(e),' -1;']);
    eval(['SleepAIB',int2str(e),' = zeros(AIBcounts(e*2-1),30)-1;']);
    eval(['AwakeAIB',int2str(e),' = zeros(AIBcounts(e*2),30)-1;']);
    eval(['SleepASH',int2str(e),' = zeros(ASHcounts(e*2-1),30)-1;']);
    eval(['AwakeASH',int2str(e),' = zeros(ASHcounts(e*2),30)-1;']);
    
%     Sleep = [-2,-2,-2,-2,-2,-2,-4,-4,-4];
%     Awake = Sleep - 1;
    for i = 1:AIBcounts(e*2-1)
%         eval(['SleepAIB',int2str(e),'(i,end-8:end)=Sleep;']);
        if (TLAIBSort(i,e*2-1)>30)
            eval(['SleepAIB',int2str(e),'(i,:)=TimeLapseAIB(TLCount_AIB',int2str(e),'(TLAIBIndex(i,e*2-1))-30:TLCount_AIB',int2str(e),'(TLAIBIndex(i,e*2-1))-1,TLAIBIndex(i,e*2-1));']);
        else
            eval(['SleepAIB',int2str(e),'(i,(32-TLAIBSort(i,e*2-1)):end)=TimeLapseAIB(1:TLCount_AIB',int2str(e),'(TLAIBIndex(i,e*2-1)),TLAIBIndex(i,e*2-1));']);
        end
    end
    for i = 1:AIBcounts(e*2)
%         eval(['AwakeAIB',int2str(e),'(i,end-8:end)=Awake;']);
        if (TLAIBSort(i,e*2)>30)
            eval(['AwakeAIB',int2str(e),'(i,:)=TimeLapseAIB(TLCount_AIB',int2str(e),'(TLAIBIndex(i,e*2))-30:TLCount_AIB',int2str(e),'(TLAIBIndex(i,e*2))-1,TLAIBIndex(i,e*2));']);
        else
            eval(['AwakeAIB',int2str(e),'(i,(32-TLAIBSort(i,e*2)):end)=TimeLapseAIB(1:TLCount_AIB',int2str(e),'(TLAIBIndex(i,e*2)),TLAIBIndex(i,e*2));']);
        end
    end
    for i = 1:ASHcounts(e*2-1)
%         eval(['SleepASH',int2str(e),'(i,end-8:end)=Sleep;']);
        if (TLASHSort(i,e*2-1)>30)
            eval(['SleepASH',int2str(e),'(i,:)=TimeLapseASH(TLCount_ASH',int2str(e),'(TLASHIndex(i,e*2-1))-30:TLCount_ASH',int2str(e),'(TLASHIndex(i,e*2-1))-1,TLASHIndex(i,e*2-1));']);
        else
            eval(['SleepASH',int2str(e),'(i,(32-TLASHSort(i,e*2-1)):end)=TimeLapseASH(1:TLCount_ASH',int2str(e),'(TLASHIndex(i,e*2-1)),TLASHIndex(i,e*2-1));']);
        end       
    end
    for i = 1:ASHcounts(e*2)
%         eval(['AwakeASH',int2str(e),'(i,end-8:end)=Awake;']);
        if (TLASHSort(i,e*2)>30)
            eval(['AwakeASH',int2str(e),'(i,:)=TimeLapseASH(TLCount_ASH',int2str(e),'(TLASHIndex(i,e*2))-30:TLCount_ASH',int2str(e),'(TLASHIndex(i,e*2))-1,TLASHIndex(i,e*2));']);
        else
            eval(['AwakeASH',int2str(e),'(i,(32-TLASHSort(i,e*2)):end)=TimeLapseASH(1:TLCount_ASH',int2str(e),'(TLASHIndex(i,e*2)),TLASHIndex(i,e*2));']);
        end
    end
    
    

    
    
    map = [1,1,1;0,0,0;.5,.5,.5]; %with unknowns
    map2 = [0,0,0;.5,.5,.5]; %without unknowns
    figure
    colormap(map)
    eval(['heatmap(SleepAIB',int2str(e),')']);
    if e == 2
        figure
        colormap(map2)
        eval(['heatmap(AwakeAIB',int2str(e),')']);
    else
        figure
        colormap(map)
        eval(['heatmap(AwakeAIB',int2str(e),')']);
    end
    figure
    colormap(map)
    eval(['heatmap(SleepASH',int2str(e),')']);
    figure
    colormap(map)
    eval(['heatmap(AwakeASH',int2str(e),')']);
%     map = [1,0,0;0,0,1;1,.8,.8;0,0,.5;1,1,1;0,0,0;.5,.5,.5];
%     map2 = [1,0,0;0,0,1;1,.8,.8;0,0,.5;.5,.5,.5;0,0,0;1,1,1];
%     figure
%     colormap(map)
%     eval(['heatmap(DualShiftTimeLapseAIB',int2str(e),')']);
%     figure
%     colormap(map)
%     eval(['heatmap(DualShiftTimeLapseASH',int2str(e),')']);
end