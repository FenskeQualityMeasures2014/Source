function [image1 flowScore] = warp3dInterp(lightfield,depths,deltaU,focus,zNearFar)

pix_shift = deltaU/2; %Why is this needed? Why not div by 2?
CameraViewAngle = 75;
h_B = deltaU/2*tand(CameraViewAngle/2);
pix_shift = (480)*h_B/(focus-h_B)*.74;
deltaS = tand(CameraViewAngle/2)*focus/(480/2);
pix_shift = deltaU/2/deltaS;
%pad_offset = 480*deltaU/(2*focus*tand(CameraViewAngle/2));
%pix_shift = pix_shift - pad_offset/8; %why is this better? have to correct for offset?
tic;
warp1 = warp3dImage(squeeze(lightfield(6,6,:,:,:)),squeeze(depths(6,6,:,:)),[ pix_shift  pix_shift], focus, zNearFar);
warp2 = warp3dImage(squeeze(lightfield(6,7,:,:,:)),squeeze(depths(6,7,:,:)),[ pix_shift -pix_shift], focus, zNearFar);
warp3 = warp3dImage(squeeze(lightfield(7,6,:,:,:)),squeeze(depths(7,6,:,:)),[-pix_shift  pix_shift], focus, zNearFar);
warp4 = warp3dImage(squeeze(lightfield(7,7,:,:,:)),squeeze(depths(7,7,:,:)),[-pix_shift -pix_shift], focus, zNearFar);
m1 = warp1(:,:,1) > 0 & warp1(:,:,2) > 0 & warp1(:,:,3) > 0;
m2 = warp2(:,:,1) > 0 & warp2(:,:,2) > 0 & warp2(:,:,3) > 0;
m3 = warp3(:,:,1) > 0 & warp3(:,:,2) > 0 & warp3(:,:,3) > 0;
m4 = warp4(:,:,1) > 0 & warp4(:,:,2) > 0 & warp4(:,:,3) > 0;
for rgb = 1:3
image1(:,:,rgb) = (warp1(:,:,rgb) + warp2(:,:,rgb) + warp3(:,:,rgb) + warp4(:,:,rgb))./(m1 + m2 + m3 + m4);
end
image1(~isfinite(image1)) = 0;
t1 = toc;
disp(['3D warp: ' num2str(t1)]);
% image1 = max(cat(4, warp1, warp2, warp3, warp4),[],4); %May also try max
m_flow = m1 & m2 & m3 & m4;
m_flow = cat(3, m_flow, m_flow, m_flow);
flowScore = calculateFlowScore(warp1.*m_flow,warp2.*m_flow,warp3.*m_flow,warp4.*m_flow);
%flowScore = 0;
