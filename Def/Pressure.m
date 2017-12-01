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
        lamp_HL;
        lamp_TL;
        lamp_HR;
        lamp_TR;
    end
    methods
        function o = Pressure(PresHighThreshold, PresLowThreshold, ...
                feetAxes, colorBarAxes, ...
                lamp_HL, lamp_TL, lamp_HR, lamp_TR)
            o.PresHL = 0; % Heel Left
            o.PresTL = 0; % Toes Left
            o.PresHR = 0; % Heel Right
            o.PresTR = 0; % Toes Right

            o.PresL_stepCtr = StepCounter(PresHighThreshold, PresLowThreshold);
            o.PresR_stepCtr = StepCounter(PresHighThreshold, PresLowThreshold);

            o.stepsPerQuarter = double.empty();

            imshow('GUI_footImage.png','Parent',feetAxes);
            imshow('GUI_colorBarImage.jpg', 'Parent', colorBarAxes);
            
            o.lamp_HL = lamp_HL;
            o.lamp_TL = lamp_TL;
            o.lamp_HR = lamp_HR;
            o.lamp_TR = lamp_TR;
        end
        
        function draw(o)
            if o.dirty_feet
                % Heel Left
                [r, g, b] = step_color_category(double(o.PresHL));
                o.lamp_HL.Color = [r, g, b];
                % Toes Left
                [r, g, b] = step_color_category(double(o.PresTL));
                o.lamp_TL.Color = [r, g, b];
                % Heel Right
                [r, g, b] = step_color_category(double(o.PresHR));
                o.lamp_HR.Color = [r, g, b];
                % Toes Right
                [r, g, b] = step_color_category(double(o.PresTR));
                o.lamp_TR.Color = [r, g, b];
                o.dirty_feet = false;
            end
        end
        
        function add_HL(o, value)
            o.PresHL = value;
            o.PresL_stepCtr.add(value);
            o.dirty_feet = true;
        end
        function add_TL(o, value)
            o.PresTL = value;
            o.dirty_feet = true;
        end
        function add_HR(o, value)
            o.PresHR = value;
            o.PresR_stepCtr.add(value);
            o.dirty_feet = true;
        end
        function add_TR(o, value)
            o.PresTR = value;
            o.dirty_feet = true;
        end
        
        function saveSteps(o)
            steps = o.PresL_stepCtr.steps + o.PresR_stepCtr.steps;
            disp(strcat({'Steps last 15 min: '}, string(steps)));
            o.stepsPerQuarter = [o.stepsPerQuarter steps];
            fileID = fopen('Steps.csv','a');
            fprintf(fileID,'%d\t%d\r\n', now, steps);
            fclose(fileID);
        end
        
        function resetSteps(o)
            o.PresL_stepCtr.reset;
            o.PresR_stepCtr.reset;
        end
    end
end