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
    startPosition = max([1, length(timestamps) - timeframe/interval]);
    while timestamps(startPosition) < timestamp
        startPosition = startPosition + 1;
    end
end