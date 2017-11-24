classdef ECG < handle
    properties (SetAccess = private)
        scalingFactor;
        windowsize;
        visiblesamples;
        extrasamples;
        samplefreq;
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
        BPM_averages = double.empty();
        BPM_minimumAllowedValue;
        plot;
        cursor_plot;
        button;
    end
    
    methods
        function o = ECG(windowsize, extrasamples, samplefreq, ...
                range, lineWidth, cursorWidth, ...
                baseline, mVref, gain, ...
                axes, button, ...
                BPM_minimumAllowedValue)
            o.scalingFactor   = mVref / 1023.0 / gain;
            o.windowsize      = windowsize;
            o.visiblesamples  = windowsize * samplefreq;
            o.extrasamples    = extrasamples;
            o.samplefreq      = samplefreq;
            o.range           = range;
            o.bufferlen       = o.visiblesamples + extrasamples;
            o.buffer          = int16(zeros(o.bufferlen,1)); % create an empty buffer
            o.ringBuffer      = double(zeros(o.visiblesamples,1)); % create an empty buffer
            o.filtered        = double(zeros(o.bufferlen,1));
            o.time            = linspace(0, windowsize, o.visiblesamples);
            o.settings        = ECG_setup(samplefreq);
            o.baseline        = baseline;
            o.BPM_minimumAllowedValue = BPM_minimumAllowedValue;
            hold(axes,'on');
            o.plot            = plot(axes, o.time, ...
                o.buffer(o.extrasamples+1:o.bufferlen), ...
                'LineWidth',lineWidth);
            o.cursor_plot     = plot(axes,[0 0],[o.range(1)*0.95,o.range(2)], ...
                'LineWidth',cursorWidth, 'Color', 'k');
            set(axes,'XLim',[0 windowsize],'YLim',o.range,'TickDir','out');
            o.button   = button;            
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
                set(o.plot,'YData',o.ringBuffer);
                cursorPos = double(o.ringBufferIndex) * o.windowsize / o.visiblesamples;
                if cursorPos > 0.01
                    set(o.cursor_plot, 'XData',[cursorPos  cursorPos ]);
                end
            end
        end
        
        function displayBPM(o)
            BPM = ECG_getBPM(o.filtered, o.samplefreq);
        
            if BPM < o.BPM_minimumAllowedValue
                BPM = 0;
            end
            o.button.Text = strcat(string(BPM),{' BPM'});
            o.BPM_minuteAverage.add(BPM);
        end
        function saveBPM(o)
            BPM = o.BPM_minuteAverage.getAverage;
            disp(strcat({'Average BPM: '}, string(BPM)));
            o.BPM_averages = [o.BPM_averages BPM];
            fileID = fopen('BPM.csv','a');
            fprintf(fileID,'%d\t%f\r\n', now, BPM);
            % fprintf(fileID,'%016X\t%f\r\n', now, BPM);
            fclose(fileID);
        end
        function resetBPM(o)
            o.BPM_minuteAverage.reset;
        end
    end
end
