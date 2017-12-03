%% Berekenen van de SPO2-waarde over een bepaald interval
clear
% Length of de signal
start_second = 530;
end_seconds = 570;

[red, ired] = TEST_createPPGTestData(start_second, end_seconds);

% DC-componenten berekenen
DC_red = mean(red);
DC_ired = mean(ired);

% Filtering
    % Settings voor filter
    fs = 500;
    settings =  PPG_setup(fs);
    
red_filtered = PPG_filter(red, settings);
ired_filtered = PPG_filter(ired, settings);

% Berekenen SPO2 (inclusief berekenen AC_componenten adhv gefilterde
                    % signalen met getpeaks)
SPO2 = PPG_getSPO2(red_filtered.',DC_red,ired_filtered.', DC_ired,220,fs);  % Transpose .' van signalen (kolom ipv rij)

% Plots
x = (1:1:(end_seconds-start_second)*fs+1)./fs;
plot(x,red_filtered);