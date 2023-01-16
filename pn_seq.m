clear all
pnSequence2 = comm.PNSequence('Polynomial','x^4+x+1', ...
    'InitialConditions',[0 0 0 1],'SamplesPerFrame',255);
x2 = pnSequence2();

x3=2*x2(1:15)-1;

x4=2*randi([0 1],15,1)-1;
xc3=abs(xcorr(x3));
xc4=abs(xcorr(x4));
t=(1:29)';

plot(t,[xc3, xc4])
grid