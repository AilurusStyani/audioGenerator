function evidenceAccumulationAuditoryToneSequence()
testMode = 0;

stimulusDuration = 125/1000; % s
intervalDuration = 125/1000; % s

toneNum = 5;

lowFreq = 5400; % Hz
highFreq = 11800; % Hz

attack = 5/1000; % s
release = 5/1000; % s

sampleRate = 96000;

sustainDuration = stimulusDuration - attack - release;

if sustainDuration<0
    error('Invalid attack / release / stimulus duration.')
end
totalDuration = (stimulusDuration+intervalDuration) * toneNum;

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


%% condition 1, 1 high + 4 low
for highi = 1:toneNum
    Y = [];
    for tonei = 1:toneNum
        if tonei == highi 
            Y = cat(1,Y,YHigh,Yinterval);
        else
            Y = cat(1,Y,YLow,Yinterval);
        end
    end
    if testMode
        player = audioplayer(Y, sampleRate);
%         plot(Y)
        player.play();
        pause(totalDuration+0.5);
    else
        fileName = 'LLLLL.wav';
        fileName(highi) = 'H';
        
        audiowrite(fileName, Y, sampleRate);
    end
end

%% condition 2, 2 high + 3 low
for highi1 = 1:toneNum-1
    for highi2 = highi1+1:toneNum
        Y = [];
        highi = [highi1, highi2];
        for tonei = 1:toneNum
            if ismember(tonei,highi)
                Y = cat(1,Y,YHigh,Yinterval);
            else
                Y = cat(1,Y,YLow,Yinterval);
            end
        end
        if testMode
            player = audioplayer(Y, sampleRate);
%             plot(Y)
            player.play();
            pause(totalDuration+0.5);
        else
            fileName = 'LLLLL.wav';
            fileName(highi) = 'H';
            
            audiowrite(fileName, Y, sampleRate);
        end
    end
end

%% condition 3, 3 high + 2 low
for lowi1 = 1:toneNum-1
    for lowi2 = lowi1+1:toneNum
        Y = [];
        lowi = [lowi1, lowi2];
        for tonei = 1:toneNum
            if ismember(tonei,lowi)
                Y = cat(1,Y,YLow,Yinterval);
            else
                Y = cat(1,Y,YHigh,Yinterval);
            end
        end
        if testMode
            player = audioplayer(Y, sampleRate);
%             plot(Y)
            player.play();
            pause(totalDuration+0.5);
        else
            fileName = 'HHHHH.wav';
            fileName(lowi) = 'L';
            
            audiowrite(fileName, Y, sampleRate);
        end
    end
end

%% condition 4, 4 high + 1 low
for lowi = 1:toneNum
    Y = [];
    for tonei = 1:toneNum
        if tonei == lowi 
            Y = cat(1,Y,YLow,Yinterval);
        else
            Y = cat(1,Y,YHigh,Yinterval);
        end
    end
    if testMode
        player = audioplayer(Y, sampleRate);
%         plot(Y)
        player.play();
        pause(totalDuration+0.5);
    else
        fileName = 'HHHHH.wav';
        fileName(lowi) = 'L';
        
        audiowrite(fileName, Y, sampleRate);
    end
end