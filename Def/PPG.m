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
        DC_RD = 0;
        DC_IR = 0;
        settings;
        baseline;

        GraphPanelDetail;
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
                GraphPanelDetail, axes_home, axes_RD, axes_IR, button, ...
                stats)
            o.windowsize      = windowsize;
            o.visiblesamples  = windowsize * samplefreq;
            o.extrasamples    = extrasamples;
            o.samplefreq      = samplefreq;
            o.range           = range;
            o.bufferlen       = o.visiblesamples + extrasamples;
            o.SPO2_Bufferlen  = SPO2_windowsize * 1;
            o.SPO2_Buffer     = double(zeros(o.SPO2_Bufferlen,1));
            o.buffer_RD       = int16(zeros(o.bufferlen,1));
            o.buffer_IR       = int16(zeros(o.bufferlen,1));
            o.ringBuffer_RD   = double(zeros(o.visiblesamples,1));
            o.ringBuffer_IR   = double(zeros(o.visiblesamples,1));
            o.settings        = PPG_setup(samplefreq);
            o.baseline        = baseline;
            SPO2_time         = linspace(-SPO2_windowsize, 0, o.SPO2_Bufferlen);
            time              = linspace(0, windowsize, o.visiblesamples);
            
            o.GraphPanelDetail      = GraphPanelDetail;
            o.plot_SPO2       = plot(axes_home, SPO2_time, ...
                o.SPO2_Buffer);
            set(axes_home,'XLim',[-SPO2_windowsize 0],'YLim',[-inf inf],'TickDir','out');
            
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
        
        function draw(o)
            if (o.samplesSinceLastDraw_IR > 0 && o.samplesSinceLastDraw_RD > 0) ...
                    && strcmp(o.GraphPanelDetail.Visible, 'on')
                
                while(o.samplesSinceLastDraw_IR > 0 && o.samplesSinceLastDraw_RD > 0)
                    newCompleteSamples = min([o.samplesSinceLastDraw_IR, o.samplesSinceLastDraw_RD]);
                    if newCompleteSamples > o.visiblesamples  % there are more new samples than the visible buffer
                        sampleSurplus = newCompleteSamples - o.visiblesamples;
                        o.samplesSinceLastDraw_IR = o.samplesSinceLastDraw_IR - sampleSurplus;  % ignore the oldest samples
                        o.samplesSinceLastDraw_RD = o.samplesSinceLastDraw_RD - sampleSurplus;
                    end
                    o.ringBuffer_RD(o.ringBufferIndex) ...
                       = o.buffer_RD(end-o.samplesSinceLastDraw_RD + 1);
                    o.samplesSinceLastDraw_RD = o.samplesSinceLastDraw_RD - 1;

                    o.ringBuffer_IR(o.ringBufferIndex) ...
                       = o.buffer_IR(end-o.samplesSinceLastDraw_IR + 1);
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
            o.DC_RD = mean(o.buffer_RD);
            o.DC_IR = mean(o.buffer_IR);
            SPO2 = PPG_getSPO2(o.buffer_RD, o.DC_RD, o.buffer_IR, o.DC_IR, 220, o.samplefreq);
            if isnan(SPO2)
                SPO2 = 0;
            end
            SPO2_text = char(strcat(string(round(SPO2*1000)/10.0),'%'));
            o.button.Text = SPO2_text;
            o.stats.add(SPO2*100);
            
            o.SPO2_Buffer(1:end-1) = o.SPO2_Buffer(2:end); % shift the buffer one place to the left
            o.SPO2_Buffer(end) = SPO2*100; % add the new value to the end of the buffer
            set(o.plot_SPO2,'YData', o.SPO2_Buffer);
        end
        
        function updateStats(o, now)
            o.stats.update(now);
        end
    end
end
