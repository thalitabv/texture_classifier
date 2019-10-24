function varargout = selbands(varargin)
% SELBANDS M-file for selbands.fig
%      SELBANDS, by itself, creates a new SELBANDS or raises the existing
%      singleton*.
%
%      H = SELBANDS returns the handle to a new SELBANDS or the handle to
%      the existing singleton*.
%
%      SELBANDS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELBANDS.M with the given input arguments.
%
%      SELBANDS('Property','Value',...) creates a new SELBANDS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before selbands_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to selbands_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selbands

% Last Modified by GUIDE v2.5 05-May-2006 11:28:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @selbands_OpeningFcn, ...
                   'gui_OutputFcn',  @selbands_OutputFcn, ...
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


% --- Executes just before selbands is made visible.
function selbands_OpeningFcn(hObject, eventdata, handles, varargin)
global Feature
global IBands

Lista = cell(1,1);
for i=1:size(Feature,2)
    occur = findstr(Feature(i).band,'\');
    Lista{i,1} = Feature(i).band(occur(size(occur,2))+1:end); % s� pega o nome do arquivo
end
set(handles.list_bands,'String',Lista); % mostra as bandas de onde se 
% extraiu atributos
handles.output = hObject;
set(handles.figure1,'WindowStyle','modal')

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes selbands wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = selbands_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in list_bands.
function list_bands_Callback(hObject, eventdata, handles)
% hObject    handle to list_bands (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns list_bands contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_bands


% --- Executes during object creation, after setting all properties.
function list_bands_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_bands (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in but_ok.
function but_ok_Callback(hObject, eventdata, handles)
global Lista
global IBands

IBands = get(handles.list_bands,'Value'); % �ndices dos itens selecionados, 
% que � o �ndice na estrutura Feature, indicando as bandas selecionadas
        % insere bandas no popup 
popstr = get(handles.list_bands,'String'); 
Lista = cell(1,1);
for i=1:size(IBands,2)
    Lista{i,1}= popstr{IBands(1,i),1}; % s� pega o nome do arquivo
end
delete(gcf)


% --- Executes on button press in but_cancel.
function but_cancel_Callback(hObject, eventdata, handles)
delete(gcf)

