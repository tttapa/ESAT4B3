gui = app1;

% beeld het percentage af op de gauge
%gui.StepsLabel.Value = 700;        % totaal aantal gezette stappen, via callback
% gui.DailygoalEditField.Value = 10000;    % waarde die zelf ingevuld kan worden
% percentage = (gui.StepsEditField.Value/gui.DailygoalEditField.Value)*100;
% gui.Gauge.ScaleColorLimits = [0 percentage];
% gui.Gauge.Value = percentage;


% functie die de druk per deel van de voet aanduidt
% left back (lb)
[rflb gflb bflb] = step_color_category(huelb);                                % via callback
gui.TextArea.BackgroundColor = [rflb gflb bflb];


% left front (lf)
[rflf gflf bflf] = step_color_category(huelf);                                % via callback
gui.TextArea_2.BackgroundColor = [rflf gflf bflf];


% right front (rf)
[rfrf gfrf bfrf] = step_color_category(huerf);                                % via callback
gui.TextArea_3.BackgroundColor = [rfrf gfrf bfrf];


% right back (rb)
[rfrb gfrb bfrb] = step_color_category(huerb);                                % via callback
gui.TextArea_4.BackgroundColor = [rfrb gfrb bfrb];



% plot image
imshow('voet.jpg','Parent',gui.UIAxes)

