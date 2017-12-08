function now = getUnixTime
    now = int64(posixtime(datetime('now')));
end