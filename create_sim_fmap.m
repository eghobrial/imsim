n = 256;
xo = 128;
yo = 66;

sigma = 0.015;

for x=1:n
    for y=1:n
        fmap(x,y) = exp(-((x-xo)^2+(y-yo)^2)/2*sigma^2);
    end
end    

fmap=fmap.^2;
fmap = fmap';
imagesc(fmap);axis('image');title('fmap');
colormap(gray(256));


I = image_sim_gre_epi(4,10,15);

I1=mat2gray(I');
%I1=I1(50:370,70:450,1);
figure('Name','Image off the gre sim');
imagesc(I1);
colormap('gray')

I2=I1>.05;
figure('Name','Threshold > 0.05');
imagesc(I2)
colormap('gray')

I3=bwareaopen(I2,10);
figure('Name','bwareaopen');
imagesc(I3)
colormap('gray')

I4=bwfill(I3,'holes');
figure('Name','fill holes');
imagesc(I4)
colormap('gray')


twoi=fmap+I4;
figure('Name','Two added together');
imagesc(twoi)
colormap(gray)


newfmap1=fmap.*I4;

twoi=newfmap1+I4;
figure('Name','Two added together');
imagesc(twoi)
colormap(gray)

immin=min(min(newfmap1))
immax=max(max(newfmap1))
immean=mean(mean(newfmap1))
%newfmap1=(newfmap1-immean)/(immax-immin);


maxi=max(max(newfmap1));
figure('Name','fmap hist');

hist(newfmap1)
%make up a grid
xdim=256;
zg = zeros(xdim,xdim);
inc = 24;
zg(33:inc:(33+192),:) = maxi;
zg(:,33:inc:(33+192)) = maxi;
zg(1:32,:) = 0;zg(232:256,:) = 0;
zg(:,1:32) = 0;zg(:,232:256) = 0;

%newfmap1=newfmap1+zg;

figure('Name','final fmap ');
imagesc(newfmap1);axis('image');title('epi');
colormap(gray(256))

