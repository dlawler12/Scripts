clear all
close all
clc

cd('Z:\Dan Lawler\Projects\Sleep\SleepTrackingDemo');
load('circles')
load('framescounter')
circles(:,3)=15;

%---------------file info-----------------
fn_in = '20190418T140418.avi';
fn_out = 'SBExampleVideo_annotated2.avi';
dt = 1; % sec

%---------------settings-----------------
% framelist = [5000:10:6980,20000:10:21980,40000:10:41980];         % frames to capture
framelist = [5000:5199,20000:20199,40000:40199];         % frames to capture
crop_xywh = [102,42,984,1010];   % crop box
outscale = 0.25;                 % scale output video
timestamp_xyh = [0,0,15];     % timestamp x,y position and height

% text overlay. cell array format each row {[x,y,frame_start,frame_end],string text}
textlabels = {[225,50,0,Inf],'Arena 1'; ...
              [700,50,0,Inf],'Arena 2'; ...
              [225,550,0,Inf],'Arena 3'; ...
              [700,550,0,Inf],'Arena 4'};

titlelabels = {[440,0,0,Inf],'Early Test'; ...
               [450,0,0,Inf],'Mid Test'; ...
               [440,0,0,Inf],'Late Test'};

% showtitle = [5000:10:5490,20000:10:20490,40000:10:40490];
showtitle = [5000:5049,20000:20049,40000:40049];
titlenum = [ones(1,50),ones(1,50)*2,ones(1,50)*3];  
titlefont = 20;
          
% output video settings
saveVideo = true;
% outformat = 'MPEG-4'; % if you want to set format
% outformat = 'Uncompressed AVI';
outframerate = 10; 
outquality = 75;

%---------------code-----------------

vobj = VideoReader(fn_in);
% nfr = get(vobj,'NumberOfFrames');


% myVideo = VideoWriter(fn_out,outformat); % if you want to set format
myVideo = VideoWriter(fn_out);
myVideo.FrameRate = outframerate;
myVideo.Quality = outquality; 
open(myVideo);


figure(1); clf;
f=1;
f_taken=1;
% while hasFrame(vobj) && f<=max(framelist)
while f<=max(framelist)
%     % read frame
%     frame = readFrame(vobj,'native');
% check if the frame is included
if ismember(f,framelist)
    
    frame = read(vobj,f);
    
    % add circles
    if framescounter(f)>0
            if(f == 1)
                start = 1;
                stop = framescounter(1);
            else
                start = sum(framescounter(1:f-1))+1;
                stop = sum(framescounter(1:f));
            end
    RBG = insertShape(frame,'Circle',circles(start:stop,1:3),'Color','blue','LineWidth',5);
    imshow(RBG)
    end
    
    % crop frame
    crop =imcrop(RBG,crop_xywh);
    axis tight manual equal
    
    % add timestamp
    timestamp = sprintf('%02d:%02d:%02d', floor(f*dt/3600), mod(floor(f*dt/60),60), mod(f*dt,60));
%     text(timestamp_xyh(1),timestamp_xyh(2),timestamp,'FontSize',timestamp_xyh(3));
    crop = insertText(crop,[timestamp_xyh(1),timestamp_xyh(2)],timestamp,'FontSize',timestamp_xyh(3),'TextColor','white','BoxColor','black','BoxOpacity',0.8);
    
    % add text labels
    for t = 1:size(textlabels,1)
        if (f >= textlabels{t,1}(3) && f <= textlabels{t,1}(4))
%             text(textlabels{t,1}(1),textlabels{t,1}(2),textlabels{t,2});
            crop = insertText(crop,[textlabels{t,1}(1),textlabels{t,1}(2)],textlabels{t,2},'FontSize',timestamp_xyh(3),'BoxColor','white','BoxOpacity',0.2);
        end
    end
    
    % add title labels
    if ismember(f,showtitle)
        t = titlenum(f_taken);
        crop = insertText(crop,[titlelabels{t,1}(1),titlelabels{t,1}(2)],titlelabels{t,2},'FontSize',titlefont,'BoxColor','white','BoxOpacity',0.6);
        f_taken = f_taken+1;
    end
    
    % legend
    
    crop = insertText(crop,[100,0],'Blue circle = Sleep','TextColor','blue','FontSize',timestamp_xyh(3),'BoxColor','white','BoxOpacity',0.8);
    
    % show new frame
    imshow(crop)
    
    % write the frame to new video file
    writeVideo(myVideo, crop);
end
f=f+1; 
end
    
close(myVideo);
