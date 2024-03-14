load('cart_u')
model=cart_pole;
xdim=model.dimx;

clear x_hat
load('cart_pole_trial_1.mat') %saved gp model
load('cart_x_true.mat')
x_hat(1,:)=model.x0;
for i=2:length(u)
    for j=1:xdim
        x_hat(i,j)=predict(gpmodel{j},[x_hat(i-1,:) u(i-1)]);      
    end
end
save('Aymen_cart_pole_x_hat_1.mat', 'x_hat');
immse(x_hat,x)
