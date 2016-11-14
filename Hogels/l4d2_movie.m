%comment out alpha = x in paperRefocus2
%load l4d2LF
alpha_values = [.3 .4 .5 .65 .8 1 2 5 10 30];

for i = 1:length(alpha_values)
    alpha = alpha_values(i);
    paperRefocus2;
    M(i) = im2frame(E);
end
% figure;
% title('Alpha Values');
% movie(M,inf,1);
    