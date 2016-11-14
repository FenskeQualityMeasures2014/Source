%Light Field Resample
threeD = rand([2,3,4]);
newLF = zeros([18 18 380 380 4]);
for i=1:4
    threeD = double(LF(:,:,:,:,i));
    threeD = upsample(threeD,2);
    threeD = permute(threeD,[2 3 4 1]);
    threeD = upsample(threeD,2);
    threeD = permute(threeD,[4 1 2 3]);
%     threeD = upsample(threeD,2);
%     threeD = permute(threeD,[2 3 4 1]);
%     threeD = upsample(threeD,2);
%     threeD = permute(threeD,[2 3 4 1]);
    threeD = padarray(threeD, [13 13 0 0], 'post');
    threeD = filter(Hd, threeD, 1);
    threeD = filter(Hd, threeD, 2);
    %threeD = filter(Hd, threeD, 3);
    %threeD = filter(Hd, threeD, 4);
    newLF(:,:,:,:,i) = threeD(14:31,14:31,:,:);
end