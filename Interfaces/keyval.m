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

% Last Modified by GUIDE v2.5 23-Oct-2016 18:00:47

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

populateImages(handles)



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

setappdata(handles.keyval, 'imageName', imageName');


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

imageIdxs = get(handles.imagesListbox, 'Value')-1;
projId = getappdata(handles.keyval, 'projId');
dsId = getappdata(handles.keyval, 'dsId');
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

toImages = get(handles.imagesCheck, 'Value');
if toImages
    mapToImages(handles, imageIds, tblKeys, tblVals);
end

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
delete(hObject);


function populateProjects(handles)
global session;

projects = getProjects(session);
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



function loadKeyValLib(handles)
global session

secCon = session.getSecurityContexts;
groupId = secCon(1).get(0).getId.getValue;
images = getImages(session, 'group', groupId);
maps = getObjectAnnotations(session, 'map', 'image', images, 'flatten', true);

numMaps = length(maps);
counter = 1;
keyLib{1} = 'Add new key-value pairs';
for thisMap = 1:numMaps
    map = maps(thisMap).getMapValue;
    numKeys = map.size();
    for thisKey = 0:numKeys-1
        keyLib{counter+1} = char(map.get(thisKey).name.getBytes');
        valLib{counter} = char(map.get(thisKey).value.getBytes');
        counter = counter + 1;
    end
end

keyLib = unique(keyLib);
valLib = unique(valLib);

set(handles.keyAutoList, 'String', keyLib);
setappdata(handles.keyval, 'keyLib', keyLib);
setappdata(handles.keyval, 'valLib', valLib);
setappdata(handles.keyval, 'maps', maps);
setappdata(handles.keyval, 'groupId', groupId);


% --- Executes on selection change in keyAutoList.
function keyAutoList_Callback(hObject, eventdata, handles)
% hObject    handle to keyAutoList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns keyAutoList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from keyAutoList

newPairs = getappdata(handles.keyval, 'newPairs');
keyVal = get(hObject, 'Value');
valList{1} = 'Add a new value';
if keyVal == 1
    [newKey, newVal] = newKeyValDlg(handles);
    newKey = strtrim(newKey);
    newVal = strtrim(newVal);
    [~, numNewVals] = size(newVal);
    keyList = get(handles.keyAutoList, 'String');
    valList = [valList newVal];
    keyList{end+1} = newKey;
    
    %Keep track of new key/val pairs
    newKeyList(1:numNewVals,1) = {newKey};
    newKeyValPairs = [newKeyList newVal'];
    newPairs = [newPairs; newKeyValPairs];
    selectValue = length(keyList);
    set(handles.keyAutoList, 'String', keyList);
    set(handles.valAutoList, 'String', valList);
    set(handles.keyAutoList, 'Value', selectValue);
    set(handles.valAutoList, 'Value', 2);
    setappdata(handles.keyval, 'selectedKey', newKey);
    setappdata(handles.keyval, 'newPairs', newPairs);
else
    keys = get(hObject, 'String');
    selectedKey = keys{keyVal};
    vals = findValsFromKey(handles, selectedKey);
    valList = [valList vals];
    set(handles.valAutoList, 'Value', 1);
    set(handles.valAutoList, 'String', valList);
    setappdata(handles.keyval, 'selectedKey', selectedKey);
end

if get(handles.keyAutoList, 'Value') > 1 && get(handles.valAutoList, 'Value') > 1
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

newPairs = getappdata(handles.keyval, 'newPairs');
valVal = get(hObject, 'Value');
valList = get(hObject, 'String');
if valVal == 1
    selectedKey = getappdata(handles.keyval, 'selectedKey');
    newVal = inputdlg(['Please enter the new Value for Key ' selectedKey '.'], 'New Value');
    newVal = strtrim(newVal{1});
    valList = [valList; newVal];
    newPairs{end+1,1} = selectedKey;
    newPairs{end,2} = newVal;
    numVals = length(valList);
    set(hObject, 'String', valList);
    set(hObject, 'Value', numVals);
    setappdata(handles.keyval, 'selectedVal', newVal);
    setappdata(handles.keyval, 'newPairs', newPairs);
else
    selectedVal = valList{valVal};
    setappdata(handles.keyval, 'selectedVal', selectedVal);
end

if get(handles.keyAutoList, 'Value') > 1 && get(handles.valAutoList, 'Value') > 1
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
valString = ['Add a new value', vals, newVal];
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
selectedkey = keys{keyVal};


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
    maps = getObjectAnnotations(session, 'map', 'image', imageId, 'flatten', true);
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