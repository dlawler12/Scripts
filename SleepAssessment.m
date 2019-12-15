function varargout = SleepAssessment(varargin)
% SLEEPASSESSMENT MATLAB code for SleepAssessment.fig
%      SLEEPASSESSMENT, by itself, creates a new SLEEPASSESSMENT or raises the existing
%      singleton*.
%
%      H = SLEEPASSESSMENT returns the handle to a new SLEEPASSESSMENT or the handle to
%      the existing singleton*.
%
%      SLEEPASSESSMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SLEEPASSESSMENT.M with the given input arguments.
%
%      SLEEPASSESSMENT('Property','Value',...) creates a new SLEEPASSESSMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SleepAssessment_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SleepAssessment_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SleepAssessment

% Last Modified by GUIDE v2.5 09-Jul-2019 10:28:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SleepAssessment_OpeningFcn, ...
                   'gui_OutputFcn',  @SleepAssessment_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SleepAssessment is made visible.
function SleepAssessment_OpeningFcn(hObject, eventdata, handles, varargin)
cd('Z:\SleepDemo')
load('SBControl190418')
load('corrected');
load('positions');
load('bouts');
load('Vals');
% load('IncorrectBouts');
load('Tracker');
for i = 1:4
    handles.TrackBox(i,1:4) = TimeAnalysis(1).File.Arena(i).TrackBox;
end
handles.corrected=corrected;
handles.positionsX=positionsX;
handles.positionsY=positionsY;
handles.awakeBouts=awakeBouts;
handles.sleepBouts=sleepBouts;
handles.filename = '20190418T140418.avi';
handles.SBCtrl = VideoReader(handles.filename);
handles.saveFileName='Vals.mat';
handles.start=[AC,AI,SC,SI];
handles.Vals=[AC,AI,SC,SI];
% handles.IncorrectBouts=IB;
% handles.IBStart=IB;
handles.Tracker = Track; %[correct(1) or incorrect(0),sleep(0) or awake(1),currentbout,startframe,framesatedge];
handles.TrStart = Track; %[correct(1) or incorrect(0),sleep(0) or awake(1),currentbout,startframe,framesatedge];
handles.edge = 0;
set(handles.AwakeCorrect, 'String', handles.Vals(1));
set(handles.AwakeIncorrect, 'String', handles.Vals(2));
set(handles.SleepCorrect, 'String', handles.Vals(3));
set(handles.SleepIncorrect, 'String', handles.Vals(4));

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SleepAssessment (see VARARGIN)

% Choose default command line output for SleepAssessment
handles.output = hObject;

% Update handles structure

guidata(hObject, handles);





% UIWAIT makes SleepAssessment wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SleepAssessment_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Sleep.
function Sleep_Callback(hObject, eventdata, handles)
% hObject    handle to Sleep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles
if handles.sleepOrAwake == 0
%     handles.c_SleepCorrect=handles.c_SleepCorrect+1;
%     set(handles.SleepCorrect, 'String', handles.c_SleepCorrect);
    handles.Vals(3)=handles.Vals(3)+1;
    set(handles.SleepCorrect, 'String', handles.Vals(3));
    a=1;
else
%     handles.c_AwakeIncorrect=handles.c_AwakeIncorrect+1;
%     set(handles.AwakeIncorrect, 'String', handles.c_AwakeIncorrect);
    handles.Vals(2)=handles.Vals(2)+1;
    set(handles.AwakeIncorrect, 'String', handles.Vals(2));
%     [num,~]=size(handles.IncorrectBouts);
%     handles.IncorrectBouts(num+1,:) = [handles.sleepOrAwake,handles.currentBout,handles.startFrame];
    a=0;
end

[num,~]=size(handles.Tracker);
handles.Tracker(num+1,:) = [a,handles.sleepOrAwake,handles.currentBout,handles.startFrame,handles.edge];

handles.output = hObject;
guidata(hObject, handles);

Start_Callback(hObject, eventdata, handles)



% --- Executes on button press in Awake.
function Awake_Callback(hObject, eventdata, handles)
% hObject    handle to Awake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles
if handles.sleepOrAwake == 1
%     handles.c_AwakeCorrect=handles.c_AwakeCorrect+1;
%     set(handles.AwakeCorrect, 'String', handles.c_AwakeCorrect);
    handles.Vals(1)=handles.Vals(1)+1;
    set(handles.AwakeCorrect, 'String', handles.Vals(1));
    a=1;
else
%     handles.c_SleepIncorrect=handles.c_SleepIncorrect+1;
%     set(handles.SleepIncorrect, 'String', handles.c_SleepIncorrect);
    handles.Vals(4)=handles.Vals(4)+1;
    set(handles.SleepIncorrect, 'String', handles.Vals(4));
%     [num,~]=size(handles.IncorrectBouts);
%     handles.IncorrectBouts(num+1,:) = [handles.sleepOrAwake,handles.currentBout,handles.startFrame];
    a=0;
end

[num,~]=size(handles.Tracker);
handles.Tracker(num+1,:) = [a,handles.sleepOrAwake,handles.currentBout,handles.startFrame,handles.edge];

handles.output = hObject;
guidata(hObject, handles);

Start_Callback(hObject, eventdata, handles)


    
% --- Executes on button press in Unsure.
function Unsure_Callback(hObject, eventdata, handles)
% hObject    handle to Unsure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% guidata(hObject, handles);
Start_Callback(hObject, eventdata, handles)

function Replay_Callback(hObject, eventdata, handles)
% hObject    handle to Unsure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% guidata(hObject, handles);
handles.SBCtrl.CurrentTime = handles.startFrame/30;

ax = handles.axes1;
i=60;
set(handles.Sleep,'enable','off')
set(handles.Awake,'enable','off')
set(handles.Unsure,'enable','off')
set(handles.Replay,'enable','off')
set(handles.Start,'enable','off')
set(handles.Save,'enable','off')
set(handles.Clear,'enable','off')
set(handles.Load,'enable','off')
set(handles.Create,'enable','off')
handles.edge = 0;
inside = 0;
    while hasFrame(handles.SBCtrl) && i>0
        inside = 0;
        handles.output = hObject;
        guidata(hObject, handles);
        I = readFrame(handles.SBCtrl);
        if handles.sleepOrAwake==0
            animal = handles.sleepBouts(handles.currentBout,1);
            frame = handles.sleepBouts(handles.currentBout,2)+(60-i);
        else
            animal = handles.awakeBouts(handles.currentBout,1);
            frame = handles.awakeBouts(handles.currentBout,2)+(60-i);            
        end
        %Check if it's in an arena
        x = handles.positionsX(animal,frame);
        y = handles.positionsY(animal,frame);
        for h = 1:4
            xmin = handles.TrackBox(h,1)+10;
            xmax = handles.TrackBox(h,1)+handles.TrackBox(h,3)-10;
            ymin = handles.TrackBox(h,2)+10;
            ymax = handles.TrackBox(h,2)+handles.TrackBox(h,4)-10;
            if x<xmax && x>xmin && y<ymax && y>ymin
                inside = 1;
            end
        end
        if inside == 0
            handles.edge=handles.edge+1;
        end
        circles = [x,y,20];
        RBG = insertShape(I,'Circle',circles,'Color','red','LineWidth',5);
    %     imshow(RBG)
        image(RBG,'Parent',handles.axes1);
        set(handles.axes1, 'Visible','off');
        pause(.1);
        i=i-1;
    end
set(handles.Sleep,'enable','on')
set(handles.Awake,'enable','on')
set(handles.Unsure,'enable','on')
set(handles.Replay,'enable','on')
set(handles.Start,'enable','on')
set(handles.Save,'enable','on')
set(handles.Clear,'enable','on')
set(handles.Load,'enable','on')
set(handles.Create,'enable','on')
handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sleepOrAwake=randi(2)-1;
if handles.sleepOrAwake==0
    handles.currentBout = randi(length(handles.sleepBouts));
    handles.startFrame = handles.sleepBouts(handles.currentBout,2);
else
    handles.currentBout = randi(length(handles.awakeBouts));
    handles.startFrame = handles.awakeBouts(handles.currentBout,2);
end
handles.output = hObject;
guidata(hObject, handles);

Replay_Callback(hObject, eventdata, handles)


%% All of the Correct/Incorrect Info below


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function SleepCorrect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SleepCorrect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function SleepIncorrect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SleepIncorrect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function AwakeCorrect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AwakeCorrect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function AwakeIncorrect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AwakeIncorrect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function text2_CreateFcn(hObject, eventdata, handles)
%
%
%

%
%


% --- Executes on key press with focus on Start and none of its controls.
function Start_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AC = handles.Vals(1);
AI = handles.Vals(2);
SC = handles.Vals(3);
SI = handles.Vals(4);

eval(['save ',handles.saveFileName,' AC AI SC SI']);

Track = handles.Tracker;
% IB = handles.IncorrectBouts;

% save IncorrectBouts.mat IB
save Tracker.mat Track

handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in Clear.
function Clear_Callback(hObject, eventdata, handles)
% hObject    handle to Clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.c_SleepCorrect=handles.SC;
% handles.c_SleepIncorrect=handles.SI;
% handles.c_AwakeCorrect=handles.AC;
% handles.c_AwakeIncorrect=handles.AI;
handles.Vals=handles.start;
% handles.IncorrectBouts = handles.IBStart;
handles.Tracker = handles.TrStart;

handles.output = hObject;
guidata(hObject, handles);

AC = handles.Vals(1);
AI = handles.Vals(2);
SC = handles.Vals(3);
SI = handles.Vals(4);

eval(['save ',handles.saveFileName,' AC AI SC SI']);

set(handles.AwakeCorrect, 'String', handles.Vals(1));
set(handles.AwakeIncorrect, 'String', handles.Vals(2));
set(handles.SleepCorrect, 'String', handles.Vals(3));
set(handles.SleepIncorrect, 'String', handles.Vals(4));

handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in Create.
function Create_Callback(hObject, eventdata, handles)
% hObject    handle to Create (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.saveFileName] = uiputfile('YourName.mat');
handles.start=[0,0,0,0];
handles.Vals=[0,0,0,0];

AC = handles.Vals(1);
AI = handles.Vals(2);
SC = handles.Vals(3);
SI = handles.Vals(4);

eval(['save ',handles.saveFileName,' AC AI SC SI']);

set(handles.AwakeCorrect, 'String', handles.Vals(1));
set(handles.AwakeIncorrect, 'String', handles.Vals(2));
set(handles.SleepCorrect, 'String', handles.Vals(3));
set(handles.SleepIncorrect, 'String', handles.Vals(4));

handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.mat');
load(file)

handles.saveFileName=file;
handles.start=[AC,AI,SC,SI];
handles.Vals=[AC,AI,SC,SI];

set(handles.AwakeCorrect, 'String', handles.Vals(1));
set(handles.AwakeIncorrect, 'String', handles.Vals(2));
set(handles.SleepCorrect, 'String', handles.Vals(3));
set(handles.SleepIncorrect, 'String', handles.Vals(4));

handles.output = hObject;
guidata(hObject, handles);
