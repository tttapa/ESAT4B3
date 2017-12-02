classdef PPG < handle
    properties (SetAccess = private)
        windowsize;
        visiblesamples;
        extrasamples;
        samplefreq;
        range;
        bufferlen;
        SPO2_Bufferlen;
        SPO2_Buffer;
        buffer_RD;
        buffer_IR;
        ringBuffer_RD;
        ringBuffer_IR;
        ringBufferIndex = uint16(1);
        samplesSinceLastDraw_RD = uint16(0);
        samplesSinceLastDraw_IR = uint16(0);
        filtered_RD;
        DC_RD = 0;
        filtered_IR;
        DC_IR = 0;
        settings;
        baseline;

        GraphPanel;
        plot_SPO2;
        plot_RD;
        plot_IR;
        cursor_plot_RD;
        cursor_plot_IR;
        button;

        stats;
    end
    
    methods
        function o = PPG(windowsize, extrasamples, samplefreq, SPO2_windowsize, ...
                range, lineWidth, cursorWidth, ...
                baseline, ...
                GraphPanel, axes_home, axes_RD, axes_IR, button, ...
                stats)
            o.windowsize      = windowsize;
            o.visiblesamples  = windowsize * samplefreq;
            o.extrasamples    = extrasamples;
            o.samplefreq      = samplefreq;
            o.range           = range;
            o.bufferlen       = o.visiblesamples + extrasamples;
            o.SPO2_Bufferlen  = SPO2_windowsize * samplefreq;
            o.SPO2_Buffer     = double(zeros(o.SPO2_Bufferlen,1));
            o.buffer_RD       = int16(zeros(o.bufferlen,1));
            o.buffer_IR       = int16(zeros(o.bufferlen,1));
            o.ringBuffer_RD   = double(zeros(o.visiblesamples,1));
            o.ringBuffer_IR   = double(zeros(o.visiblesamples,1));
            o.filtered_RD     = double(zeros(o.bufferlen,1));
            o.filtered_IR     = double(zeros(o.bufferlen,1));
            o.settings        = PPG_setup(samplefreq);
            o.baseline        = baseline;
            SPO2_time         = linspace(0, SPO2_windowsize, o.SPO2_Bufferlen);
            time              = linspace(0, windowsize, o.visiblesamples);
            
            o.GraphPanel      = GraphPanel;
            o.plot_SPO2       = plot(axes_home, SPO2_time, ...
                o.SPO2_Buffer);
            hold(axes_RD, 'on');
            o.plot_RD         = plot(axes_RD, time, ...
                o.ringBuffer_RD, ...
                'LineWidth',lineWidth);
            o.cursor_plot_RD  = plot(axes_RD,[0 0],[o.range(1)*0.95,o.range(2)], ...
                'LineWidth',cursorWidth, 'Color', 'k');
            hold(axes_IR, 'on');
            o.plot_IR          = plot(axes_IR, time, ...
                o.ringBuffer_IR, ...
                'LineWidth',lineWidth);
            o.cursor_plot_IR  = plot(axes_IR,[0 0],[o.range(1)*0.95,o.range(2)], ...
                'LineWidth',cursorWidth, 'Color', 'k');
            set(axes_RD,'XLim',[0 windowsize],'YLim',o.range,'TickDir','out');
            set(axes_IR,'XLim',[0 windowsize],'YLim',o.range,'TickDir','out');
            o.button = button;
            
            o.stats = stats;            
        end
        
        function add_RD(o, value)
            o.buffer_RD(1:(o.bufferlen-1)) = o.buffer_RD(2:o.bufferlen); % shift the buffer one place to the left
            o.buffer_RD(o.bufferlen) = int16(value) - o.baseline; % add the new value to the end of the buffer
            o.samplesSinceLastDraw_RD = o.samplesSinceLastDraw_RD + 1;
        end
        function add_IR(o, value)
            o.buffer_IR(1:(o.bufferlen-1)) = o.buffer_IR(2:o.bufferlen); % shift the buffer one place to the left
            o.buffer_IR(o.bufferlen) = int16(value) - o.baseline; % add the new value to the end of the buffer
            o.samplesSinceLastDraw_IR = o.samplesSinceLastDraw_IR + 1;
        end
        
        function filter(o)
            o.filtered_RD = PPG_filter(o.buffer_RD, o.settings);
            o.filtered_RD = o.filtered_RD(o.extrasamples+1:o.bufferlen);

            o.filtered_IR = PPG_filter(o.buffer_IR, o.settings);
            o.filtered_IR = o.filtered_IR(o.extrasamples+1:o.bufferlen);
        end
        function draw(o)
            if (o.samplesSinceLastDraw_IR > 0 && o.samplesSinceLastDraw_RD > 0) ...
                    && strcmp(o.GraphPanel.Visible, 'on')
                o.filter;
                newCompleteSamples = min([o.samplesSinceLastDraw_IR, o.samplesSinceLastDraw_RD]);
                if newCompleteSamples > o.visiblesamples  % there are more new samples than the visible buffer
                    sampleSurplus = newCompleteSamples - o.visiblesamples;
                    o.samplesSinceLastDraw_IR = o.samplesSinceLastDraw_IR - sampleSurplus;  % ignore the oldest samples
                    o.samplesSinceLastDraw_RD = o.samplesSinceLastDraw_RD - sampleSurplus;
                end
                
                while(o.samplesSinceLastDraw_IR > 0 && o.samplesSinceLastDraw_RD > 0)
                    o.ringBuffer_RD(o.ringBufferIndex) ...
                       = o.filtered_RD(o.visiblesamples-o.samplesSinceLastDraw_RD+1);
                    o.samplesSinceLastDraw_RD = o.samplesSinceLastDraw_RD - 1;

                    o.ringBuffer_IR(o.ringBufferIndex) ...
                       = o.filtered_IR(o.visiblesamples-o.samplesSinceLastDraw_IR+1);
                    o.samplesSinceLastDraw_IR = o.samplesSinceLastDraw_IR - 1;
                    
                    o.ringBufferIndex = mod(o.ringBufferIndex, o.visiblesamples) + 1;
                end
                
                set(o.plot_RD,'YData', o.ringBuffer_RD);
                set(o.plot_IR,'YData', o.ringBuffer_IR);
                cursorPos = double(o.ringBufferIndex) * o.windowsize / o.visiblesamples;
                if cursorPos > 0.01
                    set(o.cursor_plot_RD, 'XData',[cursorPos  cursorPos ]);
                    set(o.cursor_plot_IR, 'XData',[cursorPos  cursorPos ]);
                end
            end
        end
        
        function displaySPO2(o)
            if strcmp(o.GraphPanel.Visible, 'off')  % if the panel is off, the filtered buffer is not updated, so do it now
                o.filter;
            end
            o.DC_RD = mean(o.buffer_RD);
            o.DC_IR = mean(o.buffer_IR);
            SPO2 = PPG_getSPO2(o.filtered_RD, o.DC_RD, o.filtered_IR, o.DC_IR, 220, o.samplefreq);
            if isnan(SPO2)
                SPO2 = 0;
            end
            SPO2_text = char(strcat(string(round(SPO2*1000)/10.0),'%'));
            o.button.Text = SPO2_text;
            o.stats.add(SPO2*100);
        end
        
        function updateStats(o, now)
            o.stats.update(now);
        end
    end
end
