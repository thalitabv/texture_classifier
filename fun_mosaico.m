% criar um deck de imagens de filtros
function fun_mosaico

% pegar parametros
[tamanho, freqt, orient, estag] = fun_pegadados;

s = estag;
n = orient;

hnd = findobj(gcbf,'Tag','Checkbox1');
ck = get(hnd,'Value'); % 1 se assinalado e 0 caso contrário

hnd = findobj(gcbf,'Tag','EditText4');
ori = str2num(get(hnd,'String')); % 1 se assinalado e 0 caso contrário

hnd = findobj(gcbf,'Tag','EditText5');
est = str2num(get(hnd,'String')); % 1 se assinalado e 0 caso contrário



c = 0;
for i=1:est
   for j=1:ori
      c = c+1;
      % filtros da parte real
      matriz_filtroR = sprintf('filtros/R%d%d.mat',i,j);
      load(matriz_filtroR);
      if ck
         R(c).matriz = mat2gray(Gr);
      else
         R(c).matriz = Gr;
      end;
      X = cat(4,R.matriz);
         
      % filtros da parte imaginária
		matriz_filtroI = sprintf('filtros/I%d%d.mat',i,j);
      load(matriz_filtroI);
      if ck
         I(c).matriz = mat2gray(Gi);
      else
         I(c).matriz = Gi;
      end;
      Y = cat(4,I.matriz);
   end
end
figure;
montage(X);
title('Mosaic with the real part of Gabor Filters');
figure;
montage(Y);
title('Mosaico da parte imaginária dos FG');
