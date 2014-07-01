function image1 = bicubic_interp(lightfield)
%size 9 9 480 640 3
%want image at 6.5 6.5 on camera plane
%same focal plane, so no interp at that end
%reduces to bilinear interpolation
tic;
image1 =  1/256*lightfield(5,5,:,:,:) + -9/256*lightfield(5,6,:,:,:) + -9/256*lightfield(5,7,:,:,:) +  1/256*lightfield(5,8,:,:,:) + ...
         -9/256*lightfield(6,5,:,:,:) + 81/256*lightfield(6,6,:,:,:) + 81/256*lightfield(6,7,:,:,:) + -9/256*lightfield(6,8,:,:,:) + ...
         -9/256*lightfield(7,5,:,:,:) + 81/256*lightfield(7,6,:,:,:) + 81/256*lightfield(7,7,:,:,:) + -9/256*lightfield(7,8,:,:,:) + ...
          1/256*lightfield(8,5,:,:,:) + -9/256*lightfield(8,6,:,:,:) + -9/256*lightfield(8,7,:,:,:) +  1/256*lightfield(8,8,:,:,:);
image1 = squeeze(image1);
t = toc;
disp(['Bicubic Interp: ' num2str(t)]);