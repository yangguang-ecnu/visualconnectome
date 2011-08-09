function VisCon_Hint( Hint )
global gVisConFig;
if nargin == 0
    Hint = 'off';
end
if strcmpi(Hint, 'off')
    try
        delete(gVisConFig.hHint);
    end
    gVisConFig.hHint = NaN;
else
    if ishandle(gVisConFig.hHint)
        delete(gVisConFig.hHint);
    end
    hFig = findobj('Tag', 'VisConFig');
    FigPos = get(hFig, 'Position');
    gVisConFig.hHint = annotation('textbox','String', Hint, 'Color', [0.9 0.1 0.2],...
        'FontWeight', 'bold', 'FontSize', 10, 'HitTest', 'off',...
        'EdgeColor', [0.9 0.1 0.2], 'LineWidth', 1.5, 'VerticalAlignment', 'cap',...
        'Units', 'pixel', 'HorizontalAlignment', 'center', 'Interpreter', 'none',...
        'Position',[FigPos(3)/2 20 * FigPos(4)/480 10 20], 'FitBoxToText', 'on');
end
end

