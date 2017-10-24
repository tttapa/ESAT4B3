addpath('../ECG/')
addpath('../Data/')

load('100m.mat');

close all;

fs = 400;
numSeconds = 3;
maxBPM = 220;

xAxis = 1/fs:1/fs:numSeconds;
disp(length(xAxis));
disp(length(val(1:1, 1:fs*numSeconds)));

figure;

waveletFilteredBuffer = waveletFilterECG(val(1:1, 1:fs*numSeconds));
plot(xAxis, waveletFilteredBuffer);

hold on;

[bpm, locations] = calculateBPM(waveletFilteredBuffer', fs, maxBPM);

title(strcat(int2str(round(bpm)), " BPM"), 'FontSize', 18);
xlabel("Tijd (s)", 'FontSize', 14);
ylabel("ECG", 'FontSize', 14);
set(gca, 'FontSize', 14);
set(gca, 'YTickLabel', []);

markerSize = 50;
markerEdgeColor = [0 0 0];
markerFaceColor = [1 0 0];
markerLineWidth = 1;

scatter(locations/fs, waveletFilteredBuffer(locations), ...
    markerSize, 'MarkerEdgeColor', markerEdgeColor, 'MarkerFaceColor', markerFaceColor, 'LineWidth', markerLineWidth);

hold off;
