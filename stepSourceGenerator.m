function stepSourceGenerator(duration,steps,audioFreqMax,audioFreqMin,initial,terminal,testEnable)
if nargin<1 || isempty(duration)
    duration = 2; % second
end
if nargin<2 || isempty(steps)
    steps = 10;
end
if nargin <3 || isempty(audioFreqMax)
    audioFreqMax = 1000;
end
if nargin <4 || isempty(audioFreqMin)
    audioFreqMin = 500; % will be disable in pure tone ( steps == 1)
end
if nargin<5 || isempty(initial)
    initial = 0.05;% second
end
if nargin<6 || isempty(terminal)
    terminal = 0.05; % second
end
if nargin<7 || isempty(testEnable)
    testEnable = true;
end
if initial > terminal
    iniLonger = true;
else
    iniLonger = false;
end

sampleRate = 96000; % how many sample per second, 1000 to 384000 Hz, typically 8000, 11025, 22050, 44100, 48000, and 96000 Hz
% audioFrequency=linspace(audioFreqMin,audioFreqMax,sampleRate*duration);
frequencies =  linspace(audioFreqMin,audioFreqMax,steps);

% /: initial        _: mainbody      \: terminal
% ////____\\           ////____\\
%               ////____\\
% or
% //____\\\\           //____\\\\
%               //____\\\\
if iniLonger
    bodyDuration = (duration-terminal)/steps-initial;
else
    bodyDuration = (duration-initial)/steps-terminal;
end
if bodyDuration < 0
    error('terminal/initial too long');
end

y = zeros(round(sampleRate*duration),1); % matlab have some problam for big number, so I have to fun round() on it.
for i = 1:steps
    t = (1:round((bodyDuration+initial+terminal)*sampleRate))/sampleRate;
    tempY = sin(frequencies(i)*2*pi.*t)';
    initialAmp = linspace(0,1,sampleRate*initial);
    terminalAmp = linspace(1,0,sampleRate*terminal);
    tempY(1:length(initialAmp)) = tempY(1:length(initialAmp)).*initialAmp';
    tempY(end-length(terminalAmp)+1:end) = tempY(end-length(terminalAmp)+1:end).*terminalAmp';
    if i == 1
        y(1:round((bodyDuration+initial+terminal)*sampleRate)) = tempY;
    else
        if iniLonger
            y((i-1)*(bodyDuration+initial)*sampleRate+1 : (i*(bodyDuration+initial)+terminal)*sampleRate) = y((i-1)*(bodyDuration+initial)*sampleRate+1 : (i*(bodyDuration+initial)+terminal)*sampleRate) +tempY;
        else
            y((i-1)*(bodyDuration+terminal)*sampleRate+1 : (i*(bodyDuration+terminal)+initial)*sampleRate) = y((i-1)*(bodyDuration+terminal)*sampleRate+1 : (i*(bodyDuration+terminal)+initial)*sampleRate)+tempY;
        end
    end
end

player = audioplayer(y, sampleRate);
if testEnable
    plot(y)
    player.play();
    pause(duration);
end
audiowrite('stepTone.wav', y, sampleRate);
end