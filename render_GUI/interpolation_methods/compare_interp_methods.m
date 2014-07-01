function compare_interp_methods()
close all;

cd('../lightfields');
Filename = uigetfile;
if (Filename == 0)
    return;
end
load(Filename);
cd('../interpolation_methods');
mkdir('results', Filename(1:end-4));

K = [0.01 0.03];
window = fspecial('gaussian', 11, 1.5);
L = 1;

% figure;
% imshow(novel_view);
% title('Ground Truth');
% print(gcf,'-djpeg',['results\' Filename(1:end-4) '\00GroundTruth.jpg']);

error1 = 0;
mssim1 = 0;
% image1 = nearest_neighbor(lightfield);
% error1 = sum(sum(sum((image1-novel_view).^2)));
% figure;
% imshow(image1);
% title('Nearest Neighbor');
% [mssim1, ssim_map] = SSIM(rgb2gray(novel_view),rgb2gray(image1),K,window,L);
% xlabel(['MSE: ' num2str(error1) ' SSIM: ' num2str(mssim1)]);
% print(gcf,'-djpeg',['results\' Filename(1:end-4) '\01NearestNeighbor.jpg']);

error2 = 0;
mssim2 = 0;
flowScore = 0;
% [image2, flowScore] = bilinear_interp(lightfield);
% error2 = sum(sum(sum((image2-novel_view).^2)));
% figure;
% imshow(image2);
% title('Bilinear Interpolation');
% [mssim2, ssim_map] = SSIM(rgb2gray(novel_view),rgb2gray(image2),K,window,L);
% xlabel(['MSE: ' num2str(error2) ' SSIM: ' num2str(mssim2) ' Flow Score: ' num2str(flowScore)]);
% print(gcf,'-djpeg',['results\' Filename(1:end-4) '\02BilinearInterp.jpg']);

error3 = 0;
mssim3 = 0;
% image3 = bicubic_interp(lightfield);
% error3 = sum(sum(sum((image3-novel_view).^2)));
% figure;
% imshow(image3);
% title('Bicubic Interpolation');
% [mssim3 ssim_map] = SSIM(rgb2gray(novel_view),rgb2gray(image3),K,window,L);
% xlabel(['MSE: ' num2str(error3) ' SSIM: ' num2str(mssim3)]);
% print(gcf,'-djpeg',['results\' Filename(1:end-4) '\03BicubicInterp.jpg']);

error4 = 0;
mssim4 = 0;
% image4 = upsample_by_2_2(lightfield,10);
% error4 = sum(sum(sum((image4-novel_view).^2)));
% figure;
% imshow(image4);
% title('Upsample by 2 Circular: Low-pass 10');
% [mssim4 ssim_map] = SSIM(rgb2gray(novel_view),rgb2gray(image4),K,window,L);
% xlabel(['MSE: ' num2str(error4) ' SSIM: ' num2str(mssim4)]);
% print(gcf,'-djpeg',['results\' Filename(1:end-4) '\04LowPass.jpg']);

error5 = 0;
mssim5 = 0;
% image5 = upsample_by_2_gaussian2(lightfield,20);
% error5 = sum(sum(sum((image5-novel_view).^2)));
% figure;
% imshow(image5);
% title('Upsample by 2: Gaussian 20');
% [mssim5 ssim_map] = SSIM(rgb2gray(novel_view),rgb2gray(image5),K,window,L);
% xlabel(['MSE: ' num2str(error5) ' SSIM: ' num2str(mssim5)]);
% print(gcf,'-djpeg',['results\' Filename(1:end-4) '\05Gaussian.jpg']);

pause(0.1);

error6 = 0;
mssim6 = 0;
[image6 flowScore6] = warp3dInterp(lightfield,depths,deltaU,focus_LF,zNearFar);
error6 = sum(sum(sum((image6-novel_view).^2)));
figure;
imshow(image6);
title('3D Warp');
[mssim6 ssim_map] = SSIM(rgb2gray(novel_view),rgb2gray(image6),K,window,L);
xlabel(['MSE: ' num2str(error6) ' SSIM: ' num2str(mssim6) ' Flow Score: ' num2str(flowScore6)]);
print(gcf,'-djpeg',['results\' Filename(1:end-4) '\06_3DInterpNear.jpg']);


error7 = 0;
mssim7 = 0;
[image7 flowScore7] = Lumigraph_warp(lightfield,zNearFar,focus_LF,focus,deltaU,depths);
error7 = sum(sum(sum((image7-novel_view).^2)));
figure;
imshow(image7);
title('Lumigraph with 3D warp depth');
[mssim7 ssim_map] = SSIM(rgb2gray(novel_view),rgb2gray(image7),K,window,L);
xlabel(['MSE: ' num2str(error7) ' SSIM: ' num2str(mssim7) ' Flow Score: ' num2str(flowScore7)]);
print(gcf,'-djpeg',['results\' Filename(1:end-4) '\07LumigraphConstZ.jpg']);

error8 = 0;
mssim8 = 0;
[image8 flowScore8] = Lumigraph_vector_occ(lightfield,zNearFar,focus_LF,focus,deltaU,novel_view_depth,depths);
error8 = sum(sum(sum((image8-novel_view).^2)));
figure;
imshow(image8);
title('Lumigraph occ');
[mssim8 ssim_map] = SSIM(rgb2gray(novel_view),rgb2gray(image8),K,window,L);
xlabel(['MSE: ' num2str(error8) ' SSIM: ' num2str(mssim8) ' Flow Score: ' num2str(flowScore8)]);
print(gcf,'-djpeg',['results\' Filename(1:end-4) '\08LumigraphVariableZNoFill.jpg']);


figure;%('units','normalized','position',[.1 .2 .8 .6])
bar([error1 error2 error3 error4 error5 error6 error7 error8]);
set(gca,'XTickLabel',{'Near','Bilinear','Bicubic','LP:10','Gauss','3D Warp','Lum','Lum occ'});
ylabel('MSE');
title(['Mean Squared Error of ' Filename]);
print(gcf,'-djpeg',['results\' Filename(1:end-4) '\09MSEError.jpg']);

figure;
bar([mssim1 mssim2 mssim3 mssim4 mssim5 mssim6 mssim7 mssim8]);
set(gca,'XTickLabel',{'Near','Bilinear','Bicubic','LP:10','Gauss','3D Warp','Lum', 'Lum occ'});
v = axis;
axis([v(1) v(2) v(3) 1]);
ylabel('SSIM');
title(['Structured Similarity Index of ' Filename]);
print(gcf,'-djpeg',['results\' Filename(1:end-4) '\10SSIMError.jpg']);

figure;
bar([flowScore flowScore6 flowScore7 flowScore8]);
set(gca,'XTickLabel',{'Bilinear','3D Warp','Lum', 'Lum occ'});
ylabel('FlowScore');
title(['Optical Flow Score of ' Filename]);
print(gcf,'-djpeg',['results\' Filename(1:end-4) '\11flowError.jpg']);
beep;