classdef ECG < handle
    properties (SetAccess = private)
        scalingFactor;
        windowsize;
        visiblesamples;
        extrasamples;
        samplefreq;
        range;
        bufferlen;
        buffer;
        ringBuffer;
        ringBufferIndex = uint16(1);
        samplesSinceLastDraw = uint16(0);
        filtered;
        time;
        settings;
        baseline;
        BPM_minimumAllowedValue;
        
        GraphPanel;
        plot_home;
        cursor_plot;
        button;
        BPM_gauge;
        
        stats;
    end
    
    methods
        function o = ECG(windowsize, extrasamples, ...
                samplefreq, ...
                range, lineWidth, cursorWidth, ...
                baseline, mVref, gain, ...
                GraphPanel, axes_home, button, ...
                BPM_gauge, BPM_minimumAllowedValue, ...
                stats)
            o.scalingFactor   = mVref / 1023.0 / gain;
            o.windowsize      = windowsize;
            o.visiblesamples  = windowsize * samplefreq;
            o.extrasamples    = extrasamples;
            o.samplefreq      = samplefreq;
            o.range           = range;
            o.bufferlen       = o.visiblesamples + extrasamples;
            o.buffer          = int16(zeros(o.bufferlen,1));
            o.ringBuffer      = double(zeros(o.visiblesamples,1));
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
            o.button          = button;
            o.BPM_gauge = BPM_gauge;
            
            o.stats = stats;
        end
        
        function add(o, value)
            o.buffer(1:(o.bufferlen-1)) = o.buffer(2:o.bufferlen);  % shift the buffer
            o.buffer(o.bufferlen) = int16(value) - o.baseline;  % add the new value to the buffer
            o.samplesSinceLastDraw = o.samplesSinceLastDraw + 1;
        end
        
        function filter(o)
            o.filtered = ECG_filter(o.buffer, o.settings);  % filter the buffer
            o.filtered = o.filtered(o.extrasamples+1:o.bufferlen);  % only the visible samples (TODO: remove)
            o.filtered = o.filtered * o.scalingFactor;  % scale to mV
        end
        
        function draw(o)
            if o.samplesSinceLastDraw > 0 && strcmp(o.GraphPanel.Visible, 'on')
                o.filter;

                if o.samplesSinceLastDraw > o.visiblesamples
                    o.samplesSinceLastDraw = o.visiblesamples;
                end
                while(o.samplesSinceLastDraw > 0)  % for every new sample
                    o.ringBuffer(o.ringBufferIndex) ...  % add it to the ringbuffer
                       = o.filtered(end-o.samplesSinceLastDraw+1);
                    o.ringBufferIndex = mod(o.ringBufferIndex, o.visiblesamples) + 1;
                    o.samplesSinceLastDraw = o.samplesSinceLastDraw - 1;
                end
                set(o.plot_home,'YData',o.ringBuffer);  % plot the ringbuffer
                cursorPos = double(o.ringBufferIndex) * o.windowsize / o.visiblesamples;
                if cursorPos > 0.01
                    set(o.cursor_plot, 'XData',[cursorPos  cursorPos ]);  % draw the cursor
                end
            end
        end
        
        function displayBPM(o)
            if strcmp(o.GraphPanel.Visible, 'off')  % if the panel is off, the filtered buffer is not updated, so do it now
                o.filter;
            end

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
            o.stats.add(BPM);
            o.BPM_gauge.Value = BPM;
        end
        
        function updateStats(o, now)
            o.stats.update(now);
        end
    end
    
end
