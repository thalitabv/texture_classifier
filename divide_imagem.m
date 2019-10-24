function [] = divide_imagem(imgfile,Feature)       
       load(Feature(1).config)
       borda = floor(F.tam/2);
       blck_size = 50; % criar uma textbox para o usuario definir o tamanho do bloco?
       patterns = zeros(1,(F(1).ori*F(1).est*2)+2);
       Block = []; 
       nbands = size(Feature,2);
       xy = [borda+1 borda+1];
       info = imfinfo(imgfile);
       width_xy = fix(info.Width)-2*borda;
       height_xy = fix(info.Height)-2*borda;       
       n_blocos(1) = ceil(height_xy/blck_size);
       n_blocos(2) = ceil(width_xy/blck_size);
       cont = 0;
       current_folder = pwd;
       cd('dados/img');
                      
       for i=1:n_blocos(1)
           for j=1:n_blocos(2)
               cont = cont+1;
               blck_name = sprintf('block%d.mat',cont);
                   Block.id = cont;
                   Block.pix = xy;
                   Block.img = Banda((xy(1) - borda):(xy(1) + blck_size-(~(n_blocos(1)-i)*(blck_size-mod(height_xy,blck_size))) + borda-1), (xy(2) - borda):(xy(2) + blck_size-(~(n_blocos(2)-j)*(blck_size-mod(width_xy,blck_size))) + borda-1));
               save(blck_name,'Block');
               xy(2) = xy(2) + blck_size;
           end
           xy(1) = xy(1) + blck_size;
           xy(2) = borda + 1;
       end
       
       cd(current_folder);
       