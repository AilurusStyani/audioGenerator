function stepSourceGenerator(audioFreqMin,audioFreqMax,duration,steps)
if ~exist('audioFreqMin','var') || isempty(audioFreqMin)
    audioFreqMin = 1000; % Hz
end
if ~exist('audioFreqMax','var') || isempty(audioFreqMax)
    audioFreqMax = 3000;% Hz
end
if ~exist('duration','var') || isempty(duration)
    duration = 2; % second
end
if ~exist('steps','var') || isempty(steps)
    steps = 10;
end

sampleRate = 96000; % how many sample per second, Hz
% audioFrequency=linspace(audioFreqMin,audioFreqMax,sampleRate*duration);
audioFrequency = sort(repmat(linspace(audioFreqMin,audioFreqMax,steps),1,round(duration*sampleRate/steps)));
temp = (1:sampleRate)'./sampleRate;
temp = repmat(temp,ceil(duration),1);
t = temp(1:length(audioFrequency));
y = sin(audioFrequency' * 2 * pi .* t);

player = audioplayer([y, -y], sampleRate);
player.play();
% audiowrite('stepTone.wav', [y -y], sampleRate);
end