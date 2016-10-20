function varargout = keyval(varargin)
% KEYVAL MATLAB code for keyval.fig
%      KEYVAL, by itself, creates a new KEYVAL or raises the existing
%      singleton*.
%
%      H = KEYVAL returns the handle to a new KEYVAL or the handle to
%      the existing singleton*.
%
%      KEYVAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KEYVAL.M with the given input arguments.
%
%      KEYVAL('Property','Value',...) creates a new KEYVAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before keyval_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to keyval_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help keyval

% Last Modified by GUIDE v2.5 19-Oct-2016 22:11:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @keyval_OpeningFcn, ...
                   'gui_OutputFcn',  @keyval_OutputFcn, ...
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


% --- Executes just before keyval is made visible.
function keyval_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to keyval (see VARARGIN)

% Choose default command line output for keyval

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes keyval wait for user response (see UIRESUME)
% uiwait(handles.keyval);


% --- Outputs from this function are returned to the command line.
function varargout = keyval_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

global client;
global session;
connectionDlg;

if ~isjava(session)
    warndlg('No connection found. Please exit the application', 'No Connection', 'modal');
    return;
end

populateProjects(handles);




% --- Executes on selection change in projectDropdown.
function projectDropdown_Callback(hObject, eventdata, handles)
% hObject    handle to projectDropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns projectDropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from projectDropdown


% --- Executes during object creation, after setting all properties.
function projectDropdown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectDropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in datasetPulldown.
function datasetPulldown_Callback(hObject, eventdata, handles)
% hObject    handle to datasetPulldown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns datasetPulldown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from datasetPulldown


% --- Executes during object creation, after setting all properties.
function datasetPulldown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datasetPulldown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in imagesListbox.
function imagesListbox_Callback(hObject, eventdata, handles)
% hObject    handle to imagesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns imagesListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imagesListbox


% --- Executes during object creation, after setting all properties.
function imagesListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imagesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadFormBtn.
function loadFormBtn_Callback(hObject, eventdata, handles)
% hObject    handle to loadFormBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in saveFormBtn.
function saveFormBtn_Callback(hObject, eventdata, handles)
% hObject    handle to saveFormBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function proformaNameTxt_Callback(hObject, eventdata, handles)
% hObject    handle to proformaNameTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of proformaNameTxt as text
%        str2double(get(hObject,'String')) returns contents of proformaNameTxt as a double


% --- Executes during object creation, after setting all properties.
function proformaNameTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to proformaNameTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in projectCheck.
function projectCheck_Callback(hObject, eventdata, handles)
% hObject    handle to projectCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of projectCheck


% --- Executes on button press in datasetCheck.
function datasetCheck_Callback(hObject, eventdata, handles)
% hObject    handle to datasetCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of datasetCheck


% --- Executes on button press in imagesCheck.
function imagesCheck_Callback(hObject, eventdata, handles)
% hObject    handle to imagesCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imagesCheck


% --- Executes on button press in saveBtn.
function saveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to saveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in viewBtn.
function viewBtn_Callback(hObject, eventdata, handles)
% hObject    handle to viewBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close keyval.
function keyval_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to keyval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global client
global session

if isjava(client)
    client.closeSession;
end
delete(hObject);


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

    
