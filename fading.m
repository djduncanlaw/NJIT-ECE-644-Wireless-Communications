clear

a =(1/sqrt(2))*(randn(100,1)+j*randn(100,1));
b =(1/sqrt(2))*(randn(100,1)+j*randn(100,1));
y1 = 20*log10(abs(a));
plot(y1,'-r')
grid
hold

y2 = 20*log10(abs(b));
y3 = 20*log10(0.5*(10.^(y1/20)+10.^(y2/20)));
%plot(y3,'-b')
xlabel('Time')
ylabel('Power [dB]')
