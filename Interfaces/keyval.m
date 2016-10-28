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

% Last Modified by GUIDE v2.5 28-Oct-2016 13:38:12

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

startDiary(handles);

positionWindow(handles)

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
username = connectionDlg;

if ~isjava(session)
    warndlg('No connection found. Please exit the application', 'No Connection', 'modal');
    return;
end

adminService = session.getAdminService;
userObj = adminService.lookupExperimenter(username);
userId = userObj.getId.getValue;
currDefaultGroup = char(adminService.getDefaultGroup(userId).getName.getValue.getBytes');
currDefaultGroupId = adminService.getDefaultGroup(userId).getId.getValue;

setappdata(handles.keyval, 'groupId', currDefaultGroupId);

loadKeyValLib(handles);
populateUsers(handles);
populateProjects(handles);
populateGroups(handles);




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
setappdata(handles.keyval, 'imageId', []);



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


% --- Executes on selection change in projectDropdown.
function datasetDropdown_Callback(hObject, eventdata, handles)
% hObject    handle to projectDropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns projectDropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from projectDropdown

populateImages(handles)
setappdata(handles.keyval, 'imageId', []);



% --- Executes during object creation, after setting all properties.
function datasetDropdown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectDropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in projectDropdown.
function imagesListbox_Callback(hObject, eventdata, handles)
% hObject    handle to projectDropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns projectDropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from projectDropdown

imageIdx = get(hObject, 'Value')-1;
imageNames = get(hObject, 'String');
imageName = imageNames{imageIdx+1};
lastChar = imageName(end);


if numel(imageIdx)==1 && strcmp(lastChar, '*')
    imageIds = getappdata(handles.keyval, 'imageIds');
    imageId = imageIds(imageIdx);
    setappdata(handles.keyval, 'imageId', imageId);
    set(handles.viewBtn, 'Enable', 'on');
else
    set(handles.viewBtn, 'Enable', 'off');
end

%Dis/enable the save button
tblData = get(handles.keyValTbl, 'Data');
if ~isempty(tblData)
    set(handles.saveBtn, 'Enable', 'on');
else
    set(handles.saveBtn, 'Enable', 'off');
end

setappdata(handles.keyval, 'imageName', imageName');


% --- Executes during object creation, after setting all properties.
function imagesListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectDropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveBtn.
function saveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to saveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imageIdxs = get(handles.projectDropdown, 'Value')-1;
imageIdList = getappdata(handles.keyval, 'imageIds');
if imageIdxs == 0
    imageIds = imageIdList;
else
    imageIds = imageIdList(imageIdxs);
end

tblData = get(handles.keyValTbl, 'Data');
tblData = sortrows(tblData);
tblKeys = tblData(:,1);
tblVals = tblData(:,2);

mapToImages(handles, imageIds, tblKeys, tblVals);

%Refresh image list
populateImages(handles)
msgbox('Annotation saved', 'Saved');



function mapToImages(handles, imageIds, tblKeys, tblVals)
global session

updateService = session.getUpdateService;
contexts = session.getSecurityContexts;
groupId = getappdata(handles.keyval, 'groupId');
numImages = length(imageIds);

for thisImage = 1:numImages
    maps = getObjectAnnotations(session, 'map', 'image', imageIds(thisImage), 'flatten', true);
    if ~isempty(maps)
        %Get all the keyVals alread on the image
        numMaps = length(maps);
        counter = 1;
        for thisMap = 1:numMaps
            map = maps(thisMap).getMapValue;
            numKeys = map.size;
            for thisKey = 0:numKeys-1
                imgKeys{counter} = char(map.get(thisKey).name.getBytes');
                imgVals{counter} = char(map.get(thisKey).value.getBytes');
                counter = counter + 1;
            end
        end
        %Compare imgKey/Vals with those to save
        commonKeys = ismember(tblKeys, imgKeys);
        commonVals = ismember(tblVals, imgVals);
        commonPairs = commonKeys .* commonVals;
        pairsToAdd = find(~commonPairs);
        finalKeys = [imgKeys tblKeys(pairsToAdd)'];
        finalVals = [imgVals tblVals(pairsToAdd)'];
        
        % Create java ArrayList of NamedValue objects
        nv = java.util.ArrayList();
        for i = 1 : numel(finalKeys)
            nv.add(omero.model.NamedValue(finalKeys{i}, finalVals{i}));
        end
        
        maps(1).setMapValue(nv);
        
        ma = updateService.saveAndReturnObject(maps(1));
    else
        %No map for this image? Just write the new one
        annotation = writeMapAnnotation(session, tblKeys, tblVals, 'namespace', 'openmicroscopy.org/omero/client/mapAnnotation', 'group', groupId);
        link = linkAnnotation(session, annotation, 'image', imageIds(thisImage));
    end
end




% --- Executes on button press in viewBtn.
function viewBtn_Callback(hObject, eventdata, handles)
% hObject    handle to viewBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

viewerH = getappdata(handles.keyval, 'viewerH');
imageId = getappdata(handles.keyval, 'imageId');
imageName = getappdata(handles.keyval, 'imageName');

if ~isempty(viewerH)
    delete(viewerH.imageKeyValViewer);
end
imageKeyValViewer(handles, imageId, imageName');




% --- Executes when user attempts to close keyval.
function keyval_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to keyval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global client
global session

viewerH = getappdata(handles.keyval, 'viewerH');

if ~isempty(viewerH)
    delete(viewerH.imageKeyValViewer);
end

if isjava(client)
    client.closeSession;
end

diary off

delete(hObject);


function populateProjects(handles)
global session;

userIdToView = getappdata(handles.keyval, 'userIdToView');

projects = getProjects(session, 'owner', userIdToView);

if isempty(projects)
    set(handles.projectDropdown, 'String', 'No projects for this user');
    set(handles.projectDropdown, 'Enable', 'off');
    return;
else
    set(handles.projectDropdown, 'Enable', 'on');
end

numProj = projects.size;
projNames{1} = 'Select a Project';
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
set(handles.projectDropdown, 'Value', 1);
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
set(handles.datasetDropdown, 'Value', 1);
set(handles.imagesListbox, 'Value', 1);
set(handles.imagesListbox, 'String', 'All images in dataset');
set(handles.imagesListbox, 'Enable', 'off');
setappdata(handles.keyval, 'dsNames', dsNameList);
setappdata(handles.keyval, 'dsIds', dsIdList);
setappdata(handles.keyval, 'projId', projId);
set(handles.datasetDropdown, 'Enable', 'on');
set(handles.viewBtn, 'Enable', 'off');



function loadKeyValLib(handles)
global session

keyLib = {};
valLib = {};
secCon = session.getSecurityContexts;
groupId = getappdata(handles.keyval, 'groupId');
maps = getObjectAnnotations(session, 'map', 'image', [], 'owner', -1, 'group', groupId, 'flatten', true);

numMaps = length(maps);
counter = 1;
for thisMap = 1:numMaps
    map = maps(thisMap).getMapValue;
    numKeys = map.size();
    for thisKey = 0:numKeys-1
        keyLib{counter} = char(map.get(thisKey).name.getBytes');
        valLib{counter} = char(map.get(thisKey).value.getBytes');
        counter = counter + 1;
    end
end

if ~isempty(keyLib) && ~isempty(valLib)
    keyLib = unique(keyLib);
    valLib = unique(valLib);
    set(handles.keyAutoList, 'String', keyLib);
    set(handles.keyAutoList, 'Value', 1);
    set(handles.keyAutoList, 'String', keyLib);
    setappdata(handles.keyval, 'keyLib', keyLib);
    setappdata(handles.keyval, 'valLib', valLib);
    setappdata(handles.keyval, 'maps', maps);
    populateValAutoList(handles);
end


setappdata(handles.keyval, 'maps', maps);
setappdata(handles.keyval, 'groupId', groupId);
setappdata(handles.keyval, 'securityContexts', secCon);


% --- Executes on selection change in keyAutoList.
function keyAutoList_Callback(hObject, eventdata, handles)
% hObject    handle to keyAutoList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns keyAutoList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from keyAutoList

if isempty(get(hObject, 'String'))
    return;
end
newPairs = getappdata(handles.keyval, 'newPairs');
valList = get(handles.valAutoList, 'String');
keyVal = get(hObject, 'Value');

keys = get(hObject, 'String');
selectedKey = keys{keyVal};
vals = findValsFromKey(handles, selectedKey);

set(handles.valAutoList, 'Value', 1);
set(handles.valAutoList, 'String', vals');
setappdata(handles.keyval, 'selectedKey', selectedKey);

if get(handles.keyAutoList, 'Value') > 0 && get(handles.valAutoList, 'Value') > 0
    set(handles.addPairBtn, 'Enable', 'on');
else
    set(handles.addPairBtn, 'Enable', 'off');
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

if isempty(get(hObject, 'String'))
    return;
end

newPairs = getappdata(handles.keyval, 'newPairs');
valVal = get(hObject, 'Value');
valList = get(hObject, 'String');

selectedVal = valList{valVal};
setappdata(handles.keyval, 'selectedVal', selectedVal);

if get(handles.keyAutoList, 'Value') > 0 && get(handles.valAutoList, 'Value') > 0
    set(handles.addPairBtn, 'Enable', 'on');
else
    set(handles.addPairBtn, 'Enable', 'off');
end


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

newPairs = getappdata(handles.keyval, 'newPairs');
tblIdx = eventdata.Indices;
tblData = hObject.Data;
key = tblData{tblIdx(1), 1};
newVal = eventdata.NewData;

vals = findValsFromKey(handles, key);
valExists = ismember(newVal, vals);

if valExists
    return;
end

answer = questdlg([{'This looks like a new Value.'};{'Would you like to add it to the list?'}], 'New Value', 'Yes', 'No', 'Yes');

if strcmp(answer, 'No')
    tblData{tblIdx(1), tblIdx(2)} = eventdata.PreviousData;
    set(handles.keyValTbl, 'Data', tblData);
    return;
end
keys = get(handles.keyAutoList, 'String');
keyIdx = ismember(keys, key);
keyIdx = find(keyIdx);
valString = ['Create a new value', vals, newVal];
valIdx = length(valString);
set(handles.keyAutoList, 'Value', keyIdx);
set(handles.valAutoList, 'Value', valIdx);
set(handles.valAutoList, 'String', valString);
newPairs = [newPairs; {key, newVal}];
setappdata(handles.keyval, 'newPairs', newPairs);




% --- Executes on key press with focus on keyValTbl and none of its controls.
function keyValTbl_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to keyValTbl (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)




function populateValAutoList(handles)

keyVal = get(handles.keyAutoList, 'Value');
keys = get(handles.keyAutoList, 'String');
selectedKey = keys{keyVal};

vals = findValsFromKey(handles, selectedKey);

set(handles.valAutoList, 'Value', 1);
set(handles.valAutoList, 'String', vals');
setappdata(handles.keyval, 'selectedKey', selectedKey);


function vals = findValsFromKey(handles, key)

vals = {};
maps = getappdata(handles.keyval, 'maps');
newPairs = getappdata(handles.keyval, 'newPairs');
counter = 1;
numMaps = length(maps);
for thisMap = 1:numMaps
    map = maps(thisMap).getMapValue;
    numKeys = map.size();
    for thisKey = 0:numKeys-1
        if strcmp(key, char(map.get(thisKey).name.getBytes'))
            vals{counter} = char(map.get(thisKey).value.getBytes');
            counter = counter + 1;
        end
    end
end

if ~isempty(newPairs)
    %Find vals from newly created pairs that are not in map objects.
    pairIdxs = find(ismember(newPairs, key));
    if ~isempty(pairIdxs)
        for thisIdx = 1:length(pairIdxs)
            vals{counter} = newPairs{pairIdxs(thisIdx),2};
            counter = counter + 1;
        end;
    end
end

vals = unique(vals);

    
    

% --- Executes on button press in addPairBtn.
function addPairBtn_Callback(hObject, eventdata, handles)
% hObject    handle to addPairBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

keyVal = get(handles.keyAutoList, 'Value');
valVal = get(handles.valAutoList, 'Value');
keys = get(handles.keyAutoList, 'String');
vals = get(handles.valAutoList, 'String');
key = keys(keyVal);
val = vals(valVal);
tbl = get(handles.keyValTbl);
data = tbl.Data;
if ~isempty(data)
    keyIdx = ismember(data(:,1), key);
    valIdx = ismember(data(:,2), val);
    commonIdxs = keyIdx .* valIdx;
    if find(commonIdxs)
        warndlg('This key/value pair is already in the list.', 'Already added');
        return;
    end
    [numRows, ~] = size(data);
    rowAdded = 0;
    for thisRow = 1:numRows
        if isempty(data{thisRow,1})
            data(thisRow,1) = key;
            data(thisRow,2) = val;
            newData = data;
            rowAdded = 1;
            break;
        end
    end
    if rowAdded == 0
        newRow = [key val];
        newData = [data; newRow];
    end
else
    newData(1,1) = key;
    newData(1,2) = val;
end

%Dis/enable the save button
imageId = getappdata(handles.keyval, 'imageId');
if ~isempty(newData) && ~isempty(imageId)
    set(handles.saveBtn, 'Enable', 'on');
    set(handles.removeBtn, 'Enable', 'on');
else
    set(handles.saveBtn, 'Enable', 'off');
    set(handles.saveBtn, 'Enable', 'off');
    set(handles.clearTblBtn, 'Enable', 'off');
end

set(handles.clearTblBtn, 'Enable', 'on');
set(handles.keyValTbl, 'Data', newData);


% --- Executes during object creation, after setting all properties.
function keyValTbl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to keyValTbl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject, 'Data', cell(0));


function populateImages(handles)

global session;

dsVal = get(handles.datasetDropdown, 'Value')-1;
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
    imageName = char(images(thisImg).getName.getValue.getBytes');
    imageId = images(thisImg).getId.getValue;
    %Check for a map attached to this image
    maps = getObjectAnnotations(session, 'map', 'image', imageId, 'owner', -1, 'flatten', true);
    if ~isempty(maps)
        %Add an asteris to the image name
        imageName = [imageName ' *'];
    end
    imageNameId{thisImg,1} = imageName;
    imageNameId{thisImg,2} = num2str(imageId);
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
setappdata(handles.keyval, 'dsId', dsId);
set(handles.imagesListbox, 'Enable', 'on');
set(handles.viewBtn, 'Enable', 'off');


function positionWindow(handles)

%Get window position and dimensions
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(handles.keyval, 'Units');
set(handles.keyval, 'Units', 'pixels');
OldPos = get(handles.keyval,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);

%Centre to the screen
ScreenUnits=get(0,'Units');
set(0,'Units','pixels');
ScreenSize=get(0,'ScreenSize');
set(0,'Units',ScreenUnits);

FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
FigPos(3:4)=[FigWidth FigHeight];

%Put the units back to Characters
set(handles.keyval, 'Position', FigPos);
set(handles.keyval, 'Units', OldUnits);


% --- Executes on button press in removeBtn.
function removeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to removeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tblData = get(handles.keyValTbl, 'Data');
tblIdx = getappdata(handles.keyval, 'tblIdx');
tblData(tblIdx(1), :) = [];
tblSize = numel(tblData);
if tblSize == 0
    set(handles.saveBtn, 'Enable', 'off');
end
set(handles.keyValTbl, 'Data', tblData);
set(handles.removeBtn, 'Enable', 'off');


% --- Executes when selected cell(s) is changed in keyValTbl.
function keyValTbl_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to keyValTbl (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

tblIdx = eventdata.Indices;
setappdata(handles.keyval, 'tblIdx', tblIdx);

if ~isempty(tblIdx)
    set(handles.removeBtn, 'Enable', 'on');
else
    set(handles.removeBtn, 'Enable', 'of');
end



% --- Executes on button press in createValueBtn.
function createValueBtn_Callback(hObject, eventdata, handles)
% hObject    handle to createValueBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newPairs = getappdata(handles.keyval, 'newPairs');
valList = get(handles.valAutoList, 'String');

selectedKey = getappdata(handles.keyval, 'selectedKey');
newVal = inputdlg(['Please enter the new Value for Key ' selectedKey '.'], 'New Value');
if isempty(newVal)
    return;
end
newVal = strtrim(newVal{1});
valList = [valList; newVal];
newPairs{end+1,1} = selectedKey;
newPairs{end,2} = newVal;
numVals = length(valList);
set(handles.valAutoList, 'String', valList);
set(handles.valAutoList, 'Value', numVals);
setappdata(handles.keyval, 'selectedVal', newVal);
setappdata(handles.keyval, 'newPairs', newPairs);


% --- Executes during object creation, after setting all properties.
function createKeyValBtn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to createKeyValBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in createKeyValBtn.
function createKeyValBtn_Callback(hObject, eventdata, handles)
% hObject    handle to createKeyValBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newPairs = getappdata(handles.keyval, 'newPairs');
keys = get(handles.keyAutoList, 'String');
keyLib = getappdata(handles.keyval, 'keyLib');
[newKey, newVal] = newKeyValDlg;
newKey = strtrim(newKey);
newVal = strtrim(newVal);

if isempty(newKey)
    return;
end

if ismember(lower(newKey), lower(keyLib))
    msgbox('This key is already available', 'Existing key');
    return;
end

if ismember(lower(newKey), lower(newPairs))
    msgbox('This key is already available', 'Existing key');
    return;
end

numNewVals = numel(newVal);

for thisVal = 1:numNewVals
    holder{thisVal,1} = newKey;
    holder{thisVal,2} = newVal{thisVal};
end

newPairs = [newPairs; holder];
keys = [keys; newKey];
numKeys = numel(keys);
set(handles.keyAutoList, 'String', keys);
set(handles.keyAutoList, 'Value', numKeys);
set(handles.valAutoList, 'Value', 1);
set(handles.valAutoList, 'String', newVal);

setappdata(handles.keyval, 'newPairs', newPairs);


function startDiary(handles)

if ispc
    sysUserHome = getenv('userprofile');
    omeroDir = [sysUserHome '\omero'];
    logFile = [sysUserHome '\omero\keyvalLog.log'];
else
    sysUserHome = getenv('HOME');
    omeroDir = [sysUserHome '/omero'];
    logFile = [sysUserHome '/omero/keyvalLog.log'];
end

if ~isdir(omeroDir)
    mkdir(omeroDir);
end
if exist(logFile, 'file') == 2
    delete(logFile);
end

diary(logFile);


% --- Executes on selection change in projectDropdown.
function userDropdown_Callback(hObject, eventdata, handles)
% hObject    handle to projectDropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns projectDropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from projectDropdown

userIdToView = getappdata(handles.keyval, 'userIdToView');
groupUserIds = getappdata(handles.keyval, 'groupUserIds');
groupUserNames = getappdata(handles.keyval, 'groupUserNames');
userVal = get(handles.userDropdown, 'Value');
newUserName = groupUserNames(userVal);
newUserId = groupUserIds(userVal);
if userIdToView == newUserId
    return;
end

setappdata(handles.keyval, 'userIdToView', newUserId);
populateProjects(handles)
set(handles.datasetDropdown, 'Value', 1);
set(handles.datasetDropdown, 'Enable', 'off');
set(handles.imagesListbox, 'Enable', 'off');
set(handles.imagesListbox, 'Value', 1);
set(handles.imagesListbox, 'String', 'All images in dataset');
set(handles.viewBtn, 'Enable', 'off');



% --- Executes during object creation, after setting all properties.
function userDropdown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectDropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function populateUsers(handles)
global session

%Get all users in the group.
groupId = getappdata(handles.keyval, 'groupId');
adminService = session.getAdminService;
eventContext = adminService.getEventContext;
username = char(eventContext.userName.getBytes');
userId = eventContext.userId;
groupObj = adminService.getGroup(eventContext.groupId);
groupPermissions = groupObj.getDetails.getPermissions;
groupRead = groupPermissions.isGroupRead;

if ~groupRead
    set(handles.userDropdown, 'String', username);
    set(handles.userDropdown, 'Enable', 'off');
    setappdata(handles.keyval, 'groupUserNames', username);
    setappdata(handles.keyval, 'groupUserIds', userId);
    setappdata(handles.keyval, 'userIdToView', userId);
else
    groupUserNamesIds = {};
    groupUsers = groupObj.linkedExperimenterList;
    userIter = groupUsers.iterator;
    while userIter.hasNext
        thisUser = userIter.next;
        groupUserNamesIds{end+1,1} = char(thisUser.getOmeName.getValue.getBytes');
        groupUserNamesIds{end,2} = num2str(thisUser.getId.getValue);
    end
    groupUserNamesIds = sortrows(groupUserNamesIds);
    [numUsers, ~] = size(groupUserNamesIds);
    groupUserNames = {};
    groupUserIds = [];
    for thisUser = 1:numUsers
        groupUserNames{end+1} = groupUserNamesIds{thisUser,1};
        groupUserIds(end+1) = str2double(groupUserNamesIds{thisUser,2});
    end
    userMatch = strfind(groupUserNames, username);
    userIdx = find(not(cellfun('isempty', userMatch)));
    set(handles.userDropdown, 'String', groupUserNames);
    set(handles.userDropdown, 'Value', userIdx);
    
    setappdata(handles.keyval, 'groupUserNames', groupUserNames);
    setappdata(handles.keyval, 'groupUserIds', groupUserIds);
    setappdata(handles.keyval, 'userIdToView', groupUserIds(userIdx));
end



% --- Executes on button press in clearTblBtn.
function clearTblBtn_Callback(hObject, eventdata, handles)
% hObject    handle to clearTblBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer = questdlg('Are you sure you would like to clear the table?', 'Clear table?', 'Yes', 'No', 'No');

if strcmp(answer, 'Yes')
    set(handles.keyValTbl, 'Data', []);
    set(handles.clearTblBtn, 'Enable', 'off');
    set(handles.removeBtn, 'Enable', 'off');
    set(handles.saveBtn, 'Enable', 'off');
end



% --- Executes on selection change in groupDropdown.
function groupDropdown_Callback(hObject, eventdata, handles)
% hObject    handle to groupDropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns groupDropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from groupDropdown

global session

adminService = session.getAdminService;
secCon = getappdata(handles.keyval, 'securityContexts');
groupIds = getappdata(handles.keyval, 'groupIds');
groupIdx = get(hObject, 'Value');
selectedGroupId = groupIds(groupIdx);

workingGroup = adminService.getGroup(selectedGroupId);
session.setSecurityContext(workingGroup);

setappdata(handles.keyval, 'groupId', selectedGroupId);

populateUsers(handles);
populateProjects(handles);
loadKeyValLib(handles);
set(handles.datasetDropdown, 'Value', 1);
set(handles.datasetDropdown, 'String', 'Select a dataset');
set(handles.datasetDropdown, 'Enable', 'off');
set(handles.imagesListbox, 'Value', []);
set(handles.imagesListbox, 'String', 'All images in dataset');
set(handles.imagesListbox, 'Enable', 'off');





% --- Executes during object creation, after setting all properties.
function groupDropdown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to groupDropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function populateGroups(handles)

groupId = getappdata(handles.keyval, 'groupId');
secCon = getappdata(handles.keyval, 'securityContexts');

numGroups = secCon.size;
counter = 1;
for thisGroup = 1:numGroups
    groupObj = secCon(1).get(thisGroup-1);
    groupClass = class(groupObj);
    if ~strcmpi(groupClass, 'omero.model.ExperimenterGroupI')
        continue;
    end
    groupNamesIds{counter,1} = char(secCon(1).get(thisGroup-1).getName.getValue.getBytes');
    groupNamesIds{counter,2} = secCon(1).get(thisGroup-1).getId.getValue;
    counter = counter + 1;
end

groupNamesIds = sortrows(groupNamesIds);
groupNames = groupNamesIds(:,1);
groupIds = cell2mat(groupNamesIds(:,2));

set(handles.groupDropdown, 'String', groupNames);
groupIdx = find(ismember(groupIds, groupId));
set(handles.groupDropdown, 'Value', groupIdx);

setappdata(handles.keyval, 'groupNames', groupNames);
setappdata(handles.keyval, 'groupIds', groupIds);
