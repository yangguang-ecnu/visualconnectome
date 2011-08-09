%THRESEDGE Summary of this function goes here
%   Detailed explanation goes here
function ThresholdEdges(Method,MinThres,MaxThres)
global gNetwork;
if nargin<2
    error('Require at least two arguments!');
end
if nargin<3
    VisCon_ThresEdges(Method,MinThres);
else
    VisCon_ThresEdges(Method,MinThres,MaxThres);
end
Selected=gNetwork.Selected;
SelectNodes([]);
SelectNodes(Selected);

end

