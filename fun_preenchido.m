% verifica se os dados foram preenchidos e habilita o botao 'Gera Filtros Gabor'
function fun_preenchido

hnd1 = findobj(gcbf,'Tag','EditText1');
tamanho = get(hnd1, 'string'); % pega o tamanho desejado para o filtro

hnd1 = findobj(gcbf,'Tag','EditText2');
freqi = get(hnd1, 'string');	% pega a freq��ncia inferior

hnd1 = findobj(gcbf,'Tag','EditText3');
freqs = get(hnd1, 'string');	% pega a freq��ncia supeior

hnd1 = findobj(gcbf,'Tag','EditText4');
orient = get(hnd1, 'string');	% pega o n�mero de orienta��es desejadas para o filtro

hnd1 = findobj(gcbf,'Tag','EditText5');
estag = get(hnd1, 'string');	% pega o n�mero de est�gios desejados para o filtro

if (~isempty(tamanho) & ~isempty(freqi) & ~isempty(freqs) & ~isempty(orient) & ~isempty(estag))
   botao1_hnd = findobj(gcbf,'String','Gerar Filtros Gabor');
   set(botao1_hnd,'Enable','on');
   
   botao1_hnd = findobj(gcbf,'String','Salvar Configura��o');
   set(botao1_hnd,'Enable','on');
   
   botao1_hnd = findobj(gcbf,'string','-->');
	set(botao1_hnd,'Enable','on');
end;
