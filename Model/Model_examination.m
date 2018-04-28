function Model_examination(data, output_path, output_res)
%% model examinztion

is_visualize_PC = 0;

if nargin<2
    output_path = '.\PCs_visualization';
end
create_dir(output_path);

if nargin<3
    output_res = [250 250];
end

npc_id_mark = length(data.id_mark.eigenvalues);
npc_id_texture = length(data.id_texture.eigenvalues);

%% p_mark distribution
figure; 
for i = 1:npc_id_mark
    subplot(4,5,i)
    hist(data.id_mark.score(:,i),50)
    title( sprintf('PC%d', i) )
end

figure;
plot(data.id_mark.score(:,1),data.id_mark.score(:,2),'.')
xlabel('PC1');
ylabel('PC2')


%% p_texture distribution
% npc_id_texture
figure; 
for i = 1:50
    subplot(5,10,i)
    hist(data.id_texture.score(:,i),50)
    title( sprintf('PC%d', i) )
end

figure;
plot(data.id_texture.score(:,1),data.id_texture.score(:,2),'.')
xlabel('PC1');
ylabel('PC2')

figure;
plot(data.id_texture.score(:,3),data.id_texture.score(:,4),'.')
xlabel('PC3');
ylabel('PC4')



%% visualize PCs of id mark

if ~is_visualize_PC
    return
end

p_id_texture = zeros(npc_id_texture,1);

n = 20; % sampling points
for i = 1:20
    p_id_mark = zeros(npc_id_mark,1);
    p_max = max(data.id_mark.score(:,i)) ;
    p_min = min(data.id_mark.score(:,i)) ;
    p = p_min:(p_max-p_min)/(n-1):p_max;
    im = zeros([output_res, 3, n]);
    for k = 1:n
        p_id_mark(i) = p(k);
        im(:,:,:,k) = AAM_gen_image( p_id_mark, p_id_texture, data, output_res);
    end
    
    stim_name = ['ID_shape_PC' num2str(i,'%02d')];
    
    frame_rate = 10;
    mat2gif( fullfile(output_path, [stim_name '.gif']), uint8(im), Inf, 1/frame_rate )
    
end

%% visualize PCs of id texture
t = 1;
p_id_mark = zeros(npc_id_mark,1);

n = 20; % sampling points
for i = 1:20
    p_id_texture = zeros(npc_id_texture,1);
    p_max = max(data.id_texture.score(:,i));
    p_min = min(data.id_texture.score(:,i));
    p = p_min:(p_max-p_min)/(n-1):p_max;
    im = zeros([output_res, 3, n]);
    for k = 1:n
        p_id_texture(i) = p(k);
        im(:,:,:,k) = AAM_gen_image( p_id_mark, p_id_texture, data, output_res);
    end
    
    stim_name = ['ID_appear_PC' num2str(i,'%02d')];
    frame_rate = 10;
    mat2gif( fullfile(output_path, [stim_name '.gif']), uint8(im), Inf, 1/frame_rate )
    
end
