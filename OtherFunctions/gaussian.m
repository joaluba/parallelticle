function p=gaussian(x,mu,sigma)
p=(1/(sqrt(2*(sigma.^2)*pi))) * exp(- ((x-mu).^2)/(2*sigma.^2) ) ; 
end
