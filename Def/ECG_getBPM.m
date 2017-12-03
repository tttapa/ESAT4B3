function [ BPM ] = ECG_getBPM(signal, samplefreq)

    assert(samplefreq == 360, 'Wrong sample frequency');
    filtered = ECG_waveletFilter(signal);
    
    % Get the locations of the peaks
    [~, locations] = ECG_findRpeaks(filtered, samplefreq, 220);

    % If we found 2+ peaks, we can calculate the average BPM over the entire
    % dataset
    if length(locations) > 1

        % Get the location of the first and last beat
        firstBeat = locations(1);
        lastBeat = locations(length(locations));

        % Calculate the average BPM
        numBeats = length(locations) - 1;
        numMinutes = (lastBeat - firstBeat) / samplefreq / 60;
        BPM = numBeats / numMinutes;

    else
        % If we found 0 peaks or just 1 peak, we cannot calculate a BPM
        BPM = 0;
    end

    function [ Rpeaks, Rlocations ] = ECG_findRpeaks( signal, samplefreq, maxBPM )
        % ECG_FINDRPEAKS returns a list of peaks and their respective locations in the data.

        % Minimum expected samples per heartbeat using sample rate & max BPM
        minHeartbeatLength = floor(samplefreq * 60 / maxBPM);

        % Percentage of highest value that will be the cut-off value
        % As a relative threshold
        cutOffFactor = 0.4;
        
        % Ignore peaks that are lower than an absolute threshold
        minimumAbsolutePeakHeight = 1;
        
        % Find the highest value in the interval, and calculate the cut-off value
        highestValue = max(signal);
        cutOffValue = highestValue * cutOffFactor;
        cutOffValue = max([cutOffValue; minimumAbsolutePeakHeight]);

        % Find the peaks within this interval
        %   -> Parameter 3: minDistance must be <= length(INPUT_data) - 2
        [Rpeaks, Rlocations] = getPeaks(signal', false, true, cutOffValue, true, min([minHeartbeatLength, length(signal) - 2]));

    end

    function [ result ] = ECG_waveletFilter(signal, levels, frequencyWeights)
        % ECG_WAVELETFILTER returns a filtered ECG signal, ready to be analyzed for R-peaks.

        % Use Symlet 4 because is has the same shape as a QRS complex and because
        % it is orthogonal. This means the wavelet filter can be used in real time.
        wv = 'sym4';

        if nargin == 1
            levels = 5;
            frequencyWeights = [0, 0, 1, 1, 1, 0];
        end

        maxLevels = floor(log2(length(signal)));
        assert(levels <= maxLevels, 'Number of levels too high for sample this short')
        assert(levels + 1 == length(frequencyWeights), 'Wrong number of frequency weights')

        % The diagonal weight matrix determines what levels will be 
        % preserved
        weightMatrix = diag(frequencyWeights);

        % Perform the discrete wavelet transform on the ECG signal
        wtecg = modwt(signal, wv, levels);

        % Select the desired levels using the weight matrix
        wtrec = weightMatrix * wtecg;

        % Perform the inverse discrete wavelet transform to return the filtered
        % signal
        result = imodwt(wtrec, wv);

    end
    
end