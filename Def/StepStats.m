classdef StepStats < handle
    properties (SetAccess = private)
        userdata;
        datafolder = 'Data';
        filename;
        interval;
        plot;
        button;
        values;
        timestamps;
        timeframe;
        progressGauge;
        
        stepstoday;
    end
    
    methods
        function o = StepStats(userdata, filename, interval, ...
                axes, timeframe, ...
                progressGauge, ...
                button)
            o.userdata = userdata;
            folder = fullfile(o.datafolder,o.userdata.name);
            % mkdir(folder); % TODO: remove
            o.filename = filename;
            o.interval = interval;
            
            file = fullfile(folder,o.filename);

            try
                file_contents = int64(dlmread(file));
                o.timestamps = file_contents(:,1);
                o.values = uint16(file_contents(:,2));
                clear('file_contents');
            catch
                o.timestamps = uint64.empty();
                o.values = uint16.empty();
            end
            
            now = getUnixTime;
            secondsIn24h = 24*60*60;
            today_12am = now - int64(mod(now, secondsIn24h));
            try
                firstIndexOfToday = getStartIndexOfTimeStamp(o.timestamps, today_12am, o.interval);
                o.stepstoday = sum(o.values(firstIndexOfToday:end));
            catch
                o.stepstoday = 0;
            end
            
            o.timeframe  = timeframe;
            try
                [X_time, Y_values] = o.getPlotData;
                o.plot = bar(axes, X_time, Y_values, 1);
                o.updateXLim;
            catch
                o.plot = bar(axes, datetime('now'), 0, 1, 'FaceColor',[1 1 0]);
            end
            
            o.progressGauge = progressGauge;
            o.button = button;
        end
        
        function update(o, now, steps)
            o.values = [o.values; steps];
            o.timestamps = [o.timestamps; now];
            
            folder = fullfile(o.datafolder,o.userdata.foldername);
            file = fullfile(folder,o.filename);

            fileID = fopen(file,'a');
            fprintf(fileID,'%d,%d\r\n', now, steps);
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
            if length(o.timestamps) < 2
                msgID = 'GETPLOTDATA:NoTimeData';
                msg = 'No time data is returned there are less than two entries';
                ME = MException(msgID,msg);
                throw(ME);
            end
            differences = o.timestamps(2:end) - o.timestamps(1:end-1);
            if min(differences) > o.interval
                msgID = 'GETPLOTDATA:NoTimeData';
                msg = 'No time data is returned because the minimal distance is greater than 15 minutes';
                ME = MException(msgID,msg);
                throw(ME);
            end
            startPosition = getStartIndexOfTimeStampInterval(o.timestamps, o.timeframe, o.interval);
            time = datetime(o.timestamps(startPosition:end),'ConvertFrom','posixtime');
            values = o.values(startPosition:end);
        end
        
        function updateGUI(o)
            try
                [X_time, Y_values] = o.getPlotData;
                set(o.plot, 'XData', X_time, 'YData', Y_values);
                o.updateXLim;
            catch
            end
        end
        function updateXLim(o)
            startTime = datetime(o.timestamps(end) - o.timeframe - 7.5*60,'ConvertFrom','posixtime');
            endTime   = datetime(o.timestamps(end) + 7.5*60,'ConvertFrom','posixtime');
            set(o.plot.Parent, 'XLim', [startTime,endTime]);
        end
        
        function updateStepCounter(o, steps)
            stepsTxt = char(string(o.stepstoday + steps));
            o.button.Text = stepsTxt;
            o.updateStepGauge;
        end
        
        function updateStepGauge(o)
            o.progressGauge.Value = 100 * o.stepstoday / o.userdata.stepGoal;
        end
    end
end