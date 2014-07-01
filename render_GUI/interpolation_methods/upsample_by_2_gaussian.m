function image1 = upsample_by_2_gaussian(lightfield, filter_len)

%filter_len = 20;
h = fspecial('gaussian', [1 filter_len+1], 1.1);
b = h;
a = [1 zeros(1,filter_len)];
lightfield = double(lightfield);
lightfield = upsample(lightfield,2);
lightfield = padarray(lightfield, [round(filter_len/2) 0 0 0], 'post');
lightfield = filter(b, a, lightfield, [], 1);
lightfield = lightfield(round(filter_len/2):end,:,:,:,:);
    
lightfield = permute(lightfield,[2 3 4 1 5]);    
lightfield = upsample(lightfield,2);
lightfield = permute(lightfield,[4 1 2 3 5]);
lightfield = padarray(lightfield, [0 round(filter_len/2) 0 0], 'post');
    
for j = 1:size(lightfield,5)
    lightfield(:,:,:,:,j) = filter(b, a, lightfield(:,:,:,:,j), [], 2);
end
lightfield = lightfield(:,round(filter_len/2):end,:,:,:);
image1 = squeeze(lightfield(13,13,:,:,:));
image1 = image1*4;