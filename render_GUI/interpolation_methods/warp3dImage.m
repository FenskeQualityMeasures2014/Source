function warped_image = warp3dImage(Image1, Depth1, shift, focus, zNearFar)

warped_image = zeros(480, 640, 3);
zMin = zNearFar(1);
zMax = zNearFar(2);
%zMax = zNearFar(1) + .01;
zResolution = 256;
z = zMax;
warpedDepth = zMax*ones(480,640);
threshold = .1*(zMax - zMin);

for i=1:zResolution
    zLow = z;
    z = 1/(i/zResolution * (1/zMin - 1/zMax) + 1/zMax);
    pixels_to_shift = (Image1(:,:,1) > 0) & (Image1(:,:,2) > 0) & (Image1(:,:,3) > 0) ...
        & (Depth1(:,:) < zLow) & (Depth1(:,:) > z-.0001);
    image_to_warp = cat(3,Image1(:,:,1).*pixels_to_shift, Image1(:,:,2).*pixels_to_shift, Image1(:,:,3).*pixels_to_shift);
    transx = shift(1)*((focus)/((z + zLow)/2)-1);
    transx = shift(1)*(focus - (z + zLow)/2)/((z + zLow)/2);
%     disp(transx);
%     disp(((z + zLow)/2 - focus)/focus);
%     disp(((z + zLow)/2 - focus)/focus/transx);
    transy = shift(2)*((focus)/((z + zLow)/2)-1);
    transy = shift(2)*(focus - (z + zLow)/2)/((z + zLow)/2);
    A = [1,0,0;0,1,0;transx,transy,1];
    T = maketform('affine',A);
    warped_image_piece = imtransform(image_to_warp, T, 'near', ...
        'XData',[1 size(image_to_warp,2)],'YData',[1 size(image_to_warp,1)]);
    pixels_to_replace = ((warped_image_piece(:,:,1) > 0) & (warped_image_piece(:,:,2) > 0) & (warped_image_piece(:,:,3) > 0));
    pixels_to_replace2 = ((warped_image_piece(:,:,1) > 0) & (warped_image_piece(:,:,2) > 0) & (warped_image_piece(:,:,3) > 0));% & (warpedDepth - z > threshold));
    pixels_to_replace2 = cat(3,pixels_to_replace2,pixels_to_replace2,pixels_to_replace2);
    warped_image(pixels_to_replace2) = 0;
    warped_image = warped_image + warped_image_piece; %nicer, but can't handle oclussions
    warpedDepth(pixels_to_replace) = z;
end
    