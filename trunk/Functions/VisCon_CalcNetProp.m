%VISCON_NETANALYSIS Summary of this function goes here
%   Detailed explanation goes here
function VisCon_CalcNetProp()
global gVisConNet;
global gVisConFig;

hWaitBar = waitbar(0, '',...
    'Name', 'Calculate Network Property',...
    'CreateCancelBtn','setappdata(gcbf,''Canceling'',1)');
setappdata(hWaitBar,'Canceling',0)

nSub = length(gVisConNet);
for iSub = 1:nSub
    if getappdata(hWaitBar, 'Canceling') == 1
        break;
    end
    ConMat = gVisConNet(iSub).ConMat;
    ConMat(ConMat < gVisConNet(iSub).EdgeAbsThres) = 0;
    waitbar((iSub-1)/nSub, hWaitBar, sprintf('Processing the %d-th subject...', iSub));
    gVisConNet(iSub).NetProp = CalcNetProp(ConMat, 'wei');
    gVisConNet(iSub).NetProp.EdgeAbsThres = gVisConNet(iSub).EdgeAbsThres;
end
if getappdata(hWaitBar, 'Canceling') == 1
    waitbar(100, hWaitBar, 'Calculating network property canceled!');
else
    waitbar(100, hWaitBar, 'Calculating network property done!');
    if ~isempty(gVisConFig.NodeSelected)
        VisCon_UpdateInfo(gVisConFig.NodeSelected(end));
    end
end
pause(1);
delete(hWaitBar);
end

function [ NetProp ] = CalcNetProp( ConMat,type )

if strcmp(type,'wei')
    NetProp.Degree = degrees_und(ConMat).';
    NetProp.Strength = strengths_und(ConMat).';
    NetProp.Assortativity = assortativity(ConMat,0);
    NetProp.Density = density_und(ConMat);
    NetProp.ClusCoeff = clustering_coef_wu(ConMat);
    NetProp.Transitivity = transitivity_wu(ConMat);
    NetProp.Distance = distance_wei(ConMat);
    if(~isempty(find(NetProp.Distance == Inf,1)))
        warning('CalcNetProp:NotConnected',...
            'Some nodes of the network are not connected at sparsity %.2f',...
            NetProp.Density);
    end
    NetProp.CharPath=charpath(NetProp.Distance);
    NetProp.BetwCent=betweenness_wei(ConMat);
    NetProp.LocalEffi=efficiency(ConMat,1);
    NetProp.GlobalEffi=efficiency(ConMat);
%     NetProp.Randomized=randmio_und_connected(ConMat,10);
%     NetProp.Rand_ClusteringCoeff=clustering_coef_wu(NetProp.Randomized);
%     NetProp.Rand_Distance=distance_wei(NetProp.Randomized);
%     NetProp.Rand_CharPath=charpath(NetProp.Rand_Distance);
%     NetProp.Rand_LocalEffi=efficiency(NetProp.Randomized,1);
%     NetProp.Rand_GlobalEffi=efficiency(NetProp.Randomized);
%     NetProp.SmallWorld=(sum(NetProp.ClusteringCoeff)/sum(NetProp.Rand_ClusteringCoeff))...
%         /(NetProp.CharPath/NetProp.Rand_CharPath);
elseif strcmp(type,'bin')
    NetProp.Degree = degrees_und(ConMat).';
    NetProp.Strength = NetProp.Degree;
    NetProp.Assortativity = assortativity(ConMat,0);
    NetProp.Density = density_und(ConMat);
    NetProp.ClusCoeff = clustering_coef_bu(ConMat);
    NetProp.Transitivity = transitivity_bu(ConMat);
    NetProp.Distance = distance_bin(ConMat);
    NetProp.CharPath = charpath(NetProp.Distance);
    if(~isempty(find(NetProp.Distance==Inf,1)))
        warning('CalcNetProp:NotConnected',...
            'Some nodes of the network are not connected at sparsity %.2f',...
            NetProp.Density);
    end
    NetProp.BetwCent=betweenness_bin(ConMat);
    NetProp.LocalEffi=efficiency(ConMat,1);
    NetProp.GlobalEffi=efficiency(ConMat);
%     NetProp.Randomized=randmio_und(ConMat,2);
%     NetProp.Rand_ClusteringCoeff=clustering_coef_bu(NetProp.Randomized);
%     NetProp.Rand_Distance=distance_bin(NetProp.Randomized);
%     NetProp.Rand_CharPath=charpath(NetProp.Randomized);
%     NetProp.Rand_LocalEffi=efficiency(NetProp.Randomized,1);
%     NetProp.Rand_GlobalEffi=efficiency(NetProp.Randomized);
%    NetProp.SmallWorld=(sum(NetProp.ClusteringCoeff)/sum(NetProp.Rand_ClusteringCoeff))...
%        /(NetProp.CharPath/NetProp.Rand_CharPath);
end
end