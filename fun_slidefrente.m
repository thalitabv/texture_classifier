% gerencia a apresentação dos filtros gerados
% cmaps = {'hsv';'hot';'gray';'prism';'cool';'winter';'summer'};
% tplot = {'mesh';'surf';'pcolor'};

function fun_slidefrente
[tamanho, freqt, orient, estag] = fun_pegadados;

inicio = [1 1];

hnd = findobj(gcbf,'String','-->');
atual= get(hnd,'UserData');
if isempty(atual)
   set(hnd,'UserData', inicio);
   atual= get(hnd,'UserData');
end;

m = atual(1); % estágio
n = atual(2); % orientação

if m <= estag
   if n <= orient
   	[m, n] = apresenta(m,n);   
   else
      m = m+1;
      n = 1;
      if m <= estag
         [m, n] = apresenta(m,n);
      else
         m = 1;
      end;
   end;
end;

atual = [m n];
set(hnd,'UserData',atual);


% apresenta os filtros gerados
function [m, n] = apresenta(a, b)

m = a; % estágio
n = b; % orientação


hnd = findobj(gcbf,'Tag','Listbox1');
valorc = get(hnd,'UserData'); % hsv, hot, gray, prism...
c = p_valor(valorc);

hnd = findobj(gcbf,'Tag','Listbox2');
valorp = get(hnd,'UserData'); % mesh, surf ou pcolor
p = pega_valor(valorp);

hnd = findobj(gcbf,'Tag','Checkbox1'); % utilizar níveis de cinza
valorg = get(hnd,'Value');

hnd = findobj(gcbf,'Tag','Checkbox2'); % visualizar a parte imaginária
valori = get(hnd,'Value');

if valori 
   filtro = sprintf('filtros/I%d%d.mat',m,n);
   texto = 'Imaginary Part';
   k = 'i';
else
   filtro = sprintf('filtros/R%d%d.mat',m,n);
   texto = 'Real Part';
   k = 'r';
end;

Im = load(filtro); % Im recebe Gr ou Gi

v = sprintf('Im.G%s',k); % v = 'Im.Gr' ou 'Im.Gi'
w = sprintf('%s(%s)',p,v); % w = 'mesh(Im.Gr ou Gi)' ou 'surf(Im.Gr...

subplot(2,2,2),eval(w),xlabel('line'),ylabel('column'),zlabel('amplitude');;
colormap(c);

if valorg
   we = sprintf('mat2gray(%s)',v);
   A = eval(we);
else
   A = eval(v);
end;

subplot(2,2,1),imshow(A),text(0,-11,texto),text(0,-6,'Stage:'),
text(30,-6,num2str(m)),text(0,-2,'Orientation:'),text(30,-2,num2str(n));
colormap(c);

n = n+1;




function p = pega_valor(g)

switch (g)
case 'mesh'
   p = 'mesh';
case 'surf'
   p = 'surf';
case 'pcolor'
   p = 'pcolor';
end;



function c = p_valor(g)

switch (g)
case 'hsv'
   c = 'hsv';
case 'hot'
   c = 'hot';
case 'gray'
   c = 'gray';
case 'prism'
   c = 'prism';
case 'cool'
   c = 'cool';
case 'winter'
   c = 'winter';
case 'summer'
   c = 'summer';
end;

