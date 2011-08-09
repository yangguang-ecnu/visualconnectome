%This function creates and sets axes and lights.
function VisCon_Axes()
global gNetwork;
global gFigAxes;
hFig=findobj('Tag','VisConFig');
hAxes=findobj(hFig,'Tag','VisConAxes');
%Delete axes if it exists
if ~isempty(hAxes),  delete(hAxes);   end
%Create axes
hAxes = axes('Tag','VisConAxes','Color','k',...
    'XColor','w','YColor','w','ZColor','w',...
    'DrawMode','fast','Position',[0.08 0.08 0.8 0.8],'HitTest','off');
axis off vis3d;
view(hAxes,-90,0);
light('Position',[1,0,0],'Style','infinite');
light('Position',[-1,0,0],'Style','infinite');
gFigAxes.InitCamViewAng=camva(hAxes);

%Limit the axes
xlim = [min(gNetwork.PosMat(:,1)), max(gNetwork.PosMat(:,1))] + [-15,15];
ylim = [min(gNetwork.PosMat(:,2)), max(gNetwork.PosMat(:,2))] + [-15,15];
zlim = [min(gNetwork.PosMat(:,3)), max(gNetwork.PosMat(:,3))] + [-15,15];
axis(hAxes,[xlim,ylim,zlim]);
end

