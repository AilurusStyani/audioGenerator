stimulusDuration = 500/1000; % s

lowFreq = 5400; % Hz
highFreq = 11800; % Hz

attack = 5/1000; % s
release = 5/1000; % s

sampleRate = 96000;

toneT = (1:round(stimulusDuration*sampleRate))/sampleRate;

YHigh = sin(highFreq*2*pi.*toneT)';
YLow = sin(lowFreq*2*pi.*toneT)';
Yinterval = zeros(intervalDuration*sampleRate,1);

attackAmp = linspace(0,1,sampleRate*attack);
releaseAmp = linspace(1,0,sampleRate*release);

YHigh(1:length(attackAmp)) = YHigh(1:length(attackAmp)) .* attackAmp';
YHigh(end-length(releaseAmp)+1:end) = YHigh(end-length(releaseAmp)+1:end) .* releaseAmp';

YLow(1:length(attackAmp)) = YLow(1:length(attackAmp)) .* attackAmp';
YLow(end-length(releaseAmp)+1:end) = YLow(end-length(releaseAmp)+1:end) .* releaseAmp';

audiowrite('H.wav', YHigh, sampleRate);
audiowrite('L.wav', YLow, sampleRate);