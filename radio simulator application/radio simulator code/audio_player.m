function varargout = audio_player(varargin)
%deploytool  guide
% AUDIO_PLAYER MATLAB code for audio_player.fig
%      AUDIO_PLAYER, by itself, creates a new AUDIO_PLAYER or raises the existing
%      singleton*.
%
%      H = AUDIO_PLAYER returns the handle to a new AUDIO_PLAYER or the handle to
%      the existing singleton*.
%
%      AUDIOG_PLAYER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUDIO_PLAYER.M with the given input arguments.
%
%      AUDIO_PLAYER('Property','Value',...) creates a new AUDIO_PLAYER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before audio_player_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to audio_player_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help audio_player

% Last Modified by GUIDE v2.5 30-Nov-2024 18:18:55

% Begin initialization code - DO NOISET EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @audio_player_OpeningFcn, ...
                   'gui_OutputFcn',  @audio_player_OutputFcn, ...
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

end
% End initialization code - DO NOISET EDIT

%output_values = (input_values - input_min) * (output_max - output_min) / (input_max - input_min) + output_min;

% --- Executes just before audio_player is made visible.
function audio_player_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to audio_player (see VARARGIN)

% Choose default command line output for audio_player
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global vfact    %volume factor
global efact    %encryption factor
global rate
global orate    %orignal rate
global ostate
global estate
global fstate
global dstate
global rstate
global f
global oy
global ey
global fy
global fmode    %which filter will be used
global m        %the music state 0=Orignal ,1 = encrypted , 2= filtered
global om       %orignal music
global em       %encrypted music
global fm       %filtered music
global mpos     %the position of the music
global playm
global file
global path
global closesavef

%{
% Add the Functions and Filters folder to the MATLAB path temporarily
addpath('Functions');
addpath('Functions\Audio player');
addpath('Filters');
load RF_Band_Pass_Filter; % Load predefined RF Band-Pass Filter
%}

closesavef=0;
path="Channels\";
file="Ch2_Short_BBCArabic2.wav";
[oy,f]=audioread(path+file);
efact=0.01;
rate=1;
orate=1;
vfact=1;
fmode=1;
ostate=1;
estate=0;
fstate=0;
dstate=1;
rstate=1;
m=0;
playm=0;
om=audioplayer(vfact.*oy,rate.*f);
ey=encrypt_audio(oy,efact);
em=audioplayer(vfact.*ey,rate.*f);
[fy,MSE,PSNR]=filter_audio(oy,f,0,fmode);
fm=audioplayer(vfact.*fy,rate.*f);
set(handles.oradio,'value',1);
set(handles.eradio,'value',0);
set(handles.fradio,'value',0);
set(handles.dradio,'value',1);
set(handles.rradio,'value',0);
mpos=om.CurrentSample;

set(handles.loc,'string',path);
set(handles.fileb,'string',file);
set(handles.rateb,'string',rate);
set(handles.noiseb,'string',efact);
set(handles.volb,'string',vfact);
set(handles.volrb,'string',100);
set(handles.receiverb,'string',"With RF filter");
set(handles.vol,'value',0.5);
set(handles.noise,'value',0.1);
set(handles.saveb,'visible',"off");
set(handles.noise,'visible',"off");
set(handles.noiseb,'visible',"off");
set(handles.noiseT,'visible',"off");
set(handles.fmenu,'visible',"off");
set(handles.MSEb,'string',MSE);
set(handles.MSEb,'visible',"off");
set(handles.MSET,'visible',"off");
set(handles.PSNRb,'string',PSNR);
set(handles.PSNRb,'visible',"off");
set(handles.PSNRT,'visible',"off");
set(handles.RF_Filterb,'visible',"off");
set(handles.receiverb,'visible',"off");
set(handles.receiverT,'visible',"off");
set(handles.returnb,'visible',"off");
set(handles.volrT,'visible',"off");
set(handles.volrb,'visible',"off");
set(handles.persentT,'visible',"off");
set(handles.chanelsT,'visible',"off");
set(handles.radioT1,'visible',"off");
set(handles.radioT2,'visible',"off");
set(handles.radiofb,'visible',"off");
set(handles.Show_Filterb,'visible',"off");
set(handles.Show_Channels_b,'visible',"off");
set(handles.freqT,'visible',"off");
set(handles.radio_slider,'visible',"off");

ah=axes('unit','normalized','position',[0 0 1 1]);
bg=imread("audio_player_resources\audioLogo.jpg");
imagesc(bg);
set(ah,'handlevisibility','off','visible','off');

end
% UIWAIT makes audio_player wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = audio_player_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes during object creation, after setting all properties.
function noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles noiseT created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

function volb_Callback(hObject, eventdata, handles)
% hObject    handle to volb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of volb as text
%        str2double(get(hObject,'String')) returns contents of volb as a double
end

% --- Executes during object creation, after setting all properties.
function volb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles noiseT created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function vol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles noiseT created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

function volrb_Callback(hObject, eventdata, handles)
% hObject    handle to volrb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of volrb as text
%        str2double(get(hObject,'String')) returns contents of volrb as a double
end

% --- Executes during object creation, after setting all properties.
function volrb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volrb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function noiseb_Callback(hObject, eventdata, handles)
% hObject    handle to noiseb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noiseb as text
%        str2double(get(hObject,'String')) returns contents of noiseb as a double
end

% --- Executes during object creation, after setting all properties.
function noiseb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noiseb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles noiseT created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function PSNRb_Callback(hObject, eventdata, handles)
% hObject    handle to PSNRb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PSNRb as text
%        str2double(get(hObject,'String')) returns contents of PSNRb as a double
end

% --- Executes during object creation, after setting all properties.
function PSNRb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PSNRb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function MSEb_Callback(hObject, eventdata, handles)
% hObject    handle to MSEb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MSEb as text
%        str2double(get(hObject,'String')) returns contents of MSEb as a double
end

% --- Executes during object creation, after setting all properties.
function MSEb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MSEb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function loc_Callback(hObject, eventdata, handles)
% hObject    handle to loc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of loc as text
%        str2double(get(hObject,'String')) returns contents of loc as a double
end

% --- Executes during object creation, after setting all properties.
function loc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles noiseT created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function fileb_Callback(hObject, eventdata, handles)
% hObject    handle to fileb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileb as text
%        str2double(get(hObject,'String')) returns contents of fileb as a double
end

% --- Executes during object creation, after setting all properties.
function fileb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles noiseT created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function rateb_Callback(hObject, eventdata, handles)
% hObject    handle to rateb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rateb as text
%        str2double(get(hObject,'String')) returns contents of rateb as a double
end

% --- Executes during object creation, after setting all properties.
function rateb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rateb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles noiseT created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function receiverb_Callback(hObject, eventdata, handles)
% hObject    handle to receiverb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of receiverb as text
%        str2double(get(hObject,'String')) returns contents of receiverb as a double

end

% --- Executes during object creation, after setting all properties.
function receiverb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to receiverb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function radio_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radio_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

% --- Executes on button press in select.
function select_Callback(hObject, eventdata, handles)
% hObject    handle to select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global om       %orignal music
global em       %encrypted music
global fm       %filtered music
global vfact    %volume factor
global efact    %encryption factor
global rate     %speed of sound
global f
global oy
global ey
global fy
global fmode    %which filter will be used
global mpos     %the position of the music
global playm    %check if you play or not
global file
global path
[file,path]=uigetfile('*.*');
mp=strcat(path,file);
[oy ,f]=audioread(mp);
stop(om);
stop(em);
stop(fm);
om=audioplayer(vfact.*oy,rate.*f);
ey=encrypt_audio(oy,efact);
em=audioplayer(vfact.*ey,rate.*f);
[fy,MSE,PSNR]=filter_audio(oy,f,0,fmode);
set(handles.MSEb,'string',MSE);
set(handles.PSNRb,'string',PSNR);
fm=audioplayer(vfact.*fy,rate.*f);
playm=0;
mpos=om.CurrentSample;
set(handles.loc,'string',path);
set(handles.fileb,'string',file);
end

% --- Executes on button press in dradio.
function dradio_Callback(hObject, eventdata, handles)
% hObject    handle to dradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dradio
global vfact    %volume factor
global efact    %encryption factor
global rate     %speed of sound
global playm
global m
global om       %orignal music
global em       %encrypted music
global fm
global mpos     %the position of the music
global f
global oy
global ey
global fy
global fmode    %which filter will be used
global dstate
global rstate
global orate
pause(0.05);
set(handles.dradio,'value',1);
dstate=1;
set(handles.locT,'visible',"on");
set(handles.loc,'visible',"on");
set(handles.filenameT,'visible',"on");
set(handles.fileb,'visible',"on");
set(handles.rateT,'visible',"on");
set(handles.XT,'visible',"on");
set(handles.rateb,'visible',"on");
if m==1 || m==2
set(handles.saveb,'visible',"off");
end
set(handles.play,'visible',"on");
set(handles.pause,'visible',"on");
set(handles.resume,'visible',"on");
set(handles.stop,'visible',"on");
set(handles.slow,'visible',"on");
set(handles.fast,'visible',"on");
set(handles.select,'visible',"on");
set(handles.oradio,'visible',"on");
set(handles.eradio,'visible',"on");
set(handles.fradio,'visible',"on");
set(handles.RF_Filterb,'visible',"off");
set(handles.receiverb,'visible',"off");
set(handles.receiverT,'visible',"off");
set(handles.returnb,'visible',"off");
set(handles.volrT,'visible',"off");
set(handles.volrb,'visible',"off");
set(handles.persentT,'visible',"off");
set(handles.chanelsT,'visible',"off");
set(handles.radioT1,'visible',"off");
set(handles.radioT2,'visible',"off");
set(handles.radiofb,'visible',"off");
set(handles.Show_Filterb,'visible',"off");
set(handles.Show_Channels_b,'visible',"off");
set(handles.freqT,'visible',"off");
set(handles.radio_slider,'visible',"off");
if rstate==1 
    rstate=0;
    set(handles.rradio,'value',0);
    if m==0
        mpos= om.CurrentSample; 
    elseif m==1
        mpos= em.CurrentSample;
    elseif m==2
        mpos= fm.CurrentSample;
    end
    %default mode:
    efact=0.01;
    rate=orate;
    vfact=1;
    om=audioplayer(vfact.*oy,rate.*f);
    ey=encrypt_audio(oy,efact);
    em=audioplayer(vfact.*ey,rate.*f);
    [fy]=filter_audio(oy,f,0,fmode);
    fm=audioplayer(vfact.*fy,rate.*f);
    play(om,mpos);
    pause(om);              %just to save the position
    play(em,mpos);
    pause(em);              %just to save the position
    play(fm,mpos);
    pause(fm);              %just to save the position
    if playm==1 %playing
        switch m
            case 0
                play(om,mpos);
            case 1
                play(em,mpos);
            case 2
                play(fm,mpos);      
        end
    end
end

set(handles.rateb,'string',rate);
set(handles.noiseb,'string',efact);
set(handles.volb,'string',vfact);
set(handles.vol,'value',0.5);
set(handles.noise,'value',0.1);
set(handles.volT,'visible',"on");
set(handles.volb,'visible',"on");
set(handles.vol,'visible',"on");
if m==1
set(handles.noiseT,'visible',"on");
set(handles.noiseb,'visible',"on");
set(handles.noise,'visible',"on");
end
if m==2
set(handles.fmenu,'visible',"on");
set(handles.MSEb,'visible',"on");
set(handles.MSET,'visible',"on");
set(handles.PSNRb,'visible',"on");
set(handles.PSNRT,'visible',"on");
end

end

% --- Executes on button press in returnb.
function returnb_Callback(hObject, eventdata, handles)
% hObject    handle to returnb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dread
global fmr
global omr
pause(0.05);
stop(fmr);
%stop(omr);
set(handles.dradio,'visible',"on");
dread=1;
end


% --- Executes on button press in rradio.
function rradio_Callback(hObject, eventdata, handles)
% hObject    handle to rradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rradio
global playm
global om                                   % orignal music
global omr                                  % orignal music received
global RF_flag                              % RF Filter Flag
global em                                   % encrypted music
global fm                                   % filtered music
global fmr                                  % filtered music received
global dstate
global rstate
global dread
global Channel_Frequency                    % user's desired
global mc1                                  % chanel 1 FM
global yr1                                  % y chanel 1
global AM_Modulated_Signal                  % AM Channel
global AM_Modulated_Signal_RF_Filter        % AM Filtered Channel  
global IF_Channel_Filtered                  % IF Filtered Channel  
global Bass_Band_Channel                    % Bass band Channel
global RF_BPF                               % RF Bnad Pass Filter
global IF_BPF                               % IF Bnad Pass Filter
global Bass_Band_Filter                     % Bass band Low pass Filter
global Fs                                   % radio sample requency

pause(0.05);
set(handles.dradio,'visible',"off");
set(handles.volT,'visible',"off");
set(handles.volb,'visible',"off");
set(handles.vol,'visible',"off");
set(handles.noiseT,'visible',"off");
set(handles.noiseb,'visible',"off");
set(handles.noise,'visible',"off");
set(handles.fmenu,'visible',"off");
set(handles.MSEb,'visible',"off");
set(handles.MSET,'visible',"off");
set(handles.PSNRb,'visible',"off");
set(handles.PSNRT,'visible',"off");
set(handles.locT,'visible',"off");
set(handles.loc,'visible',"off");
set(handles.filenameT,'visible',"off");
set(handles.fileb,'visible',"off");
set(handles.rateT,'visible',"off");
set(handles.XT,'visible',"off");
set(handles.rateb,'visible',"off");
set(handles.play,'visible',"off");
set(handles.pause,'visible',"off");
set(handles.resume,'visible',"off");
set(handles.stop,'visible',"off");
set(handles.slow,'visible',"off");
set(handles.fast,'visible',"off");
set(handles.saveb,'visible',"off");
set(handles.select,'visible',"off");
set(handles.oradio,'visible',"off");
set(handles.eradio,'visible',"off");
set(handles.fradio,'visible',"off");
set(handles.RF_Filterb,'visible',"on");
set(handles.receiverb,'visible',"on");
set(handles.receiverT,'visible',"on");
set(handles.returnb,'visible',"on");
set(handles.rradio,'value',1);
set(handles.receiverb,'string',"Intializing...");
set(handles.volrT,'visible',"on");
set(handles.volrb,'visible',"on");
set(handles.persentT,'visible',"on");
set(handles.chanelsT,'visible',"on");
set(handles.freqT,'string',"Frequency (AM)");
set(handles.chanelsT, 'String', {'Channels frequencies (AM):', ...
                   '  100 kHz Channel 1 QuranPalestine', ...
                   '  150 kHz Channel 2 FM9090   ', ...
                   '  200 kHz Channel 3 BBCArabic2      ', ...
                   '  250 kHz Channel 4 RussianVoice    ', ...
                   '  300 kHz Channel 5 SkyNewsArabia '});
set(handles.radioT1,'visible',"on");
set(handles.radioT2,'visible',"on");
set(handles.radiofb,'visible',"on");
set(handles.Show_Filterb,'visible',"on");
set(handles.Show_Channels_b,'visible',"on");
set(handles.freqT,'visible',"on");
set(handles.radio_slider,'visible',"on");
set(handles.RF_Filterb,'visible',"on");
set(handles.receiverb,'visible',"on");
set(handles.receiverT,'visible',"on");

% initialze the slider
startfreq=50;
Channel_Frequency=100e3;
endfreq=350;
set(handles.radioT1,'string',int2str(startfreq)+" kHz");
set(handles.radioT2,'string',int2str(endfreq)+" kHz");
set(handles.radiofb,'string',int2str(Channel_Frequency/1e3));
set(handles.radio_slider,'Value',0.16);

% get the radio signal
[AM_Modulated_Signal, Fs] = get_AM_Signal("Channels\AM\AM_Modulated_Channel.mat");
[yr1,Channel_Fs] = audioread( "Channels\Ch0_Short_QuranPalestine.wav");
[yn, Fsn] = audioread( "Channels\noise.wav");
mc1=audioplayer(yr1,Channel_Fs);
mcn=audioplayer(yn/2,Fsn);
fmr = mc1 ;
pause(0.05);

% global variables handling
rstate=1;
stop(om);
stop(em);
stop(fm);
playm=0;    %stop
dread=0;
RF_flag = 1;

%start the radio
play(mc1);
omr = mc1;
Channel_Frequency_old=Channel_Frequency;
RF_flag_old = RF_flag;
set(handles.receiverb,'string',"With RF Filter");

%exit when user want
while dread==0
    dstate=0;
    radio_pos=mc1.CurrentSample;
    
    % Check and handle frequency change or Flag change
    if (Channel_Frequency_old ~= Channel_Frequency) || (RF_flag_old ~= RF_flag)
        
        Channel_Frequency_old = Channel_Frequency;
        RF_flag_old = RF_flag;
        play(mcn);
        [mc1,yr1,Channel_Fs,radio_pos,AM_Modulated_Signal_RF_Filter, IF_Channel_Filtered, Bass_Band_Channel, RF_BPF, IF_BPF, Bass_Band_Filter] = ...
             change_radio_chanel(mc1,AM_Modulated_Signal,Channel_Frequency,Fs, RF_flag);
        play(mc1,radio_pos);
        stop(mcn);
        
    end % if Channel_Frequency_old ~= Channel_Frequency
    
    % Reset radio if necessary
    if  radio_pos == 1 % Needs reset
        play(mc1);
    end % if  radio_pos == 1
    
    % Allow GUI to update
    drawnow;
    
    % Add a small pause to avoid excessive CPU usage
    pause(0.02);
    
end %   while dread==0

% Call the rradio_Callback function
stop(mc1);
stop(fmr);
stop(omr);

if dread==1
    dradio_Callback(handles.rradio, eventdata, handles);
end

end

% --- Executes on button press in Show_Filterb.
function Show_Filterb_Callback(hObject, eventdata, handles)
% hObject    handle to Show_Filterb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global RF_BPF                               % RF Bnad Pass Filter
global IF_BPF                               % IF Bnad Pass Filter
global Bass_Band_Filter                     % Bass band Low pass Filter
global Fs                                   % radio sample requency

    %Plot the frequency response of RF Bandpass Filter
    plotFilter(RF_BPF, Fs, "Frequency Response of RF Bandpass Filter");

    %Plot the frequency response of IF Bandpass Filter
    plotFilter(IF_BPF, Fs, "Frequency Response of IF Bandpass Filter");

    %Plot the frequency response of Bass_Band Low Pass Fileter
    plotFilter(Bass_Band_Filter, Fs, "Frequency Response of Bass Band Low Pass Filter");

end

% --- Executes on button press in Show_Channels_b.
function Show_Channels_b_Callback(hObject, eventdata, handles)
% hObject    handle to Show_Channels_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global AM_Modulated_Signal_RF_Filter        % AM Filtered Channel  
global IF_Channel_Filtered                  % IF Filtered Channel 
global Bass_Band_Channel                    % Bass band Channel


    %  Visualize Receiver Signals
    plotReceiver(AM_Modulated_Signal_RF_Filter, IF_Channel_Filtered, Bass_Band_Channel);
    
end

% --- Executes on button press in RF_Filterb.
function RF_Filterb_Callback(hObject, eventdata, handles)
% hObject    handle to RF_Filterb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global RF_flag                              % RF Filter Flag
    RF_flag = ~RF_flag;
    if RF_flag == 1
        set(handles.receiverb,'string',"With RF Filter");
    else
        set(handles.receiverb,'string',"No RF Filter");
    end
end

% --- Executes on slider movement.
function radio_slider_Callback(hObject, eventdata, handles)
% hObject    handle to radio_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global Channel_Frequency    %user's desired

   slider_read=get(hObject,'Value');    %slider read

   %{
    we need to map as 
    the min input is 0 max is 1, 
    output min=50e3  max=350e3
   %}
   Channel_Frequency =((slider_read-0)/1)*(350e3-50e3)+50e3;
   
   % map the frequency
   Channel_Frequency = map_radio_frequency(Channel_Frequency);  
   
   % display the frequency
   set(handles.radiofb,'string',int2str(Channel_Frequency/1e3));
   
end


% --- Executes on button press in oradio.
function oradio_Callback(hObject, eventdata, handles)
% hObject    handle to oradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of oradio
global estate
global fstate
global ostate
global m
global om       %orignal music
global em       %encrypted music
global fm       %filtered music
global mpos     %the position of the music 
global playm
set(handles.oradio,'value',1);
ostate=1;
m=0;
if (estate==1)||(fstate==1)  %if it is on it will not do anything
    set(handles.eradio,'value',0);
    set(handles.fradio,'value',0);

    if estate==1
        mpos=em.CurrentSample;  %save it before you stop it
        stop(em);
    elseif fstate==1
        mpos=fm.CurrentSample;  %save it before you stop it
        stop(fm);       
    end
    estate=0;
    fstate=0;

    play(om,mpos);
    pause(om);              %just to save the position
    if playm==1
        play(om,mpos);
    end
end

set(handles.fmenu,'visible',"off");
set(handles.MSEb,'visible',"off");
set(handles.MSET,'visible',"off");
set(handles.PSNRb,'visible',"off");
set(handles.PSNRT,'visible',"off");
set(handles.noise,'visible',"off");
set(handles.noiseb,'visible',"off");
set(handles.noiseT,'visible',"off");
end

% --- Executes on button press in eradio.
function eradio_Callback(hObject, eventdata, handles)
% hObject    handle to eradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of eradio
global estate
global fstate
global ostate
global m
global om       %orignal music
global em       %encrypted music
global fm       %filtered music
global mpos     %the position of the music 
global playm
set(handles.eradio,'value',1);
estate=1;
m=1;

if (ostate==1)||(fstate==1)  %if it is on it will not do anything
    set(handles.oradio,'value',0);
    set(handles.fradio,'value',0);

    if ostate==1
        mpos=om.CurrentSample;  %save it before you stop it
        stop(om);
    elseif fstate==1
        mpos=fm.CurrentSample;  %save it before you stop it
        stop(fm);    
    end
    ostate=0;
    fstate=0;

    play(em,mpos);
    pause(em);              %just to save the position
    if playm==1
        play(em,mpos);
    end
end

set(handles.fmenu,'visible',"off");
set(handles.MSEb,'visible',"off");
set(handles.MSET,'visible',"off");
set(handles.PSNRb,'visible',"off");
set(handles.PSNRT,'visible',"off");
set(handles.saveb,'visible',"on");
set(handles.noise,'visible',"on");
set(handles.noiseb,'visible',"on");
set(handles.noiseT,'visible',"on");
end

% --- Executes on button press in fradio.
function fradio_Callback(hObject, eventdata, handles)
% hObject    handle to fradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fradio
global ostate
global estate
global fstate
global m
global om       %orignal music
global em       %encrypted music
global fm       %filtered music
global f
global oy
global fy
global fmode    %which filter will be used
global vfact    %volume factor
global rate
global mpos     %the position of the music 
global playm
set(handles.fradio,'value',1);
fstate=1;
m=2;

if (ostate==1)||(estate==1)  %if it is on it will not do anything
    set(handles.oradio,'value',0);
    set(handles.eradio,'value',0);

    if ostate==1
        mpos=om.CurrentSample;  %save it before you stop it
        stop(om);
    elseif estate==1
        mpos=em.CurrentSample;  %save it before you stop it
        stop(em);    
    end
    ostate=0;
    estate=0;
    [fy]=filter_audio(oy,f,1,fmode);
    fm=audioplayer(vfact.*fy,rate.*f);
    play(fm,mpos);
    pause(fm);              %just to save the position
    if playm==1
        play(fm,mpos);
    end
end

set(handles.fmenu,'visible',"on");
set(handles.MSEb,'visible',"on");
set(handles.MSET,'visible',"on");
set(handles.PSNRb,'visible',"on");
set(handles.PSNRT,'visible',"on");
set(handles.saveb,'visible',"on");
set(handles.noise,'visible',"off");
set(handles.noiseb,'visible',"off");
set(handles.noiseT,'visible',"off");
end

% --- Executes on selection change in fmenu.
function fmenu_Callback(hObject, eventdata, handles)
% hObject    handle to fmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fmenu
global vfact
global rate     %speed of sound
global playm
global m
global om       %orignal music
global em       %encrypted music
global fm       %filtered music
global mpos     %the position of the music
global f
global oy
global fy
global fmode    %which filter will be used

if m==0
    mpos= om.CurrentSample; 
elseif m==1
    mpos= em.CurrentSample;
elseif m==2
    mpos= fm.CurrentSample;    
end

fmode=get(hObject,'Value');    %filter selection 1=wave, 2=FIR
%we need to filter the music
om=audioplayer(vfact.*oy,rate.*f);
[fy,MSE,PSNR]=filter_audio(oy,f,1,fmode);
set(handles.MSEb,'string',MSE);
set(handles.PSNRb,'string',PSNR);
fm=audioplayer(vfact.*fy,rate.*f);
play(om,mpos);
play(fm,mpos);
pause(om);
pause(fm);

if playm==1 %playing
    play(fm,mpos);    
end

end

% --- Executes during object creation, after setting all properties.
function fmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m
global om       %orignal music
global em       %encrypted music
global fm       %filtered music
global playm
global mpos     %the position of the music
stop(em);
stop(om);
stop(fm);
mpos=om.CurrentSample;  %restart
if m==0
    play(om);
elseif m==1
    play(em);
elseif m==2
    play(fm);
end
playm=1;
end

% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m
global om       %orignal music
global em       %encrypted music
global fm       %filtered music
global playm
global mpos     %the position of the music
pause(em);
pause(om);
pause(fm);
if m==0
    mpos=om.CurrentSample;
elseif m==1
    mpos=em.CurrentSample;
elseif m==2
    mpos=fm.CurrentSample;    
end
playm=0;
end

% --- Executes on button press in resume.
function resume_Callback(hObject, eventdata, handles)
% hObject    handle to resume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m
global om       %orignal music
global em       %encrypted music
global fm       %filtered music
global mpos     %the position of the music 
global playm
if m==0
    play(om,mpos);
elseif m==1
    play(em,mpos);
elseif m==2
    play(fm,mpos);
end
playm=1;
end

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global om       %orignal music
global em       %encrypted music
global fm       %filtered music
global playm
global mpos     %the position of the music
stop(em);
stop(om);
stop(fm);
playm=0;    %stop
mpos=om.CurrentSample;  %restart
end
    
% --- Executes on button press in fast.
function fast_Callback(hObject, eventdata, handles)
% hObject    handle to fast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vfact    %volume factor
global efact    %encryption factor
global rate     %speed of sound
global playm
global m
global om       %orignal music
global em       %encrypted music
global fm       %filtered music
global mpos     %the position of the music
global f
global oy
global ey
global fy
global fmode    %which filter will be used
global dstate
global orate
set(handles.dradio,'value',0);
dstate=0;

if m==0
    mpos= om.CurrentSample; 
elseif m==1
    mpos= em.CurrentSample;
elseif m==2
    mpos= fm.CurrentSample;
end

rate=rate+0.2*orate;
om=audioplayer(vfact.*oy,rate.*f);
ey=encrypt_audio(oy,efact);
em=audioplayer(vfact.*ey,rate.*f);
[fy]=filter_audio(oy,f,0,fmode);
fm=audioplayer(vfact.*fy,rate.*f);
play(om,mpos);
play(em,mpos);
play(fm,mpos);
pause(om);
pause(em);  
pause(fm);  
if playm==1 %playing
    switch m
        case 0
            play(om,mpos);
        case 1
            play(em,mpos);
        case 2
            play(fm,mpos);    
    end
end
set(handles.rateb,'string',rate);
set(handles.saveb,'visible',"on");
end

% --- Executes on button press in slow.
function slow_Callback(hObject, eventdata, handles)
% hObject    handle to slow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vfact    %volume factor
global efact    %encryption factor
global rate     %speed of sound
global playm
global m
global om       %orignal music
global em       %encrypted music
global fm       %filtered music
global mpos     %the position of the music
global f
global oy
global ey
global fy
global fmode    %which filter will be used
global dstate
global orate
set(handles.dradio,'value',0);
dstate=0;

if m==0
    mpos= om.CurrentSample; 
elseif m==1
    mpos= em.CurrentSample;
elseif m==2
    mpos= fm.CurrentSample;    
end

rate=rate-0.2*orate;
om=audioplayer(vfact.*oy,rate.*f);
ey=encrypt_audio(oy,efact);
em=audioplayer(vfact.*ey,rate.*f);
[fy]=filter_audio(oy,f,0,fmode);
fm=audioplayer(vfact.*fy,rate.*f);
play(om,mpos);
play(em,mpos);
play(fm,mpos);
pause(om);
pause(em);
pause(fm);
if playm==1 %playing
    switch m
        case 0
            play(om,mpos);
        case 1
            play(em,mpos);
        case 2
            play(fm,mpos);    
    end
end
set(handles.rateb,'string',rate);
set(handles.saveb,'visible',"on");

end

% --- Executes on slider movement.
function vol_Callback(hObject, eventdata, handles)
% hObject    handle to vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global vfact    %volume factor
global efact    %encryption factor
global rate     %speed of sound
global playm
global m
global om       %orignal music
global em       %encrypted music
global fm       %filtered music
global mpos     %the position of the music
global f
global oy
global ey
global fy
global fmode    %which filter will be used
global dstate
set(handles.dradio,'value',0);
dstate=0;

if m==0
    mpos= om.CurrentSample; 
elseif m==1
    mpos= em.CurrentSample;
elseif m==2
    mpos= fm.CurrentSample;
end

vr=get(hObject,'Value');    %volume read
if vr>=0.5  %increase the vol
   %we need to map as the min input is 0.5 max is 1, output min=1 max=5
   vfact=((vr-0.5)/0.5)*(5-1)+1;
else
   %we need to map as the min input is 0 max is 0.5, output min=0 max=0.2
   vfact=((vr-0)/0.5)*(0.5)+0;
end
om=audioplayer(vfact.*oy,rate.*f);
ey=encrypt_audio(oy,efact);
em=audioplayer(vfact.*ey,rate.*f);
[fy]=filter_audio(oy,f,0,fmode);
fm=audioplayer(vfact.*fy,rate.*f);
play(om,mpos);
play(em,mpos);
play(fm,mpos);
pause(om);
pause(em);
pause(fm);
if playm==1 %playing
    switch m
        case 0
            play(om,mpos);
        case 1
            play(em,mpos);
        case 2
            play(fm,mpos);    
    end
end
set(handles.volb,'string',vfact);
set(handles.saveb,'visible',"on");
end

% --- Executes on slider movement.
function noise_Callback(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global vfact
global efact    %encryption factor
global rate     %speed of sound
global playm
global m
global om       %orignal music
global em       %encrypted music
global fm       %filtered music
global mpos     %the position of the music
global f
global oy
global ey
global dstate
set(handles.dradio,'value',0);
dstate=0;

if m==0
    mpos= om.CurrentSample; 
elseif m==1
    mpos= em.CurrentSample;
elseif m==2
    mpos= fm.CurrentSample;    
end

nr=get(hObject,'Value');    %noise read
%we need to map as the min input is 0 max is 1, output min=0 max=0.1
efact=((nr-0)/1)*(0.1-0)+0;
om=audioplayer(vfact.*oy,rate.*f);
ey=encrypt_audio(oy,efact);
em=audioplayer(vfact.*ey,rate.*f);
play(om,mpos);
play(em,mpos);
pause(om);
pause(em);
if playm==1 %playing
    play(em,mpos);    
end
set(handles.noiseb,'string',efact);
set(handles.saveb,'visible',"on");
set(handles.noise,'visible',"on");
set(handles.noiseb,'visible',"on");
set(handles.noiseT,'visible',"on");
end

% --- Executes on button press in saveb.
function saveb_Callback(hObject, eventdata, handles)
% hObject    handle to saveb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vfact
global rate     %speed of sound
global f
global oy
global ey
global fy
global m
global om
global em
global fm       %filtered music
global closesavef
global savedfile
global ext
sm=audioplayer(vfact*oy,rate*f); %saved audio
msgbox("Choose the path to save the audio","Attention");
pause(3);
path=uigetdir();
savefigure=openfig("saveAudio.fig");
while closesavef==0
    %to delay
    pause(0.5);
end
closesavef=0; %to restart
close(savefigure);
savedfilep=path+"\"+savedfile; %file path
%normal audio
if m==0
    audiowrite(savedfilep,vfact*oy,rate*f);
elseif m==1
    audiowrite(savedfilep,vfact*ey,rate*f);
    sm=audioplayer(vfact*ey,rate*f);
elseif m==2
    audiowrite(savedfilep,vfact*fy,rate*f);
    sm=audioplayer(vfact*fy,rate*f);    
end
msgbox("The audio is saved","Message");
pause(3);
pause(om);
pause(em);
pause(fm);
stop(sm);
play(sm);
pause(5);
pause(sm);
end
