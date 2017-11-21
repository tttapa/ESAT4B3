
function [steps,mem_prev, stepping] = stepcounter(signal, stepping, mem_prev)          %input: gefilterd s1 en gefilterd s2

steps = 0;
counter = 2;
total_count = length(signal) - 1;
threshold_high = 500;
threshold_low = 300;

if nargin == 3
    mem_prev = false;
end
    
while counter <= total_count
    mem_cur = signal(counter, 1);
    
    if stepping == false
        if mem_cur < threshold_high
            mem_cur = false;
        else
            mem_cur = true;
        end

        if mem_prev == false && mem_cur == true
            steps = steps +1;
            stepping = true;
        end

    else
        if mem_cur < threshold_low
            stepping = false;
        end
    end
    counter = counter + 1;
    mem_prev = mem_cur;
 
end
end


