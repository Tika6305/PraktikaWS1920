function [amp_values] = calcAmpValuesMarc( kanal1, kanal2, mvc_k1, mvc_k2 )
% Diese Funktion bestimmt die Parameter im Zeitbereich:
% p_mvc: Amplitudenwerte bezogen auf die maximale Amplitude in % für beide
% Kanäle
% mav: mittlere Amplitude für beide Kanäle
% rms: quadratisches Mittel für beide Kanäle

% Signal in muV
kanal1 = kanal1*1000*1000;
kanal2 = kanal2*1000*1000;

% prozentuale Amplitudenwerte
[p_mvc_k1] = kanal1./mvc_k1.*100;
[p_mvc_k2] = kanal2./mvc_k2.*100;

length_k1 = length(kanal1);
length_k2 = length(kanal2);

% mittlere Amplitude pro sample
mav_k1 = 1/length_k1 * sum (abs(kanal1));
mav_k2 = 1/length_k2 * sum (abs(kanal2));

% quadratisches Mittel
rms_k1=rms(kanal1);
rms_k2=rms(kanal2);

% Ausgabe mittlere Amplitude
disp(['MAV (Kanal 1) = ', num2str(mav_k1), ' uV']);
disp(['MAV (Kanal 2) = ', num2str(mav_k2), ' uV']);
% Ausgabe RMS
disp(['RMS (Kanal 1) = ', num2str(rms_k1), ' uV']);
disp(['RMS (Kanal 2) = ', num2str(rms_k2), ' uV']);

%Zusammenfassen der Ergebnisse
amp_values = struct('mvc_k2',mvc_k2,'mvc_k1',mvc_k1,'p_mvc_k1',p_mvc_k1,...
                    'p_mvc_k2',p_mvc_k2, 'mav_k1',mav_k1, 'mav_k2',mav_k2,...
                    'rms_k1',rms_k1,'rms_k2',rms_k2);
end