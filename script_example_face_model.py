
from Model.AAM_Model import AAM_Model
import numpy as np
import time
import concurrent.futures

#%%
model_data = './Data/Face_Model_data.mat'
model = AAM_Model(model_data)

#%% gen random faces
n_faces = 4
output_res = [360, 250]
params = model.gen_random_params(n_faces)

#%%
start_time = time.time()
im = model.gen_image_param(params, output_res)
t = time.time() - start_time
print(f'--- {t} seconds ---' )

#%%
workers = 4
start_time = time.time()
n = params.shape[0]
params_n = [params[np.newaxis,i,:] for i in range(n)]
output_res_n = [output_res]*n
with concurrent.futures.ThreadPoolExecutor(max_workers = workers) as executor:
    im2 = np.concatenate(list(executor.map(model.gen_image_param, params_n, output_res_n)), axis=3)

t = time.time() - start_time
print(f'--- {t} seconds ---' )

#%%
print((im-im2).sum())

#%%
import matplotlib.pyplot as plt
im[im>255] = 255
im[im<0] = 0
for i in range(n_faces):
    plt.figure()
    plt.imshow(im[:,:,:,i]/255)
