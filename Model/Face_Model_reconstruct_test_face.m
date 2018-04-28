%% 1.compute params for test faces e. reconstruct

%% source faces path
data_path = '..\faces in movies';
% data_path = '..\familiar faces';

addpath('..\Model\')

%% load Model data
load ..\Model\Face_Model_Data.mat
ndim = length(FM.id_mark.eigenvalues) + length(FM.id_texture.eigenvalues);


%% define texture coordinate
% [x, y] = texture_template_coordinate;
x = FM.x_texture;
y = FM.y_texture;

%% load data
% load( fullfile(data_path, 'data_raw.mat'), 'im_data', 'marks_raw');
[ im_data, marks_raw ] = load_raw_data( data_path);

%% compute parameters in shape-apearance space

n_faces = length(im_data);
param = zeros(n_faces, ndim); 

for i = 1:n_faces
    
    fprintf('%d/%d\n', i, n_faces)
    
    % image and marks to params in PCA space
    marks = marks_raw(:,:,i);
    im = im_data{i};
    resy = size(im,1);
    resx = size(im,2);
    
    texture_template = draw_texture( im, marks, resx, resy, FM.id_mark.mean, x, y, FM.facets ); 
    
    marks_norm = mark_normalize(marks);
    p_id_mark = FM.id_mark.eig_vector' * (marks_norm(:) - FM.id_mark.mean');
    p_id_texture = FM.id_texture.eig_vector' * (texture_template(:) - FM.id_texture.mean');
    
    param(i,:) = [p_id_mark' p_id_texture']; 
    
   
end

% save params_faces_in_movies_120d.mat param


%% check reconstruction
% reconstruct faces
output_res = [250 250];
 im_syn = zeros([output_res, 3, n_faces]);

 for i =1:n_faces
     p_id_mark = param(i,1:20);
     p_id_texture = param(i,21:end);
     im_syn(:,:,:,i) = FM_gen_face( p_id_mark', p_id_texture', FM, output_res);
 end
 
 
 %% figure
figure('position', [100 100 1500 900]);
for i =1:n_faces
    subplot(5, 8, i*2-1)
    im_ori = im_data{i};
    imshow(im_ori)
    
    subplot(5, 8, i*2)
    imshow(uint8(im_syn(:,:,:,i)))
end

for i =1:n_faces
    figure('position', [100 100 800 500]);
    subplot(1, 2, 1)
    im_ori = im_data{i};
    imshow(im_ori)
    
    subplot(1, 2, 2)
    imshow(uint8(im_syn(:,:,:,i)))
end

% fig2pdf