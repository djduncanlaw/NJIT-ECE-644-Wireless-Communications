%% Modeling the Propagation of RF Signals
% This example shows how to model several RF propagation effects. These
% include free space path loss, atmospheric attenuation due to rain, fog
% and gas, and multipath propagation due to bounces on the ground. This
% discussion is based on the International Telecommunication Union's ITU-R
% P series recommendations. ITU-R is the organization's radio communication
% sector and the P series focuses on radio wave propagation.

% Copyright 2015-2016 The MathWorks, Inc.

%% Introduction
% To properly evaluate the performance of radar and wireless communication
% systems, it is critical to understand the propagation environment. Using
% radar as an example, the received signal power of a monostatic radar is
% given by the radar range equation:
%
% $$ P_r = \frac{P_tG^2\sigma\lambda^2}{(4\pi)^3R^4L}$$
%
% where $P_t$ is the transmitted power, $G$ is the antenna gain, $\sigma$
% is the target radar cross section (RCS), $\lambda$ is the wavelength, and
% $R$ is the propagation distance. All propagation losses other than free
% space path loss are included in the $L$ term. The rest of example shows
% how to estimate this $L$ term in different scenarios.

%% Free Space Path Loss
% First, the free space path loss is computed as a function of propagation
% distance and frequency. In free space, RF signals propagate at a constant
% speed of light in all directions. At a far enough distance, the radiating
% source looks like a point in space and the wavefront forms a sphere whose
% radius is equal to $R$. The power density at the wavefront is inversely
% proportional to $R^2$
%
% $$ \frac{P_t}{4\pi R^2} $$
%
% where $P_t$ is the transmitted signal power. For a monostatic radar where
% the signal has to travel both directions (from the source to the target
% and back), the dependency is actually inversely proportional to $R^4$, as
% shown previously in the radar equation. The loss related to this
% propagation mechanism is referred to as free space path loss, sometimes
% also called the spreading loss. Quantitatively, free space path loss is
% also a function of frequency, given by [5]
%
% $$L_{fs} = 20*\log_{10}(\frac{4\pi R}{\lambda}) \quad dB$$
%
% As a convention, propagation losses are often expressed in dB. This
% convention makes it much easier to derive the two-way free space path
% loss by simply doubling the one-way free space loss. 
%
% The following figure plots how the free space path loss changes over the
% frequency between 10 to 1000 GHz for different ranges.

c = physconst('lightspeed');
R0 = [10 1e2 10e2]; 
freq = (10:1000).'*1e9;
apathloss = fspl(R0,c./freq);
figure
loglog(freq/1e9,apathloss); 
grid on; ylim([50 150])
legend('Range: 100 m', 'Range: 1 km', 'Range: 10 km')
xlabel('Frequency (GHz)'); 
ylabel('Path Loss (dB)')
title('Free Space Path Loss')


%%
% The figure illustrates that the propagation loss increases with range and
% frequency.

%% Propagation Loss due to Rain
% In reality, signals don't travel in a vacuum, so free space path loss
% describes only part of the signal attenuation. Signals interact with
% particles in the air and lose energy along the propagation path. The loss
% varies with different factors such as pressure, temperature, water
% density.
% 
% Rain can be a major limiting factor for a radar systems, especially when
% operating above 5 GHz. In the ITU model in [2], rain is characterized by
% the rain rate (in mm/h). According to [6], the rain rate can range from
% less than 0.25 mm/h for very light rain to over 50 mm/h for extreme
% rains. In addition, because of the rain drop's shape and its relative
% size compared to the RF signal wavelength, the propagation loss due to
% rain is also a function of signal polarization.
%
% The following plot shows how losses due to rain varies with frequency.
% The plot assumes the polarization to be horizontal, so the tilt angle is
% 0. In addition, assume that the signal propagates parallel to the ground,
% so the elevation angle is 0. In general, horizontal polarization
% represents the worse case for propagation loss due to rain.

R0 = 1e3;                % 1 km range
rainrate = [1 4 16 50];  % rain rate in mm/h
el = 0;                  % 0 degree elevation
tau = 0;                 % horizontal polarization

for m = 1:numel(rainrate)
    rainloss(:,m) = rainpl(R0,freq,rainrate(m),el,tau)';
end
figure
loglog(freq/1e9,rainloss); grid on;
legend('Light rain','Moderate rain','Heavy rain','Extreme rain', ...
    'Location','SouthEast');
xlabel('Frequency (GHz)'); 
ylabel('Rain Attenuation (dB/km)')
title('Rain Attenuation for Horizontal Polarization');

%%
% Similar to rainfall, snow can also have a significant impact on the
% propagation of RF signals. However, there is no specific model to compute
% the propagation loss due to snow. The common practice is to treat it as
% rainfall and compute the propagation loss based on the rain model, even
% though this approach tends to overestimate the loss a bit.

%% Propagation Loss due to Fog and Cloud
% Fog and cloud are formed with water droplets too, although much smaller
% compared to rain drops. The size of fog droplets are generally less than
% 0.01 cm. Fog is often characterized by the liquid water density. A medium
% fog with a visibility of roughly 300 meters, has a liquid water density
% of 0.05 g/m^3. For heavy fog where the visibility drops to 50 meters, the
% liquid water density is about 0.5 g/m^3. The atmosphere temperature (in
% Celsius) is also present in the ITU model for propagation loss due to fog
% and cloud [3].
%
% The next plot shows how the propagation loss due to fog varies with
% frequency. 

T = 15;                      % 15 degree Celsius
waterdensity = [0.05 0.5];   % liquid water density in g/m^3
for m = 1: numel(waterdensity)
    fogloss(:,m) = fogpl(R0,freq,T,waterdensity(m))';
end
figure
loglog(freq/1e9,fogloss); grid on;
legend('Medium fog','Heavy fog');
xlabel('Frequency (GHz)'); 
ylabel('Fog Attenuation (dB/km)')
title('Fog Attenuation');

%%
% Note that in general fog is not present when it is raining.

%% Propagation Loss due to Atmospheric Gases
% Even when there is no fog or rain, the atmosphere is full of gases that
% still affect the signal propagation. The ITU model [4] describes
% atmospheric gas attenuation as a function of both dry air pressure, like
% oxygen, measured in hPa, and water vapour density, measured in g/m^3.
%
% The plot below shows how the propagation loss due to atmospheric gases
% varies with the frequency. Assume a dry air pressure of 1013 hPa at 15
% degrees Celsius, and a water vapour density of 7.5 g/m^3.

P = 101300; % dry air pressure in Pa
ROU = 7.5;  % water vapour density in g/m^3
gasloss = gaspl(R0,freq,T,P,ROU);
figure
loglog(freq/1e9,gasloss); grid on;
xlabel('Frequency (GHz)'); 
ylabel('Atmospheric Gas Attenuation (dB/km)')
title('Atmospheric Gas Attenuation');

%%
% The plot suggests that there is a strong absorption due to atmospheric
% gases at around 60 GHz.
%
% The next figure compares all weather related losses for a 77 GHz
% automotive radar. The horizontal axis is the target distance from the
% radar. The maximum distance of interest is about 200 meters. 

R = (1:200).';
fc77 = 77e9;   
apathloss = fspl(R,c/fc77);           

rr = 16;  % heavy rain
arainloss = rainpl(R,fc77,rr,el,tau); 

M = 0.5; % heavy fog
afogloss = fogpl(R,fc77,T,M);         

agasloss = gaspl(R,fc77,T,P,ROU);   

% Multiply by 2 for two-way loss
figure
semilogy(R,2*[apathloss arainloss afogloss agasloss]); 

grid on;
xlabel('Propagation Distance (m)'); 
ylabel('Path Loss (dB)');
legend('Free space','Rain','Fog','Gas','Location','Best')
title('Path Loss for 77 GHz Radar');

%%
% The plot suggests that for a 77 GHz automotive radar, the free space path
% loss is the dominant loss. Losses from fog and atmospheric gasses are
% negligible, accounting for less than 0.5 dB. The loss from rain can get
% close to 3 dB at 180 m.

%% Propagation Delay and Doppler Shift on top of Propagation Loss
% Functions mentioned above for computing propagation losses, are useful to
% establish budget links. To simulate the propagation of arbitrary signals,
% we also need to apply range-dependent time delays, gains and phase
% shifts.
%
% The code below simulates an air surveillance radar operated at 24 GHz.

fc = 24e9;

%%
% First, define the transmitted signal. A rectangular waveform will be used
% in this case

waveform = phased.RectangularWaveform;
wav = waveform();

%%
% Assume the radar is at the origin and the target is at a 5 km range, of
% the direction of 45 degrees azimuth and 10 degrees elevation. In
% addition, assume the propagation is along line of sight (LOS), a heavy
% rain rate of mm/h with no fog.

Rt = 5e3;
az = 45;
el = 10;
pos_tx = [0;0;0];
pos_rx = [Rt*cosd(el)*cosd(az);Rt*cosd(el)*sind(az);Rt*sind(el)];
vel_tx = [0;0;0];
vel_rx = [0;0;0];

loschannel = phased.LOSChannel(...
    'PropagationSpeed',c,...
    'OperatingFrequency',fc,...
    'SpecifyAtmosphere',true,...
    'Temperature',T,...
    'DryAirPressure',P,...
    'WaterVapourDensity',ROU,...
    'LiquidWaterDensity',0,...    % No fog
    'RainRate',rr,...
    'TwoWayPropagation', true)

%%
% The received signal can then be simulated as

y = loschannel(wav,pos_tx,pos_rx,vel_tx,vel_rx);

%%
% The total loss can be computed as

L_total = pow2db(bandpower(wav))-pow2db(bandpower(y))

%%
% To verify the power loss obtained from the simulation, compare it with
% the result from the analysis below and make sure they match.

Lfs = 2*fspl(Rt,c/fc);
Lr = 2*rainpl(Rt,fc,rr,el,tau);
Lg = 2*gaspl(Rt,fc,T,P,ROU);

L_analysis = Lfs+Lr+Lg

%% Multipath Propagation
% Signals may not always propagate along the line of sight. Instead, some
% signals can arrive at the destination via different paths through
% reflections and may add up either constructively or destructively. This
% multipath effect can cause significant fluctuations in the received
% signal.
%
% Ground reflection is a common phenomenon for many radar or wireless
% communication systems. For example, when a base station sends a signal to
% a mobile unit, the signal not only propagates directly to the mobile
% unit but is also reflected from the ground.

%%
% Assume an operating frequency of 1900 MHz, as used in LTE, such a channel
% can be modeled as

fc = 1900e6;
tworaychannel = phased.TwoRayChannel('PropagationSpeed',c,...
    'OperatingFrequency',fc);

%%
% Assume the mobile unit is 1.6 meters above the ground, the base
% station is 100 meters above the ground at a 500 meters distance. Simulate
% the signal received by the mobile unit.

pos_base = [0;0;100];
pos_mobile = [500;0;1.6];
vel_base = [0;0;0];
vel_mobile = [0;0;0];
y2ray = tworaychannel(wav,pos_base,pos_mobile,vel_base,vel_mobile);

%%
% The signal loss suffered in this channel can be computed as

L_2ray = pow2db(bandpower(wav))-pow2db(bandpower(y2ray))

%% 
% The free space path loss is given by

L_ref = fspl(norm(pos_mobile-pos_base),c/fc)

%%
% The result suggests that in this configuration, the channel introduces an
% extra 17 dB loss to the received signal compared to the free space case.
% Now assume the mobile user is a bit taller and holds the mobile unit at
% 1.8 meters above the ground. Repeating the simulation above suggests that
% this time the ground reflection actually provides a 6 dB gain! Although
% free space path loss is essentially the same in the two scenarios, a 20
% cm move caused a 23 dB fluctuation in signal power.

pos_mobile = [500;0;1.8];
y2ray  = tworaychannel(wav,pos_base,pos_mobile,vel_base,vel_mobile);
L_2ray = pow2db(bandpower(wav))-pow2db(bandpower(y2ray))
L_ref  = fspl(norm(pos_mobile-pos_base),c/fc)

%% Wideband Propagation in a Multipath Environment
% Increasing a system's bandwidth increases the capacity of its channel.
% This enables higher data rates in communication systems and finer range
% resolutions for radar systems. The increased bandwidth can also improve
% robustness to multipath fading for both systems.
% 
% Typically, wideband systems operate with a bandwidth of greater than 5%
% of their center frequency. In contrast, narrowband systems operate with a
% bandwidth of 1% or less of the system's center frequency.
%
% The narrowband channel in the preceding section was shown to be very
% sensitive to multipath fading. Slight changes in the mobile unit's height
% resulted in considerable signal losses. The channel's fading
% characteristics can be plotted by varying the mobile unit's height across
% a span of operational heights for this wireless communication system. A
% span of heights from 10cm to 3m is chosen to cover a likely range for
% mobile unit usage.

% Simulate the signal fading at mobile unit for heights from 10cm to 3m
hMobile = linspace(0.1,3);
pos_mobile = repmat([500;0;1.6],[1 numel(hMobile)]);
pos_mobile(3,:) = hMobile;
vel_mobile = repmat([0;0;0],[1 numel(hMobile)]);

release(tworaychannel);
y2ray = tworaychannel(repmat(wav,[1 numel(hMobile)]),...
    pos_base,pos_mobile,vel_base,vel_mobile);

%%
% The signal loss observed at the mobile unit for the narrowband system can
% now be plotted.
L2ray = pow2db(bandpower(wav))-pow2db(bandpower(y2ray));
figure
plot(hMobile,L2ray);
xlabel('Mobile Unit''s Height (m)');
ylabel('Channel Loss (dB)');
title('Multipath Fading Observed at Mobile Unit');
grid on;

%%
% The sensitivity of the channel loss to the mobile unit's height for this
% narrowband system is clear. Deep signal fades occur at heights that are
% likely to be occupied by the system's users.
%
% Increasing the channel's bandwidth can improve the communication link's
% robustness to these multipath fades. To do this, a wideband waveform is
% defined with a bandwidth of 10% of the link's center frequency.
bw = 0.10*fc;
pulse_width = 1/bw;
fs = 2*bw;

waveform = phased.RectangularWaveform('SampleRate',fs,...
    'PulseWidth',pulse_width);
wav = waveform();

%%
% A wideband two-ray channel model is also required to simulate the
% multipath reflections of this wideband signal off of the ground between
% the base station and the mobile unit and to compute the corresponding
% channel loss.
widebandTwoRayChannel = ...
    phased.WidebandTwoRayChannel('PropagationSpeed',c,...
    'OperatingFrequency',fc,'SampleRate',fs);

%%
% The received signal at the mobile unit for various operational heights
% can now be simulated for this wideband system.
y2ray_wb = widebandTwoRayChannel(repmat(wav,[1 numel(hMobile)]),...
    pos_base,pos_mobile,vel_base,vel_mobile);
L2ray_wb = pow2db(bandpower(wav))-pow2db(bandpower(y2ray_wb));

hold on;
plot(hMobile,L2ray_wb);
hold off;
legend('Narrowband','Wideband');

%%
% As expected, the wideband channel provides much better performance across
% a wide range of heights for the mobile unit. In fact, as the height of
% the mobile unit increases, the impact of multipath fading almost
% completely disappears. This is because the difference in propagation
% delay between the direct and bounce path signals is increasing, reducing
% the amount of coherence between the two signals when received at the
% mobile unit.

%% Conclusion
% This example provides a brief overview of RF propagation losses due to
% atmospheric and weather effects. It also introduces multipath signal
% fluctuations due to bounces on the ground. It highlighted functions and
% objects to calculate attenuation losses and simulate range-dependent time
% delays and Doppler shifts.

%% References
%  [1] John Seybold, Introduction to RF Propagation, Wiley, 2005
%
%  [2] Recommendation ITU-R P.838-3, 2005
%
%  [3] Recommendation ITU-R P.840-3, 2013
%
%  [4] Recommendation ITU-R P.676-10, 2013
%
%  [5] Recommendation ITU-R P.525-2, 1994
%
displayEndOfDemoMessage(mfilename)
