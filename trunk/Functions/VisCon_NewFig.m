function VisCon_NewFig()
global gVisConFig;
global gVisConNet;
global gVisConSurf;
global gVisConState;

hFig = findobj('Tag', 'VisConFig');
if ~isempty(hFig)
    if strcmpi(gVisConState, 'Finish') || strcmpi(gVisConState, 'Loaded')
        FigPos = get(hFig, 'Position');
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
            elseif strcmp(Button,'Cancel')
                return;
            end
        end
        gVisConNet = struct;
        gVisConSurf = struct;
        VisConFig.VisConPath = gVisConFig.VisConPath;
        VisConFig.TbarIcons = gVisConFig.TbarIcons;
        VisConFig.PointerIcons = gVisConFig.PointerIcons;
        VisConFig.DftCmap = gVisConFig.DftCmap;
        gVisConFig = VisConFig;
        set(hFig, 'DeleteFcn', []);
        delete(hFig);
    elseif strcmpi(gVisConState, 'NewFig')
        return;
    end
else
    ScrSize = get(0,'ScreenSize');
    FigPos = [ScrSize(1,[3,4])/2-[360,240],720,480];
    Icons = load(fullfile(gVisConFig.VisConPath,'Resources','Icons.dat'),'-mat');
    Cmaps = load(fullfile(gVisConFig.VisConPath,'Resources','Cmaps.dat'),'-mat');
    gVisConFig.TbarIcons = Icons.TbarIcons;
    gVisConFig.PointerIcons = Icons.PointerIcons;
    gVisConFig.DftCmap = Cmaps.DftCmap;
end

figure('Name','VisualConnectome - Untitled','NumberTitle','off',...
    'Tag','VisConFig','Color','k','MenuBar','none','ToolBar','none',...
    'DeleteFcn','clear global gVisConFig gVisConNet gVisConSurf gVisConState;',...
    'Renderer','OpenGL','InvertHardcopy','off','BusyAction','cancel',...
    'PaperPositionMode','auto','NextPlot','new',...
    'Units','pixel','Position',FigPos);
VisCon_Menu();
VisCon_Toolbar();
gVisConState = 'NewFig';
end