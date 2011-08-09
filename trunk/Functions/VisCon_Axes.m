%This function creates and sets axes and lights.
function VisCon_Axes()
global gFigAxes;
hFig=findobj('Tag','VisConFig');
hAxes=findobj(hFig,'Tag','VisConAxes');
%Delete axes if it exists
if ~isempty(hAxes),  delete(hAxes);   end
%Create axes
hAxes=axes('Tag','VisConAxes','Color','k',...
    'XColor','w','YColor','w','ZColor','w',...
    'DrawMode','fast','Position',[0.08 0.08 0.8 0.8]);
axis off vis3d;
view(hAxes,-90,0);
light('Position',[1,0,0],'Style','infinite');
light('Position',[-1,0,0],'Style','infinite');
gFigAxes.InitCamViewAng=get(hAxes,'CameraViewAngle');
end

