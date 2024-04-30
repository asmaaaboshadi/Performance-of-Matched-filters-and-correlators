clear all
clc
close all
%%define system parameters 
num_bits=1e5;
snr_range=0:2:30;
m = input ('enter the number of samples in the waveform: ');
T = 1;   %symbol period (normalized to 1)
n = m * num_bits ;  % Total number of samples 
t = linspace (0,T,m);
sampling_instant=20;
%%define waveforms
% Generate s1(t) and s2(t)
expr1 = input ('enter the expression for s1: ','s');
s1 = eval(expr1);
expr2 = input ('enter the expression for s2: ','s');
s2 = eval(expr2);
% Generate random binary data 
data = randi ([0,1], 1 , num_bits);
for i = 1:num_bits
    if data(i)==1
        x((i-1)*m+1:i*m) = s1;
    else 
        x((i-1)*m+1:i*m) = s2;
    end
end
%%plot waveform of first 20 bits 
figure (1)
plot (t, x(1:m), 'linewidth',2);
hold on ;
for i =2:20
    plot (t+(i-1)*T , x((i-1)*m+1:i*m), 'linewidth' ,2);
end
ylim ([-0.5 , 1.5]);
xlabel ('Time (s)');
ylabel('Voltage');
%%calculate transmitted signal power 
signal_power = mean (abs(x).^2);
p = (1/n) * sum (abs(x).^2);
%%generate noise signal
noise_mf = zeros (1,n);
noise_corr = zeros (1,num_bits);
ber_mf = zeros(size(snr_range));
ber_corr= zeros(size(snr_range));
ber_SD= zeros (size (snr_range));
for i = 1:length (snr_range)
    snr = snr_range(i);
    noise_power= signal_power / (10^(snr/10));
    noise_std = sqrt(noise_power /2);
    noise_mf = noise_std* randn(1,n);
    noise_corr = noise_std* randn(1,n);
    %noise_mf = awgn (x, snr , 'measured');
    x_noisy_mf= x + noise_mf;
    x_noisy_corr= x+ noise_corr;

    %implement matched filter and correlator 
    s1_conj = conj(fliplr(s1));
    s2_conj = conj(fliplr(s2));
    h =  s1_conj -  s2_conj ;
    y_mf = conv (x_noisy_mf , h ,'same');
    
    %implement correlator 
    r_corr = zeros (1, num_bits);
    for j = 1: num_bits
        block= x_noisy_corr((j-1)*m+1 : j*m);
        r_corr(j) = sum (block .*h) ;
    end
    %threshold 
    v_thresh = (mean (s1)+ mean (s2))/2;

    %sample simple detector output 
    y_sampled_simple_detector=x_noisy_mf(m/2: m: end);
    %simple detector decision 
    rx_data_SD=(y_sampled_simple_detector>v_thresh);
    %rx_data_SD=[data(1) rx_data_SD];
    %sample matched filter output 
    y_sampled_mf = y_mf (m/2:m:end);
    %matched filter decision 
    rx_data_mf = (y_sampled_mf> v_thresh);
    % rx_data_mf = [data (1) rx_data_mf];
    %correlator desicion
    rx_data_corr = (r_corr > v_thresh);
    %bit error calculation 
    ber_SD(i) = biterr (rx_data_SD , data) / num_bits;
    ber_mf(i) = biterr (rx_data_mf , data) / num_bits;
    ber_corr(i) = biterr (rx_data_corr , data) / num_bits;
end
%% plot waveform of first 20 bits 
figure (2)
plot (t , x_noisy_mf(1:m) , 'LineWidth',2);
hold on;
for i =2:20
 plot (t+(i-1)*T , x_noisy_mf((i-1)*m+1:i*m), 'linewidth' ,2);
end
ylim ([-0.5 , 1.5]);
figure (3)
plot (t , x_noisy_corr(1:m) , 'LineWidth',2);
hold on;
for i =2:20
 plot (t+(i-1)*T , x_noisy_corr((i-1)*m+1:i*m), 'linewidth' ,2);
end
ylim ([-0.5 , 1.5]);
%%plot BER vs SNR 
figure (4)
semilogy (snr_range , ber_SD , 'o-r' , 'LineWidth', 2, 'MarkerSize', 8 , 'DisplayName',  'simple Detector ');
hold on ;
semilogy (snr_range , ber_mf , 'x-k' , 'LineWidth', 2, 'MarkerSize', 8 , 'DisplayName',  'Matched filter');
xlabel ('SNR(db)');
ylabel('bit erorr rate');
title ('Bit error rate vs SNR');
legend ('show');
grid on;
figure (5)
semilogy (snr_range , ber_SD , 'o-r' , 'LineWidth', 2, 'MarkerSize', 8 , 'DisplayName',  'simple Detector ');
hold on ;
semilogy (snr_range , ber_corr , 'd-b' , 'LineWidth', 2, 'MarkerSize', 8 , 'DisplayName',  'correlator');
xlabel ('SNR(db)');
ylabel('bit erorr rate');
title ('Bit error rate vs SNR');
legend ('show');
grid on ;




