function [Fs, q, x, rowCount, colCount, sparseRowCount, rowVector, colVector, v] =  audioCompress(infilename, outfilename)
    debug = "reading file"
    [x, Fs] = audioread(infilename);
    n = 32;             % length of window
    nb = floor(length(x) / n - 1);           % number of windows, > 1
    rowCount = n;
    colCount = nb;
    b = 4; L = 5;       % Quantization information
    q = 2*L/(2^b - 1);  % b bits on the interval [-L, L]
    for i = 1:n
        for j = 1:2*n
            M(i, j) = cos((i-1 + 1/2) * (j-1 + 1/2 + n/2) * pi/n);
        end
    end
    M = sqrt(2/n) * M; 
    W = ones (n, nb);
    debug = "creating matrix"
    for k=1:nb          % loop over each window
        x0 = x(1+(k-1)*n : 2*n+(k-1)*n);
        y0 = M*x0;
        y1 = round(y0/q); % transform components quantized
        W(:, k) = y1;
    end
    y0'
    debug = "Writing file"
    V = sparse(W);
    
    fileId = fopen(outfilename, 'w');   % open the output file with write access
    fwrite(fileId, W, 'int16');         % write the matrix to the file    
    fclose(fileId);                     % close the output file
    
    [rowVector colVector v] = find(V);
    [sparseRowCount, ~] = size(rowVector); 
    fileId = fopen('sparsetest', 'w');   % open the output file with write access
    fwrite(fileId, [colVector rowVector v], 'int16');         % write the matrix to the file    
    fclose(fileId);                     % close the output file
    
    %dlmwrite('sparsetestDLM', [row, col, v], 'delimiter', '\t');
end
