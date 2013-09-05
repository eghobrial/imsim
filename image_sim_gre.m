function [new_img_00 gray_pix]=image_sim_gre(TE,TR,alpha,gridopt,epi);

alpha=alpha*pi/180;

%NMR PARAMETERS
%Tissue Name                 : BACKGROUND
%Tissue Label                : 0                     
T1bk=0.000001;
T2bk=0.000001;
T2starbk=0.000001;
PDbk=0;
%
%Tissue Name                 : CSF
%Tissue Label                : 1                     
T1csf=2569;
T2csf=329;
T2starcsf=58;
PDcsf=100;
%
%Tissue Name                 : GREY MATTER
%Tissue Label                : 2                     
T1g=833;
T2g=83;
T2starg=69;
PDg=86;
%
%Tissue Name                 : WHITE MATTER
%Tissue Label                : 3                     
T1w=500;
T2w=70;
T2starw=61;
PDw=77;
%
%Tissue Name                 : FAT
%Tissue Label                : 4                     
T1f=350;
T2f=70;
T2starf=58;
PDf=100;
%
%Tissue Name                 : MUSCLE / SKIN
%Tissue Label                : 5                     
T1m=900;
T2m=47;
T2starm=30;
PDm=100;
%
%Tissue Name                 : SKIN
%Tissue Label                : 6                     
T1s=2569;
T2s=329;
T2stars=58;
PDs=100;
%
%Tissue Name                 : SKULL
%Tissue Label                : 7                     
T1sk=0.000001;
T2sk=0.000001;
T2starsk=0.000001;
PDsk=0;
%
%Tissue Name                 : Glial MATTER
%Tissue Label                : 8                     
T1gl=833;
T2gl=83;
T2stargl=69;
PDgl=86;
%
%Tissue Name                 : MEAT
%Tissue Label                : 9                     
T1mit=500;
T2mit=70;
T2starmit=61;
PDmit=77;
%
%Tissue Name                 : MS LESION
%Tissue Label                : 10                    
%T1 (ms)                     : 752                   
%T2 (ms)                     : 237                   
%T2* (ms)                    : 204                   
%PD                          : 0.76      

load images75

image90bk_new = image90bk * PDbk * exp(-TE/T2starbk) * sin(alpha) * (1-exp(-TR/T1bk))/(1-cos(alpha)* exp(-TR/T1bk));
image90csf_new = image90csf * PDcsf * exp(-TE/T2starcsf) *  sin(alpha) * (1-exp(-TR/T1csf))/(1-cos(alpha)* exp(-TR/T1csf));
image90g_new = image90g * PDg * exp(-TE/T2starg) *  sin(alpha) * (1-exp(-TR/T1g))/(1-cos(alpha)* exp(-TR/T1g));
image90w_new = image90w * PDw * exp(-TE/T2starw) *  sin(alpha) * (1-exp(-TR/T1w))/(1-cos(alpha)* exp(-TR/T1w));
image90f_new = image90f * PDf * exp(-TE/T2starf) *  sin(alpha) * (1-exp(-TR/T1f))/(1-cos(alpha)* exp(-TR/T1f));
image90m_new = image90m * PDm * exp(-TE/T2starm) *  sin(alpha) * (1-exp(-TR/T1m))/(1-cos(alpha)* exp(-TR/T1m));
image90s_new = image90s * PDs * exp(-TE/T2stars) *  sin(alpha) * (1-exp(-TR/T1s))/(1-cos(alpha)* exp(-TR/T1s));
image90sk_new = image90sk * PDsk * exp(-TE/T2starsk) *  sin(alpha) * (1-exp(-TR/T1sk))/(1-cos(alpha)* exp(-TR/T1sk));
image90gl_new = image90gl * PDgl * exp(-TE/T2stargl) *  sin(alpha) * (1-exp(-TR/T1gl))/(1-cos(alpha)* exp(-TR/T1gl));
image90mit_new = image90mit * PDmit * exp(-TE/T2starmit) *  sin(alpha) * (1-exp(-TR/T1mit))/(1-cos(alpha)* exp(-TR/T1mit));

gray_img=reshape(image90g_new(:),181,217);
 gray_img = gray_img(181:-1:1,217:-1:1);
 gray_pix=max(max(gray_img));
 
if (epi=='off')
new_img = image90bk_new+image90sk_new+image90csf_new+image90g_new+image90w_new+image90f_new+image90m_new+image90s_new+image90gl_new+image90mit_new;
%new_img = image90sk_new+image90csf_new+image90g_new+image90w_new+image90gl_new;
else
 %new_img = image90csf_new+image90g_new+image90w_new+image90gl_new;
new_img = image90bk_new+image90sk_new+image90csf_new+image90g_new+image90w_new+image90f_new+image90m_new+image90s_new+image90gl_new+image90mit_new;
end

new_imgr = reshape(new_img(:),181,217);
new_imgr = new_imgr(181:-1:1,217:-1:1);
new_img_00 = zeros(256,256);
%new_img_00(34:214,20:236) = new_imgr;
new_img_00(40:220,25:241) = new_imgr;
 maxi=max(max(new_img_00));
  %make up a grid
  xdim=256;
  zg = zeros(xdim,xdim);
  inc = 24;
  zg(33:inc:(33+192),:) = maxi;
  zg(:,33:inc:(33+192)) = maxi;
  zg(1:32,:) = 0;zg(232:256,:) = 0;
  zg(:,1:32) = 0;zg(:,232:256) = 0;
  size(zg);
if (gridopt=='off')
      new_img_00=new_img_00;
else
    if (epi=='onn')
     new_img_00=new_img_00+zg;
     %new_img_00=min(maxi,new_img_00);
    end 
%   % imagesc(new_img_00');axis('image');title('epi');
%   % colormap(gray(256));
%   %  imwrite(new_img_00','gre_sim1.pgm','PGM','Encoding','ASCII');
 end  

