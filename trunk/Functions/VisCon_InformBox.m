%NODEINFORMBOX Summary of this function goes here
%   Detailed explanation goes here
function VisCon_InformBox(Sw)
global gFigAxes;
if nargin==0,   Sw='on';    end
hFig=findobj('Tag','VisConFig');
Information={...
    '    {\bf\fontsize{10}Information Box}',...
    '{\bfNodTag:} ',...
    '{\bfRegion:} ',...
    '{\bfDegree:} '};
if strcmpi(Sw,'on')
    %delete information box if it exists
    try
        delete(gFigAxes.hInformBox);  
    end
    FigPos=get(hFig,'Position');
    gFigAxes.hInformBox=annotation('textbox','string',Information,...
        'EdgeColor','w','Color','w','FontSize',8,'LineWidth',1.5,...
        'Units','pixel','Position',[3 FigPos(4)-102 142 100],...
        'HitTest','off');
elseif strcmpi(Sw,'off')
    try
        delete(gFigAxes.hInformBox);  
    end
    gFigAxes.hInformBox=NaN;
else
    error('Wrong input argument!');
end
end

