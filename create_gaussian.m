n = 256;
xo = 128;
yo = 128;

sigma = .404*128;

for x=1:n
    for y=1:n
        %gaussian(x,y) = (1/2*pi*sigma^2)*(exp(-((x-xo)^2+(y-yo)^2)/2*sigma^2));
        gaussian(x,y) = (exp(-((x-xo)^2+(y-yo)^2)/(2*sigma^2)));
    end
end    

%  gaussian=gaussian.^2;
 % gaussian = gaussian';
imagesc(gaussian);axis('image');title('gaussian');
colormap(gray(256));
figure;
mesh(gaussian)