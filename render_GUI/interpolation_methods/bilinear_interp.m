function [image1 flowScore] = bilinear_interp(lightfield)
%size 9 9 480 640 3
%want image at 6.5 6.5 on camera plane
%same focal plane, so no interp at that end
%reduces to bilinear interpolation
tic;
image1 = .25*lightfield(6,6,:,:,:) + .25*lightfield(6,7,:,:,:) + ...
         .25*lightfield(7,6,:,:,:) + .25*lightfield(7,7,:,:,:);
image1 = squeeze(image1);
t = toc;
disp(['Bilinear Interp: ' num2str(t)]);

%compute flow score
flowScore = calculateFlowScore(squeeze(lightfield(6,6,:,:,:)),...
                                 squeeze(lightfield(6,7,:,:,:)),...
                                 squeeze(lightfield(7,6,:,:,:)),...
                                 squeeze(lightfield(7,7,:,:,:)));