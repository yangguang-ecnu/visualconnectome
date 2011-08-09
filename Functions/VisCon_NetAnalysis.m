%VISCON_NETANALYSIS Summary of this function goes here
%   Detailed explanation goes here
function VisCon_NetAnalysis()
global gNetwork;
AdjMat=gNetwork.AdjMat;
AdjMat(AdjMat<gNetwork.EdgeRange(1))=0;
AdjMat(AdjMat>gNetwork.EdgeRange(2))=0;
gNetwork.Degree=degrees_und(AdjMat);


end

