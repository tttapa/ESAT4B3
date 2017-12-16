function main
    close all;

    deviceName = 'Arduino Leonardo';
    channel = 1;
    controller = 19;
    midicontrolsObject = midicontrols(channel*1000+controller, 'MIDIDevice',deviceName);

    midicallback(midicontrolsObject,@dispMIDI)

    theta =pi/4;

    a = cos(theta);
    b = sin(theta);
    b_coeff = [a^2 + b^2, -2*a, 1];
    disp(b_coeff);

    omega = 0:0.01:pi;
    Z_re = cos(omega); % Real part of z
    Z_im = sin(omega); % Imaginary part of z
    H_sq = ((Z_re - a).^2+(Z_im - b).^2).*((Z_re - a).^2+(Z_im + b).^2);
    logH = 10*log10(H_sq);
    figure;
    freqResp = axes;
    f = plot(freqResp, omega, logH);
    freqResp.set('XLim',[0,pi],'YLim',[-60,20]);
    
    [Re,Im] = meshgrid(-2:0.01:2, -2:0.01:2);
    Z = ((Re - a).^2+(Im - b).^2).*((Re - a).^2+(Im + b).^2);
    logZ = 10*log10(Z);
    
    circT = 0:0.01:2*pi;
    circX = cos(circT);
    circY = sin(circT);
    circZ = ((circX - a).^2+(circY - b).^2).*((circX - a).^2+(circY + b).^2);
    logCircZ = 10*log10(circZ);
    
    figure;
    asTop = axes;
    hold(asTop,'on');
    surfTop = surf(asTop, Re, Im, logZ,'FaceAlpha',0.7,'EdgeColor', 'none');
    unitCircleTop = plot3(circX, circY, logCircZ,'r');
    campos([2,2,100]);
    asTop.set('XLim',[-2,2],'YLim',[-2,2],'ZLim',[-60,30]);

    figure;
    asBottom = axes;
    hold(asBottom,'on');
    surfBottom = surf(asBottom, Re, Im, logZ,'FaceAlpha',0.7,'EdgeColor', 'none');
    unitCircleBottom = plot3(circX, circY, logCircZ,'r');
    campos([2,2,-20]);
    asBottom.set('XLim',[-2,2],'YLim',[-2,2],'ZLim',[-60,30]);
    

    while 1
        pause(0.2);
    end

    function dispMIDI(obj)
        theta = midiread(obj)*pi;
        a = cos(theta);
        b = sin(theta);
        b_coeff = [a^2 + b^2, -2*a, 1];
        disp(b_coeff);

        Z_re = cos(omega); % Real part of z
        Z_im = sin(omega); % Imaginary part of z
        H_sq = ((Z_re - a).^2+(Z_im - b).^2).*((Z_re - a).^2+(Z_im + b).^2);
        logH = 10*log10(H_sq);

        Z = ((Re - a).^2+(Im - b).^2).*((Re - a).^2+(Im + b).^2);
        logZ = 10*log10(Z);
        
        circZ = ((circX - a).^2+(circY - b).^2).*((circX - a).^2+(circY + b).^2);
        logCircZ = 10*log10(circZ);
        
        logZ(logZ<-60) = -60;

        set(f,'YData',logH);
        
        set(surfTop,'ZData',logZ);
        set(unitCircleTop,'ZData',logCircZ);
        
        set(surfBottom,'ZData',logZ);
        set(unitCircleBottom,'ZData',logCircZ);
    end
end