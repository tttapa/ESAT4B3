function startPosition = getStartIndexOfTimeStamp(timestamps, timestamp, interval)
    if isempty(timestamps)
        msgID = 'getStartIndexOfTimeStampInterval:EmptyList';
        msg = 'List of time stamps is empty.';
        ex = MException(msgID,msg);
        throw(ex);
    end
    if timestamps(end) < timestamp
        msgID = 'getStartIndexOfTimeStamp:NotInList';
        msg = 'The given time stamp is later than the last time stamp in the list.';
        ex = MException(msgID,msg);
        throw(ex);
    end
    timeframe = timestamps(end) - timestamp;
    if nargin == 2
        % if the interval between time stamps is unknown, start looking
        % from index 1
        startPosition = 1;
    elseif nargin == 3
        % make an educated guess of where the time stamp is if every time 
        % stamp was recorded (i.e. the interval of entries in 'timestamps' is constant and known)
        startPosition = max([1, length(timestamps) - timeframe/interval]);
    end
    while timestamps(startPosition) < timestamp
        % if some time stamps are missing (i.e. if the interval is greater
        % than the expected interval) the start position is too low, 
        % so increment until the right time stamp is found
        startPosition = startPosition + 1;
    end
end