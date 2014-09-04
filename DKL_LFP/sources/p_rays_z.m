function P=p_rays_z(z, n)
%function P=p_rays_z(z, n)
%the probability of obtaining a Rayleigh's Z of at least z using n samples, 
%if the samples are uniformly distributed. This is the significance of the Z.

%Author - Murat Okatan 04/27/03.
%Reference Durand D. and Greenwood J. A. (1958) J. Geol., V66, pp229-238.
%Eq(4)

%version 1. Compute the significance using up to O(n^-2) terms given in the paper. 

P=exp(-z)*(1+(z-z^2/2)/2/n-(z-11*z^2/2+19*z^3/6-9*z^4/24)/12/n^2);