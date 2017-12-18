%% Berekenen van de SPO2-waarde over een bepaald interval
clear
% Length of de signal
start_second = 525;
end_seconds = 540;

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
[SPO2, AC_red, AC_infrared] = PPG_getSPO2_klad(red_filtered(5*fs:end).',DC_red,ired_filtered(5*fs:end).', DC_ired,220,fs);  % Transpose .' van signalen (kolom ipv rij)

% Plots
x = (1:1:(end_seconds-start_second)*fs+1)./fs;

% Oorspronkelijk rood met DC
figure;
plot(x,red);
title('Niet-gefilterd rood signaal met DC-component')
xlim([5,15])
xlabel('Tijd (s)')
ylabel('PPG')
set(gca, 'PlotBoxAspectRatio', [1 1 1], ...
    'LineWidth', 1, ...
    'Box', 'on', ...
    'FontSize', 16);
hold on
plot(x,ones(size(x)) * DC_red);
xlim([5,15])
xlabel('Tijd (s)')
ylabel('PPG')
set(gca, 'PlotBoxAspectRatio', [1 1 1], ...
    'LineWidth', 1, ...
    'Box', 'on', ...
    'FontSize', 16);
%Gefilterd rood AC
x_AC = (5*fs:1:(end_seconds-start_second)*fs+1)./fs;
figure;
plot(x_AC,red_filtered(5*fs:end));
title('Gefilterd rood signaal met AC-component')
xlim([5,15])
ylim([-10,15])
xlabel('Tijd (s)')
ylabel('PPG')
set(gca, 'PlotBoxAspectRatio', [1 1 1], ...
    'LineWidth', 1, ...
    'Box', 'on', ...
    'FontSize', 16);
hold on
plot(x_AC,ones(size(x_AC)) * AC_red);
xlim([5,15])
ylim([-10,15])
xlabel('Tijd (s)')
ylabel('PPG')
set(gca, 'PlotBoxAspectRatio', [1 1 1], ...
    'LineWidth', 1, ...
    'Box', 'on', ...
    'FontSize', 16);

%Oorspronkelijk infrarood DC
figure;
plot(x,ired);
title('Niet-gefilterd infrarood signaal met DC-component')
xlim([5,15])
ylim([6095,6230])
xlabel('Tijd (s)')
ylabel('PPG')
set(gca, 'PlotBoxAspectRatio', [3 1 1], ...
    'LineWidth', 1, ...
    'Box', 'on', ...
    'FontSize', 16);
hold on
plot(x,ones(size(x)) * DC_ired);
xlim([5,15])
ylim([6095,6230])
xlabel('Tijd (s)')
ylabel('PPG')
set(gca, 'PlotBoxAspectRatio', [3 1 1], ...
    'LineWidth', 1, ...
    'Box', 'on', ...
    'FontSize', 16);

%Gefilterd infrarood AC
figure;
plot(x_AC,ired_filtered(5*fs:end));
title('Gefilterd infrarood signaal met AC-component')
xlim([5,15])
ylim([-50,85])
xlabel('Tijd (s)')
ylabel('PPG')
set(gca, 'PlotBoxAspectRatio', [3 1 1], ...
    'LineWidth', 1, ...
    'Box', 'on', ...
    'FontSize', 16);
hold on
plot(x_AC,ones(size(x_AC)) * AC_infrared);
xlim([5,10])
ylim([-50,85])
xlabel('Tijd (s)')
ylabel('PPG')
set(gca, 'PlotBoxAspectRatio', [3 1 1], ...
    'LineWidth', 1, ...
    'Box', 'on', ...
    'FontSize', 16);

