%position vectors for pixels
%vectors as [x y z];
lensletPitch = .1;
cameraNormal = [0 -2 -1]; 
camera90 = [0 cameraNormal(3) cameraNormal(2)]; %[x z y]
camera90 = camera90/norm(camera90);
cameraPosition = [20 0 70 ];
st = zeros(380,380,3);
for i=1:380
    for j=1:380
        st(i,j,:) = [i*lensletPitch j*lensletPitch 0] + cameraPosition + j*lensletPitch*camera90;
    end
end

uv = zeros(9,9,3);
angles = (-2:0.5:2)/180*pi;
for i = 1:9
    for j = 1:9
        uv(i,j,:) = [1 0 0; 0 cos(angles(i)) -sin(angles(i)); 0 sin(angles(i)) cos(angles(i))]*[cos(angles(j)) 0 sin(angles(j)); 0 1 0; -sin(angles(j)) 0 cos(angles(j))]*cameraNormal';
    end
end

faces = gpuArray(OBJ.objects(1,3).data.vertices);
image = gpuArray.zeros(380,380);
uv = gpuArray(uv);
st = gpuArray(st);
vertices = gpuArray(OBJ.vertices);
%faces = sortrows(faces,3);%wrong sort
for i=1:380
    disp(i);
    parfor j=1:380
        disp(j);
        for k=1:size(faces,1);
            P1 = vertices(faces(k,1),:);
            P2 = vertices(faces(k,2),:);
            P3 = vertices(faces(k,3),:);
            normal = cross((P1-P2),(P1-P3))';
            t = ((P1-squeeze(st(i,j,:))')*normal)/(squeeze(uv(5,5,:))'*normal);
            if (t>0&&t~=Inf)
                P = squeeze(st(i,j,:))' + t*squeeze(uv(5,5,:))';
                v0 = P3-P1;
                v1 = P2-P1;
                v2 = P-P1;
                dot00 = v0*v0';
                dot01 = v0*v1';
                dot02 = v0*v2';
                dot11 = v1*v1';
                dot12 = v1*v2';
                denom = 1/(dot00*dot11 - dot01*dot01);
                u = (dot11*dot02 - dot01*dot12)*denom;
                v = (dot00*dot12 - dot01*dot02)*denom;
                if ~(u<0 || v<0 || u>1 || v>1 || u+v>1)
                    image(i,j) = acos(abs(normal'*squeeze(uv(5,5,:)))/norm(normal)/norm(squeeze(uv(5,5,:))));
                    break;
                end
            end
        end
    end
end
image = gather(image);