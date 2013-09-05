function gauss=create_gauss(matrix);

n = 256;
xo = 128;
yo = 128;
sigma1=.404;

switch matrix
    case 256
        sigma = sigma1*128;
    case 128
        sigma = sigma1*64;
    case 64
        sigma = sigma1*32;
end        

for x=1:n
    for y=1:n
        gauss(x,y) = exp(-((x-xo)^2+(y-yo)^2)/(2*sigma^2));
    end
end  
% figure;
%   mesh(gauss);
% 
