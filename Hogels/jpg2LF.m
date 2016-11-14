%convert .jpg to LF
offset = 2; %pixels to pad the offset
l4d2LF = zeros(9,9,900,1600,3);
folder = 'C:\Program Files (x86)\Steam\SteamApps\common\Left 4 Dead 2\left4dead2\screenshots\JPEG\';
for i = 0:80
    disp(i)
    if (i<10)
        temp = imread([folder 'c10m1_caves000' num2str(i) '.jpg']);
    else
        temp = imread([folder 'c10m1_caves00' num2str(i) '.jpg']);
    end
    temp = padarray(temp,[offset*4 offset*4]);
    padL = offset*(mod(i,9)-4);   %if (padL<0) padL=0; end
    padR = offset*(4-mod(i,9));   %if (padR<0) padR=0; end
    padU = offset*(floor(i/9)-4); %if (padU<0) padU=0; end
    padD = offset*(4-floor(i/9)); %if (padD<0) padD=0; end
    l4d2LF(floor(i/9)+1,mod(i,9)+1,:,:,:) = temp(1+padU+(offset*4):900-padD+(offset*4),1+padL+(offset*4):1600-padR+(offset*4),:);
end
save l4d2LF l4d2LF -v7.3
beep