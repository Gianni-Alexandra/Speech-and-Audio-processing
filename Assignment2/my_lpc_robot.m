function out = my_lpc_robot(file)
    % INPUT:
    %   file: input filename of a wav file
    % OUTPUT:
    %   None. Saves and plots results for different LPC orders.

    [sig, Fs] = audioread(file);

    %% Define Parameters:
    Horizon = 30;  % 30ms - window length
    LPCOrders = [23, 24, 25];  % LPC orders to experiment with
    Buffer = 0;  % Initialization

    Horizon = Horizon * Fs / 1000;  % Number of samples per frame
    Shift = Horizon / 2;  % Frame step size (50% overlap)
    Win = hanning(Horizon);  % Analysis window
    Lsig = length(sig);

    % Frame Processing Setup:
    slice = 1:Horizon;  % Current frame indices
    tosave = 1:Shift;  % Synthesized signal storage indices
    Nfr = floor((Lsig - Horizon) / Shift) + 1;  % Number of frames

    for OrderLPC = LPCOrders
        % Initialization for each LPC order
        out = zeros(size(sig));
        residual = zeros(size(sig));
        Buffer = 0;  % Reset buffer

        %% Analysis Frame-by-Frame
        for l = 1:Nfr
            sigLPC = Win .* sig(slice);  % Multiply frame by Hanning window
            en = sum(sigLPC.^2);  % Get the short-term energy of the input

            % LPC Analysis
            r = xcorr(sigLPC, OrderLPC, 'biased');  % Compute autocorrelation
            r = r(OrderLPC+1:end);  % Keep the non-negative lags
            a = levinson(r, OrderLPC);  % LPC coefficients
            G = sqrt(sum(a .* r));  % Gain
            ex = filter(a, 1, sigLPC);  % Residual signal (prediction error)
            residual(slice) = ex;  % Store the residual signal

            % Define parameters for robot voice
            pitchPeriod = 100;  % 100 Hz pitch frequency
            excitation = zeros(Horizon, 1);  % Initialize excitation signal
            excitation(1:pitchPeriod:end) = 1;  % Define excitation with constant pitch period

            % LPC Synthesis with Robot Excitation Signal
            s = filter(G, a, excitation);

            % Energy Normalization
            ens = sum(s.^2);  % Short-term energy of the output
            if ens == 0
                g = 1;  % Avoid division by zero
            else
                g = sqrt(en / ens);  % Normalization factor
            end
            s = s * g;

            % Overlap-and-Add
            s(1:Shift) = s(1:Shift) + Buffer;
            out(tosave) = s(1:Shift);
            Buffer = s(Shift+1:Horizon);

            % Update Frame Indices
            slice = slice + Shift;
            tosave = tosave + Shift;
        end

        % Ensure the Output Signal is Real
        out = real(out);

        % Play the Robot-Voiced Signal
        fprintf('Playing the robot-voiced signal with LPC order = %d...\n', OrderLPC);
        soundsc(out, Fs);
        pause(3);

        % Plot signals
        figure;
        plot(sig, 'b', 'DisplayName', 'Original Signal');
        hold on;
        plot(out, 'r', 'DisplayName', 'Robot-Voiced Signal');
        hold off;
        title(sprintf('Original and Robot-Voiced Signals with LPC Order = %d', OrderLPC));
        xlabel('Sample');
        ylabel('Amplitude');
        legend('show');
        grid on;

        % Plot the residual signal
        %figure;
        %plot(residual, 'g');
        %title(sprintf('Residual Signal with LPC Order = %d', OrderLPC));
        %xlabel('Samples');
        %ylabel('Amplitude');
        %grid on;

        % Reset indices for next LPC order
        slice = 1:Horizon;
        tosave = 1:Shift;
    end
end