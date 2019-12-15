clear all
close all
clc
cd('Z:\Dan Lawler\Projects\Sleep\Odorants\SbasalControl\190418\data');




%% Load variables
load('corrected')
load('positions')
load('bouts')
load('dataSet')
filename = '20190418T140418.avi';
SBCtrl = VideoReader(filename);

% GuiFormat



% Getting The Bout Data
boutLength = 60; %seconds
sizing=size(corrected);
awakeBouts = [0,0];
awakeNum = 0;
sleepBouts = [0,0];
sleepNum = 0;
%% Find all events

for i = 1:sizing(1)
    for j = 1:sizing(2)-boutLength
        current = corrected(i,j);
        nextSet = corrected(i,j+1:j+boutLength-1);
        allData = dataSet(i,j:j+boutLength-1);
        checkBout = sum(nextSet == current)==(boutLength-1);
        checkBehavior = sum(allData>1)>(boutLength)*.9;
        checkNaN = sum(isnan(positionsX(i,j:j+boutLength-1)))==0 && sum(isnan(positionsY(i,j:j+boutLength-1)))==0;
        if checkBout && checkNaN && checkBehavior
            if current == 1
                awakeBouts(awakeNum+1,:) = [i,j];
                awakeNum = awakeNum + 1;
            else
                sleepBouts(sleepNum+1,:) = [i,j];
                sleepNum = sleepNum + 1;
            end
        end
    end
    i
end



%% a random sleep event
animal = randi(sizing(1));
time = randi(sizing(2)-boutLength);


if corrected

    frame = round(SBCtrl.CurrentTime*30);

    SBCtrl.CurrentTime = 10;
    while hasFrame(SBCtrl)
        I = readFrame(SBCtrl);
    %     RBG = insertShape(I,'Circle',circles(start:stop,:),'Color','red','LineWidth',5);
    %     imshow(RBG)
        imshow(I)
    end

close(outputVideo);




function browse_Callback(hObject, event, handles)
  [chosenfile, chosenpath] = uigetfile('*.avi', 'Select a video');
  if ~ischar(chosenfile)
    return;   %user canceled dialog
  end
  filename = fullfile(chosenpath, chosenfile);
  set(handles.edit1, filename);
function play_Callback(hobject, event, handles)
  filename = get(handles.edit1, filename);
  if ~exist(filename, 'file')
    warndlg( 'Text in edit box is not the name of a file');
    return
  end
  try
    obj = VideoReader(filename);
  catch
    warndlg( 'File named in edit box does not appear to be a usable movie file');
    return
  end
    ax = handles.ax1;
    while hasFrame(obj)
        vidFrame = readFrame(obj);
        image(vidFrame, 'Parent', ax);
        set(ax, 'Visible', 'off');
        pause(1/obj.FrameRate);
    end
    clear obj