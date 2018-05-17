function [out] =  audioDecompress(filename, sparseRowCount, rowCount, colCount, q, Fs)
    %A = dlmread(filename);  % read the compressed file into a matrix, A
    %[n, nb] = size(A);      % use the dimensions of the matrix to determine n and nb
    % Raw will be the [row col value] matrix of a sparse matrix
    fileId = fopen(filename, 'r');
    Raw = fread(fileId, [sparseRowCount, 3], 'int16');
    fclose(fileId);
    n = rowCount;
    nb = colCount;
    A = zeros(n, nb);
    debug = "Max Raw row val"
    debug = max(Raw(:, 1))
    for foo = 1:sparseRowCount
        rowNdx = Raw(foo, 1);
        colNdx = Raw(foo, 2);
        value = Raw(foo, 3);
        A(rowNdx, colNdx) = value;
    end
    debug = "Size of A:"
    size(A)
    M = ones(n, 2*n);       % initialize our DCT matrix
    for i = 1:n             % Construct our DCT matrix
        for j = 1:2*n
            M(i, j) = cos((i-1 + 1/2) * (j-1 + 1/2 + n/2) * pi/n);
        end
    end
    N = M';                 % since M is orthogonal, its inverse is its transpose
    size(N)
    out = [];
    y1 = A(:, 1);       
    debug = "Size of y1:"
    size(y1)
    for k=1:nb              % loop over each window
        y1 = A(:, k);       % grab the kth column of A
        y2 = y1*q;          % dequantize it
        w(:, k) = N*y2;     % invert the MDCT
        if (k>1)            % if we're not on the first step
            w2 = w(n+1:2*n, k-1);
            w3 = w(1:n, k);
            out = [out; (w2 + w3) /2];  % collect the reconstructed signal
        end
    end
    debug = "Playing decomp"
    sound(out, Fs);  
end
