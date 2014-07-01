
filterBank_spec = zeros(25,25,100);
for i = 1:100
    vect = [1:13 12:-1:1];
    vect = (vect-13) + (200/i);
    vect(vect<0) = 0;
    f = vect'*vect;
    f = f/sum(f(:));
%     if (length(vect)<25)
%         filter_spec = padarray(f,[13-i 13-i]);
%     elseif (length(vect)==25)
%         filter_spec = f;
%     else
%         filter_spec = f(i-12:i+12,i-12:i+12)
%     end
    filterBank_spec(:,:,i) = f;
end

save filterBank_spec filterBank_spec;