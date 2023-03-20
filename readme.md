# RLC measurements using Keysight Precision RLC Meter

Download the latest version of your RLC meter manual (https://www.keysight.com/us/en/assets/9018-06166)

## RLC Measurements
An RLC meter uses the current and voltage to determine the real and imaginary components of the impedance in the tested element. From these values, the equipment is able to calcualte other parameters (like inductance or capacitance) depending on an equivalent circuit model. It is for the user to determine which equivalent circuit better describes the tested system and correct accordingly. The equivalent model used by the RLC meter can be changed by setting the "type of measurement" setting. In general, a low impedance, e.g. < 100 ohm (low resistance, high capacitances or low inductances), can be tested using the series model and high impedance (high resistances, low capacitances or high inductors) with a paralel model.

To select the type of measurement the RLC meter will perform, you may select any of the following type parameters:
{CPD|CPQ|CPG|CPRP|CSD|CSQ|CSRS|LPD|LPQ|LPG|LPRP|LPRD|LSD|LSQ|LSRS|LSRD|RX|ZTD|ZTR|GB|YTD|YTR|VDID}

#### The first part of the type denotes the primary parameter, as:
- Cp Capacitance value measured using the parallel equivalent circuitmodel
- Cs Capacitance value measured using the series equivalent circuit model
- Lp Inductance value measured using the parallel equivalent circuit model
- Ls Inductance value measured using the series equivalent circuit model
- R Resistance
- Z Absolute value of impedance
- G Conductance
- Y Absolute value of admittance

#### The second part denotes the secondary parameter from:
- D Dissipation factor
- Q Quality factor (inverse of dissipation factor)
- G Conductance
- Rs Equivalent series resistance measured using the series equivalent circuit model
- Rp Equivalent parallel resistance measured using the parallel equivalentcircuit model
- X Reactance
- B Sustenance
- Phase angle

## The matlab code
Use the function run_RLC to run a sweep and retreive the data from the equipment, the function parameters are:
- instr:  A VISA connection to an instrument, either GPIB or TCP/IP. (e.g. instr = tcpclient(192.168.1.1, 5025,'Timeout',5);)
- freqs:  A double array with the frequencies to measure. (e.g. freqs =linspace(20,1e3,100); )
- func:   String with the type of measurement specification. (e.g. func = 'ZTD')

Note that an instrument can only run 201 frequencies at a time.

```
instr = tcpclient(192.168.1.1, 5025,'Timeout',10);
f = logspace(20, 2e6, 201);
func = 'ZTD';

[Z, T] = run_RLC(instr,freqs, type);

figure; 
yyaxis left
plot(f,Z); ylabel('Impedance (Ohm)')

yyaxis rigth
plot(f,T); ylabel('Angle (rad)')
```
