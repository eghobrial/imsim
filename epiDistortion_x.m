 function distortedImage = epiDistortion(originalImage, fieldMap, bandWidth, rampTime)
% DISTORTEDIMAGE = EPIDISTORTION(ORIGINALIMAGE, FIELDMAP, BANDWIDTH, RAMPTIME)
% calculates the geometric and intensity distortion of a echo planar image
% from the (undistorted) image and it's field map. note that geometric
% distortion occurs mainly along phase encoding direction for echo planar 
% image. frequncy encoding direction is the horizontal axis for 
% both the image and field map.
%
% Assumption for epi sequence: trapezoidal readout gradient waveforms and 
% triangular phase encoding blips.
%
% input:
%   originalImage: 2D image, undistorted
%   fieldMap: field distribution of originalImage, in Hz
%   bandWidth: bandwidth of frequency encoding in kHz
%   rampTime: gradient rise time, in microSeconds
% output:
%   distortedImage: 2D image, distorted

%Created by Yansong Zhao, VUIIS. 09/15/2003
%This is a function of Image Toolbox
	
[Np,Ns] = size(originalImage);
bandWidth = bandWidth * 1000; % in Hz
rampTime = rampTime * 1e-6; % in Second

% initialization
distortedImage = zeros([Np,Ns]);

h = waitbar(0.1,'Calculating Distortion Please wait...');

% Loop through each separate column 
% distortion along phase encoding direction
for ks = 1 : Ns
    
    % Step through distorted positions (y1) and 
    % determine the original position (y)
    for y1 = 1 : Np
       
        y = 1;
        Positions = []; % record position
        while (y+1 < Np)
            % calculate the relative pixel shift along phase encoding
            % direction. for echo planar imaging sequence with trapezodial
            % readout gradient and triangular phase encoding blips:
            % delatY = (2 * rampTime + Ns / bandWidth) * Np * fieldmap
            % unit of deltaY: pixel size
            
            % pixel at y was distorted to position1
            position1 = y + (2*rampTime+Ns./bandWidth)*Np*fieldMap(ks,y);
            % pixel at y + 1 was distorted to position2
            position2 = y + 1 + (2*rampTime+Ns./bandWidth)*Np*fieldMap(ks,y+1);
            
            if position1<=y1 & position2 >=y1
                % y1 was distorted from some point between y and y+1
                Positions = [Positions; y, position1, position2];
            end
            
            y = y + 1;
        end
        
        % Loop number of positions just in case more than one point map to
        % same position
        for k = 1: size(Positions,1)
            
            y = Positions(k,1);
            position1 = Positions(k,2);
            position2 = Positions(k,3);
            
            % determine the original positoin's offset from y
            if (position1 ~=position2)
                yOffset = (y1 - position1)/(position2-position1);
            else
                yOffset = 0;
            end
     
		    % Interpolate the intensity at y
		    intensityY = interpolateBetweenPixels(originalImage(ks,y), originalImage(ks,y+1), yOffset);
            
            % since y1 = y + (2*ramp+Ns/BW)*Np*B. B: field inhomogeneity, BW: bandwidth
            % Jacobian dy1/dy = 1 + (2*ramp+Ns/BW)*Np*(dB/dy)
            
            % compute dB/dy
		    if (y == Np) % Reverse difference
			    dBdy = fieldMap(ks,y) - fieldMap(ks,y-1);
		    else % Forward difference
 			    dBdy = fieldMap(ks,y+1) - fieldMap(ks,y);
		    end
       
            % Jacobian
            dy1dy = 1 + (2*rampTime+Ns/bandWidth)*Np*dBdy;
            
            % intensity distortion		
   		    intensityY1 = intensityY / dy1dy;
   		    
            distortedImage(ks,y1) = distortedImage(ks,y1) + intensityY1;
            
	    end % for k
			
	   if (distortedImage(ks,y1) < 0)
		    distortedImage(ks,y1) = 0;
	    end
			
    end  % for y1
       waitbar(ks/Ns,h)
end % for ks
close(h)

% END of epiDistortion.m 
% This is a function of Image Toolbox