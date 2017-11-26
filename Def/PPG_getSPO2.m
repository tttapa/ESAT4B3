function [SPO2] = PPG_getSPO2(signal_red_filtered, signal_red_unfiltered, signal_infrared_filtered, signal_infrared_unfiltered, maxBPM, fs)

[AC_red, DC_red] = PPG_getACDC(signal_red_filtered, signal_red_unfiltered, maxBPM, fs);
[AC_infrared, DC_infrared] = PPG_getACDC(signal_infrared_filtered, signal_infrared_unfiltered, maxBPM, fs);

R = (AC_red/DC_red)/(AC_infrared/DC_infrared);
SPO2 = 110 - 25*R;

end

