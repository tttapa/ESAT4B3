function s = startSerial(serialPort, baudrate, BytesAvailableFcnCount, HandleFcn, ErrorFcn)
    % Initializations
    msgtype = message_type(0); % initialization of variables used in callback function
    value = uint16(0);         % "
    
    s = false;

    % Close and delete open serial ports
    if ~isempty(instrfind)
        fclose(instrfind);
        delete(instrfind);
        clear instrfind;
    end

    % Check if there are serial ports available on the system
    if isempty(seriallist)
        disp('No serial ports available.');
        return;
    end

    % If no port specified, select the first serial port in the system
    if strcmp(serialPort, '')
        sl = seriallist;
        serialPort = sl(1);
        msg = strcat({'Selected serial port '}, serialPort, '.');
        disp(msg);

    % Exit script if port is not available
    elseif(~ismember(serialPort, seriallist))
        errmsg = strcat({'Serial port '}, serialPort, {' not available.'});
        disp(errmsg);
        return;
    end

    % Open serial port
    s = serial(serialPort, 'BaudRate', baudrate);

    s.BytesAvailableFcn = @serialcb; % Callback function for serial port
    s.BytesAvailableFcnCount = BytesAvailableFcnCount; % On every x bytes received
    s.InputBufferSize = 2.^(ceil(log2(s.BytesAvailableFcnCount))+2);
    % disp(strcat({'Input buffer size: '}, string(s.InputBufferSize)));
    % disp(strcat({'Bytes per redraw:  '}, string(s.BytesAvailableFcnCount)));
    s.BytesAvailableFcnMode = 'byte';
    
    s.ErrorFcn = ErrorFcn;
    s.BreakInterruptFcn = ErrorFcn;
    
    %% Serial callback

    function serialcb (s, ~, ~) % Callback function that executes when a new byte arrives on the serial port
        x = uint16(fread(s, s.BytesAvailableFcnCount)); % Read the data from the buffer

        for i = 1:s.BytesAvailableFcnCount
            % https://github.com/tttapa/ESAT4B3/blob/master/Arduino/Serial-Protocol.md
            if bitand(x(i), 128) ~= 0 % 128 == 0b10000000
                % if it's a header byte
                msgtype = message_type(bitand(x(i), 7)); % 7 == 0b0111
                value = bitshift(bitand(x(i), 112), 3);  % 112 == 0b01110000 
            else 
                % if it's a data byte
                value = bitor(value, x(i));
                HandleFcn(value, msgtype);
                value = uint16(0);
            end
        end
    end
end