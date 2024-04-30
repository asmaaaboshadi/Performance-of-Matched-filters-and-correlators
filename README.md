# Performance-of-Matched-filters-and-correlators
Objective
(1) Investigate the matched filter and correlator receivers
(2) Modify the system of simple detector to use a matched filter receiver instead of simple
sampler.
(3) Compare the performance of simple detector and matched filter receiver.


Theoretical Background

(1) Matched filter receivers and correlators:
Matched filter is baseband filter which is designed as function of transmitted waveforms to
maximize the received SNR at the designed sampling instant and hence minimizes the
resultant probability of error and considered the optimal receiver in case of AWGN channel.
The matched filter is designed in case of AWGN channel 


And the output of the matched filter is the convolution between hmf(t) and received signal to
have a MF output that will be further sampled to be the input of the simple detector.
To ease the design of implementing of the MF, the correlator is proposed. The correlator
consists of multiplier and integrator

The received signal is multiplied by this g(t) and then accumulated to have a value that will be
compared with the threshold.
The correlator receiver output equals the MF output at the sampling instant. The threshold at
this case can be calculated as


(2) Modeling Matched filter receiver
To model the Matched filter receiver using MATLAB, you should use the sampled MF version,
That will result in sampling hmf(t) by specified number of samples (example:10 samples), the
transmitted signal itself should be represented by same number of samples, then you can
perform convolution at the receiver and choose the sample at any time (but not the middle)
which represents the sampling process.

Procedure
(1) Simulation parameters

a. Number of bits/SNR=1e5 bits

b. Signal to noise ratio range=0 to 30 dB with 2 dB steps.

c. Number of samples that represents waveform m = 20

d. Sampling instant =20

e. Receiver type: Matched filter and correlator.

f. s1(t) is rectangular signal with Amp=1 and s2(t) is zero signal.



(2) Generate random binary data vector (you can make use of randint or randi).

(3) Represent each bit with proper waveform (hint: use concatenation, notice that the
resultant vector will be 10e6 samples)

(4) Apply noise to samples (Hint: For fair comparison between MF and simple detector you
should equate the average power in the two cases, and hence you should notice that the
power of signal in case of MF is calculated by adding the squares of all samples that
represents s1(t) and hence SNR will change).

Rx_sequence=bits+noise

Or

Rx_sequence=awgn(bits,snr,’measured’)

(5) Apply convolution process in the receiver (Hint: the convolution process will be performed
in bit-by-bit basis i.e. 20 samples by 20 samples) You may use conv
In case of correlator, you will apply element by element multiplication and then add the
resultant samples together.


(6) Sample the output of the Matched filter (i.e. choose the middle sample, you may use
indexing tools)


(7) Decide whether the Rx_sequence is ‘1’ or ‘0’ by comparing the samples with threshold
(Hint: try to use relational operators and indexing to make the code more efficient)


(8) Compare the original bits with the detected bits and calculate number of errors (you can
make use of xor or biterr).


(9) Save the probability of error of each SNR in matrix, BER


(10) Plot the BER curve against SNR (use semilogy)
