%% Animazione avambraccio 1 GDL da dati marker su CSV
% Legge le posizioni di spalla, gomito e mano da un file CSV esterno

clear; clc; close all

% Parametri (devono essere coerenti con i dati del CSV)
l1 = 0.3;   % Lunghezza omero [m]
l2 = 0.25;  % Lunghezza avambraccio [m]

% --- CARICAMENTO CSV ---
% Sostituisci 'dati_marker_1gdl.csv' col nome del tuo file se diverso
data = readtable('dati_marker_1.csv');

% Estrai marker
xS = data.x_spalla; yS = data.y_spalla;    % Spalla
xG = data.x_gomito; yG = data.y_gomito;    % Gomito
xH = data.x_mano;   yH = data.y_mano;      % Mano
nframe = height(data);

% Figura e limiti
figure('Name','Animazione 1 GDL da CSV'); axis equal; grid on; hold on
xlabel('x [m]'); ylabel('y [m]');
title('Animazione avambraccio (1 GDL) da dati CSV');
xlim([-0.3 0.3]);
ylim([-0.05 l1+0.1]);

for k = 1:nframe
    cla
    % Omero (fisso)
    plot([xS(k), xG(k)], [yS(k), yG(k)], 'k-', 'LineWidth', 4); % omero
    % Avambraccio
    plot([xG(k), xH(k)], [yG(k), yH(k)], 'k-', 'LineWidth', 4); % avambraccio
    % Marker giunti
    plot(xS(k), yS(k), 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 10); % spalla
    plot(xG(k), yG(k), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10); % gomito
    plot(xH(k), yH(k), 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 10); % mano

    % Retta di forza trasmissibile (opzionale, come nello script originale)
    v_link = [xH(k) - xG(k); yH(k) - yG(k)];
    v_link = v_link / norm(v_link);
    v_perp = [-v_link(2); v_link(1)];
    L = 0.2;
    retta_fx = xH(k) + L * [-v_perp(1), v_perp(1)];
    retta_fy = yH(k) + L * [-v_perp(2), v_perp(2)];
    plot(retta_fx, retta_fy, 'r', 'LineWidth', 2);

    % Etichette statiche
    text(xS(k), yS(k), '  Spalla (fissa)', 'FontWeight', 'bold', 'FontSize', 10, 'VerticalAlignment', 'bottom');
    text(xG(k), yG(k), '  Gomito', 'FontWeight', 'bold', 'FontSize', 10, 'VerticalAlignment', 'top');
    text(xH(k), yH(k), '  Mano', 'FontWeight', 'bold', 'FontSize', 10, 'VerticalAlignment', 'bottom');

    % Calcolo e mostra angolo attuale (opzionale)
    theta2 = atan2(yH(k)-yG(k), xH(k)-xG(k));
    angolo_gradi = rad2deg(theta2);
    txt = sprintf('\\theta = %.1f^\\circ', angolo_gradi);
    text(-0.28, l1+0.08, txt, 'FontWeight', 'bold', 'FontSize', 13, 'Color', 'b');

    pause(0.03)
end