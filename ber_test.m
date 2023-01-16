% ber_test
% Estimate simulation BER for binary communication and compare to
% theoretical result.

clear

% Number of samples used to compute errors. 
N=1e6;

% To demonstrate optimality of test comparing to zero, offset the test by d
d=0.1;

% SNR range in dB
snr_min=0; snr_max=12;
snr=(snr_min:1:snr_max);


for k=snr_min+1:snr_max+1,
    s=sign(rand(1,N)-0.5);
    z=(1/sqrt(10^((k-1)/10)))*randn(1,N);
    r=s+z;
    y=sign(r+d);
    e(k)=numel(find(y~=s));
    ber(k)=e(k)/N;
end

semilogy(snr,ber,snr,qfunc(sqrt(10.^(snr/10))),'linewidth',1.5)
grid
xlabel 'SNR (dB)', ylabel('BER')

    