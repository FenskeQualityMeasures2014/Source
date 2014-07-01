close all
% for visualization of filters
for i = 1:10
normalized_cutoff = i/10;
fudge_factor = 5;
sigma_f = normalized_cutoff/fudge_factor;
sigma_t = 1/(2*pi*sigma_f);
f = fspecial('gaussian', [481 641], sigma_t);
freq_response = fftshift(fft2(f));
figure;
imshow(abs(freq_response));
%imshow(f,[]); %or look at kernel
xlabel(num2str(i/10));
disp(abs(freq_response(round(i/10*240+241), 321)));
end

num_filters = 100;
filterBank = zeros(num_filters,25);
for i = 1:100
normalized_cutoff = i/100;
sigma_f = normalized_cutoff/fudge_factor;
sigma_t = 1/(2*pi*sigma_f);
f = fspecial('gaussian', [25 25], sigma_t);
[U,S,V] = svd(f);
v = U(:,1)*sqrt(S(1,1));
h = V(:,1)'*sqrt(S(1,1));
filterBank(i,:) = v;
end
save filterBank filterBank;