function main
    close all;
%% MIDI

    deviceName = 'Arduino Leonardo';

    midicontrolsAngle = midicontrols(1*1000+8, 'MIDIDevice',deviceName);
    midicallback(midicontrolsAngle,@midiAngle)
    
    midicontrolsRadius = midicontrols(1*1000+0, 'MIDIDevice',deviceName);
    midicallback(midicontrolsRadius,@midiRadius)

%% ECG Data
    
    fs = 360;
    seconds = 2;
    DC_offset = 250;
    
    data = csvread('../Data/RealDataArduino.csv');
    data = data(1:seconds*fs) - DC_offset;
        
    f = figure;
    aOrigECG = subplot(2, 3, 1);
    pECG = plot(aOrigECG, data);
    aOrigECG.set('XLim',[0 length(data)-1],'YLim',[-200,400]);
    
    title('Raw ECG signal');
    
    aECG = subplot(2, 3, 4);
    pECG = plot(aECG, data);
    aECG.set('XLim',[0 length(data)-1],'YLim',[-200,400]);
    
    title('Filtered ECG signal');
    
    aFFT = subplot(2, 3, 5);
    yFFT = real(fft(data));
    yFFT = 10*log10(yFFT(1:end/2+1).^2);
    xFFT = linspace(0,fs/2, length(yFFT));
    pFFT = plot(aFFT, xFFT, yFFT);
    aFFT.set('XLim',[0 fs/2],'YLim',[-20,100]);
    
    title('Frequency spectrum');

%% Z domain stuff

    theta = 0;
    radius = 0;

    [Re,Im] = meshgrid(-2:0.01:2, -2:0.01:2);
    omega = 0:0.01:pi;
    Z_re = cos(omega); % Real part of z
    Z_im = sin(omega); % Imaginary part of z
    
    circT = 0:0.01:2*pi;
    circX = cos(circT);
    circY = sin(circT);
    
    b_coeff = [];
    logH = [];
    logZ = [];
    logCircZ = [];

    calculateZ;
    
%% Plots

    freqResp = subplot(2, 3, 2);
    hold(freqResp, 'on');
    xOmega = linspace(0, fs/2, length(logH));
    f = plot(freqResp, xOmega, logH);
    plot(freqResp,[50 50],[-60 20],'--k');
    freqResp.set('XLim',[0,fs/2],'YLim',[-60,20]);
        
    title('Filter requency response');
    
    asTop = subplot(2, 3, 3);
    hold(asTop,'on');
    surfTop = surf(asTop, Re, Im, logZ,'FaceAlpha',0.7,'EdgeColor', 'none');
    unitCircleTop = plot3(circX, circY, logCircZ,'r');
    campos([2,2,100]);
    asTop.set('XLim',[-2,2],'YLim',[-2,2],'ZLim',[-60,30]);

    title('Transfer function');

    asBottom = subplot(2, 3, 6);
    hold(asBottom,'on');
    surfBottom = surf(asBottom, Re, Im, logZ,'FaceAlpha',0.7,'EdgeColor', 'none');
    unitCircleBottom = plot3(circX, circY, logCircZ,'r');
    campos([2,2,-20]);
    asBottom.set('XLim',[-2,2],'YLim',[-2,2],'ZLim',[-60,30]);
    
    xlabel('Re(z)');
    ylabel('Im(z)');
    zlabel('10 log(|H(z)|²)');

%% Loop and callbacks

    while ishandle(f)
        pause(0.2);
    end

    function midiAngle(obj)
        theta = midiread(obj)*pi;
        update;
    end

    function midiRadius(obj)
        radius = midiread(obj);
        update;
    end

%% Calculate and update plots

    function calculateZ
        a = radius * cos(theta);
        b = radius * sin(theta);
        b_coeff = [a^2 + b^2, -2*a, 1];

        H_sq = ((Z_re - a).^2+(Z_im - b).^2).*((Z_re - a).^2+(Z_im + b).^2);
        logH = 10*log10(H_sq);

        Z_sq = ((Re - a).^2+(Im - b).^2).*((Re - a).^2+(Im + b).^2);
        logZ = 10*log10(Z_sq);
        logZ(logZ<-60) = -60;

        circZ_sq = ((circX - a).^2+(circY - b).^2).*((circX - a).^2+(circY + b).^2);
        logCircZ = 10*log10(circZ_sq);
        logCircZ(logCircZ<-60) = -60;
    end

    function update
        calculateZ;

        set(f,'YData',logH);
        
        set(surfTop,'ZData',logZ);
        set(unitCircleTop,'ZData',logCircZ);
        
        set(surfBottom,'ZData',logZ);
        set(unitCircleBottom,'ZData',logCircZ);
        
        % ECG
        filtered = filter(b_coeff, 1, data);
        pECG.set('YData', filtered);
        yFFT = real(fft(filtered));
        yFFT = 10*log10(yFFT(1:end/2+1).^2);
        pFFT.set('YData', yFFT);
    end
end