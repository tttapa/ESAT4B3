gui = appdruksensor;

%% beeld het percentage af op de gauge
% gui.StepsLabel.Value = 700;        % totaal aantal gezette stappen, via callback
% gui.DailygoalEditField.Value = 10000;    % waarde die zelf ingevuld kan worden
% percentage = (gui.StepsEditField.Value/gui.DailygoalEditField.Value)*100;
% gui.Gauge.ScaleColorLimits = [0 percentage];
% gui.Gauge.Value = percentage;



huelb = 1023;
huelf = 723;
huerb = 500;
huerf = 900;

%% functie die de druk per deel van de voet aanduidt
% left back (lb)
[rflb gflb bflb] = step_color_category(huelb);                                % via callback
gui.Lamplb.Color = [rflb gflb bflb];

% left front (lf)
[rflf gflf bflf] = step_color_category(huelf);                                % via callback
gui.Lamplf.Color = [rflf gflf bflf];

% right back (rb)
[rfrb gfrb bfrb] = step_color_category(huerb);                                % via callback
gui.Lamprb.Color = [rfrb gfrb bfrb];

% right front (rf)
[rfrf gfrf bfrf] = step_color_category(huerf);                                % via callback
gui.Lamprf.Color = [rfrf gfrf bfrf];



%% plot image

imshow('colorbar.jpg','Parent',gui.UIAxes2)

imshow('voet.jpg','Parent',gui.UIAxes)



