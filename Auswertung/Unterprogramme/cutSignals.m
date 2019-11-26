function [kanal1_cut, kanal2_cut, t_cut,i] = cutSignals(kanal1, kanal2,fs,t)
%Was steht im Fenster der Abfrage?
prompt = {'Schneide Zeitbereich von Interesse','Startzeit in s:','Endzeit in s:'};
%Wie groß ist das Fenster?
dims = [1 45];
%Was ist der Titel des Fensters
dlgtitle = 'Userabfrage';
%Was sind die default Werte?
totalSignalLength = size(kanal1);
totalSignalLength_sec = totalSignalLength(1)/fs;
definput = {'ignored','0',num2str(totalSignalLength_sec)};
%Speichere die Antwort als inform
inform = inputdlg(prompt,dlgtitle,dims,definput);
% inform = [inform{1} str2num(inform{2}) str2num(inform{3})]
answer = cell2mat(inform(1));
t_1=str2num(cell2mat(inform(2)));
t_2=str2num(cell2mat(inform(3)));
%inform = [cell2mat(inform(1)), (cell2mat(inform(2))), (cell2mat(inform(3)))]

[t_cut] = t(round(t_1*fs+1):round(t_2*fs));
kanal1_cut = kanal1(round(t_1*fs+1):round(t_2*fs));
kanal2_cut = kanal2(round(t_1*fs+1):round(t_2*fs));



%Lösche die übrigen Variablen
clearvars prompt dims definput inform 