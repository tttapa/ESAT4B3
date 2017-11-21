function colorbar

hsv = linspace(0,1023,360);
[ R G B ] = value2RGB(hsv);
rgb = [R' G' B']
end

function [R G B] = value2RGB(value) 
    hue = (1-value/1023)*120;
    hue = hue * pi /180;          % Convert to radian
    
    R = cos(hue*3/4);
    G = sin(hue*3/4);
    B = 0;
end