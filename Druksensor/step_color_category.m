function [rf, gf, bf] = step_color_category(value)
  hue = (1-value/1023)/3;
  [rf, gf, bf] = hsv2rgb([hue,1,1]);
end
