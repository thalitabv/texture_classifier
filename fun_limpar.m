% limpa os 'edits' e desabilita alguns botões.
function fun_limpar

hnd1 = findobj(gcbf,'Tag','EditText1');
set(hnd1, 'string',''); 

hnd1 = findobj(gcbf,'Tag','EditText2');
set(hnd1, 'string',''); 

hnd1 = findobj(gcbf,'Tag','EditText3');
set(hnd1, 'string',''); 

hnd1 = findobj(gcbf,'Tag','EditText4');
set(hnd1, 'string',''); 

hnd1 = findobj(gcbf,'Tag','EditText5');
set(hnd1, 'string',''); 

hnd1 = findobj(gcbf,'Tag','EditText6');
set(hnd1, 'string',''); 

hnd1 = findobj(gcbf,'Tag','EditText7');
set(hnd1, 'string',''); 

botao1_hnd = findobj(gcbf,'string','Gerar Filtros Gabor');
set(botao1_hnd,'Enable','off');

botao1_hnd = findobj(gcbf,'string','Mosaico de Filtros');
set(botao1_hnd,'Enable','off');

botao1_hnd = findobj(gcbf,'string','-->');
set(botao1_hnd,'Enable','off');

subplot(2,2,1),cla; % limpa os desenhos
subplot(2,2,2),cla;