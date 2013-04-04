function y = kij_3( x,i,j )
%   kij computes k(x^i,x^j), in this case <x^i,x^j>
%   x: input matrix
%   i,j: sample index

xi = x(i,:);
xj = x(j,:);
y = (xi*xj')^3;

end

