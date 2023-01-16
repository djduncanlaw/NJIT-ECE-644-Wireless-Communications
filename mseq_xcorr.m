% mseq_xcorr
% Examples of cross-correlation of Hadamard and of random codes

clc; clear all;

N=32;
A=randi([0 1],2,N);
d1=A(1,:);
d2=A(2,:);

[rc,lags]=crossCorr(d1,d2);

H=hadamard(N);
h1=0.5*H(4,:)+0.5;
h2=0.5*H(9,:)+0.5;
[hc,lags]=crossCorr(h1,h2);

plot(lags,rc,'-*r',lags,hc,'-ob','markersize',4);
title('Cross Correlation of Hadamard sequences');
ylabel('Xcorr');
xlabel('Lag');
grid on;
