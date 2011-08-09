%THRESEDGE Summary of this function goes here
%   Detailed explanation goes here
function EdgeThreshold(Method,MinThres,MaxThres)
if nargin<2
    error('Require at least two arguments!');
end

hFig=findobj('Tag','VisConFig');
hAxes=findobj(hFig,'Tag','VisConAxes');
if isempty(hFig)
    error('VisualConnectome is not running');
else
    set(0,'CurrentFigure',hFig);
end
if isempty(hAxes)
    error('You must first create or open a VCT file!');
else
    set(hFig,'CurrentAxes',hAxes);
end

if nargin<3
    VisCon_EdgeThres(Method,MinThres);
else
    VisCon_EdgeThres(Method,MinThres,MaxThres);
end
VisCon_UpdateEdgeCbar()
end

