classdef StepStats < handle
    properties (SetAccess = private)
        filename;
        interval;
        plot;
        button;
        values;
        timestamps;
        timeframe;
        
        stepstoday;
    end
    
    methods
        function o = StepStats(filename, interval, ...
                axes, timeframe, ...
                button)
            o.filename = filename;
            o.interval = interval;
            
            try
                file_contents = int64(dlmread(filename));
                o.timestamps = file_contents(:,1);
                o.values = uint16(file_contents(:,2));
                clear('file_contents');
            catch
                o.timestamps = uint64.empty();
                o.values = uint16.empty();
            end
            
            now = int64(posixtime(datetime('now')));
            secondsIn24h = 24*60*60;
            today_0am = now - int64(mod(now, secondsIn24h));
            try
                firstIndexOfToday = getStartIndexOfTimeStampInterval(o.timestamps, today_0am, o.interval);
                o.stepstoday = sum(o.values(firstIndexOfToday:end));
            catch
                o.stepstoday = 0;
            end
            
            o.timeframe  = timeframe;
            try
                [X_time, Y_values] = o.getPlotData;
                o.plot = bar(axes, X_time, Y_values);
                o.updateXLim;
            catch
                o.plot = bar(axes, datetime('now'), 0);
            end
            
            o.button = button;
        end
        
        function update(o, now, steps)
            o.values = [o.values; steps];
            o.timestamps = [o.timestamps; now];
            
            fileID = fopen(o.filename,'a');
            fprintf(fileID,'%d\t%d\r\n', now, steps);
            fclose(fileID);
            o.updateGUI;
            
            secondsIn24h = 24*60*60;
            if mod(now, secondsIn24h) == 0  % new day
                o.stepstoday = 0;
            else
                o.stepstoday = o.stepstoday + steps;
            end
        end
        
        function [time, values] = getPlotData(o)
            startPosition = getStartIndexOfTimeStampInterval(o.timestamps, o.timeframe, o.interval);
            time = datetime(o.timestamps(startPosition:end),'ConvertFrom','posixtime');
            values = o.values(startPosition:end);
        end
        
        function updateGUI(o)
            [X_time, Y_values] = o.getPlotData;
            set(o.plot, 'XData', X_time, 'YData', Y_values);
            o.updateXLim;
        end
        function updateXLim(o)
            startTime = datetime(o.timestamps(end) - o.timeframe,'ConvertFrom','posixtime');
            endTime   = datetime(o.timestamps(end),'ConvertFrom','posixtime');
            set(o.plot.Parent, 'XLim', [startTime,endTime]);
        end
        
        function updateStepCounter(o, steps)
            stepsTxt = char(string(o.stepstoday + steps));
            o.button.Text = stepsTxt;
        end
    end
end