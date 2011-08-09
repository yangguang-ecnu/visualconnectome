%VISCON_PREPROC Summary of this function goes here
%   Detailed explanation goes here
function VisCon_Preproc()
global gVisConFig;
global gVisConNet;
global gVisConSurf;

nSub = length(gVisConNet);
gVisConFig.NodeNum = length(gVisConNet(1).ConMat);
gVisConFig.EdgeNum = gVisConFig.NodeNum*(gVisConFig.NodeNum-1)/2;
for iSub = 1:nSub
    %Validate Connectivity Matrix and Position Matrix
    if ~isequal(gVisConNet(iSub).ConMat,gVisConNet(iSub).ConMat.')
        error('The %d-th connectivity matrix should be symmetric!', iSub);
    end
    
    if size(gVisConNet(iSub).PosMat,1) ~= gVisConFig.NodeNum
        error('The %d-th position matrix should have equal rows as adjacent matrix!', iSub);
    end
    if size(gVisConNet(iSub).PosMat,2) ~= 3
        error('The %d-th position matrix should contain the 3-d coordinates of nodes!', iSub);
    end
    
    %Validate NodeSize data
    if ~isvector(gVisConNet(iSub).NodeSize) || ~isnumeric(gVisConNet(iSub).NodeSize)
        error('NodeSize should be a scalar or a vector!');
    end
    if length(gVisConNet(iSub).NodeSize)==1
        gVisConNet(iSub).NodeSize = ones(gVisConFig.NodeNum,1)*gVisConNet(iSub).NodeSize;
    elseif length(gVisConNet(iSub).NodeSize) ~= gVisConFig.NodeNum
        error('The length of NodeSize is not equal to the number of nodes!');
    end
    
    %Validate NodeColor data
    if ischar(gVisConNet(iSub).NodeColor)
        switch gVisConNet(iSub).NodeColor
            case {'y','yellow'}
                gVisConNet(iSub).NodeColor = [1 1 0];
            case {'m','magenta'}
                gVisConNet(iSub).NodeColor = [1 0 1];
            case {'c','cyan'}
                gVisConNet(iSub).NodeColor = [1 0 1];
            case {'r','red'}
                gVisConNet(iSub).NodeColor = [1 0 0];
            case {'g','green'}
                gVisConNet(iSub).NodeColor = [0 1 0];
            case {'b','blue'}
                gVisConNet(iSub).NodeColor = [0 0 1];
            otherwise
                error('Wrong input node color!')
        end
    elseif iscell(gVisConNet(iSub).NodeColor)
       for iNode = 1:length(gVisConNet(iSub).NodeColor)
           switch gVisConNet(iSub).NodeColor{iNode}
            case {'y','yellow'}
                gVisConNet(iSub).NodeColor{iNode} = [1 1 0];
            case {'m','magenta'}
                gVisConNet(iSub).NodeColor{iNode} = [1 0 1];
            case {'c','cyan'}
                gVisConNet(iSub).NodeColor{iNode} = [1 0 1];
            case {'r','red'}
                gVisConNet(iSub).NodeColor{iNode} = [1 0 0];
            case {'g','green'}
                gVisConNet(iSub).NodeColor{iNode} = [0 1 0];
            case {'b','blue'}
                gVisConNet(iSub).NodeColor{iNode} = [0 0 1];
            otherwise
                error('Wrong input node color!')
           end
       end
       gVisConNet(iSub).NodeColor = cell2mat(gVisConNet(iSub).NodeColor);
    end
    if size(gVisConNet(iSub).NodeColor,1) == 1
        gVisConNet(iSub).NodeColor = repmat(gVisConNet(iSub).NodeColor,gVisConFig.NodeNum,1);
    elseif size(gVisConNet(iSub).NodeColor,1) ~= gVisConFig.NodeNum
        error('The length of NodeColor is not equal to the number of nodes!');
    end
    
    %Validate NodeName data
    if ~isempty(gVisConNet(iSub).NodeName) && length(gVisConNet(iSub).NodeName) ~= gVisConFig.NodeNum
        error('The length of NodeName is not equal to the number of nodes!');
    end
    
    %Validate NodeStyle data
    if iscell(gVisConNet(iSub).NodeStyle) && length(gVisConNet(iSub).NodeStyle) == gVisConFig.NodeNum
        for i = 1:gVisConFig.NodeNum
            if ~strcmpi(gVisConNet(iSub).NodeStyle{i}, 'cube') && ~strcmpi(gVisConNet(iSub).NodeStyle{i}, 'sphere')
                error('Node style should be only ''cube'' or ''sphere''!')
            end
        end
    elseif ischar(gVisConNet(iSub).NodeStyle)
        if ~strcmpi(gVisConNet(iSub).NodeStyle, 'cube') && ~strcmpi(gVisConNet(iSub).NodeStyle, 'sphere')
            error('Node style should be only ''cube'' or ''sphere''!')
        end
        gVisConNet(iSub).NodeStyle = repmat({gVisConNet(iSub).NodeStyle}, gVisConFig.NodeNum, 1);
    else
        error('Error node style input!');
    end
    
    %Validate EdgeWidth data
    if ~isnumeric(gVisConNet(iSub).EdgeWidth) || ~isscalar(gVisConNet(iSub).EdgeWidth)
        error('EdgeWidth should be a scalar!');
    end
    
    %Network Attribute
    NoiseThres = 1e-3;
    gVisConNet(iSub).ConMat(1:gVisConFig.NodeNum+1:end) = 0;    %Diagonal elements equal to zero
    gVisConNet(iSub).ConMat(gVisConNet(iSub).ConMat < NoiseThres) = 0;
    SortedWeight = triu(gVisConNet(iSub).ConMat);
    SortedWeight = sort(SortedWeight(:));
    gVisConNet(iSub).SortedWeight = SortedWeight(SortedWeight >= NoiseThres);
    gVisConNet(iSub).NzEdgeNum = length(gVisConNet(iSub).SortedWeight);
    gVisConNet(iSub).MinWeight = min(gVisConNet(iSub).SortedWeight);
    gVisConNet(iSub).MaxWeight = max(gVisConNet(iSub).SortedWeight);
    gVisConNet(iSub).EdgeAbsThres = gVisConNet(iSub).MinWeight;
    gVisConNet(iSub).EdgeCountThres = gVisConNet(iSub).NzEdgeNum;
    gVisConNet(iSub).EdgeConnected = false(gVisConFig.NodeNum);
    gVisConNet(iSub).NodeShowed = false(1,gVisConFig.NodeNum);
    gVisConNet(iSub).NetProp = [];
end    
    %Preallocate handles of some objects
    gVisConFig.hNodes = zeros(gVisConFig.NodeNum,1)*NaN;
    gVisConFig.hNodeMarkers = zeros(gVisConFig.NodeNum,1)*NaN;
    gVisConFig.hEdges = zeros(gVisConFig.NodeNum)*NaN;
    gVisConFig.hEdgeCbar = NaN;
    gVisConFig.hHint = NaN;
    %Create unit sphere
    [gVisConFig.Sphe.x,gVisConFig.Sphe.y,gVisConFig.Sphe.z] = sphere(20);
    %Create unit cube
    gVisConFig.Cube.Vertices = [1 1 1;1 -1 1;-1 -1 1;-1 1 1;1 1 -1;1 -1 -1;-1 -1 -1;-1 1 -1];
    gVisConFig.Cube.Faces = [1 2 3 4;5 6 7 8;1 2 6 5;3 4 8 7;1 4 8 5;2 3 7 6];
    %Create displaying property
    gVisConFig.NodeSelected = [];
    gVisConFig.EdgeShowed = false(gVisConFig.NodeNum);
    gVisConFig.CurSubj = 1;
    gVisConFig.IdenNodes = 1;
    gVisConFig.IdenEdgeThres = 1;
    gVisConFig.EdgeThresType = 0;
    gVisConFig.LineSmooth = 'on';
    gVisConFig.FileName = 'Untitled';
    gVisConFig.FilePath = '';
    gVisConFig.SaveState = 1;
end

