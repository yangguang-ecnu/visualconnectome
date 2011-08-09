function EdgeThreshold(Method, Thres, Subj, Display)
global gVisConFig;
global gVisConNet;

if nargin < 2
    error('Require at least two arguments!');
end
if nargin < 3
    Subj = gVisConFig.CurSubj;
end
if nargin < 4
    Display = 'on';
end

if ~ischar(Method) || isempty(strmatch(lower(Method), {'absolute','counting','proportional'},'exact'))
    error('Error input Method!');
end
         
if ischar(Subj) && strcmpi(Subj, 'all')
    Subj = [1:length(gVisConNet)];
elseif ~isnumeric(Subj)
    error('Input Subj should be numeric subject index!');
end

if max(Subj) > length(gVisConNet) || min(Subj) < 1
    error('The input Subj exceeds subject index!');
end

hFig = findobj('Tag','VisConFig');
hMatView = findobj('Tag','VisConMatView');
hAxes = findobj(hFig,'Tag','VisConAxes');

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
for iSub = Subj
    VisCon_EdgeThres(Method, Thres, iSub);
end
if strcmpi(Display, 'on')
    if strcmpi(Method, 'absolute')
        fprintf('Edges with weight larger than %.6f will be retained!\n', gVisConNet(gVisConFig.CurSubj).EdgeAbsThres);
    elseif strcmpi(Method, 'counting') || strcmpi(Method, 'proportional')
        fprintf('%i (%.2f%%) of strongest edges will be retained!\n', gVisConNet(gVisConFig.CurSubj).EdgeCountThres,...
            gVisConNet(gVisConFig.CurSubj).EdgeCountThres * 100 / gVisConFig.EdgeNum);
    end
end
%Update Edges
VisCon_UpdateEdgeCbar();
VisCon_UpdateEdges();
%Update ConMat Viewer
if ~isempty(hMatView)
    ConMatViewer();
end
%
if ~isempty(gVisConFig.NodeSelected)
    VisCon_UpdateInfo(gVisConFig.NodeSelected(end));
end
end

