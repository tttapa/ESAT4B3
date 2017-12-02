function startPosition = getStartIndexOfTimeStampInterval(timestamps, timeframe, interval)
% GETSTARTINDEXOFTIMESTAMPINTERVAL Returns the start position of the time stamp that is
% the start of a given time frame (in seconds). For example, if the last
% time stamp is 12:00, and the time frame is 120 seconds, the start
% position will be the index of the time stamp 11:58, if it exists. If
% 11:58 doesn't exist, it will return the index of the first time stamp >
% 11:58.
    if isempty(timestamps)
        msgID = 'getStartIndexOfTimeStampInterval:EmptyList';
        msg = 'List of time stamps is empty.';
        ex = MException(msgID,msg);
        throw(ex);
    end
    startPosition = max([1, length(timestamps) - timeframe/interval]);
    while timestamps(startPosition) < timestamps(end) - timeframe
        startPosition = startPosition + 1;
    end
end