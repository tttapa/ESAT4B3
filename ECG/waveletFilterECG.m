function filtered = waveletFilterECG(ecgsig)
wv = 'sym4'; % Symlet 4 heeft ongeveer dezelfde vorm als een QRS complex, en is orthogonaal, dus kan real-time berekend worden

wtecg = modwt(ecgsig, wv); % pas de discrete wavelet-transformatie toe op het ECG-signaal
wtrec = zeros(size(wtecg)); % maak een matrix met dezelfde dimensies als het resultaat en vul ze met nullen
wtrec(4:5,:) = wtecg(4:5,:); % kopiëer level 4 en 5 van het resultaat naar de nieuwe matrix
filtered = imodwt(wtrec, wv); % voer de inverse discrete wavelet-transformatie toe op de nieuwe matrix
