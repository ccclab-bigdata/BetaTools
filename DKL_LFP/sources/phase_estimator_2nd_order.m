function [min_phase_confidence, mean_phase, max_phase_confidence, mean_r]=phase_estimator_2nd_order(r_data_vector, phase_data_vector, confidence)
%function [min_phase_confidence, mean_phase, max_phase_confidence, mean_r]=phase_estimator_2nd_order(r_data_vector, phase_data_vector, confidence)
%r_data_vector     : vector of r values
%phase_data_vector : vector of phase values
%confidence        : confidence level of the interval (0<confidence<1)
%
%min_phase_confidence: lower boundary of the confidence interval
%mean_phase          : average phase
%max_phase_confidence: upper boundary of the confidence interval
%mean_r              : average radius

%Author Murat Okatan. 04/30/03. 
%Reference: Biostatistical analysis. 2nd Ed. Jerrold H. Zar (1974)
%           Prentice-Hall

min_phase_confidence=[];
mean_phase=[];
max_phase_confidence=[];
mean_r=[];


r=r_data_vector;
phase=phase_data_vector;

k=length(r);
if ~k | confidence<=0 | confidence>=1,
    return;
end
if k~=length(phase),
    errordlg('Different number of radii and phase');
    return;
end

compex=r.*exp(sqrt(-1)*phase);
mean_compex=mean(compex);

mean_r=abs(mean_compex);
mean_phase=angle(mean_compex);

if k<=2,
	mean_phase=mean_phase/pi*180;
	min_phase_confidence=[];
	max_phase_confidence=[];
    return;
end


X=r.*cos(phase);
Y=r.*sin(phase);

X_bar=mean(X);
Y_bar=mean(Y);

sum_x_sqr=sum(X.^2)-sum(X)^2/k;
sum_y_sqr=sum(Y.^2)-sum(Y)^2/k;
sum_xy   =sum(X.*Y)-sum(X)*sum(Y)/k;

A= (k-1)/sum_x_sqr;
B=-(k-1)*sum_xy/sum_x_sqr/sum_y_sqr;
C= (k-1)/sum_y_sqr;
D= (k-1)*2*(1-sum_xy^2/sum_x_sqr/sum_y_sqr)*finv(confidence, 2, k-2)/k/(k-2);
H= A*C-B^2;
G= A*X_bar^2+2*B*X_bar*Y_bar+C*Y_bar^2-D;
U= H*X_bar^2-C*D;
V= sqrt(D*G*H);
W= H*X_bar*Y_bar+B*D;

b1=(W+V)/U;
b2=(W-V)/U;

M1=sqrt(1+b1^2);
phase_1=asin(b1/M1)+[0 pi];
compex_1=exp(sqrt(-1)*phase_1);
diff_1=abs(compex_1-exp(sqrt(-1)*mean_phase));
indx=diff_1==min(diff_1);
phase_1=phase_1(indx);

M2=sqrt(1+b2^2);
phase_2=asin(b2/M2)+[0 pi];
compex_2=exp(sqrt(-1)*phase_2);
diff_2=abs(compex_2-exp(sqrt(-1)*mean_phase));
indx=diff_2==min(diff_2);
phase_2=phase_2(indx);

if ~isreal(phase_1) | ~isreal(phase_2),
    min_phase_confidence=[];
    max_phase_confidence=[];
	mean_phase=mean_phase/pi*180;
    return;
end

if rem(2*pi+phase_1, 2*pi)<rem(2*pi+phase_2, 2*pi),
	min_phase_confidence=phase_1;
	max_phase_confidence=phase_2;
else
	min_phase_confidence=phase_2;
	max_phase_confidence=phase_1;
end

min_phase_confidence=min_phase_confidence/pi*180;
mean_phase=mean_phase/pi*180;
max_phase_confidence=max_phase_confidence/pi*180;
