function [image1 opticalFlowScore] = Lumigraph_warp(lightfield,zNearFar,focus_LF,focus,deltaU,depths)


CameraViewAngle = 75;
h_B = deltaU/2*tand(CameraViewAngle/2);
pix_shift = (480)*h_B/(focus_LF-h_B)*.88;
deltaS = tand(CameraViewAngle/2)*focus_LF/(480/2);
pix_shift = deltaU/2/deltaS;

tic;
warp1 = warp3dDepth(squeeze(depths(6,6,:,:)),[ pix_shift  pix_shift], focus_LF, zNearFar);
warp2 = warp3dDepth(squeeze(depths(6,7,:,:)),[ pix_shift -pix_shift], focus_LF, zNearFar);
warp3 = warp3dDepth(squeeze(depths(7,6,:,:)),[-pix_shift  pix_shift], focus_LF, zNearFar);
warp4 = warp3dDepth(squeeze(depths(7,7,:,:)),[-pix_shift -pix_shift], focus_LF, zNearFar);
m1 = warp1(:,:) > 0;
m2 = warp2(:,:) > 0;
m3 = warp3(:,:) > 0;
m4 = warp4(:,:) > 0;
novel_view_depth = (warp1(:,:) + warp2(:,:) + warp3(:,:) + warp4(:,:))./(m1 + m2 + m3 + m4);
novel_view_depth(~isfinite(novel_view_depth)) = zNearFar(2);
t = toc;
disp(['Lum warp overhead: ' num2str(t)]);

[image1 opticalFlowScore] = Lumigraph_vector_occ(lightfield,zNearFar,focus_LF,focus,deltaU,novel_view_depth,depths);
