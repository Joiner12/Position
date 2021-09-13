function [Dref, pr_set] = wireless_channel_simulation(freq, TXAntenna_Gain, RXAntenna_Gain)
    %-----------Parameters Setting------------%
    LightSpeedC = 3e8;
    % BlueTooth = 2400 * 1000000; %hz
    % Zigbee = 915.0e6; %hz
    Freq = freq;
    TXAntennaGain = TXAntenna_Gain; %db
    RXAntennaGain = RXAntenna_Gain; %db
    PTx = 0.001; %watt
    sigma = 6; %Sigma from 6 to 12 %Principles of communication systems simulation with wireless application P.548
    mean = 0;
    PathLossExponent = 2; %Line Of sight

    %------------ FRIIS Equation --------------
    % Friis free space propagation model:
    %        Pt * Gt * Gr * (Wavelength^2)
    %  Pr = --------------------------
    %        (4 *pi * d)^2 * L

    pr_set = zeros(0);
    Wavelength = LightSpeedC / Freq;
    PTxdBm = 10 * log10(PTx * 1000);
    Dref = 0:1:100; % distance
    M = Wavelength ./ (4 * pi * Dref);
    % Pr0 = PTxdBm + TXAntennaGain + RXAntennaGain - (20 * log10(1 / M));
    pr_set = PTxdBm + TXAntennaGain + RXAntennaGain - (20 .* log10(1 ./ M));

    if false
        figure;
        fg = plot(pr_set);
        set(fg, 'Linewidth', 2);
        ylabel('RX Power (dBm)');
        xlabel('Distance (m)');
        grid on;
        set(gca, 'XMinorGrid', 'on');
        set(gca, 'YMinorGrid', 'on');

        set(gcf, 'position', [600 500 500 320]);
        set(gca, 'FontSize', 18, 'FontName', 'Arial', 'FontWeight', 'normal');
    end

end
