% Serial Data Logger
% Yu Hin Hau
% 7/9/2013
% **CLOSE PLOT TO END SESSION
 
clear
clc
 
%User Defined Properties 
serialPort = 'COM5';            % define COM port #
plotTitle = 'Serial Data Log';  % plot title
xLabel = 'Sample';    % x-axis label
yLabel = 'ECG';                % y-axis label
plotGrid = 'on';                % 'off' to turn off grid
scrollWidth = 1000;               % display period in plot, plot entire data log if <= 0
delay = .01;                    % make sure sample faster than resolution
 
%Define Function Variables
time = 0;
data = 0;
count = 1;
 
%Set up Plot
plotGraph = plot(time,data,'-m','LineWidth',1);
             
title(plotTitle,'FontSize',25);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
axis([0 scrollWidth -inf inf]);
grid(plotGrid);
 
%instrfind % List serial ports
if ~isempty(instrfind) % Close and delete open serial ports
    fclose(instrfind);
    delete(instrfind);
    clear instrfind;
end

%Open Serial COM Port
s = serial(serialPort,'BaudRate',115200);
disp('Close Plot to End Session');
fopen(s);
 

time = 1:10000;
data = zeros(1, 10000);

tic
 
while ishandle(plotGraph) %Loop when Plot is Active
     
    dat = fscanf(s,'%f'); %Read Data from Serial as Float

    if(ismember(65535, dat))
        break;
    end
    
    if(~isempty(dat) && isfloat(dat)) %Make sure Data Type is Correct
        data(count:count + length(dat) - 1) = dat;
        count = count + length(dat);
%         for i = 1:length(dat)
%            count = count + 1;
%            time = tim(count) = count;
%            data(count) = dat(i);
%         end
%         count = count + 1;    
%         time(count) = count;    %Extract Elapsed Time
%         data(count) = dat(1); %Extract 1st Data Element         
         
        %Set Axis according to Scroll Width
        if(scrollWidth > 0)
        set(plotGraph,'XData',time(max([(count-scrollWidth) 1]):count - 1),'YData',data(max([(count-scrollWidth) 1]):count - 1));
        axis([count-scrollWidth count -inf inf]);
        else
        set(plotGraph,'XData',time,'YData',data);
        axis([0 count -inf inf]);
        end
        
        drawnow;
        

        %Allow MATLAB to Update Plot
        %pause(delay);
    end
    
    drawnow;
    java.lang.Thread.sleep(1);    % Works much better than pause

end
 
%Close Serial COM Port and Delete useless Variables
fclose(s);
clear count dat delay max min plotGraph plotGrid plotTitle s ...
        scrollWidth serialPort xLabel yLabel;
 
 
disp('Session Terminated...');