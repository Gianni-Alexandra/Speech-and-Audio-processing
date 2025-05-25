## LPC Analysis, Synthesis and Robot voice generation

### Objective
This assignment explores the fundamentals of Linear Prediction (LP) analysis and synthesis for speech processing using MATLAB. The project also includes modifying the excitation signal to generate a robot-like voice effect.

### Task Overview
***Question 1: LP Analysis-Synthesis***
- Implement:
  - Autocorrelation of a speech frame (xcorr).
  - Levinson-Durbin recursion (custom implementation).
  - Gain computation of the LP filter.
  - Inverse filtering to get the LP error.
- Process a .WAV speech file (*sample.wav*) frame-by-frame.
- Save the reconstructed signal with *audiowrite* and compare it to the original using *soundsc*.
 
***Question 2: Robot Voice effect***
- Modify the excitation signal (line 43) to synthesize a robotic voice using a fixed pitch period.
- Experiment with different LP orders (e.g. 20 and 28) compared to the default 24.
- Save the synthesized robot speech and comment on how pitch period and LP order affected the result.

