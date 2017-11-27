function [ ] = GUI_loadStepsPanel( INPUT_gui )
%GUI_LOADSTEPSPANEL Summary of this function goes here
%   Detailed explanation goes here


%% beeld het percentage af op de gauge
% INPUT_gui.StepsLabel.Value = 700;        % totaal aantal gezette stappen, via callback
% INPUT_gui.DailygoalEditField.Value = 10000;    % waarde die zelf ingevuld kan worden
% percentage = (INPUT_gui.StepsEditField.Value/INPUT_gui.DailygoalEditField.Value)*100;
% INPUT_gui.Gauge.ScaleColorLimits = [0 percentage];
% INPUT_gui.Gauge.Value = percentage;



hueLB = 1;
hueLF = 100;
hueRB = 20;
hueRF = 900;

%% functie die de druk per deel van de voet aanduidt
% left back (lb)
[redLB, greenLB, blueLB] = step_color_category(hueLB);                                % via callback
INPUT_gui.StepsLampLB.Color = [redLB greenLB blueLB];

% left front (lf)
[redLF, greenLF, blueLF] = step_color_category(hueLF);                                % via callback
INPUT_gui.StepsLampLF.Color = [redLF greenLF blueLF];

% right back (rb)
[redRB, greenRB, blueRB] = step_color_category(hueRB);                                % via callback
INPUT_gui.StepsLampRB.Color = [redRB greenRB blueRB];

% right front (rf)
[redRF, greenRF, blueRF] = step_color_category(hueRF);                                % via callback
INPUT_gui.StepsLampRF.Color = [redRF greenRF blueRF];



%% plot image

imshow('GUI_footImage.jpg', 'Parent', INPUT_gui.StepsAxesDetail1)
imshow('GUI_colorBarImage.jpg', 'Parent', INPUT_gui.StepsAxesDetail2)

end

