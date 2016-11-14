%run matlabpool first
tic
alpha = 5;
resolutionRatio = .4;
E = zeros(round(900*resolutionRatio),round(1600*resolutionRatio),3);
for c = 1:3;
for i=1:1:round(900*resolutionRatio)
    disp([c i]);
    for j=1:round(1600*resolutionRatio)
        total = 0;
        for k=1:1:9
            m = round(k+((alpha/resolutionRatio*i)-k)/(alpha));
            m = min(m,900);
            m = max(1,m);
            for l=1:9
                n = round(l+((alpha/resolutionRatio*j)-l)/(alpha));
                %n2 = round(((alpha-1)*l)/alpha + (j/resolutionRatio));
                n = min(n,1600);
                n = max(1,n);
                total = total + double(l4d2LF(k,l,m,n,c));
            end
        end
        E(i,j,c) = total;
    end
end
end
E = E(1:1:end,1:1:end,:);
E = E/max(E(:));
%E = E/3000000; %Chosen to have same scale for all images
t = toc;
beep;
pause(1.5);
beep;
pause(.5);
beep;