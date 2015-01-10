function [Gamma,Beta,Alpha,Theta,Delta] = getBand(mySignal,waveletFunction)

[C,L] = wavedec(mySignal,5,waveletFunction);

%Calculation The Coificients Vectors of every Band 
cD1 = detcoef(C,L,1); %NOISY 
cD2 = detcoef(C,L,2); %Gamma 
cD3 = detcoef(C,L,3); %Beta 
cD4 = detcoef(C,L,4); %Alpha 
cD5 = detcoef(C,L,5); %Theta 
cA5 = appcoef(C,L,waveletFunction,5); %Delta

%Calculation the Details Vectors of every Band : 
D1 = wrcoef('d',C,L,waveletFunction,1); %NOISY 
D2 = wrcoef('d',C,L,waveletFunction,2); %Gamma 
D3 = wrcoef('d',C,L,waveletFunction,3); %Beta 
D4 = wrcoef('d',C,L,waveletFunction,4); %Alpha 
D5 = wrcoef('d',C,L,waveletFunction,5); %Theta 
A5 = wrcoef('a',C,L,waveletFunction,5); %Delta

Gamma = D2; figure, plot(1:1:length(Gamma),Gamma); 
Beta = D3; figure, plot(1:1:length(Beta),Beta); 
Alpha = D4; figure, plot(1:1:length(Alpha),Alpha); 
Theta = D5; figure, plot(1:1:length(Theta),Theta); 
Delta = A5; figure, plot(1:1:length(Delta),Delta);