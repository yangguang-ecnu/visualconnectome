%This function creates and sets axes and lights.
function VisCon_Axes()
global gVisConNet;
global gVisConFig;
hFig = findobj('Tag','VisConFig');
hAxes = findobj(hFig,'Tag','VisConAxes');
%Delete axes if it exists
if ~isempty(hAxes),  delete(hAxes);   end
%Create axes
hAxes = axes('Tag','VisConAxes','Color','k',...
    'XColor','w','YColor','w','ZColor','w',...
    'DrawMode','fast','Position',[0.12 0.08 0.8 0.8],'HitTest','off');
axis off vis3d;
view(hAxes,-90,0);
light('Position',[1,0,0],'Style','infinite');
light('Position',[-1,0,0],'Style','infinite');
gVisConFig.InitCamViewAng = camva(hAxes);

%Limit the axes
AllPosMat = vertcat(gVisConNet(:,1).PosMat);
xlim = [min(AllPosMat(:,1)), max(AllPosMat(:,1))] + [-15,15];
ylim = [min(AllPosMat(:,2)), max(AllPosMat(:,2))] + [-15,15];
zlim = [min(AllPosMat(:,3)), max(AllPosMat(:,3))] + [-15,15];
axis(hAxes,[xlim,ylim,zlim]);
end

