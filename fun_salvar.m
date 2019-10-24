function fun_salvar

[tamanho, freqt, orient, estag] = fun_pegadados;

hnd1 = findobj(gcbf,'Tag','EditText6');
nome = get(hnd1, 'String'); % pega o nome do arquvo
nomecompl = sprintf('confg/%s',nome);

F.tam = tamanho;
F.frq_inf = freqt(1);
F.frq_sup = freqt(2);
F.ori = orient;
F.est = estag;

save(nomecompl,'F');

