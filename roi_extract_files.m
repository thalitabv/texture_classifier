function [] = roi_extract_files(Feature)

load(Feature(1).config); % carrega configuracao dos filtros Gabor
N = F(1).tam; % tamanho do filtro

load(Feature(1).contextfile); % carrega arquivo de contexto com informacoes das rois
Class = Context(1).class;
R = Context(1).roi; 

blck_size = 50;

cband = size(Feature,2); % conta as bandas selecionadas
% para cada banda...
for m=1:cband    
    
    % inicializa estruturas para receberem os atributos
    Node = [];
    Node(1).class = '';
    Node(1).roi = [];
    Node(1).label = 0; %rotulo da classe -- so e usado no classificador
    
    Roi = [];
    Roi(1).roiname = '';
    Roi(1).patterns = [];
    
    Node(1).roi = Roi;
    Feature(m).structure = Node;
    
    cont3 = 0;
    Banda = imread(Feature(m).band); % le a banda, sem georreferenciamento mesmo
    save(Feature(1).ffile,'Feature');
  
    for i=1:size(Class,2) % para cada classe
        % identificar as ROIs da classe e extrair atributos
        Roi = [];
        Roi(1).roiname = '';
        Roi(1).patterns = [];
        Node(i).class = Class(i).name;
        Node(i).roi = Roi;
        Node(i).label = i; % o label eh o contador das classes
        cont = 0;
        for j=1:size(R,2) % percorre todas as rois    
            if strcmp(R(j).classname,Class(i).name)
                cont = cont+1;                        
                Roi(cont).roiname = R(j).classname;
                % encontra os extremos da ROI
                L = bwlabel(R(j).BW);
                bbox = regionprops(L,'BoundingBox');
                ul_corner_xy = fix(bbox.BoundingBox(1,1:2));
                width_xy = fix(bbox.BoundingBox(1,3:4));
                n_blocos = ceil(width_xy(2)/blck_size)*ceil(width_xy(1)/blck_size);
                %Roi(cont).patterns = zeros(1,(F(1).ori*F(1).est*2)+2);
                cont2 = 0;
                for k=1:n_blocos(1)
                    cont3 = cont3+1;
                    blck_name = sprintf('roi_features%d.mat',cont3);               
                    current_folder = pwd;
                    cd('resultados/roi/');
                    try
                        load(blck_name);
                        Roi(cont).patterns(cont2+1:cont2+size(Block(m).patterns,1),:) = Block(m).patterns;
                        cont2 = cont2 + size(Block(m).patterns,1);
                    catch                        
                    end                    
                    cd(current_folder);            
                end               
            end
        end
        Node(i).roi = Roi;
        Feature(m).structure = Node;                                     
        
    end
end
save(Feature(1).ffile,'Feature');
msgbox('Finished!','Extract')
    

