function [Kanal1_power_spectrum_ein, Kanal2_power_spectrum_ein ] = calcAndDisplayPowerspectrum( f, fs, Kanal1, Kanal2, f_end )
% Laut https://de.wikipedia.org/wiki/Spektrale_Leistungsdichte wird
% erst quadriert und dann durch 2*T geteilt
N = length(Kanal1);
%Berechne die Leistungsspektren von Kanal 1 und Kanal 2

%Zweiseitiges Betragsspektrum
Kanal1_Betrag_zwei = abs(fft(Kanal1));
Kanal2_Betrag_zwei = abs(fft(Kanal2));

%Einseitiges Betragsspektrum
Kanal1_Betrag_ein = Kanal1_Betrag_zwei(1:N/2)*2;
Kanal2_Betrag_ein = Kanal2_Betrag_zwei(1:N/2)*2;


%Zweiseitiges Leistungsspektrum
signalLength = (N);
% Es wird durch 2*T geteilt, selbst wenn das Signal bei t=0 startet
% Siehe: https://www.lntwww.de/Signaldarstellung/Klassifizierung_von_Signalen
Kanal1_power_spectrum_zwei = Kanal1_Betrag_zwei.^2/(2*signalLength);
Kanal2_power_spectrum_zwei = Kanal2_Betrag_zwei.^2/(2*signalLength);

%Einseitiges Leistungsspektrum
Kanal1_power_spectrum_ein = Kanal1_power_spectrum_zwei(1:(N/2))*2;
Kanal2_power_spectrum_ein = Kanal2_power_spectrum_zwei(1:(N/2))*2;

%Plotte Signale
%Plotte Frequenzspektrum
figure('Name', 'Frequenzsspektrum')
subplot(2,1,1);
plot(f(1,1:floor(f_end/(fs/N))),Kanal1_Betrag_ein(1:floor(f_end/(fs/N)),1));
legend('Kanal 1');
xlabel('Frequenz in Hz');
ylabel('|X(f)|');
title('Einseitiges Betragsspektrum')
subplot(2,1,2);
plot(f(1,1:floor(f_end/(fs/N))),Kanal2_Betrag_ein(1:floor(f_end/(fs/N)),1));
legend('Kanal 2');
xlabel('Frequenz in Hz');
ylabel('|X(f)|');



%Plotte Leistungsspektrum
%Die Signale und die Frequenzachse werden so manipuliert, dass die oberste
%Frequenz im Spektrum eingestellt werden kann über f_end
figure('Name', 'Leistungsspektrum')
subplot(2,1,1);
plot(f(1,1:floor(f_end/(fs/N))),Kanal1_power_spectrum_ein(1:floor(f_end/(fs/N)),1));
legend('Kanal 1');
xlabel('Frequenz in Hz');
ylabel('|X(f)|^2');
title('Einseitiges Leistungsspektrum')
subplot(2,1,2);
plot(f(1,1:floor(f_end/(fs/N))),Kanal1_power_spectrum_ein(1:floor(f_end/(fs/N)),1));
legend('Kanal 2');
xlabel('Frequenz in Hz');
ylabel('|X(f)|^2');

end

