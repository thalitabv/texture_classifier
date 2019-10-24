function fig = visualfg()
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
% This problem is solved by saving the output as a FIG-file.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.
% 
% NOTE: certain newer features in MATLAB may not have been saved in this
% M-file due to limitations of this format, which has been superseded by
% FIG-files.  Figures which have been annotated using the plot editor tools
% are incompatible with the M-file/MAT-file format, and should be saved as
% FIG-files.

load visualfg

h0 = figure('Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'CreateFcn','clf;', ...
	'FileName','C:\work\visualfg.m', ...
	'Name','Gerador de Bancos de Filtros Gabor', ...
	'NumberTitle','off', ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[106 95 800 534], ...
	'Renderer','zbuffer', ...
	'RendererMode','manual', ...
	'Tag','Fig1', ...
	'ToolBar','none');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','visualfun preenchido', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[95.25 132 45 15], ...
	'Style','edit', ...
	'Tag','EditText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[46.5 129 45 15], ...
	'String','Tamanho:', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[33 102 58.5 15], ...
	'String','Freq. Inferior:', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[33 75 58.5 15], ...
	'String','Freq. Superior:', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[33 48.75 58.5 15], ...
	'String','Orientações:', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','visualfun preenchido', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[95.25 102.75 45 15], ...
	'Style','edit', ...
	'Tag','EditText2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','visualfun preenchido', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[96 75 45 15], ...
	'Style','edit', ...
	'Tag','EditText3');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','visualfun preenchido', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[96 48.75 45 15], ...
	'Style','edit', ...
	'Tag','EditText4');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','visualfun gerar_filtro', ...
	'Enable','off', ...
	'ListboxTop',0, ...
	'Position',[162 132 89.25 15], ...
	'String','Gerar Filtros Gabor', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback',mat1, ...
	'ListboxTop',0, ...
	'Position',[369.75 33 89.25 15], ...
	'String','Abrir Configuração', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback',mat2, ...
	'ListboxTop',0, ...
	'Position',[483 75 89.25 15], ...
	'String','Salvar Configuração', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','visualfun mosaico', ...
	'Enable','off', ...
	'ListboxTop',0, ...
	'Position',[162 103.5 89.25 15], ...
	'String','Mosaico de Filtros', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','visualfun preenchido', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[95.25 21.75 45 15], ...
	'Style','edit', ...
	'Tag','EditText5');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[33 21.75 58.5 15], ...
	'String','Estágios:', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','visualfun limpar', ...
	'ListboxTop',0, ...
	'Position',[162 75 89.25 15], ...
	'String','Limpar', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback','visualfun parafrente', ...
	'Enable','off', ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[369 117.75 87.75 28.5], ...
	'String','-->', ...
	'Tag','frente', ...
	'UserData',[4 6]);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback',mat3, ...
	'ListboxTop',4, ...
	'Position',[271.5 46.5 54 43.5], ...
	'String',mat4, ...
	'Style','listbox', ...
	'Tag','Listbox1', ...
	'UserData','gray', ...
	'Value',3);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback',mat5, ...
	'Position',[272.25 7.5 54 29.25], ...
	'String',mat6, ...
	'Style','listbox', ...
	'Tag','Listbox2', ...
	'TooltipString','mesh', ...
	'UserData','mesh', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[264.75 132 75 15], ...
	'String','Níveis de cinza', ...
	'Style','checkbox', ...
	'Tag','Checkbox1', ...
	'UserData','G');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[263.25 103.5 75.75 15], ...
	'String','Parte Imaginária', ...
	'Style','checkbox', ...
	'Tag','Checkbox2');
h1 = axes('Parent',h0, ...
	'View',[-37.5 30], ...
	'CameraUpVector',[0 0 1], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'ColorOrder',mat7, ...
	'Position',[0.5779768786127169 0.5810982658959537 0.3270231213872832 0.3439017341040462], ...
	'Tag','Axes2', ...
	'XColor',[0 0 0], ...
	'XGrid','on', ...
	'YColor',[0 0 0], ...
	'YGrid','on', ...
	'ZColor',[0 0 0], ...
	'ZGrid','on');
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'Position',[-4.125220861324066 -5.946874550092502 4.084815995894516], ...
	'String','line', ...
	'Tag','Axes2Text4', ...
	'VerticalAlignment','top');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Position',[-4.641622849437288 -5.534434674317303 4.107064086134148], ...
	'String','column', ...
	'Tag','Axes2Text3', ...
	'VerticalAlignment','top');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-4.746550505921801 -4.903437267613618 4.86349915428164], ...
	'Rotation',90, ...
	'String','amplitude', ...
	'Tag','Axes2Text2', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-3.811101299161736 -5.113924288812884 5.560605981790113], ...
	'Tag','Axes2Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'Box','on', ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'CLimMode','manual', ...
	'Color',[1 1 1], ...
	'ColorOrder',mat8, ...
	'DataAspectRatioMode','manual', ...
	'Layer','top', ...
	'Position',[0.13 0.5810982658959537 0.3270231213872832 0.3439017341040462], ...
	'Tag','Axes1', ...
	'TickDir','out', ...
	'TickDirMode','manual', ...
	'Visible','off', ...
	'WarpToFill','off', ...
	'WarpToFillMode','manual', ...
	'XColor',[0 0 0], ...
	'XLim',[0.5 64.5], ...
	'XLimMode','manual', ...
	'YColor',[0 0 0], ...
	'YDir','reverse', ...
	'YLim',[0.5 64.5], ...
	'YLimMode','manual', ...
	'ZColor',[0 0 0]);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[32.67486338797815 66.94808743169399 453.0759604751449], ...
	'Tag','Axes1Text9', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[32.67486338797815 -2.647540983606561 453.0759604751449], ...
	'Tag','Axes1Text8', ...
	'VerticalAlignment','cap', ...
	'Visible','off');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[67.64754098360658 31.97540983606557 453.0759604751449], ...
	'Rotation',90, ...
	'Tag','Axes1Text7', ...
	'VerticalAlignment','baseline', ...
	'Visible','off');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'Position',mat9, ...
	'Tag','Axes1Text1', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback',mat10, ...
	'ListboxTop',0, ...
	'Position',[481.5 33 89.25 15], ...
	'String','Sair', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[484.5 104.25 87 15], ...
	'Style','edit', ...
	'Tag','EditText6');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[484.5 120 87.75 15], ...
	'String','Nome do arquivo:', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[369.75 73.5 87.75 15], ...
	'String','Nome do arquivo:', ...
	'Style','text', ...
	'Tag','StaticText10');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[369.75 57.75 87 15], ...
	'Style','edit', ...
	'Tag','EditText7');
if nargout > 0, fig = h0; end
