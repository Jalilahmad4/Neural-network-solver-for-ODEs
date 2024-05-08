function y = dNet(x,p)
n = length(x);   % # of inputs
m = floor((length(p)-1)/3); % # of neurons
w = p(1:m);
beta = p(m+1:2*m);
alpha = p(2*m+1:3*m);
bias = p(3*m+1);
z = zeros(n,m);
y = zeros(1,n);
for i=1:n
    z(i,:) = w*x(i) + beta;
    y(i) = sum(alpha.*w.*dsigma(z(i,:)));
end

 
