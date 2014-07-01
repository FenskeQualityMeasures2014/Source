function image1 = upsample_by_2_gaussian2(lightfield, filter_len)

filter_len = 10;
h = fspecial('gaussian', [filter_len+1 filter_len+1], 1.1);
h = h(1:2:11,1:2:11);
tic;
image1 = zeros(480,640,3);
for i = 1:6
    for j = 1:6
        image1 = image1 + 4*squeeze(h(i,j)*lightfield(3+i,3+j,:,:,:));
    end
end
t = toc;
disp(['Gaussian: ' num2str(t)]);