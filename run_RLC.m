function [data1, data2] = run_RLC(instr, freqs, func)  
%Runs a sweep in an RLC system for teh frequencies and the type of
%measurement specified.
% instr: Instrument (TCPIP or GPIB VISA Connection)
% freqs: Array of frequencies (Double array, maximim size is 201;
% func:  Function to run in the RLC sweep (Check page 399 in the manual for
% options)

    send(instr,'*RST;*CLS');         %viVPrintf(AgtE4980A/AL, "*RST;*CLS" + vbLf, 0)
    %send(instr,'*SRE 0');
    %send(instr,'STAT:OPER:ENAB 0');

    send(instr,'TRIG:SOUR BUS');     %viVPrintf(AgtE4980A/AL, "TRIG:SOUR BUS" + vbLf,0)
    %send(instr,'APER LONG,3');     % Averaging time for each measurement LONG / SHORT / MID
    send(instr,'DISP:PAGE LIST');    %viVPrintf(AgtE4980A/AL, "DISP:PAGE LIST" + vbLf, 0)
    send(instr,'FORM ASC');          %viVPrintf(AgtE4980A/AL, "FORM ASC" + vbLf, 0)
    send(instr,'LIST:MODE SEQ');     %viVPrintf(AgtE4980A/AL, "LIST:MODE SEQ" + vbLf,0)
    if isempty(func)
        func = "CPD";
    end
    send(instr,":FUNC:IMP:TYPE "+func);

    Nop = length(freqs);
    str_freq = num2str(freqs(1),3);
    for i = 2:Nop
        str_freq = str_freq + ", " +  num2str(freqs(i),6) ;
    end
    send(instr,'LIST:FREQ %s', str_freq); %viVPrintf(AgtE4980A/AL, "LIST:FREQ 1E3,2E3,5E3,1E4,2E4,5E4,1E5" + vbLf, 0)
    
    % Prepare the bands for the measurement
    send(instr,'LIST:BAND1 A,100,200');  %viVPrintf(AgtE4980A/AL, "LIST:BAND1 A,100,200" + vbLf, 0)
    send(instr,'LIST:BAND2 A,100,200');  %viVPrintf(AgtE4980A/AL, "LIST:BAND2 A,100,200" + vbLf, 0)
    send(instr,'LIST:BAND3 A,100,200');  %viVPrintf(AgtE4980A/AL, "LIST:BAND3 A,100,200"+ vbLf, 0)
    send(instr,'LIST:BAND4 A,100,200');  %viVPrintf(AgtE4980A/AL, "LIST:BAND4 A,100,200"+ vbLf, 0)
    send(instr,'LIST:BAND5 A,100,200');  %viVPrintf(AgtE4980A/AL, "LIST:BAND5 A,100,200"+ vbLf, 0)
    send(instr,'LIST:BAND6 A,100,200');  %viVPrintf(AgtE4980A/AL, "LIST:BAND6 A,100,200"+ vbLf, 0)
    send(instr,'LIST:BAND7 A,100,200');  %viVPrintf(AgtE4980A/AL, "LIST:BAND7 A,100,200"+ vbLf, 0)
    
    send(instr,'INIT:CONT ON');
    send(instr,':TRIG:IMM');
    
    %send(instr,'*SRE 128')
    %send(instr,'STAT:OPER:ENAB 16')

    % Read the result
    stabyte = [];
    while isempty(stabyte)
        stabyte = send(instr,'*SRE?'); %Messy way of waiting
        %pause(Nop/10);% Roughly 10 measurements per second
        warning('off','all');
    end
    warning('on','all')

    res = send(instr,':FETC?');

    if res == "+0"
        pause(1); 
        res = send(instr,':FETC?');
    end
    % Convert the data into an array of numbers
    result = split(res, ",");
    data1 = [];
    data2 = [];
    for i = 1:4:Nop * 4 
        data1 = [data1; str2num(result(i))];
        data2 = [data2; str2num(result(i+1))];
    end  
end