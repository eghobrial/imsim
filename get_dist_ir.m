function [imga imgb imsnr] = get_dist_se(mag,phase,magicn,nex,matrix,bw,b0,phasencode,epi,gray_pix,gaussopt)
fov=256;
res=(fov/matrix);
slicet=.1;
if (epi=='onn')
  load simfmap1
  r=20;
  r=20*b0/3;
  matrix1=256;
  newfmap1=newfmap1.*r;
  ge_mag = mag;
  ge_phase = phase';
  %ge_complex=ge_mag.*(cos(ge_phase)+i*sin(ge_phase));
  %distort the mag image
  switch phasencode
    case 'ypm'
        dimage = epiDistortion(mag,newfmap1,bw,200);
    case 'ymp'
        dimage = epiDistortion_yrev(mag,newfmap1,bw,200);
    case 'xpm'
        dimage = epiDistortion_x(mag,newfmap1,bw,200);
    case 'xmp'
        dimage = epiDistortion_xrev(mag,newfmap1,bw,200);
  end
  %figure;
  % imin=min(min(dimage))
  % imax=max(max(dimage))
  % imagesc(dimage);axis('image');title('Distored Image');
  ge_complex=dimage.*(cos(ge_phase)+i*sin(ge_phase));
  nks_comp = fftshift(fft2(ge_complex));
  %iks=ifft2(nks_comp);
  %magicn=96;
   noise=((sqrt(bw))*(sqrt((256/matrix))))/(res*res*sqrt(nex)*b0);
   noise=noise*(256/matrix)*1000;
  
  r1=noise*randn(matrix1,matrix1);
  r2=noise*randn(matrix1,matrix1);
    rn=r1+i*r2;
 nks_comp=nks_comp+rn;
  b1  = zeros(256,256);
  c1 = zeros (256,256);
%   b = abs(nks_comp)+r1;
%   c = angle(nks_comp)+r2;
b = abs(nks_comp);

if (gaussopt=='onn')
   gauss = create_gauss(matrix);
   b = b .* gauss;
   figure('Name','Kspace after gauss filter');
   imagesc(abs(b).^.2);
   colormap(gray);
end 
c = angle(nks_comp);
  if matrix==256
     b1=b;
     c1=c;
  else
    b1(magicn:256-magicn-1,magicn:256-magicn-1)=b(magicn:256-magicn-1,magicn:256-magicn-1);
    c1(magicn:256-magicn-1,magicn:256-magicn-1)=c(magicn:256-magicn-1,magicn:256-magicn-1);
  end
   nks_mag=b1;
  nks_phase=c1;
  nks_complex=nks_mag.*(cos(nks_phase)+i*sin(nks_phase));
  iks=ifft2(nks_complex);
  imga=abs(iks);
  imgb=angle(iks);
  %figure('Name','Kspace Modified');
  %imagesc(abs(nks_mag).^.2);
  %colormap(gray);
  %figure
  %imagesc(abs(iks));
  %colormap(gray);
  %figure;
  %imagesc(angle(iks));
  %colormap(gray);
   imstd = std(std(imga));
immean = mean(mean(imga));

noiseim= noise*(.0049/1.25)*(matrix/256);
imsnr = (gray_pix)/(noiseim) ;
if (gaussopt=='onn')
imsnr=imsnr*2;
end 

%imsnr=immean/imstd;
else
 ge_complex=mag.*(cos(phase)+i*sin(phase));
  noise=((sqrt(bw))*(sqrt((256/matrix))))/(res*res*sqrt(nex)*b0);
   noise=noise*(256/matrix)*1000;
  r1=noise*randn(256,256);
 r2=noise*randn(256,256);
   r=r1+i*r2;
 ks_complex = fftshift(fft2(ge_complex));
  ks_complex=ks_complex+r;
%  figure('Name','Kspace Origninal');
%  imagesc(abs(ks_complex).^.2);
%  colormap(gray);
 b=abs(ks_complex);
 if (gaussopt=='onn')
   gauss = create_gauss(matrix);
   b = b .* gauss;
%    figure('Name','Kspace after gauss filter');
%    imagesc(abs(b).^.2);
%    colormap(gray);
end 
 
 c=angle(ks_complex);
 b1  = zeros(256,256);
 c1 = zeros (256,256);
 if matrix==256
    b1=b;
    c1=c;
 else
    b1(magicn:256-magicn-1,magicn:256-magicn-1)=b(magicn:256-magicn-1,magicn:256-magicn-1);
    c1(magicn:256-magicn-1,magicn:256-magicn-1)=c(magicn:256-magicn-1,magicn:256-magicn-1);
 end    
%  size(b1)
  nks_mag=b1;
  nks_phase=c1;
%  figure('Name','Kspace Modified');
%  imagesc(abs(nks_mag).^.2);
%  colormap(gray);
 nks_complex=nks_mag.*(cos(nks_phase)+i*sin(nks_phase));
 iks=ifft2(nks_complex);
 %b2=ifft2(b1);
 imga=abs(iks);
 size(imga);
 imstd = std(std(imga));
immean = mean(mean(imga));
noiseim= noise*(.0049/1.25)*(matrix/256);
imsnr = (gray_pix)/(noiseim) ;
if (gaussopt=='onn')
imsnr=imsnr*2;
end 

imgb=angle(iks);
%imsnr=immean/imstd;
end


