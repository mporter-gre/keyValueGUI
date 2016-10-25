function varargout = connectionDlg(varargin)
% CONNECTIONDLG MATLAB code for connectionDlg.fig
%      CONNECTIONDLG by itself, creates a new CONNECTIONDLG or raises the
%      existing singleton*.
%
%      H = CONNECTIONDLG returns the handle to a new CONNECTIONDLG or the handle to
%      the existing singleton*.
%
%      CONNECTIONDLG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONNECTIONDLG.M with the given input arguments.
%
%      CONNECTIONDLG('Property','Value',...) creates a new CONNECTIONDLG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before connectionDlg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to connectionDlg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help connectionDlg

% Last Modified by GUIDE v2.5 20-Oct-2016 01:43:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @connectionDlg_OpeningFcn, ...
                   'gui_OutputFcn',  @connectionDlg_OutputFcn, ...
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

% --- Executes just before connectionDlg is made visible.
function connectionDlg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to connectionDlg (see VARARGIN)

% Choose default command line output for connectionDlg
handles.output = 'Yes';

setappdata(handles.connectionDlg, 'pass', '');

% Update handles structure
guidata(hObject, handles);

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Make the GUI modal
set(handles.connectionDlg,'WindowStyle','modal');

%check login history
checkLoginHistory(handles);
user = get(handles.userTxt, 'String');
if ~isempty(user)
    uicontrol(handles.passTxt);
else
    uicontrol(handles.userTxt);
end

% UIWAIT makes connectionDlg wait for user response (see UIRESUME)
uiwait(handles.connectionDlg);

% --- Outputs from this function are returned to the command line.
function varargout = connectionDlg_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.connectionDlg);

% --- Executes on button press in connectBtn.
function connectBtn_Callback(hObject, eventdata, handles)
% hObject    handle to connectBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global session
global client

handles.output = get(hObject,'String');

credentials{1} = get(handles.userTxt, 'String');
credentials{2} = getappdata(handles.connectionDlg, 'pass');
credentials{3} = get(handles.serverTxt, 'String');
credentials{4} = str2double(get(handles.portTxt, 'String'));

try
    client = omero.client(credentials{3}, credentials{4});
    session = client.createSession(credentials{1}, credentials{2});
catch    
    warndlg('Login failed. Check details', 'Connection failed.', 'modal');
    return;
end
client.enableKeepAlive(60);
saveHistory(credentials);

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.connectionDlg);

% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.connectionDlg);


% --- Executes when user attempts to close connectionDlg.
function connectionDlg_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to connectionDlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on key press over connectionDlg with no controls selected.
function connectionDlg_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to connectionDlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
    handles.output = 'No';
    
    % Update handles structure
    guidata(hObject, handles);
    
    uiresume(handles.connectionDlg);
end    
    
if isequal(get(hObject,'CurrentKey'),'return')
    uiresume(handles.connectionDlg);
end    



function userTxt_Callback(hObject, eventdata, handles)
% hObject    handle to userTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of userTxt as text
%        str2double(get(hObject,'String')) returns contents of userTxt as a double


% --- Executes during object creation, after setting all properties.
function userTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to userTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function passTxt_Callback(hObject, eventdata, handles)
% hObject    handle to passTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of passTxt as text
%        str2double(get(hObject,'String')) returns contents of passTxt as a double



% --- Executes during object creation, after setting all properties.
function passTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to passTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function serverTxt_Callback(hObject, eventdata, handles)
% hObject    handle to serverTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of serverTxt as text
%        str2double(get(hObject,'String')) returns contents of serverTxt as a double


% --- Executes during object creation, after setting all properties.
function serverTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to serverTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function portTxt_Callback(hObject, eventdata, handles)
% hObject    handle to portTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of portTxt as text
%        str2double(get(hObject,'String')) returns contents of portTxt as a double


% --- Executes during object creation, after setting all properties.
function portTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to portTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on key press with focus on passTxt and none of its controls.
function passTxt_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to passTxt (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

lastChar = eventdata.Character;
lastKey = eventdata.Key;
currPass = getappdata(handles.connectionDlg, 'pass');
charset = char(33:126);
if lastChar
    if any(charset == lastChar)
        password = [currPass lastChar];
    elseif strcmp(lastKey, 'backspace')
        password = currPass(1:end-1);
    elseif strcmp(lastKey, 'delete')
        password = '';
    elseif strcmp(lastKey, 'return')
        connectBtn_Callback(hObject, eventdata, handles);
        return;
    else
        return;
    end

    setappdata(handles.connectionDlg, 'pass', password);
    numChars = length(password);
    stars(1:numChars) = '*';
    set(hObject, 'String', stars);
    drawnow();
end


function populateProjects(handles)
global session;

projects = getProjects(session);
numProj = projects.size;
projNames{1} = 'Select a project';
for thisProj = 1:numProj
    projNames{thisProj+1} = char(projects(thisProj).getName.getValue.getBytes');
    projIds(thisProj) = projects(thisProj).getId.getValue;
end

set(handles.projectDropdown, 'String', projNames);
setappdata(handles.keyval, 'projects', projects);
setappdata(handles.keyval, 'projIds', projIds);
setappdata(handles.keyval, 'projNames', projNames);

    
function checkLoginHistory(handles)

if ispc
    sysUser = getenv('username');
    sysUserHome = getenv('userprofile');
    historyFile = [sysUserHome '\omero\analysisHistory.mat'];
else
    sysUser = getenv('USER');
    sysUserHome = getenv('HOME');
    historyFile = [sysUserHome '/omero/analysisHistory.mat'];
end
try
    history = open(historyFile);
    set(handles.userTxt, 'String', history.omeroUser);
    set(handles.serverTxt, 'String', history.omeroServer);
    try  %previous versions didn't include port details.
        set(handles.portTxt, 'String', history.omeroPort);
    catch
    end
    uicontrol(handles.passTxt);
catch
end



function saveHistory(credentials)

omeroUser = credentials{1};
omeroServer = credentials{3};
omeroPort = credentials{4};
if ispc
    sysUserHome = getenv('userprofile');
    sysUser = getenv('username');
    omeroDir = [sysUserHome '\omero'];
    historyFile = [sysUserHome '\omero\analysisHistory.mat'];
else
    sysUserHome = getenv('HOME');
    sysUser = getenv('USER');
    omeroDir = [sysUserHome '/omero'];
    historyFile = [sysUserHome '/omero/analysisHistory.mat'];
end

if ~isdir(omeroDir)
    mkdir(omeroDir)
end
save(historyFile, 'omeroUser', 'omeroServer', 'omeroPort');
