function [ ] = GUI_setColors( gui )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here





 gui.HealthVisionUIFigure.Color = [0.05 0.1 0.15];

% HeaderPanel
  gui.HeaderPanel.BackgroundColor = [0.05 0.1 0.15];
 
  gui.HeaderAgeEditField.Limits = [0 110];
  gui.HeaderAgeEditField.FontColor = [1 1 1];
  gui.HeaderAgeEditField.BackgroundColor = [0.05 0.1 0.2];
 
  gui.HeaderUserEditField.FontColor = [1 1 1];
  gui.HeaderUserEditField.BackgroundColor = [0.05 0.1 0.2];
            
  gui.HeaderHeightEditField.FontColor = [1 1 1];
  gui.HeaderHeightEditField.BackgroundColor = [0.05 0.1 0.2];   
  
  gui.HeaderWeightEditField.FontColor = [1 1 1];
  gui.HeaderWeightEditField.BackgroundColor = [0.05 0.1 0.2];   
  
%   Mainpanel
  gui.MainPanel.BackgroundColor = [0.05 0.1 0.15];
  
% ButtoPanel 
  gui.ButtonPanel.BackgroundColor = [0.05 0.1 0.15];

  gui.ECGButton.BackgroundColor = [0.15 0.18 0.23];
  gui.ECGButton.FontColor = [0 1 1];
  gui.PPGButton.BackgroundColor = [0.15 0.18 0.23];
  gui.PPGButton.FontColor = [1 0 1];
  gui.StepsButton.BackgroundColor = [0.15 0.18 0.23];
  gui.StepsButton.FontColor = [1 1 0];
  
  gui.ECGLabel.FontColor = [0 1 1];
  gui.PPGLabel.FontColor = [1 0 1];
  gui.StepsLabel.FontColor = [1 1 0];
  
%   InfoPanel
gui.InfoPanel.BackgroundColor = [0.05 0.1 0.15];

% GraphPanel
gui.GraphPanel.BackgroundColor = [0.05 0.1 0.15];
  
gui.ECGAxesHome.XColor = [0 1 1];
gui.ECGAxesHome.XColorMode = 'manual';
gui.ECGAxesHome.YColor = [0 1 1];
gui.ECGAxesHome.YColorMode = 'manual';
gui.ECGAxesHome.Color = [0.05 0.1 0.2];
gui.ECGAxesHome.BackgroundColor = [0.05 0.1 0.2];

gui.PPGAxesHome.GridColorMode = 'manual';
gui.PPGAxesHome.MinorGridColor = [0 0 0];
gui.PPGAxesHome.MinorGridColorMode = 'manual';
gui.PPGAxesHome.XColor = [1 0 1];
gui.PPGAxesHome.XColorMode = 'manual';
gui.PPGAxesHome.YColor = [1 0 1];
gui.PPGAxesHome.YColorMode = 'manual';
gui.PPGAxesHome.Color = [0.05 0.1 0.2];
gui.PPGAxesHome.BackgroundColor = [0.05 0.1 0.2];

gui.StepsAxesHome.XColor = [1 1 0];
gui.StepsAxesHome.XColorMode = 'manual';
gui.StepsAxesHome.YColor = [1 1 0];
gui.StepsAxesHome.YColorMode = 'manual';
gui.StepsAxesHome.Color = [0.05 0.1 0.2];
gui.StepsAxesHome.BackgroundColor = [0.05 0.1 0.2];

% PPGPanel
gui.PPGPanel.BackgroundColor = [0.05 0.1 0.15];
            
gui.PPGAxesDetail1.BackgroundColor = [0.05 0.1 0.2];
gui.PPGAxesDetail1.Color = [0.05 0.1 0.2];
gui.PPGAxesDetail1.XColor = [1 0 1];
gui.PPGAxesDetail1.YColor = [1 0 1];

gui.PPGAxesDetail2.BackgroundColor = [0.05 0.1 0.2];
gui.PPGAxesDetail2.Color = [0.05 0.1 0.2];
gui.PPGAxesDetail2.XColor = [1 0 1];
gui.PPGAxesDetail2.YColor = [1 0 1];

gui.PPGAxesDetail3.BackgroundColor = [0.05 0.1 0.2];
gui.PPGAxesDetail3.Color = [0.05 0.1 0.2];
gui.PPGAxesDetail3.XColor = [1 0 1];
gui.PPGAxesDetail3.YColor = [1 0 1];

gui.SPO2ValueEditField.BackgroundColor = [0.15 0.18 0.23];
gui.SPO2ValueEditField.FontColor = [1 0 1];
gui.SPO2ValueEditField.Value = 88;

gui.PPGStatisticsButtonGroup.BackgroundColor = [0.05 0.1 0.2];
gui.PPGStatisticsButtonGroup.ForegroundColor = [1 0 1];

gui.PPGButton30m.FontColor = [1 0 1];

gui.PPGButton2h.FontColor = [1 0 1];

gui.PPGButton6h.FontColor = [1 0 1];

gui.PPGMinLabel.FontColor = [1 0 1];
gui.PPGMaxLabel.FontColor = [1 0 1];
gui.PPGAvgLabel.FontColor = [1 0 1];

gui.PPGLowLabel.FontColor = [1 0 1];
gui.PPGNormalLabel.FontColor = [1 0 1];

gui.PPGMinEditField.FontColor = [1 0 1];
gui.PPGMinEditField.BackgroundColor = [0.05 0.1 0.2];

gui.PPGMaxEditField.FontColor = [1 0 1];
gui.PPGMaxEditField.BackgroundColor = [0.05 0.1 0.2];

gui.PPGAvgEditField.FontColor = [1 0 1];
gui.PPGAvgEditField.BackgroundColor = [0.05 0.1 0.2];

gui.PPGLastTimeLabel.FontColor = [1 0 1];

% ECGPanel
gui.ECGPanel.BackgroundColor = [0.05 0.1 0.15];
                 
gui.ECGAvgEditField.FontColor = [0 1 1];
gui.ECGAvgEditField.BackgroundColor = [0.05 0.1 0.2];

gui.ECGLastTimeLabel.FontColor = [0 1 1];

gui.ECGMinEditField.FontColor = [0 1 1];
gui.ECGMinEditField.BackgroundColor = [0.05 0.1 0.2];

gui.ECGMaxEditField.FontColor = [0 1 1];
gui.ECGMaxEditField.BackgroundColor = [0.05 0.1 0.2];

gui.ECGGauge.BackgroundColor = [0.05 0.1 0.2];
gui.ECGGauge.FontColor = [0 1 1];
gui.ECGGauge.ScaleColorLimits = [0 60; 60 220-gui.HeaderAgeEditField.Value; 220-gui.HeaderAgeEditField.Value 240 ];
gui.ECGGauge.ScaleColors = [0 0 1; 0 1 0; 1 0 0];

gui.ECGAxesDetail.XColor = [0 1 1];
gui.ECGAxesDetail.YColor = [0 1 1];
gui.ECGAxesDetail.Color = [0.05 0.1 0.2];
gui.ECGAxesDetail.BackgroundColor = [0.05 0.1 0.2];

gui.ECGStatisticsButtonGroup.ForegroundColor = [0 1 1];
gui.ECGStatisticsButtonGroup.BackgroundColor = [0.05 0.1 0.2];

gui.ECGButton30m.FontColor = [0 1 1];

gui.ECGButton2h.FontColor = [0 1 1];

gui.ECGButton6h.FontColor = [0 1 1];

gui.ECGMinLabel.FontColor = [0 1 1];

gui.ECGMaxLabel.FontColor = [0 1 1];

gui.ECGAvgLabel.FontColor = [0 1 1];

gui.ECGLowLabel.FontColor = [0 1 1];

gui.ECGNormalLabel.FontColor = [0 1 1];

gui.ECGHighLabel.FontColor = [0 1 1];

% STEPSpanel
gui.StepsPanel.BackgroundColor = [0.05 0.1 0.15];

gui.StepsGauge.BackgroundColor = [0.05 0.1 0.2];
gui.StepsGauge.FontColor = [1 1 0];  

gui.StepsProgressLabel.FontColor = [1 1 0];

gui.StepsDailyGoalLabel.FontColor = [1 1 0];

gui.StepsAxesDetail1.BackgroundColor = [0.05 0.1 0.2];
gui.StepsAxesDetail1.Color = [0.05 0.1 0.2];

gui.StepsAxesDetail2.BackgroundColor = [0.05 0.1 0.2];
gui.StepsAxesDetail2.Color = [0.05 0.1 0.2];

% Questions
 prompt = {'Enter your name:','Enter your age:','Enter your lenght(m):','Enter your weight(kg):'};
 dlg_title = ' Age ';
 num_lines = 1;
 defaultans = {'Jan Vermeulen','65','1.75','75'};
 answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
 gui.HeaderUserEditField.Value = answer{1};
 gui.HeaderAgeEditField.Value = str2double(answer{2});
 gui.HeaderHeightEditField.Value = str2double(answer{3});
 gui.HeaderWeightEditField.Value = str2double(answer{4});






























%  gui.HealthVisionUIFigure.Color = [0.05 0.1 0.15];
%  
% % HeaderPanel
%   gui.HeaderPanel.BackgroundColor = [0.05 0.1 0.15];
%  
%   gui.HeaderAgeEditField.Limits = [0 110];
%   gui.HeaderAgeEditField.FontColor = [1 1 1];
%   gui.HeaderAgeEditField.BackgroundColor = [0.05 0.1 0.2];
%  
%   gui.HeaderUserEditField.FontColor = [1 1 1];
%   gui.HeaderUserEditField.BackgroundColor = [0.05 0.1 0.2];
%             
%   gui.HeaderHeightEditField.FontColor = [1 1 1];
%   gui.HeaderHeightEditField.BackgroundColor = [0.05 0.1 0.2];   
%   
%   gui.HeaderWeightEditField.FontColor = [1 1 1];
%   gui.HeaderWeightEditField.BackgroundColor = [0.05 0.1 0.2];   
%   
% %   Mainpanel
%   gui.MainPanel.BackgroundColor = [0.05 0.1 0.15];
%   
% % ButtoPanel 
%   gui.ButtonPanel.BackgroundColor = [0.05 0.1 0.15];
% 
%   gui.ECGButton.BackgroundColor = [0.15 0.18 0.23];
%   gui.ECGButton.FontColor = [0 1 1];
%   gui.PPGButton.BackgroundColor = [0.15 0.18 0.23];
%   gui.PPGButton.FontColor = [1 0 1];
%   gui.StepsButton.BackgroundColor = [0.15 0.18 0.23];
%   gui.StepsButton.FontColor = [1 1 0];
%   
%   gui.ECGLabel.FontColor = [0 1 1];
%   gui.PPGLabel.FontColor = [1 0 1];
%   gui.StepsLabel.FontColor = [1 1 0];
%   
% %   InfoPanel
% gui.InfoPanel.BackgroundColor = [0.05 0.1 0.15];
% 
% % GraphPanel
% gui.GraphPanel.BackgroundColor = [0.05 0.1 0.15];
%   
% gui.ECGAxesHome.XColor = [0 1 1];
% gui.ECGAxesHome.XColorMode = 'manual';
% gui.ECGAxesHome.YColor = [0 1 1];
% gui.ECGAxesHome.YColorMode = 'manual';
% gui.ECGAxesHome.Color = [0.05 0.1 0.2];
% gui.ECGAxesHome.BackgroundColor = [0.05 0.1 0.2];
% 
% gui.PPGAxesHome.GridColorMode = 'manual';
% gui.PPGAxesHome.MinorGridColor = [0 0 0];
% gui.PPGAxesHome.MinorGridColorMode = 'manual';
% gui.PPGAxesHome.XColor = [1 0 1];
% gui.PPGAxesHome.XColorMode = 'manual';
% gui.PPGAxesHome.YColor = [1 0 1];
% gui.PPGAxesHome.YColorMode = 'manual';
% gui.PPGAxesHome.Color = [0.05 0.1 0.2];
% gui.PPGAxesHome.BackgroundColor = [0.05 0.1 0.2];
% 
% gui.StepsAxesHome.XColor = [1 1 0];
% gui.StepsAxesHome.XColorMode = 'manual';
% gui.StepsAxesHome.YColor = [1 1 0];
% gui.StepsAxesHome.YColorMode = 'manual';
% gui.StepsAxesHome.Color = [0.05 0.1 0.2];
% gui.StepsAxesHome.BackgroundColor = [0.05 0.1 0.2];
% 
% % PPGPanel
% gui.PPGPanel.BackgroundColor = [0.05 0.1 0.15];
%             
% gui.PPGAxesDetail1.BackgroundColor = [0.05 0.1 0.2];
% gui.PPGAxesDetail1.Color = [0.05 0.1 0.2];
% gui.PPGAxesDetail1.XColor = [1 0 1];
% gui.PPGAxesDetail1.YColor = [1 0 1];
% 
% gui.PPGAxesDetail2.BackgroundColor = [0.05 0.1 0.2];
% gui.PPGAxesDetail2.Color = [0.05 0.1 0.2];
% gui.PPGAxesDetail2.XColor = [1 0 1];
% gui.PPGAxesDetail2.YColor = [1 0 1];
% 
% gui.PPGAxesDetail3.BackgroundColor = [0.05 0.1 0.2];
% gui.PPGAxesDetail3.Color = [0.05 0.1 0.2];
% gui.PPGAxesDetail3.XColor = [1 0 1];
% gui.PPGAxesDetail3.YColor = [1 0 1];
% 
% gui.SPO2ValueEditField.BackgroundColor = [0.15 0.18 0.23];
% gui.SPO2ValueEditField.FontColor = [1 0 1];
% gui.SPO2ValueEditField.Value = 88;
% 
% gui.PPGStatisticsButtonGroup.BackgroundColor = [0.05 0.1 0.2];
% gui.PPGStatisticsButtonGroup.ForegroundColor = [1 0 1];
% 
% gui.PPGButton30m.FontColor = [1 0 1];
% 
% gui.PPGButton2h.FontColor = [1 0 1];
% 
% gui.PPGButton6h.FontColor = [1 0 1];
% 
% gui.PPGMinLabel.FontColor = [1 0 1];
% gui.PPGMaxLabel.FontColor = [1 0 1];
% gui.PPGAvgLabel.FontColor = [1 0 1];
% 
% gui.PPGLowLabel.FontColor = [1 0 1];
% gui.PPGNormalLabel.FontColor = [1 0 1];
% 
% gui.PPGMinEditField.FontColor = [1 0 1];
% gui.PPGMinEditField.BackgroundColor = [0.05 0.1 0.2];
% 
% gui.PPGMaxEditField.FontColor = [1 0 1];
% gui.PPGMaxEditField.BackgroundColor = [0.05 0.1 0.2];
% 
% gui.PPGAvgEditField.FontColor = [1 0 1];
% gui.PPGAvgEditField.BackgroundColor = [0.05 0.1 0.2];
% 
% gui.PPGLastTimeLabel.FontColor = [1 0 1];
% 
% % ECGPanel
% gui.ECGPanel.BackgroundColor = [0.05 0.1 0.15];
%                  
% gui.ECGAvgEditField.FontColor = [0 1 1];
% gui.ECGAvgEditField.BackgroundColor = [0.05 0.1 0.2];
% 
% gui.ECGLastTimeLabel.FontColor = [0 1 1];
% 
% gui.ECGMinEditField.FontColor = [0 1 1];
% gui.ECGMinEditField.BackgroundColor = [0.05 0.1 0.2];
% 
% gui.ECGMaxEditField.FontColor = [0 1 1];
% gui.ECGMaxEditField.BackgroundColor = [0.05 0.1 0.2];
% 
% gui.ECGGauge.BackgroundColor = [0.05 0.1 0.2];
% gui.ECGGauge.FontColor = [0 1 1];
% gui.ECGGauge.ScaleColorLimits = [0 60; 60 220-gui.HeaderAgeEditField.Value; 220-gui.HeaderAgeEditField.Value 240 ];
% gui.ECGGauge.ScaleColors = [0 0 1; 0 1 0; 1 0 0];
% 
% gui.ECGAxesDetail.XColor = [0 1 1];
% gui.ECGAxesDetail.YColor = [0 1 1];
% gui.ECGAxesDetail.Color = [0.05 0.1 0.2];
% gui.ECGAxesDetail.BackgroundColor = [0.05 0.1 0.2];
% 
% gui.ECGStatisticsButtonGroup.Position = [32 178 129 144];
% gui.ECGStatisticsButtonGroup.ForegroundColor = [0 1 1];
% gui.ECGStatisticsButtonGroup.BackgroundColor = [0.05 0.1 0.2];
% 
% gui.ECGButton30m.FontColor = [0 1 1];
% gui.ECGButton2h.FontColor = [0 1 1];
% gui.ECGButton6h.FontColor = [0 1 1];
% 
% 
% gui.ECGMinLabel.FontColor = [0 1 1];
% gui.ECGMaxLabel.FontColor = [0 1 1];
% gui.ECGAvgLabel.FontColor = [0 1 1];
% 
% gui.ECGLowLabel.FontColor = [0 1 1];
% gui.ECGNormalLabel.FontColor = [0 1 1];
% gui.ECGHighLabel.FontColor = [0 1 1];
% 
% 
% % Steps Panel
% 
% gui.StepsPanel.BackgroundColor = [0.05 0.1 0.15];
% gui.StepsProgressLabel.FontColor = [1 1 0];
% gui.StepsDailyGoalLabel.FontColor = [1 1 0];
% 
% gui.StepsAxesDetail1.BackgroundColor = [0.05 0.1 0.15];
% gui.StepsAxesDetail2.BackgroundColor = [0.05 0.1 0.15];
% 
end

