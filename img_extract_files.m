function [] = img_extract_files(n_blocos,Feature_img)

global Imagem

load(Feature_img(1).contextfile)
cband = size(Feature,2);
load(Feature(1).config)
load(Feature(1).contextfile)
borda=floor((F(1).tam)/2);
clear Feature
current_folder = pwd;
cd('resultados/img');
load(Feature_img(1).som);
IBands = A.ibands;
W = A.pesos;
Grade = A.grade;
clear A;

Imagem = [];
% para cada banda...
for i=1:n_blocos
    i
    blck_name = sprintf('img_features%d.mat',i);    
    M.fname = sprintf('img_classes%d.mat',i);
    load(blck_name);
    load(M.fname);
    P = atribcat2(Block,IBands);
    M.classes = execute_som(W,Grade,P);
    save(M.fname,'M');
    execute_som(W,Grade,P);
    clear Block
end

paint_image(Context,Feature_img,Imagem);

cd(current_folder)

%*****************************************************************
%function classe = execute_som(W,Grade,P)
function [] = execute_som(W,Grade,P)
global Imagem
tot = size(P,1);
[lin,col,z] = size(W);
for i=1:tot % percorre todos os elementos do arquivo de teste
    WN = winner_neuron(P(i,3:end),lin,col,W); % calcula neur�nio vencedor
    xy = P(i,1:2);
    %classe(xy(1),xy(2)) = Grade(WN(1),WN(2));
    Imagem(xy(1),xy(2)) = Grade(WN(1),WN(2));
end

%**************************************************************************
%function paint_image(Context,Feature_img,img,c)
function paint_image(Context,Feature_img,img)

map = [0 0 0];
for i=2:size(Context(1).class,2)+1
    map(i,:)=Context(1).class(i-1).color;
end
%img = zeros(size(img));
for i=1:size(img,1)
    for j=1:size(img,2)
        %img(i,j) = c(i,j)+1;
        img(i,j) = img(i,j)+1;
    end
end

colormap(map);
imwrite(img,map,Feature_img.classified_img,'tif')
%open_image(Feature_img.classified_img)
   
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

% Open the image
function open_image(full_path)
global CurrFigure
global FigHandles


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


%**************************************************************************
% concatena atributos das bandas selecionadas
function P = atribcat2(Feature, IBands)
nbands = size(IBands,2);
cont = 0;
atrib = [];
P = Feature(1).patterns(:,1:2);   
for n=1:size(IBands,2)
    atrib = cat(2,atrib,Feature(IBands(n)).patterns(:,3:end));
end
P = cat(2,P,atrib);


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
