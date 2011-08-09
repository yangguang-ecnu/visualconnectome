%AXESINDICATOR Summary of this function goes here
%   Detailed explanation goes here
function AxesIndicator(Sw)
if nargin==0,   Sw='on';    end
hFig=findobj('Tag','VisConFig');
hAxes=findobj(hFig,'Tag','VisConAxes');
hAxesInd=findobj(hFig,'Tag','VisConAxesInd');
hMenuAxesInd=findobj(hFig,'Tag','VisConMenuAxesInd');
hTbarAxesInd=findobj(hFig,'Tag','VisConTbarAxesInd');
if isempty(hFig)
    error('VisualConnectome is not running');
else
    set(0,'CurrentFigure',hFig);
end
if isempty(hAxes)
    error('You must first create or open a VCT file!');
end
if strcmpi(Sw,'on') || strcmpi(Sw,'show');
    %Delete axes indicator if it exists
    if ~isempty(hAxesInd),  delete(hAxesInd);   end
    %Create Axes Indicator
    hAxesInd=axes('Tag','VisConAxesInd','DrawMode','fast',...
        'Units','pixel','Position',[30 30 40 40],...
        'HitTest','off');
    axis off vis3d;
    [az,el]=view(hAxes);
    view(hAxesInd,az,el);
    line([0;1],[0;0],[0;0],'Color','r','LineWidth',2.5,'Marker','x','MarkerSize',3,'HitTest','off');
    line([0;0],[0;1],[0;0],'Color','g','LineWidth',2.5,'Marker','x','MarkerSize',3,'HitTest','off');
    line([0;0],[0;0],[0;1],'Color','b','LineWidth',2.5,'Marker','x','MarkerSize',3,'HitTest','off');
    text(0.8,-0.1,-0.1,'X','Color','w','HitTest','off');
    text(-0.1,0.8,-0.1,'Y','Color','w','HitTest','off');
    text(-0.1,-0.1,0.8,'Z','Color','w','HitTest','off');
    set(hMenuAxesInd,'Checked','on');
    set(hTbarAxesInd,'State','on');
elseif strcmpi(Sw,'off') || strcmpi(Sw,'hide')
    if ~isempty(hAxesInd),  delete(hAxesInd);   end
    set(hMenuAxesInd,'Checked','off');
    set(hTbarAxesInd,'State','off');
else
    error('Wrong input argument!');
end
set(hFig,'CurrentAxes',hAxes);
end

