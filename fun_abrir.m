function fun_abrir

hnd1 = findobj(gcbf,'Tag','EditText7');
nome = get(hnd1, 'String'); % pega o nome do arquvo

cd confg;

try
   C.dado = load(nome);
   
   hnd1 = findobj(gcbf,'Tag','EditText1');
	set(hnd1,'String',num2str(C.dado.F.tam)); % copia o tamanho do filtro

	hnd1 = findobj(gcbf,'Tag','EditText2');
   set(hnd1,'String',num2str(C.dado.F.frq_inf)); 
   
	hnd1 = findobj(gcbf,'Tag','EditText3');
	set(hnd1,'String',num2str(C.dado.F.frq_sup));

	hnd1 = findobj(gcbf,'Tag','EditText4');
	set(hnd1,'String',num2str(C.dado.F.ori));

	hnd1 = findobj(gcbf,'Tag','EditText5');
	set(hnd1,'String',num2str(C.dado.F.est));
end;

cd ..;

botao1_hnd = findobj(gcbf,'string','Gerar Filtros Gabor');
set(botao1_hnd,'Enable','on');
