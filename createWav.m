function [Fs] = createWav ()
  n = 32;             % length of window
  nb = 127;           % number of windows, > 1
  b = 4; L = 5;       % Quantization information
  q = 2*L/(2^b - 1);  % b bits on the interval [-L, L]
  for i = 1:n
    for j = 1:2*n
      M(i, j) = cos((i-1 + 1/2) * (j-1 + 1/2 + n/2) * pi/n);
    end
  end
  M = sqrt(2/n) * M;
  N = M';             % Inverse MDCT
  Fs = 8172;            % Fs = sampling rate
  f = 7;   
  x = cos((1:4096)*pi*64*f/4096);   %test signal
  audiowrite('test.wav', x, Fs);  
end

