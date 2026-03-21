clc
clearvars
close all

nombre = '250825c';

%% Carga de datos

datos_crud = load(['datos' nombre '.dat']);
tiempo = load(['tiempo' nombre '.dat']);
lambda = load(['lambda' nombre '.dat']);

li = 500; %Long. de onda inicial
lf = 1000; %Long. de onda final
lambda0 = 750; %Long. de onda [nm] de referencia para seguir el pico que mas cerca caiga de ese valor
np = 9; %Nro. de picos y valles que va a seguir (toma de lambda0 en adelante) durante el secado
t0 = 17; %tiempo inicial que se le restan a los datos para mostrar los resultados

% Parámetros de muestra y líquido
p = 0.33; %Porosidad de la muestra
h = 15e-6; %Espesor de la muestra [m]
dens = 789; %Densidad del líquido [kg/m3]

% Parámetros del suavizado y busqueda
order = 3; %Orden del polinomio de suavizado de los espectros
framelen = 21; %Nro. de puntos en el suavizado de los espectros (debe ser impar)
prominencia = 4;

%% Recortado de vectores
tiempo = tiempo';
indi = parecido(li,lambda);
indf = parecido(lf,lambda);
lambda = lambda(indi:indf); %Recorta el vector de long. de onda
datos = zeros(length(tiempo),length(lambda));
for i=1:length(tiempo)
    datos(i,:)=datos_crud(i,indi:indf); %Recorta los vectores de datos
end

%% Suavizado y busqueda de picos y valles

lambdacentral = zeros(length(tiempo),np);

figure
xlabel('Tiempo [s]')
ylabel('Long. de onda [nm]')
title(['Seguimiento de extremos de la medicion ' nombre])
hold on

for cont = 1:length(tiempo)
    %Sigue la posicion de un pico en particular (que empieza en lambda0)
    %suaviza los datos antes de buscar la posicion del máximo
    suav=sgolayfilt(datos(cont,:),order,framelen);
    [maxs,locs_max] = findpeaks(suav,'MinPeakProminence', prominencia);
    [mins,locs_min] = findpeaks(-suav,'MinPeakProminence', prominencia);
    %Une y ordena los extremos
    extr = [maxs mins];
    locs = [locs_max locs_min];
    [locs, idx] = sort(locs);
    extr = extr(idx);

    aux = min(abs(lambda0-lambda(locs_max)))==abs(lambda0-lambda(locs_max)); %indice del pico mas cercano
    locs = locs(lambda(locs)>=lambda(locs_max(aux)));
    indc = locs(1:np);
    lambdacentral(cont,:) = lambda(indc)';

    %corrijo la longitud de onda de referencia para poder seguir el pico
    lambda0=lambdacentral(cont,1);

    plot(tiempo(cont)*ones(size(maxs)),lambda(locs_max),'r.');
    plot(tiempo(cont)*ones(size(mins)),lambda(locs_min),'b.');

end

legend('Máximos', 'Mínimos');
hold off

% figure(10)  
% plot(lambda, datos(cont/4,:), lambda, suav)


%% Graficos
tiempo=tiempo-t0; %tiempo inicial que se le restan a los datos para mostrar los resultados
ind0 = find(tiempo == min(abs(tiempo)));
lambdaini = lambdacentral(ind0,:);

figure(2)
plot(tiempo,lambdacentral)
ylabel('Posicion del pico de referencia [nm]')
xlabel('Tiempo [s]')
grid on
hold all

figure(3)
plot(tiempo,(lambdacentral-min(lambdacentral))./(lambdaini-min(lambdacentral)))
ylabel('Fracc. de llenado')
xlabel('Tiempo [s]')
grid on
hold all

figure(4)
plot(tiempo,((lambdacentral-min(lambdacentral))./min(lambdacentral)))
ylabel('Variacion de la posicion del pico de referencia relativa')
xlabel('Tiempo [s]')
grid on
hold all

frac_llen_prom = mean((lambdacentral-min(lambdacentral))./(lambdaini-min(lambdacentral)), 2);

ley = ['Medición: ' nombre '. n = ' num2str(size(lambdacentral,2))];

figure(5)

lgd = legend;
old_labels = {};
if ~isempty(lgd) && isvalid(lgd)
    old_labels = lgd.String;
end

plot(tiempo,frac_llen_prom)
ylabel('Fracc. de llenado')
xlabel('Tiempo [s]')
title('Curva Promediada')
legend([old_labels, ley]);
grid on
hold all

% Evaporación
evap = zeros(size(tiempo));
evap(1) = -dens*p*h*(frac_llen_prom(2)-frac_llen_prom(1))/(tiempo(2)-tiempo(1));
evap(2:end-1) = -dens*p*h*(frac_llen_prom(3:end)-frac_llen_prom(1:end-2))./(tiempo(3:end)-tiempo(1:end-2));
evap(end) = -dens*p*h*(frac_llen_prom(end)-frac_llen_prom(end-1))./(tiempo(end)-tiempo(end-1));

ley = ['Medición: ' nombre '.'];

figure(6)

lgd = legend;
old_labels = {};
if ~isempty(lgd) && isvalid(lgd)
    old_labels = lgd.String;
end

plot(tiempo,evap)
ylabel('Flujo másico de evaporación [kg/m^2s]')
xlabel('Tiempo [s]')
legend([old_labels, ley]);
grid on
hold all