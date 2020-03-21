clear; clf;
N = 1024;
win = window('hamming', N);
Pscale = 1;
Fscale = 32;
zero_padding = 2;
[name, path]=uigetfile('/home/milosz/Downloads/muse_uprising.mp3');
[x,Fs]=audioread([path name]);
if ~isvector(x)
    x=x(:,1);    
end

% x=x(1:end/16);
x=x(1:Fs*20);
% x=x-mean(x);

Nwin=floor(numel(x)/N)-1;

F_axis=(0:1/(zero_padding*N):1-1/(zero_padding*N))*Fs;

Pmedium=0;
for i=1:length(x)    
   Pmedium=Pmedium+(abs(x(i)))^2;
end
Pmax = Pscale*Pmedium/Nwin;
% Pmax=max(abs(x));
% for i = 1:Nwin
k=Nwin;
graphics = zeros(zero_padding*N/Fscale, k);
for i = 1:k
	y=x(N*i+1:(i+1)*N).*win;
    f=fft(y, zero_padding*N);
    PSD=(1/N)*(abs(f)).^2;
    graphics(1:zero_padding*N/Fscale, i)=PSD(1:zero_padding*N/Fscale);
    
%     PSD(1:30) = zeros(1, 30);
%     cestrum = abs(fft(PSD));
%     cestrum = cestrum/cestrum(1);
%     graphics(1:zero_padding*N/Fscale, i)=cestrum(1:zero_padding*N/Fscale);
end
surface(graphics(:, :), 'edgecolor', 'none')

p=audioplayer(x,Fs);
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



