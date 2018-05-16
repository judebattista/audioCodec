function [out, Fs] =  fileCompressor(filename, FS, a, b)
%just a quick mockup of a file compression system. Testing primarily to 
%see whether resulting wav file is actually smaller when decompressed.
%note: the 'out' vector actually creates a larger file than the original,
%even with less time recorded, irregardless of choice of b.
  [x, Fs] = audioread(filename, [a*FS, b*FS]);
  n = 32;             % length of window
  nb = length(x) / n - 1;           % number of windows, > 1
  b = 24; L = 5;       % Quantization information
  q = 2*L/(2^b - 1);  % b bits on the interval [-L, L]
  for i = 1:n
    for j = 1:2*n
      M(i, j) = cos((i-1 + 1/2) * (j-1 + 1/2 + n/2) * pi/n);
    end
  end
  M = sqrt(2/n) * M;
  N = M';             % Inverse MDCT
  %Fs = 8172;            % Fs = sampling rate
  f = 8;   
  %x = cos((1:4096)*pi*64*f/4096);   %test signal
  sound(x, Fs);       % Matlab's sound command_line_path
  out = [];
  for k=1:nb          % loop over each window
    x0 = x(1+(k-1)*n : 2*n+(k-1)*n);
    y0 = M*x0;
    y1 = round(y0/q); % transform components quantized
    y2 = y1*q;        % and dequantized
    w(:, k) = N*y2;   % invert the MDCT
    if (k>1)          % if we're not on the first step
      w2 = w(n+1:2*n, k-1);
      w3 = w(1:n, k);
      out = [out; (w2 + w3) /2];  %collect the reconstructed signal
    end
  end
pause((b-a) + 1);
debug = "Playing decomp"
sound(out, Fs);  
audiowrite('testCompress.wav', out, Fs); 
end
