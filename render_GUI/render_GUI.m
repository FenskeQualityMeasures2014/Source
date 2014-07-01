function varargout = render_GUI(varargin)
% RENDER_GUI MATLAB code for render_GUI.fig
%      RENDER_GUI, by itself, creates a new RENDER_GUI or raises the existing
%      singleton*.
%
%      H = RENDER_GUI returns the handle to a new RENDER_GUI or the handle to
%      the existing singleton*.
%
%      RENDER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RENDER_GUI.M with the given input arguments.
%
%      RENDER_GUI('Property','Value',...) creates a new RENDER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before render_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to render_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help render_GUI

% Last Modified by GUIDE v2.5 04-Mar-2014 20:28:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @render_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @render_GUI_OutputFcn, ...
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




% --- Executes just before render_GUI is made visible.
function render_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to render_GUI (see VARARGIN)

% Choose default command line output for render_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes render_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
cameratoolbarnokeys;


% --- Outputs from this function are returned to the command line.
function varargout = render_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
cla(handles.axes1);
tic;
polygons = preview_OBJ(handles);
t = toc;
set(handles.text1, 'String', [num2str(polygons) ' polygons']);
set(handles.text2, 'String', [num2str(t) ' s']);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Populate drop down menu
listing = dir('data_files');
folders = {'Choose directory'};
for i=1:length(listing)
    if(listing(i).isdir)
        if~(strcmp(listing(i).name,'.') || strcmp(listing(i).name, '..'))
            folders{length(folders)+1} = listing(i).name;
        end
    end
end
set(hObject, 'String', folders);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image1 = capture_image(handles);
figure;
imshow(image1);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cameraPose = struct('CameraPosition', get(handles.axes1, 'CameraPosition'), 'CameraTarget', get(handles.axes1, 'CameraTarget'),...
    'CameraUpVector', get(handles.axes1, 'CameraUpVector'), 'CameraViewAngle', get(handles.axes1, 'CameraViewAngle'));
Filename = uiputfile('camera_poses\.mat');
if (Filename == 0)
    return;
end
cd('camera_poses');
save(Filename,'cameraPose');
cd('..');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cd('camera_poses');
Filename = uigetfile;
if (Filename == 0);
    cd('..');
    return;
end
load(Filename);
cd('..');
set(handles.axes1, 'CameraPosition',  cameraPose.CameraPosition );
set(handles.axes1, 'CameraTarget',    cameraPose.CameraTarget   );
set(handles.axes1, 'CameraUpVector',  cameraPose.CameraUpVector );
set(handles.axes1, 'CameraViewAngle', cameraPose.CameraViewAngle);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zNearFar = getZvalues(handles);
[deltaU, pad_offset, focusOffset] = getMinSpacing(handles, zNearFar);
getLightfield2(handles, deltaU, pad_offset, focusOffset);
[depthMap cameraCoord] = getDepthMap(handles);
figure;
imshow(depthMap);
% image1 = capture_image(handles);
% bin1 = depthMap > 0;
% bin2 = image1(:,:,1) > 0;
% figure; imshow(bin1-bin2,[]);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cd('interpolation_methods');
compare_interp_methods;
cd('..');
