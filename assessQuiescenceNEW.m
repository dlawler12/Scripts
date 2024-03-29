% *************************************************************************
% Program name  : assessQuiescence.m
% Author        : Caleb Mullen & Dan Lawler
% Date          : NOV 13 2017
% Purpose       : Pass in behavioral data generated by behavior recognition
%                 software. Simplify data by translating behaviors to 
%                 binary paused or moving states. Smooth data by removing 
%                 short changes in state. Resulting data set is analysed 
%                 and plotted. Further analysis to be completed...
% *************************************************************************
%% This code can be modified for different data sets

% Notes on areas to add to code (in order of importance):
% 1) Would like to have data saved outside of workspace
%   - Ideally, would like to have data saved in folders where the data
%     originated
%   - e.g. if data was opened from Z:\...assessQuiescence create folders in
%     that directory. First with subfolders by genotype (which you can
%     extract from the file name), then by another subfolder by date, then
%     with all of the mat files (smoothed and raw data)
% 2) Would like to run a data analysis within matlab on the analyzed data.
%    For starters, lets work on creating a mat file with the histogram
%    output for the data set. This would take the total histogram output of
%    all animals. When I do this in excel, I find the end of each bout
%    (wake or sleep) first, then place them in their respective histogram
%    denomination. Currently my groups are 10000+ sleeping frames,
%    5000-9999, 2000-4999, 1000-1999, 500-999, 300-499, 200-299, 100-199,
%    50-99, 40-49, 30-39, 20-29, 10-19, 0-9. Then it's 1-10 awake, 11-20,
%    21-30, 31-40, 41-50, 51-100, 101-200, 201-300, 301-500, 501-1000,
%    1001-2000, 2001-5000, 5001-10000, 10000+. Additionally, right now I'm
%    grouping the undecided 0s into the same group as forward 1s
% 3) To clean up the code, would like to have it call a function. The
%    function would probably need to ask for the dataset and all the
%    different bout lengths. Only issue I guess would be integrating this
%    with the directory saving in #1
% 4) A long way to analyze the likelihood of an animal entering or exiting
%    a bout is to use Hidden Markov Models to predict the system. Matlab
%    has built in ways to predict these likelihoods (in their statistics
%    toolbox) using the "hmmtrain" funciton. This is an example of how to
%    use it:
%    trans = [0.99,0.01;0.01,0.99];  %this predicts your transition
%    probability from a to b and b to a
%
%    emis = [1/6, 1/6, 1/6, 1/6, 1/6, 1/6; 1/10, 1/10, 1/10, 1/10, 1/10,
%    1/2]; % this predicts the emission frequencies which I care less about
%
%    sequence = Raw_N2_1003_Arena1(Raw_N2_1003_Arena1==0)=1; % has to have
%    timepoints in the rows rather than in columns, so matrix has many more
%    rows than columns. Also, 0 as a variable isn't accepted in the HMM
%    calculations so we'll change all non-pauses to 1 and group them with
%    forward motion like we do in the histogram
%
%    [estTR,estE] = hmmtrain(sequence,trans,emis); %this will calculated
%    the estimated Transition and emission matrix for the data set. I care
%    about the transition matrix
%    ***A side not here is that hmmtrain does take a while to calculate
%    especially when you have 20+ columns of 43000 rows. So if you're
%    testing this function out do give it time to run.
% 5) This may be down the line, but we probably want to rethink how we
%    assign the 0s and 1s from the raw data. Right now we have 3 groups.
%    Forward, pause, and unknown. I think we should try to treat the
%    unknown like we're not breaking the current behavior as long as the
%    unknown period is shorter than the length of our smoothing. If it's
%    longer than the smoothing, then we should break the behavior into
%    unknown after that many frames

clear all
close all
timeInterval = 1/60; %time per frame (min)
% cd('Z:\Dan Lawler\Projects\Sleep\Mutants\Summary');

% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\AllN2Data\ErrorBarN2\New Folder');
% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\AllN2Data\NewN2');
cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\ManuscriptNewExperiments');
% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\NewAnalysisData');

% cd('Z:\Dan Lawler\Projects\Sleep\Odorants\SbasalControl\190418\data');
% cd('Z:\Dan Lawler\Projects\Sleep\Odorants\SbasalControl\181219-NoFlow\data');

% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\DiacetylOnly');
% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\SulfateAlone');
% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups');
% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\Test');
% cd('Z:\Dan Lawler\Projects\Sleep\Mutants\SummaryOdr10');
% cd('Z:\Dan Lawler\Projects\Sleep\OnOffFlow\Summary');
% cd('Z:\Dan Lawler\Projects\Sleep\Odorants\SUMMARY');
% cd('Z:\Dan Lawler\Projects\Sleep\Mutants\Summary\N2s (unlabeled) ');
files = dir('*.mat');
boutLength = 20;
leaveSleep = 5;
%boutLength = [6,10,20,60];

% strategy right now is to treat any unknown tracks as "movement" and then
% correct after the test for unknown tracks

for i = 1:length(files)
    load(files(i).name);
    split=strsplit(files(i).name,'.');
    str=char(split(1));
    d=length(TimeAnalysis);
   	dataSet = TimeAnalysis(1).Data; %For full arena data
    if d>1
        for w=2:d
            dataSet = [dataSet;TimeAnalysis(w).Data];
        end
    end
%     dataSet = transpose(data2); %For data saved from data2 file

    
    
    eval(['Raw_',str,'=transpose(dataSet);']);
    
    
%     %CheckforLotsof0s    
%     eval(['UnknownCount',str,'=sum(Raw_',str,'==0)/43201;'])
%    for boutLength = [6,10,20,60]
    
        matrixSize = size(dataSet); %find size of data matrix
        rawState = zeros(matrixSize(1),matrixSize(2)); %matrix for raw state values
        count = zeros(matrixSize(1),matrixSize(2));
        count(:,1)=1;
        temp1 = zeros(1,boutLength);
        temp2 = zeros(1,boutLength);
        twitchPause = zeros(matrixSize(1),matrixSize(2));
        partOfTwitchPause = zeros(matrixSize(1),matrixSize(2));
        corrected = zeros(matrixSize(1),matrixSize(2));

        for t = 1:matrixSize(1)
            for j = 1:matrixSize(2)

               %% Raw State 
                if (dataSet(t,j) == 3)
                    rawState(t,j) = 0; %Sleep 0
                else
                    rawState(t,j) = 1; %Everything else 1
                end

               %% Count
               if j>1
                    if (rawState(t,j) == rawState(t,j-1))
                        count(t,j)=count(t,j-1)+1;
                    else
                        count(t,j)=1;
                    end
               end
            end
        end

        for t = 1:matrixSize(1)
            for j = 1:matrixSize(2)

               %%Twitch/Pause
               if j>(boutLength+1) && j<(matrixSize(2)-boutLength+1)
                    temp1 = count(t,j+1:j+boutLength);
                    temp2 = twitchPause(t,j-boutLength:j-1);
                    check = sum(temp2(temp2 == 1)) < 1 || rawState(t,j) ~= corrected(t,j-boutLength-1);
                    if(count(t,j)==1 && sum(temp1(temp1 == 1)) > 0 && check)
                        twitchPause(t,j) = 1;
                    end
               end

               %%Part of twitch/pause
               if j>1
                   if rawState(t,j) == rawState(t,j-1)
                       partOfTwitchPause(t,j)=partOfTwitchPause(t,j-1);
                   else
                       partOfTwitchPause(t,j)=twitchPause(t,j);
                   end
               end
               
               %%Check if leaving a Sleep Bout
               if j>(leaveSleep+1)
                   if rawState(t,j)==1 && partOfTwitchPause(t,j)==1 && sum(corrected(t,j-(leaveSleep-1):j-1)) == 0
                       if sum(dataSet(t,j-(leaveSleep-1):j)~=3)==leaveSleep && sum(dataSet(t,j-(leaveSleep-1):j)>1)==leaveSleep
                           partOfTwitchPause(t,j) = 0;
                       end
                   end
               end

               %%Corrected
               if partOfTwitchPause(t,j) == 0
                   corrected(t,j) = rawState(t,j);
               else
                   corrected(t,j) = 1-rawState(t,j);
               end
            end
        end
        tempSummary = zeros(3,(matrixSize(2)-1)/900); %Split by 15 minute segments
        % First column total non-missed decisions
        % Second column raw sleep decisions
        % Third column smoothed sleep decisions
        for u = 1:(matrixSize(2)-1)/900
            tempSummary(1,u) = sum(sum(dataSet(:,(u-1)*900+1:u*900) > 1));
            tempSummary(2,u) = sum(sum(dataSet(:, (u-1)*900+1:u*900) == 3));
            tempSummary(3,u) = sum(sum(corrected(:, (u-1)*900+1:u*900) == 0));
        end

        eval(['Smooth',int2str(boutLength),'_',str,'=transpose(corrected);']);
        eval(['SummaryData',int2str(boutLength),'_',str,'=tempSummary;']);
%         %% Correction plot
%         % Goal is to have 0 as agreed sleep, 1 as raw sleep 2 as
%         % predicted sleep and 3 as agreed awake
%         
% %         tempCorrection=transpose(rawState);
%         eval(['Correction',int2str(boutLength),'_',str,'=transpose(rawState)+2*Smooth',int2str(boutLength),'_',str,';']);
%             
        %% Histogram Calculation
        %Sleep
        eval(['histfile=Smooth',int2str(boutLength),'_',str,';']);
        [~,animals] = size(histfile);
        newmat = zeros(43201,animals);
        for h = 1:animals
            count = 0 ;
            for u = 1:43201
                if(histfile(u,h)==0)
                    newmat(u,h)=count+1;
                    count=count+1;
                else
                    count = 0;
                end
            end
        end

        maxs = zeros(43201,animals);
        for e = 1:animals
            for g = 1:43200
                if(newmat(g+1,e)<newmat(g,e))
                    maxs(g,e)=newmat(g,e);
                end
            end
        end

        g=43201;
        for o = 1:animals
            maxs(g,o)=newmat(g,o);
        end
        maxs(maxs==0)=NaN;
        bins = [0,20,50,100,200,500,1000,10000000];
%         a = histcounts(maxs,bins);
        eval(['HistSleep',int2str(boutLength),'_',str,'=histcounts(maxs,bins);']);
%    end


%Sleep
        newmat = zeros(43201,animals);
        for z = 1:animals
            count = 0 ;
            for q = 1:43201
                if(histfile(q,z)==1)
                    newmat(q,z)=count+1;
                    count=count+1;
                else
                    count = 0;
                end
            end
        end

        maxs = zeros(43201,animals);
        for b = 1:animals
            for l = 1:43200
                if(newmat(l+1,b)<newmat(l,b))
                    maxs(l,b)=newmat(l,b);
                end
            end
        end

        l=43201;
        for r = 1:animals
            maxs(l,r)=newmat(l,r);
        end
        maxs(maxs==0)=NaN;
        bins = [0,20,50,100,200,500,1000,10000000];
%         a = histcounts(maxs,bins);
        eval(['HistAwake',int2str(boutLength),'_',str,'=histcounts(maxs,bins);']);
%    end

%% Final Plots
% Goal of this section is to create a single figure plot for each arena and
% condition with all types of plots that we care about. They will include:
% 1) Ethogram of sleep over time
% 2) Time course plot under the Ethogram
% 3) Histogram of awake bout lengths and sleep bout lengths
    eval(['test=Smooth',int2str(boutLength),'_',str,';']);
    figure(i)
    test = transpose(test);
    %Sort by most sleep to least
    sortfile=zeros(animals,2);
    for n = 1:animals
        sortfile(n,1)=mean(test(n,:));
        sortfile(n,2)=n;
    end
    [~,idx] = sort(sortfile(:,1));
    test=test(idx,:);
    test = transpose(test);
    
    subplot(3,1,1)
    %ethogram
    colormap gray
    heatmap(transpose(test))
    title('Ethogram')
%     ylabel('Animal Number')
    
    subplot(6,1,3)
    %timecourse
    basalminutebin = zeros(720,1);
    for t = 1:720
        basalminutebin(t)=1-(mean(mean(test(60*(t-1)+1:60*t,:))));
    end
    plot(basalminutebin)
    title('Timecourse')
    xlim([0 720])
    ylim([0 1])
    xlabel('Time (minutes)')
    ylabel('Sleep Fraction')
    
    subplot(2,2,3)
    %awake histo
    eval(['bar(HistAwake',int2str(boutLength),'_',str,'/animals);']);
    title('Awake')
    ylim([0 20])
    ylabel('Bout Count (per animal)')
    xticks([1 2 3 4 5 6 7])
    xticklabels({'0-20','20-50','50-100','100-200','200-500','500-1000','>1000'})
    xtickangle(45)
    xlabel('Bout Length (seconds)')

    subplot(2,2,4)
    %sleep histo
    eval(['bar(HistSleep',int2str(boutLength),'_',str,'/animals);']);
    title('Sleep')
    ylim([0 20])
    ylabel('Bout Count (per animal)')
    xticks([1 2 3 4 5 6 7])
    xticklabels({'0-20','20-50','50-100','100-200','200-500','500-1000','>1000'})
    xtickangle(45)
    xlabel('Bout Length (seconds)')
    
% %Save    
%     sgtitle(str,'Interpreter','none')
% %     savefig(i)
%     saveas(i,[str,'.pdf'])
end
% close all
% output_fig = figure();
% dinfo = dir('*.fig');
% for K = 1 : length(dinfo)
%   this_fig_file = dinfo(K).name;
%   fig = openfig(this_fig_file, 'Visible', 'off');
%   three_ax = findobj(fig, 'type', 'axes');
%   copyobj(three_ax, output_fig);
%   delete(fig);
% end
% saveas(output_fig,'Sleep Data Figures.pdf')