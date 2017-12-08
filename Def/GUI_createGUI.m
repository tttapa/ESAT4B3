function [ gui ] = GUI_createGUI()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


%%
% Define colors
%

mainBackgroundColor = [0.05 0.1 0.15];
secondaryBackgroundColor = [0.05 0.1 0.2];

headerBackgroundColor = [0.26 0.32 0.38];

buttonBackgroundColor = [0.15 0.18 0.23];

whiteColor = [1 1 1];
ecgColor = [0 0.8 0.8]; % originally [0 1 1]
ppgColor = [0.8 0 0.8]; % originally [1 0 1]
stepsColor = [0.8 0.8 0]; % originally [1 1 0]



%%
% Create GUI
%

gui = HealthVision;


%%
% Set colors
%


gui.HealthVisionUIFigure.Color = mainBackgroundColor;

% HeaderPanel
gui.HeaderPanel.BackgroundColor = headerBackgroundColor;

gui.HeaderTitleAxes.BackgroundColor = headerBackgroundColor;

%gui.HeaderAgeEditField.Limits = [0 110];
%gui.HeaderAgeEditField.FontColor = whiteColor;
%gui.HeaderAgeEditField.BackgroundColor = secondaryBackgroundColor;

%gui.HeaderUserEditField.FontColor = whiteColor;
%gui.HeaderUserEditField.BackgroundColor = secondaryBackgroundColor;

%gui.HeaderHeightEditField.FontColor = whiteColor;
%gui.HeaderHeightEditField.BackgroundColor = secondaryBackgroundColor;   

%gui.HeaderWeightEditField.FontColor = whiteColor;
%gui.HeaderWeightEditField.BackgroundColor = secondaryBackgroundColor;   

%   Mainpanel
gui.MainPanel.BackgroundColor = mainBackgroundColor;

% ButtonPanel 
gui.ButtonPanel.BackgroundColor = mainBackgroundColor;

gui.ECGButton.BackgroundColor = buttonBackgroundColor;
gui.ECGButton.FontColor = ecgColor;
gui.PPGButton.BackgroundColor = buttonBackgroundColor;
gui.PPGButton.FontColor = ppgColor;
gui.StepsButton.BackgroundColor = buttonBackgroundColor;
gui.StepsButton.FontColor = stepsColor;

gui.ECGLabel.FontColor = ecgColor;
gui.PPGLabel.FontColor = ppgColor;
gui.StepsLabel.FontColor = stepsColor;

%   InfoPanel
gui.InfoPanel.BackgroundColor = mainBackgroundColor;

% GraphPanel
gui.GraphPanel.BackgroundColor = mainBackgroundColor;

gui.ECGAxesHome.XColor = ecgColor;
gui.ECGAxesHome.XColorMode = 'manual';
gui.ECGAxesHome.YColor = ecgColor;
gui.ECGAxesHome.YColorMode = 'manual';
gui.ECGAxesHome.Color = secondaryBackgroundColor;
gui.ECGAxesHome.BackgroundColor = secondaryBackgroundColor;

gui.PPGAxesHome.GridColorMode = 'manual';
gui.PPGAxesHome.MinorGridColor = [0 0 0];
gui.PPGAxesHome.MinorGridColorMode = 'manual';
gui.PPGAxesHome.XColor = ppgColor;
gui.PPGAxesHome.XColorMode = 'manual';
gui.PPGAxesHome.YColor = ppgColor;
gui.PPGAxesHome.YColorMode = 'manual';
gui.PPGAxesHome.Color = secondaryBackgroundColor;
gui.PPGAxesHome.BackgroundColor = secondaryBackgroundColor;

gui.StepsAxesHome.XColor = stepsColor;
gui.StepsAxesHome.XColorMode = 'manual';
gui.StepsAxesHome.YColor = stepsColor;
gui.StepsAxesHome.YColorMode = 'manual';
gui.StepsAxesHome.Color = secondaryBackgroundColor;
gui.StepsAxesHome.BackgroundColor = secondaryBackgroundColor;

% PPGPanel
gui.PPGPanel.BackgroundColor = mainBackgroundColor;

gui.PPGAxesDetail1.BackgroundColor = secondaryBackgroundColor;
gui.PPGAxesDetail1.Color = secondaryBackgroundColor;
gui.PPGAxesDetail1.XColor = ppgColor;
gui.PPGAxesDetail1.YColor = ppgColor;

gui.PPGAxesDetail2.BackgroundColor = secondaryBackgroundColor;
gui.PPGAxesDetail2.Color = secondaryBackgroundColor;
gui.PPGAxesDetail2.XColor = ppgColor;
gui.PPGAxesDetail2.YColor = ppgColor;

gui.PPGAxesDetail3.BackgroundColor = secondaryBackgroundColor;
gui.PPGAxesDetail3.Color = secondaryBackgroundColor;
gui.PPGAxesDetail3.XColor = ppgColor;
gui.PPGAxesDetail3.YColor = ppgColor;

%gui.SPO2ValueEditField.BackgroundColor = buttonBackgroundColor;
%gui.SPO2ValueEditField.FontColor = ppgColor;
%gui.SPO2ValueEditField.Value = 88;

gui.PPGStatisticsButtonGroup.BackgroundColor = secondaryBackgroundColor;
gui.PPGStatisticsButtonGroup.ForegroundColor = ppgColor;

gui.PPGButton30m.FontColor = ppgColor;

gui.PPGButton2h.FontColor = ppgColor;

gui.PPGButton6h.FontColor = ppgColor;

gui.PPGMinLabel.FontColor = ppgColor;
gui.PPGMaxLabel.FontColor = ppgColor;
gui.PPGAvgLabel.FontColor = ppgColor;

gui.PPGLowLabel.FontColor = ppgColor;
gui.PPGNormalLabel.FontColor = ppgColor;

gui.PPGGauge.BackgroundColor = secondaryBackgroundColor;
gui.PPGGauge.FontColor = ppgColor;
gui.PPGGauge.ScaleColorLimits = [0 90; 90 100 ];
gui.PPGGauge.ScaleColors = [0 0 1; 0 1 0];

gui.PPGMinEditField.FontColor = ppgColor;
gui.PPGMinEditField.BackgroundColor = secondaryBackgroundColor;

gui.PPGMaxEditField.FontColor = ppgColor;
gui.PPGMaxEditField.BackgroundColor = secondaryBackgroundColor;

gui.PPGAvgEditField.FontColor = ppgColor;
gui.PPGAvgEditField.BackgroundColor = secondaryBackgroundColor;

gui.PPGLastTimeLabel.FontColor = ppgColor;

% ECGPanel
gui.ECGPanel.BackgroundColor = mainBackgroundColor;

gui.ECGAvgEditField.FontColor = ecgColor;
gui.ECGAvgEditField.BackgroundColor = secondaryBackgroundColor;

gui.ECGLastTimeLabel.FontColor = ecgColor;

gui.ECGMinEditField.FontColor = ecgColor;
gui.ECGMinEditField.BackgroundColor = secondaryBackgroundColor;

gui.ECGMaxEditField.FontColor = ecgColor;
gui.ECGMaxEditField.BackgroundColor = secondaryBackgroundColor;

gui.ECGGauge.BackgroundColor = secondaryBackgroundColor;
gui.ECGGauge.FontColor = ecgColor;

% Wordt gedaan in UserDataFcns.m
%gui.ECGGauge.ScaleColorLimits = [0 60; 60 220-gui.HeaderAgeEditField.Value; 220-gui.HeaderAgeEditField.Value 240 ];
gui.ECGGauge.ScaleColors = [0 0 1; 0 1 0; 1 0 0];

gui.ECGAxesDetail.XColor = ecgColor;
gui.ECGAxesDetail.YColor = ecgColor;
gui.ECGAxesDetail.Color = secondaryBackgroundColor;
gui.ECGAxesDetail.BackgroundColor = secondaryBackgroundColor;

gui.ECGStatisticsButtonGroup.ForegroundColor = ecgColor;
gui.ECGStatisticsButtonGroup.BackgroundColor = secondaryBackgroundColor;

gui.ECGButton30m.FontColor = ecgColor;

gui.ECGButton2h.FontColor = ecgColor;

gui.ECGButton6h.FontColor = ecgColor;

gui.ECGMinLabel.FontColor = ecgColor;

gui.ECGMaxLabel.FontColor = ecgColor;

gui.ECGAvgLabel.FontColor = ecgColor;

gui.ECGLowLabel.FontColor = ecgColor;

gui.ECGNormalLabel.FontColor = ecgColor;

gui.ECGHighLabel.FontColor = ecgColor;

% STEPSpanel
gui.StepsPanel.BackgroundColor = mainBackgroundColor;

gui.StepsGauge.BackgroundColor = secondaryBackgroundColor;
gui.StepsGauge.FontColor = stepsColor;  

gui.StepsProgressLabel.FontColor = stepsColor;

gui.StepsDailyGoalEditField.FontColor = stepsColor;
gui.StepsDailyGoalEditField.BackgroundColor = secondaryBackgroundColor;


gui.StepsAxesDetail1.BackgroundColor = secondaryBackgroundColor;
gui.StepsAxesDetail1.Color = secondaryBackgroundColor;

gui.StepsAxesDetail2.BackgroundColor = secondaryBackgroundColor;
gui.StepsAxesDetail2.Color = secondaryBackgroundColor;


% Images

[logoImage, ~, logoAlpha] = imread('GUI_logoTransparent.png');
[footImage, ~, footAlpha] = imread('GUI_footImage.png');
[colorBarImage, ~, colorBarAlpha] = imread('GUI_colorBarImage.jpg');

logoDat = imshow(logoImage, 'Parent', gui.HeaderTitleAxes);
footDat = imshow(footImage,'Parent',gui.StepsAxesDetail1);
colorBarDat = imshow(colorBarImage, 'Parent', gui.StepsAxesDetail2);

set(logoDat, 'AlphaData', logoAlpha);
set(footDat, 'AlphaData', footAlpha);
%set(colorBarDat, 'AlphaData', colorBarAlpha);


% Questions
%prompt = {'Enter your name:','Enter your age:','Enter your height(m):','Enter your weight(kg):'};
%dlg_title = ' Age ';
%num_lines = 1;
%defaultans = {'Jan Vermeulen','65','1.75','75'};
%answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
%gui.HeaderUserEditField.Value = answer{1};
%gui.HeaderAgeEditField.Value = str2double(answer{2});
%gui.HeaderHeightEditField.Value = str2double(answer{3});
%gui.HeaderWeightEditField.Value = str2double(answer{4});



end

