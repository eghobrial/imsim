%test

new_imgr = image_sim_se(17,2000);

load simfmap
fmap = image75;

fmap = fmap.*15;

disimg = epiDistortion(new_imgr,fmap,64,200);

figure
imagesc(disimg)
colormap(gray)




