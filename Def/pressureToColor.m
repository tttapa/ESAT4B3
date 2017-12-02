function [rf, gf, bf] = pressureToColor(value)
  hue = (1.0-value/1023)/3;
  [rf, gf, bf] = hsv2rgb([hue,1,1]);
end
