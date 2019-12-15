clear all
close all
clc
cd('Z:\Dan Lawler\Projects\Sleep\Stimulations\DemoVideo')
files = dir('*.avi');
order = [1,3,2,4];
lengths = [22,26];
state = 'AwakeSleep';

saveFileName = 'ClosedLoopExample.avi';
outputVideo = VideoWriter(['Z:\Dan Lawler\Projects\Sleep\Stimulations\DemoVideo\Output\',saveFileName],'Uncompressed AVI');
% output video settings
saveVideo = true;
% outformat = 'MPEG-4';
outframerate = 30; 
outquality = 75;
outputVideo.FrameRate = outframerate;
% outputVideo.Quality = outquality;

open(outputVideo)


timestamp_xy = [20,15];     % timestamp x,y position and height
font = 20;
time = 0;
reduction = 8; % # of times to repeat behavior frames

for i=order
    filename = files(i).name;
    currentvid = VideoReader(filename);
    framecounter=0;
    if i<3
        dt = 1000; % 10s
        while hasFrame(currentvid)
            framecounter=framecounter+1;
            I = readFrame(currentvid);
            time = time+dt;
            timestamp = sprintf('%02d:%02d:%02d.%02d', floor(time/360000), mod(floor(time/6000),60), mod(floor(time/100),60), mod(time,100));
            addframe = insertText(I,timestamp_xy,timestamp,'FontSize',font,'TextColor','red');
            if framecounter>(lengths(i)-7)
                text = [state(1+5*(i-1):5*i),' state detected...stimulus in ',int2str(lengths(i)-framecounter),' frames'];
                addframe = insertText(addframe,[400,15],text,'FontSize',font);
            end
            imshow(addframe)
            for t = 1:reduction
            writeVideo(outputVideo, addframe);
            end
        end
    else
        dt = 10; % 0.1s
        while hasFrame(currentvid)
            framecounter=framecounter+1;
            I = readFrame(currentvid);
            time = time+dt;
            timestamp = sprintf('%02d:%02d:%02d.%02d', floor(time/360000), mod(floor(time/6000),60), mod(floor(time/100),60), mod(time,100));
            addframe = insertText(I,timestamp_xy,timestamp,'FontSize',font,'TextColor','red');
            if framecounter>50 && framecounter<151
                text = '1 mM Copper Chloride';
                addframe = insertText(addframe,[300,15],text,'FontSize',font,'TextColor','blue');
            end
            imshow(addframe)
            writeVideo(outputVideo, addframe);
        end
    end
    if i == 3
        time = time+15*60*100-3000; % add 15 minutes
    end
    clear currentvid
end

close(outputVideo);