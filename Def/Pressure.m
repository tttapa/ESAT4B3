classdef Pressure < handle
    properties (SetAccess = private)
        PresHighThreshold;
        PresLowThreshold;
        dirty_feet = false;
        PresHL;
        PresTL;
        PresHR;
        PresTR;
        PresL_stepCtr;
        PresR_stepCtr;
        stepsPerQuarter;
        
        GraphPanel;
        feetAxes;
        lamp_HL;
        lamp_TL;
        lamp_HR;
        lamp_TR;
        circle;
        
        stats;
    end
    methods
        function o = Pressure(PresHighThreshold, PresLowThreshold, ...
                GraphPanel, feetAxes, colorBarAxes, ...
                lamp_HL, lamp_TL, lamp_HR, lamp_TR, ...
                stats)
            o.PresHL = 0; % Heel Left
            o.PresTL = 0; % Toes Left
            o.PresHR = 0; % Heel Right
            o.PresTR = 0; % Toes Right

            o.PresL_stepCtr = StepCounter(PresHighThreshold, PresLowThreshold);
            o.PresR_stepCtr = StepCounter(PresHighThreshold, PresLowThreshold);

            o.stepsPerQuarter = double.empty();

            o.GraphPanel = GraphPanel;
            o.feetAxes = feetAxes;
            hold(feetAxes, 'on');
            % set(feetAxes, 'XLim', [0 1], 'YLim', [0 1]);
            % *** Image is set in GUI_createGUI() ***
            %imshow('GUI_footImage.png','Parent',feetAxes);
            %imshow('GUI_colorBarImage.jpg', 'Parent', colorBarAxes);
            radius = 1;
            pos = [0 0];
            o.circle = rectangle(feetAxes,'Position',[pos pos+radius],'Curvature',[1 1]);
            
            o.lamp_HL = lamp_HL;
            o.lamp_TL = lamp_TL;
            o.lamp_HR = lamp_HR;
            o.lamp_TR = lamp_TR;
            
            o.stats = stats;
        end
        
        function draw(o)
            if o.dirty_feet && strcmp(o.GraphPanel.Visible, 'on')
                % Heel Left
                [r, g, b] = pressureToColor(double(o.PresHL));
                o.lamp_HL.Color = [r, g, b];
                colorsum = [r, g, b];
                % Toes Left
                [r, g, b] = pressureToColor(double(o.PresTL));
                o.lamp_TL.Color = [r, g, b];
                colorsum = colorsum + [r, g, b];
                % Heel Right
                [r, g, b] = pressureToColor(double(o.PresHR));
                o.lamp_HR.Color = [r, g, b];
                colorsum = colorsum + [r, g, b];
                % Toes Right
                [r, g, b] = pressureToColor(double(o.PresTR));
                o.lamp_TR.Color = [r, g, b];
                colorsum = colorsum + [r, g, b];
                set(o.circle, 'FaceColor', colorsum/4); % dirty hack to update lamps
                o.dirty_feet = false;
            end
        end
        
        function add_HL(o, value)
            o.PresHL = value;
            if o.PresL_stepCtr.add(value)
                o.stats.updateStepCounter(o.PresL_stepCtr.steps + o.PresR_stepCtr.steps);
            end
            o.dirty_feet = true;
        end
        function add_TL(o, value)
            o.PresTL = value;
            o.dirty_feet = true;
        end
        function add_HR(o, value)
            o.PresHR = value;
            if o.PresR_stepCtr.add(value)
                o.stats.updateStepCounter(o.PresL_stepCtr.steps + o.PresR_stepCtr.steps);
            end
            o.dirty_feet = true;
        end
        function add_TR(o, value)
            o.PresTR = value;
            o.dirty_feet = true;
        end
        
        function updateStats(o, now)
            steps = o.PresL_stepCtr.steps + o.PresR_stepCtr.steps; 
            o.stats.update(now, steps);
            o.PresL_stepCtr.reset;
            o.PresR_stepCtr.reset;
        end
    end
end