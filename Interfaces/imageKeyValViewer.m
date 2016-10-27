function varargout = imageKeyValViewer(varargin)
% IMAGEKEYVALVIEWER MATLAB code for imageKeyValViewer.fig
%      IMAGEKEYVALVIEWER, by itself, creates a new IMAGEKEYVALVIEWER or raises the existing
%      singleton*.
%
%      H = IMAGEKEYVALVIEWER returns the handle to a new IMAGEKEYVALVIEWER or the handle to
%      the existing singleton*.
%
%      IMAGEKEYVALVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEKEYVALVIEWER.M with the given input arguments.
%
%      IMAGEKEYVALVIEWER('Property','Value',...) creates a new IMAGEKEYVALVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageKeyValViewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageKeyValViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageKeyValViewer

% Last Modified by GUIDE v2.5 24-Oct-2016 21:17:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageKeyValViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @imageKeyValViewer_OutputFcn, ...
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


% --- Executes just before imageKeyValViewer is made visible.
function imageKeyValViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imageKeyValViewer (see VARARGIN)

% Choose default command line output for imageKeyValViewer
handles.output = hObject;

parentHandles = varargin{1};
imageId = varargin{2};
imageName = varargin{3};

handles.parentHandles = parentHandles;

setappdata(handles.imageKeyValViewer, 'parentHandles', parentHandles);
setappdata(handles.imageKeyValViewer, 'imageId', imageId);
setappdata(parentHandles.keyval, 'viewerH', handles);
set(handles.imageNameLbl, 'String', imageName(1:end-2));

fetchMaps(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imageKeyValViewer wait for user response (see UIRESUME)
% uiwait(handles.imageKeyValViewer);


% --- Outputs from this function are returned to the command line.
function varargout = imageKeyValViewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in copyBtn.
function copyBtn_Callback(hObject, eventdata, handles)
% hObject    handle to copyBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer = questdlg('Are you sure you want to replace the Key/Value table data?', 'Confirm overwrite', 'Yes', 'No', 'No');
if strcmp(answer, 'No')
    return;
end

data = get(handles.keyValTbl, 'Data');
set(handles.parentHandles.keyValTbl, 'Data', data);
set(handles.parentHandles.clearTblBtn, 'Enable', 'on');




% --- Executes on button press in closeBtn.
function closeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to closeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(handles.parentHandles.keyval, 'viewerH', []);
delete(handles.imageKeyValViewer);

function fetchMaps(handles)

global session;

imageId = getappdata(handles.imageKeyValViewer, 'imageId');

maps = getObjectAnnotations(session, 'map', 'image', imageId, 'owner', -1, 'flatten', true);
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
end

data = [imgKeys' imgVals'];

set(handles.keyValTbl, 'Data', data);


% --- Executes during object creation, after setting all properties.
function keyValTbl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to keyValTbl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject, 'Data', cell(0));


% --- Executes on mouse press over figure background.
function imageKeyValViewer_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to imageKeyValViewer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currKey = eventdata.Key

if strcmpi(currKey, 'F5')
    fetchMaps(handles);
end
