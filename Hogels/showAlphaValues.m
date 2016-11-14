function varargout = showAlphaValues(varargin)
% SHOWALPHAVALUES MATLAB code for showAlphaValues.fig
%      SHOWALPHAVALUES, by itself, creates a new SHOWALPHAVALUES or raises the existing
%      singleton*.
%
%      H = SHOWALPHAVALUES returns the handle to a new SHOWALPHAVALUES or the handle to
%      the existing singleton*.
%
%      SHOWALPHAVALUES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHOWALPHAVALUES.M with the given input arguments.
%
%      SHOWALPHAVALUES('Property','Value',...) creates a new SHOWALPHAVALUES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before showAlphaValues_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to showAlphaValues_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help showAlphaValues

% Last Modified by GUIDE v2.5 05-Feb-2014 19:03:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @showAlphaValues_OpeningFcn, ...
                   'gui_OutputFcn',  @showAlphaValues_OutputFcn, ...
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
%Extra initialization
load l4d2Movie;
global l4d2Movie1;
l4d2Movie1 = l4d2Movie;


% --- Executes just before showAlphaValues is made visible.
function showAlphaValues_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to showAlphaValues (see VARARGIN)

% Choose default command line output for showAlphaValues
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes showAlphaValues wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = showAlphaValues_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
alpha_values = [.3 .4 .5 .65 .8 1 2 5 10 30];
global l4d2Movie1;
sliderPos = get(hObject,'Value');
desiredAlpha = alpha_values(round(sliderPos+1));
set(handles.text1, 'String', ['Alpha = ' num2str(desiredAlpha)]);
panax = axes('Units','normal', 'Position', [0 0 1 1], 'Parent', handles.uipanel1);
imhandle = imshow(l4d2Movie1(round(sliderPos+1)).cdata, 'Parent', panax);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global l4d2Movie1;
panax = axes('Units','normal', 'Position', [0 0 1 1], 'Parent', handles.uipanel1);
movie(panax, l4d2Movie1, str2num(get(handles.edit2, 'String')), str2num(get(handles.edit1, 'String')));


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


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
