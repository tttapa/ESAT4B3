
function[bar_steps] = daily_steps(steps)        
x = datestr(steps(1,:), 'HH:MM');               %x: vanaf begin, om de 4 weergeven
bar_steps = bar(x(1,4,:), steps(:,2), 0.8));
end
             
%1e kolom: tijd, 2e kolom: aantal stappen
