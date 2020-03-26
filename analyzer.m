clear; clf;
N = 1024;
win = window('hamming', N);
Pscale = 1;
Fscale = 2;
zero_padding = 2;
[name, path]=uigetfile('/home/milosz/Downloads/muse_uprising.mp3');
[x,Fs]=audioread([path name]);
if ~isvector(x)
    x=x(:,1);    
end

% x=x(1:end/16);
x=x(Fs*10:Fs*20);
% x=x-mean(x);
x_orig = x;
Nwin=floor(numel(x)/N)-1;

F_axis=(0:1/(zero_padding*N):1-1/(zero_padding*N))*Fs;

Pmedium=0;
for i=1:length(x)    
   Pmedium=Pmedium+(abs(x(i)))^2;
end
Pmax = Pscale*Pmedium/Nwin;
% Pmax=max(abs(x));

graphics = zeros(zero_padding*N/Fscale, Nwin);
graphics_maximums = zeros(1, Nwin);

%% loudnes filter
A_Butterworth = [1.0000 -1.9698 0.9702]
B_Butterworth = [0.9850 -1.9700 0.9850];
A_YuleWalkk = [1.0000 -3.4785 6.3632 -8.5475 9.4769 -8.8150 6.8540 -4.3947 2.1961 -0.7510 0.1315];
B_YuleWalkk = [0.0542 -0.0291 -0.0085 -0.0085 -0.0083 0.0225 -0.0260 0.0162 -0.0024 0.0067 -0.0019];
B_highpass = [1 -2 1];
A = conv(A_Butterworth, A_YuleWalkk)
B = conv(B_Butterworth, B_YuleWalkk);
B = conv(B, B_highpass)
filter(B, A, [1 2 3 4])
x = filter(B, A, x);
%%
for i = 1:Nwin
	y=x(N*i+1:(i+1)*N).*win;
    f=fft(y, zero_padding*N);
    PSD=(1/N)*(abs(f)).^2;
%     graphics(1:zero_padding*N/Fscale, i)=PSD(1:zero_padding*N/Fscale);
    
    PSD(1) = 0;
    cestrum = ifft(PSD);
    if cestrum(1) ~= 0
        cestrum = cestrum/cestrum(1);
    end
%     cestrum(1:30) = zeros(1, 30);
    
    graphics(1:zero_padding*N/Fscale, i)=cestrum(1:zero_padding*N/Fscale);
    k = find(cestrum(1:zero_padding*N/Fscale)<0, 1);
    if isempty(k)
        graphics_maximums(i) = zero_padding*N/Fscale;
    else
        [maximum, max_index] = max(cestrum(k:end/2));
        if max_index+k > zero_padding*N/Fscale
            graphics_maximums(i) = zero_padding*N/Fscale;
        else
            graphics_maximums(i) = max_index+k;
        end
    end

end
surface(graphics(:, :), 'edgecolor', 'none');
colorbar;
hold on;
l = 5
graphics_maximums = filter(ones(1 ,l)/l, [1], graphics_maximums);
graphics_maximums = graphics_maximums(1:end);
plot(graphics_maximums, '*', 'color', 'red');

p=audioplayer(x_orig,Fs);
play(p);

y = 1:zero_padding*N/Fscale;
x = ones(1, numel(y))*1;
z = ones(1, numel(y))*1000000;
h = animatedline(x, y, z, 'linewidth', 3, 'color', 'red');
while p.isplaying
    current_sample = p.CurrentSample;
    current_window = floor(p.CurrentSample/N);
    clearpoints(h);
    x = ones(1, numel(y))*current_window;
    h = animatedline(x, y, z, 'linewidth', 3, 'color', 'red');
    pause(0.1);
end



