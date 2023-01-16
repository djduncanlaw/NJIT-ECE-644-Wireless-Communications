% qam_example

clear all
clc

% Define parameters
M = 16;                     % Size of signal constellation
k = log2(M);                % Number of bits per symbol
n = 30000;                  % Number of bits to process
numSamplesPerSymbol = 1;    % Oversampling factor

% Create a binary data stream as a column vector.
rng default                 % Use default random number generator
dataIn = randi([0 1],n,1);  % Generate vector of binary data

% Plot the first 40 bits in a stem plot.
stem(dataIn(1:40),'filled');
title('Random Bits');
xlabel('Bit Index');
ylabel('Binary Value');
%% 


%Convert the Binary Signal to an Integer-Valued Signal
% The qammod function implements a rectangular, M-ary QAM modulator, 
% M being 16 in this example. The default configuration is such that the 
% object receives integers between 0 and 15 rather than 4-tuples of bits. 
% In this example, we preprocess the binary data stream dataIn before using
% the qammod function. In particular, the bi2de function is used to convert
% each 4-tuple to a corresponding integer.
% Perform a bit-to-symbol mapping.

% Reshape data into binary k-tuples, k = log2(M)
dataInMatrix = reshape(dataIn,length(dataIn)/k,k);   
% Convert to integers
dataSymbolsIn = bi2de(dataInMatrix);                 

% Plot the first 10 symbols in a stem plot.
%figure; % Create new figure window.
stem(dataSymbolsIn(1:10));
title('Random Symbols');
xlabel('Symbol Index');
ylabel('Integer Value');
%% 


% Modulate using 16-QAM. Binary and Gray. 
dataMod = qammod(dataSymbolsIn,M,0);         % Binary coding, phase offset = 0
dataModG = qammod(dataSymbolsIn,M,0,'gray'); % Gray coding, phase offset = 0

% SNR per symbol given SNR per bit per sample
EbNo = 20;
snr = EbNo + 10*log10(k) - 10*log10(numSamplesPerSymbol);

% Received signal with AWGN
receivedSignal = awgn(dataMod,snr,'measured');
receivedSignalG = awgn(dataModG,snr,'measured');

% Constellation of received samples
sPlotFig = scatterplot(receivedSignal,1,0,'g.');
hold on
scatterplot(dataMod,1,0,'k*',sPlotFig)
%% 


% Demodulate 16 QAM. 
% The qamdemod function is used to demodulate the received data and 
% output integer-valued data symbols.
dataSymbolsOut = qamdemod(receivedSignal,M);
dataSymbolsOutG = qamdemod(receivedSignalG,M,0,'gray');

% Convert the Integer-Valued Signal to a Binary Signal
dataOutMatrix = de2bi(dataSymbolsOut,k);
dataOut = dataOutMatrix(:);                   % Return data in column vector
dataOutMatrixG = de2bi(dataSymbolsOutG,k);
dataOutG = dataOutMatrixG(:);                 % Return data in column vector

% Compute the System BER
[numErrors,ber] = biterr(dataIn,dataOut);
fprintf('\nThe binary coding bit error rate = %5.2e, based on %d errors\n', ...
    ber,numErrors)
[numErrorsG,berG] = biterr(dataIn,dataOutG);
fprintf('\nThe Gray coding bit error rate = %5.2e, based on %d errors\n', ...
    berG,numErrorsG)
%% 


% Observe that Gray coding significantly reduces the bit error rate.

% Binary Symbol Mapping for 16-QAM Constellation. Generate and plot. 
M = 16;                         % Modulation order
x = (0:15)';                    % Integer input
y1 = qammod(x,16,'bin');        % 16-QAM output
scatterplot(y1)
text(real(y1)+0.1, imag(y1), dec2bin(x))
title('16-QAM, Binary Symbol Mapping')
axis([-4 4 -4 4])
%% 


% Gray-coded Symbol Mapping for 16-QAM Constellation. Generate and plot. 
y2 = qammod(x,16,'gray');  % 16-QAM output, Gray-coded
scatterplot(y2)
text(real(y2)+0.1, imag(y2), dec2bin(x))
title('16-QAM, Gray-coded Symbol Mapping')
axis([-4 4 -4 4])

% Pulse Shaping Using a Raised Cosine Filter
M = 16;                     % Size of signal constellation
k = log2(M);                % Number of bits per symbol
numBits = 3e5;              % Number of bits to process
numSamplesPerSymbol = 4;    % Oversampling factor
%% 


% Set the square-root, raised cosine filter parameters.
span = 10;        % Filter span in symbols
rolloff = 0.25;   % Roloff factor of filter

% Create a square-root, raised cosine filter using the rcosdesign function.
rrcFilter = rcosdesign(rolloff, span, numSamplesPerSymbol);

% Display the RRC filter
fvtool(rrcFilter,'Analysis','Impulse')
%% 


% Now perform simulation to evaluate BER
% Reshape the input vector into a matrix of 4-bit binary data,
% which is then converted into integer symbols.

dataInMatrix = reshape(dataIn, length(dataIn)/k, k); % Reshape data into binary 4-tuples
dataSymbolsIn = bi2de(dataInMatrix);                 % Convert to integers

%Apply 16-QAM modulation using qammod.
dataMod = qammod(dataSymbolsIn, M);

%Using the upfirdn function, upsample and apply the square-root, raised cosine filter.
txSignal = upfirdn(dataMod, rrcFilter, numSamplesPerSymbol, 1);

% The upfirdn function upsamples the modulated signal, dataMod,
% by a factor of numSamplesPerSymbol.
% Set the Eb/N0 to 10 dB and convert the SNR given the number of bits per symbol,
% k, and the number of samples per symbol.
EbNo = 10;
snr = EbNo + 10*log10(k) - 10*log10(numSamplesPerSymbol);

% Pass the filtered signal through an AWGN channel.
rxSignal = awgn(txSignal, snr, 'measured');

% Filter the received signal 
rxFiltSignal = upfirdn(rxSignal,rrcFilter,1,numSamplesPerSymbol);   % Downsample and filter
rxFiltSignal = rxFiltSignal(span+1:end-span);                       % Account for delay

% Apply 16-QAM demodulation to the received, filtered signal.
dataSymbolsOut = qamdemod(rxFiltSignal, M);

%Using the de2bi function, convert the incoming integer symbols into binary data.
dataOutMatrix = de2bi(dataSymbolsOut,k);
dataOut = dataOutMatrix(:);                 % Return data in column vector

%Apply the biterr function to determine the number of errors and the associated BER.
[numErrors, ber] = biterr(dataIn, dataOut);
fprintf('\nThe bit error rate = %5.2e, based on %d errors\n', ...
    ber, numErrors)

% Eye diagram
eyediagram(txSignal(1:2000),numSamplesPerSymbol*2);
%% 

% Constellation diagram
h = scatterplot(sqrt(numSamplesPerSymbol)*...
    rxSignal(1:numSamplesPerSymbol*5e3),...
    numSamplesPerSymbol,0,'g.');
hold on;
scatterplot(rxFiltSignal(1:5e3),1,0,'kx',h);
title('Received Signal, Before and After Filtering');
legend('Before Filtering','After Filtering');
axis([-5 5 -5 5]); % Set axis ranges
hold off;










































