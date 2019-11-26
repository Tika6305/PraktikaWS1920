function [filename, foldername] = userRequest()
%Was steht im Fenster der Abfrage?
prompt = {'Hier Dateiname eintragen ohne .txt Endung:','Hier Ordnername eintragen:'};
%Wie groß ist das Fenster?
dims = [1 45];
%Was ist der Titel des Fensters
dlgtitle = 'Userabfrage';
%Was sind die default Werte?
definput = {'wrks_222','G2'};
%Speichere die Antwort als fileadress
fileadress = inputdlg(prompt,dlgtitle,dims,definput);
%Extrahiere den Dateinamen aus der Userantwort (Position1)
filename = cell2mat(fileadress(1));
%Extrahiere den Ordnernamen aus der Userantwort (Position1)
foldername = cell2mat(fileadress(2));

%Lösche die übrigen Variablen
clearvars prompt dims definput fileadress 