%% Lösche Command Window und Workspace, Schließe alle Figures

clc;
close all;
clear;
addpath Unterprogramme;   %Lade Ordner mit Unterprogrammen

%% Lese Kanal 1 und Kanal 2 aus

%User abfragen wo Datei liegt und wie sie heisst
[filename, foldername] = userRequest;
Aufgabe = filename(end-3+1:end);

% Make Directory for each dataset
taskDir = ['Aufgabe' Aufgabe];
if ~exist(taskDir, 'dir')
   mkdir(taskDir)
end

%Lese Daten ein
[kanal1, kanal2] = txtToWorkspace(filename,foldername);
%Berechne beide Signale in Volt 
% Wenn Grundeinheit 1 entspricht 10muV dann 10muV=10*10^-6V
kanal1 = kanal1/1000/1000/10;
kanal2 = kanal2/1000/1000/10; 
%Mache Plausibilitätscheck
plausibilityTest(kanal1,kanal2);
%Lösche die übrigen Variablen
clearvars filename foldername


%% Darstellung
fs = 2048;          % Samplingfrequenz
%Berechne Zeitachse
N  = length(kanal1);
t  = 0: 1/fs: (N-1)/fs;
%Berechne Frequenzachse
f_delta = fs/N;
f = 0: f_delta: f_delta*(N-1); 
%Plotte Signal in Zeitbereich
displayTimeDomain(t,kanal1,kanal2);
[kanal1_cut, kanal2_cut, t_cut] = cutSignals(kanal1, kanal2,fs,t);
% Darstellunng des gekürzten Signal
displayTimeDomain(t_cut,kanal1_cut,kanal2_cut);

%% Filterung

%Filterparameter:
N_butter   = 6;     % Ordnung
Fu = 10;            % Untere Cutofffrequenz
Fo = 701;           % Obere Cutofffrequenz


%Filterdesign festlegen
h  = fdesign.bandpass('N,F3dB1,F3dB2', N_butter, Fu, Fo, fs);
%Filter designen und Transferfunktion berechnen
[b, a] = tf(design(h, 'butter')); 
%Signal filtern (0-Phasen-Filterung)
kanal1_cut = filtfilt(b,a,kanal1_cut); 
kanal2_cut = filtfilt(b,a,kanal2_cut); 

%Lösche die übrigen Variablen
clearvars h b a Fu Fo N_butter


%%Testsignal
%kanal1 = 4*sin(2*pi*t*32)';
%Leistung des sinus 4^2/2


%Plotte Leistungsspektrum
f_end = 700; %Bis zu dieser Frequenz geht der Plot
%Lösche die übrigen Variablen
clearvars f_delta N

% Bestimmung Amplitudenparameter
% Verkürzen auf das Nutzsignal
[mvc_k1_cut, mvc_k2_cut]= amplitude(kanal1_cut, kanal2_cut);
amp_values = calcAmpValues( kanal1_cut, kanal2_cut, mvc_k1_cut, mvc_k2_cut );

% Bestimmung Frequenzparameter
[kanal1_power_ein_cut, kanal2_power_ein_cut] = calcAndDisplayPowerspectrum(f,fs,kanal1_cut,kanal2_cut,f_end);
freq_values = calcFreqValues( kanal1_power_ein_cut, kanal2_power_ein_cut,f );

% See how Energy and Voltage changes with time useful for Task No. 4
[quantiles, totalEnergy_deltaT] = displaySTFT(fs,kanal1_cut,kanal2_cut,Aufgabe);


clearvars mvc_k1 mvc_k2 

