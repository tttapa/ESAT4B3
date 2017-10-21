function RESULT_filteredSignal = waveletFilterECG(INPUT_ecgsig, INPUT_levels, INPUT_frequencyWeights)
% WAVELET_FILTER_ECG returns a filtered ECG signal, ready to be analyzed
% for peaks.
%
% @param INPUT_ecgsig - row vector of ECG data
% @param INPUT_levels - number of levels analyzed
% @param INPUT_frequencyWeights - row vector representing the weights of
%                                 each level
%


%%
% SETUP
%

% Use Symlet 4 because is has the same shape as a QRS complex and because
% it is orthogonal. This means WAVELET_FILTER_ECG can be used in real time.
wv = 'sym4';

if nargin == 1
    INPUT_levels = 5;
    INPUT_frequencyWeights = [0, 0, 1, 1, 1, 0];
end

maxLevels = floor(log2(length(INPUT_ecgsig)));
assert(INPUT_levels <= maxLevels, 'Number of levels too high for sample this short')
assert(INPUT_levels + 1 == length(INPUT_frequencyWeights), 'Wrong number of frequency weightss')


%%
% EXECUTION
%

% Calculate the weight matrix
weightMatrix = diag(INPUT_frequencyWeights);

% Perform the discrete wavelet transform on the ECG signal
wtecg = modwt(INPUT_ecgsig, wv, INPUT_levels);

% Select the desired levels using the weight matrix
wtrec = weightMatrix * wtecg;

% Perform the inverse discrete wavelet transform to return the filtered
% signal
RESULT_filteredSignal = imodwt(wtrec, wv);

end