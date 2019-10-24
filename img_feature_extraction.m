% extrai os vetores de GABOR das rois
function [] = img_feature_extraction

load('confg.mat'); % carrega configuracao dos filtros Gabor
N = F(1).tam; % tamanho do filtro
borda = floor(N/2); % tamanho da borda a ser "ignorada" na classificao

current_folder = pwd;

cd('dados/img');
id_block = dlmread('id_block.dat',',');
cd(current_folder);

b = id_block(1);

for k=1:id_block(2)

    current_folder = pwd;
    cd('dados/img');
    blockfile = sprintf('block%d.mat',b);
    load(blockfile);
    if k==1
        cband = size(Block,2); % conta as bandas selecionadas
    end
    cd(current_folder);
    fpatterns = sprintf('img_features%d.mat',b)
    b = b + 1;
    for m=1:cband   % para cada banda        
        Block(m).patterns = zeros(1,(F(1).ori*F(1).est*2)+2);
        cont = 1;
        for i=borda+1:size(Block(m).img,1)-borda
            for j=borda+1:size(Block(m).img,2)-borda
                % obter uma secao da Imagem do tamanho do filtro e cujo centro
                % seja o ponto (x,y)
                sec = Block(m).img(i-floor(N/2):i+floor(N/2),j-floor(N/2):j+floor(N/2));
                Block(m).patterns(cont,1:2) = [(Block(m).pix(1)+i-borda-1) (Block(m).pix(2)+j-borda-1)]; % linha coluna (e os atributos...)
                Block(m).patterns(cont,3:end) = apply_Gabor(sec, N, F(1).est,F(1).ori); 
                cont = cont + 1;
            end
        end
    end
    cd('resultados/img');
    save(fpatterns,'Block');                                
    cd(current_folder);
    
end
    
     
% aplica os filtro de Gabor na imagem 'tile'
function vector = apply_Gabor(tile, siz, est,ori)
% siz eh o tamanho do filtro (o mesmo tamanho de 'tile')
% est: numero de estagios
% ori: numero de orientacoes
vector = zeros(1,(est*ori*2)); % inicializa vetor que receber� os atributos
cont = 1; % contador para posicionar os atributos
A = fftn(double(tile));% A recebe a transformada de Fourier da imagem estudada.

current_folder = pwd;
cd('filtros');
for n=1:ori,
    for i=1:est,
        filterName = sprintf('GW.r.%d.%d',i,n);
        fid = fopen(filterName,'r');% fid recebe identificador do arquivo aberto em modo de leitura
        G_r = fread(fid,[siz siz],'float');
        fclose(fid);
        
        filterName = sprintf('GW.i.%d.%d',i,n);
        fid = fopen(filterName,'r');
        G_i = fread(fid,[siz siz],'float');
        fclose(fid);
        
        G = G_r+i*G_i;% composi�ao do filtro unindo as partes real e imagin�ria
        % Dom�nio da freq��ncia
        
              
        B=abs((ifftn(double(A.*G))));% B recebe a magnitude (abs) da transformada inversa da 
        % aplicacao do filtro G
        % Dom�nio do espa�o
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %M = fftshift(B); % troca os quadrantes para a imagem ficar 'normal'
        %M = mat2gray(M); % passa a considerar como n�veis de cinza
        %[M,MAP] = gray2ind(M,256); % passa para imagem indexada
        %img_filtrada = sprintf('img/%s_%d_%d.bmp',arq,i,n);
        %imwrite(M,MAP,img_filtrada,'bmp');        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %B = mat2gray(fftshift(B)); % troca os quadrantes para a imagem ficar 'normal'
        % e passa para n�veis de cinza entre [0 1]
        vector(cont) = mean2(B);
        vector(cont+1) = std2(B);
        cont = cont + 2; % pr�xima posi��o a ser preenchida
    end
end
cd(current_folder);

