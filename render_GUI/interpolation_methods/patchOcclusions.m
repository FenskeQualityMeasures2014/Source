function patchedImage = patchOcclusions(image, depth, mask)

threshold = .1;

while (max(mask(:))==1)
    center = find(mask);
    center = max(2,min(640*480-1,center));
    north = center - 1;
    south = center + 1;
    west = max(2,center - 480);
    east = min(480*640-1,center + 480);
    northwest = west - 1;
    southwest = west + 1;
    northeast = east - 1;
    southeast = east + 1;
    neighbors = cat(2, north, south, east, west, northeast, northwest, southeast, southwest);
    edge_pix = (mask(north) == 0) | (mask(south) == 0) | (mask(east) == 0) | (mask(west) == 0) |...
        (mask(northeast) == 0) | (mask(northwest) == 0) | (mask(southeast) == 0) | (mask(southwest) == 0);
    zcenter = depth(center);
    znorth = abs(depth(north) - zcenter) .* (mask(north) == 0);
    zsouth = abs(depth(south) - zcenter) .* (mask(south) == 0);
    zeast = abs(depth(east) - zcenter) .* (mask(east) == 0);
    zwest = abs(depth(west) - zcenter) .* (mask(west) == 0);
    znortheast = abs(depth(northeast) - zcenter) .* (mask(northeast) == 0);
    znorthwest = abs(depth(northwest) - zcenter) .* (mask(northwest) == 0);
    zsoutheast = abs(depth(southeast) - zcenter) .* (mask(southeast) == 0);
    zsouthwest = abs(depth(southwest) - zcenter) .* (mask(southwest) == 0);
    zneighbors = cat(2, znorth, zsouth, zeast, zwest, znortheast, znorthwest, zsoutheast, zsouthwest);
    zneighbors(zneighbors == 0) = max(depth(:));
    [zclose, zcloseind] = min(zneighbors, [], 2);
    pix_to_fill = edge_pix & (zclose < threshold);
    ind_to_fill = neighbors(find(pix_to_fill)+(zcloseind(pix_to_fill)-1)*size(pix_to_fill,1));
    for rgb = 0:1:2
        image(center(pix_to_fill) + rgb*480*640) = image(ind_to_fill + rgb*480*640);
    end
    oldmask = mask;
    mask(center(pix_to_fill)) = 0;
    if (mask == oldmask), mask(:) = 0; end
end

patchedImage = image;
    