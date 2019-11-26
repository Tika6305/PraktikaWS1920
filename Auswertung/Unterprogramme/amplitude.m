function [mvc_k1, mvc_k2] = amplitude( kanal1, kanal2 )
% Diese Funktion bestimmt die Amplitude der jeweiligen Kanäle sowie das
% Amplitudenmaximum (MVC).

% Signal in muV
kanal1 = kanal1*1000*1000;
kanal2 = kanal2*1000*1000;

mvc_k1= max(kanal1);
mvc_k2= max(kanal2);

% Ausgabe MVC
disp('Amplituden- und Frequenzparameter:');
disp(['MVC (Kanal 1) = ', num2str(mvc_k1), ' uV']);
disp(['MVC (Kanal 2) = ', num2str(mvc_k2), ' uV']);

clearvars kanal1 kanal2
end