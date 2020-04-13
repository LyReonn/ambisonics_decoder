function varargout = ambisonics_gui(varargin)
% AMBISONICS_GUI MATLAB code for ambisonics_gui.fig
%      AMBISONICS_GUI, by itself, creates a new AMBISONICS_GUI or raises the existing
%      singleton*.
%
%      H = AMBISONICS_GUI returns the handle to a new AMBISONICS_GUI or the handle to
%      the existing singleton*.
%
%      AMBISONICS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AMBISONICS_GUI.M with the given input arguments.
%
%      AMBISONICS_GUI('Property','Value',...) creates a new AMBISONICS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ambisonics_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ambisonics_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ambisonics_gui

% Last Modified by GUIDE v2.5 20-Mar-2020 23:01:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ambisonics_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @ambisonics_gui_OutputFcn, ...
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


% --- Executes just before ambisonics_gui is made visible.
function ambisonics_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ambisonics_gui (see VARARGIN)

% Choose default command line output for ambisonics_gui
handles.output = hObject;

handles.fA = pi/2;
handles.fM = 0.5;
handles.fS = 1;

handles.aA = 0;
handles.aB = 0;
handles.aC = 0;

axes(handles.flu_signal);
axes(handles.frd_signal);
axes(handles.bld_signal);
axes(handles.bru_signal);

axes(handles.w_signal);
axes(handles.x_signal);
axes(handles.y_signal);
axes(handles.z_signal);

axes(handles.l_channel);
axes(handles.r_channel);

handles.pa = polaraxes('Units', 'pixels', 'Position', [670 320 250 250]);

PlotBlumlein(handles);
DrawAudioStream(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ambisonics_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ambisonics_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function DrawAudioStream(handles)

h3vr = audioDeviceReader();
h3vr.Driver = 'ASIO';
h3vr.Device = h3vr.getAudioDevices{1};
h3vr.NumChannels = 4;
h3vr.BitDepth = '16-bit integer';
h3vr.SampleRate = 48000;
h3vr.SamplesPerFrame = 2048;
h3vr.OutputDataType = 'single';

monitor = audioDeviceWriter();
monitor.Driver = 'ASIO';
monitor.Device = monitor.getAudioDevices{1};
monitor.BitDepth = h3vr.BitDepth;
monitor.SampleRate = h3vr.SampleRate;


fW = 1/sqrt(3);
a2b = [fW fW fW fW
        1  1 -1 -1
        1 -1  1 -1
        1 -1 -1  1].';

fB = sqrt(2)/2;
bl = [0 fB  fB 0
      0 fB -fB 0].';

while true

    aformat = h3vr();
    
    if handles.cb_disp_a.Value == 1
        plot(handles.flu_signal, aformat(:, 1));
        plot(handles.frd_signal, aformat(:, 2));
        plot(handles.bld_signal, aformat(:, 3));
        plot(handles.bru_signal, aformat(:, 4));
        title(handles.flu_signal, 'FLU Signal');
        title(handles.frd_signal, 'FRD Signal');
        title(handles.bld_signal, 'BLD Signal');
        title(handles.bru_signal, 'BRU Signal');
        set(handles.flu_signal, 'ylim', [-1 1], 'ytick', 0, 'xlim', [0 h3vr.SamplesPerFrame], 'xtick', []);
        set(handles.frd_signal, 'ylim', [-1 1], 'ytick', 0, 'xlim', [0 h3vr.SamplesPerFrame], 'xtick', []);
        set(handles.bld_signal, 'ylim', [-1 1], 'ytick', 0, 'xlim', [0 h3vr.SamplesPerFrame], 'xtick', []);
        set(handles.bru_signal, 'ylim', [-1 1], 'ytick', 0, 'xlim', [0 h3vr.SamplesPerFrame], 'xtick', []);
    end
    
    bformat = aformat * a2b;
    
%     aA = handles.aA;
%     roll = [1 0       0       0
%             0 1       0       0
%             0 0  cos(aA) sin(aA)
%             0 0 -sin(aA) cos(aA)].';
%     
%     aB = handles.aB;
%     pitch = [1       0  0      0
%              0  cos(aB) 0 sin(aB)
%              0       0  1      0
%              0 -sin(aB) 0 cos(aB)].';
%     
%     aC = handles.aC;
%     yaw = [1       0       0  0
%            0  cos(aC) sin(aC) 0
%            0 -sin(aC) cos(aC) 0
%            0       0       0  1].';
%        
%     bformat = bformat * roll;
%     bformat = bformat * pitch;
%     bformat = bformat * yaw;
    
    if handles.cb_disp_b.Value == 1
        plot(handles.w_signal, bformat(:, 1));
        plot(handles.x_signal, bformat(:, 2));
        plot(handles.y_signal, bformat(:, 3));
        plot(handles.z_signal, bformat(:, 4));
        title(handles.w_signal, 'W Signal');
        title(handles.x_signal, 'X Signal');
        title(handles.y_signal, 'Y Signal');
        title(handles.z_signal, 'Z Signal');
        set(handles.w_signal, 'ylim', [-1 1], 'ytick', 0, 'xlim', [0 h3vr.SamplesPerFrame], 'xtick', []);
        set(handles.x_signal, 'ylim', [-1 1], 'ytick', 0, 'xlim', [0 h3vr.SamplesPerFrame], 'xtick', []);
        set(handles.y_signal, 'ylim', [-1 1], 'ytick', 0, 'xlim', [0 h3vr.SamplesPerFrame], 'xtick', []);
        set(handles.z_signal, 'ylim', [-1 1], 'ytick', 0, 'xlim', [0 h3vr.SamplesPerFrame], 'xtick', []);
    end
    


    fA = handles.fA;
    xy = [0.5 0.5*cos(fA/2)  0.5*sin(fA/2) 0
          0.5 0.5*cos(fA/2) -0.5*sin(fA/2) 0].';

    fM = handles.fM;
    fS = handles.fS;
    ms = [1-fM fM  fS 0
          1-fM fM -fS 0].';
    
    if handles.rb_blumlein.Value == 1
    	b2s = bl;
    elseif handles.rb_xy.Value == 1
    	b2s = xy;
    elseif handles.rb_ms.Value == 1
        b2s = ms;
    end
    
    output = bformat * b2s;
    
    plot(handles.l_channel, output(:, 1));
    plot(handles.r_channel, output(:, 2));
    title(handles.l_channel, 'Left Channel');
    title(handles.r_channel, 'Right Channel');
    set(handles.l_channel, 'ylim', [-1 1], 'ytick', 0, 'xlim', [0 h3vr.SamplesPerFrame], 'xtick', []);
    set(handles.r_channel, 'ylim', [-1 1], 'ytick', 0, 'xlim', [0 h3vr.SamplesPerFrame], 'xtick', []);

    drawnow limitrate;
    
    monitor(output);
    
end



function slider_roll_Callback(hObject, eventdata, handles)
% --- Executes on slider movement.
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.aA = deg2rad(get(hObject, 'Value'));
handles.text_roll_val.String = get(hObject, 'Value');
guidata(handles.figure1, handles);


function slider_pitch_Callback(hObject, eventdata, handles)
% --- Executes on slider movement.
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.aB = deg2rad(get(hObject, 'Value'));
handles.text_pitch_val.String = get(hObject, 'Value');
guidata(handles.figure1, handles);


function slider_yaw_Callback(hObject, eventdata, handles)
% --- Executes on slider movement.
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.aC = deg2rad(get(hObject, 'Value'));
handles.text_yaw_val.String = get(hObject, 'Value');
guidata(handles.figure1, handles);


function slider_xy_angle_Callback(hObject, eventdata, handles)
% --- Executes on slider movement.
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.fA = deg2rad(get(hObject,'Value'));
handles.text_xy_angle_val.String = get(hObject,'Value');

guidata(handles.figure1, handles);
PlotXY(handles);


function text_xy_angle_val_ButtonDownFcn(hObject, eventdata, handles)
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text_xy_angle_val.
handles.fA = deg2rad(90);
hObject.String = 90;
handles.slider_xy_angle.Value = 90;

guidata(handles.figure1, handles);
PlotXY(handles);


function slider_ms_factor_m_Callback(hObject, eventdata, handles)
% --- Executes on slider movement.
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.fM = get(hObject,'Value');
handles.text_ms_factor_m_val.String = handles.fM;

guidata(handles.figure1, handles);
PlotMS(handles);


function text_ms_factor_m_val_ButtonDownFcn(hObject, eventdata, handles)
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text_ms_factor_m_val.
handles.fM = 0.5;
hObject.String = handles.fM;
handles.slider_ms_factor_m.Value = handles.fM;

guidata(handles.figure1, handles);
PlotMS(handles);


function slider_ms_factor_s_Callback(hObject, eventdata, handles)
% --- Executes on slider movement.
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.fS = get(hObject,'Value');
handles.text_ms_factor_s_val.String = handles.fS;

guidata(handles.figure1, handles);
PlotMS(handles);


function text_ms_factor_s_val_ButtonDownFcn(hObject, eventdata, handles)
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text_ms_factor_s_val.
handles.fS = 1;
hObject.String = handles.fS;
handles.slider_ms_factor_s.Value = handles.fS;

guidata(handles.figure1, handles);
PlotMS(handles);


function rb_blumlein_Callback(hObject, eventdata, handles)
% --- Executes on button press in rb_blumlein.
% Hint: get(hObject,'Value') returns toggle state of rb_blumlein
handles.slider_xy_angle.Visible = 'Off';
handles.slider_ms_factor_m.Visible = 'Off';
handles.slider_ms_factor_s.Visible = 'Off';
handles.text_xy_angle.Visible = 'Off';
handles.text_ms_factor_m.Visible = 'Off';
handles.text_ms_factor_s.Visible = 'Off';
handles.text_xy_angle_val.Visible = 'Off';
handles.text_ms_factor_m_val.Visible = 'Off';
handles.text_ms_factor_s_val.Visible = 'Off';

PlotBlumlein(handles);


function PlotBlumlein(handles)
t = 0:pi/100:2*pi;
fB = sqrt(2)/2;
pa = handles.pa;

r1 = fB*(cos(t)+sin(t));
r2 = fB*(cos(t)-sin(t));
r3 = -fB*(cos(t)+sin(t));
r4 = -fB*(cos(t)-sin(t));

polarplot(pa, t, r1);
hold on;
polarplot(pa, t, r2);
polarplot(pa, t, r3);
polarplot(pa, t, r4);
hold off;
pa.ThetaZeroLocation = 'top';

guidata(handles.figure1, handles);


function rb_xy_Callback(hObject, eventdata, handles)
% --- Executes on button press in rb_xy.
% Hint: get(hObject,'Value') returns toggle state of rb_xy
handles.slider_xy_angle.Visible = 'On';
handles.slider_ms_factor_m.Visible = 'Off';
handles.slider_ms_factor_s.Visible = 'Off';
handles.text_xy_angle.Visible = 'On';
handles.text_ms_factor_m.Visible = 'Off';
handles.text_ms_factor_s.Visible = 'Off';
handles.text_xy_angle_val.Visible = 'On';
handles.text_ms_factor_m_val.Visible = 'Off';
handles.text_ms_factor_s_val.Visible = 'Off';

PlotXY(handles);


function PlotXY(handles)
t = 0:pi/100:2*pi;
fA = handles.fA;
pa = handles.pa;

r1 = 0.5*(1+cos(fA/2)*cos(t)+sin(fA/2)*sin(t));
r2 = 0.5*(1+cos(fA/2)*cos(t)-sin(fA/2)*sin(t));

polarplot(pa, t, r1);
hold on;
polarplot(pa, t, r2);
hold off;
pa.ThetaZeroLocation = 'top';

guidata(handles.figure1, handles);


function rb_ms_Callback(hObject, eventdata, handles)
% --- Executes on button press in rb_ms.
% Hint: get(hObject,'Value') returns toggle state of rb_ms
handles.slider_xy_angle.Visible = 'Off';
handles.slider_ms_factor_m.Visible = 'On';
handles.slider_ms_factor_s.Visible = 'On';
handles.text_xy_angle.Visible = 'Off';
handles.text_ms_factor_m.Visible = 'On';
handles.text_ms_factor_s.Visible = 'On';
handles.text_xy_angle_val.Visible = 'Off';
handles.text_ms_factor_m_val.Visible = 'On';
handles.text_ms_factor_s_val.Visible = 'On';

PlotMS(handles);


function PlotMS(handles)
t = 0:pi/100:2*pi;
fM = handles.fM;
fS = handles.fS;
pa = handles.pa;

r1 = 1-fM + fM*cos(t);
r2 = fS*sin(t);
r3 = -fS*sin(t);

polarplot(pa, t, r1);
hold on;
polarplot(pa, t, r2);
polarplot(pa, t, r3);
hold off;
pa.ThetaZeroLocation = 'top';

guidata(handles.figure1, handles);


%---------------------------------------------------------------------------%


function cb_disp_b_Callback(hObject, eventdata, handles)
% --- Executes on button press in cb_disp_b.
% Hint: get(hObject,'Value') returns toggle state of cb_disp_b


function cb_disp_a_Callback(hObject, eventdata, handles)
% --- Executes on button press in cb_disp_a.
% Hint: get(hObject,'Value') returns toggle state of cb_disp_a


function slider_roll_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider_pitch_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider_yaw_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider_xy_angle_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider_ms_factor_m_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider_ms_factor_s_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function figure1_CloseRequestFcn(hObject, eventdata, handles)
% --- Executes when user attempts to close figure1.
% Hint: delete(hObject) closes the figure
delete(hObject);
