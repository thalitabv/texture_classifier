% pega os dados para montar os filtros
function [tamanho, freqt, orient, estag] = fun_pegadados

hnd1 = findobj(gcbf,'Tag','EditText1');
tamanho = str2num(get(hnd1, 'string')); % pega o tamanho desejado para o filtro

hnd1 = findobj(gcbf,'Tag','EditText2');
freqi = str2num(get(hnd1, 'string'));	% pega a freq��ncia inferior

hnd1 = findobj(gcbf,'Tag','EditText3');
freqs = str2num(get(hnd1, 'string'));	% pega a freq��ncia supeior

hnd1 = findobj(gcbf,'Tag','EditText4');
orient = str2num(get(hnd1, 'string'));	% pega o n�mero de orienta��es desejadas

hnd1 = findobj(gcbf,'Tag','EditText5');
estag = str2num(get(hnd1, 'string'));	% pega o n�mero de est�gios desejados

freqt = [freqi freqs];
