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
Flimits = [0.01,0.99]; % exclude lower and upper 1%
Frange = 0:.1:4;
h = hist(AllSqIntNorm(:),Frange); ch = cumsum(h) ./ msum(h);
llim = Frange(find(ch >= Flimits(1),1)-1); ulim = Frange(find(ch >= Flimits(2),1));
AllSqIntNormFilt = AllSqIntNorm;
AllSqIntNormFilt(find(AllSqIntNormFilt < llim | AllSqIntNormFilt > ulim)) = NaN;


[frames,traces] = size(AllSqIntNorm);
trials = traces/(max(animal)+1);
CatchTrial = [];
for a = 0:max(animal)
    lineartrace = reshape(AllSqIntNorm(:,find(animal == a)),[],1);
    CatchTrial = [CatchTrial, lineartrace];
end
a = reshape(CatchTrial,[frames,trials,numel(CatchTrial)/(frames*trials)]);

% databrowse(CatchTrial',[],expset(1:40:end))
% databrowse(CatchTrial([(24*300):(27*300)],:)',[],expset(1:40:end))
% databrowse(CatchTrial([(29*300):end],:)',[],expset(1:40:end))






peaks = squeeze(max(a)-1);
avpeaks=zeros(40,1);
for i=1:40
    avpeaks(i)=mean(peaks(i,:));
end

plot(avpeaks);

% Reformat plot to have red for catch data (26, 31-40), data labels, trial
% labels, and maybe something to signify break time



