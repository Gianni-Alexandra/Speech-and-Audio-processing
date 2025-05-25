## Spectrogram and Time-Domain Analysis of speech

### Objective
This assignment introduces basic concepts of speech signal processing using Matlab. It covers spectrogram analysis, time-domain signal inspection
and audio manipulation techniques such as resampling.

### Task Overview
***Question 1: Spectrogram Analysis***
- Load *sample1.wav* and *sample2.wav* using *audioread*.
- Generate and plot **narrowband** and **wideband** spectrograms with appropriate db scaling and colorbars.
- Identify and annotate:
  - Fundamental frequencies (F_0) for the vowels in the words "add" and "cats".
  - Format frequencies of these vowels.
  - Determine the speaker's gender based on frequency characteristics.
 
***Question 2: Time-Domain Signal Analysis***
- Record the word *"asa"* using *audiorecorder* in Matlab.
- Divide and plot the waveform in 200ms segments.
- Identify and label voiced (/a/) and unvoiced (/s/) segments.
- Slow down the audio by resampling, plot the result, and discuss the changes.
