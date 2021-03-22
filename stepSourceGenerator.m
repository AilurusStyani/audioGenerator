function stepSourceGenerator(audioFreqMin,audioFreqMax,duration,steps)
if nargin<1 || isempty(audioFreqMin)
    audioFreqMin = 1000; % Hz
end
if nargin<2 || isempty(audioFreqMax)
    audioFreqMax = 3000;% Hz
end
if nargin<3 || isempty(duration)
    duration = 2; % second
end
if nargin<4 || isempty(steps)
    steps = 10;
end

sampleRate = 96000; % how many sample per second, Hz
% audioFrequency=linspace(audioFreqMin,audioFreqMax,sampleRate*duration);
frequencies =  linspace(audioFreqMin,audioFreqMax,steps);
for i = 1:steps
    if i == 1
        t = (0:(duration/steps*sampleRate))/(duration/steps*sampleRate);
        tempY = sin(frequencies(i)*2*pi.*t);
        pointN = sampleRate/frequencies(i);
        [~,index0] = max(tempY(end-pointN:end));
        y = tempY(1:(end-pointN+index0));
    else
        t = (1:(duration/steps*sampleRate))/(duration/steps*sampleRate);
        tempY = sin(frequencies(i)*2*pi.*t+pi/2);
        pointN = sampleRate/frequencies(i);
        [~,index0] = max(tempY(end-pointN:end));
        y=cat(2,y,tempY(1:(end-pointN+index0)));
    end
end
% audioFrequency = sort(repmat(linspace(audioFreqMin,audioFreqMax,steps),1,round(duration*sampleRate/steps)));
% temp = (1:sampleRate)'./sampleRate;
% temp = repmat(temp,ceil(duration),1);
% t = temp(1:length(audioFrequency));
% y = sin(audioFrequency' * 2 * pi .* t);

% plot(y)
player = audioplayer([y, -y], sampleRate);
player.play();
% audiowrite('stepTone.wav', [y -y], sampleRate);
end