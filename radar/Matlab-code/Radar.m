function varargout = Radar(varargin)

% RADAR MATLAB code for Radar.fig
%      RADAR, by itself, creates a new RADAR or raises the existing
%      singleton*.
%
%      H = RADAR returns the handle to a new RADAR or the handle to
%      the existing singleton*.
%
%      RADAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RADAR.M with the given input arguments.
%
%      RADAR('Property','Value',...) creates a new RADAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Radar_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Radar_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Radar

% Last Modified by GUIDE v2.5 10-Apr-2015 19:08:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Radar_OpeningFcn, ...
                   'gui_OutputFcn',  @Radar_OutputFcn, ...
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


% --- Executes just before Radar is made visible.
function Radar_OpeningFcn(hObject, eventdata, handles, varargin)
handles.port = 1;
polar(linspace(0,pi,180), 150*ones(1,180),'k')
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Radar (see VARARGIN)

% Choose default command line output for Radar
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Radar wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Radar_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Connect.
function Connect_Callback(hObject, eventdata, handles)
ranger_min = 2;
if strcmp(get(hObject,'String'),'Connect') && handles.port > 0
    set(hObject,'String','Disconnect');
    try
        serial_arduino = setupSerialPort(handles.port);
    cmdStart = 't';
    cmdRead = 'r';
    while cmdStart~='s'
        cmdStart = fread(serial_arduino,1,'uchar');
    end
    cm = 150*ones(1,180);
    while strcmp(get(hObject,'String'),'Disconnect')
       writeCmd(serial_arduino, cmdStart);
       writeCmd(serial_arduino, cmdRead);
       [cmtmp angletmp] = readData(serial_arduino);
       if(cmtmp >=ranger_min && angletmp~= 0)
       cm(angletmp)=cmtmp;
       polar(linspace(0,pi, length(cm)),cm/58,'r')
       hold on
       polar(linspace(0,pi, length(cm)), 150*ones(1,180),'k')
       hold off
       %pause(0.1)
       drawnow
       %axis([-150 150 -150 150])
       %axis equal
       end
    end
    catch err
        set(hObject,'String','Connect');
        mbox = msgbox(err.message,'Not open Serial','error'); uiwait(mbox);
    end
else
    set(hObject,'String','Connect');
    clearPorts
end
% hObject    handle to Connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Connect


% --- Executes on selection change in port.
function port_Callback(hObject, eventdata, handles)
handles.port = get(hObject, 'Value');
guidata(hObject,handles)
% hObject    handle to port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns port contents as cell array
%        contents{get(hObject,'Value')} returns selected item from port


% --- Executes during object creation, after setting all properties.
function port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if isempty(listPort())>0
    ports = {'nothing'};
else
    ports = listPort();
end
set(hObject, 'String', ports);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','black');
end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clearPorts();
delete(instrfindall)
