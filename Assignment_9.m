n=100;
x=rand(1,n);
h1=exp(-0.5*(x.^2));
h2=-h1;
snr1=(abs(h1)).^2;
snr2=0.5*(((abs(h1)).^2)+((abs(h2)).^2));
hist(snr1)
hist(snr2)
