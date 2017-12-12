function [SPO2, AC_red, AC_infrared] = PPG_getSPO2(INPUT_filteredR, INPUT_dcR, INPUT_filteredIR, INPUT_dcIR, maxBPM, fs)

% startR = uint16(length(INPUT_filteredR)/6);
% startIR = uint16(length(INPUT_filteredIR)/6);

% noTransferR = INPUT_filteredR(startR:end);
% noTransferIR = INPUT_filteredIR(startIR:end);

AC_red = sqrt((sum(INPUT_filteredR.^2))/length(INPUT_filteredR));
AC_infrared = sqrt((sum(INPUT_filteredIR.^2))/length(INPUT_filteredIR));

R = (AC_red/INPUT_dcR)/(AC_infrared/INPUT_dcIR);

SPO2 = 110 - 25*R;

end

