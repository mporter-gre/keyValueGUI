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

% Last Modified by GUIDE v2.5 21-Oct-2016 01:05:17

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

loadKeyValLib(handles);
populateProjects(handles);




% --- Executes on selection change in projectDropdown.
function projectDropdown_Callback(hObject, eventdata, handles)
% hObject    handle to projectDropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns projectDropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from projectDropdown

projVal = get(hObject, 'Value');
if projVal == 1
    return;
end

populateDatasets(handles);


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


% --- Executes on selection change in datasetDropdown.
function datasetDropdown_Callback(hObject, eventdata, handles)
% hObject    handle to datasetDropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns datasetDropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from datasetDropdown

global session;

dsVal = get(hObject, 'Value')-1;
if dsVal == 0
    return;
end

dsIds = getappdata(handles.keyval, 'dsIds');
dsId = dsIds(dsVal);

images = getImages(session, 'dataset', dsId);

numImages = length(images);
if numImages == 0
    set(handles.imagesListbox, 'Value', 1);
    set(handles.imagesListbox, 'String', 'No images in this dataset');
    return;
end

imageNameId{numImages,2} = [];
dsNameList{numImages} = [];

for thisImg = 1:numImages
    imageNameId{thisImg,1} = char(images(thisImg).getName.getValue.getBytes');
    imageNameId{thisImg,2} = num2str(images(thisImg).getId.getValue);
end

imageNameId = sortrows(imageNameId);
imageNameList{1} = 'All images in dataset';
for thisImg = 1:numImages
    imageNameList{thisImg+1} = imageNameId{thisImg, 1};
    imageIdList(thisImg) = str2double(imageNameId{thisImg, 2});
end

set(handles.imagesListbox, 'Value', []);
set(handles.imagesListbox, 'String', imageNameList);
setappdata(handles.keyval, 'imageNames', imageNameList);
setappdata(handles.keyval, 'imageIds', imageIdList);
set(handles.imagesListbox, 'Enable', 'on');



% --- Executes during object creation, after setting all properties.
function datasetDropdown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datasetDropdown (see GCBO)
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
    projNameId{thisProj,1} = char(projects(thisProj).getName.getValue.getBytes');
    projNameId{thisProj,2} = projects(thisProj).getId.getValue;
end

projNameId = sortrows(projNameId);

for thisProj = 1:numProj
    projNames{thisProj+1} = projNameId{thisProj,1};
    projIds(thisProj) = projNameId{thisProj,2};
end

set(handles.projectDropdown, 'String', projNames);
setappdata(handles.keyval, 'projects', projects);
setappdata(handles.keyval, 'projIds', projIds);
setappdata(handles.keyval, 'projNames', projNames);



function populateDatasets(handles)
global session;

projVal = get(handles.projectDropdown, 'Value')-1;
projIds = getappdata(handles.keyval, 'projIds');
projId = projIds(projVal);
project = getProjects(session, projId);
datasets = toMatlabList(project.linkedDatasetList);

numDs = length(datasets);
if numDs == 0
    set(handles.datasetDropdown, 'Value', 1);
    set(handles.datasetDropdown, 'String', 'No datasets in this project');
    return;
end

dsNameId{numDs,2} = [];
dsNameList{numDs} = [];

for thisDs = 1:numDs
    dsNameId{thisDs,1} = char(datasets(thisDs).getName.getValue.getBytes');
    dsNameId{thisDs,2} = num2str(datasets(thisDs).getId.getValue);
end

dsNameId = sortrows(dsNameId);
dsNameList{1} = 'Select a dataset';
for thisDs = 1:numDs
    dsNameList{thisDs+1} = dsNameId{thisDs, 1};
    dsIdList(thisDs) = str2double(dsNameId{thisDs, 2});
end

set(handles.datasetDropdown, 'String', dsNameList);
setappdata(handles.keyval, 'dsNames', dsNameList);
setappdata(handles.keyval, 'dsIds', dsIdList);
set(handles.datasetDropdown, 'Enable', 'on');



function loadKeyValLib(handles)
global session

secCon = session.getSecurityContexts;
groupId = secCon(1).get(0).getId.getValue;
images = getImages(session, 'group', groupId);
maps = getObjectAnnotations(session, 'map', 'image', images, 'flatten', true);

numMaps = length(maps);
counter = 1;
keyLib{1} = 'Add new key';
for thisMap = 1:numMaps
    map = maps(thisMap).getMapValue;
    numKeys = length(map);
    for thisKey = 0:numKeys-1
        keyLib{counter+1} = char(map.get(thisKey).name.getBytes');
        valLib{counter} = char(map.get(thisKey).value.getBytes');
        counter = counter + 1;
    end
end

set(handles.keyAutoList, 'String', keyLib);
setappdata(handles.keyval, 'keyLib', keyLib);
setappdata(handles.keyval, 'valLib', valLib);


% --- Executes on selection change in keyAutoList.
function keyAutoList_Callback(hObject, eventdata, handles)
% hObject    handle to keyAutoList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns keyAutoList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from keyAutoList

keyVal = get(hObject, 'Value');
if keyVal == 1
    newKey = inputdlg('Enter a new key:', 'New key');
    set(handles.valAutoList, 'Value', 1);
    set(handles.valAutoList, 'String', 'Add new value');
else
    keys = get(hObject, 'String');
    selectedKey = keys{keyVal};
    %Do some query on this key to get values. Handle no values? Then
    %populate valAutoList
end


% --- Executes during object creation, after setting all properties.
function keyAutoList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to keyAutoList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in valAutoList.
function valAutoList_Callback(hObject, eventdata, handles)
% hObject    handle to valAutoList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns valAutoList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from valAutoList


% --- Executes during object creation, after setting all properties.
function valAutoList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valAutoList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in keyValTbl.
function keyValTbl_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to keyValTbl (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

% eventdata.Indices
% eventdata.NewData
% eventdata.EditData



% --- Executes on key press with focus on keyValTbl and none of its controls.
function keyValTbl_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to keyValTbl (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


keyValTbl_CellEditCallback(hObject, eventdata, handles)
tbl = handles.keyValTbl;
tbl.Data
keyLib = getappdata(handles.keyval, 'keyLib');
valLib = getappdata(handles.keyval, 'valLib');
typeText = getappdata(handles.keyval, 'typeText');
lastChar = eventdata.Character;
typeText = [typeText lastChar];
textFound = strfind(lower(keyLib), lower(typeText));
idx = cellfun('isempty', textFound);
textMatches = keyLib(~idx);
set(handles.keyAutoList, 'String', textMatches);
setappdata(handles.keyval, 'typeText', typeText);



function populateValAutoList(handles)

keyVal = get(handles.keyAutoList, 'Value');
keys = get(handles.keyAutoList, 'String');
selectedkey = keys{keyVal};

