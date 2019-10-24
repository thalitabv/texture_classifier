% dispara as acoes do sistema de geração de Filtros Gabor
function visualfun (acao)

switch (acao)
case 'gerar_filtro'
   fun_faz_filtro;
case 'preenchido'
   fun_preenchido;
case 'mosaico'
   fun_mosaico;
case 'limpar'
   fun_limpar;
case 'parafrente'
   fun_slidefrente;   
case 'salvar'
   fun_salvar;   
case 'abrir'
   fun_abrir;
end;


