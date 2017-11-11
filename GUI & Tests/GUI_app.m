classdef GUI_app < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        UIAxes                          matlab.ui.control.UIAxes
        UIAxes2                         matlab.ui.control.UIAxes
        UIAxes3                         matlab.ui.control.UIAxes
        GaugeLabel                      matlab.ui.control.Label
        Gauge                           matlab.ui.control.SemicircularGauge
        LaagLampLabel                   matlab.ui.control.Label
        LaagLamp                        matlab.ui.control.Lamp
        NormaalLampLabel                matlab.ui.control.Label
        NormaalLamp                     matlab.ui.control.Lamp
        HoogLampLabel                   matlab.ui.control.Label
        HoogLamp                        matlab.ui.control.Lamp
        LeeftijdEditFieldLabel          matlab.ui.control.Label
        LeeftijdEditField               matlab.ui.control.NumericEditField
        beatrateEditFieldLabel          matlab.ui.control.Label
        beatrateEditField               matlab.ui.control.NumericEditField
        OxygenSaturationEditFieldLabel  matlab.ui.control.Label
        OxygenSaturationEditField       matlab.ui.control.NumericEditField
        Label                           matlab.ui.control.Label
        MoredetailsButton               matlab.ui.control.StateButton
        LessdetailsButton               matlab.ui.control.Button
        ExtrainformationheartbeatPanel  matlab.ui.container.Panel
        minEditField_4Label             matlab.ui.control.Label
        minEditField_4                  matlab.ui.control.NumericEditField
        AverageheartbeatsLabel          matlab.ui.control.Label
        minEditField_2Label             matlab.ui.control.Label
        minEditField_2                  matlab.ui.control.NumericEditField
        EditFieldLabel                  matlab.ui.control.Label
        hourEditField                   matlab.ui.control.NumericEditField
        LasthourLabel                   matlab.ui.control.Label
        minEditField_3Label             matlab.ui.control.Label
        minEditField_3                  matlab.ui.control.NumericEditField
        maxEditFieldLabel               matlab.ui.control.Label
        maxEditField                    matlab.ui.control.NumericEditField
        UIAxes4                         matlab.ui.control.UIAxes
        OverviewactivitiesLabel         matlab.ui.control.Label        
        LaagLamp_2                      matlab.ui.control.Lamp
        NormaalLamp_2Label              matlab.ui.control.Label
        NormaalLamp_2                   matlab.ui.control.Lamp
        LaagLamp_2Label                 matlab.ui.control.Label
    end

    methods (Access = private)

        % Value changed function: MoredetailsButton
        function MoredetailsButtonValueChanged(app, event)
            value = app.MoredetailsButton.Value;
            app.ExtrainformationheartbeatPanel.Visible = 'on';
            app.LessdetailsButton.Visible = 'on';
            app.MoredetailsButton.Visible = 'off';

        end

        % Button pushed function: LessdetailsButton
        function LessdetailsButtonPushed(app, event)
            app.ExtrainformationheartbeatPanel.Visible = 'off';
            app.LessdetailsButton.Visible = 'off';
            app.MoredetailsButton.Visible = 'on';
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 640 650];
            app.UIFigure.Name = 'Slimme thuiszorgmonitor';
            setAutoResize(app, app.UIFigure, true)
            app.UIFigure.Color = [0.2 0.2 0.2];
  
            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            app.UIAxes.ColorOrder = [0 1 1;0.929411764705882 0.694117647058824 0.125490196078431;0.494117647058824 0.184313725490196 0.556862745098039;0.466666666666667 0.674509803921569 0.188235294117647;0.301960784313725 0.745098039215686 0.933333333333333;0.635294117647059 0.0784313725490196 0.184313725490196];
            app.UIAxes.TickDir = 'in';
            app.UIAxes.TickDirMode = 'manual';
            app.UIAxes.GridColor = [0 1 1];
            app.UIAxes.GridColorMode = 'manual';
            app.UIAxes.MinorGridColor = [0 1 1];
            app.UIAxes.MinorGridColorMode = 'manual';
            app.UIAxes.XColor = [0 1 1];
            app.UIAxes.XColorMode = 'manual';
            app.UIAxes.YColor = [0 1 1];
            app.UIAxes.YColorMode = 'manual';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [12 500 590 134];
            app.UIAxes.Color = [0 0 0];
            app.UIAxes.BackgroundColor = [0 0 0];
%             load('synchron_ecg_ppg_fs500.mat')
%             fs = 500; 
%             signal = synchronSignals.ecg;
%             startFrame = 1;
%             framesShown = 1800;
%             stopFrame = 5000;
%             x = (1:1:framesShown)./fs;
%             % close all;
%            % axes(handles.UIAxes)
%             while startFrame + framesShown <= stopFrame 
%                 %&& ishandle(handles.axes1)
%                 plot(app.UIAxes,x, signal(1, startFrame:startFrame + framesShown-1),'-');
%                 xlim([0 framesShown/fs*2]);
%                 pause(0.1); 
%                 startFrame = startFrame + 10; % met hoeveel samples de functie telkens verspringt   
%             end
            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            app.UIAxes2.ColorOrder = [1 0 1;0.850980392156863 0.325490196078431 0.0980392156862745;0.929411764705882 0.694117647058824 0.125490196078431;0.494117647058824 0.184313725490196 0.556862745098039;0.466666666666667 0.674509803921569 0.188235294117647;0.301960784313725 0.745098039215686 0.933333333333333;0.635294117647059 0.0784313725490196 0.184313725490196];
            app.UIAxes2.GridColor = [1 0 1];
            app.UIAxes2.GridColorMode = 'manual';
            app.UIAxes2.MinorGridColor = [1 0 1];
            app.UIAxes2.MinorGridColorMode = 'manual';
            app.UIAxes2.XColor = [1 0 1];
            app.UIAxes2.XColorMode = 'manual';
            app.UIAxes2.YColor = [1 0 1];
            app.UIAxes2.YColorMode = 'manual';
            app.UIAxes2.YGrid = 'on';
            app.UIAxes2.Position = [12 222 590 134];
            app.UIAxes2.Color = [0 0 0];
            app.UIAxes2.BackgroundColor = [0 0 0];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.UIFigure);
            app.UIAxes3.ColorOrder = [1 0 1;0.850980392156863 0.325490196078431 0.0980392156862745;0.929411764705882 0.694117647058824 0.125490196078431;0.494117647058824 0.184313725490196 0.556862745098039;0.466666666666667 0.674509803921569 0.188235294117647;0.301960784313725 0.745098039215686 0.933333333333333;0.635294117647059 0.0784313725490196 0.184313725490196];
            app.UIAxes3.GridColor = [1 0 1];
            app.UIAxes3.GridColorMode = 'manual';
            app.UIAxes3.MinorGridColor = [1 0 1];
            app.UIAxes3.MinorGridColorMode = 'manual';
            app.UIAxes3.XColor = [1 0 1];
            app.UIAxes3.XColorMode = 'manual';
            app.UIAxes3.YColor = [1 0 1];
            app.UIAxes3.YColorMode = 'manual';
            app.UIAxes3.YGrid = 'on';
            app.UIAxes3.Position = [12 105 590 134];
            app.UIAxes3.Color = [0 0 0];
            app.UIAxes3.BackgroundColor = [0 0 0];
            
            % Create LeeftijdEditFieldLabel
            app.LeeftijdEditFieldLabel = uilabel(app.UIFigure);
            app.LeeftijdEditFieldLabel.HorizontalAlignment = 'right';
            app.LeeftijdEditFieldLabel.FontWeight = 'bold';
            app.LeeftijdEditFieldLabel.Position = [448.03125 469 37 15];
            app.LeeftijdEditFieldLabel.Text = 'Age';
            app.LeeftijdEditFieldLabel.FontColor = [1 1 1];

            % Create LeeftijdEditField            
            app.LeeftijdEditField = uieditfield(app.UIFigure, 'numeric');
            app.LeeftijdEditField.Limits = [0 110];
            app.LeeftijdEditField.ValueDisplayFormat = '%.0f';
            app.LeeftijdEditField.FontWeight = 'bold';
            app.LeeftijdEditField.Position = [500.03125 465 100 22];
%             prompt = {'Enter your age:'};
%             dlg_title = ' Age ';
%             num_lines = 1;
%             defaultans = {'65'};
%             answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
%             app.LeeftijdEditField.Value = str2double(answer{1});

            app.LeeftijdEditField.Value = 55;
            app.LeeftijdEditField.FontColor = [1 1 1];
            app.LeeftijdEditField.BackgroundColor = [0 0 0];
            
            % Create beatrateEditFieldLabel
            app.beatrateEditFieldLabel = uilabel(app.UIFigure);
            app.beatrateEditFieldLabel.HorizontalAlignment = 'right';
            app.beatrateEditFieldLabel.VerticalAlignment = 'center';
            app.beatrateEditFieldLabel.FontWeight = 'bold';
            app.beatrateEditFieldLabel.FontSize = 28;
            app.beatrateEditFieldLabel.Position = [384.03125 385 103 55];
            app.beatrateEditFieldLabel.Text = 'beat rate ';
            app.beatrateEditFieldLabel.FontColor = [0 1 1];

            % Create beatrateEditField
            app.beatrateEditField = uieditfield(app.UIFigure, 'numeric');
            app.beatrateEditField.FontSize = 48;
            app.beatrateEditField.Limits = [0 240];
            app.beatrateEditField.ValueDisplayFormat = '%.0f';
            app.beatrateEditField.FontWeight = 'bold';
            app.beatrateEditField.FontColor = [0 1 1];
            app.beatrateEditField.BackgroundColor = [0 0 0];
            app.beatrateEditField.Position = [502.03125 385 100 58];
            app.beatrateEditField.Value = 220;

            % Create GaugeLabel
            app.GaugeLabel = uilabel(app.UIFigure);
            app.GaugeLabel.HorizontalAlignment = 'center';
            app.GaugeLabel.Position = [122 366 35 15];
            app.GaugeLabel.Text = '';

            % Create Gauge        
            app.Gauge = uigauge(app.UIFigure, 'semicircular');
            app.Gauge.Limits = [0 240];
            app.Gauge.MajorTicks = [0 40 80 120 160 200 240];
            app.Gauge.Position = [54 396 171 93];
            app.Gauge.BackgroundColor = [0.1 0.1 0.1];
            app.Gauge.FontColor = [0 1 1];
            app.Gauge.ScaleColorLimits = [0 60; 60 220-app.LeeftijdEditField.Value; 220-app.LeeftijdEditField.Value 240 ];
            app.Gauge.ScaleColors = [0 0 1; 0 1 0; 1 0 0];
            app.Gauge.Value = app.beatrateEditField.Value;

            % Create OxygenSaturationEditFieldLabel
            app.OxygenSaturationEditFieldLabel = uilabel(app.UIFigure);
            app.OxygenSaturationEditFieldLabel.HorizontalAlignment = 'right';
            app.OxygenSaturationEditFieldLabel.VerticalAlignment = 'center';
            app.OxygenSaturationEditFieldLabel.FontSize = 26;
            app.OxygenSaturationEditFieldLabel.FontWeight = 'bold';
            app.OxygenSaturationEditFieldLabel.Position = [292.53125 31 196 34];
            app.OxygenSaturationEditFieldLabel.Text = 'Oxygen Saturation';
            app.OxygenSaturationEditFieldLabel.FontColor = [1 0 1];

            % Create OxygenSaturationEditField
            app.OxygenSaturationEditField = uieditfield(app.UIFigure, 'numeric');
            app.OxygenSaturationEditField.FontSize = 48;
            app.OxygenSaturationEditField.FontColor = [1 0 1];
            app.OxygenSaturationEditField.BackgroundColor = [0 0 0];
            app.OxygenSaturationEditField.Position = [496 19 71 58];
            app.OxygenSaturationEditField.Value = 60;
            
            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.BackgroundColor = [0 0 0];
            app.Label.FontSize = 42;
            app.Label.FontColor = [1 0 1];
            app.Label.Position = [564 21 36 56];
            app.Label.Text = '%';

            % Create MoredetailsButton
            app.MoredetailsButton = uibutton(app.UIFigure, 'state');
            app.MoredetailsButton.ValueChangedFcn = createCallbackFcn(app, @MoredetailsButtonValueChanged, true);
            app.MoredetailsButton.Text = 'More details';
            app.MoredetailsButton.BackgroundColor = [0.101960784313725 0.101960784313725 0.101960784313725];
            app.MoredetailsButton.FontAngle = 'italic';
            app.MoredetailsButton.FontColor = [0 1 1];
            app.MoredetailsButton.Position = [387 375 100 22];

            % Create LessdetailsButton
            app.LessdetailsButton = uibutton(app.UIFigure, 'push');
            app.LessdetailsButton.ButtonPushedFcn = createCallbackFcn(app, @LessdetailsButtonPushed, true);
            app.LessdetailsButton.Visible = 'off';
            app.LessdetailsButton.BackgroundColor = [0.101960784313725 0.101960784313725 0.101960784313725];
            app.LessdetailsButton.FontColor = [0 1 1];
            app.LessdetailsButton.Position = [388 375 100 22];
            app.LessdetailsButton.Text = 'Less details';

            % Create ExtrainformationheartbeatPanel
            app.ExtrainformationheartbeatPanel = uipanel(app.UIFigure);
            app.ExtrainformationheartbeatPanel.Title = 'Extra information heartbeat';
            app.ExtrainformationheartbeatPanel.Visible = 'off';
            app.ExtrainformationheartbeatPanel.Position = [31 1 594 366];
            app.ExtrainformationheartbeatPanel.BackgroundColor = [0.3 0.3 0.3];
            
            % Create minEditField_4Label
            app.minEditField_4Label = uilabel(app.ExtrainformationheartbeatPanel);
            app.minEditField_4Label.HorizontalAlignment = 'right';
            app.minEditField_4Label.FontSize = 18;
            app.minEditField_4Label.Position = [33.03125 273 42 23];
            app.minEditField_4Label.Text = '1 min';
            app.minEditField_4Label.FontColor = [0 1 1];

            % Create minEditField_4
            app.minEditField_4 = uieditfield(app.ExtrainformationheartbeatPanel, 'numeric');
            app.minEditField_4.ValueDisplayFormat = '%.0f';
            app.minEditField_4.FontSize = 18;
            app.minEditField_4.Position = [90.03125 276 100 23];
            app.minEditField_4.Value = 140;
            app.minEditField_4.FontColor = [0 1 1];
            app.minEditField_4.BackgroundColor = [0.2 0.2 0.2];

            % Create AverageheartbeatsLabel
            app.AverageheartbeatsLabel = uilabel(app.ExtrainformationheartbeatPanel);
            app.AverageheartbeatsLabel.FontSize = 22;
            app.AverageheartbeatsLabel.Position = [33 305 175 29];
            app.AverageheartbeatsLabel.Text = 'Average heartbeats';
            app.AverageheartbeatsLabel.FontColor = [0 1 1];

            % Create minEditField_2Label
            app.minEditField_2Label = uilabel(app.ExtrainformationheartbeatPanel);
            app.minEditField_2Label.HorizontalAlignment = 'right';
            app.minEditField_2Label.FontSize = 18;
            app.minEditField_2Label.Position = [26.5 242 50 23];
            app.minEditField_2Label.Text = '10 min';
            app.minEditField_2Label.FontColor = [0 1 1];

            % Create minEditField_2
            app.minEditField_2 = uieditfield(app.ExtrainformationheartbeatPanel, 'numeric');
            app.minEditField_2.ValueDisplayFormat = '%.0f';
            app.minEditField_2.FontSize = 18;
            app.minEditField_2.Position = [91.03125 244 100 23];
            app.minEditField_2.Value = 141;
            app.minEditField_2.FontColor = [0 1 1];
            app.minEditField_2.BackgroundColor = [0.2 0.2 0.2];

            % Create EditFieldLabel
            app.EditFieldLabel = uilabel(app.ExtrainformationheartbeatPanel);
            app.EditFieldLabel.HorizontalAlignment = 'right';
            app.EditFieldLabel.FontSize = 18;
            app.EditFieldLabel.Position = [30 213 47 23];
            app.EditFieldLabel.Text = '1 hour';
            app.EditFieldLabel.FontColor = [0 1 1];


            % Create hourEditField
            app.hourEditField = uieditfield(app.ExtrainformationheartbeatPanel, 'numeric');
            app.hourEditField.ValueDisplayFormat = '%.0f';
            app.hourEditField.FontSize = 18;
            app.hourEditField.Position = [92.5 213 100 23];
            app.hourEditField.Value = 142;
            app.hourEditField.FontColor = [0 1 1];
            app.hourEditField.BackgroundColor = [0.2 0.2 0.2];

            % Create LasthourLabel
            app.LasthourLabel = uilabel(app.ExtrainformationheartbeatPanel);
            app.LasthourLabel.FontSize = 22;
            app.LasthourLabel.Position = [313 305 81 29];
            app.LasthourLabel.Text = 'Last hour';
            app.LasthourLabel.FontColor = [0 1 1];


            % Create minEditField_3Label
            app.minEditField_3Label = uilabel(app.ExtrainformationheartbeatPanel);
            app.minEditField_3Label.HorizontalAlignment = 'right';
            app.minEditField_3Label.FontSize = 18;
            app.minEditField_3Label.Position = [263.03125 260 29 23];
            app.minEditField_3Label.Text = 'min';
            app.minEditField_3Label.FontColor = [0 1 1];


            % Create minEditField_3
            app.minEditField_3 = uieditfield(app.ExtrainformationheartbeatPanel, 'numeric');
            app.minEditField_3.ValueDisplayFormat = '%.0f';
            app.minEditField_3.FontSize = 18;
            app.minEditField_3.Position = [307.03125 263 100 23];
            app.minEditField_3.Value = 160;
            app.minEditField_3.FontColor = [0 1 1];
            app.minEditField_3.BackgroundColor = [0.2 0.2 0.2];

            % Create maxEditFieldLabel
            app.maxEditFieldLabel = uilabel(app.ExtrainformationheartbeatPanel);
            app.maxEditFieldLabel.HorizontalAlignment = 'right';
            app.maxEditFieldLabel.FontSize = 18;
            app.maxEditFieldLabel.Position = [258.5 224 33 23];
            app.maxEditFieldLabel.Text = 'max';
            app.maxEditFieldLabel.FontColor = [0 1 1];


            % Create maxEditField
            app.maxEditField = uieditfield(app.ExtrainformationheartbeatPanel, 'numeric');
            app.maxEditField.ValueDisplayFormat = '%.0f';
            app.maxEditField.FontSize = 18;
            app.maxEditField.Position = [306.5 227 100 23];
            app.maxEditField.Value = 120;
            app.maxEditField.FontColor = [0 1 1];
            app.maxEditField.BackgroundColor = [0.2 0.2 0.2];
            

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.ExtrainformationheartbeatPanel);
            xlabel(app.UIAxes4, 'time');
            ylabel(app.UIAxes4, 'beat rate ');
            app.UIAxes4.XColor = [0 1 1];
            app.UIAxes4.XColorMode = 'manual';
            app.UIAxes4.YColor = [0 1 1];
            app.UIAxes4.YColorMode = 'manual';
            app.UIAxes4.Color = [0.2 0.2 0.2];
            app.UIAxes4.Position = [43 0 505 192];
            app.UIAxes4.BackgroundColor = [0.3 0.3 0.3];
            app.UIAxes4.ColorOrder = [0 1 1;0.850980392156863 0.325490196078431 0.0980392156862745;0.929411764705882 0.694117647058824 0.125490196078431;0.494117647058824 0.184313725490196 0.556862745098039;0.466666666666667 0.674509803921569 0.188235294117647;0.301960784313725 0.745098039215686 0.933333333333333;0.635294117647059 0.0784313725490196 0.184313725490196];
            
            % Create OverviewactivitiesLabel
            app.OverviewactivitiesLabel = uilabel(app.ExtrainformationheartbeatPanel);
            app.OverviewactivitiesLabel.FontSize = 16;
            app.OverviewactivitiesLabel.FontWeight = 'bold';
            app.OverviewactivitiesLabel.Position = [253 191 124 17];
            app.OverviewactivitiesLabel.Text = 'Overview activities';
            app.OverviewactivitiesLabel.FontColor = [0 1 1];
            
            % Create LaagLampLabel
            app.LaagLampLabel = uilabel(app.UIFigure);
            app.LaagLampLabel.HorizontalAlignment = 'right';
            app.LaagLampLabel.Position = [263.625 462 27 15];
            app.LaagLampLabel.Text = 'Low';
            app.LaagLampLabel.FontColor = [0 1 1];

            % Create LaagLamp
            app.LaagLamp = uilamp(app.UIFigure);
            app.LaagLamp.Position = [305.625 459 20 20];
            if app.beatrateEditField.Value <= 60
               app.LaagLamp.Color = [0 0 1];
            else
               app.LaagLamp.Color = [0.1 0.1 0.1];
            end

            % Create NormaalLampLabel
            app.NormaalLampLabel = uilabel(app.UIFigure);
            app.NormaalLampLabel.HorizontalAlignment = 'right';
            app.NormaalLampLabel.Position = [247.09375 435 43 15];
            app.NormaalLampLabel.Text = 'Normal';
            app.NormaalLampLabel.FontColor = [0 1 1];
            

            % Create NormaalLamp
            app.NormaalLamp = uilamp(app.UIFigure);
            app.NormaalLamp.Position = [305.09375 432 20 20];
            if app.beatrateEditField.Value > 60 && app.beatrateEditField.Value < 220-app.LeeftijdEditField.Value
               app.NormaalLamp.Color = [0 1 0];
            else
               app.NormaalLamp.Color = [0.1 0.1 0.1];
            end

            % Create HoogLampLabel
            app.HoogLampLabel = uilabel(app.UIFigure);
            app.HoogLampLabel.HorizontalAlignment = 'right';
            app.HoogLampLabel.Position = [261.09375 407 29 15];
            app.HoogLampLabel.Text = 'High';
            app.HoogLampLabel.FontColor = [0 1 1];
            
            % Create HoogLamp
            app.HoogLamp = uilamp(app.UIFigure);
            app.HoogLamp.Position = [305.09375 404 20 20];
            if app.beatrateEditField.Value > 220-app.LeeftijdEditField.Value
               app.HoogLamp.Color = [1 0 0];
%                [d,fs] = audioread('SmokeAlarm.mp3');
%                sound(d,fs)
            else
               app.HoogLamp.Color = [0.1 0.1 0.1];
            end
            
            % Create LaagLamp_2
            app.LaagLamp_2 = uilamp(app.UIFigure);
            app.LaagLamp_2.Position = [208.625 64 20 20];
            app.LaagLamp_2.Color = [0 0 1];

            % Create NormaalLamp_2Label
            app.NormaalLamp_2Label = uilabel(app.UIFigure);
            app.NormaalLamp_2Label.HorizontalAlignment = 'right';
            app.NormaalLamp_2Label.Position = [150 22 43 15];
            app.NormaalLamp_2Label.Text = 'Normaal';
            app.NormaalLamp_2Label.FontColor = [1 0 1];


            % Create NormaalLamp_2
            app.NormaalLamp_2 = uilamp(app.UIFigure);
            app.NormaalLamp_2.Position = [208.09375 19 20 20];

            % Create LaagLamp_2Label
            app.LaagLamp_2Label = uilabel(app.UIFigure);
            app.LaagLamp_2Label.HorizontalAlignment = 'right';
            app.LaagLamp_2Label.Position = [150 67 43 15];
            app.LaagLamp_2Label.Text = 'Laag';
            app.LaagLamp_2Label.FontColor = [1 0 1];

            
        end
    end

    methods (Access = public)

        % Construct app
        function app = GUI_app()

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end