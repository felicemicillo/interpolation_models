clc;
clear;

% Modello di interpolazione lineare a tratti
figure ('Name', 'Seleziona i punti di controllo');
imshow ('Ferrari_488_Spider.jpg');
[x, y] = getpts ();
close;

% Configurazione degli assi con asse Y invertito
figure ('Name', 'Lineare a tratti');
hold on;
axis ('equal');
set (gca, 'Ydir', 'reverse');
nodes = plot (x, y, '*');
set (nodes, 'Color', 'k', 'LineWidth', 3);

% Interpolazione lineare a tratti
hold on
s = 1 : length(x);                                                         % Vettore degli indici dei nodi
t = 1 : 0.1 : length(x);                                                   % Vettore in cui calcolare i punti intermedi
p1 = interp1 (s, x, t);                                                    % Calcolo dei punti intermedi sulla coordinata x
p2 = interp1 (s, y, t);                                                    % Calcolo dei punti intermedi sulla coordinata y
lineare = plot (p1, p2);                                                   % Plot dell'interpolazione lineare a tratti
set (lineare, 'Color', 'r', 'LineWidth', 2);


