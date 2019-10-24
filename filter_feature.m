% o usu�rio determina o arquivo de configura��o do filtro, onde est�o os
% filtros, o nome do arquivo de atributos e as bandas de extra��o
function varargout = filter_feature(varargin)
% FILTER_FEATURE M-file for filter_feature.fig
%      FILTER_FEATURE, by itself, creates a new FILTER_FEATURE or raises the existing
%      singleton*.
%
%      H = FILTER_FEATURE returns the handle to a new FILTER_FEATURE or the handle to
%      the existing singleton*.
%
%      FILTER_FEATURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTER_FEATURE.M with the given input arguments.
%
%      FILTER_FEATURE('Property','Value',...) creates a new FILTER_FEATURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before filter_feature_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to filter_feature_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help filter_feature

% Last Modified by GUIDE v2.5 19-Apr-2006 17:07:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @filter_feature_OpeningFcn, ...
                   'gui_OutputFcn',  @filter_feature_OutputFcn, ...
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

%**************************************************************************
% --- Executes just before filter_feature is made visible.
function filter_feature_OpeningFcn(hObject, eventdata, handles, varargin)
global Feature
global Extract_ok 
Extract_ok = [0 0 0 0 0]; % 4 campos nao preenchidos, mais botao Extract
% se o arq de contexto ja contiver dados para extracao de atributos, entao
% preecher os campos!
if ~isempty(Feature(1).config)
    ocurr = findstr(Feature(1).config,'\');
    tam = size(ocurr,2);
    set(handles.txt_configuration,'String',Feature(1).config(ocurr(tam-1):end));
    Extract_ok = [1 Extract_ok(1,2) Extract_ok(1,3) Extract_ok(1,4) 0];
end
if ~isempty(Feature(1).filters)
    ocurr = findstr(Feature(1).filters,'\');
    tam = size(ocurr,2);    
    set(handles.txt_filters,'String',Feature(1).filters(ocurr(tam-1):end));
    Extract_ok = [Extract_ok(1,1) 1 Extract_ok(1,3) Extract_ok(1,4) 0];
end
if ~isempty(Feature(1).ffile)
    ocurr = findstr(Feature(1).ffile,'\');
    tam = size(ocurr,2);        
    set(handles.txt_save,'String',Feature(1).ffile(ocurr(tam-1):end));
    Extract_ok = [Extract_ok(1,1) Extract_ok(1,2) 1 Extract_ok(1,4) 0];
end
if ~isempty(Feature(1).band)
    cont = size(Feature,2);
    popstr = cell(1);
    for i=1:cont
        fulln = Feautre(i).band;
        occur = findstr(fulln,'\');
        popstr{i,1} = fulln(occur(size(occur,2))+1:end); % copiar so o nome do arquivo
    end
    set(handles.popbands,'String',popstr); % preenche a listbox
    Extract_ok = [Extract_ok(1,1) Extract_ok(1,2) Extract_ok(1,3) 1 0];
end

% Choose default command line output for filter_feature
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes filter_feature wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%**************************************************************************
% --- Outputs from this function are returned to the command line.
function varargout = filter_feature_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%**************************************************************************
% --- Executes on button press in but_filter_param.
function but_filter_param_Callback(hObject, eventdata, handles)
[file, path] = uigetfile('*.mat','Select a Filter Configuration file');
global Feature
global Extract_ok 

if ~ (isequal(file,0) | isequal(path,0))
    full_name = fullfile(path,file);
    ocurr = findstr(full_name,'\');
    tam = size(ocurr,2);
    if tam>2
        part_name = strcat('...',full_name(1,ocurr(1,tam-2):ocurr(1,tam)),file);
    else
        part_name = full_name;
    end
    set(handles.txt_configuration,'String',part_name);
    Feature(1).config = fullfile(path,file);
    Extract_ok = [1 Extract_ok(1,2) Extract_ok(1,3) Extract_ok(1,4) 0];
end

%**************************************************************************
% --- Executes on button press in but_filters.
function but_filters_Callback(hObject, eventdata, handles)
global Feature
global Extract_ok 

dname = uigetdir('','Select the Gabor Filters Folder');
if dname~=0
    full_name = dname;
    ocurr = findstr(full_name,'\');
    tam = size(ocurr,2); % tam recebe a quantidade de ocorrencias
    if tam>2
        part_name = strcat('...',full_name(1,ocurr(1,tam-2):end));
    else
        part_name = full_name;
    end
    set(handles.txt_filters,'String',part_name);
    Feature(1).filters = dname;
    Extract_ok = [Extract_ok(1,1) 1 Extract_ok(1,3) Extract_ok(1,4) 0];
end

%**************************************************************************
% --- Executes on button press in but_save.
function but_save_Callback(hObject, eventdata, handles)
global Feature
global Extract_ok 

[file,path] = uiputfile('feature1.mat','Save Features As...');
if ~ (isequal(file,0) | isequal(path,0))
    full_name = fullfile(path,file);
    ocurr = findstr(full_name,'\');
    tam = size(ocurr,2);
    if tam>2
        part_name = strcat('...',full_name(1,ocurr(1,tam-2):ocurr(1,tam)),file);
    else
        part_name = full_name;
    end
    set(handles.txt_save,'String',part_name);
    Feature(1).ffile = full_name;
    Extract_ok = [Extract_ok(1,1) Extract_ok(1,2) 1 Extract_ok(1,4) 0];
end

%**************************************************************************
% --- Executes on button press in but_extract.
function but_extract_Callback(hObject, eventdata, handles)
global Feature
global Extract_ok 

Extract_ok = [Extract_ok(1,1) Extract_ok(1,2) Extract_ok(1,3) Extract_ok(1,4) 1];
if ~Extract_ok
    errordlg('There is at least one field with trobles!','ERROR');
else
    save(Feature(1).ffile,'Feature');
    delete(gcf)
end

%**************************************************************************
% --- Executes on button press in but_cancel.
function but_cancel_Callback(hObject, eventdata, handles)
global Extract_ok 

Extract_ok = [Extract_ok(1,1) Extract_ok(1,2) Extract_ok(1,3) Extract_ok(1,4) 0];
delete(gcf)


%**************************************************************************
% sele��o de bandas de onde ser�o extra�dos atributos
function but_feat_sp_b_Callback(hObject, eventdata, handles)
global Extract_ok
global Feature

[file, path] = uigetfile('*.tif','Select Band(s) for Feature Extraction','Multiselect','on');
if ~ (isequal(file,0) | isequal(path,0))
    cont = size(file,1);
    if cont==1
        Feature(1).band = strcat(path,file);
    else
        file = sort(file)'; % nomes em ordem alfab. e na vertical
        for i=1:cont
            Feature(i).band = strcat(path,file{i});
        end
    end
    set(handles.popbands,'String',file);
    Extract_ok = [Extract_ok(1,1) Extract_ok(1,2) Extract_ok(1,3) 1 0];
end


%**************************************************************************
% --- Executes during object creation, after setting all properties.
function popbands_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popbands (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in popbands.
function popbands_Callback(hObject, eventdata, handles)
% hObject    handle to popbands (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popbands contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popbands


