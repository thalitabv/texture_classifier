% gerencia a cria��o dos filtros
function fun_faz_filtro

[tamanho, freqt, orient, estag] = fun_pegadados;
stage = estag;
orientation = orient;

cd filtros;
delete *.*;
cd ..;
hnd = findobj(gcbf,'String','-->');
atual = [1 1];
set(hnd,'UserData', atual);


N = tamanho; % tamanho da imagem

freq = freqt;% filtrar estas frequencias
 
for s = 1:stage,
    for n = 1:orientation,
       [Gr,Gi] = Gabor(N,[s n],freq,[stage orientation]);
       
        % salvar os filtros (dom�nio do espa�o) para o mosaico e perfis 3D
        matriz_filtroR = sprintf('filtros/R%d%d.mat',s,n);
        save(matriz_filtroR,'Gr');
        matriz_filtroI = sprintf('filtros/I%d%d.mat',s,n);
        save(matriz_filtroI,'Gi');
        %%%%
        
        % salvar os filtros (dom�nio da freq��ncia) para aplica��o nas imagens
        F = fft2(Gr+i*Gi);
        F(1,1) = 0; % bias, previsto no paper
        filterName = sprintf('filtros/GW.r.%d.%d',s,n);
        fid = fopen(filterName,'w'); % fid � um inteiro obtido com fopen
        fwrite(fid,real(F),'float'); % arquivo recebe parte real do filtro, em n�meros bin.
        fclose(fid);
        filterName = sprintf('filtros/GW.i.%d.%d',s,n);
        fid = fopen(filterName,'w'); 
        fwrite(fid,imag(F),'float'); % arquivo recebe parte imagin�ria do filtro
        fclose(fid);
    end;
end;
 
botao1_hnd = findobj(gcbf,'String','Gerar Filtros Gabor');
set(botao1_hnd,'Enable','off');

botao1_hnd = findobj(gcbf,'String','Mosaico de Filtros');
set(botao1_hnd,'Enable','on');

botao1_hnd = findobj(gcbf,'String','Salvar Configura��o');
set(botao1_hnd,'Enable','on');

botao1_hnd = findobj(gcbf,'string','-->');
set(botao1_hnd,'Enable','on');
