% spsp_interf_cancel
% Illustrate interference suppression capability of spread spectrum

clear all

% Number of bits;  code length

N=256;

H=hadamard(N);
A=2*(randi([0 1],N)-0.5);

% Choose Hadamard code randomly
h1=H(:,randi([2 N]));
h2=H(:,randi([2 N]));
[hc,lags]=xcorr(h1,h2);

% Generate Kasami sequence
kasamiSequence = comm.KasamiSequence('Polynomial',[8 4 3 2 0], ...
    'InitialConditions',[0 0 0 0 0 0 0 1],'SamplesPerFrame',255);
kasSeq = kasamiSequence();
kas1 = 2*kasSeq - 1;
release(kasamiSequence)
kasamiSequence.Polynomial = 'x^8 + x^3 + 1';

kasSeq = kasamiSequence();
kas2 = 2*kasSeq - 1;
[kc,lags]=xcorr(kas1,kas2);

plot(lags,hc(1:size(kc)),'-*r',lags,kc,'-ob','markersize',3);

grid
xlabel('Time')
ylabel('Cross-correlation')
title('Kasami and Hadamard codes cross-correlations')
ylim([0,25])

