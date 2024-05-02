%% 3
% 3.1 PAM
%a
clear;clc;
fs = 10^6;  fc=10000; fc_channel=10000; BW=1000;
T = 0.01; 
t = 0:1/fs:T-1/fs;
x = randi([0 ,1],1,100);
pulse1 = ones(1,length(t));
pulse0 = -1*ones(1,length(t));

figure;
stem(x,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
ylabel('b[n]','Interpreter','LaTeX')
title('Binary Input Random Signal','Interpreter','LaTeX')
ylim([-1,2])
grid on;

[b1,b2] = Divide(x);
figure;
subplot(1,2,1)
stem(b1,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('$b_1[n]$','Interpreter','LaTeX')
ylim([-1,2])
grid on;
subplot(1,2,2)
stem(b2,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('$b_2[n]$','Interpreter','LaTeX')
ylim([-1,2])
grid on;

x1 = PulseShaping(b1, pulse0, pulse1);
x2 = PulseShaping(b2, pulse0, pulse1);
tt = 1/fs * (1:1:length(x1));
figure;
plot(tt,x1,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
title('$x_1(t)$','Interpreter','LaTeX')
ylim([-2,2])
grid on;
figure;
plot(tt,x2,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
title('$x_2(t)$','Interpreter','LaTeX')
ylim([-2,2])
grid on;

xc = AnalogMod(x1, x2, fs, fc);
figure;
plot(tt,xc,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
ylabel('$x_c(t)$','Interpreter','LaTeX')
title('Modulated Signal','Interpreter','LaTeX')
ylim([-2,2])
xlim([0, 0.001])
grid on;

y = Channel(xc, fs, fc_channel, BW);
figure;
plot(tt,y,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
ylabel('$y(t)$','Interpreter','LaTeX')
title('Modulated Signal after Channel','Interpreter','LaTeX')
ylim([-2,2])
xlim([0, 0.002])
grid on;

[y1, y2] = AnalogDemod(y, fs, BW, fc);
figure;
plot(tt,y1,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
ylabel('$y_1(t)$','Interpreter','LaTeX')
title('Demodulated First Part of Signal','Interpreter','LaTeX')
ylim([-2,2])
grid on;
figure;
plot(tt,y2,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
ylabel('$y_2(t)$','Interpreter','LaTeX')
title('Demodulated Second Part of Signal','Interpreter','LaTeX')
ylim([-2,2])
grid on;

[pulse0_corr_b1, pulse1_corr_b1, b1_hat] = MatchedFilter(y1, pulse0, pulse1, 0);
[pulse0_corr_b2, pulse1_corr_b2, b2_hat] = MatchedFilter(y2, pulse0, pulse1, 0);
figure;
stem(pulse0_corr_b1,'linewidth',1.5); hold on;
stem(pulse1_corr_b1,'linewidth',1.5); hold off;
xlabel('n','Interpreter','LaTeX')
title('First Part Correlation with Pulses','Interpreter','LaTeX')
legend('Correlation with 0Pulse','Correlation with 1Pulse','Interpreter','LaTeX')
grid on;
figure;
stem(pulse0_corr_b2,'linewidth',1.5); hold on;
stem(pulse1_corr_b2,'linewidth',1.5); hold off;
xlabel('n','Interpreter','LaTeX')
title('Second Part Correlation with Pulses','Interpreter','LaTeX')
legend('Correlation with 0Pulse','Correlation with 1Pulse','Interpreter','LaTeX')
grid on;

figure;
stem(b1_hat,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('$\hat{b}_1[n]$','Interpreter','LaTeX')
ylim([-1,2])
grid on;
figure;
stem(b2_hat,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('$\hat{b}_2[n]$','Interpreter','LaTeX')
ylim([-1,2])
grid on;

x_hat = Combine(b1_hat, b2_hat);
figure;
stem(x_hat,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('$\hat{b}[n]$','Interpreter','LaTeX')
ylim([-1,2])
grid on;
figure;
stem(x,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('b[n]','Interpreter','LaTeX')
ylim([-1,2])
grid on;
%%
%b
noise_var = linspace(0, 100000, 20);
p = zeros(1,length(noise_var));
for i=1:length(noise_var)
    x = randi([0 1],1,100);
    [~, ~, ~, ~, x_hat] = Digital_System(x, fs, fc, fc_channel, BW, pulse0, pulse1, 1, noise_var(i), 0);
    p(i) = sum(abs(x-x_hat))/length(x) * 100;
end

plot(noise_var, p)
title('Probability of Error','Interpreter','LaTeX')
xlabel('Variance of Noise','Interpreter','LaTeX')
grid on; grid minor;
%%
%c
clc
close all
noise_var = [10, 100, 500, 1000, 5000, 10000];
figure;
for i=1:length(noise_var)
    subplot(2,3,i)
    [b1_0, b1_1, b2_0, b2_1, x_hat] = Digital_System(x, fs, fc, fc_channel, BW, pulse0, pulse1, 1, noise_var(i), 0);
    %Normalization
    b1_0 = b1_0/max(b1_0);
    b2_0 = b2_0/max(b2_0);
    scatter(b1_0, b2_0)
    grid on; grid minor;
    xlabel('$b_1[n]$','Interpreter','LaTeX')
    ylabel('$b_2[n]$','Interpreter','LaTeX')
    xlim([-2 2])
    ylim([-2 2])
end
%%
%3.2
%a
clc
clear 
close all
fs = 10^6;  fc=10000; fc_channel=10000; BW=1000;
T = 0.01; 
t = 0:1/fs:T-1/fs;
x = randi([0 ,1],1,100);
f_sin = 500;
pulse1 = sin(2*pi*f_sin*t);
pulse0 = -1*sin(2*pi*f_sin*t);

figure;
stem(x,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
ylabel('b[n]','Interpreter','LaTeX')
title('Binary Input Random Signal','Interpreter','LaTeX')
ylim([-1,2])
grid on;

[b1,b2] = Divide(x);
figure;
subplot(1,2,1)
stem(b1,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('$b_1[n]$','Interpreter','LaTeX')
ylim([-1,2])
grid on;
subplot(1,2,2)
stem(b2,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('$b_2[n]$','Interpreter','LaTeX')
ylim([-1,2])
grid on;

x1 = PulseShaping(b1, pulse0, pulse1);
x2 = PulseShaping(b2, pulse0, pulse1);
tt = 1/fs * (1:1:length(x1));
figure;
plot(tt,x1,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
title('$x_1(t)$','Interpreter','LaTeX')
ylim([-2,2])
xlim([0,0.1])
grid on;
figure;
plot(tt,x2,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
title('$x_2(t)$','Interpreter','LaTeX')
ylim([-2,2])
xlim([0,0.1])
grid on;

xc = AnalogMod(x1, x2, fs, fc);
figure;
plot(tt,xc,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
ylabel('$x_c(t)$','Interpreter','LaTeX')
title('Modulated Signal','Interpreter','LaTeX')
ylim([-2,2])
xlim([0, 0.002])
grid on;

y = Channel(xc, fs, fc_channel, BW);
figure;
plot(tt,y,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
ylabel('$y(t)$','Interpreter','LaTeX')
title('Modulated Signal after Channel','Interpreter','LaTeX')
ylim([-2,2])
xlim([0, 0.002])
grid on;

[y1, y2] = AnalogDemod(y, fs, BW, fc);
figure;
plot(tt,y1,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
ylabel('$y_1(t)$','Interpreter','LaTeX')
title('Demodulated First Part of Signal','Interpreter','LaTeX')
ylim([-2,2])
xlim([0.3, 0.3+0.005])
grid on;
figure;
plot(tt,y2,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
ylabel('$y_2(t)$','Interpreter','LaTeX')
title('Demodulated Second Part of Signal','Interpreter','LaTeX')
ylim([-2,2])
xlim([0.3, 0.3+0.005])
grid on;

[pulse0_corr_b1, pulse1_corr_b1, b1_hat] = MatchedFilter(y1, pulse0, pulse1, 1);
[pulse0_corr_b2, pulse1_corr_b2, b2_hat] = MatchedFilter(y2, pulse0, pulse1, 1);
figure;
stem(pulse0_corr_b1,'linewidth',1.5); hold on;
stem(pulse1_corr_b1,'linewidth',1.5); hold off;
xlabel('n','Interpreter','LaTeX')
title('First Part Correlation with Pulses','Interpreter','LaTeX')
legend('Correlation with 0Pulse','Correlation with 1Pulse','Interpreter','LaTeX')
ylim([-3000 3000])
grid on;
figure;
stem(pulse0_corr_b2,'linewidth',1.5); hold on;
stem(pulse1_corr_b2,'linewidth',1.5); hold off;
xlabel('n','Interpreter','LaTeX')
title('Second Part Correlation with Pulses','Interpreter','LaTeX')
legend('Correlation with 0Pulse','Correlation with 1Pulse','Interpreter','LaTeX')
ylim([-3000 3000])
grid on;

figure;
stem(b1_hat,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('$\hat{b}_1[n]$','Interpreter','LaTeX')
ylim([-1,2])
grid on;
figure;
stem(b2_hat,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('$\hat{b}_2[n]$','Interpreter','LaTeX')
ylim([-1,2])
grid on;

x_hat = Combine(b1_hat, b2_hat);
figure;
stem(x_hat,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('$\hat{b}[n]$','Interpreter','LaTeX')
ylim([-1,2])
grid on;
figure;
stem(x,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('b[n]','Interpreter','LaTeX')
ylim([-1,2])
grid on;
%%
%b
noise_var = linspace(0, 100000, 20);
p = zeros(1,length(noise_var));
for i=1:length(noise_var)
    x = randi([0 1],1,100);
    [~, ~, ~, ~, x_hat] = Digital_System(x, fs, fc, fc_channel, BW, pulse0, pulse1, 1, noise_var(i), 1);
    p(i) = sum(abs(x-x_hat))/length(x) * 100;
end

plot(noise_var, p)
title('Probability of Error','Interpreter','LaTeX')
xlabel('Variance of Noise','Interpreter','LaTeX')
grid on; grid minor;
%%
%c
clc
close all
noise_var = [10, 100, 500, 1000, 5000, 10000];
figure;
for i=1:length(noise_var)
    subplot(2,3,i)
    [b1_0, b1_1, b2_0, b2_1, x_hat] = Digital_System(x, fs, fc, fc_channel, BW, pulse0, pulse1, 1, noise_var(i), 1);
    %Normalization
    b1_0 = b1_0/max(b1_0);
    b2_0 = b2_0/max(b2_0);
    scatter(b1_0, b2_0)
    grid on; grid minor;
    xlabel('$b_1[n]$','Interpreter','LaTeX')
    ylabel('$b_2[n]$','Interpreter','LaTeX')
    xlim([-2 2])
    ylim([-2 2])
end
%%
%3.3 FSK
%b
clc
clear 
close all


fs = 10^6;  fc=10000; fc_channel=10000; BW=1000;
T = 0.01; 
t = 0:1/fs:T-1/fs;
x = randi([0 ,1],1,100);
pulse1 = sin(2*pi*1000*t);
pulse0 = -1*sin(2*pi*1500*t);

figure;
stem(x,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
ylabel('b[n]','Interpreter','LaTeX')
title('Binary Input Random Signal','Interpreter','LaTeX')
ylim([-1,2])
grid on;

[b1,b2] = Divide(x);
figure;
subplot(1,2,1)
stem(b1,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('$b_1[n]$','Interpreter','LaTeX')
ylim([-1,2])
grid on;
subplot(1,2,2)
stem(b2,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('$b_2[n]$','Interpreter','LaTeX')
ylim([-1,2])
grid on;

x1 = PulseShaping(b1, pulse0, pulse1);
x2 = PulseShaping(b2, pulse0, pulse1);
tt = 1/fs * (1:1:length(x1));
figure;
plot(tt,x1,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
title('$x_1(t)$','Interpreter','LaTeX')
ylim([-2,2])
xlim([0,0.06])
grid on;
figure;
plot(tt,x2,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
title('$x_2(t)$','Interpreter','LaTeX')
ylim([-2,2])
xlim([0,0.06])
grid on;

xc = AnalogMod(x1, x2, fs, fc);
figure;
plot(tt,xc,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
ylabel('$x_c(t)$','Interpreter','LaTeX')
title('Modulated Signal','Interpreter','LaTeX')
ylim([-2,2])
xlim([0, 0.005])
grid on;

y = Channel(xc, fs, fc_channel, BW);
figure;
plot(tt,y,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
ylabel('$y(t)$','Interpreter','LaTeX')
title('Modulated Signal after Channel','Interpreter','LaTeX')
ylim([-2,2])
xlim([0, 0.005])
grid on;

[y1, y2] = AnalogDemod(y, fs, BW, fc);
figure;
plot(tt,y1,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
ylabel('$y_1(t)$','Interpreter','LaTeX')
title('Demodulated First Part of Signal','Interpreter','LaTeX')
ylim([-2,2])
xlim([0, 0.005])
grid on;
figure;
plot(tt,y2,'linewidth',1.5)
xlabel('t(s)','Interpreter','LaTeX')
ylabel('$y_2(t)$','Interpreter','LaTeX')
title('Demodulated Second Part of Signal','Interpreter','LaTeX')
ylim([-2,2])
xlim([0, 0.005])
grid on;

[pulse0_corr_b1, pulse1_corr_b1, b1_hat] = MatchedFilter(y1, pulse0, pulse1, 2);
[pulse0_corr_b2, pulse1_corr_b2, b2_hat] = MatchedFilter(y2, pulse0, pulse1, 2);
figure;
stem(pulse0_corr_b1,'linewidth',1.5); hold on;
stem(pulse1_corr_b1,'linewidth',1.5); hold off;
xlabel('n','Interpreter','LaTeX')
title('First Part Correlation with Pulses','Interpreter','LaTeX')
legend('Correlation with 0Pulse','Correlation with 1Pulse','Interpreter','LaTeX')
ylim([-3000 3000])
grid on;
figure;
stem(pulse0_corr_b2,'linewidth',1.5); hold on;
stem(pulse1_corr_b2,'linewidth',1.5); hold off;
xlabel('n','Interpreter','LaTeX')
title('Second Part Correlation with Pulses','Interpreter','LaTeX')
legend('Correlation with 0Pulse','Correlation with 1Pulse','Interpreter','LaTeX')
ylim([-3000 3000])
grid on;

figure;
stem(b1_hat,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('$\hat{b}_1[n]$','Interpreter','LaTeX')
ylim([-1,2])
grid on;
figure;
stem(b2_hat,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('$\hat{b}_2[n]$','Interpreter','LaTeX')
ylim([-1,2])
grid on;

x_hat = Combine(b1_hat, b2_hat);
figure;
stem(x_hat,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('$\hat{b}[n]$','Interpreter','LaTeX')
ylim([-1,2])
grid on;
figure;
stem(x,'linewidth',2)
xlabel('n','Interpreter','LaTeX')
title('b[n]','Interpreter','LaTeX')
ylim([-1,2])
grid on;
%%
%c
noise_var = linspace(0, 100000, 20);
p = zeros(1,length(noise_var));
for i=1:length(noise_var)
    x = randi([0 1],1,100);
    [~, ~, ~, ~, x_hat] = Digital_System(x, fs, fc, fc_channel, BW, pulse0, pulse1, 1, noise_var(i), 2);
    p(i) = sum(abs(x-x_hat))/length(x) * 100;
end

plot(noise_var, p)
title('Probability of Error','Interpreter','LaTeX')
xlabel('Variance of Noise','Interpreter','LaTeX')
grid on; grid minor;
%%
%d
clc
close all
noise_var = [10, 100, 500, 1000, 5000, 10000];
figure;
for i=1:length(noise_var)
    subplot(2,3,i)
    [b1_0, b1_1, b2_0, b2_1, x_hat] = Digital_System(x, fs, fc, fc_channel, BW, pulse0, pulse1, 1, noise_var(i), 2);
    %Normalization
    b1_0 = b1_0/max(b1_0);
    b2_0 = b2_0/max(b2_0);
    scatter(b1_0, b2_0)
    grid on; grid minor;
    xlabel('$b_1[n]$','Interpreter','LaTeX')
    ylabel('$b_2[n]$','Interpreter','LaTeX')
    title('$var = $',noise_var(i),'Interpreter','LaTeX')
    xlim([-2 2])
    ylim([-2 2])
end
%%
%4
clc
clear 
close all

fs = 10^6;  fc=10000; fc_channel=10000; BW=1000;
T = 0.01; 
t = 0:1/fs:T-1/fs;
x = randi([0 ,255],1,100);
pulse1 = ones(1,length(t));
pulse0 = -1*ones(1,length(t));
encoded_x = SourceGenerator(x);

noise_var = linspace(0, 5000, 5);
p = zeros(1, length(noise_var));
reconstruction_error = zeros(1, length(noise_var));

for i=1:length(noise_var)
    [~, ~, ~, ~, x_hat] = Digital_System(encoded_x, fs, fc, fc_channel, BW, pulse0, pulse1, 1, noise_var(i), 0);
    decoded_x = OutputDecoder(x_hat);
    reconstruction_error(i) = sum((x-decoded_x).^2);
end

plot(noise_var, reconstruction_error)
xlabel('Noise Variance','Interpreter','LaTeX')
ylabel('Reconstruction Error','Interpreter','LaTeX')
grid on; grid minor;
%%
%3
clc
clear 
close all

fs = 10^6;  fc=10000; fc_channel=10000; BW=1000;
T = 0.01; 
t = 0:1/fs:T-1/fs;
x = randi([0 ,255],1,10);
pulse1 = ones(1,length(t));
pulse0 = -1*ones(1,length(t));
encoded_x = SourceGenerator(x);

noise_var = 1000000;
n = 25;
p = [];
reconstruction_error = zeros(1, length(noise_var));


for j=1:n
    [~, ~, ~, ~, x_hat] = Digital_System(encoded_x, fs, fc, fc_channel, BW, pulse0, pulse1, 1, noise_var, 0);
    decoded_x = OutputDecoder(x_hat);
    reconstruction_error(j) = sum((x-decoded_x).^2);
    p = [p, reconstruction_error(j)];
end
histogram(p,100,'Normalization','probability')
title('Noise Variance =',noise_var,'Interpreter','LaTeX')
grid on;
%%
%5
%1
clear; clc;
x = 0:0.01:1;
mu = [1 , 5 ,30,80,150,255 ];
numFunctions = 6;
functionNames = cell(1, numFunctions);

hold on;
for i = 1:numFunctions
    y = sign(x) .* (log(1 + mu(i).*abs(x)) / log(1 + mu(i)));
    
    plot(x, y, 'Color', rand(1,3)); 
    functionNames{i} = sprintf('%d', mu(i)); 
end
hold off;
xlabel('x');
ylabel('g(x)');
title('$\mu$-law compander','Interpreter','LaTeX');
grid on
legend(functionNames); 
%%
%2
clear; clc;
[soundtrack, originalFs] = audioread('hekayat.mp3');
desiredFs = 44100;  
if originalFs ~= desiredFs
    resampledSoundtrack = resample(soundtrack, desiredFs, originalFs);
else
    resampledSoundtrack = soundtrack;
end
time = (0:length(soundtrack)-1) / originalFs;
timeResampled = (0:length(resampledSoundtrack)-1) / desiredFs;
% Play original audio
sound(soundtrack, originalFs);  
pause(length(soundtrack)/originalFs + 1);
% Play resampled audio
sound(resampledSoundtrack, desiredFs);  
%%
%3
my_sound = resampledSoundtrack/max(resampledSoundtrack);
signal_power = mean(abs(my_sound).^2);
power_dB = 10*log10(signal_power)
%%
%6
mu = 255;
y = ulaw_compressor(my_sound , mu);
x = ulaw_expander(y , mu);
figure
plot(timeResampled, my_sound);
xlabel('Time (s)')
title('The Original Signal')
figure
plot(timeResampled, x);
xlabel('Time (s)')
title('Reconstructed Signal')
squered_mean = mean((my_sound - x).^2);
rms_error = sqrt(squered_mean)
%%
%8
%L = 4
clc;
L = 4; 
quantized_output = quantizer(my_sound, L);
figure
plot(timeResampled, quantized_output);
xlabel('Time (s)')
ylabel('Quantized Output')
title('L = 4')
noise_power = mean(abs(my_sound - quantized_output).^2);
snr = (signal_power/noise_power)
snr_db = 10*log10(snr)
%%
%L = 5
clc;
L = 5; 
quantized_output = quantizer(my_sound, L);
figure
plot(timeResampled, quantized_output);
xlabel('Time (s)')
ylabel('Quantized Output')
title('L = 5')
noise_power = mean(abs(my_sound - quantized_output).^2);
snr = (signal_power/noise_power)
snr_db = 10*log10(snr)
%%
% L = 6
clc;
L = 6; 
quantized_output = quantizer(my_sound, L);
figure
plot(timeResampled, quantized_output);
xlabel('Time (s)')
ylabel('Quantized Output')
title('L = 6')
noise_power = mean(abs(my_sound - quantized_output).^2);
snr = (signal_power/noise_power)
snr_db = 10*log10(snr)
%%
% L = 7
clc;
L = 7; 
quantized_output = quantizer(my_sound, L);
figure
plot(timeResampled, quantized_output);
xlabel('Time (s)')
ylabel('Quantized Output')
title('L = 7')

noise_power = mean(abs(my_sound - quantized_output).^2);


snr = (signal_power/noise_power)
snr_db = 10*log10(snr)
%%
% L = 8
clc;
L = 8; 
quantized_output = quantizer(my_sound, L);
figure
plot(timeResampled, quantized_output);
xlabel('Time (s)')
ylabel('Quantized Output')
title('L = 8')
noise_power = mean(abs(quantized_output - my_sound).^2);


snr = (signal_power/noise_power)
snr_db = 10*log10(snr)
%%
%9
%L= 4
clc;
L = 4;
mu = [1 , 5 ,30,80,150,255 ];
snrs = [];
snrs_db = [];
numFunctions = 6;
for i = 1:numFunctions
y = ulaw_compressor(my_sound , mu(i));
quantized_output = quantizer(y, L);
x_hat = ulaw_expander(quantized_output , mu(i));
noise_power = mean(abs(x_hat - my_sound).^2);
snr = (signal_power/noise_power);
snrs = [snrs , snr];
snrs_db = [snrs_db , 10*log10(snr)];
end
snrs
snrs_db
%%
%L= 5
clc;
L = 5;
mu = [1 , 5 ,30,80,150,255 ];
snrs = [];
snrs_db = []
numFunctions = 6;
for i = 1:numFunctions
y = ulaw_compressor(my_sound , mu(i));
quantized_output = quantizer(y, L);
x_hat = ulaw_expander(quantized_output , mu(i));
noise_power = mean(abs(x_hat - my_sound).^2);
snr = (signal_power/noise_power);
snrs = [snrs , snr];
snrs_db = [snrs_db , 10*log10(snr)];
end
snrs
snrs_db
%% 
%L= 6
clc;
L = 6;
mu = [1 , 5 ,30,80,150,255 ];
snrs6 = [];
snrs_db6 = [];
numFunctions = 6;
for i = 1:numFunctions
y = ulaw_compressor(my_sound , mu(i));
quantized_output = quantizer(y, L);
x_hat = ulaw_expander(quantized_output , mu(i));
noise_power = mean(abs(x_hat - my_sound).^2);
snr = (signal_power/noise_power);
snrs6 = [snrs6 , snr];
snrs_db6 = [snrs_db6 , 10*log10(snr)];
end
snrs6
snrs_db6
%%
%L= 7
clc;
L = 7;
mu = [1 , 5 ,30,80,150,255 ];
snrs = [];
snrs_db = [];
numFunctions = 6;
for i = 1:numFunctions
y = ulaw_compressor(my_sound , mu(i));
quantized_output = quantizer(y, L);
x_hat = ulaw_expander(quantized_output , mu(i));
noise_power = mean(abs(x_hat - my_sound).^2);
snr = (signal_power/noise_power);
snrs = [snrs , snr];
snrs_db = [snrs_db , 10*log10(snr)];
end
snrs
snrs_db
%%
%L= 8
clc;
L = 8;
mu = [1 , 5 ,30,80,150,255 ];
snrs = [];
snrs_db = [];
numFunctions = 6;
for i = 1:numFunctions
y = ulaw_compressor(my_sound , mu(i));
quantized_output = quantizer(y, L);
x_hat = ulaw_expander(quantized_output , mu(i));
noise_power = mean(abs(x_hat - my_sound).^2);
snr = (signal_power/noise_power);
snrs = [snrs , snr];
snrs_db = [snrs_db , 10*log10(snr)];
end
snrs
snrs_db
%%
%10
clc;
%L= 6
clc;
L = 6;
mu = 1:5:255;
snrs6 = [];
snrs_db6 = [];
numFunctions = length(mu);
for i = 1:numFunctions
y = ulaw_compressor(my_sound , mu(i));
quantized_output = quantizer(y, L);
x_hat = ulaw_expander(quantized_output , mu(i));
noise_power = mean(abs(x_hat - my_sound).^2);
snr = (signal_power/noise_power);
snrs6 = [snrs6 , snr];
snrs_db6 = [snrs_db6 , 10*log10(snr)];
end
figure
plot(mu, snrs6);
xlabel('$\mu$','Interpreter','LaTeX')
ylabel('SNR','Interpreter','LaTeX')
grid on;grid minor
title('SNR based on different $\mu$','Interpreter','LaTeX')
%%
%11
%L= 4
clc;
L = 4;
mu = [1 , 5 ,30,80,150,255 ];
snrs = [];
snrs_db = []
numFunctions = 6;
for i = 1:numFunctions
y = ulaw_expander(my_sound , mu(i));
quantized_output = quantizer(y, L);
x_hat = ulaw_compressor(quantized_output , mu(i));
noise_power = mean(abs(x_hat - my_sound).^2);
snr = (signal_power/noise_power);
snrs = [snrs , snr];
snrs_db = [snrs_db , 10*log10(snr)];
end
snrs
snrs_db
%%
%L= 5
clc;
L = 5;
mu = [1 , 5 ,30,80,150,255 ];
snrs = [];
snrs_db = []
numFunctions = 6;
for i = 1:numFunctions
y = ulaw_expander(my_sound , mu(i));
quantized_output = quantizer(y, L);
x_hat = ulaw_compressor(quantized_output , mu(i));
noise_power = mean(abs(x_hat - my_sound).^2);
snr = (signal_power/noise_power);
snrs = [snrs , snr];
snrs_db = [snrs_db , 10*log10(snr)];
end
snrs
snrs_db
%% 
%L= 6
clc;
L = 6;
mu = [1 , 5 ,30,80,150,255 ];
snrs = [];
snrs_db = [];
numFunctions = 6;
for i = 1:numFunctions
y = ulaw_expander(my_sound , mu(i));
quantized_output = quantizer(y, L);
x_hat = ulaw_compressor(quantized_output , mu(i));
noise_power = mean(abs(x_hat - my_sound).^2);
snr = (signal_power/noise_power);
snrs = [snrs , snr];
snrs_db = [snrs_db , 10*log10(snr)];
end
snrs
snrs_db
%%
%L= 7
clc;
L = 7;
mu = [1 , 5 ,30,80,150,255 ];
snrs = [];
snrs_db = [];
numFunctions = 6;
for i = 1:numFunctions
y = ulaw_compressor(my_sound , mu(i));
y = ulaw_expander(my_sound , mu(i));
quantized_output = quantizer(y, L);
x_hat = ulaw_compressor(quantized_output , mu(i));
snr = (signal_power/noise_power);
snrs = [snrs , snr];
snrs_db = [snrs_db , 10*log10(snr)];
end
snrs
snrs_db
%%
%L= 8
clc;
L = 8;
mu = [1 , 5 ,30,80,150,255 ];
snrs = [];
snrs_db = [];
numFunctions = 6;
for i = 1:numFunctions
y = ulaw_expander(my_sound , mu(i));
quantized_output = quantizer(y, L);
x_hat = ulaw_compressor(quantized_output , mu(i));
noise_power = mean(abs(x_hat - my_sound).^2);
snr = (signal_power/noise_power);
snrs = [snrs , snr];
snrs_db = [snrs_db , 10*log10(snr)];
end
snrs
snrs_db

%%
% functions
function [b1, b2] = Divide(x)
L = length(x);
b1 = zeros(1,L/2);
b2 = zeros(1,L/2);

    for i = 1:L
        if mod(i,2) == 0 
            b2(i/2) = x(i);
        
        else 
            b1((i+1)/2) = x(i);
        end
        
    end
        
end

function combined = Combine(x1, x2)
combined=[];
for i=1:1:length(x1)
    combined = [combined,x1(i),x2(i)];
end

end


function out = PulseShaping(x , pulse0 , pulse1)
    out = [];
    for i = 1:length(x)
        if x(i) == 0  
            out = [out, pulse0];
        else 
            out = [out ,pulse1];
            
        end
    end  
    
end


function xc = AnalogMod(x1, x2, fs, fc)
t = 1/fs:1/fs:(length(x1)*1/fs);
xc = x1.*cos(2*pi*fc*t) + x2.*sin(2*pi*fc*t);
end


function out = Channel(xc, fs, fc, BW)
    f_min = fc - BW/2;
    f_max = fc + BW/2;
    out = bandpass(xc,[f_min, f_max],fs);
end



function [y1, y2] = AnalogDemod(y, fs, BW, fc)
t=1/fs:1/fs:(length(y)*1/fs);

y1_hat = y .* cos(2*pi*fc*t);
y2_hat = y .* sin(2*pi*fc*t);

y1 = lowpass(y1_hat, BW, fs);
y2 = lowpass(y2_hat, BW, fs);

end



function [pulse0_corr_signal, pulse1_corr_signal, out] = MatchedFilter(x, pulse0, pulse1, Mod)
Tb = length(pulse0);
L = length(x)/Tb;
out = zeros(1,L);

pulse1_corr = conv(x, pulse1);
pulse0_corr = conv(x, pulse0);
pulse1_corr_signal = zeros(1,L);
pulse0_corr_signal = zeros(1,L);
for n=1:L
    pulse1_corr_signal(n) = pulse1_corr(n*Tb);
    pulse0_corr_signal(n) = pulse0_corr(n*Tb);
    
    if Mod == 0
        if pulse1_corr(n*Tb) >= pulse0_corr(n*Tb)
            out(n) = 1;
        else
            out(n) = 0;
        end
    elseif (Mod == 1) || (Mod == 2)
        if pulse1_corr(n*Tb) >= pulse0_corr(n*Tb)
            out(n) = 0;
        else
            out(n) = 1;
        end
        
        if Mod == 2
            m = max(abs(pulse0_corr(n*Tb)),abs(pulse1_corr(n*Tb)));
            if abs(pulse0_corr(n*Tb)) > abs(pulse1_corr(n*Tb))
                pulse1_corr_signal(n) = m;
            else
                pulse0_corr_signal(n) = m;
            end
        end
    end
    
end
end


function [pulse0_corr_b1, pulse1_corr_b1, pulse0_corr_b2, pulse1_corr_b2, b_hat] = ...
    Digital_System(x, fs, fc, fc_channel, BW, pulse0, pulse1, ifNoise, noise_var, Mod)

[b1,b2] = Divide(x);
x1 = PulseShaping(b1, pulse0, pulse1);
x2 = PulseShaping(b2, pulse0, pulse1);
xc = AnalogMod(x1, x2, fs, fc);

y = Channel(xc, fs, fc_channel, BW);
if ifNoise == 1
    noise = sqrt(noise_var)*randn(size(y));
    y = y + noise;
end
[y1, y2] = AnalogDemod(y, fs, BW, fc);
[pulse0_corr_b1, pulse1_corr_b1, b1_hat] = MatchedFilter(y1, pulse0, pulse1, Mod);
[pulse0_corr_b2, pulse1_corr_b2, b2_hat] = MatchedFilter(y2, pulse0, pulse1, Mod);

b_hat = Combine(b1_hat, b2_hat);
end

function output = SourceGenerator(x)
output = [];
for i = 1:length(x)
    output = [output, de2bi(x(i),8)];
end
end


function decoded = OutputDecoder(x)
decoded = [];
for i = 1:8:length(x)
    binary_digit = x(i:1:i+7);
    decoded = [decoded, bi2de(binary_digit)];
end
end

function output = ulaw_compressor(x , mu)
output = sign(x) .* (log(1 + mu.*abs(x)) / log(1 + mu));

end

function x =   ulaw_expander(y , mu)
x =  sign(y) .* (1/mu) .* ((1 + mu) .^ abs(y) - 1);
end


function quantized_signal = quantizer(signal, L)
    max_val = max(signal);
    min_val = min(signal);
    delta = (max_val - min_val) / L;
    quantized_signal = round(signal / delta) * delta;
end