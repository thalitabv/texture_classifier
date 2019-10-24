% funcao que preenche rapidamente os campos para teste
function quick_fill(handles)
global Context

set(handles.edit_lines,'String','10');
set(handles.edit_columns,'String','10');
set(handles.edit_epoch_order,'String','20');
set(handles.edit_epoch_conver,'String','100');
set(handles.edit_learn_order,'String','0.2');
set(handles.edit_learn_conver,'String','0.02');
set(handles.edit_sigma,'String','8');
set(handles.edit_conscience,'String','0');
set(handles.check_conscience,'Value',0);
