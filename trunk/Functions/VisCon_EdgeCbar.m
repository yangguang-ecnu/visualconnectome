%VISCON_EDGECOLORBAR Summary of this function goes here
%   Detailed explanation goes here
function VisCon_EdgeCbar(Sw)
global gFigAxes;
global gNetwork;
if nargin==0,   Sw='on';    end
hFig=findobj('Tag','VisConFig');
hAxes=findobj(hFig,'Tag','VisConAxes');
if strcmpi(Sw,'on')
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
    caxis(hAxes,gNetwork.EdgeRange);
    title(gFigAxes.hEdgeCbar,'Edge Weight','color','w');
elseif strcmpi(Sw,'off')
    try
        delete(gFigAxes.hEdgeCbar);  
    end
    gFigAxes.hEdgeCbar=NaN;
else
    error('Wrong input argument!');
end
set(hFig,'CurrentAxes',hAxes);
end

