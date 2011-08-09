%MATRIXVIEWER Summary of this function goes here
%   Detailed explanation goes here
function ConMatViewer()
global gVisConFig;
global gVisConNet;
hMatView = findobj('Tag','VisConMatView');
if isempty(hMatView)
    hMatView = figure('Name','Connectivity Matrix Viewer - VisualConnectome','NumberTitle','off',...
        'Tag','VisConMatView','MenuBar','none','ToolBar','none');
else
    figure(hMatView);
end
ConMat = gVisConNet(gVisConFig.CurSubj).ConMat;
ConMat(ConMat < gVisConNet(gVisConFig.CurSubj).EdgeAbsThres) = 0;
image(ConMat, 'CDataMapping', 'scaled', 'Tag', 'VisConMatImg');
axis image; 
set(gca,'XAxisLocation','top','YDir','reverse','TickDir','out','Position',[0.1,0.1,0.8,0.8]);
% if ~isempty(gVisConNet(gVisConFig.CurSubj).NodeName)
%     set(gca,'YTick',[1:gVisConFig.NodeNum], 'YTickLabel', gVisConNet(gVisConFig.CurSubj).NodeName);
% end
colormap default;
caxis([0 1]);
% colormap(gVisConFig.DftCmap);
% caxis([gVisConNet(gVisConFig.CurSubj).EdgeAbsThres gVisConNet(gVisConFig.CurSubj).MaxWeight]);
hCbar = colorbar;
title(hCbar,'Weight');
CurserObj = datacursormode(hMatView);
set(CurserObj, 'Enable', 'On', 'Updatefcn', @UpdateCurserInform);
function output_txt = UpdateCurserInform(obj,event_obj)
pos = get(event_obj,'Position');
output_txt = {['From n',num2str(pos(1),'%d'), ' to n',num2str(pos(2),'%d')],...
    ['Weight: ', num2str(ConMat(pos(1),pos(2)),3)]};
if ~isempty(gVisConNet(gVisConFig.CurSubj).NodeName)
    output_txt(3) = {['n',num2str(pos(1),'%d'),': ', gVisConNet(gVisConFig.CurSubj).NodeName{pos(1)}]};
    output_txt(4) = {['n',num2str(pos(2),'%d'),': ', gVisConNet(gVisConFig.CurSubj).NodeName{pos(2)}]};
end
end

end

