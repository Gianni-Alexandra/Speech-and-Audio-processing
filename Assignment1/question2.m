%%% Based on script2 %%%
close all;

%% 1.Record audio
% Define recording parameters
Fs = 44100;        % Sampling frequency (44.1 kHz)
nBits = 16;        % Bits per sample
nChannels = 1;     % Number of channels (mono)
recDuration = 2;   % Duration of recording in seconds

%Record a short segment of speech corresponding to the word “asa” 
% Use "audiorecorder" Matlab function
rec = audiorecorder(Fs,nBits,nChannels);

% Notify user and start recording the word “asa”
disp('Recording will start in 2 seconds. Get ready to say "asa".');
pause(2); % Delay for user preparation
disp('Recording...');
recordblocking(rec, recDuration); 
disp('Recording complete. Thank you');

% Play recorded sound
play(rec);

% get audio data
audioData = getaudiodata(rec);

% Save the recording to a .wav file
filename = 'asa_audio.wav';
audiowrite(filename, audioData, Fs);
disp(['Audio saved as ', filename]);

% Plot the signal
figure;
plot((1:length(audioData)) / Fs, audioData);
title('Speech Signal plot');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Save the original signal plot
saveas(gcf, 'asa_Signal.png');


%% 2.Plot signal segments: Divide signal into 200ms segments and plot
%Define N, segment duration in ms
N = 200;

%Find number of samples
% I convert ms to seconds 
% Multiply by Fs to determine how many samples correspond to the segment duration in seconds.
% Use round so i can have an integer result
samples_perSegment = round(Fs * (N / 1000))

% Divide and 
numSegments = ceil(length(audioData) / samples_perSegment); % Total number of segments

%plot segments
figure;
hold on;

for i = 1:numSegments
    % Extract the current segment
    segment_start = (i - 1) * samples_perSegment + 1;
    segment_end = i * samples_perSegment;
    %segment_end = min(i * samplesPerSegment, length(speechSignal));
    segment = audioData(segment_start:segment_end);
    
    % Time axis for the segment
   % segment_time = (startIdx:endIdx) / fs;
    segment_time = (0:samples_perSegment-1) / Fs + (i-1) * N / 1000;

    % Plot the segments
    plot(segment_time, segment);
end

title(['Audio Signal Segments (', num2str(N), ' ms per line)']);
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
hold off;

% Save the signal plot with 200 ms segments
saveas(gcf, 'Signal_Segments_200ms.png');

%% 3. Voiced and unvoiced segments: Identify and label /a/ and /s/
% Create a time axis for the full audio
timeFull = (0:length(audioData)-1) / Fs;

% Define voiced and unvoiced criteria
thresholdRMS = 0.05; % Threshold for voiced segment (adjust as needed)
figure;
plot(timeFull, audioData);
hold on;
title('Voiced and Unvoiced Segments');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

for i = 1:numSegments
    % Extract segment
    segmentStart = (i - 1) * samples_perSegment  + 1;
    segmentEnd = i * samples_perSegment;
    segment = audioData(segmentStart:segmentEnd);
    segmentTime = timeFull(segmentStart:segmentEnd);
    
    % Calculate RMS for amplitude analysis
    rmsValue = rms(segment);
    
    % Label based on amplitude and periodicity
    if rmsValue > thresholdRMS
        label = '/a/ (Voiced)';
        color = 'g'; % Green for voiced
    else
        label = '/s/ (Unvoiced)';
        color = 'r'; % Red for unvoiced
    end
    
    % Plot and annotate
    plot(segmentTime, segment, color, 'LineWidth', 1.5);
    text(mean(segmentTime), max(segment), label, 'Color', color, 'FontSize', 10);
end
hold off;

%% Slow down the sound: Slow down the recorded audio using resampling.
% Slow down the sound
slowFactor = 2; % x2 slower

% Resample the audio to slow it down
slow_speech_signal = resample(audioData, slowFactor, 1); 

% Plot the slowed-down signal
figure;
plot((1:length(slow_speech_signal)) / Fs, slow_speech_signal);
title('Slowed-Down Speech Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Save the slowed-down signal plot
saveas(gcf, 'Slowed_Down_Signal.png');

% Play the original and slowed-down audio
%disp('Playing original signal...');
%%sound(audioData, Fs);
%pause(2); % Wait for the original sound to finish
disp('Playing slowed-down signal...');
sound(slow_speech_signal, Fs);

