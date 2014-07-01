function image1 = nearest_neighbor(lightfield)
%lightfield size is 9 9 480 640 3
%desired viewpoint is at 6.5 6.5 on camera viewplane
%just take viewpoint at 7 7 on camera viewplane in this case
tic;
image1 = squeeze(lightfield(7,7,:,:,:));
t = toc;
disp(['Nearest neighbor: ' num2str(t)]);