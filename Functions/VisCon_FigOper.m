%These functions is used to set figure property and its callback.
function VisCon_FigOper()
hFig=findobj('Tag','VisConFig');
set(hFig,...
    'ButtonDownFcn',@VisCon_FigOperButtonDn,...
    'WindowScrollWheelFcn',@VisCon_FigOperScroll,...
    'ResizeFcn',@VisCon_FigResize,...
    'KeyPressFcn',@VisCon_FigOperKeyDn,...
    'CloseRequestFcn',@VisCon_FigShut);
end
%% Figure button down function
function VisCon_FigOperButtonDn(Src,Evnt)
global gFigAxes;
%hFig=Src;
hAxes=findobj(Src,'Tag','VisConAxes');
hAxesInd=findobj(Src,'Tag','VisConAxesInd');
if ~isempty(hAxes)
    if strcmp(get(Src,'SelectionType'),'normal')
        set(Src,'PointerShapeCData',gFigAxes.PointerIcons{1},'Pointer','custom');
        set(Src,'WindowButtonMotionFcn',@LButtonMotion);
    end
    if strcmp(get(Src,'SelectionType'),'alt')
        set(Src,'PointerShapeCData',gFigAxes.PointerIcons{2},'Pointer','custom');
        set(Src,'WindowButtonMotionFcn',@RButtonMotion);
    end
    if strcmp(get(Src,'SelectionType'),'extend')
        set(Src,'PointerShapeCData',gFigAxes.PointerIcons{3},'Pointer','custom');
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
    if isempty(Evnt.Modifier)
        if strcmp(Evnt.Key,'comma')
            KeyScrollNode up;
        elseif strcmp(Evnt.Key,'period')
            KeyScrollNode down;
        elseif strcmp(Evnt.Key,'a')
            if ~isempty(gFigAxes.NodeSelected)
                EdgeShowed=(gNetwork.AdjMat(gFigAxes.NodeSelected,:)>=gNetwork.EdgeRange(1))...
                    & (gNetwork.AdjMat(gFigAxes.NodeSelected,:)<=gNetwork.EdgeRange(2));
                if all(all(gNetwork.EdgeConnected(gFigAxes.NodeSelected,:)))...
                        || isequal(EdgeShowed,gFigAxes.EdgeShowed(gFigAxes.NodeSelected,:))
                    DisconnectNodesAll(gFigAxes.NodeSelected);
                else
                    ConnectNodesAll(gFigAxes.NodeSelected);
                end
            end
        elseif strcmp(Evnt.Key,'b')
            if ~isempty(gFigAxes.NodeSelected)
                StartNodes=gFigAxes.NodeSelected;
                for i=gNetwork.NodeNum
                    set(gFigAxes.hNodes,'ButtonDownFcn',...
                        {@KeyConnNodesWith,StartNodes});
                end
            end
        elseif Evnt.Key=='1'
            set(hAxes,'CameraViewAngle',gFigAxes.InitCamViewAng);
            set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
            view(hAxes,0,90);
            if ~isempty(hAxesInd)
                view(hAxesInd,0,90);
            end
        elseif Evnt.Key=='2'
            set(hAxes,'CameraViewAngle',gFigAxes.InitCamViewAng);
            set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
            view(hAxes,180,-90);
            if ~isempty(hAxesInd)
                view(hAxesInd,180,-90);
            end
        elseif Evnt.Key=='3'
            set(hAxes,'CameraViewAngle',gFigAxes.InitCamViewAng);
            set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
            view(hAxes,-90,0);
            if ~isempty(hAxesInd)
                view(hAxesInd,-90,0);
            end
        elseif Evnt.Key=='4'
            set(hAxes,'CameraViewAngle',gFigAxes.InitCamViewAng);
            set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
            view(hAxes,90,0);
            if ~isempty(hAxesInd)
                view(hAxesInd,90,0);
            end
        elseif Evnt.Key=='5'
            set(hAxes,'CameraViewAngle',gFigAxes.InitCamViewAng);
            set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
            view(hAxes,180,0);
            if ~isempty(hAxesInd)
                view(hAxesInd,180,0);
            end
        elseif Evnt.Key=='6'
            set(hAxes,'CameraViewAngle',gFigAxes.InitCamViewAng);
            set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
            view(hAxes,0,0);
            if ~isempty(hAxesInd)
                view(hAxesInd,0,0);
            end
        elseif strcmp(Evnt.Key,'leftarrow')
            camorbit(hAxes,5,0);
            if ~isempty(hAxesInd)
                camorbit(hAxesInd,5,0);
            end
        elseif strcmp(Evnt.Key,'rightarrow')
            camorbit(hAxes,-5,0);
            if ~isempty(hAxesInd)
                camorbit(hAxesInd,-5,0);
            end
        elseif strcmp(Evnt.Key,'uparrow')
            camorbit(hAxes,0,5);
            if ~isempty(hAxesInd)
                camorbit(hAxesInd,0,5);
            end
        elseif strcmp(Evnt.Key,'downarrow')
            camorbit(hAxes,0,-5);
            if ~isempty(hAxesInd)
                camorbit(hAxesInd,0,-5);
            end
        elseif strcmp(Evnt.Key,'equal')
            camzoom(hAxes,1.1);
        elseif strcmp(Evnt.Key,'hyphen')
            camzoom(hAxes,0.9);
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
        'Position',[3 FigPos(4)-122 162 120]);
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
%% Node scroll function using key '<' '>'
function KeyScrollNode(Dir)
global gFigAxes;
global gNetwork;
if ~isempty(gFigAxes.NodeSelected)
    %Delete all selected markers
    for i=gFigAxes.NodeSelected
        if ishandle(gFigAxes.hNodeMarkers(i))
            delete(gFigAxes.hNodeMarkers(i))
        end
        gFigAxes.hNodeMarkers(i)=NaN;
    end
    %Select previous node
    if strcmpi(Dir,'up')
        i=min(gFigAxes.NodeSelected)-1;
        if i<1
            i=gNetwork.NodeNum;
        end
        %Select following node
    elseif strcmpi(Dir,'down')
        i=max(gFigAxes.NodeSelected)+1;
        if i>gNetwork.NodeNum
            i=1;
        end
    end
else
    %Select the last node
    if strcmpi(Dir,'up'),
        i=gNetwork.NodeNum;
        %Select the first node
    elseif strcmpi(Dir,'down'),
        i=1;
    end
end
VisCon_DrawNodeMarker(i)
gFigAxes.NodeSelected=i;
VisCon_UpdateInform(i);
end
%% Connect Nodes with using key 'b'
function KeyConnNodesWith(Src,Evnt,StartNodes)
global gFigAxes;
global gNetwork;
%Delete node marker
for j=gFigAxes.NodeSelected
    if ishandle(gFigAxes.hNodeMarkers(j))
        delete(gFigAxes.hNodeMarkers(j))
    end
    gFigAxes.hNodeMarkers(j)=NaN;
end
gFigAxes.NodeSelected=[];
%Display node marker
[j,~]=find(gFigAxes.hNodes==Src);
VisCon_DrawNodeMarker(j)
gFigAxes.NodeSelected=j;
VisCon_UpdateInform(j);
PairNodes=[StartNodes.',j*ones(length(StartNodes),1)];
if all(gNetwork.EdgeConnected(StartNodes,j))
    DisconnectTwoNodes(PairNodes);
else
    ConnectTwoNodes(PairNodes);
end
for j=1:gNetwork.NodeNum
    set(gFigAxes.hNodes(j),'ButtonDownFcn',@VisCon_SelectNode);
end

end
