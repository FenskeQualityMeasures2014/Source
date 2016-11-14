%Lets create a tabletop image

%Lets use dimensions of Lytro decoded light field images = 380 by 380
%pixels, 9 by 9 angles, and 3 colors.

%define tabletop as checkerboard on y-z plane
%put center of camera at (0,10,0)
%angle camera down at table 30 degrees from vertical
%define deltaX for camera pixels as .001
%for a ray originating at (x0,y0,z0)
%calculate intersection with table

angles = -0.1:0.025:0.1; %degrees
xDim = 380;
yDim = 380;
LFtabletop = zeros(9,9,380,380,3);
for i=1:xDim
    for j=1:yDim
        %calculate pixel position (x0,y0,z0)
        x0 = 0 + .001*i;
        y0 = 10 - sqrt(3)/2*.001*j;
        z0 = 0 + 1/2*.001*j;
        disp([i j]);
        for k=1:length(angles)
            for l=1:length(angles)
                %calculate tabletop coordinates
                z = y0*tan((90-5-angles(l))/180*pi) - z0;
                x = (z+z0)*tan(angles(k)/180*pi) - x0;
                %apply checkboard texture
                if (mod(floor(10*x)+floor(10*z),2)==0)
                    LFtabletop(l,k,j,i,:) = .2;
                else
                    LFtabletop(l,k,j,i,:) = .9;
                end
            end
        end
    end
end