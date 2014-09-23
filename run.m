p=primes(1000000);
nums=[pi .3232 rand(1,3)*5];
for i=1:length(nums)
    figure;
    hist(mod(p,nums(i)),300);
end