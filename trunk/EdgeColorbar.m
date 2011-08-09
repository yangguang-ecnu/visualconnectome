%This function is used to toggle edge colorbar visibility.
function EdgeColorbar(Sw)
global gFigAxes;
if nargin==0,   Sw='on';    end
hFig=findobj('Tag','VisConFig');
hAxes=findobj(hFig,'Tag','VisConAxes');
hMenuEdgeCbar=findobj(hFig,'Tag','VisConMenuEdgeCbar');
hTbarEdgeCbar=findobj(hFig,'Tag','VisConTbarEdgeCbar');
if isempty(hFig)
    error('VisualConnectome is not running');
else
    set(0,'CurrentFigure',hFig);
end
if isempty(hAxes)
    error('You must first create or open a VCT file!');
end
if strcmpi(Sw,'on') || strcmpi(Sw,'show')
    %delete edge colorbar if it exists
    try     
        delete(gFigAxes.hEdgeCbar); 
    end
    %Create edge colorbar
    FigPos=get(hFig,'Position');
    height=FigPos(4)/2;             width=FigPos(4)/20;
    left=0.95*FigPos(3)-width-20;   bottom=FigPos(4)/4;
    gFigAxes.hEdgeCbar=colorbar('Units','pixel',...
        'Position',[left bottom width height],...
        'HitTest','off');
    title(gFigAxes.hEdgeCbar,'Edge Weight','color','w');
    VisCon_UpdateEdgeCbar();
    set(hMenuEdgeCbar,'Checked','on');
    set(hTbarEdgeCbar,'State','on');
elseif strcmpi(Sw,'off') || strcmpi(Sw,'hide')
    try
        delete(gFigAxes.hEdgeCbar);  
    end
    gFigAxes.hEdgeCbar=NaN;
    set(hMenuEdgeCbar,'Checked','off');
    set(hTbarEdgeCbar,'State','off');
else
    error('Wrong input argument!');
end
set(hFig,'CurrentAxes',hAxes);
end

