%VISCON_THRESUI Summary of this function goes here
%   Detailed explanation goes here
function VisCon_AbsThresDlg()
global gNetwork;

hFig=findobj('Tag','VisConFig');
FigPos=get(hFig,'Position');
DlgPos=[FigPos([1 2])+FigPos([3 4])/2-[200 0],400,100];

AbsThresDlg=dialog('Name','Absolute Threshold',...
    'Units','Pixel','Position',DlgPos);
MinThresSlider=uicontrol(AbsThresDlg,'Style','slider',...
    'Units','Pixel','Position',[45 55 250 16],...
    'Min',gNetwork.MinAdj,'Max',gNetwork.MaxAdj,...
    'Value',gNetwork.EdgeRange(1),...
    'Callback',@MinThresSliderFcn);
MaxThresSlider=uicontrol(AbsThresDlg,'Style','slider',...
    'Units','Pixel','Position',[45 15 250 16],...
    'Min',gNetwork.MinAdj,'Max',gNetwork.MaxAdj,...
    'Value',gNetwork.EdgeRange(2),...
    'Callback',@MaxThresSliderFcn);

MinThresEdit=uicontrol(AbsThresDlg,'Style','edit',...
    'Units','Pixel','Position',[340 54 50 20],...
    'String',sprintf('%.6f',gNetwork.EdgeRange(1)),...
    'Callback',@MinThresEditFcn);
MaxThresEdit=uicontrol(AbsThresDlg,'Style','edit',...
    'Units','Pixel','Position',[340 14 50 20],...
    'String',sprintf('%.6f',gNetwork.EdgeRange(2)),...
    'Callback',@MaxThresEditFcn);

MinThresCheck=uicontrol(AbsThresDlg,'Style','checkbox',...
    'Units','Pixel','Position',[5 75 160 14],...
    'Callback',@MinThresCheckFcn,...
    'String','Absolute Minimal Threshold',...
    'TooltipString','Edge with weight larger than this value will be retained');
MaxThresCheck=uicontrol(AbsThresDlg,'Style','checkbox',...
    'Units','Pixel','Position',[5 35 160 14],...
    'Callback',@MaxThresCheckFcn,...
    'String','Absolute Maximal Threshold',...
    'TooltipString','Edge with weight smaller than this value will be retained');

if gNetwork.EdgeRange(1)==gNetwork.MinAdj
    set(MinThresSlider,'Enable','off');
    set(MinThresEdit,'Enable','off');   
else
    set(MinThresCheck,'Value',1);
end

if gNetwork.EdgeRange(2)==gNetwork.MaxAdj
    set(MaxThresSlider,'Enable','off');
    set(MaxThresEdit,'Enable','off');   
else
    set(MaxThresCheck,'Value',1);
end

uicontrol(AbsThresDlg,'Style','text',...
    'Units','Pixel','Position',[5 55 35 16],...
    'String',sprintf('%.4f',gNetwork.MinAdj));
uicontrol(AbsThresDlg,'Style','text',...
    'Units','Pixel','Position',[5 15 35 16],...
    'String',sprintf('%.4f',gNetwork.MinAdj));
uicontrol(AbsThresDlg,'Style','text',...
    'Units','Pixel','Position',[300 55 35 16],...
    'String',sprintf('%.4f',gNetwork.MaxAdj));
uicontrol(AbsThresDlg,'Style','text',...
    'Units','Pixel','Position',[300 15 35 16],...
    'String',sprintf('%.4f',gNetwork.MaxAdj));

    function MinThresSliderFcn(Src,Evnt)
        MinThres=get(Src,'Value');
        MaxThres=get(MaxThresSlider,'Value');
        if MinThres>=MaxThres
            MinThres=MaxThres-0.000001;
            set(Src,'Value',MinThres);
        end
        set(MinThresEdit,'String',sprintf('%.6f',MinThres));
        set(0,'CurrentFigure',hFig);
        ThresholdEdges('absolute',MinThres,MaxThres);
    end

    function MaxThresSliderFcn(Src,Evnt)
        MinThres=get(MinThresSlider,'Value');
        MaxThres=get(Src,'Value');
        if MinThres>=MaxThres
            MaxThres=MinThres+0.000001;
            set(Src,'Value',MaxThres);
        end
        set(MaxThresEdit,'String',sprintf('%.6f',MaxThres));
        set(0,'CurrentFigure',hFig);
        ThresholdEdges('absolute',MinThres,MaxThres);
    end

    function MinThresEditFcn(Src,Evnt)
        MinThres=str2double(get(Src,'String'));
        MaxThres=get(MaxThresSlider,'Value');
        errmsg=sprintf('You must enter a number between\n%.6f and %.6f',...
            gNetwork.MinAdj,gNetwork.MaxAdj);
        if ~isnan(MinThres)
            if MinThres<gNetwork.MinAdj || MinThres>gNetwork.MaxAdj
                errordlg(errmsg,'Threshold error');
            end
        else
            errordlg(errmsg,'Threshold error');
        end
        if MinThres>=MaxThres
            MinThres=MaxThres-0.000001;
            set(Src,'String',sprintf('%.6f',MinThres));
        end
        set(MinThresSlider,'Value',MinThres);
        set(0,'CurrentFigure',hFig);
        ThresholdEdges('absolute',MinThres,MaxThres);
    end

    function MaxThresEditFcn(Src,Evnt)
        MinThres=get(MinThresSlider,'Value');
        MaxThres=str2double(get(Src,'String'));
        errmsg=sprintf('You must enter a number between\n%.6f and %.6f',...
            gNetwork.MinAdj,gNetwork.MaxAdj);
        if ~isnan(MaxThres)
            if MaxThres<gNetwork.MinAdj || MaxThres>gNetwork.MaxAdj
                errordlg(errmsg,'Threshold error');
            end
        else
            errordlg(errmsg,'Threshold error');
        end
        if MinThres>=MaxThres
            MaxThres=MinThres+0.000001;
            set(Src,'String',sprintf('%.6f',MinThres));
        end
        set(MaxThresSlider,'Value',MaxThres);
        set(0,'CurrentFigure',hFig);
        ThresholdEdges('absolute',MinThres,MaxThres);
    end

    function MinThresCheckFcn(Src,Evnt)
        State=get(Src,'Value');
        if State==1
            set(MinThresSlider,'Enable','on');
            set(MinThresEdit,'Enable','on');
        elseif State==0
            set(MinThresSlider,'Enable','off');
            set(MinThresEdit,'Enable','off');
        end
    end

    function MaxThresCheckFcn(Src,Evnt)
        State=get(Src,'Value');
        if State==1
            set(MaxThresSlider,'Enable','on');
            set(MaxThresEdit,'Enable','on');
        elseif State==0
            set(MaxThresSlider,'Enable','off');
            set(MaxThresEdit,'Enable','off');
        end
    end
          
end

