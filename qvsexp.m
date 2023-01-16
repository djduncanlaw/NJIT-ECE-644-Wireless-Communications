% qvsexp
snr_dB=0:15;
snr=10.^(snr_dB/10);
y1=qfunc(sqrt(snr));
y2=exp(-snr/2);
semilogy(snr_dB,y1,snr_dB,y2,'linewidth',1.5)
title 'qfunc vs. exp'
xlabel 'snr'
ylabel 'function value'
grid
