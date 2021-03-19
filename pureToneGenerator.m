function pureToneGenerator(audioFrequency)
if isempty(audioFrequency)
    audioFrequency = 1000; % Hz
end

sampleRate = 10^6; % how many sample per second, Hz

t = (0:sampleRate)'./sampleRate;
y = sin(audioFrequency * 2 * pi * t);

player = audioplayer([y, -y], sampleRate);
player.play();
audiowrite('pureTone.wav', [y -y], sampleRate);
end
