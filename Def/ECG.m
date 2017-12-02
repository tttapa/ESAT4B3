classdef ECG < handle
    properties (SetAccess = private)
        scalingFactor;
        windowsize;
        visiblesamples;
        extrasamples;
        samplefreq;
        BPM_interval;
        range;
        bufferlen;
        buffer; % create an empty buffer
        ringBuffer; % create an empty buffer
        ringBufferIndex = uint16(1);
        samplesSinceLastDraw = uint16(0);
        filtered;
        time;
        settings;
        baseline;
        BPM_minuteAverage = Average;
        BPM_averages;
        BPM_averages_time;
        BPM_minimumAllowedValue;
        GraphPanel;
        plot_home;
        cursor_plot;
        plot_BPM;
        button;
        statsTimeframe;
    end
    
    methods
        function o = ECG(windowsize, extrasamples, ...
                samplefreq, BPM_interval, ...
                range, lineWidth, cursorWidth, ...
                baseline, mVref, gain, ...
                GraphPanel, axes_home, axes_BPM, button, ...
                buttongroup, ...
                BPM_minimumAllowedValue)
            o.scalingFactor   = mVref / 1023.0 / gain;
            o.windowsize      = windowsize;
            o.visiblesamples  = windowsize * samplefreq;
            o.extrasamples    = extrasamples;
            o.samplefreq      = samplefreq;
            o.BPM_interval    = BPM_interval;
            o.range           = range;
            o.bufferlen       = o.visiblesamples + extrasamples;
            o.buffer          = int16(zeros(o.bufferlen,1)); % create an empty buffer
            o.ringBuffer      = double(zeros(o.visiblesamples,1)); % create an empty buffer
            o.filtered        = double(zeros(o.bufferlen,1));
            o.time            = linspace(0, windowsize, o.visiblesamples);
            o.settings        = ECG_setup(samplefreq);
            o.baseline        = baseline;
            o.BPM_minimumAllowedValue = BPM_minimumAllowedValue;
            o.GraphPanel = GraphPanel;
            hold(axes_home,'on');
            o.plot_home       = plot(axes_home, o.time, ...
                o.buffer(o.extrasamples+1:o.bufferlen), ...
                'LineWidth',lineWidth);
            o.cursor_plot     = plot(axes_home,[0 0],[o.range(1)*0.95,o.range(2)], ...
                'LineWidth',cursorWidth, 'Color', [0.05 0.1 0.2]);
            set(axes_home,'XLim',[0 windowsize],'YLim',o.range,'TickDir','out');
            
            try
                BPM_file_contents = double(dlmread('BPM.csv'));
                o.BPM_averages = BPM_file_contents(:,2);
                clear('BPM_file_contents');
            catch
                o.BPM_averages = double.empty();
            end
            try
                BPM_file_contents = int64(dlmread('BPM.csv'));
                o.BPM_averages_time = BPM_file_contents(:,1);
                clear('BPM_file_contents');
            catch
                o.BPM_averages_time = double.empty();
            end
            o.button          = button;
            o.statsTimeframe  = buttongroup.SelectedObject.UserData;
            buttongroup.SelectionChangedFcn = @o.SelChange;
            [timeX, BPM_statsToDisplay] = o.getStatsData;
            o.plot_BPM = plot(axes_BPM, timeX, BPM_statsToDisplay, '-o');
            o.updateStatsXLim;
        end
        
        function add(o, value)
            o.buffer(1:(o.bufferlen-1)) = o.buffer(2:o.bufferlen); % shift the buffer
            o.buffer(o.bufferlen) = int16(value) - o.baseline; % add the new value to the buffer
            o.samplesSinceLastDraw = o.samplesSinceLastDraw + 1;
        end
        
        function draw(o)
            if o.samplesSinceLastDraw > 0
                o.filtered = ECG_filter(o.buffer, o.settings);
                o.filtered = o.filtered(o.extrasamples+1:o.bufferlen);
                o.filtered = o.filtered * o.scalingFactor;

                while(o.samplesSinceLastDraw > 0)
                    o.ringBuffer(o.ringBufferIndex) ...
                       = o.filtered(o.visiblesamples-o.samplesSinceLastDraw+1);
                    o.ringBufferIndex = mod(o.ringBufferIndex, o.visiblesamples) + 1;
                    o.samplesSinceLastDraw = o.samplesSinceLastDraw - 1;
                end
                if strcmp(o.GraphPanel.Visible, 'on')
                    set(o.plot_home,'YData',o.ringBuffer);
                    cursorPos = double(o.ringBufferIndex) * o.windowsize / o.visiblesamples;
                    if cursorPos > 0.01
                        set(o.cursor_plot, 'XData',[cursorPos  cursorPos ]);
                    end
                end
            end
        end
        
        function displayBPM(o)
            BPM = ECG_getBPM(o.filtered, o.samplefreq);
        
            if BPM < o.BPM_minimumAllowedValue
                BPM = 0;
            end
            
            % If BPM in (0,60] -> low lamp on
            % If BPM in (60,220-age) -> normal lamp on
            % If BPM in [220-age
            %if BPM > 0 && BPM <= 60
                %o.LowLamp.Color = [0 0 1];
                %o.NormalLamp.Color = [0.05 0.1 0.15];
                %o.HighLamp.Color = [0.05 0.1 0.15];
            %elseif BPM < 220 - age
                %o.LowLamp.Color = [0.05 0.1 0.15];
                %o.NormalLamp.Color = [0 1 0];
                %o.HighLamp.Color = [0.05 0.1 0.15];
            %else
                %o.LowLamp.Color = [0.05 0.1 0.15];
                %o.NormalLamp.Color = [0.05 0.1 0.15];
                %o.HighLamp.Color = [1 0 0];
            %end
            BPM_text = char(strcat(string(uint8(round(BPM))), {' BPM'}));
            o.button.Text = BPM_text;
            o.BPM_minuteAverage.add(BPM);
        end
        function saveBPM(o, now)
            BPM = o.BPM_minuteAverage.getAverage;
            if BPM == 0
                return
            end
            disp(strcat({'Average BPM: '}, string(BPM)));
            o.BPM_averages = [o.BPM_averages; BPM]; % TODO: doesn't work if o.BPM_averages is empty
            o.BPM_averages_time = [o.BPM_averages_time; now];
            fileID = fopen('BPM.csv','a');
            fprintf(fileID,'%d\t%f\r\n', now, BPM);
            % fprintf(fileID,'%016X\t%f\r\n', now, BPM);
            fclose(fileID);
            o.updateStats;
        end
        function resetBPM(o)
            o.BPM_minuteAverage.reset;
        end
        
        function SelChange(o, bg, ev)
            o.statsTimeframe = ev.NewValue.UserData; % UserData contains number of seconds in the desired time frame
            o.updateStats;
        end
        
        function [timeX, BPM_statsToDisplay] = getStatsData(o)
            startPosition = max([1, length(o.BPM_averages_time) - o.statsTimeframe/o.BPM_interval]);
            while o.BPM_averages_time(startPosition) < o.BPM_averages_time(end) - o.statsTimeframe
                startPosition = startPosition + 1;
            end
            timeX = datetime(o.BPM_averages_time(startPosition:end),'ConvertFrom','posixtime');
            BPM_statsToDisplay = o.BPM_averages(startPosition:end);
        end
        
        function updateStats(o)
            [timeX, BPM_statsToDisplay] = o.getStatsData;
            set(o.plot_BPM, 'XData', timeX, 'YData', BPM_statsToDisplay);
            o.updateStatsXLim;
        end
        function updateStatsXLim(o)
            startTime = datetime(o.BPM_averages_time(end) - o.statsTimeframe,'ConvertFrom','posixtime');
            endTime   = datetime(o.BPM_averages_time(end),'ConvertFrom','posixtime');
            set(o.plot_BPM.Parent, 'XLim', [startTime,endTime]);
        end
    end
    
end
