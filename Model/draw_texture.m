function im = draw_texture( source_texture, source_mark, source_x, source_y, target_mark, target_x, target_y, facets )
%DRAW_TEXTURE
% example 


%% input check
if size(source_mark,2)~=2
    source_mark = reshape(source_mark,[],2);
end

if size(target_mark,2)~=2
    target_mark = reshape(target_mark,[],2);
end

if isinteger(source_texture)
    source_texture = single(source_texture);
end

[sx, sy] = xy2grid(source_x, source_y);
[tx, ty] = xy2grid(target_x, target_y);



%%
nch = size(source_texture,3);

[target_resy, target_resx] = size(tx);
im = nan(target_resy, target_resx, nch);

% locate points belong to each facets in target image
nf = size(facets,1);
pt_ind_facets = false(numel(tx), nf);
for i = 1:nf
    xv = target_mark(facets(i,:),1);
    yv = target_mark(facets(i,:),2);
    pt_ind_facets(:, i) = inpolygon(tx(:), ty(:), xv, yv);
end
% pt_ind_all = any(pt_ind_facets,2);

% compute affine transformation
aft = affine_transform_triangles(target_mark, source_mark, facets);

% piece-wise transform
for i = 1:nch
    im1 = nan(target_resy, target_resx);
    for k = 1:nf
        pt_ind = pt_ind_facets(:, k);
        xyt = [tx(pt_ind) ty(pt_ind) ones(sum(pt_ind),1)] * aft(:,:,k)';
        im1(pt_ind) = interp2(sx, sy, source_texture(:,:,i), xyt(:,1), xyt(:,2));
    end
    im(:,:,i) = im1;
end

ind = ~isnan(im);
im(~ind) = 128;

% adjust contrast
% im_max = max(im(ind(:)));
% im_min = min(im(ind(:)));
% im = (im - im_min)/(im_max-im_min) * 255;


end

function [x_grid, y_grid] = xy2grid(x, y)

if isscalar(x)
    [x_grid, y_grid] = meshgrid(1:x, 1:y);
    
elseif size(squeeze(x),2)==1
    % if source coordinate is one dimension
    [x_grid, y_grid] = meshgrid(x, y);
    
else
    x_grid = x;
    y_grid = y;
end

end
