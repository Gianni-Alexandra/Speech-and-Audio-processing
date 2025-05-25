% This file creates and analyzes spectrograms
% Speech & Audio Processing Assignment

% Load audio files
[audio1, fs1] = audioread('sample1.wav');
[audio2, fs2] = audioread('sample2.wav');

% Parameters for spectrogram
narrowband_window = 512; % Window size for narrowband
wideband_window = 64;    % Window size for wideband
overlap_narrow = narrowband_window / 4; % 25% overlap
overlap_wide = wideband_window / 4;     % 25% overlap

% Plot for sample1.wav
figure;

% 1. Narrowband Spectrogram for sample1.wav
subplot(2,1,1); % 2 rows, 1 column, 1st subplot
spectrogram(audio1(:,1), narrowband_window, overlap_narrow, [], fs1, 'yaxis');
title('Narrowband Spectrogram of sample1.wav');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colormap jet;
colorbar;
caxis([-100 0]); % Set color range

% 2. Wideband Spectrogram for sample1.wav
subplot(2,1,2); % 2 rows, 1 column, 2nd subplot
spectrogram(audio1(:,1), wideband_window, overlap_wide, [], fs1, 'yaxis');
title('Wideband Spectrogram of sample1.wav');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colormap jet;
colorbar;
caxis([-100 0]);

saveas(gcf, 'sample1_spectrograms.png'); % Save figure as image

% Plot for sample2.wav
figure;

% 3. Narrowband Spectrogram for sample2.wav
subplot(2,1,1); % 2 rows, 1 column, 1st subplot
spectrogram(audio2(:,1), narrowband_window, overlap_narrow, [], fs2, 'yaxis');
title('Narrowband Spectrogram of sample2.wav');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colormap jet;
colorbar;
caxis([-100 0]);

% 4. Wideband Spectrogram for sample2.wav
subplot(2,1,2); % 2 rows, 1 column, 2nd subplot
spectrogram(audio2(:,1), wideband_window, overlap_wide, [], fs2, 'yaxis');
title('Wideband Spectrogram of sample2.wav');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colormap jet;
colorbar;
caxis([-100 0]);

saveas(gcf, 'sample2_spectrograms.png'); % Save figure as image
