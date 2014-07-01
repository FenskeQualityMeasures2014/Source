close all
% for visualization of filters

% filter_bank_rates = [1 .9 .8 .7 .6 .5 .4 .3 .2 .1];
% filterBank_LP = zeros(481,641,length(filter_bank_rates)-1);
% smoother = fspecial('gaussian', [100 100], 20);
% for i = 1:length(filter_bank_rates)-1
%     filter_image = zeros(481,641);
%     filter_image(ceil((1-filter_bank_rates(i+1))*240):ceil(filter_bank_rates(i+1)*240 + 240), ...
%         ceil((1-filter_bank_rates(i+1))*320):ceil(filter_bank_rates(i+1)*320 + 320)) = 1;
%     smoother = fspecial('gaussian', [round(1000*(filter_bank_rates(i)-filter_bank_rates(i+1))) ...
%         round(1000*(filter_bank_rates(i)-filter_bank_rates(i+1)))], 1000*(filter_bank_rates(i)-filter_bank_rates(i+1))/5);
%     filter_image = imfilter(filter_image, smoother);
%     figure;
%     imshow(filter_image);
%     %filter_bank(:,:,i) = filter_image;
%     
%     kernel = fftshift(ifft2(filter_image,'symmetric'));
%     
%     figure;
%     imshow(kernel,[]);
% end

%filter generation

filter_bank_rates = 1:-.01:.00;
filterBank_LP = zeros(25,25,length(filter_bank_rates)-1);
smoother = fspecial('gaussian', [100 100], 20);
for i = 1:length(filter_bank_rates)-1
    filter_image = zeros(481,641);
    filter_image(ceil((1-filter_bank_rates(i+1))*240):ceil(filter_bank_rates(i+1)*240 + 240), ...
        ceil((1-filter_bank_rates(i+1))*320):ceil(filter_bank_rates(i+1)*320 + 320)) = 1;
    smoother = fspecial('gaussian', [round(1000*(filter_bank_rates(i)-filter_bank_rates(i+1))) ...
        round(1000*(filter_bank_rates(i)-filter_bank_rates(i+1)))], 1000*(filter_bank_rates(i)-filter_bank_rates(i+1))/5);
    filter_image = imfilter(filter_image, smoother);
    %imshow(filter_image);
    kernel = fftshift(ifft2(fftshift(filter_image),'symmetric'));
    %imshow(kernel);
    %This would be nice is we can seperate this filter...TODO: check how
    %bad approximations are
%     f = kernel(309:333,229:253);
%     [U,S,V] = svd(f);
%     v = U(:,1)*sqrt(S(1,1));
%     h = V(:,1)'*sqrt(S(1,1));
%     filterBank(i,:) = v;
    window = fspecial('gaussian',[25 25], 2.5);
    window = window/window(13,13);
    windowed = window.*kernel(229:253,309:333);
    windowed = windowed/sum(windowed(:));
    filterBank_LP(:,:,101-i) = windowed;
    %imshow(filterBank_LP(:,:,101-i));
end

save filterBank_LP filterBank_LP;