function ind = parecido(x,y)

%
% funcion que devuelve el indice en que se encuentra el valor x mas
% parecido dentro del vector y.
%
% ind = parecido(x,y)
%

ind = find( abs( x-y ) == min( abs( x-y ) ) );

if numel(ind)>1
ind=ind(1);
end

% EOF
end
