clear all
close all
clc

%read in neural imaging text files
if exist('SmDat')
    ButtonName = questdlg('Reload data?','','Yes', 'No', 'Yes');
end
if ~exist('SmDat') || strcmp(ButtonName,'Yes')
    p=uigetdir;
    if p==0
        return
    else
        D = dir(fullfile(p,'*.an*.txt'));
        disp(sprintf('Found %d neural trace files.  ',length(D)));
        cd(p);
    end
    clear SmDat
    for f = 1:length(D); %read all txt files into SmDat
        name = fullfile(p,D(f).name);
        SmDat(f).name = name;
        SmDat(f).data = textread(SmDat(f).name,'','delimiter',',','headerlines',1);
        SmDat(f).exp = str2num(name((strfind(name,'mov')+3):(strfind(name,'mov')+6)));
        SmDat(f).animal = str2num(name((strfind(name,'.an')+3):(strfind(name,'.an')+4)));
        SmDat(f).valve = str2num(name((strfind(name,'valve')+5)));
        SmDat(f).pattern = str2num(name((strfind(name,'pattern')+7)));
        if ~isempty(strfind(name,'stim'))
            SmDat(f).time = str2num(strrepl(name((strfind(name,'_mov')+(-5:-1))),'_','.'));
        else
            SmDat(f).time = [];
        end
        if ~isempty(strfind(name,'stim'))
            SmDat(f).stimulus = str2num(name((strfind(name,'stim')+(4:5))));
        else
            SmDat(f).stimulus = SmDat(f).valve;
        end
        if mod(f,round(length(D)/20))==0, disp(sprintf('\b*')); end
    end
end

%Parse and align data
raw = struct2mat(3,SmDat,[],{'data'});
numfiles = size(raw,3);
numpts = mmax(raw(:,1,:));

All = NaN*ones(numpts,size(raw,2),numfiles);
for ex = 1:numfiles
    valid = find(~isnan(raw(:,1,ex)));
    All(raw(valid,1,ex),:,ex)=raw(valid,:,ex); %this will end up with only the last row if there is more than one row for a frame
end

%remove faulty negative values (tracking glitches)
AllSqInt = squeeze(All(:,12,:)); 
AllSqInt(find(AllSqInt<500))=NaN;

animal = struct2mat(1,SmDat,[],{'animal'});
exp = struct2mat(1,SmDat,[],{'exp'});
valve = struct2mat(1,SmDat,[],{'valve'});
pattern = struct2mat(1,SmDat,[],{'pattern'});
expset = cumsum([1;exp(2:end)<exp(1:end-1)]);
% time = struct2mat(1,SmDat,[],{'time'});
stimulus = struct2mat(1,SmDat,[],{'stimulus'});

numsets = max(expset);
if numsets>1
    oanimal = animal;
    animalsperset = []; 
    for s=1:numsets 
        animalsperset(s) = max(animal(find(expset==s)))+1;
        if s>1
            animal(find(expset == s)) = animal(find(expset == s)) + sum(animalsperset(1:s-1));
        end
    end
end

numanimals = max(animal)+1;

if isempty(pattern) && ~isempty(valve)
    pattern = valve;
else 
    pattern = ones(size(animal));
end

group = cellstr(num2str(pattern+(animal+1)*0.1));

baseline = nanmean(AllSqInt(1:40,:));
AllSqIntNorm = AllSqInt ./ repmat(baseline,size(AllSqInt,1),1);

% Filter outliers by histogram
Flimits = [0.05,0.95]; % exclude lower and upper 1%
Frange = 0:.1:4;
h = hist(AllSqIntNorm(:),Frange); ch = cumsum(h) ./ msum(h);
llim = Frange(find(ch >= Flimits(1),1)-1); ulim = Frange(find(ch >= Flimits(2),1));
AllSqIntNormFilt = AllSqIntNorm;
AllSqIntNormFilt(find(AllSqIntNormFilt < llim | AllSqIntNormFilt > ulim)) = NaN;

% Filter outliers by histogram (for AIB)
Flimits = [0.01,0.99]; % exclude lower and upper 1%
Frange = 0:1000:400000;
h = hist(AllSqInt(:),Frange); ch = cumsum(h) ./ msum(h);
llim = Frange(find(ch >= Flimits(1),1)-1); ulim = Frange(find(ch >= Flimits(2),1));
AllSqIntFilt = AllSqInt;
AllSqIntFilt(find(AllSqIntFilt < llim | AllSqIntFilt > ulim)) = NaN;

temp = AllSqIntFilt(:,1:22);
an1 = temp(:);
an1 = sort(an1);
base1 = mean(an1(1:length(an1)/10));

temp = AllSqIntFilt(:,23:29);
an2 = temp(:);
an2=sort(an2);
base2 = mean(an2(1:length(an2)/10));

temp = AllSqIntFilt(:,30:35);
an3 = temp(:);
an3=sort(an3);
base3 = mean(an2(1:length(an3)/10));

baseline(1:22)=base1;
baseline(23:29)=base2;
baseline(30:35)=base3;

AllSqIntNormAIB = AllSqIntFilt ./ repmat(baseline,size(AllSqIntFilt,1),1);

for i = 1:35
    averageAct = sum(nansum(AllSqIntNormAIB(51:150,:)))/sum(sum(~isnan(AllSqIntNormAIB(51:150,:))));
    if nanmean(AllSqIntNormAIB(1:50,i))>averageAct || nanmax(AllSqIntNormAIB(:,i))<1
        animal(i)=animal(i)+2;
    end
end

load('reversalFrame.mat')
counter = 1;
for i = 1:35
    if animal(i)<2 && reversalFrame(i)<201
        AllSqIntNormAIBRev(1:150,counter)=AllSqIntNormAIB(reversalFrame(i)-49:reversalFrame(i)+100,i);
        AllSqIntNormUse(1:300,counter)=AllSqIntNormAIB(:,i);
        animalAIB(counter)=animal(i);
        counter=counter+1;
    end
end

databrowse(AllSqIntNormAIBRev(1:150,:)',(1:150)/10,animalAIB);

% Filter outliers by histogram (for AIB)
Flimits = [0.01,0.99]; % exclude lower and upper 1%
Frange = 0:.1:6;
h = hist(AllSqIntNormUse(:),Frange); ch = cumsum(h) ./ msum(h);
llim = Frange(find(ch >= Flimits(1),1)-1); ulim = Frange(find(ch >= Flimits(2),1));
% AllSqIntFilt = AllSqInt;
AllSqIntNormUse(find(AllSqIntNormUse < llim | AllSqIntNormUse > ulim)) = NaN;


% databrowse(AllSqIntNormUse(1:300,:)',(1:300)/10,animalAIB);
% figure
% databrowse(AllSqIntNormAIB(1:300,:)',(1:300)/10,animal);


% databrowse(AllSqIntNorm');
% 
% figure(1); 
% for a = 0:max(animal); 
%     subplotarray(numanimals,a+1); 
%     imagesc(AllSqIntNorm(:,find(animal == a))'); 
%     set(gca,'CLim',[.5 4]); 
%     title(a); 
% end
% 
% figure(3); clf; 
% for a = 0:max(animal); 
%     lineartrace = reshape(AllSqIntNorm(:,find(animal == a)),[],1);
%     smoothtrace = smooth(lineartrace,10);
%     smoothtrace(find(isnan(lineartrace))) = NaN;
%     hold on; 
%     plot(smoothtrace + (max(animal)-1-a)*4); 
% end; hold off
% 
