function nef = maxwell_cil(n1,n2,p)
%Funcion que calcula el indice de refraccion complejo de un material
%poroso, usando el modelo de medio efectivo de Maxwell-Garnett para 
%particulas cilindricas. Aplicable a materiales no magneticos, y campo 
%electrico polarizado perpendicular al eje cilindrico. Fuente: (citar)
%
% Ejemplo de uso:
%       neff = maxwell_cil(n1,n2,p)
%
% Input:
%       n1:    indice de refraccion del material 1
%       n2:    indice de refraccion del material 2
%       p:     porosidad (nro. real, 0<p<1), proporcion en volumen de n1
%              sobre el total
%
% Output:
%       neff:  indice de refraccion del medio efectivo

%Constante dielectrica de cada medio:
e1 = n1.^2;
e2 = n2.^2;

% Constante dielectrica efectiva, Maxwell-Garnet para cilindros: (citar)
eef = e2.*(((1-p)*e2+(1+p)*e1)./((1+p)*e2+(1-p)*e1));

% Calculo del indice de refraccion efectivo
nef = eef.^0.5;

% EOF maxwell_cil.m
end