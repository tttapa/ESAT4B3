function [SPO2] = PPG_getSPO2(signal_red, signal_infrared)

[AC_red, DC_red] = PPG_getACDC(signal_red);
[AC_infrared, DC_infrared] = PPG_getACDC(signal_infrared);

R = (AC_red/DC_red)/(AC_infrared/DC_infrared);
SPO2 = 110 - 25*R;

end

