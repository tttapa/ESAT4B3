function [rf, gf, bf] = step_color_category(hue)
 
  hue = (1-hue/1023)*120;
  hue = hue * pi /180;          % Convert to radian
  
  if (hue>=0 && hue<120)        % Convert from HSI color space to RGB              
    rf = cos(hue*3/4);
    gf = sin(hue*3/4);
    bf = 0;
  elseif(hue>=120 && hue<240)
    hue = hue - 120*pi/180;
    gf = cos(hue*3/4);
    bf = sin(hue*3/4);
    rf = 0;
  elseif(hue>=240 && hue<360)
    hue = hue - 240*pi/180;
    bf = cos(hue*3/4);
    rf = sin(hue*3/4);
    gf = 0;
  end
end
