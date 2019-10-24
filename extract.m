function varargout = extract(varargin)
% Interface para selecao de regioes de interesse de imagens de 
% sensoriamento remotoe extracao de atributos de Gabor

% Last Modified by GUIDE v2.5 19-Oct-2005 11:25:10

% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @extract_OpeningFcn, ...
                       'gui_OutputFcn',  @extract_OutputFcn, ...
                       'gui_DeleteFcn',  @extract_DeleteFcn, ...
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
    

% --- Executes just before extract is made visible.
function extract_OpeningFcn(hObject, eventdata, handles, varargin)
    global FigHandles
    global CurrFigure
    global RecOk
    global Context
    global Feature
    global Imagem
    global Hrois
    global Cent
    global Extract_ok
    global Fig_Extract
    global cont2
    cont2 = 0;
    
    FigHandles = zeros(1,2); % armazena os handles da figura e imagem
    CurrFigure = zeros(1,2); % handle da figura selecionada e da imagem
    RecOk = 0;    % flag que indica se da para desenhar ou nao o retangulo de coleta de amostra
    Imagem = []; % armazena a imagem

    Class(1).name = ''; % nome da classe
    Class(1).color = []; % vetor RGB da cor representativa da classe
    
    Roi(1).classname = '';
    Roi(1).roi_name = '';
    Roi(1).polig_x = [];
    Roi(1).polig_y = [];
    Roi(1).BW = []; % mascara binaria
    Roi(1).centroid = []; % ponto central da mascara
    
    Context(1).contextfile = ''; % estrutura de dados que armazena as informacoes das rois
    Context(1).refimage = '';
    Context(1).class = []; % estrutura com os nomes das classes e respectivas cores
    Context(1).roi = []; % estrutura para receber os dados das rois: classe e poligono
    %Context(1).config = ''; % arquivo de configuracao do filtro de extracao de atributos
    %Context(1).filters = ''; % pasta que contem os filtros
    %Context(1).features = ''; % arquivo de atributos  
    %Context(1).bands(1).fullname = ''; % armazena caminho das bandas para extracao
    
    Feature(1).contextfile = ''; % estrutura de dados que armazena as informacoes das rois
    Feature(1).ffile = ''; % estrutura de dados gerais que armazena as informacoes do processo de extracao
    Feature(1).band = ''; % nome da banda
    Feature(1).structure = []; % estrutura com classes, ROIs e atributos
    Feature(1).config = ''; % arquivo de configuracao do filtro de extracao de atributos
    Feature(1).filters = ''; % pasta que contem os filtros
    Feature(1).netfiles = []; % nomes das redes treinadas para este arquivo de atributos
        
    Hrois = []; % armazena os handles das ROIs desenhadas sobre a imagem
    
    Cent = []; % armazena o centro da ROI selecionada para desenhar um s�mbolo gr�fico
    
    Extract_ok = [0 0 0 0];
    
    Fig_Extract = gcf; % armazena o handle da figura 'Extract'
    
    % Choose default command line output for extract
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes extract wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
 
    
% --- Outputs from this function are returned to the command line.
function varargout = extract_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;


% --- Executes on button press in but_extract.
function but_extract_Callback(hObject, eventdata, handles)
global Context
global Feature
global Extract_ok
global Imagem
try
    load(Context(1).contextfile);
catch
    errordlg('There is no Context file!','ERROR');
    return
end
% verifica se o arquivo de contexto tem pelo menos uma imagem, uma classe e
% uma roi
continue_flag = 0;
if isempty(Context(1).refimage)
    errordlg('There is no Image file!','ERROR');
    continue_flag = 1;
    if ~isempty(Context(1).class)
        errordlg('There is no Class!','ERROR');
        continue_flag = 1;
        if ~isempty(Context(1).roi)
            errordlg('There is no ROI!','ERROR');
            continue_flag = 1;
        end
    end
end
if ~continue_flag % tudo ok com o arquivo de contexto!
    filter_feature

    % WAITFOR Block execution and wait for event.
    % WAITFOR(H) returns when the graphics object identified by H
    % is deleted or when Ctrl-C is typed in the Command Window. If H does 
    % not exist, waitfor returns immediately without processing any events.
    % Modificado em 10/10/2005
    waitfor(gcf); % espera fechar a janela filter_feature
    
    
    if Extract_ok % todos os campos ok, extrair atributos!!
           
        % Salvar os blocos de processamento 
        load(Feature(1).config);
        borda = floor(F.tam/2);
        blck_size = 50; % criar uma textbox para o usuario definir o tamanho do bloco?
        Block = []; 
        cont = 0;
        cband = size(Feature,2); % conta as bandas selecionadas       
        current_folder = pwd;
        cd('dados/roi');
                
        for c=1:size(Context.class,2)
            for r=1:size(Context.roi,2)
                if strcmp(Context.roi(r).classname,Context.class(c).name)
                    bbox = regionprops(bwlabel(Context.roi(r).BW),'BoundingBox');
                    xy = [fix(bbox.BoundingBox(1,2))+1 fix(bbox.BoundingBox(1,1))+1]; % coordenadas iniciais
                    roisize = [fix(bbox.BoundingBox(1,4)) fix(bbox.BoundingBox(1,3))];                    
                    %lst_blck = xy + roisize - mod(roisize,blck_size);
                    n_blocos = ceil(roisize/blck_size);
                    for i=1:n_blocos(1)
                        for j=1:n_blocos(2)
                            cont = cont+1;
                            blck_name = sprintf('roi_block%d.mat',cont)
                            % para cada banda...
                            for m=1:cband
                                Banda = imread(Feature(m).band); % le a banda, sem georreferenciamento mesmo
                                Block(m).id = cont;
                                Block(m).pix = xy;
                                Block(m).roi = Context.roi(r).roi_name;
                                Block(m).img = Banda((xy(1) - borda):(xy(1) + blck_size-(~(n_blocos(1)-i)*(blck_size-mod(roisize(1),blck_size))) + borda-1), (xy(2) - borda):(xy(2) + blck_size-(~(n_blocos(2)-j)*(blck_size-mod(roisize(2),blck_size))) + borda-1));
                                Block(m).BW = Context.roi(r).BW((xy(1) - borda):(xy(1) + blck_size-(~(n_blocos(1)-i)*(blck_size-mod(roisize(1),blck_size))) + borda-1), (xy(2) - borda):(xy(2) + blck_size-(~(n_blocos(2)-j)*(blck_size-mod(roisize(2),blck_size))) + borda-1));
                            end
                            save(blck_name,'Block');
                            xy(2) = xy(2) + blck_size;
                        end
                        xy(1) = xy(1) + blck_size;
                        xy(2) = fix(bbox.BoundingBox(1,1)) + 1;
                    end
                end
            end
        end
        
        cd(current_folder);
        
    end
    
end


% --- Executes on button press in but_exit.
function but_exit_Callback(hObject, eventdata, handles)
global FigHandles

for i=2:size(FigHandles,1)
    delete(FigHandles(i,1));
end;

shh = get(0,'ShowHiddenHandles');
set(0,'ShowHiddenHandles','on');
currFig = get(0,'CurrentFigure');
set(0,'ShowHiddenHandles',shh);
delete(currFig);

% --- Executes on button press in but_new_context.
function but_new_context_Callback(hObject, eventdata, handles)
    global Context
    global Feature
    [file,path] = uiputfile('contexto1.mat','New Context File');
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
        Context(1).contextfile = full_name;
        Feature(1).contextfile = full_name;
        save(full_name,'Context');
    end



% --- Executes on button press in but_open_context.
function but_open_context_Callback(hObject, eventdata, handles)
    [file, path] = uigetfile('*.mat','Select a Context file');
    global Context
    global Feature
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
        Context(1).contextfile = fullfile(path,file);
        Feature(1).contextfile = fullfile(path,file);
        load(full_name); % carrega o arquivo de contexto
        % abre a imagem e preenche as listbox
        try
            open_image(Context(1).refimage);
            refresh_list_classes(handles);
        catch
            errordlg('The image can not be openned!','ERROR');
        end
    end
 



% --- Executes on button press in but_bandsel.
function but_bandsel_Callback(hObject, eventdata, handles)
    [file, path] = uigetfile({'*.bmp';'*.tif'},'Select a Band');
    if ~ isequal(file,0) | isequal(path,0)
        open_image(strcat(path,file));
    end
    
% abre a imagem
function open_image(full_path)
global CurrFigure
global FigHandles
global Context
global Imagem

Geo_data(1).GeoInf = [];
Geo_data(1).axesm = [];
Geo_data(1).map = [];
Geo_data(1).infoshape(1).Hshape(1).name = '';
Geo_data(1).infoshape(1).Hshape(1).handles = [];

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

f = uimenu('Label','Shape');
    uimenu(f,'Label','Open','Callback', @open_shape);
    uimenu(f,'Label','Remove','Callback', @remove_shape);   
    
[lin col] = size(FigHandles);
FigHandles(lin+1,1) = CurrFigure(1,1); % armazena o handle da figura recem criada
Context(1).refimage = full_path;
save(Context(1).contextfile,'Context');

%% Add an axes
a = axes('Parent',CurrFigure(1,1),'ButtonDownFcn',@figure_click);

%% Open selected image
%[Imagem,MAP] = imread(full_path);
%warning off
%colormap(MAP);
%figure(CurrFigure(1,1))
%CurrFigure(1,2) = image(Imagem); % armazena o handle da imagem
%FigHandles(lin+1,2) = CurrFigure(1,2);
%axis image;
%set(gca,'XAxisLocation','top');
%warning on
try
    GeoInf = geotiffinfo(full_path); % Le informa��es do arquivo
catch
    errordlg('Geotiff reading failed.');
    return
end
LAT_INF = GeoInf(1).CornerCoords.LAT(1); % BoundingBox(3); % captura latitude inferior do ret�ngulo envolvente
LAT_SUP = GeoInf(1).CornerCoords.LAT(2); %BoundingBox(4); % captura latitude superior do ret�ngulo envolvente
LON_INF = GeoInf(1).CornerCoords.LON(1); %BoundingBox(1); % captura longitude inferior do ret�ngulo envolvente
LON_SUP = GeoInf(1).CornerCoords.LON(3); %BoundingBox(2); % captura longitude superior do ret�ngulo envolvente
X_SUP = GeoInf(1).CornerCoords.X(3); % Captura o X superior da imagem
X_INF = GeoInf(1).CornerCoords.X(1); % Captura o X inferior da imagem
Y_SUP = GeoInf(1).CornerCoords.X(3); % Captura o Y superior da imagem
Y_INF = GeoInf(1).CornerCoords.X(1); % Captura o Y inferior da imagem
if LAT_INF > LAT_SUP % verifica o valor das latitudes
    AUX = LAT_SUP;
    LAT_SUP = LAT_INF;
    LAT_INF = AUX;
end
if LON_INF > LON_SUP % verifica o valor das longitudes
   AUX = LON_SUP;
   LON_SUP = LON_INF;
   LON_INF = AUX;
end
zone = utmzone(LAT_SUP,LON_SUP);
warning off
Geo_data(1).GeoInf = GeoInf; 
figure(CurrFigure(1,1))
Geo_data(1).axesm = axesm ('MapProjection','utm', 'Zone',  zone,...
    'AngleUnits', 'dms','Grid', 'off', 'MapLatLimit', [LAT_INF LAT_SUP], ...
    'MapLonLimit', [LON_INF LON_SUP], 'FFill', 100); % Cria um objeto do 
    % tipo axesm para inserir a imagem e armazena o handle na figura
[X, cmap, R, bbox] = geotiffread(full_path);  % Le o conte�do do arquivo
Geo_data(1).map = mapshow(X,cmap,R); % Mostra o mapa no axes e armazena o handle
FigHandles(lin+1,1) = CurrFigure(1,1);
showaxes; % Mostra os eixos
Grid on; % Mostra o grid
set(gca,'XAxisLocation','top');
warning on
set(CurrFigure(1,1),'UserData',Geo_data); %armazena a estrutura no UserData da figura.



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



% --- Executes during object creation, after setting all properties.
function edt_classname_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in but_insert_class.
function but_insert_class_Callback(hObject, eventdata, handles)
    global RecOk
    global FigHandles
    global Context
    
    if ~ isempty(get(handles.edt_classname,'String')) % h� um nome para a classe
        RecOk = 1;
        load(Context(1).contextfile);
        Class = Context(1).class;
        % verifica se o nome e a cor da classe j� existem no contexto
        flag = 0;
        for i=1:(size(Context(1).class,2))
           if strcmp(Class(i).name,get(handles.edt_classname,'String')) | ...
                   all(Class(i).color == get(handles.panel_color,'BackgroundColor'))
               errordlg('Class name or color already exists.','Extract')
               flag = 1;
               break
           end
        end
        if ~flag
            % verifica quantas classes j� foram armazenadas e insere
            % mais uma
            a = size(Context(1).class,2)+1;
            Class(a).name = get(handles.edt_classname,'String');
            Class(a).color = get(handles.panel_color,'BackgroundColor');
            % armazena dados da classe no arquivo de contexto
            Context(1).class = Class;
            save(Context(1).contextfile,'Context');
        end
    else
        errordlg('You must tipe a class name.','Extract')
    end
    refresh_list_classes(handles);

% reescreve as classes na listbox de classes
function refresh_list_classes(handles)
global Context
load(Context(1).contextfile);
Class = Context(1).class;
classes = '';
if ~isempty(Class)
    for i=1:size(Class,2)
        classes = strvcat(classes,Class(i).name);
    end
    [sorted_names,sorted_index] = sortrows(classes);
    set(handles.list_classes,'String',sorted_names,'Value',1);
    set(handles.edt_classname,'String',sorted_names(1,:));
    set(handles.panel_color, 'BackgroundColor', Class(1).color);
    refresh_list_rois(handles,get(handles.edt_classname,'String'));
else
    % valor default
    set(handles.edt_classname,'String','');
    set(handles.panel_color,'BackgroundColor',[1 1 1]);
    set(handles.list_classes,'String','');
    refresh_list_rois(handles,'nothing'),
end

 
% --------------------------------------------------------------------
function panel_color_ButtonDownFcn(hObject, eventdata, handles)
    set(handles.panel_color,'BackgroundColor',uisetcolor);



% --- Executes on selection change in list_classes.
function list_classes_Callback(hObject, eventdata, handles)
if get(hObject,'Value') ~= 0
    global Context
    contents = get(hObject,'String');
    big_name = contents(get(hObject,'Value'),:); % podem haver espa�os em branco 
    % que impedir�o a compara��o mais � frente.
    result = isspace(big_name); % 'abcd   ' = [0 0 0 0 1 1 1 ]
    for i=1:size(big_name,2);
        if ~result(1,i)
            final_name(1,i) = big_name(1,i);
        else
            break
        end
    end
    set(handles.edt_classname,'String',final_name);
    A = Context(1).class;
    for i=1:size(A,2)
        if strcmp(A(i).name,final_name)
            set(handles.panel_color,'BackgroundColor',A(i).color);
            refresh_list_rois(handles,final_name); 
            break
        end
    end
end


% --- Executes during object creation, after setting all properties.
function list_classes_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in but_cl_remove.
function but_cl_remove_Callback(hObject, eventdata, handles)
global Context
if ~isempty(get(handles.edt_classname,'String'))
    if ~isempty(Context(1).class)
        % remover classe
        Class = Context(1).class;
        cont = 0;
        Aux(1).name = '';
        Aux(1).color = [];
        for i=1:size(Class,2)
            if ~strcmp(Class(i).name, get(handles.edt_classname,'String'))
                cont = cont+1;
                Aux(cont) = Class(i);
            end
        end
        Context(1).class = Aux;
        % remover rois
        R = Context(1).roi;
        cont = 0;
        Aux(1).classname = '';
        Aux(1).roi_name = '';
        Aux(1).polig_x = [];
        Aux(1).polig_y = [];
        Aux(1).BW = []; 
        Aux(1).centroid = [];
        for i=1:size(R,2)
            if ~strcmp(R(i).classname, get(handles.edt_classname,'String'))
                cont = cont+1;
                Aux(cont).classname = R(i).classname;
                Aux(cont).roi_name = R(i).roi_name;
                Aux(cont).polig_x = R(i).polig_x;
                Aux(cont).polig_y = R(i).polig_y;
                Aux(cont).BW = R(i).BW; 
                Aux(cont).centroid = R(i).centroid; 
            end
        end
        Context(1).roi = Aux;
        save(Context(1).contextfile,'Context');
    end
end
refresh_list_classes(handles); % esta chamar� refresh_list_rois
    
    
% --- Executes on selection change in list_rois.
function list_rois_Callback(hObject, eventdata, handles)
global Context
global Hrois
global Cent
global CurrFigure
if ~isempty(Cent)
    try
        delete(Cent(1,1));
    end
end
if get(hObject,'Value') ~= 0
    contents = get(hObject,'String');
    selected_roi = contents(get(hObject,'Value'),:);
    R = Context(1).roi;
    for i=1:size(R,2)
        if strcmp(R(i).roi_name,selected_roi)
            % desenha o s�mbolo sobre a roi
            figure(CurrFigure(1,1))
            S = R(i).centroid.Centroid;
            Cent(1,1) = rectangle('Position',[S(1,1)-10,...
                S(1,2)-10,20,20],'FaceColor','m','EdgeColor','m');
            break
        end
    end
end



% --- Executes during object creation, after setting all properties.
function list_rois_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in but_roi_remove.
function but_roi_remove_Callback(hObject, eventdata, handles)
global Context
if ~isempty(get(handles.list_rois,'String'))
    if get(handles.list_rois,'Value')~=0 % uma roi foi selecionada
        contents = get(handles.list_rois,'String');
        selected_roi = contents(get(handles.list_rois,'Value'),:);
        % remover roi
        R = Context(1).roi;
        cont = 0;
        Aux(1).classname = '';
        Aux(1).roi_name = '';
        Aux(1).polig_x = [];
        Aux(1).polig_y = [];
        Aux(1).BW = []; 
        Aux(1).centroid = []; 
        for i=1:size(R,2)
            if ~strcmp(R(i).roi_name, selected_roi)
                cont = cont+1;
                Aux(cont).classname = R(i).classname;
                Aux(cont).roi_name = R(i).roi_name;
                Aux(cont).polig_x = R(i).polig_x;
                Aux(cont).polig_y = R(i).polig_y;
                Aux(cont).BW = R(i).BW; 
                Aux(cont).centroid = R(i).centroid; 
            end
        end
        Context(1).roi = Aux;
        save(Context(1).contextfile,'Context');
    end
end
class = get(handles.edt_classname,'String');
refresh_list_rois(handles,class); % esta chamar� refresh_list_rois




% --- Executes on button press in but_acquire_roi.
function but_acquire_roi_Callback(hObject, eventdata, handles)
global CurrFigure
global Imagem
global Context
global Hrois
% verifica se uma classe est� selecionada
if ~isempty(get(handles.edt_classname,'String'))
    Class = Context(1).class;
    if ~isempty(Class)
        for i=1:size(Class,2)
            if strcmp(Class(i).name,get(handles.edt_classname,'String'))
                color = Class(i).color;
                break
            end
        end
        
        [lin, col] = size(Hrois);
        figure(CurrFigure(1,1))
        set(gcf,'Pointer','cross');
        [BW,xi,yi] = roipoly;
        set(CurrFigure(1,1),'Pointer','arrow');        
        N_Roi = Context(1).roi;
        % conta quantas ROIs existem, soma 1 (tam)
        % conta quantas rois existem para aquela determinada classe, soma 1
        % (rl)
        if ~isempty(N_Roi)
            tam = size(N_Roi,2)+1;
            cont = 0;
            for j=1:size(N_Roi,2)
                if strcmp(N_Roi(j).classname,get(handles.edt_classname,'String'))
                   cont = cont+1;
                end
            end
            rl = cont+1;
        else
            tam = 1;
            rl = 1;
        end
        N_Roi(tam).classname = get(handles.edt_classname,'String');
        N_Roi(tam).roi_name = strcat(get(handles.edt_classname,'String'),'_',num2str(rl));
        N_Roi(tam).polig_x = xi; 
        N_Roi(tam).polig_y = yi; 
        N_Roi(tam).BW = BW;
        L = bwlabel(BW);
        N_Roi(tam).centroid = regionprops(L,'Centroid');
        Context(1).roi = N_Roi;
        save(Context(1).contextfile,'Context');
        refresh_list_rois(handles, get(handles.edt_classname,'String'),N_Roi(tam).roi_name);
    else
        errordlg('There is no class selected.','Extract');
    end
else
    errordlg('There is no class selected.','Extract');
end

% atualiza a lista de rois conforme a classe selecionada
% a roi atual pode ou n�o ser fornecida
function refresh_list_rois(handles, class_name, act_roi)
global Context
global Hrois % handles para as ROIs desenhadas sobre a imagem
global Cent
global CurrFigure
global Fig_Extract
if ~isempty(Cent)
    try
        delete(Cent(1,1));
    end
end
% apaga as rois
for i=1:size(Hrois,1);
    try
        delete(Hrois(i,:));
    end
end
load(Context(1).contextfile);
Class = Context(1).class;
if ~isempty(Class)
    if ~strcmp(class_name,'nothing')
        for i=1:size(Class,2)
            if strcmp(Class(i).name,class_name)
                color = Class(i).color;
                % preenche lista de rois
                R = Context(1).roi;
                list_names = '';
                if ~isempty(R)
                    cont = 0;
                    for j=1:size(R,2)
                        if strcmp(R(j).classname,class_name)
                            cont = cont+1;
                            list_names(cont,:) = R(j).roi_name;
                            % desenha a ROI
                            figure(CurrFigure(1,1))
                            Hrois(cont,1) = patch(R(j).polig_x,R(j).polig_y,...
                            color,'EdgeColor',color);
                            if nargin >2 % se foi fornecido a roi atual
                                if strcmp(R(j).roi_name,act_roi);
                                    indice = j; % indice da roi
                                    % desenha o s�mbolo sobre a roi atual
                                    s = R(j).centroid.Centroid;
                                    Cent(1,1) = rectangle('Position',[s(1,1)-10,...
                                        s(1,2)-10,20,20],'FaceColor','m','EdgeColor','m');
                                end
                            end
                            figure(Fig_Extract)
                        end
                    end
                    if ~isempty(list_names)
                        figure(Fig_Extract)
                        [sorted_names,sorted_index] = sortrows(list_names);
                        set(handles.list_rois,'String',sorted_names,'Value',1); % atualiza lista
                        % aponta para a roi fornecida, se for o caso
                        if nargin>2
                            % encontra o �ndice do nome da roi na lista de
                            % nomes da classe
                            roi_name = eliminate_spaces(act_roi);
                            for k=1:size(list_names,1)
                                if strcmp(eliminate_spaces(list_names(k,:)),roi_name)
                                    set(handles.list_rois,'Value',k);
                                    break
                                end
                            end
                        end
                    else
                        % valores default
                        set(handles.list_rois,'String','','Value',0);
                    end
                else
                    % valores default
                    set(handles.list_rois,'String','','Value',0);
                end
            end
        end
    else
        % valores defaut
        set(handles.list_rois,'String','','Value',0);
    end
else
    % valores defaut
    set(handles.list_rois,'String','','Value',0);
end



% a partir de um nome, extrai qualquer espa�o em banco que houver ap�s ele
function final_name = eliminate_spaces(full_name)
result = isspace(full_name); % 'abcd   ' = [0 0 0 0 1 1 1 ]
for i=1:size(full_name,2);
    if ~result(1,i)
        final_name(1,i) = full_name(1,i);
    else
        break
    end
end

%**************************************************************************
% abre um shape sobre o mapa
function open_shape(src,eventdata)
global CurrFigure
Geo_data = get(CurrFigure(1,1),'Userdata'); % carrega
if ~isempty(Geo_data(1).infoshape(1).Hshape(1).handles) 
    cont = size(Geo_data(1).infoshape(1).Hshape,2);
else
    Geo_data(1).infoshape(1).Hshape(1).name = ''; % s� pra confirmar
    Geo_data(1).infoshape(1).Hshape(1).handles = [];    
    cont = 0;
end
[file, path] = uigetfile('*.shp','Select a shape file');
shapes = shaperead(strcat(path, file));
h = mapshow(Geo_data(1).axesm,shapes, 'DisplayType',...
    shapes(1).Geometry,'FaceColor', 'none','EdgeColor','b');
Geo_data(1).infoshape(1).Hshape(cont+1).name = file;
Geo_data(1).infoshape(1).Hshape(cont+1).handles = h;
set(CurrFigure(1,1),'Userdata',Geo_data); % salva

%**************************************************************************     
% remove os shapes escolhidos de uma lista
function remove_shape(src,eventdata)
global CurrFigure
global GEO
CurrFigure(1,1) = gcf;
GEO = [];
GEO = get(CurrFigure(1,1),'Userdata'); % carrega
if ~isempty(GEO(1).infoshape)
    removeshape
end
figure(CurrFigure(1,1))
set(CurrFigure(1,1),'Userdata',GEO); % salva
clear(GEO);

% Retorna o n�mero total de padr�es a serem calculados
function total = total_patterns(handles,Imagem,Context)
% R = estrutura de ROIs no Context
% Imagem = a banda de origem dos dados
% Context = arquivo de contexto
load(Context(1).config); % carrega configura��o dos filtros Gabor
N = F(1).tam; % tamanho do filtro
R = Context(1).roi;
cont = 0;
for j=1:size(R,2) % percorre todas as rois
    roi_npoints = 0;
    % encontra os extremos da ROI
    L = bwlabel(R(j).BW);
    bbox = regionprops(L,'BoundingBox');
    ul_corner_xy = fix(bbox.BoundingBox(1,1:2));
    width_xy = fix(bbox.BoundingBox(1,3:4));
    for x=ul_corner_xy(1,1):ul_corner_xy+width_xy(1,1) % coluna, ATENCAO!!!
        for y=ul_corner_xy(1,2):ul_corner_xy(1,2)+width_xy(1,2) % linha
            if R(j).BW(y,x) % se neste ponto for 1, ou seja, se pertencer ao pol�gono
                roi_npoints = roi_npoints + 1;
                cont = cont + 1;
            end
        end
    end
end
save(Context(1).contextfile,'Context');
total = cont;

