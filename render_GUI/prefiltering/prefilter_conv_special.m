

cd('../lightfields');
Filename = uigetfile;
if (Filename == 0)
    return;
end
load(Filename);
cd('../prefiltering');

load filterBank_spec;

deltaS = tand(75/2)*focus_LF/(480);
h_d = 1/(deltaU/(2*deltaS)*focus_LF);
z_c = 2/(1/zNearFar(1) + 1/zNearFar(2));
z_c = focus_LF
zNearFar2(1) = 1/(1/z_c + h_d/2);
zNearFar2(2) = 1/(1/z_c - h_d/2);

filter_ratio = depths.*(zNearFar2(2) - zNearFar2(1))./(2*zNearFar2(1)*zNearFar2(2) - depths.*(zNearFar2(1) + zNearFar2(2)));
filter_ratio = min(1,abs(filter_ratio));
novel_filter_ratio = novel_view_depth.*(zNearFar2(2) - zNearFar2(1))./(2*zNearFar2(1)*zNearFar2(2) - novel_view_depth.*(zNearFar2(1) + zNearFar2(2)));
novel_filter_ratio = min(1,abs(novel_filter_ratio));
figure;
imshow(squeeze(filter_ratio(7,7,:,:)),[]);

filtered_LF = zeros(9,9,480,640,3);
image2filter = zeros(480+24,640+24);

tic;
for i = 1:9
    for j = 1:9
        disp([i j]);
        for rgb = 1:3
            image2filter(:,:) = padarray(squeeze(lightfield(i,j,:,:,rgb)),[12 12]);
            for ii = 1:480
                for jj = 1:640
                    pixel_depth = filter_ratio(i,j,ii,jj);
                    if (pixel_depth > 0 && pixel_depth < 1)
                        filter_bank_index = max(1,min(100,round(100*pixel_depth)));
                        filtered_LF(i,j,ii,jj,rgb) = sum(sum(image2filter(ii:ii+24,jj:jj+24).*filterBank_spec(:,:,filter_bank_index)));
                    else
                        filtered_LF(i,j,ii,jj,rgb) = image2filter(ii+12,jj+12);
                    end
                end
            end
        end
    end
end
t = toc;
filtered_novel = zeros(480,640,3);

for rgb = 1:3
            image2filter(:,:) = padarray(squeeze(novel_view(:,:,rgb)),[12 12]);
            for ii = 1:480
                for jj = 1:640
                    pixel_depth = novel_filter_ratio(ii,jj);
                    if (pixel_depth > 0 && pixel_depth < 1)
                        filter_bank_index = max(1,min(100,round(100*pixel_depth)));
                        filtered_novel(ii,jj,rgb) = sum(sum(image2filter(ii:ii+24,jj:jj+24).*filterBank_spec(:,:,filter_bank_index)));
                    else
                        filtered_novel(ii,jj,rgb) = image2filter(ii+12,jj+12);
                    end
                end
            end
end

imshow(squeeze(filtered_LF(4,4,:,:,:)));

Filename = [Filename(1:end-4) '_filtered_special.mat'];
original_LF = lightfield;
original_novel = novel_view;
lightfield = filtered_LF;
novel_view = filtered_novel;
save(['..\lightfields\' Filename],'lightfield','depths','novel_view','deltaU','focus','zNearFar','focus_LF','novel_view_depth','original_LF','original_novel');
beep;                    