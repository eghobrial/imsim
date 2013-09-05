function val = interpolateBetweenPixels(val1, val2, offset)
% VAL = INTERPOLATEBETWEENPIXELS(VAL1,VAL2,OFFSET) returns the linear 
% interpolation for one dimensional data between two adjacient pixels. 
% i.e. val1 = f(n1), val2 = f(n1+1), val = f(n1+offset)

%Created by Yansong Zhao, VUIIS. 08/15/2003
%This is a function of Image Toolbox

val = (val2 - val1) * offset + val1;

% END of interpolateBetweenPixels.m 
% This is a function of Image Toolbox