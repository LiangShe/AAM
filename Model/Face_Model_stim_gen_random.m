%% FM stim gen 2000 faces

%% create path
output_path = '.\stim\';
create_dir(output_path)


%% load data
load Face_Model_Data.mat

nmark = size(FM.id_mark.eig_vector,1) / 2;
nres = sqrt(size(FM.id_texture.eig_vector,1));


return

%% generate random identity params

% n_id = 2000;
% mat_name = 'params_2k_120d.mat';

% generate random identity params for unfamiliar faces
% n_id = 10000;
% mat_name = 'params_unfamiliar_120d.mat';

p_id_mark = gen_randn_param( n_id, FM.id_mark.score);
p_id_texture = gen_randn_param( n_id, FM.id_texture.score);

params = [p_id_mark' p_id_texture'];
% save(fullfile(output_path, mat_name), 'params' );

return
%%  gen faces
% name_str = '2k';
% output_path = '.\stim\2000';
% mat_name = '.\stim\params_2k_120d.mat';

% name_str = 'unfamiliar';
% output_path = '.\stim\unfamiliar';
% mat_name = '.\stim\params_unfamiliar_120d.mat';

output_res = [300 300];
create_dir(output_path)
load(mat_name);

n_faces = size(params,1);

for i = 1:n_faces
    
    fprintf('%d/%d\n',i,n_faces);
    
    p_id_mark = params(i,1:20)';
    p_id_texture = params(i,21:end)';
    
    im_syn = FM_gen_face( p_id_mark, p_id_texture, FM, output_res);
    % figure; image(uint8(im_syn))
    
    % write files
    filename = sprintf('syn_120d_%s_%05d.tif', name_str, i);
    imwrite(uint8(im_syn), fullfile(output_path,filename));
    
end



