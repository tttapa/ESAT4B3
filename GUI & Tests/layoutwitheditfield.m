classdef layoutwitheditfield < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        UIAxes                          matlab.ui.control.UIAxes
        UIAxes_2                        matlab.ui.control.UIAxes
        UIAxes_3                        matlab.ui.control.UIAxes
        EditField_2                     matlab.ui.control.NumericEditField
        EditField_3                     matlab.ui.control.NumericEditField
        SPO2Label                       matlab.ui.control.Label
        DRUKLabel                       matlab.ui.control.Label
        EditField_4                     matlab.ui.control.NumericEditField
        ECGLabel                        matlab.ui.control.Label
        ExtrainformationheartbeatPanel  matlab.ui.container.Panel
        AverageEditFieldLabel           matlab.ui.control.Label
        AverageEditField                matlab.ui.control.NumericEditField
        LasthourLabel                   matlab.ui.control.Label
        MinEditFieldLabel               matlab.ui.control.Label
        MinEditField                    matlab.ui.control.NumericEditField
        MaxEditFieldLabel               matlab.ui.control.Label
        MaxEditField                    matlab.ui.control.NumericEditField
        Label                           matlab.ui.control.Label
        Gauge                           matlab.ui.control.SemicircularGauge
        LowLampLabel                    matlab.ui.control.Label
        LowLamp                         matlab.ui.control.Lamp
        NormalLampLabel                 matlab.ui.control.Label
        NormalLamp                      matlab.ui.control.Lamp
        HighLampLabel                   matlab.ui.control.Label
        HighLamp                        matlab.ui.control.Lamp
        UIAxes2                         matlab.ui.control.UIAxes
        XButton                         matlab.ui.control.Button
        TimeButtonGroup                 matlab.ui.container.ButtonGroup
        minButton                       matlab.ui.control.RadioButton
        minButton_2                     matlab.ui.control.RadioButton
        hourButton                      matlab.ui.control.RadioButton
        LastminuteLabel                 matlab.ui.control.Label
        Last10minutesLabel              matlab.ui.control.Label
        ExtrainformationSPO2Panel       matlab.ui.container.Panel
        UIAxes3                         matlab.ui.control.UIAxes
        UIAxes4                         matlab.ui.control.UIAxes
        UIAxes6                         matlab.ui.control.UIAxes
        EditField_5                     matlab.ui.control.NumericEditField
        LowLamp_2Label                  matlab.ui.control.Label
        LowLamp_2                       matlab.ui.control.Lamp
        NormalLamp_2Label               matlab.ui.control.Label
        NormalLamp_2                    matlab.ui.control.Lamp
        TimeButtonGroup_2               matlab.ui.container.ButtonGroup
        minButton_3                     matlab.ui.control.RadioButton
        minButton_4                     matlab.ui.control.RadioButton
        hourButton_2                    matlab.ui.control.RadioButton
        LastminuteLabel_2               matlab.ui.control.Label
        MinEditField_2Label             matlab.ui.control.Label
        MinEditField_2                  matlab.ui.control.NumericEditField
        MaxEditField_2Label             matlab.ui.control.Label
        MaxEditField_2                  matlab.ui.control.NumericEditField
        AverageEditField_2Label         matlab.ui.control.Label
        AverageEditField_2              matlab.ui.control.NumericEditField
        XButton_2                       matlab.ui.control.Button
        Last10minutesLabel_2            matlab.ui.control.Label
        LasthourLabel_2                 matlab.ui.control.Label
        Panel                           matlab.ui.container.Panel
        AgeEditFieldLabel               matlab.ui.control.Label
        AgeEditField                    matlab.ui.control.NumericEditField
        UserEditFieldLabel              matlab.ui.control.Label
        UserEditField                   matlab.ui.control.EditField
        LengthEditFieldLabel            matlab.ui.control.Label
        LengthEditField                 matlab.ui.control.NumericEditField
        weightEditFieldLabel            matlab.ui.control.Label
        weightEditField                 matlab.ui.control.NumericEditField
        MoredetailsButton               matlab.ui.control.Button
        MoredetailsButton_2             matlab.ui.control.Button
        MoredetailsButton_3             matlab.ui.control.Button
    end

    methods (Access = private)

        % Button pushed function: MoredetailsButton
        function MoredetailsButtonPushed(app, event)
            app.ExtrainformationheartbeatPanel.Visible = 'on';
            app.MoredetailsButton.Visible = 'off';
        end

        % Button pushed function: XButton
        function XButtonPushed(app, event)
            app.ExtrainformationheartbeatPanel.Visible = 'off';
            app.MoredetailsButton.Visible = 'on'; 
        end

        % Selection changed function: TimeButtonGroup
        function TimeButtonGroupSelectionChanged(app, event)
            selectedButton = app.TimeButtonGroup.SelectedObject;
            if app.minButton.Value == true
                app.LastminuteLabel.Visible = 'on';
                app.Last10minutesLabel.Visible = 'off';
                app.LasthourLabel.Visible = 'off';
            elseif app.minButton_2.Value == true
                app.LastminuteLabel.Visible = 'off';
                app.Last10minutesLabel.Visible = 'on';
                app.LasthourLabel.Visible = 'off';
            else
                app.LastminuteLabel.Visible = 'off';
                app.Last10minutesLabel.Visible = 'off';
                app.LasthourLabel.Visible = 'on';
            end
        end

        % Button pushed function: MoredetailsButton_2
        function MoredetailsButton_2Pushed(app, event)
            app.ExtrainformationSPO2Panel.Visible = 'on';
            app.MoredetailsButton_2.Visible = 'off';
        end

        % Button pushed function: XButton_2
        function XButton_2Pushed(app, event)
            app.ExtrainformationSPO2Panel.Visible = 'off';
            app.MoredetailsButton_2.Visible = 'on';
        end

        % Selection changed function: TimeButtonGroup_2
        function TimeButtonGroup_2SelectionChanged(app, event)
            selectedButton = app.TimeButtonGroup_2.SelectedObject;
            if app.minButton_3.Value == true
                app.LastminuteLabel_2.Visible = 'on';
                app.Last10minutesLabel_2.Visible = 'off';
                app.LasthourLabel_2.Visible = 'off';
            elseif app.minButton_4.Value == true
                app.LastminuteLabel_2.Visible = 'off';
                app.Last10minutesLabel_2.Visible = 'on';
                app.LasthourLabel_2.Visible = 'off';
            else
                app.LastminuteLabel_2.Visible = 'off';
                app.Last10minutesLabel_2.Visible = 'off';
                app.LasthourLabel_2.Visible = 'on';
            end 
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Color = [0.05 0.1 0.15];
            app.UIFigure.Position = [100 100 947 691];
            app.UIFigure.Name = 'UI Figure';
            setAutoResize(app, app.UIFigure, true)
            
            % Create Panel
            app.Panel = uipanel(app.UIFigure);
            app.Panel.Title = 'Panel';
            app.Panel.BackgroundColor = [0.05 0.1 0.15];
            app.Panel.Position = [1 600 945 115];

            % Create AgeEditFieldLabel
            app.AgeEditFieldLabel = uilabel(app.Panel);
            app.AgeEditFieldLabel.HorizontalAlignment = 'right';
            app.AgeEditFieldLabel.FontColor = [1 1 1];
            app.AgeEditFieldLabel.Position = [735 60 25 15];
            app.AgeEditFieldLabel.Text = 'Age';

            % Create AgeEditField
            app.AgeEditField = uieditfield(app.Panel, 'numeric');
            app.AgeEditField.Limits = [0 110];
            app.AgeEditField.ValueDisplayFormat = '%.0f';
            app.AgeEditField.FontColor = [1 1 1];
            app.AgeEditField.BackgroundColor = [0.05 0.1 0.2];
            app.AgeEditField.Position = [791.03125 56 100 22];
            app.AgeEditField.Value = 55;

            % Create UserEditFieldLabel
            app.UserEditFieldLabel = uilabel(app.Panel);
            app.UserEditFieldLabel.HorizontalAlignment = 'right';
            app.UserEditFieldLabel.FontSize = 22;
            app.UserEditFieldLabel.FontColor = [1 1 1];
            app.UserEditFieldLabel.Position = [27 48 44 29];
            app.UserEditFieldLabel.Text = 'User';

            % Create UserEditField
            app.UserEditField = uieditfield(app.Panel, 'text');
            app.UserEditField.FontSize = 22;
            app.UserEditField.FontColor = [1 1 1];
            app.UserEditField.BackgroundColor = [0.05 0.1 0.2];
            app.UserEditField.Position = [86 49 224 31];

            % Create LengthEditFieldLabel
            app.LengthEditFieldLabel = uilabel(app.Panel);
            app.LengthEditFieldLabel.HorizontalAlignment = 'right';
            app.LengthEditFieldLabel.FontColor = [1 1 1];
            app.LengthEditFieldLabel.Position = [735 35 50 15];
            app.LengthEditFieldLabel.Text = 'Length(m)';

            % Create LengthEditField
            app.LengthEditField = uieditfield(app.Panel, 'numeric');
            app.LengthEditField.FontColor = [1 1 1];
            app.LengthEditField.BackgroundColor = [0.05 0.1 0.2];            
            app.LengthEditField.Position = [791.03125 31 100 22];

            % Create weightEditFieldLabel
            app.weightEditFieldLabel = uilabel(app.Panel);
            app.weightEditFieldLabel.HorizontalAlignment = 'right';
            app.weightEditFieldLabel.FontColor = [1 1 1];
            app.weightEditFieldLabel.Position = [735 10 50 15];
            app.weightEditFieldLabel.Text = 'Weight(kg)';

            % Create weightEditField
            app.weightEditField = uieditfield(app.Panel, 'numeric');
            app.weightEditField.FontColor = [1 1 1];
            app.weightEditField.BackgroundColor = [0.05 0.1 0.2];            
            app.weightEditField.Position = [791.5 6 100 22];
            
%             prompt = {'Enter your name:','Enter your age:','Enter your lenght(m):','Enter your weight(kg):'};
%             dlg_title = ' Age ';
%             num_lines = 1;
%             defaultans = {'Jan Vermeulen','65','1.75','75'};
%             answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
%             app.UserEditField.Value = answer{1};
%             app.AgeEditField.Value = str2double(answer{2});
%             app.LengthEditField.Value = str2double(answer{3});
%             app.weightEditField.Value = str2double(answer{4});

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            app.UIAxes.ColorOrder = [0 1 1;0.850980392156863 0.325490196078431 0.0980392156862745;0.929411764705882 0.694117647058824 0.125490196078431;0.494117647058824 0.184313725490196 0.556862745098039;0.466666666666667 0.674509803921569 0.188235294117647;0.301960784313725 0.745098039215686 0.933333333333333;0.635294117647059 0.0784313725490196 0.184313725490196];
            app.UIAxes.XColor = [0 1 1];
            app.UIAxes.XColorMode = 'manual';
            app.UIAxes.YColor = [0 1 1];
            app.UIAxes.YColorMode = 'manual';
            app.UIAxes.Color = [0.05 0.1 0.2];
            app.UIAxes.Position = [171 417 764 172];
            app.UIAxes.BackgroundColor = [0.05 0.1 0.2];

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.UIFigure);
            app.UIAxes_2.ColorOrder = [1 0 1;0.850980392156863 0.325490196078431 0.0980392156862745;0.929411764705882 0.694117647058824 0.125490196078431;0.494117647058824 0.184313725490196 0.556862745098039;0.466666666666667 0.674509803921569 0.188235294117647;0.301960784313725 0.745098039215686 0.933333333333333;0.635294117647059 0.0784313725490196 0.184313725490196];
            app.UIAxes_2.GridColor = [0 0 0];
            app.UIAxes_2.GridColorMode = 'manual';
            app.UIAxes_2.MinorGridColor = [0 0 0];
            app.UIAxes_2.MinorGridColorMode = 'manual';
            app.UIAxes_2.XColor = [1 0 1];
            app.UIAxes_2.XColorMode = 'manual';
            app.UIAxes_2.YColor = [1 0 1];
            app.UIAxes_2.YColorMode = 'manual';
            app.UIAxes_2.Color = [0.05 0.1 0.2];
            app.UIAxes_2.Position = [169 222 766 172];
            app.UIAxes_2.BackgroundColor = [0.05 0.1 0.2];


            % Create UIAxes_3
            app.UIAxes_3 = uiaxes(app.UIFigure);
            app.UIAxes_3.XColor = [1 1 0];
            app.UIAxes_3.XColorMode = 'manual';
            app.UIAxes_3.YColor = [1 1 0];
            app.UIAxes_3.YColorMode = 'manual';
            app.UIAxes_3.Color = [0.05 0.1 0.2];
            app.UIAxes_3.Position = [167 27 766 172];
            app.UIAxes_3.BackgroundColor = [0.05 0.1 0.2];


            % Create SPO2EditField
            app.EditField_2 = uieditfield(app.UIFigure, 'numeric');
            app.EditField_2.FontSize = 72;
            app.EditField_2.Position = [23.03125 235 120 143];
            app.EditField_2.BackgroundColor = [0.15 0.18 0.23];
            app.EditField_2.FontColor = [1 0 1];
            app.EditField_2.Value = 95;


            % Create STEPSEditField
            app.EditField_3 = uieditfield(app.UIFigure, 'numeric');
            app.EditField_3.FontSize = 48;
            app.EditField_3.BackgroundColor = [0.15 0.18 0.23];
            app.EditField_3.FontColor = [1 1 0];
            app.EditField_3.Position = [21.03125 44 120 138];
            app.EditField_3.Value = 1234;

            % Create SPO2Label
            app.SPO2Label = uilabel(app.UIFigure);
            app.SPO2Label.FontSize = 18;
            app.SPO2Label.FontColor = [1 0 1];
            app.SPO2Label.Position = [28 349 70 23];
            app.SPO2Label.Text = 'SPO2(%)';

            % Create STEPSLabel
            app.DRUKLabel = uilabel(app.UIFigure);
            app.DRUKLabel.FontSize = 18;
            app.DRUKLabel.FontColor = [1 1 0];
            app.DRUKLabel.Position = [28 149 50 23];
            app.DRUKLabel.Text = 'STEPS';

            % Create ECG Editfield Label
            app.EditField_4 = uieditfield(app.UIFigure, 'numeric');
            app.EditField_4.FontSize = 72;
            app.EditField_4.FontColor = [0 1 1];
            app.EditField_4.BackgroundColor = [0.15 0.18 0.23];
            app.EditField_4.Position = [23.03125 430 117 149];
            app.EditField_4.Value = 150;

            % Create ECGLabel
            app.ECGLabel = uilabel(app.UIFigure);
            app.ECGLabel.FontSize = 18;
            app.ECGLabel.FontColor = [0 1 1];
            app.ECGLabel.Position = [28 542 37 23];
            app.ECGLabel.Text = 'ECG';
            
            % Create MoredetailsButton
            app.MoredetailsButton = uibutton(app.UIFigure, 'push');
            app.MoredetailsButton.ButtonPushedFcn = createCallbackFcn(app, @MoredetailsButtonPushed, true);
            app.MoredetailsButton.FontAngle = 'italic';
            app.MoredetailsButton.Position = [35 437 100 22];
            app.MoredetailsButton.Text = 'More details';
            app.MoredetailsButton.FontColor = [0 1 1];
            app.MoredetailsButton.BackgroundColor = [0.05 0.1 0.2];

            % Create MoredetailsButton_2
            app.MoredetailsButton_2 = uibutton(app.UIFigure, 'push');
            app.MoredetailsButton_2.ButtonPushedFcn = createCallbackFcn(app, @MoredetailsButton_2Pushed, true);
            app.MoredetailsButton_2.FontAngle = 'italic';
            app.MoredetailsButton_2.Position = [35 243 100 22];
            app.MoredetailsButton_2.Text = 'More details';
            app.MoredetailsButton_2.FontColor = [1 0 1];
            app.MoredetailsButton_2.BackgroundColor = [0.05 0.1 0.2];

            % Create MoredetailsButton_3
            app.MoredetailsButton_3 = uibutton(app.UIFigure, 'push');
            app.MoredetailsButton_3.FontAngle = 'italic';
            app.MoredetailsButton_3.Position = [33 48 100 22];
            app.MoredetailsButton_3.Text = 'More details';
            app.MoredetailsButton_3.FontColor = [1 1 0];
            app.MoredetailsButton_3.BackgroundColor = [0.05 0.1 0.2];

            % Create ExtrainformationheartbeatPanel
            app.ExtrainformationheartbeatPanel = uipanel(app.UIFigure);
            app.ExtrainformationheartbeatPanel.Title = 'Extra information heartbeat';
            app.ExtrainformationheartbeatPanel.ForegroundColor = [0 1 1];
            app.ExtrainformationheartbeatPanel.Visible = 'off';
            app.ExtrainformationheartbeatPanel.FontSize = 20;
            app.ExtrainformationheartbeatPanel.Position = [23 27 916 382];
            app.ExtrainformationheartbeatPanel.BackgroundColor = [0.05 0.1 0.15];

            % Create AverageEditFieldLabel
            app.AverageEditFieldLabel = uilabel(app.ExtrainformationheartbeatPanel);
            app.AverageEditFieldLabel.HorizontalAlignment = 'right';
            app.AverageEditFieldLabel.FontSize = 24;
            app.AverageEditFieldLabel.Position = [202.5 178 79 31];
            app.AverageEditFieldLabel.Text = 'Average';
            app.AverageEditFieldLabel.FontColor = [0 1 1];

            % Create AverageEditField
            app.AverageEditField = uieditfield(app.ExtrainformationheartbeatPanel, 'numeric');
            app.AverageEditField.FontSize = 24;
            app.AverageEditField.Position = [296.5 178 100 30];
            app.AverageEditField.FontColor = [0 1 1];
            app.AverageEditField.BackgroundColor = [0.05 0.1 0.2];

            % Create LasthourLabel
            app.LasthourLabel = uilabel(app.ExtrainformationheartbeatPanel);
            app.LasthourLabel.Visible = 'off';
            app.LasthourLabel.FontSize = 24;
            app.LasthourLabel.Position = [301 300 88 31];
            app.LasthourLabel.Text = 'Last hour';
            app.LasthourLabel.FontColor = [0 1 1];


            % Create MinEditFieldLabel
            app.MinEditFieldLabel = uilabel(app.ExtrainformationheartbeatPanel);
            app.MinEditFieldLabel.HorizontalAlignment = 'right';
            app.MinEditFieldLabel.FontSize = 24;
            app.MinEditFieldLabel.Position = [245.03125 256 37 31];
            app.MinEditFieldLabel.Text = 'Min';
            app.MinEditFieldLabel.FontColor = [0 1 1];
            
            % Create MinEditField
            app.MinEditField = uieditfield(app.ExtrainformationheartbeatPanel, 'numeric');
            app.MinEditField.FontSize = 24;
            app.MinEditField.Position = [297.03125 260 100 30];
            app.MinEditField.FontColor = [0 1 1];
            app.MinEditField.BackgroundColor = [0.05 0.1 0.2];
            
            % Create MaxEditFieldLabel
            app.MaxEditFieldLabel = uilabel(app.ExtrainformationheartbeatPanel);
            app.MaxEditFieldLabel.HorizontalAlignment = 'right';
            app.MaxEditFieldLabel.FontSize = 24;
            app.MaxEditFieldLabel.Position = [238.5 217 43 31];
            app.MaxEditFieldLabel.Text = 'Max';
            app.MaxEditFieldLabel.FontColor = [0 1 1];
            

            % Create MaxEditField
            app.MaxEditField = uieditfield(app.ExtrainformationheartbeatPanel, 'numeric');
            app.MaxEditField.FontSize = 24;
            app.MaxEditField.Position = [296.5 221 100 30];
            app.MaxEditField.FontColor = [0 1 1];
            app.MaxEditField.BackgroundColor = [0.05 0.1 0.2];


            % Create Label
            app.Label = uilabel(app.ExtrainformationheartbeatPanel);
            app.Label.HorizontalAlignment = 'center';
            app.Label.Position = [576 234 25 15];
            app.Label.Text = '';

            % Create Gauge
            app.Gauge = uigauge(app.ExtrainformationheartbeatPanel, 'semicircular');
            app.Gauge.Limits = [0 240];
            app.Gauge.MajorTicks = [0 40 80 120 160 200 240];
            app.Gauge.Position = [455 176 216 117];
            app.Gauge.BackgroundColor = [0.05 0.1 0.2];
            app.Gauge.FontColor = [0 1 1];
            app.Gauge.ScaleColorLimits = [0 60; 60 220-app.AgeEditField.Value; 220-app.AgeEditField.Value 240 ];
            app.Gauge.ScaleColors = [0 0 1; 0 1 0; 1 0 0];
            app.Gauge.Value = app.EditField_4.Value;
            
            % Create LowLampLabel
            app.LowLampLabel = uilabel(app.ExtrainformationheartbeatPanel);
            app.LowLampLabel.HorizontalAlignment = 'right';
            app.LowLampLabel.FontSize = 24;
            app.LowLampLabel.Position = [770.625 260 42 31];
            app.LowLampLabel.Text = 'Low'; 
            app.LowLampLabel.FontColor = [0 1 1];

            % Create LowLamp
            app.LowLamp = uilamp(app.ExtrainformationheartbeatPanel);
            app.LowLamp.Position = [827.625 263 20 20];
            app.LowLamp.Color = [0 0 1];
            if app.EditField_4.Value <= 60
               app.LowLamp.Color = [0 0 1];
            else
               app.LowLamp.Color = [0.05 0.1 0.15];
            end

            % Create NormalLampLabel
            app.NormalLampLabel = uilabel(app.ExtrainformationheartbeatPanel);
            app.NormalLampLabel.HorizontalAlignment = 'right';
            app.NormalLampLabel.FontSize = 24;
            app.NormalLampLabel.Position = [744.09375 219 69 31];
            app.NormalLampLabel.Text = 'Normal';
            app.NormalLampLabel.FontColor = [0 1 1];

            % Create NormalLamp
            app.NormalLamp = uilamp(app.ExtrainformationheartbeatPanel);
            app.NormalLamp.Position = [828.09375 223 20 20];
            if app.EditField_4.Value > 60 && app.EditField_4.Value < 220-app.AgeEditField.Value
               app.NormalLamp.Color = [0 1 0];
            else
               app.NormalLamp.Color = [0.05 0.1 0.15];
            end

            % Create HighLampLabel
            app.HighLampLabel = uilabel(app.ExtrainformationheartbeatPanel);
            app.HighLampLabel.HorizontalAlignment = 'right';
            app.HighLampLabel.FontSize = 26;
            app.HighLampLabel.Position = [770.09375 176 49 34];
            app.HighLampLabel.Text = 'High';
            app.HighLampLabel.FontColor = [0 1 1];

            % Create HighLamp
            app.HighLamp = uilamp(app.ExtrainformationheartbeatPanel);
            app.HighLamp.Position = [828.09375 180 20 20];
            if app.EditField_4.Value > 220-app.AgeEditField.Value
               app.HighLamp.Color = [1 0 0];
%                [d,fs] = audioread('SmokeAlarm.mp3');
%                sound(d,fs)
            else
               app.HighLamp.Color = [0.05 0.1 0.15];
            end

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.ExtrainformationheartbeatPanel);
            xlabel(app.UIAxes2, 'Time');
            ylabel(app.UIAxes2, 'Heartbeat');
            app.UIAxes2.Position = [37 2 831 165];
            app.UIAxes2.XColor = [0 1 1];
            app.UIAxes2.YColor = [0 1 1];
            app.UIAxes2.Color = [0.05 0.1 0.2];
            app.UIAxes2.BackgroundColor = [0.05 0.1 0.2];

            % Create XButton
            app.XButton = uibutton(app.ExtrainformationheartbeatPanel, 'push');
            app.XButton.ButtonPushedFcn = createCallbackFcn(app, @XButtonPushed, true);
            app.XButton.FontSize = 18;
            app.XButton.FontColor = [1 0 0];
            app.XButton.Position = [885 321 31 30];
            app.XButton.Text = 'X';

            % Create TimeButtonGroup
            app.TimeButtonGroup = uibuttongroup(app.ExtrainformationheartbeatPanel);
            app.TimeButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @TimeButtonGroupSelectionChanged, true);
            app.TimeButtonGroup.Title = 'Time';
            app.TimeButtonGroup.FontSize = 24;
            app.TimeButtonGroup.Position = [32 178 129 144];
            app.TimeButtonGroup.ForegroundColor = [0 1 1];
            app.TimeButtonGroup.BackgroundColor = [0.05 0.1 0.2];
            
            % Create minButton
            app.minButton = uiradiobutton(app.TimeButtonGroup);
            app.minButton.Text = '1 min';
            app.minButton.FontSize = 24;
            app.minButton.Position = [11 67 70.125 31];
            app.minButton.Value = true;
            app.minButton.FontColor = [0 1 1];

            % Create minButton_2
            app.minButton_2 = uiradiobutton(app.TimeButtonGroup);
            app.minButton_2.Text = '10 min';
            app.minButton_2.FontSize = 24;
            app.minButton_2.Position = [11 45 81.078125 31];
            app.minButton_2.FontColor = [0 1 1];

            % Create hourButton
            app.hourButton = uiradiobutton(app.TimeButtonGroup);
            app.hourButton.Text = '1 hour';
            app.hourButton.FontSize = 24;
            app.hourButton.Position = [11 23 77.8125 31];
            app.hourButton.FontColor = [0 1 1];

            % Create LastminuteLabel
            app.LastminuteLabel = uilabel(app.ExtrainformationheartbeatPanel);
            app.LastminuteLabel.FontSize = 24;
            app.LastminuteLabel.Position = [301 300 107 31];
            app.LastminuteLabel.Text = 'Last minute';
            app.LastminuteLabel.FontColor = [0 1 1];

            % Create Last10minutesLabel
            app.Last10minutesLabel = uilabel(app.ExtrainformationheartbeatPanel);
            app.Last10minutesLabel.Visible = 'off';
            app.Last10minutesLabel.FontSize = 24;
            app.Last10minutesLabel.Position = [301 300 144 31];
            app.Last10minutesLabel.Text = 'Last 10 minutes';
            app.Last10minutesLabel.FontColor = [0 1 1];

            % Create ExtrainformationSPO2Panel
            app.ExtrainformationSPO2Panel = uipanel(app.UIFigure);
            app.ExtrainformationSPO2Panel.Title = 'Extra information SPO2';
            app.ExtrainformationSPO2Panel.Visible = 'off';
            app.ExtrainformationSPO2Panel.FontSize = 24;
            app.ExtrainformationSPO2Panel.Position = [21 14 925 577];
            app.ExtrainformationSPO2Panel.BackgroundColor = [0.05 0.1 0.15];
            app.ExtrainformationSPO2Panel.ForegroundColor = [1 0 1];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.ExtrainformationSPO2Panel);
            app.UIAxes3.Position = [14 306 898 123];
            app.UIAxes3.BackgroundColor = [0.05 0.1 0.2];
            app.UIAxes3.Color = [0.05 0.1 0.2];
            app.UIAxes3.XColor = [1 0 1];
            app.UIAxes3.YColor = [1 0 1];

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.ExtrainformationSPO2Panel);
            app.UIAxes4.Position = [14 208 890 111];
            app.UIAxes4.BackgroundColor = [0.05 0.1 0.2];
            app.UIAxes4.Color = [0.05 0.1 0.2];
            app.UIAxes4.XColor = [1 0 1];
            app.UIAxes4.YColor = [1 0 1];
            
            % Create UIAxes6
            app.UIAxes6 = uiaxes(app.ExtrainformationSPO2Panel);
            app.UIAxes6.Position = [348 30 556 154];
            app.UIAxes6.BackgroundColor = [0.05 0.1 0.2];
            app.UIAxes6.Color = [0.05 0.1 0.2];
            app.UIAxes6.XColor = [1 0 1];
            app.UIAxes6.YColor = [1 0 1];

            % Create EditField_5
            app.EditField_5 = uieditfield(app.ExtrainformationSPO2Panel, 'numeric');
            app.EditField_5.FontSize = 48;
            app.EditField_5.Position = [150.03125 441 87 87];
            app.EditField_5.BackgroundColor = [0.15 0.18 0.23];
            app.EditField_5.FontColor = [1 0 1];
            app.EditField_5.Value = app.EditField_2.Value;

            % Create LowLamp_2Label
            app.LowLamp_2Label = uilabel(app.ExtrainformationSPO2Panel);
            app.LowLamp_2Label.HorizontalAlignment = 'right';
            app.LowLamp_2Label.FontSize = 24;
            app.LowLamp_2Label.Position = [288.625 497 42 31];
            app.LowLamp_2Label.Text = 'Low';
            app.LowLamp_2Label.FontColor = [1 0 1];

            % Create LowLamp_2
            app.LowLamp_2 = uilamp(app.ExtrainformationSPO2Panel);
            app.LowLamp_2.Position = [345.625 502 20 20];
            if app.EditField_2.Value < 95
                app.LowLamp_2.Color = [0 0 1];
            else
                app.LowLamp_2.Color = [0.05 0.1 0.15];
            end

            % Create NormalLamp_2Label
            app.NormalLamp_2Label = uilabel(app.ExtrainformationSPO2Panel);
            app.NormalLamp_2Label.HorizontalAlignment = 'right';
            app.NormalLamp_2Label.FontSize = 24;
            app.NormalLamp_2Label.Position = [264.09375 441 69 31];
            app.NormalLamp_2Label.Text = 'Normal';
            app.NormalLamp_2Label.FontColor = [1 0 1];

            % Create NormalLamp_2
            app.NormalLamp_2 = uilamp(app.ExtrainformationSPO2Panel);
            app.NormalLamp_2.Position = [348.09375 446 20 20];
            if app.EditField_2.Value >= 95
                app.NormalLamp_2.Color = [0 1 0]
            else
                app.NormalLamp_2.Color = [0.05 0.1 0.15]
            end

            % Create TimeButtonGroup_2
            app.TimeButtonGroup_2 = uibuttongroup(app.ExtrainformationSPO2Panel);
            app.TimeButtonGroup_2.SelectionChangedFcn = createCallbackFcn(app, @TimeButtonGroup_2SelectionChanged, true);
            app.TimeButtonGroup_2.Title = 'Time';
            app.TimeButtonGroup_2.FontSize = 20;
            app.TimeButtonGroup_2.Position = [24 49 100 143];
            app.TimeButtonGroup_2.BackgroundColor = [0.05 0.1 0.2];
            app.TimeButtonGroup_2.ForegroundColor = [1 0 1];

            % Create minButton_3
            app.minButton_3 = uiradiobutton(app.TimeButtonGroup_2);
            app.minButton_3.Text = '1 min';
            app.minButton_3.FontSize = 20;
            app.minButton_3.Position = [11 76 62.109375 26];
            app.minButton_3.Value = true;
            app.minButton_3.FontColor = [1 0 1];

            % Create minButton_4
            app.minButton_4 = uiradiobutton(app.TimeButtonGroup_2);
            app.minButton_4.Text = '10 min';
            app.minButton_4.FontSize = 20;
            app.minButton_4.Position = [11 54 71.234375 26];
            app.minButton_4.FontColor = [1 0 1];


            % Create hourButton_2
            app.hourButton_2 = uiradiobutton(app.TimeButtonGroup_2);
            app.hourButton_2.Text = '1 hour';
            app.hourButton_2.FontSize = 20;
            app.hourButton_2.Position = [11 32 68.5 26];
            app.hourButton_2.FontColor = [1 0 1];

            % Create LastminuteLabel_2
            app.LastminuteLabel_2 = uilabel(app.ExtrainformationSPO2Panel);
            app.LastminuteLabel_2.FontSize = 24;
            app.LastminuteLabel_2.Position = [225 161 107 31];
            app.LastminuteLabel_2.Text = 'Last minute';
            app.LastminuteLabel_2.FontColor = [1 0 1];

            % Create MinEditField_2Label
            app.MinEditField_2Label = uilabel(app.ExtrainformationSPO2Panel);
            app.MinEditField_2Label.HorizontalAlignment = 'right';
            app.MinEditField_2Label.FontSize = 24;
            app.MinEditField_2Label.Position = [174.03125 125 37 31];
            app.MinEditField_2Label.Text = 'Min';
            app.MinEditField_2Label.FontColor = [1 0 1];

            % Create MinEditField_2
            app.MinEditField_2 = uieditfield(app.ExtrainformationSPO2Panel, 'numeric');
            app.MinEditField_2.FontSize = 24;
            app.MinEditField_2.Position = [226.03125 125 100 30];
            app.MinEditField_2.FontColor = [1 0 1];
            app.MinEditField_2.BackgroundColor = [0.05 0.1 0.2];

            % Create MaxEditField_2Label
            app.MaxEditField_2Label = uilabel(app.ExtrainformationSPO2Panel);
            app.MaxEditField_2Label.HorizontalAlignment = 'right';
            app.MaxEditField_2Label.FontSize = 24;
            app.MaxEditField_2Label.Position = [167.5 87 43 31];
            app.MaxEditField_2Label.Text = 'Max';
            app.MaxEditField_2Label.FontColor = [1 0 1];

            % Create MaxEditField_2
            app.MaxEditField_2 = uieditfield(app.ExtrainformationSPO2Panel, 'numeric');
            app.MaxEditField_2.FontSize = 24;
            app.MaxEditField_2.Position = [225.5 88 100 30];
            app.MaxEditField_2.FontColor = [1 0 1];
            app.MaxEditField_2.BackgroundColor = [0.05 0.1 0.2];
            
            % Create AverageEditField_2Label
            app.AverageEditField_2Label = uilabel(app.ExtrainformationSPO2Panel);
            app.AverageEditField_2Label.HorizontalAlignment = 'right';
            app.AverageEditField_2Label.FontSize = 24;
            app.AverageEditField_2Label.Position = [131.5 54 79 31];
            app.AverageEditField_2Label.Text = 'Average';
            app.AverageEditField_2Label.FontColor = [1 0 1];

            % Create AverageEditField_2
            app.AverageEditField_2 = uieditfield(app.ExtrainformationSPO2Panel, 'numeric');
            app.AverageEditField_2.FontSize = 24;
            app.AverageEditField_2.Position = [225.5 52 100 30];
            app.AverageEditField_2.FontColor = [1 0 1];
            app.AverageEditField_2.BackgroundColor = [0.05 0.1 0.2];
            
            % Create XButton_2
            app.XButton_2 = uibutton(app.ExtrainformationSPO2Panel, 'push');
            app.XButton_2.ButtonPushedFcn = createCallbackFcn(app, @XButton_2Pushed, true);
            app.XButton_2.FontSize = 20;
            app.XButton_2.FontWeight = 'bold';
            app.XButton_2.FontColor = [1 0 0];
            app.XButton_2.Position = [887 506 29 33];
            app.XButton_2.Text = 'X';

            % Create Last10minutesLabel_2
            app.Last10minutesLabel_2 = uilabel(app.ExtrainformationSPO2Panel);
            app.Last10minutesLabel_2.Visible = 'off';
            app.Last10minutesLabel_2.FontSize = 24;
            app.Last10minutesLabel_2.Position = [187 161 144 31];
            app.Last10minutesLabel_2.Text = 'Last 10 minutes';
            app.Last10minutesLabel_2.FontColor = [1 0 1];

            % Create LasthourLabel_2
            app.LasthourLabel_2 = uilabel(app.ExtrainformationSPO2Panel);
            app.LasthourLabel_2.Visible = 'off';
            app.LasthourLabel_2.FontSize = 24;
            app.LasthourLabel_2.Position = [245 161 88 31];
            app.LasthourLabel_2.Text = 'Last hour';
            app.LasthourLabel_2.FontColor = [1 0 1];

        end
    end

    methods (Access = public)

        % Construct app
        function app = layoutwitheditfield()

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