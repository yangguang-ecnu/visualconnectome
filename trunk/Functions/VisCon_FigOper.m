%These functions is used to set figure property and its callback.
function VisCon_FigOper()
hFig = findobj('Tag','VisConFig');
set(hFig,...
    'ButtonDownFcn',@VisCon_FigOperButtonDn,...
    'WindowScrollWheelFcn',@VisCon_FigOperScroll,...
    'ResizeFcn',@VisCon_FigResize,...
    'KeyPressFcn',@VisCon_FigOperKeyDn,...
    'CloseRequestFcn',@VisCon_FigShut);
end
%% Figure button down function
function VisCon_FigOperButtonDn(Src,Evnt)
global gVisConFig;
hAxes = findobj(Src,'Tag','VisConAxes');
hAxesInd = findobj(Src,'Tag','VisConAxesInd');
if ~isempty(hAxes)
    if strcmp(get(Src,'SelectionType'),'normal') && isempty(get(1, 'CurrentModifier'))
        if ~isempty(gVisConFig.NodeSelected)
            for iNode = gVisConFig.NodeSelected
                try
                    delete(gVisConFig.hNodeMarkers(iNode));
                end
                gVisConFig.hNodeMarkers(iNode) = NaN;
            end
            gVisConFig.NodeSelected = [];
            VisCon_UpdateInfo([]);
        end
    end
    if strcmp(get(Src,'SelectionType'),'alt') && isempty(get(1, 'CurrentModifier'))
        set(Src,'PointerShapeCData',gVisConFig.PointerIcons{1},'Pointer','custom');
        set(Src,'WindowButtonMotionFcn',@RButtonMotion);
    end
    if strcmp(get(Src,'SelectionType'),'extend') && isempty(get(1, 'CurrentModifier'))
        set(Src,'PointerShapeCData',gVisConFig.PointerIcons{2},'Pointer','custom');
        set(Src,'WindowButtonMotionFcn',@MButtonMotion);
    end
    set(Src,'WindowButtonUpFcn',@ButtonUp);
    FigCurPointOld = get(Src,'CurrentPoint');
end
    function RButtonMotion(Src,Evnt)
        FigCurPointNew = get(Src,'CurrentPoint');
        FigCurPoint = FigCurPointNew-FigCurPointOld;
        FigCurPointOld = FigCurPointNew;
        camorbit(hAxes,-0.5*FigCurPoint(1),-0.5*FigCurPoint(2));
        if ~isempty(hAxesInd)
            camorbit(hAxesInd,-0.5*FigCurPoint(1),-0.5*FigCurPoint(2));
        end
    end
    function MButtonMotion(Src,Evnt)
        FigCurPointNew = get(Src,'CurrentPoint');
        FigCurPoint = FigCurPointNew-FigCurPointOld;
        FigCurPointOld = FigCurPointNew;
        camdolly(hAxes,-0.006*FigCurPoint(1),-0.006*FigCurPoint(2),0);
    end
%     function MButtonMotion(Src,Evnt)
%         FigCurPointNew = get(Src,'CurrentPoint');
%         FigCurPoint = FigCurPointNew-FigCurPointOld;
%         FigCurPointOld = FigCurPointNew;
%         camzoom(hAxes,1-0.01*FigCurPoint(1)-0.01*FigCurPoint(2));
%     end
    function ButtonUp(Src,Evnt)
        set(Src,'WindowButtonMotionFcn','');
        set(Src,'WindowButtonUpFcn','');
        set(Src,'Pointer','arrow');
    end
end
%% Figure key press function
function VisCon_FigOperKeyDn(Src,Evnt)
global gVisConFig;
global gVisConNet;
hFig = findobj('Tag','VisConFig');
hAxes = findobj(hFig,'Tag','VisConAxes');
hAxesInd = findobj(hFig,'Tag','VisConAxesInd');
if ~isempty(hAxes)
    if isempty(Evnt.Modifier)
        if strcmp(Evnt.Key,'comma')
            KeyScrollNode up;
        elseif strcmp(Evnt.Key,'period')
            KeyScrollNode down;
        elseif strcmp(Evnt.Key,'a')
            if ~isempty(gVisConFig.NodeSelected)
                EdgeShowed = (gVisConNet(gVisConFig.CurSubj).ConMat(gVisConFig.NodeSelected,:) >= gVisConNet(gVisConFig.CurSubj).EdgeAbsThres);
                if all(all(gVisConNet(gVisConFig.CurSubj).EdgeConnected(gVisConFig.NodeSelected,:)))...
                        || isequal(EdgeShowed,gVisConFig.EdgeShowed(gVisConFig.NodeSelected,:))
                    DisconnectNodesAll(gVisConFig.NodeSelected);
                else
                    ConnectNodesAll(gVisConFig.NodeSelected);
                end
            end
        elseif strcmp(Evnt.Key,'b')
            if ~isempty(gVisConFig.NodeSelected)
                StartNodes = gVisConFig.NodeSelected;
                for i = gVisConFig.NodeNum
                    set(gVisConFig.hNodes,'ButtonDownFcn',...
                        {@VisCon_ConnectNodesWith,StartNodes});
                end
                VisCon_Hint('Select a node to connect/disconnect ...');
            end
        elseif strcmp(Evnt.Key,'h')
            if ~isempty(gVisConFig.NodeSelected)
                HideNodes(gVisConFig.NodeSelected);
            end
        elseif Evnt.Key == '1'
            set(hAxes,'CameraViewAngle',gVisConFig.InitCamViewAng);
            set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
            view(hAxes,0,90);
            if ~isempty(hAxesInd)
                view(hAxesInd,0,90);
            end
        elseif Evnt.Key == '2'
            set(hAxes,'CameraViewAngle',gVisConFig.InitCamViewAng);
            set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
            view(hAxes,180,-90);
            if ~isempty(hAxesInd)
                view(hAxesInd,180,-90);
            end
        elseif Evnt.Key == '3'
            set(hAxes,'CameraViewAngle',gVisConFig.InitCamViewAng);
            set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
            view(hAxes,-90,0);
            if ~isempty(hAxesInd)
                view(hAxesInd,-90,0);
            end
        elseif Evnt.Key=='4'
            set(hAxes,'CameraViewAngle',gVisConFig.InitCamViewAng);
            set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
            view(hAxes,90,0);
            if ~isempty(hAxesInd)
                view(hAxesInd,90,0);
            end
        elseif Evnt.Key=='5'
            set(hAxes,'CameraViewAngle',gVisConFig.InitCamViewAng);
            set(hAxes,'CameraTargetMode','auto','CameraPositionMode','auto');
            view(hAxes,180,0);
            if ~isempty(hAxesInd)
                view(hAxesInd,180,0);
            end
        elseif Evnt.Key=='6'
            set(hAxes,'CameraViewAngle',gVisConFig.InitCamViewAng);
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
    elseif strcmp(Evnt.Modifier, 'control')
        switch(Evnt.Key)
            case 'leftarrow'
                camdolly(hAxes, 0.2, 0, 0);
            case 'rightarrow'
                camdolly(hAxes, -0.2, 0, 0);
            case 'uparrow'
                camdolly(hAxes, 0, -0.2, 0);
            case 'downarrow'
                camdolly(hAxes, 0, 0.2, 0);
            otherwise
        end
    end
end
end
%% Figure scroll function
function VisCon_FigOperScroll(Src,Evnt)
hFig = findobj('Tag','VisConFig');
hAxes = findobj(hFig,'Tag','VisConAxes');
if ~isempty(hAxes)
    if Evnt.VerticalScrollCount < 0
        camzoom(hAxes,0.9^(-Evnt.VerticalScrollCount));
    elseif Evnt.VerticalScrollCount > 0
        camzoom(hAxes,1.1^Evnt.VerticalScrollCount);
    end
end
end
%% Figure resize function
function VisCon_FigResize(Src,Evnt)
global gVisConFig;
hFig = findobj('Tag','VisConFig');
hAxesInd = findobj(hFig, 'Tag', 'VisConAxesInd');
hInfoBox = findobj(hFig, 'Tag', 'VisConInfoBox');
FigPos = get(hFig,'Position');
if ~isempty(hInfoBox)
    set(hInfoBox,'Units','pixel',...
        'Position',[8 FigPos(4) - 6 1 1]);
end
if ishandle(gVisConFig.hEdgeCbar)
    height = FigPos(4)/2;             width = FigPos(4)/20;
    left = 0.95*FigPos(3)-width-20;   bottom = FigPos(4)/4;
    set(gVisConFig.hEdgeCbar,'Units','pixel',...
        'Position',[left bottom width height]);
end
if ~isempty(hAxesInd)
    set(hAxesInd,'Units','pixel',...
        'Position',[30 30 40 40] * FigPos(4)/480);
end
if ishandle(gVisConFig.hHint)
   set(gVisConFig.hHint,'Position',[FigPos(3)/2 20 * FigPos(4)/480 10 20],...
       'FitBoxToText', 'on'); 
end
hSubjSelPanel = findobj(hFig, 'Tag', 'SubjSelPanel');
if ~isempty(hSubjSelPanel)
    set(hSubjSelPanel, 'Units','pixel',...
        'Position', [FigPos(3)/2-150 FigPos(4)-62 300 64]);
end
end
%% Figure shut function
function VisCon_FigShut(Src,Evnt)
global gVisConFig;
if gVisConFig.SaveState == 1
    if isempty(gVisConFig.FilePath)
        quest = 'Save to VCT File?';
    else
        quest = ['Save changes to ' gVisConFig.FileName '?'];
    end
    Button = questdlg(quest,'VisualConnectome','Save','Discard','Cancel','Save');
    if strcmp(Button,'Save')
        if isempty(gVisConFig.FilePath)
            if  VisCon_SaveDlg() == 0
                return;
            end
        else
            SaveVisConFile(fullfile(gVisConFig.FilePath, gVisConFig.FileName));
        end
        delete(Src);
    elseif strcmp(Button,'Discard')
        delete(Src);
    end
else
    delete(Src);
end
end
%% Node scroll function using key '<' '>'
function KeyScrollNode(Dir)
global gVisConFig;
global gVisConNet;
NodeShowed = find(gVisConNet(gVisConFig.CurSubj).NodeShowed);
if ~isempty(gVisConFig.NodeSelected)
    %Delete all selected markers
    for i=gVisConFig.NodeSelected
        if ishandle(gVisConFig.hNodeMarkers(i))
            delete(gVisConFig.hNodeMarkers(i))
        end
        gVisConFig.hNodeMarkers(i)=NaN;
    end
    %Select previous node
    if strcmpi(Dir,'up')
        i = find(NodeShowed == min(gVisConFig.NodeSelected)) - 1;
        if i < 1
            i = max(NodeShowed);
        else
            i = NodeShowed(i);
        end
        %Select following node
    elseif strcmpi(Dir,'down')
        i = find(NodeShowed == min(gVisConFig.NodeSelected)) + 1;
        if i > length(NodeShowed);
            i = min(NodeShowed);
        else
            i = NodeShowed(i);
        end
    end
else
    %Select the last node
    if strcmpi(Dir,'up'),
        i = max(NodeShowed);
    %Select the first node
    elseif strcmpi(Dir,'down'),
        i = min(NodeShowed);
    end
end
VisCon_DrawNodeMarker(i)
gVisConFig.NodeSelected=i;
VisCon_UpdateInfo(i);
end
