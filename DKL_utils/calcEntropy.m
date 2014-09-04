function H = calcEntropy(x)

totCount = sum(x);
p = x / totCount;
p_logp = p.* log(p);
p_logp(isnan(p_logp)) = 0;

H = -sum(p_logp);

H(isnan(H)) = 0;