function filtered = waveletFilterECG(ecgsig, levels, frequencyWeights)
wv = 'sym4'; % Symlet 4 heeft ongeveer dezelfde vorm als een QRS complex, en is orthogonaal, dus kan real-time berekend worden

if nargin == 1
    levels = 5;
    frequencyWeights = [0, 0, 1, 1, 1, 0];
end

maxlevels = floor(log2(length(ecgsig)));
assert(levels <= maxlevels, 'Number of levels too high for sample this short')

assert(levels + 1 == length(frequencyWeights), 'Wrong number of frequency weightss')

weightMatrix = diag(frequencyWeights);

wtecg = modwt(ecgsig, wv, levels); % pas de discrete wavelet-transformatie toe op het ECG-signaal
wtrec = weightMatrix * wtecg; % selecteer de gewenste levels met de juiste weights
filtered = imodwt(wtrec, wv); % voer de inverse discrete wavelet-transformatie toe op de nieuwe matrix
end