function prefilterLF()

cd('../lightfields');
Filename = uigetfile;
if (Filename == 0)
    return;
end
load(Filename);
cd('../prefiltering');

deltaS = tand(75/2)*focus_LF/(480/2);
h_d = 1/(deltaU/(2*deltaS)*focus_LF);
z_c = 2/(1/zNearFar(1) + 1/zNearFar(2));
zNearFar2(1) = 1/(1/z_c + h_d/2);
zNearFar2(2) = 1/(1/z_c - h_d/2);

filter_ratio = depths.*(zNearFar2(2) - zNearFar2(1))./(2*zNearFar2(1)*zNearFar2(2) - depths.*(zNearFar2(1) + zNearFar2(2)));
filter_ratio = sign(filter_ratio).*min(1,abs(filter_ratio));
figure;
imshow(squeeze(filter_ratio(4,4,:,:)),[]);

filter_bank_rates = [1 .9 .8 .7 .6 .5 .4 .3 .2 .16 .08 .04 .02 .01 .001];
filter_bank = zeros(480,640,length(filter_bank_rates)-1);
smoother = fspecial('gaussian', [100 100], 20);
for i = 1:length(filter_bank_rates)-1
    filter_image = zeros(480,640);
    filter_image(ceil((1-filter_bank_rates(i+1))*240):ceil(filter_bank_rates(i+1)*240 + 240), ...
        ceil((1-filter_bank_rates(i+1))*320):ceil(filter_bank_rates(i+1)*320 + 320)) = 1;
    smoother = fspecial('gaussian', [round(1000*(filter_bank_rates(i)-filter_bank_rates(i+1))) ...
        round(1000*(filter_bank_rates(i)-filter_bank_rates(i+1)))], 1000*(filter_bank_rates(i)-filter_bank_rates(i+1))/5);
    filter_image = imfilter(filter_image, smoother);
    filter_bank(:,:,i) = filter_image;
end

image1_rgb = zeros(480,640,3);
filtered_LF = zeros(9,9,480,640,3);

for i = 1:9
    for j = 1:9
        view2filter = squeeze(lightfield(i,j,:,:,:));
        depths2filter = squeeze(filter_ratio(i,j,:,:));
        mask = (depths2filter>=filter_bank_rates(1)) | (depths2filter<filter_bank_rates(end));
        for rgb = 1:3
            filtered_LF(i,j,:,:,rgb) = shiftdim(view2filter(:,:,rgb).*mask,-2);
        end
        for k = 1:length(filter_bank_rates)-1
            mask = (depths2filter<filter_bank_rates(k)) & (depths2filter>filter_bank_rates(k+1));
            for rgb = 1:3
                image1 = view2filter(:,:,rgb).*mask;
                image1_fft = fftshift(fft2(image1));
                image1_fft_filtered = image1_fft.*filter_bank(:,:,k);
                image1_filtered = ifft2(fftshift(image1_fft_filtered),'symmetric');
                image1_rgb(:,:,rgb) = image1_filtered;
            end
            filtered_LF(i,j,:,:,:) = filtered_LF(i,j,:,:,:) + (shiftdim(image1_rgb,-2));
        end
    end
end