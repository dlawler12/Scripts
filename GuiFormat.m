function varargout = GuiFormat(varargin)
% GUIFORMAT MATLAB code for GuiFormat.fig
%      GUIFORMAT, by itself, creates a new GUIFORMAT or raises the existing
%      singleton*.
%
%      H = GUIFORMAT returns the handle to a new GUIFORMAT or the handle to
%      the existing singleton*.
%
%      GUIFORMAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIFORMAT.M with the given input arguments.
%
%      GUIFORMAT('Property','Value',...) creates a new GUIFORMAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GuiFormat_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GuiFormat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GuiFormat

% Last Modified by GUIDE v2.5 05-Jul-2019 10:52:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GuiFormat_OpeningFcn, ...
                   'gui_OutputFcn',  @GuiFormat_OutputFcn, ...
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


% --- Executes just before GuiFormat is made visible.
function GuiFormat_OpeningFcn(hObject, eventdata, handles, varargin)
cd('Z:\Dan Lawler\Projects\Sleep\Odorants\SbasalControl\190418\data')
load('corrected');
load('positions');
load('bouts');
load('Vals');
handles.corrected=corrected;
handles.positionsX=positionsX;
handles.positionsY=positionsY;
handles.awakeBouts=awakeBouts;
handles.sleepBouts=sleepBouts;
handles.filename = '20190418T140418.avi';
handles.SBCtrl = VideoReader(handles.filename);
handles.sleepOrAwake=0;
handles.c_SleepCorrect=SC;
handles.c_SleepIncorrect=SI;
handles.c_AwakeCorrect=AC;
handles.c_AwakeIncorrect=AI;
handles.AC=AC;
handles.AI=AI;
handles.SC=SC;
handles.SI=SI;
handles.startFrame=0;

set(handles.AwakeCorrect, 'String', handles.c_AwakeCorrect);
set(handles.SleepCorrect, 'String', handles.c_SleepCorrect);
set(handles.AwakeIncorrect, 'String', handles.c_AwakeIncorrect);
set(handles.SleepIncorrect, 'String', handles.c_SleepIncorrect);

% handles.SleepCorrect = 1;

% set(handles.SleepCorrect, 'String', 1)

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GuiFormat (see VARARGIN)

% Choose default command line output for GuiFormat
handles.output = hObject;

% Update handles structure

guidata(hObject, handles);





% UIWAIT makes GuiFormat wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GuiFormat_OutputFcn(hObject, eventdata, handles) 
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
    handles.c_SleepCorrect=handles.c_SleepCorrect+1;
    set(handles.SleepCorrect, 'String', handles.c_SleepCorrect);
else
    handles.c_AwakeIncorrect=handles.c_AwakeIncorrect+1;
    set(handles.AwakeIncorrect, 'String', handles.c_AwakeIncorrect);
end
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
    handles.c_AwakeCorrect=handles.c_AwakeCorrect+1;
    set(handles.AwakeCorrect, 'String', handles.c_AwakeCorrect);
else
    handles.c_SleepIncorrect=handles.c_SleepIncorrect+1;
    set(handles.SleepIncorrect, 'String', handles.c_SleepIncorrect);
end
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
    while hasFrame(handles.SBCtrl) && i>0
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
        circles = [handles.positionsX(animal,frame),handles.positionsY(animal,frame),20];
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
SC = handles.c_SleepCorrect;
SI = handles.c_SleepIncorrect;
AC = handles.c_AwakeCorrect;
AI = handles.c_AwakeIncorrect;
save Vals.mat SC SI AC AI

handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in Clear.
function Clear_Callback(hObject, eventdata, handles)
% hObject    handle to Clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.c_SleepCorrect=handles.SC;
handles.c_SleepIncorrect=handles.SI;
handles.c_AwakeCorrect=handles.AC;
handles.c_AwakeIncorrect=handles.AI;

handles.output = hObject;
guidata(hObject, handles);

SC = handles.c_SleepCorrect;
SI = handles.c_SleepIncorrect;
AC = handles.c_AwakeCorrect;
AI = handles.c_AwakeIncorrect;
save Vals.mat SC SI AC AI

set(handles.AwakeCorrect, 'String', handles.c_AwakeCorrect);
set(handles.SleepCorrect, 'String', handles.c_SleepCorrect);
set(handles.AwakeIncorrect, 'String', handles.c_AwakeIncorrect);
set(handles.SleepIncorrect, 'String', handles.c_SleepIncorrect);

handles.output = hObject;
guidata(hObject, handles);