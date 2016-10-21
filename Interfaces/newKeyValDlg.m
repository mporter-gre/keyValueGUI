function varargout = newKeyValDlg(varargin)
% NEWKEYVALDLG MATLAB code for newKeyValDlg.fig
%      NEWKEYVALDLG, by itself, creates a new NEWKEYVALDLG or raises the existing
%      singleton*.
%
%      H = NEWKEYVALDLG returns the handle to a new NEWKEYVALDLG or the handle to
%      the existing singleton*.
%
%      NEWKEYVALDLG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEWKEYVALDLG.M with the given input arguments.
%
%      NEWKEYVALDLG('Property','Value',...) creates a new NEWKEYVALDLG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before newKeyValDlg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to newKeyValDlg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help newKeyValDlg

% Last Modified by GUIDE v2.5 21-Oct-2016 11:27:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @newKeyValDlg_OpeningFcn, ...
                   'gui_OutputFcn',  @newKeyValDlg_OutputFcn, ...
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


% --- Executes just before newKeyValDlg is made visible.
function newKeyValDlg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to newKeyValDlg (see VARARGIN)

% Choose default command line output for newKeyValDlg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes newKeyValDlg wait for user response (see UIRESUME)
uiwait(handles.newKeyValDlg);


% --- Outputs from this function are returned to the command line.
function varargout = newKeyValDlg_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
newKey = get(handles.newKeyTxt, 'String');
newVal = get(handles.newValTxt, 'String');
varargout{1} = newKey;
varargout{2} = newVal;
delete(handles.newKeyValDlg);



function newKeyTxt_Callback(hObject, eventdata, handles)
% hObject    handle to newKeyTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newKeyTxt as text
%        str2double(get(hObject,'String')) returns contents of newKeyTxt as a double


% --- Executes during object creation, after setting all properties.
function newKeyTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newKeyTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newValTxt_Callback(hObject, eventdata, handles)
% hObject    handle to newValTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newValTxt as text
%        str2double(get(hObject,'String')) returns contents of newValTxt as a double


% --- Executes during object creation, after setting all properties.
function newValTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newValTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in okBtn.
function okBtn_Callback(hObject, eventdata, handles)
% hObject    handle to okBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newKey = get(handles.newKeyTxt, 'String');
newVal = get(handles.newValTxt, 'String');

if ~isempty(newKey) && ~isempty(newVal)
    uiresume(handles.newKeyValDlg);
else
    warndlg('Please input a new key and value pair');
    return;
end

    


% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
