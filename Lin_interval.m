tic
clear('instr')

% Connect to the isntrument
ipaddress =  "192.168.1.71";
TimeOutTime = 1000;
instr = tcpclient(ipaddress, 5025,'Timeout',TimeOutTime/1e3); 
send(instr,'*IDN?')

%Define the frequencies to test the device
sta_f = 20e0;     % Start frequency, min 20 Hz
end_f = 1e6;     % Stop frequency, max 2e6 Hz
nop = 1000;      % Number of points (freqeuncies will be logartihmially spaced)
type = "CPD";    % Check page 399 in the manual for more options


%Determine an array of ranges of frequencies for blocks of max_nop mesurements.

max_nop = 201;
nor = ceil(nop/max_nop);
f_lims = linspace(sta_f, end_f, nor+1);

%In a loop interate over the frequencies, setting up at maximum max_nop measurements. 
all_val1 = [];
all_val2 = [];
all_freqs = [];
for i = 1: nor
    if i == nor
        freqs = linspace(f_lims(i),f_lims(i+1),mod(nop,max_nop));
    else
        freqs = linspace(f_lims(i),f_lims(i+1),max_nop);
    end
    [val1, val2] = run_RLC(instr,freqs, type);

    all_freqs = [all_freqs; freqs'];
    all_val1 = [all_val1; val1];
    all_val2 = [all_val2; val2];
end

%Plot the result.
    figure(1), clf;
    yyaxis left
    plot(all_freqs, all_val1, 'x'); hold on
    yyaxis right
    plot(all_freqs, all_val2, 'x'); grid on;
    hold off

%Cleat the instrument connection
    clear('instr')
    toc

data_export = [all_freqs, all_val1, all_val2];
writematrix(data_export, 'linearRLC_measurement.csv');