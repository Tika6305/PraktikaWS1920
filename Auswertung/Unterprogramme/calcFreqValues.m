function [freq_values] = calcFreqValues( Kanal1_power_ein, Kanal2_power_ein,f )
% Diese Funktion bestimmt die Parameter im Frequenzbereich:
% P_m: mittlere Leistung für beide Kanäle
% SEF_50: spektrale Eckfrequenz bei 50% der Gesamtleistung für beide Kanäle
% SEF_95: spektrale Eckfrequenz bei 95% der Gesamtleistung für beide Kanäle

% Betrachtung der Frequenzen bis zur halben Abtastfrequenz
% (Nyquist-Kriterium)
M = length(Kanal1_power_ein);
Kanal1_power_help= 1/M * Kanal1_power_ein;
Kanal2_power_help= 1/M * Kanal2_power_ein;

% mittlere Leistug, Kanal1_power wurde bereits durch die Anzahl der
% Frequenzen geteilt
P_m_k1 = sum(Kanal1_power_help);
P_m_k2 = sum(Kanal2_power_help);


function quantileFreq=get_quantile(kanal_power_ein,f,quantile)
    cumulative = cumsum(kanal_power_ein)./sum(kanal_power_ein);
    argument = find(cumulative > quantile, 1, 'first');
    quantileFreq=f(argument);
end

%SEF 50%
E_ges_1 = sum(Kanal1_power_help);
E_sum = 0;
i=1;
while 1
E_sum = E_sum + Kanal1_power_help(i);
    if (E_sum > (0.5*E_ges_1))
    i = i-1;
    break
    end
i=i+1;
end
SEF_50_k1 = f(max(i,1));

E_ges_2 = sum(Kanal2_power_help);
E_sum = 0;
i=1;
while 1
E_sum = E_sum + Kanal2_power_help(i);
    if (E_sum > (0.5*E_ges_2))
    i = i-1;
    break
    end
i=i+1;
end
SEF_50_k2 = f(max(i,1));

% SEF 95%
E_sum = 0;
i=1;
while 1
E_sum = E_sum + Kanal1_power_help(i);
    if (E_sum > (0.95*E_ges_1))
    i = i-1;
    break
    end
i=i+1;
end
SEF_95_k1= f(max(i,1));

E_sum = 0;
i=1;
while 1
E_sum = E_sum + Kanal2_power_help(i);
    if (E_sum > (0.95*E_ges_2))
    i = i-1;
    break
    end
i=i+1;
end
SEF_95_k2 = f(max(i,1));

% Ausgabe mittlere Leistung
disp(['P_m (Kanal 1) = ', num2str(P_m_k1), ' V*V']);
disp(['P_m (Kanal 2) = ', num2str(P_m_k2), ' V*V']);

% Ausgabe Spektrale Eckfrequenz
disp(['SEF_50v2 (Kanal 1) = ', num2str(get_quantile(Kanal1_power_help,f,0.5)), ' Hz']);
disp(['SEF_50v2 (Kanal 2) = ', num2str(get_quantile(Kanal2_power_help,f,0.5)), ' Hz']);
disp(['SEF_95v2 (Kanal 1) = ', num2str(get_quantile(Kanal1_power_help,f,0.95)), ' Hz']);
disp(['SEF_95v2 (Kanal 2) = ', num2str(get_quantile(Kanal2_power_help,f,0.95)), ' Hz']);



disp(['SEF_50 (Kanal 1) = ', num2str(SEF_50_k1), ' Hz']);
disp(['SEF_50 (Kanal 2) = ', num2str(SEF_50_k2), ' Hz']);
disp(['SEF_95 (Kanal 1) = ', num2str(SEF_95_k1), ' Hz']);
disp(['SEF_95 (Kanal 2) = ', num2str(SEF_95_k2), ' Hz']);


%Zusammenfassen der Ergebnisse
freq_values = struct('P_m_k1',P_m_k1,'P_m_k2',P_m_k2,'SEF_50_k1',...
                    SEF_50_k1,'SEF_50_k2',SEF_50_k2,'SEF_95_k1',...
                    SEF_95_k1,'SEF_95_k2',SEF_95_k2);

end


