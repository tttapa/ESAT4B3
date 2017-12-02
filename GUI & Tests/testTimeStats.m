function testTimeStats
    BPM_interval = 30;
    now = 1512216000; % uint64(posixtime(datetime('now')));
    BPM_averages_time = ((now - 24*60*60)/BPM_interval:now/BPM_interval)*BPM_interval;
    % BPM_averages_time(length(BPM_averages_time)-2) = []; % delete one entry
    updateStats(60);
    function updateStats(timeframe)
        startPosition = max([1, length(BPM_averages_time) - timeframe/BPM_interval]);
        while BPM_averages_time(startPosition) < BPM_averages_time(end) - timeframe
            startPosition = startPosition + 1;
        end
        time = datetime(BPM_averages_time(startPosition:end),'ConvertFrom','posixtime');
        disp(time);
    end
end