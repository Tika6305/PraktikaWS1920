function [] = plausibilityTest(Kanal1,Kanal2)
%Überprüft ob im Kanal 1 oder Kanal 2 Werte größer 1V aufgetreten sind
%Falls ja, dann kommt ein Pop-Up
%Falls nein, Ausgabe 'Daten sind plausibel'

error_found = 0;

if (max(abs(Kanal1)) > 10^6)
    waitfor(msgbox('Im Kanal 1 ist ein Wert größer 1V aufgetreten'))
    error_found = 1;
end

if (max(abs(Kanal2)) > 10^6)
    waitfor(msgbox('Im Kanal 2 ist ein Wert größer 1V aufgetreten'))
    error_found = 1;
end

if error_found == 1
    return
else
    
disp('Daten sind plausibel');

clearvars error_found;
end

