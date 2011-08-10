function VisCon_UpdateInfo(Node)
global gVisConFig;
global gVisConNet;

hFig = findobj('Tag', 'VisConFig');
hInfoBoxText = findobj(hFig, 'Tag', 'VisConInfoBoxText');
if nargin == 0,   Node = [];    end
if ~isscalar(Node) && ~isempty(Node)
    error('Input argument should be a scalar!')
end
CutLine = {repmat('-', 1, 38)};
SubjInfoTitle = {...
    [blanks(12) '{\bf\fontsize{10}Subject Info.}'],...
    '{\bfSubjTag: }',...
    };
NetInfoTitle = {...
    [blanks(12) '{\bf\fontsize{10}Network Info.}'],...
    '{\bfGlobalEffi: }',...
    '{\bfCharPath: }',...
    };
NodeInfoTitle = {...
    [blanks(14) '{\bf\fontsize{10}Node Info.}'],...   
    '{\bfNodeTag: }',...
    '{\bfRegion: }',...
    '{\bfDegree: }',...
    '{\bfStrength: }',...
    '{\bfClusCoeff: }',...
    '{\bfBetwCent: }',...
    '{\bfLocalEffi: }'...
    };
if ~isempty(hInfoBoxText)
    %
    SubjInfo = SubjInfoTitle;
    SubjInfo{2} = [SubjInfo{2}, ['Subj. ' num2str(gVisConFig.CurSubj)]];
    %
    NetInfo = NetInfoTitle;
    if ~isempty(gVisConNet(gVisConFig.CurSubj).NetProp)
        NetProp = gVisConNet(gVisConFig.CurSubj).NetProp;
        if isequal(gVisConNet(gVisConFig.CurSubj).EdgeAbsThres, NetProp.EdgeAbsThres)
            NetInfo{2} = [NetInfo{2}, sprintf('%.3f', NetProp.GlobalEffi)];
            NetInfo{3} = [NetInfo{3}, sprintf('%.3f', NetProp.CharPath)];
        else
            NetInfo{2} = [NetInfo{2}, 'To Update'];
            NetInfo{3} = [NetInfo{3}, 'To Update'];
        end
    else
        NetInfo{2} = [NetInfo{2}, 'Not Available'];
        NetInfo{3} = [NetInfo{3}, 'Not Available'];
    end
    %
    NodeInfo = NodeInfoTitle;    
    if ~isempty(Node)
        hNode = gVisConFig.hNodes(Node);
        NodeInfo{2} = [NodeInfo{2},get(hNode,'Tag')];
        % Display Region Name
        if ~isempty(gVisConNet(gVisConFig.CurSubj).NodeName) 
            NodeName = gVisConNet(gVisConFig.CurSubj).NodeName{Node};
            NodeName = strrep(NodeName, '_', '\_');
            NodeInfo{3} = [NodeInfo{3},NodeName];
        else
            NodeInfo{3} = [NodeInfo{3},'Not Available'];
        end
        % Display Network Property
        if ~isempty(gVisConNet(gVisConFig.CurSubj).NetProp)
            NetProp = gVisConNet(gVisConFig.CurSubj).NetProp;
            if isequal(gVisConNet(gVisConFig.CurSubj).EdgeAbsThres, NetProp.EdgeAbsThres)
                NodeInfo{4} = [NodeInfo{4}, sprintf('%d', NetProp.Degree(Node))];
                NodeInfo{5} = [NodeInfo{5}, sprintf('%.3f', NetProp.Strength(Node))];
                NodeInfo{6} = [NodeInfo{6}, sprintf('%.3f', NetProp.ClusCoeff(Node))];
                NodeInfo{7} = [NodeInfo{7}, sprintf('%.3f', NetProp.BetwCent(Node))];
                NodeInfo{8} = [NodeInfo{8}, sprintf('%.3f', NetProp.LocalEffi(Node))];
            else
                NodeInfo{4} = [NodeInfo{4}, 'To Update'];
                NodeInfo{5} = [NodeInfo{5}, 'To Update'];
                NodeInfo{6} = [NodeInfo{6}, 'To Update'];
                NodeInfo{7} = [NodeInfo{7}, 'To Update'];
                NodeInfo{8} = [NodeInfo{8}, 'To Update'];
            end
        else
            NodeInfo{4} = [NodeInfo{4}, 'Not Available'];
            NodeInfo{5} = [NodeInfo{5}, 'Not Available'];
            NodeInfo{6} = [NodeInfo{6}, 'Not Available'];
            NodeInfo{7} = [NodeInfo{7}, 'Not Available'];
            NodeInfo{8} = [NodeInfo{8}, 'Not Available'];
        end
    end
    set(hInfoBoxText,'String',[SubjInfo,CutLine,NetInfo,CutLine,NodeInfo]);
end

end

