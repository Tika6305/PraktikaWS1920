function [quantiles,totalEnergy_deltaT] = displaySTFT(fs, kanal1, kanal2,Aufgabe)
if nargin == 3
    Aufgabe = 'None';
end
% Access Directory for each dataset
taskDir = ['Aufgabe' Aufgabe];


windowLength  = fs;
windowOverlap = 0;%round(windowLength/2);
kanalNummer = input( 'Welcher Arm/Kanal soll untersucht werden? \n Gib 1 ein für den linken Arm und 2 für den rechten Arm \n');
if kanalNummer==1
    kanal = kanal1;
else
    kanal = kanal2;
end

% Make Spectrogram
figure()
% using a hamming window
nfft = windowLength; % has influence on energy
window = rectwin(windowLength); % windowLength;%
[s,w,tt]=spectrogram(kanal,window,windowOverlap,nfft,fs,'yaxis');
% s:[frequency,time]
si = size(s);
%fprintf('spectrogram shape %d %d\n',length(s),length(s(1:end,1)));
fprintf('spectrogram shape %d %d ',si(1),si(2))
fprintf('windowLength %d \n',windowLength);
fprintf('mean power bandpower %d \n',bandpower(kanal(1:si(2)*(windowLength-windowOverlap))));

% Korrekturfaktoren sind zur richtigen Darstellung der Energie notwendig,
% da aufgrund der zeitlichen Fensterung und weiteren mir unbekannten Faktoren das 
% Spektrogram nicht die selbe Energie wie das Zeitsignal besitzt.
% https://community.sw.siemens.com/s/article/window-correction-factors
windowCorrection = 1; % bei Rechteck Fenster
% Notwendigkeit nur im Vergleich mit 'bandpower(kanal)' aufgefallen.
% Theorie dazu nicht gefunden
unbekannterGrund = 2; 
correction_factor = windowCorrection*unbekannterGrund; % 
fprintf('mean power %d \n',mean(1/windowLength^2*sum(abs(s).^2*correction_factor)));
% Cut results at 700Hz because of the lowpass 
s = s(1:700,1:end);
fprintf('Maximale Energie %d im Spektrogram \n',max(max(abs(s).^2)));
w = w(1: 700);

% Plot Spectrogram
surf(tt, w, 10*log10(abs(s).^2), 'EdgeColor', 'none');
axis xy; 
axis tight; 
colormap(jet); view(0,90);
ax=gca;
colorlim = get(ax,'clim');
newlim = [(colorlim(1)*0.8),colorlim(2)];
set(ax,'clim',(newlim));
xlabel('Zeit in s');
colorbar;
ylabel('Frequenz in HZ');
title(['10*log(|STFT|^2) \Delta T =' num2str(windowLength/fs) 's']);
Arm={'links', 'rechts'};
baseFileName =  sprintf('%s%sSTFT.png',Aufgabe, Arm{kanalNummer});
baseFileName = fullfile(taskDir, baseFileName);
saveas(gcf, baseFileName);

%baseFileName =  sprintf('%s%sSTFT.pdf',Aufgabe, Arm{kanalNummer});
%baseFileName = fullfile(taskDir, baseFileName);
%saveas(gcf, baseFileName);

%baseFileName =  sprintf('%s%sSTFT.svg',Aufgabe, Arm{kanalNummer});
%baseFileName = fullfile(taskDir, baseFileName);
%saveas(gcf, baseFileName);

%baseFileName =  sprintf('%s%sSTFT.fig',Aufgabe, Arm{kanalNummer});
%baseFileName = fullfile(taskDir, baseFileName);
%saveas(gcf, baseFileName);


% Plot total energy at Time Frame
totalEnergy_deltaT = sum(1/(windowLength^2)*abs(s).^2*correction_factor,1);
scaledEnergy = (totalEnergy_deltaT-min(totalEnergy_deltaT))/(max(totalEnergy_deltaT)-min(totalEnergy_deltaT));

%  
approx_poly = polyfit(tt, totalEnergy_deltaT,4);
y1 = polyval(approx_poly,tt);
figure()
plot( tt, totalEnergy_deltaT,'o');
hold on
plot(tt,y1)
xlabel('Zeit in s');
ylabel('Energie in V^2');
grid on
title(['Energie des Spektrograms innerhalb von \DeltaT=' num2str(windowLength/fs) 's']);
% save figure in 'png', 'pdf', 'svg', 'fig'

baseFileName =  sprintf('%s%sEnergydt.png',Aufgabe, Arm{kanalNummer});
baseFileName = fullfile(taskDir, baseFileName);
saveas(gcf, baseFileName);

%baseFileName =  sprintf('%s%sEnergydt.pdf',Aufgabe, Arm{kanalNummer});
%baseFileName = fullfile(taskDir, baseFileName);
%saveas(gcf, baseFileName);

%baseFileName =  sprintf('%s%sEnergydt.svg',Aufgabe, Arm{kanalNummer});
%baseFileName = fullfile(taskDir, baseFileName);
%saveas(gcf, baseFileName);

%baseFileName =  sprintf('%s%sEnergydt.fig',Aufgabe, Arm{kanalNummer});
%baseFileName = fullfile(taskDir, baseFileName);
%saveas(gcf, baseFileName);



%extract frequency row at time i
i = 1;
st0 = s(1:end, i);
cumsumNormed = cumsum(abs(st0).^2)/sum(abs(st0).^2);
figure()
plot(cumsumNormed)

% Einheit der Energie wahrscheinlich falsch
ylabel('Normalized Energy (V^2)')
title('Normalized Energy at first STFT window');
xlabel('Frequency(Hz)');
% Get Frequency where half of the energy is covered
Energy50 = find(cumsumNormed>0.5);
Energy50 = Energy50(1);

%helper value since indexing cannot be done in one line, compared to python
numRepeats = size(s);
cumsumNormedAll = cumsum(abs(s).^2,1)./repmat(sum(abs(s).^2,1),numRepeats(1),1);

% compare result with manually extracted first time step, st0
%test=sum(cumsumNormed-cumsumNormedAll(1:end,1))
quantile_th = 0.95;
quantiles = zeros(size(cumsumNormedAll,2),1);
for i = 1:size(cumsumNormedAll,2)
    quantiles(i) = find(cumsumNormedAll(1:end,i) > quantile_th, 1, 'first');
end
figure()
plot(quantiles)
xlabel('Zeit in s');
ylabel('Frequenz in HZ');
title(['Eckfrequenzen bei ' num2str(quantile_th) ' der gesamten Energie']);
% save figure in 'png', 'pdf', 'svg', 'fig'
Arm={'links', 'rechts'};
baseFileName =  sprintf('%s%s%sEnergydt.png',Aufgabe, Arm{kanalNummer}, num2str(quantile_th));
baseFileName = fullfile(taskDir, baseFileName);
saveas(gcf, baseFileName);

baseFileName =  sprintf('%s%s%sEnergydt.pdf',Aufgabe, Arm{kanalNummer}, num2str(quantile_th));
baseFileName = fullfile(taskDir, baseFileName);
saveas(gcf, baseFileName);

%baseFileName =  sprintf('%s%s%sEnergydt.svg',Aufgabe, Arm{kanalNummer}, num2str(quantile_th));
%baseFileName = fullfile(taskDir, baseFileName);
%saveas(gcf, baseFileName);

%baseFileName =  sprintf('%s%s%sEnergydt.fig',Aufgabe, Arm{kanalNummer}, num2str(quantile_th));
%baseFileName = fullfile(taskDir, baseFileName);
%saveas(gcf, baseFileName);




%Lösche die übrigen Variablen
clearvars -except quantiles totalEnergy_deltaT;