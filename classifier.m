function varargout = classifier(varargin)
% CLASSIFIER M-file for classifier.fig
%      CLASSIFIER, by itself, creates a new CLASSIFIER or raises the existing
%      singleton*.
%
%      H = CLASSIFIER returns the handle to a new CLASSIFIER or the handle to
%      the existing singleton*.
%
%      CLASSIFIER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLASSIFIER.M with the given input arguments.
%
%      CLASSIFIER('Property','Value',...) creates a new CLASSIFIER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before classifier_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to classifier_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help classifier

% Last Modified by GUIDE v2.5 10-Nov-2005 12:52:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @classifier_OpeningFcn, ...
                   'gui_OutputFcn',  @classifier_OutputFcn, ...
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


% --- Executes just before classifier is made visible.
function classifier_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to classifier (see VARARGIN)
global FigHandles
global CurrFigure
global Imagem
global Extract_ok
global Fig_Classifier
global Net_fullpath
global Feature_img
global A
global P
global cont2
cont2 = 0;
    
FigHandles = zeros(1,2); % armazena os handles da figura e imagem
CurrFigure = zeros(1,2); % handle da figura selecionada e da imagem
Imagem = []; % armazena a imagem

Feature_img = [];
Feature_img(1).contextfile = '';
Feature_img(1).som = '';
Feature_img(1).patterns = [];
Feature_img(1).classes = '';
Feature_img(1).classified_img = '';
Feature_img(1).classified_img_features = '';

  
Extract_ok = [0 0 0];
    
Fig_Extract = gcf; % armazena o handle da figura 'Extract'
    
% Choose default command line output for classifier
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes classifier wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = classifier_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in but_open_context.
function but_open_context_Callback(hObject, eventdata, handles)
% hObject    handle to but_open_context (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Extract_ok
global Feature
global Feature_img

[file, path] = uigetfile('*.mat','Select a Features file');
    if ~ (isequal(file,0) | isequal(path,0))
        full_name = fullfile(path,file);
        ocurr = findstr(full_name,'\');
        tam = size(ocurr,2);
        if tam>2
            part_name = strcat('...',full_name(1,ocurr(1,tam-2):ocurr(1,tam)),file);
        else
            part_name = full_name;
        end
        set(handles.txt_context,'String',part_name);
        load(full_name); % carrega o arquivo de atributos
        load(Feature(1).contextfile); % carrega o arquivo de contexto
        refresh_list_classes(handles);
        load_nets(handles);
    end
    Feature_img(1).contextfile = Feature(1).ffile;
    %open_image(Context.refimage);
    Feature_img(1).imgfile = Context.refimage;
    Extract_ok = [1 Extract_ok(1,2) 0];
    
    
% Reescreve as classes na listbox de classes com as cores correspondentes
function refresh_list_classes(handles)
global Feature
global Context

Class = Context(1).class;
classes = '';
if ~isempty(Class)
    for i=1:size(Class,2)
        classes = strvcat(classes,Class(i).name);
    end
    [sorted_names,sorted_index] = sortrows(classes);
    set(handles.text_class,'String',sorted_names,'Value',1);
    for i=1:size(Class,2)
        j = sorted_index(i);
        text_color(i) = uicontrol(handles.panel_class_color,'Style','edit','Units','characters','Position',[2.1 19.2-(1.1*i) 3.8 1.1],...
            'enable','inactive','BackgroundColor',Class(j).color); % create a panel object
    end
end


% Criado em 10/11/2005
% Carrega as redes treinadas com o arquivo de contexto selecionado
function load_nets(handles)
global Feature
global Net_fullpath
Net_filenames = Feature(1).netfiles;
filenames = '';
if ~isempty(Net_filenames)
    for i=1:size(Net_filenames,2)
        filenames = strvcat(filenames,Net_filenames(i).name);
    end
    %[sorted_names,sorted_index] = sortrows(filenames);
    set(handles.popupmenu_select_net,'String',filenames,'Value',1);
    for i=1:size(Net_filenames,2)
        Net_fullpath(i).somfile = Net_filenames(i).fullname;
    end
end



% --- Executes on selection change in popupmenu_select_net.
function popupmenu_select_net_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_select_net (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_select_net contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_select_net
global Feature
global Feature_img
global Net_fullpath
global Extract_ok
global val

val = get(hObject,'Value');
load(Net_fullpath(val).somfile);
Feature_img(1).som = Net_fullpath(val).somfile;


% --- Executes during object creation, after setting all properties.
function popupmenu_select_net_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_select_net (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global val
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
val = get(hObject,'Value');


% Open the image
function open_image(full_path)
global CurrFigure
global FigHandles
global Imagem

%% Set up the figure and defaults
CurrFigure(1,1) = figure('Units','characters',...
        'Position',[30 30 120 35],...
        'HandleVisibility','callback',...
        'IntegerHandle','off',...
        'Renderer','painters',...
        'Toolbar','figure',...
        'NumberTitle','off',...
        'Name',full_path,...
        'DeleteFcn',@delete_figure);

[lin col] = size(FigHandles);
FigHandles(lin+1,1) = CurrFigure(1,1); % armazena o handle da figura rec�m criada


%% Add an axes
a = axes('Parent',CurrFigure(1,1),'ButtonDownFcn',@figure_click);

%% Open selected image
[Imagem,MAP] = imread(full_path);    
warning off
colormap(MAP);
figure(CurrFigure(1,1))
CurrFigure(1,2) = image(Imagem); % armazena o handle da imagem
FigHandles(lin+1,2) = CurrFigure(1,2);
axis image;
set(gca,'XAxisLocation','top');
warning on



% --- Executes when any figure is deleted.
function delete_figure(hObject, eventdata, handles)
    global FigHandles
    global CurrFigure
    for i=1:size(FigHandles)
        try 
            if FigHandles(i) == CurrFigure(1,1)
                break
            end %if
        end %try
    end %for
    aux = zeros(size(FigHandles,1)-1,2);
    cont = 1;
    for j=2:size(FigHandles,1)
        if ~ j == i
            cont = cont +1;
            aux(cont,1:2) = FigHandles(j,1:2);
        end %if
    end %for
    
    FigHandles = aux;
    CurrFigure = FigHandles(size(FigHandles,1));
    if ~ CurrFigure == 0
        figure(CurrFigure); % faz a figura em CurrFigure ser a figura selecionada.
    end


% --- Executes on button press in but_execute.
function but_execute_Callback(hObject, eventdata, handles)
% hObject    handle to but_execute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Context
global Feature
global Extract_ok
global Imagem
global P
global Feature_img
global Net_fullpath
global val

Extract_ok = [Extract_ok(1,1) Extract_ok(1,2) 1];

% verifica se o arquivo de contexto tem uma imagem
continue_flag = 0;
if isempty(Feature_img(1).imgfile)
    errordlg('There is no Image file!','ERROR');
    continue_flag = 1;
end
if ~continue_flag % tudo ok com o arquivo de contexto!
   if Extract_ok % todos os campos ok, extrair atributos!!
       
       load(Net_fullpath(val).somfile);
       Feature_img(1).som = Net_fullpath(val).somfile;
       save(Feature_img(1).classified_img_features,'Feature_img');
       % Salvar os blocos de processamento 
       load(Feature(1).config);
       borda = floor(F.tam/2);
       blck_size = 50; % criar uma textbox para o usuario definir o tamanho do bloco?
       patterns = zeros(1,(F(1).ori*F(1).est*2)+2);
       Block = []; 
       xy = [borda+1 borda+1];
       info = imfinfo(Feature_img(1).imgfile);
       width_xy = fix(info.Width)-2*borda;
       height_xy = fix(info.Height)-2*borda;       
       n_blocos(1) = ceil(height_xy/blck_size);
       n_blocos(2) = ceil(width_xy/blck_size);
       cband = A.ibands; % conta as bandas selecionadas       
       cont = 0;
       current_folder = pwd;
       cd('dados/img');
                      
       for i=1:n_blocos(1)
           for j=1:n_blocos(2)
               cont = cont+1;
               blck_name = sprintf('block%d.mat',cont);
               % para cada banda...
               for m=1:size(cband,2)
                   Banda = imread(Feature(cband(m)).band); % l� a banda, sem georreferenciamento mesmo
                   Block(m).id = cont;
                   Block(m).pix = xy;
                   Block(m).img = Banda((xy(1) - borda):(xy(1) + blck_size-(~(n_blocos(1)-i)*(blck_size-mod(height_xy,blck_size))) + borda-1), (xy(2) - borda):(xy(2) + blck_size-(~(n_blocos(2)-j)*(blck_size-mod(width_xy,blck_size))) + borda-1));
               end
               save(blck_name,'Block');
               xy(2) = xy(2) + blck_size;
           end
           xy(1) = xy(1) + blck_size;
           xy(2) = borda + 1;
       end
       
       cd(current_folder);
       
   end
end


% --- Executes on button press in but_exit.
function but_exit_Callback(hObject, eventdata, handles)
% hObject    handle to but_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global FigHandles

for i=2:size(FigHandles,1)
    delete(FigHandles(i,1));
end;

shh = get(0,'ShowHiddenHandles');
set(0,'ShowHiddenHandles','on');
currFig = get(0,'CurrentFigure');
set(0,'ShowHiddenHandles',shh);
delete(currFig);




% --- Executes on button press in but_save_img.
function but_save_img_Callback(hObject, eventdata, handles)
% hObject    handle to but_save_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Feature_img
global Extract_ok 

[file,path] = uiputfile('*.tif','Save Classified Image');
if ~ (isequal(file,0) | isequal(path,0))
    full_name = fullfile(path,file);
    ocurr = findstr(full_name,'\');
    tam = size(ocurr,2);
    if tam>2
        part_name = strcat('...',full_name(1,ocurr(1,tam-2):ocurr(1,tam)),file);
    else
        part_name = full_name;
    end
    set(handles.text_final_img,'String',part_name);
    Feature_img(1).classified_img = full_name;
    % Salva os atributos da imagem em um arquivo com o mesmo nome da
    % imagem, mas com a terminacao '_features' 
    occur = findstr(full_name,'\');
    features_name = full_name(1,occur(1,end)+1:length(full_name)-4); % s� pega o nome do arquivo, sem '.mat'
    path = full_name(1,1:occur(1,end)); 
    Feature_img(1).classified_img_features = strcat(path,features_name,'_features.mat');
    Feature_img(1).classes = strcat(path,features_name,'_classes.dat');
    save(Feature_img(1).classified_img_features,'Feature_img');
    Extract_ok = [Extract_ok(1,1) 1 0];
end


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in but_view_net.
% Mostra a configuracao (parametros) da rede selecionada
function but_view_net_Callback(hObject, eventdata, handles)
% hObject    handle to but_view_net (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Net_fullpath

val = get(handles.popupmenu_select_net,'Value');
load(Net_fullpath(val).somfile);


%*****************************************************************
function classe = execute_som(handles,Imagem,P)
global A
global Net_fullpath

val = get(handles.popupmenu_select_net,'Value');
load(Net_fullpath(val).somfile);
W = A.pesos;
Grade = A.grade;
tot = size(P,1);
[lin,col,z] = size(W);
for i=1:tot % percorre todos os elementos do arquivo de teste
    WN = winner_neuron(P(i,3:end),lin,col,W); % calcula neur�nio vencedor
    xy = P(i,1:2);
    classe(xy(1),xy(2)) = Grade(WN(1),WN(2));
end
paint_image(handles,Imagem,classe);

%**************************************************************************
function paint_image(handles,Imagem,c)
global Context
global Feature_img

img = imread(Feature_img(1).imgfile);
map = [0 0 0];
for i=2:size(Context(1).class,2)+1
    map(i,:)=Context(1).class(i-1).color;
end
img = zeros(size(img));
for i=1:size(c,1)
    for j=1:size(c,2)
        img(i,j) = c(i,j)+1;
    end
end
colormap(map);
imwrite(img,map,Feature_img(1).classified_img,'tif')
open_image(Feature_img(1).classified_img)
   
%**************************************************************************
% --- Identifica as coordenadas do neur�nio vencedor 
function WN = winner_neuron(atr,r,c,W)
% entrada: vetor de atributo, total de linhas e colunas, pesos
[a col] = size(atr);
atr = atr';
Dup=atr(:,ones(r,1),ones(c,1));
Dup=permute(Dup,[2,3,1]); 
Dif= W - Dup;
Sse=sqrt(sum(Dif.^2,3));
[val1 win_rows]=min(Sse); 
[val2 wc]=min(val1); 
wr=win_rows(wc); 
WN(1,1:2)=[wr wc]; % neur�nio vencedor

