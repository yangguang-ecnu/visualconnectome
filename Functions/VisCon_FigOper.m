%These functions create figure and set its property.
function VisCon_FigOper()
hFig=findobj('Tag','VisConFig');
set(hFig,...
    'WindowButtonDownFcn',@VisCon_FigOperButtonDn,...
    'WindowScrollWheelFcn',@VisCon_FigOperScroll,...
    'KeyPressFcn',@VisCon_FigOperKeyDn,...
    'ResizeFcn',@VisCon_FigResize,...
    'CloseRequestFcn',@VisCon_FigShut);
end
%% Figure button down function
function VisCon_FigOperButtonDn(Src,Evnt)
global gFigAxes;
hFig=findobj('Tag','VisConFig');
hAxes=findobj(hFig,'Tag','VisConAxes');
hAxesInd=findobj(hFig,'Tag','VisConAxesInd');
if ~isempty(hAxes)
    if strcmp(get(Src,'SelectionType'),'normal')
        set(Src,'Pointer','custom','PointerShapeCData',gFigAxes.PointerIcons{1});
        set(Src,'WindowButtonMotionFcn',@LButtonMotion);
    end
    if strcmp(get(Src,'SelectionType'),'alt')
        set(Src,'Pointer','custom','PointerShapeCData',gFigAxes.PointerIcons{2});
        set(Src,'WindowButtonMotionFcn',@RButtonMotion);
    end
    if strcmp(get(Src,'SelectionType'),'extend')
        set(Src,'Pointer','custom','PointerShapeCData',gFigAxes.PointerIcons{3});
        set(Src,'WindowButtonMotionFcn',@MButtonMotion);
    end
    set(Src,'WindowButtonUpFcn',@ButtonUp);
    FigCurPointOld=get(Src,'CurrentPoint');
end
    function LButtonMotion(Src,Evnt)
        FigCurPointNew=get(Src,'CurrentPoint');
        FigCurPoint=FigCurPointNew-FigCurPointOld;
        FigCurPointOld=FigCurPointNew;
        camorbit(hAxes,-0.5*FigCurPoint(1),-0.5*FigCurPoint(2));
        if ~isempty(hAxesInd)
            camorbit(hAxesInd,-0.5*FigCurPoint(1),-0.5*FigCurPoint(2));
        end
    end
    function RButtonMotion(Src,Evnt)
        FigCurPointNew=get(Src,'CurrentPoint');
        FigCurPoint=FigCurPointNew-FigCurPointOld;
        FigCurPointOld=FigCurPointNew;
        camdolly(hAxes,-0.006*FigCurPoint(1),-0.006*FigCurPoint(2),0);
    end
    function MButtonMotion(Src,Evnt)
        FigCurPointNew=get(Src,'CurrentPoint');
        FigCurPoint=FigCurPointNew-FigCurPointOld;
        FigCurPointOld=FigCurPointNew;
        camzoom(hAxes,1-0.01*FigCurPoint(1)-0.01*FigCurPoint(2));
    end
    function ButtonUp(Src,Evnt)
        set(Src,'WindowButtonMotionFcn','');
        set(Src,'WindowButtonUpFcn','');
        set(Src,'Pointer','arrow');
    end
end
%% Figure key press function
function VisCon_FigOperKeyDn(Src,Evnt)
global gFigAxes;
global gNetwork;
hFig=findobj('Tag','VisConFig');
hAxes=findobj(hFig,'Tag','VisConAxes');
hAxesInd=findobj(hFig,'Tag','VisConAxesInd');
if ~isempty(hAxes)
    if strcmp(Evnt.Key,'leftarrow')
        camorbit(hAxes,5,0);
        if ~isempty(hAxesInd)
            camorbit(hAxesInd,5,0);
        end
    end
    if strcmp(Evnt.Key,'rightarrow')
        camorbit(hAxes,-5,0);
        if ~isempty(hAxesInd)
            camorbit(hAxesInd,-5,0);
        end
    end
    if strcmp(Evnt.Key,'uparrow')
        camorbit(hAxes,0,5);
        if ~isempty(hAxesInd)
            camorbit(hAxesInd,0,5);
        end
    end
    if strcmp(Evnt.Key,'downarrow')
        camorbit(hAxes,0,-5);
        if ~isempty(hAxesInd)
            camorbit(hAxesInd,0,-5);
        end
    end
    if strcmp(Evnt.Key,'equal')
        camzoom(hAxes,1.1);
    end
    if strcmp(Evnt.Key,'hyphen')
        camzoom(hAxes,0.9);
    end
    if Evnt.Key=='1'
        set(hAxes,'CameraViewAngle',gFigAxes.InitCamViewAng);
        set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
        view(hAxes,0,90);
        if ~isempty(hAxesInd)
            view(hAxesInd,0,90);
        end
    end
    if Evnt.Key=='2'
        set(hAxes,'CameraViewAngle',gFigAxes.InitCamViewAng);
        set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
        view(hAxes,180,-90);
        if ~isempty(hAxesInd)
            view(hAxesInd,180,-90);
        end
    end
    if Evnt.Key=='3'
        set(hAxes,'CameraViewAngle',gFigAxes.InitCamViewAng);
        set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
        view(hAxes,-90,0);
        if ~isempty(hAxesInd)
            view(hAxesInd,-90,0);
        end
    end
    if Evnt.Key=='4'
        set(hAxes,'CameraViewAngle',gFigAxes.InitCamViewAng);
        set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
        view(hAxes,90,0);
        if ~isempty(hAxesInd)
            view(hAxesInd,90,0);
        end
    end
    if Evnt.Key=='5'
        set(hAxes,'CameraViewAngle',gFigAxes.InitCamViewAng);
        set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
        view(hAxes,180,0);
        if ~isempty(hAxesInd)
            view(hAxesInd,180,0);
        end
    end
    if Evnt.Key=='6'
        set(hAxes,'CameraViewAngle',gFigAxes.InitCamViewAng);
        set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
        view(hAxes,0,0);
        if ~isempty(hAxesInd)
            view(hAxesInd,0,0);
        end
    end
    if Evnt.Key=='a'
        if isempty(gNetwork.Selected)
            SelectNodes('all');
        else
            SelectNodes('none');
        end
    end
end
end
%% Figure scroll function
function VisCon_FigOperScroll(Src,Evnt)
hFig=findobj('Tag','VisConFig');
hAxes=findobj(hFig,'Tag','VisConAxes');
if ~isempty(hAxes)
    if Evnt.VerticalScrollCount<0
        camzoom(hAxes,0.9^(-Evnt.VerticalScrollCount));
    elseif Evnt.VerticalScrollCount>0
        camzoom(hAxes,1.1^Evnt.VerticalScrollCount);
    end
end
end
%% Figure resize function
function VisCon_FigResize(Src,Evnt)
global gFigAxes;
hFig=findobj('Tag','VisConFig');
FigPos=get(hFig,'Position');
if ishandle(gFigAxes.hInformBox)
    set(gFigAxes.hInformBox,'Units','pixel',...
        'Position',[3 FigPos(4)-102 142 100]);
end
if ishandle(gFigAxes.hEdgeCbar)
    height=FigPos(4)/2;             width=FigPos(4)/20;
    left=0.95*FigPos(3)-width-20;   bottom=FigPos(4)/4;
    set(gFigAxes.hEdgeCbar,'Units','pixel',...
        'Position',[left bottom width height]);
end
end
%% Figure shut function
function VisCon_FigShut(Src,Evnt)
Button=questdlg('Confirm to exit VisualConnectome?','VisualConnectome',...
    'OK','Cancel','Cancel');
if strcmp(Button,'OK')
    delete(Src);
end
end

