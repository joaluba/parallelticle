function p=gauss_probability(val, mu, sigma,binwidth,varargin)


x1=val-(binwidth/2);
x2=val+(binwidth/2);

y1=normpdf(x1,mu,sigma);
y2=normpdf(x2,mu,sigma);

p=(x2-x1).*(y1+y2)/2;

p=max(p,realmin);

% if ~isempty(varargin)
% range=varargin{1};
% if val<range(1) ||val<range(2) 
%  p=0; 
% end

 end



                    
                    
                    
                
                    
                    
                    