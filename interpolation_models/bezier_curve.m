clc;
clear;

% Modello di interpolazione curve di Bezier
figure ('Name', 'Seleziona i punti di controllo');
imshow ('Ferrari_488_Spider.jpg');
[x, y] = getpts ();
close;

% Configurazione degli assi con asse Y invertito
figure ('Name', 'Interpolazione curva di Bezier');
hold on;
axis ('equal');
set (gca, 'Ydir', 'reverse');
nodes = plot (x, y, '*');
set (nodes, 'Color', 'k', 'LineWidth', 2);

% Curve di Bezier
hold on
P = zeros(length(x), 2);                                                   % Definisco una matrice P con le coordinate dei punti di controllo
for i = 1 : length (x)
    P (i,1) = x (i);
    P (i,2) = y (i);
end
syms t;
B = bernsteinMatrix (length(x)-1, t);                                      % Realizzo la matrice dei polinomi di Bernstein
bezierCurve = simplify (B*P);                                              % Moltiplico la matrice di bernstein e i punti di controllo e ottengo la curva di Bezier
bezier = fplot (bezierCurve(1), bezierCurve(2), [0,1]);                    % Plotto la curva di Bezier
set (bezier, 'Color', 'r', 'LineWidth', 2);

% Plot dei polinomi di Bernstein
figure('Name', 'Polinomi della matrice di Bernstein')
axis('equal')
axis([0 1 0 1])
hold('on')
t_values = linspace(0, 1, 50);                                             % Definisco l'intervallo in cui definire i polinomi da plottare
for i = 1:(length(x))                                                      % Plotto ogni polinomio
    y = subs(B(:, i), t_values);
    plot(t_values, y);
end
hold off;
legend(cellstr(strcat('B(', num2str((0:length(x)-1)'), ',', ...
    num2str(length(x)-1), ')')));


