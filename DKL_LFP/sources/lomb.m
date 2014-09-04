function [f, P]=lomb(t, x, alpha)
%function [f, P]=lomb(t, x, alpha)
%t: time points
%x: signal values
%alpha: significance
%f: output frequencies
%P: output spectral Power at frequencies f.

%Author: Murat Okatan 02/20/2003

%version 3. Handle the case where all power are NaN.
%version 2. Show the phase of the peak frequency in radians and seconds.
%version 1. Compute the lomb spectrum of input. Show the significance of
%   the peak.

if all(x==0),
    errordlg('Input is a zero vector');
    return;
end

if isempty(alpha) | alpha<=0,
    alpha=0.01;
end

t=reshape(t, 1, length(t));
x=reshape(x, 1, length(x));
data=[t;x];

lomb_inputfile=fopen('input.lomb', 'wt');
fprintf(lomb_inputfile, '%f %f\n', data);
fclose(lomb_inputfile);

%Run lomb
if ispc,
    dos('lomb -P input.lomb > output.lomb');
elseif isunix,
    dos('./lomb -P input.lomb > output.lomb');
else
    errordlg('System not Unix nor PC');
    return;
end

[col1, col2]=textread('output.lomb', '%f %f');

M=col1(1);
prob=col2(1);
nout=col1(2);
pwr=col2(2);

f=col1(3:end);
P=col2(3:end);

if all(isnan(P)),
    errordlg('All power are NaN');
    return;
end

z=2*pwr*(-log(1-(1-alpha)^(1/M)))/nout;

figure;plot(f, P);
xlabel('Frequency (Hz)');
ylabel('Relative Power');
title('Lomb Power Spectrum');
hold on;
line([min(f) max(f)], z*[1 1], 'Color', 'r');
text(f(1)+(f(end)-f(1))*0.7, z+abs((max(P)-z)*0.1), sprintf('alpha = %f', alpha));

peak_f=mean(f(find(P==max(P))));
omeg=2*pi*peak_f;
compex=exp(-i*omeg*t);
Z=sum(x.*compex);
phase_r=-angle(Z);
phase_s=phase_r/omeg;
phase_d=phase_r/pi*180;

msg=sprintf('%.3e (%.3f Hz).\nPhase: %.3f rad, %.3f deg, %.3f s', ...
    prob, peak_f, phase_r, phase_d, phase_s);
text(f(min(find(P==max(P))))*1.1, max(P)*0.97, msg);

delete('input.lomb');
delete('output.lomb');