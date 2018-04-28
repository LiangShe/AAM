
% addpath('.\Model')

model_data = '.\Data\Human_Face_Model.mat';
model = AAM_Model(model_data);

%% gen random faces
n_faces = 3;
output_res = [360 250];
params = model.gen_random_params(n_faces);
im = model.gen_image_param(params,output_res);

%%
for i = 1:n_faces
    figure;imshow(uint8(im(:,:,:,i)))
end

