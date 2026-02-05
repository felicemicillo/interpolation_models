clc;
clear;

% Modello di interpolazione NURBS
figure ('Name', 'Seleziona i punti di controllo');
imshow ('Ferrari_488_Spider.jpg');
[x, y] = getpts ();
close;

% Configurazione degli assi con asse Y invertito
figure ('Name', 'NURBS');
hold on;
axis ('equal');
set (gca, 'Ydir', 'reverse');
nodes = plot (x, y, '*');
set (nodes, 'Color', 'k', 'LineWidth', 2);

%Nurbs con algoritmo di DeBoor
n = 4;
grado = n-1;
P = [x,y]';
t = [zeros(grado + 1, 1)' sort(rand(size(x, 1) - grado - 1, 1))' ...       % Knots a punti fissi
    ones(grado + 1, 1)'];
                                                                           % Knots a punti variabili
%t = sort(rand(length(x) + grado + 1, 1))'
w = 10*rand(size(x, 1), 1)';                                               % Vettore casuale dei pesi
Y = nurbs_deboor_fun(n,t,P,w);
hold on;
plot(Y(1,:), Y(2,:), 'r');
hold off;

%Plot delle funzioni base
figure('Name','Nik')
hold on;
axis('equal')
N = bspline_funzioni_base_fun(grado, t, size(x,1));
R = (N.*w)./sum(N.*w);
for j = 1 : size(x, 1)
    plot(linspace(1, 9, 10*size(x, 1)), R(:, j));
end
hold off;
legend(cellstr(strcat('N(', num2str((0:length(x)-1)'), ',', ...
    num2str(length(x)-1), ')')));
