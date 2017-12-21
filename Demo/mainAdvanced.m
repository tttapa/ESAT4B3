function main
    close all;
%% MIDI

    deviceName = 'Arduino Leonardo';
    
    try 
        load('angles', 'angles');
    catch
        angles = zeros(1,8);
    end
    
    try 
        load('radii', 'radii');
    catch
        radii = zeros(1,8);
    end
    
    try 
        load('poles', 'poles');
    catch
        poles = false(1,8);
    end
    
    gain = 0;
        
    midiAngles = midicontrols.empty();
    for j = 1:8
        midiAngles(j) = midicontrols(1*1000 + 8 + (j-1), 'MIDIDevice',deviceName);
        midicallback(midiAngles(j), @(obj)setAngle(obj, j));
    end
    
    midiRadii = midicontrols.empty();
    for j = 1:8
        midiRadii(j) = midicontrols(1*1000 + 0 + (j-1), 'MIDIDevice',deviceName);
        midicallback(midiRadii(j), @(obj)setRadius(obj, j));
    end
    
    midiPoles = midicontrols.empty();
    for j = 1:8
        midiPoles(j) = midicontrols(1*1000 + 16 + (j-1), 'MIDIDevice',deviceName);
        midicallback(midiPoles(j), @(obj)setPole(obj, j));
    end
    
    gainMidi = midicontrols(1*1000 + 36, 'MIDIDevice',deviceName);
    midicallback(gainMidi, @(obj)setGain(obj));
    
%% ECG Data
    
    fs = 360;
    seconds = 2;
    % DC_offset = 250;
    
    data = csvread('../Data/RealDataArduino.csv');
    data = data(1:seconds*fs);
        
    f = figure;
    aOrigECG = subplot(2, 3, 1);
    pECG = plot(aOrigECG, data);
    aOrigECG.set('XLim',[0 length(data)-1],'YLim',[-200,700]);
    
    % data = data - DC_offset;
    
    aECG = subplot(2, 3, 4);
    pECG = plot(aECG, data);
    aECG.set('XLim',[0 length(data)-1],'YLim',[-200,700]);
    
    aFFT = subplot(2, 3, 5);
    yFFT = real(fft(data));
    yFFT = 10*log10(yFFT(1:end/2+1).^2);
    xFFT = linspace(0,fs/2, length(yFFT));
    pFFT = plot(aFFT, xFFT, yFFT);
    aFFT.set('XLim',[0 fs/2],'YLim',[-20,100]);

%% Z domain stuff

    z = sym('z');
    H_T = symfun(1, z);
    H_N = symfun(1, z);

    [Re,Im] = meshgrid(-2:0.01:2, -2:0.01:2);
    omega = 0:0.01:pi;
    Z_re = cos(omega); % Real part of z
    Z_im = sin(omega); % Imaginary part of z
    
    circT = 0:0.01:2*pi;
    circX = cos(circT);
    circY = sin(circT);
    
    b_coeff = [];
    a_coeff = [];
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
        
    asTop = subplot(2, 3, 3);
    hold(asTop,'on');
    surfTop = surf(asTop, Re, Im, logZ,'FaceAlpha',0.7,'EdgeColor', 'none');
    unitCircleTop = plot3(circX, circY, logCircZ,'r');
    campos([2,2,100]);
    asTop.set('XLim',[-2,2],'YLim',[-2,2],'ZLim',[-60,30]);

    asBottom = subplot(2, 3, 6);
    hold(asBottom,'on');
    surfBottom = surf(asBottom, Re, Im, logZ,'FaceAlpha',0.7,'EdgeColor', 'none');
    unitCircleBottom = plot3(circX, circY, logCircZ,'r');
    campos([2,2,-20]);
    asBottom.set('XLim',[-2,2],'YLim',[-2,2],'ZLim',[-60,30]);
    
    update;

%% Loop

    while ishandle(f)
        pause(0.05);
        drawnow;
    end
    
    save('angles', 'angles');
    save('radii', 'radii');
    save('poles', 'poles');

%% MIDI callbacks

    function setAngle(obj, j)
        theta = midiread(obj)*pi;
        angles(j) = theta;
        update;
    end

    function setRadius(obj, j)
        radii(j) = midiread(obj);
        update;
    end

    function setPole(obj, j)
        poles(j) = midiread(obj);
        update;
    end

    function setGain(obj)
        gain = (midiread(obj)-0.5) * 20;
        update;
    end

%% Calculate and update plots

    function calculateZ
        H_T(z) = 1;
        H_N(z) = 1;
        H_sq = ones(size(omega));
        Z_sq = ones(length(Re), length(Im));
        circZ_sq = ones(size(circT));
        for j = 1:8
            disp(strcat(string(j),':',string(radii(j)),'<',string(angles(j))));
            a = radii(j) * cos(angles(j));
            b = radii(j) * sin(angles(j));
            disp(strcat({'a = '}, string(a)));
            disp(strcat({'b = '}, string(b)));
            isReal = angles(j) == 0 || angles(j) == pi;
            if radii(j) == 0
            elseif isReal
                if poles(j) == 0
                    H_T(z) = H_T(z) * (z - a);
                    H_sq = H_sq .* ((Z_re - a).^2 + Z_im.^2);
                    Z_sq = Z_sq .* ((Re - a).^2 + Im.^2);
                    circZ_sq = circZ_sq .* ((circX - a).^2+circY.^2);
                else 
                    H_N(z) = H_N(z) * (z - a);
                    H_sq = H_sq ./ ((Z_re - a).^2 + Z_im.^2);
                    Z_sq = Z_sq ./ ((Re - a).^2 + Im.^2);
                    circZ_sq = circZ_sq ./ ((circX - a).^2+circY.^2);
                end
            else
                if poles(j) == 0
                    H_T(z) = H_T(z) * (z - (a + b*1i)) * (z - (a - b*1i));
                    H_sq = H_sq .* (((Z_re - a).^2+(Z_im - b).^2) .* ((Z_re - a).^2+(Z_im + b).^2));
                    Z_sq = Z_sq .* (((Re - a).^2+(Im - b).^2) .* ((Re - a).^2+(Im + b).^2));
                    circZ_sq = circZ_sq .* ((circX - a).^2+(circY - b).^2).*((circX - a).^2+(circY + b).^2);
                else 
                    H_N(z) = H_N(z) * (z - (a + b*1i)) * (z - (a - b*1i));
                    H_sq = H_sq ./ (((Z_re - a).^2+(Z_im - b).^2) .* ((Z_re - a).^2+(Z_im + b).^2));
                    Z_sq = Z_sq ./ (((Re - a).^2+(Im - b).^2) .* ((Re - a).^2+(Im + b).^2));
                    circZ_sq = circZ_sq ./ (((circX - a).^2+(circY - b).^2).*((circX - a).^2+(circY + b).^2));
                end
            end
        end
        
%         disp(H_T(z))
%         disp(H_N(z))
        
        H_sq = abs(H_T(Z_re + 1j*Z_im) ./ H_N(Z_re + 1j*Z_im));
        
        b_coeff = fliplr(double(coeffs(H_T(z))))*(10^gain);
        a_coeff = fliplr(double(coeffs(H_N(z))))*(10^gain);
%         
%         
%         disp(b_coeff);
%         disp(' ');
%         disp(a_coeff);
%         disp(' ');
%         
        % figure, freqz(b_coeff, a_coeff, 720, fs)

        logH = 10*log10(H_sq)+gain;

        logZ = 10*log10(Z_sq)+gain;
        logZ(logZ<-120) = -120;

        logCircZ = 10*log10(circZ_sq)+gain;
        logCircZ(logCircZ<-120) = -120;
    end

    function update
        calculateZ;

        set(f,'YData',logH);
        
        set(surfTop,'ZData',logZ);
        set(unitCircleTop,'ZData',logCircZ);
        
        set(surfBottom,'ZData',logZ);
        set(unitCircleBottom,'ZData',logCircZ);
        
        % ECG
        filtered = filter(b_coeff, a_coeff, data);
        pECG.set('YData', filtered);
        yFFT = real(fft(filtered));
        yFFT = 10*log10(yFFT(1:end/2+1).^2);
        pFFT.set('YData', yFFT);
    end
end