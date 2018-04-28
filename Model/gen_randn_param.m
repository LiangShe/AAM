function p = gen_randn_param( np, data)
% p = gen_randn_param( np, data)
% generate random parameters follow samples from data
% data: data samples (samples, dimensions)
% np: number of parameter vectors to generate
% assuming gaussion distributions, cut off to the largest/smallest real value 

ndim = size(data,2);
p = zeros(ndim, np);
for i = 1:ndim
    std_1dim = std(data(:,i));
    max_1dim = max(data(:,i));
    min_1dim = min(data(:,i));
    mean_1dim = mean(data(:,i));
    for j = 1:np
        r = randn * std_1dim + mean_1dim;
        while r >max_1dim || r <min_1dim
            r = randn * std_1dim + mean_1dim;
        end
        p(i,j) = r;
    end
end


end

