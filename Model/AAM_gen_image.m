function  [im, landmark]= AAM_gen_image( p_id_mark, p_id_texture, model, output_res )
% AAM_gen_image
%

% buffer size
resx = output_res(2)*model.image.upsampling; 
resy = output_res(1)*model.image.upsampling;


%% mark
nmark = length(p_id_mark);
neutral_mark = model.id_mark.mean' + model.id_mark.eig_vector(:,1:nmark) * p_id_mark;
neutral_mark = reshape(neutral_mark, [], 2);

% scale face width () to proportion of images
width_ind = model.mark_group.width;
width = resx*model.image.width_factor...
    /(neutral_mark(width_ind(2),1) - neutral_mark(width_ind(1),1)); 

dy = model.image.y_offset_factor * resx;

neutral_mark(:,1) = neutral_mark(:,1) * width + resx/2;
neutral_mark(:,2) = neutral_mark(:,2) * width + resy/2 + dy;

%% texture
ntexture = length(p_id_texture);
[resy_texture, resx_texture] = size(model.x_texture);
neutral_texture = model.id_texture.mean' + model.id_texture.eig_vector(:,1:ntexture) * p_id_texture ;
neutral_texture = reshape(neutral_texture, resy_texture, resx_texture, 3);

im = draw_texture( neutral_texture, model.id_mark.mean, model.x_texture, model.y_texture, neutral_mark, resx, resy, model.facets );

%% smooth edge
if model.image.smooth_edge
    sigma = model.image.smooth_factor*resx;
    edge = neutral_mark(model.mark_group.rim,:);
    im = im_mask_smooth_edge(im, edge, sigma);
end

%%
if model.image.upsampling>1
    im = imresize(im, output_res);
end

landmark = neutral_mark;
end

