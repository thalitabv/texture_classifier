% treinamento de SOM com atributos de textura de Gabor
% atualizado em 08/05/2006
function varargout = kohonenfg(varargin)
%KOHONENFG M-file for kohonenfg.fig
%      KOHONENFG, by itself, creates a new KOHONENFG or raises the existing
%      singleton*.
%
%      H = KOHONENFG returns the handle to a new KOHONENFG or the handle to
%      the existing singleton*.
%
%      KOHONENFG('Property','Value',...) creates a new KOHONENFG using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to kohonenfg_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      KOHONENFG('CALLBACK') and KOHONENFG('CALLBACK',hObject,...) call the
%      local function named CALLBACK in KOHONENFG.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help kohonenfg

% Last Modified by GUIDE v2.5 11-May-2006 08:13:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kohonenfg_OpeningFcn, ...
                   'gui_OutputFcn',  @kohonenfg_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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
% --- Executes just before kohonenfg is made visible.
function kohonenfg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
global Context
global Feature
global Aux
global Grade_hist
global som_partname % armazena o nome do arquivo de configura��o da rede
global som_fullname
Aux = [];
Aux.pesos = [];
Aux.grade = [];

%*****************
quick_fill(handles) % fun�ao que preenche rapidamente os campos para testar as rotinas
%*****************

% Choose default command line output for kohonenfg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes kohonenfg wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%**************************************************************************
% --- Outputs from this function are returned to the command line.
function varargout = kohonenfg_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%**************************************************************************
% --- Executes on button press in push_browse_feature.
function push_browse_context_Callback(hObject, eventdata, handles)
    global Context
    global Feature
    global Lista % receber� as bandas selecionadas para treinamento
    global IBands % recebe o �ndice das bandas selecionadas na estrutura Feature
    Lista = cell(1,1);
    Lista{1,1} = 'teste';
    set(handles.list_selbands,'String',Lista);
    IBands = [];
    [file, path] = uigetfile('*.mat','Select a Features File');
    if ~ (isequal(file,0) | isequal(path,0))
        if length(fullfile(path,file))>70
            set(handles.text_filename,'String',strcat(path(1:20),' ... \',file));
        else
            set(handles.text_filename,'String',fullfile(path,file));
        end
        load(fullfile(path,file));
        load(Feature(1).contextfile)
               
        % pede para o usuario selecionar as bandas
        selbands
        waitfor(gcf)
        % calcula classes e amostras
        set(handles.list_selbands,'String',Lista);
        [tclasses, tsamples] = extract_cl_samples(Feature);
        set(handles.text_c_number,'String',num2str(tclasses))
        set(handles.text_t_samples,'String',num2str(tsamples))
    end

    
%**************************************************************************
% --- Executes during object creation, after setting all properties.
function edit_lines_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%**************************************************************************
% --- Executes during object creation, after setting all properties.
function edit_columns_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%**************************************************************************
% --- Executes during object creation, after setting all properties.
function edit_epoch_order_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%**************************************************************************
% --- Executes during object creation, after setting all properties.
function edit_epoch_conver_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%**************************************************************************
% --- Executes during object creation, after setting all properties.
function edit_learn_order_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%**************************************************************************
% --- Executes during object creation, after setting all properties.
function edit_learn_conver_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_learn_conver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%**************************************************************************
% --- Executes during object creation, after setting all properties.
function edit_sigma_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%**************************************************************************
% --- Executes on button press in push_browse_som.
function push_browse_som_Callback(hObject, eventdata, handles)
global Context
global Feature
global som_partname
global som_fullname

    [file,path] = uiputfile('som.mat','New Context File');
    if ~ (isequal(file,0) | isequal(path,0))
        
         % Modificado em 18/10/2005
        full_name = fullfile(path,file);
        
        if length(fullfile(path,file))>70
            set(handles.text_filesom,'String',strcat(path(1:20),' ... \',file));
        else
            set(handles.text_filesom,'String',fullfile(path,file));
        end
                
        som_partname = file;
        som_fullname = full_name;

    end
    
%**************************************************************************
% --- Executes on button press in check_conscience.
function check_conscience_Callback(hObject, eventdata, handles)
    if get(hObject,'Value')
        set(handles.edit_conscience,'Visible','on')
        set(handles.text_bias,'Visible','on')
    else
        set(handles.edit_conscience,'Visible','off')
        set(handles.text_bias,'Visible','off')
    end

%**************************************************************************
% --- Executes during object creation, after setting all properties.
function edit_conscience_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%**************************************************************************
% --- Executes on button press in push_training.
function push_training_Callback(hObject, eventdata, handles)
global Feature
global Context
global som_partname
global som_fullname
global Grade
global IBands % indice das bandas selecionadas na estrutura Feature

tic

% Modificado em 10/11/2005 --- Salva o nome do arquivo de
% configuracao da rede no arquivo de contexto
cont = 0;
for i=1:size(Feature(1).netfiles,2)
    if size(Feature(1).netfiles(i).fullname) == size(som_fullname)
        if Feature(1).netfiles(i).fullname == som_fullname
            cont = cont+1;
        end
    end
end
if ~cont     
    %armazena os nomes das redes treinadas com o arquivo de contexto
    %selecionado
    Netfiles = Feature(1).netfiles;
    if size(Feature(1).netfiles,2)==1 % primeira rede a ser treinada com este arquivo de atributos
        Netfiles(1).name = som_partname;
        Netfiles(1).fullname = som_fullname;
    else
        Netfiles(size(Feature(1).netfiles,2)+1).name = som_partname;
        Netfiles(size(Feature(1).netfiles,2)+1).fullname = som_fullname;
    end
    Feature(1).netfiles = Netfiles;
    save(Feature(1).ffile,'Feature');
end

el = str2num(get(handles.edit_lines,'String'));
ec = str2num(get(handles.edit_columns,'String'));
ep1 = str2num(get(handles.edit_epoch_order,'String'));
ep2 = str2num(get(handles.edit_epoch_conver,'String'));
txapr1 = str2num(get(handles.edit_learn_order,'String'));
txapr2 = str2num(get(handles.edit_learn_conver,'String'));
vizi1 = str2num(get(handles.edit_sigma,'String'));
if get(handles.check_conscience,'Value')
    C = str2num(get(handles.edit_conscience,'String')); % constante de consci�ncia, 0 < C < 100
else
    C = 0;
end

% o indice da classe na estrutura eh o rotulo de classe da amostra
for i=1:size(Feature(1).structure,2)
    Feature(1).structure(i).label = i;
end
save(Feature(1).ffile,'Feature');

% monta a matriz de amostras com o primeiro elemento indicando a classe, o 
% seg e terceiro as coordenadas e os demais os atributos
% concatena atributos das bandas selecionadas - 08/05/2006 
P = atribcat2(Feature, IBands);
S = P(:,4:end); % S tem somente os atributos de textura, sem info de classe 

b = size(S,2); % 'b' � o n�mero de atributos de textura (somente) de cada linha da matriz de padr�es
W=(rand(el,ec,b)*.2)-.1; %gera matriz de pesos,tridimensional,de 'b' planos,diminuindo os 
% valores em 80% e depois em 0.1
fig1 = gcf;
pj = 0; % para o caso de n�o se utilizar consci�ncia
jole = 0;
if get(handles.check_conscience,'Value')
	pj = zeros(el,ec); % matriz de fra��o de vezes (fraction of time)
    B = 0.0001;
    H = figure('Name','Ordering Phase Kappa','NumberTitle','off'); % passar H para a fase seguinte!
    [W_out1,WN1,pj1,p1,jole] = som_2d(handles,P,el,ec,ep1,[txapr1 vizi1],W,pj,[C,B],S,H,fig1);
    if jole
       save_data(handles,W_out1,W,WN1,Grade,el,ec,ep1,ep2,txapr1,txapr2,vizi1,C);
    else
	   H = figure('Name','Convergence Phase Kappa','NumberTitle','off');
       [W_out2,WN2,pj2] = som_2d(handles,P,el,ec,ep2,[p1(1) txapr2 p1(2) 0],W_out1,pj1,[C,B],S,H,fig1);
       save_data(handles,W_out2,W,WN2,Grade,el,ec,ep1,ep2,txapr1,txapr2,vizi1,C);
    end
else
   H = figure('Name','Ordering Phase Kappa','NumberTitle','off');
   [W_out1,WN1,pj1,p1,jole] = som_2d(handles,P,el,ec,ep1,[txapr1 vizi1],W,pj,[],S,H, fig1);
   if jole
      save_data(handles,W_out1,W,WN1,Grade,el,ec,ep1,ep2,txapr1,txapr2,vizi1,0);
	else      
      H = figure('Name','Convergence Phase Kappa','NumberTitle','off');
      [W_out2,WN2,pj2] = som_2d(handles,P,el,ec,ep2,[p1(1) txapr2 p1(2) 0],W_out1,pj1,[],S,H, fig1);
      save_data(handles,W_out2,W,WN2,Grade,el,ec,ep1,ep2,txapr1,txapr2,vizi1,0);
   end
end

toc

%**************************************************************************
% --- Executes on button press in push_trpkg.
function push_trpkg_Callback(hObject, eventdata, handles)
% hObject    handle to push_trpkg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%**************************************************************************
% --- Executes on button press in push_clean.
function push_clean_Callback(hObject, eventdata, handles)
% hObject    handle to push_clean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text_filename,'String','')
set(handles.text_c_number,'String','')
set(handles.text_t_samples,'String','')
set(handles.edit_lines,'String','')
set(handles.edit_columns,'String','')
set(handles.edit_epoch_order,'String','')
set(handles.edit_epoch_conver,'String','')
set(handles.edit_lean_order,'String','')
set(handles.edit_lean_conver,'String','')
set(handles.edit_sigma,'String','')
set(handles.check_conscience,'Value',0)

%**************************************************************************
% --- Executes on button press in push_exit.
function push_exit_Callback(hObject, eventdata, handles)
% hObject    handle to push_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    shh = get(0,'ShowHiddenHandles');
    set(0,'ShowHiddenHandles','on');
    currFig = get(0,'CurrentFigure');
    set(0,'ShowHiddenHandles',shh);
    delete(currFig);

%**************************************************************************
% --- Salva os dados de configuracao da rede, seus pesos inicial e final.
% modificado para armazenar �ndice e nome das bandas selecionadas para
% treinamento - 09/05/2006
function save_data(handles,W_fim,W_ini,WN,Grade,el,ec,ep1,ep2,txapr1,txapr2,vizi1,C)
global Feature
global som_fullname
global Aux
global IBands

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Recupera os dados da rede correspondentes à época que apresentou maior kappa %%%
k_values=[];
for i=1:size(Aux,2)
    k_values(i)=Aux(i).kappa;
end 
[m,im] = max(k_values);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A.context = Feature(1).ffile;

A.el = el;
A.ec = ec;
A.ep1 = ep1;
A.ep2 = ep2;
A.txapr1 = txapr1;
A.txapr2 = txapr2;
A.vizi1 = vizi1;
A.cons = C;
A.pesos = Aux(im).pesos;
A.ini = W_ini;
A.venc = Aux(im).winner;
A.grade = Aux(im).grade;
A.me = Aux(im).me;
A.ibands = IBands; % indice das bandas selecionadas na estrutura Feature
A.bands = get(handles.list_selbands,'String');
save(som_fullname,'A');

%**************************************************************************
% --- Manipula�ao da rede neural (treinamento dos neuronios)
function [W_out,WN_out,pj_out,p_out,jole]= som_2d(handles,P, nsofmx, nsofmy, epochs, phas, W_in,pj,consc,S,H,fig1)
global Context

%%%%% para o teste kappa ser feito com outro arquivo de atributos
%St = load('textura_60');
%%%%%

alfa = 0;
if length(consc)>1 % utilizar recursos de consci�ncia
    zero_aux = zeros(nsofmx,nsofmy); % ajuda para atualiza��o do pj
    um_aux = ones(nsofmx,nsofmy)./(nsofmx*nsofmy); % ajuda para atualiza��o do bj
	C = consc(1);
    B = consc(2);
    alfa = 1;
end;

r=nsofmx;  c=nsofmy; cr=r+1; cc=c+1; % r e c = 10; cr e cc = 11
[pats dimz]=size(S); % pats= numero de padr�es (linhas)
n = 1:epochs;

if length(phas) == 2,	% phas(1), tx aprendizagem 1; phas(2), vizinhan�a 1
    so = phas(2);				
    t1 = epochs/(log(so+1)); 
    sigmas = so*exp(-n/t1);	
    lrs    = phas(1)*exp(-n/epochs); 
    set(handles.text_phase,'String','Ordering');
else % phas(1), tx apr. fase anterior; phas(2), tx apr. 2; phas(3), vizi. fase anterior
	sigmas = (phas(3)-phas(4))*fliplr(n)/epochs+phas(4);
	lrs    = (phas(1)-phas(2))*fliplr(n)/epochs+phas(2);
    set(handles.text_phase,'String','Convergence');
end
drawnow
mask=zeros(2*r+1,2*c+1); 
x=[-c:c];   y=[r:-1:-r]; 
for i=1:length(x), for j=1:length(y), 
      mask(j,i)=sqrt(x(i)^2+y(j)^2);
   end
end

[tlin tcol] = size(S);

jole = 0;
for epoch=1:epochs
    [neword]=atr_shuffle(S);
    sigma=sigmas(epoch);
    figure(fig1)
    set(handles.text_percentage,'String',strcat(num2str(floor(epoch*100/epochs)),' %'));
    drawnow
    for pat=1:pats  
        in=neword(pat,:)';
        Dup=in(:,ones(r,1),ones(c,1));
        Dup=permute(Dup,[2,3,1]);
        Dif= W_in - Dup;
        Sse=sqrt(sum(Dif.^2,3));
        [val1 win_rows]=min(Sse);
        [val2 wc]=min(val1); 
        wr=win_rows(wc); 
        if alfa % utilizar recursos de consci�ncia
            pj_velho = pj(wr,wc);
            pj = pj + (zero_aux-pj).*B; % atualiza pj como se nenhum vencesse
            pj(wr,wc) = pj_velho + B*(1-pj_velho); % atualiza s� o pj do vencedor
                % agora pj inteiro est� correto
            bj = (um_aux-pj).*C; % c�lculo do bj
             Sse_cons = Sse-bj;
             % calcula os novos neur�nios vencerores, se for o caso
            [val1 win_rows]=min(Sse_cons);
            [val2 wc]=min(val1); 
            wr=win_rows(wc);
        end
        WN(pat,1:2)=[wr wc]; % neur�nios vencedores com fator consci�ncia ou n�o
        M1 = mask(cr-wr+1:cr+(r-wr),cc-wc+1:cc+(c-wc));
        M1 = (1/(2*pi*sigma^2)*exp((-M1.^2/(2*sigma^2)))); 
        M1 = M1/max(max(M1)); 
        M1=M1(:,:,ones(1,dimz));
        W_in = W_in + lrs(epoch)*(Dup-W_in).*M1;                   
    end
    if mod(epoch,2)==0 % a cada x �pocas, calcula Kappa e armazena
        %***** alterar P caso a fonte de atributos de teste seja outra!!!
        Grade = contextual(P,W_in);
        Me = error_matrix(handles,P,Grade,W_in);
        K = find_kap(Me);
        figure(H);
        plot(epoch,K,'o');
        hold on;
        figure(fig1);
        save_kappa(handles,K,epoch,Grade,W_in,WN,Me);
        % para encerrar quando Kappa atingir 1
        if K ==1
            jole = 1;
            break
        end
    end
end


p_out = [lrs(length(lrs)) sigma]; % devolve a �ltima tx aprendizagem e o �ltimo sigma
WN_out = WN;
W_out = W_in;
pj_out = pj;


%**************************************************************************
% --- Embaralha a sequencia de atributos
function [o1,o2,o3,o4,o5] = atr_shuffle(n1,n2,n3,n4,n5)
%   (embaralha as linhas das matrizes mantendo a mesma ordem entre elas)
%	 (pode receber at� 5 matrizes para embaralhar)
% n1 � P, matriz de padr�es
[r c]=size(n1); % r = 500, c = 2
[y,idx] = sort(rand(1,r));
% sort classifica o vetor de numeros aleatorios gerados por rand(1,500)
% y recebe o vetor ordenado, idx recebe o indice dos elementos apos a classificacao.
% isto serve apenas para gerar um �ndice aleat�rio de linhas para embaralhar o vetor P.
for i=1:nargin;
   eval(['o' num2str(i) '=n' num2str(i) '(idx,:);']); % eval executa a string dentro dos().
   %     o1= n1(idx,:);
end
% o vetor n1, ou P, tem suas linhas ordenadas tal como o �ndice idx, obtido
% aleatoriamente.

%**************************************************************************
% --- Gera um Mapa Contextual de n�meros de classe
function Grade_out = contextual(P,W)
% gera o mapa contextual da grade de neur�nios para testar a classifica��o 
% durante o treinamento do SOM
% lembrar que P cont�m informa��o de classe no primeiro elemento de cada linha
[lin,col,z] = size(W);
Grade = ones(lin,col); % Mapa Contextual a ser formado
[tot tam_vetor] = size(P);
wz = zeros(1,(tam_vetor-3)); % menos 3 porque 1= classe, 2 e 3 = coordenadas
for i=1:lin % para cada linha da Grade
   for j=1:col % para cada coluna da Grade
      wz(1,:) = W(i,j,:);
      for m=1:tot % submete todos os padroes e encontra o mais proximo
         dif = wz-P(m,4:end);
         Eucli = sqrt(sum(dif.^2)); % calcul distancia Euclidiana
         res(m,1) = [Eucli]; % matriz coluna com as dist�ncias entre o peso e os padr�es
      end;
      [Y,I] = min(res); % Y = menor dist�ncia; I = �ndice do atributo mais pr�ximo
      
      Grade(i,j) = P(I,1); % rotula o elemento da grade com o numero da classe
      res = 0;
      wz = zeros(1,(tam_vetor-3));
   end;
end;
Grade_out = Grade;

%**************************************************************************
% --- Gera a matriz de erro para o c�lculo do Kappa
function Me = error_matrix(handles,P,Grade,W)
% Recebe estrutura de atributos de teste com id de classe, grade 
% (mapa contextual) e pesos
global Feature
set(handles.text_phase,'String','Kappa')
tot_cla = size(Feature(1,1).structure,2);
tot = size(P,1);
set(handles.text_percentage,'String','0 %')
drawnow
[lin,col,z] = size(W);
Me = zeros(tot_cla,tot_cla); % matriz de erros para c�lculo de Kappa
for i=1:tot % percorre todos os elementos do arquivo de teste
    WN = winner_neuron(P(i,4:end),lin,col,W); % calcula neur�nio vencedor
    set(handles.text_percentage,'String',strcat(num2str(floor(i*100/tot)),' %'))
    drawnow
    % S(i,1): id da classe na primenira coluna da linha "atributo"
    Me(P(i,1),Grade(WN(1),WN(2))) = Me(P(i,1),Grade(WN(1),WN(2)))+1;
end;
   
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

%**************************************************************************
% --- Calcula o coeficiente Kappa da matriz de erros
function K = find_kap(Me)
col = sum(Me); % somat�rio das colunas (vetor linha)
lin = sum(Me,2); % somat�rio das linhas (vetor coluna)
term2 = trace(lin*col); % corresponde ao somat�rio (somat�rio de cada linha x som. cada col.)

tot_am = sum(sum(Me)); % total de amostras: soma de todos os elementos
traco = trace(Me); % somat�rio da diagonal principal

% Modificado em 19/10/2005
if tot_am == traco
    K = 1;
else
    K = (tot_am*traco - term2)/(tot_am^2-term2);
end

%**************************************************************************
% --- Salva o coeficiente Kappa em arquivo com o mesmo nome do som, mas com
% terminacao '_kap'
function save_kappa(handles,K,epoch,Grade,W,WN,Me)
global som_fullname
global Context
global Aux

name = som_fullname;
occur = findstr(name,'\');
kap_name = name(1,occur(1,end)+1:length(name)-4); % s� pega o nome do arquivo, sem '.mat'
path = name(1,1:occur(1,end)); 
s_kappa = strcat(path,kap_name,'_kap');
try
   load(s_kappa); % se j� existir o arquivo
   fg = 1;
catch
   fg = 0;
end;
if fg
   [a tot] = size(Z);
else
   tot = 0;
end;
Z(tot+1).kappa = K;
Z(tot+1).epoca = epoch;
Aux(tot+1).kappa = K;
Aux(tot+1).epoca = epoch;
Aux(tot+1).pesos = W;
Aux(tot+1).grade = Grade;
Aux(tot+1).winner = WN;
Aux(tot+1).me = Me;
save(s_kappa,'Z');


% --- Executes on selection change in list_selbands.
function list_selbands_Callback(hObject, eventdata, handles)
% hObject    handle to list_selbands (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns list_selbands contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_selbands


% --- Executes during object creation, after setting all properties.
function list_selbands_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_selbands (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%**************************************************************************
% concatena atributos das bandas selecionadas
function P = atribcat2(Feature, IBands)
nbands = size(IBands,2);
P = zeros(1,nbands*(size(Feature(1).structure(1).roi(1).patterns,2)-2)+3);
cont = 0;
for i=1:size(Feature(1).structure,2) % para cada classe  
    cont = cont+1; % rotulo da classe
    for j=1:size(Feature(1).structure(i).roi,2) % para cada roi da classe
        atrib = [];
        aux = Feature(1).structure(i).roi(j).patterns(:,1:2);        
        for n=1:size(IBands,2)
            atrib = cat(2,atrib,Feature(IBands(n)).structure(i).roi(j).patterns(:,3:end));
        end
        aux = cat(2,aux,atrib);
        tot_patterns = size(aux,1);
        tot_P = size(P,1);
        if i==1 % primeira vez
            P(1:tot_patterns,1) = cont;
            P(1:tot_patterns,2:end) = aux;
        else
            P(tot_P+1:(tot_P+tot_patterns),1) = cont;
            P(tot_P+1:end,2:end) = aux;
        end
    end
end
