function out = my_lpc(file)
%
% INPUT:
%   file: input filename of a wav file
% OUTPUT:
%   out: a vector contaning the output signal
%
% Example:   
%   out = my_lpc('sample.wav');
%   [sig,fs]= audioread('sample.wav');
%   sound(sig,fs);
%   sound(out,fs);

[sig, Fs] = audioread(file);
%% Define Parameters:
Horizon = 30;               %30ms - window length  #Frame the signal.Framesize
OrderLPC=24;                %order of LPC   #The number of linear prediction coefficients.
Buffer = 0;                  % initialization
out = zeros(size(sig));      % initialization. Placeholder for the output signal
residual = zeros(size(sig)); % initialization

%% Convert Horizon to Samples: ms->samples. 
Horizon = Horizon*Fs/1000;      % Number of samples per frame.
Shift = Horizon/2;              % Frame step size (50% overlap for smoother synthesis).
Win = hanning(Horizon);         % Analysis window. A Hanning window smooths the signal within each frame.
%% Frame Processing Setup:
Lsig = length(sig);
slice = 1:Horizon;                    %Specifies the current frame indices.
tosave = 1:Shift;                     %Specifies where the synthesized signal will be stored.
Nfr = floor((Lsig-Horizon)/Shift)+1;  % number of frames.

%% Analysis frame-by-frame
for l=1:Nfr
  % Windowing the Signal
  sigLPC = Win.*sig(slice);    % Multiplies the current frame by the Hanning window.
  en = sum(sigLPC.^2);         % get the short - term energy of the input
  
  %% LPC analysis
  r = xcorr(sigLPC, OrderLPC, 'biased');  % correlation (to be computed using xcorr).
  r = r(OrderLPC+1:end);        % Keep the non-negative lags
  
  a = levinson(r, OrderLPC);   % LPC coefficients. Derived using Levinson recursion.
  G = sqrt(sum(a .* r));       % gain. The gain is equal to the square root of the LPC coefficients and autocorrelation values of the signal.
  ex = filter(a, 1, sigLPC);   % inverse filter. Prediction error (residual signal) after inverse filtering.
  residual(slice) = ex;        % store residual signal
  %% synthesis
  s = filter(G,a, ex);  %Synthesizes the speech frame from the residual signal using the LPC filter.
  
  %% Energy Normalization: Balances the energy between the original and synthesized frames.
  ens = sum(s.^2);      % get the short-time energy of the output
  g = sqrt(en/ens);     % normalization factor
  s  =s*g;              % energy compensation

  %% Overlap-and-Add: Combines overlapping frames to ensure smooth signal reconstruction
  s(1:Shift) = s(1:Shift) + Buffer;   % Add overlap from previous frame. Overlap and Add
  out(tosave) = s(1:Shift);           % save the first part of the frame. Save the processed frame
  Buffer = s(Shift+1:Horizon);        % Store the remaining part in buffer
  
  %% Update Frame Indices:
  slice = slice+Shift;     % move the frame
  tosave = tosave+Shift;
  
end

 % Ensure the output signal is real
 out = real(out);

 %% Save the processed signal
 audiowrite('processed_signal.wav', out, Fs);
 disp('Processed signal saved as processed_signal.wav');

 % Play the original signal
 disp('Playing the original signal...');
 soundsc(sig, Fs);
 pause(length(sig) / Fs + 1); % Pause to ensure playback completes

 % Play the processed signal
 disp('Playing the processed signal...');
 soundsc(out, Fs);

 disp("End!")

 %% Plot signals

 % plot the original signal 
 figure;
 subplot(2,1,1);
 plot(sig, 'b');
 title('Original signal');
 xlabel('Samples');
 ylabel('Amplitude');
 grid on;
 
 % plot the synthesized signal
 subplot(2,1,2);
 plot(out, 'r');
 title('Synthesized signal');
 xlabel('Samples');
 ylabel('Amplitude');
 grid on;

 % plot the residual
 figure;
 plot(residual, 'g');
 title('residual signal');
 xlabel('Sample');
 ylabel('Amplitude');
 %legend('show');
 grid on;

 % plot the two signals on the same grid
 figure;
 plot(sig, 'b', 'DisplayName', 'Original Signal');
 hold on;
 plot(out, 'r', 'DisplayName', 'Synthesized Signal');
 hold off;
 title('Original and Synthesized signals');
 xlabel('Sample');
 ylabel('Amplitude');
 legend('show');
 grid on;

end
