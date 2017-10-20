function filtered = waveletFilterECG2(ecgsig)
wv = 'sym4'; % Symlet 4 heeft ongeveer dezelfde vorm als een QRS complex, en is orthogonaal, dus kan real-time berekend worden

levels = floor(log2(length(ecgsig)));
frequencyWeights = zeros(1, levels + 1);
frequencyWeights(1, floor(length(frequencyWeights) / 4)) = 1;
frequencyWeights(1, floor(length(frequencyWeights) / 2)) = 1;
frequencyWeights(1, floor(length(frequencyWeights) * 3 / 4)) = 1;

weightMatrix = diag(frequencyWeights);

wtecg = modwt(ecgsig, wv, levels); % pas de discrete wavelet-transformatie toe op het ECG-signaal
wtrec = weightMatrix * wtecg; % selecteer de gewenste levels met de juiste weights
filtered = imodwt(wtrec, wv); % voer de inverse discrete wavelet-transformatie toe op de nieuwe matrix
end