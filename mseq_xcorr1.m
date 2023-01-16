% mseq_xcorr
% Examples of cross-correlation of Hadamard and of random codes

clc; clear all;

N=32;
A=randi([0 1],2,N);
d1=2*A(1,:)-1;
d2=2*A(2,:)-1;

[rc,lags]=xcorr(d1,d2);

H=hadamard(N);
h1=H(randi([2 N]),:);
h2=H(randi([2 N]),:);
[hc,lags]=xcorr(h1,h2);

plot(lags,rc,'-*r',lags,hc,'-ob','markersize',4);
title('Cross Correlation of Hadamard sequences');
ylabel('Xcorr');
xlabel('Lag');
grid on;
