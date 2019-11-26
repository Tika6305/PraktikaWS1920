function [] = displayTimeDomain(t,Kanal1,Kanal2)

max_ch1 = max(Kanal1);
max_ch2 = max(Kanal2);
max_total = 1.1*max(max_ch1,max_ch2);

%Plotte Kanal 1 und 2 in Millivolt
figure('Name', 'Zeitsignale')
subplot(2,1,1);
plot(t,Kanal1.*1000);
legend('Kanal 1');
xlabel('Zeit in s');
ylabel('Spannung in mV');
lim = axis;
axis([lim(1) lim(2) -max_total*1000 max_total*1000]);
subplot(2,1,2);
plot(t,Kanal2.*1000);
legend('Kanal 2');
xlabel('Zeit in s');
ylabel('Spannung in mV');
lim = axis;
axis([lim(1) lim(2) -max_total*1000 max_total*1000]);