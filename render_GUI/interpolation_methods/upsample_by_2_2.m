function image1 = upsample_by_2_2(lightfield, filter_len)

filter_len = 10;
b = fir1(filter_len,.5);
h = ftrans2(b);
h = h(1:2:11,1:2:11);
tic; %start here, assume filter is predefined
image1 = zeros(480,640,3);
for i = 1:6
    for j = 1:6
        image1 = image1 + 4*squeeze(h(i,j)*lightfield(3+i,3+j,:,:,:));
    end
end
t = toc;
disp(['Low Pass: ' num2str(t)]);