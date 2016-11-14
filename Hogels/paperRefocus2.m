
tic
%alpha = 30;
resolutionRatio = 1;
alpha_max = 1;
alpha_min = -inf;
%m_min = 9*(alpha-1)/alpha; %this is -21 when alpha  = .3
m_min = 21;
%m_max = 9*alpha_max; %this is 9 max
m_max = 9;
%padding = m_min+m_max;
padding = 30;
E = zeros(round(900*resolutionRatio)+padding,round(1600*resolutionRatio)+padding,3);
for c = 1:3;
    for k = 1:9
        disp([c k]);
        for l = 1:9
            m = round(k*(alpha-1)/alpha);
            n = round(l*(alpha-1)/alpha);
            E((1+m_min+m):(900+m_min+m),(1+m_min+n):(1600+m_min+n),:) = ...
            E((1+m_min+m):(900+m_min+m),(1+m_min+n):(1600+m_min+n),:) + squeeze(l4d2LF(k,l,:,:,:));
        end
    end
end
E = E(m_min+1:end-m_max,m_min+1:end-m_max,:);
E = E/max(E(:));
t = toc;
beep;
pause(1.5);
beep;
pause(.5);
beep;