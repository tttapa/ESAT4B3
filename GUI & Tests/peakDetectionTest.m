function peakDetectionTest
    threshold = 2;
    maxDistance = 8;
    
    testSignal = [ 1 2 3 4 3 2 1 1 2 3 4 3 2 1 1 1 1 1 1 1 1 1 1 2 3 4 3 2 1 1 2 3 4 3 2 1 ];
    
    close all,
    clc,
    figure,
    hold on,
    plot(testSignal);
    refline([0 threshold]);
    
    for i = 1:length(testSignal)
        % disp(string(i));
        distance = doStuff(testSignal(i));
        if distance > 0
            disp(strcat({'distance  = '},string(distance)));
        elseif distance < 0
            disp('No peaks');
        end
    end

    function distance = doStuff(value)
        assert(threshold > 0); % TODO: make static_assert in C implementation
        persistent ctr prevCtr max;
        if isempty(prevCtr)
            prevCtr = 0;
        end
        distance = 0;
        if prevCtr > 0
            prevCtr = prevCtr + 1;
            % disp(strcat({'      prevCtr = '}, string(prevCtr)));
            % disp(strcat({'          ctr = '}, string(ctr)));
        end
        if max > 0
            if value >= max
                % disp('   new max');
                ctr = 0;
                max = value;
            elseif value < threshold
                % disp('   end of peak');
                ctr = ctr + 1;
                if prevCtr > 0
                    distance = prevCtr - ctr;
                    % disp(strcat({'      distance = '},string(distance)));
                end
                prevCtr = ctr;
                max = 0;
            else 
                % disp('   peak falling');
                ctr = ctr + 1;
            end
        elseif prevCtr >= maxDistance
            % disp('   no peak');
            prevCtr = 0;
            distance = -1;
        elseif value >= threshold
            % disp('   threshold')
            ctr = 0;
            max = value;
        end
    end
end