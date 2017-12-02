classdef Stats < handle
    properties (SetAccess = private)
        filename;
        interval;
        plot;
        minfield;
        maxfield;
        avgfield;
        average = Average;
        values;
        timestamps;
        timeframe;
    end
    
    methods
        function o = Stats(filename, interval, ...
                axes, buttongroup, ...
                minfield, maxfield, avgfield)
            o.filename = filename;
            o.interval = interval;
            o.minfield = minfield;
            o.maxfield = maxfield;
            o.avgfield = avgfield;
            
            try
                file_contents = double(dlmread(filename));
                o.values = file_contents(:,2);
                clear('file_contents');
            catch
                o.values = double.empty();
            end
            try
                file_contents = int64(dlmread(filename));
                o.timestamps = file_contents(:,1);
                clear('file_contents');
            catch
                o.timestamps = double.empty();
            end
            o.timeframe  = buttongroup.SelectedObject.UserData;
            buttongroup.SelectionChangedFcn = @o.SelectionChange;
            [X_time, Y_values] = o.getPlotData;
            o.plot = plot(axes, X_time, Y_values, '-o');
            o.updateXLim;
            o.updateMinMaxAvg(Y_values);
        end
        
        function add(o, new) % every second
            o.average.add(new);
        end
        
        function update(o, now)
            value = o.average.getAverage;
            o.average.reset;
            if value == 0
                return
            end
            
            o.values = [o.values; value]; % TODO: doesn't work if o.values is empty
            o.timestamps = [o.timestamps; now];
            
            fileID = fopen(o.filename,'a');
            fprintf(fileID,'%d\t%f\r\n', now, value);
            fclose(fileID);
            o.updateGUI;
        end
        
        function SelectionChange(o, ~, ev) % object, buttongroup, event
            o.timeframe = ev.NewValue.UserData; % UserData contains number of seconds in the desired time frame
            o.updateGUI;
        end
        
        function [time, values] = getPlotData(o)
            startPosition = max([1, length(o.timestamps) - o.timeframe/o.interval]);
            while o.timestamps(startPosition) < o.timestamps(end) - o.timeframe
                startPosition = startPosition + 1;
            end
            time = datetime(o.timestamps(startPosition:end),'ConvertFrom','posixtime');
            values = o.values(startPosition:end);
        end
        
        function updateGUI(o)
            [X_time, Y_values] = o.getPlotData;
            set(o.plot, 'XData', X_time, 'YData', Y_values);
            o.updateXLim;
            o.updateMinMaxAvg(Y_values);
        end
        function updateXLim(o)
            startTime = datetime(o.timestamps(end) - o.timeframe,'ConvertFrom','posixtime');
            endTime   = datetime(o.timestamps(end),'ConvertFrom','posixtime');
            set(o.plot.Parent, 'XLim', [startTime,endTime]);
        end
        function updateMinMaxAvg(o, Y_values)
            o.minfield.Value = round(min(Y_values), 1);
            o.maxfield.Value = round(max(Y_values), 1);
            o.avgfield.Value = round(mean(Y_values), 1);
        end
        
    end
end