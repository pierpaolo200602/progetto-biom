% ---- INSERISCI QUI LE LUNGHEZZE CHE CONOSCI ----
l1 = 0.30; % lunghezza spalla-gomito (in metri)
l2 = 0.25; % lunghezza gomito-polso (in metri)

% ---- CARICAMENTO DATI ----
data = readtable('dati_marker.csv');
t = data.time;
x1 = data.x1; y1 = data.y1; % Spalla
x2 = data.x2; y2 = data.y2; % Gomito
x3 = data.x3; y3 = data.y3; % Polso
dt = mean(diff(t));
nFrame = height(data);

theta1 = zeros(nFrame,1);
theta2 = zeros(nFrame,1);
omega1 = zeros(nFrame,1);
omega2 = zeros(nFrame,1);
vx = zeros(nFrame,1);
vy = zeros(nFrame,1);

% ---- CALCOLO ANGOLI ----
for i = 1:nFrame
    theta1(i) = atan2(y2(i)-y1(i), x2(i)-x1(i));
    theta2(i) = atan2(y3(i)-y2(i), x3(i)-x2(i)) - theta1(i);
end

% ---- VELOCITÀ ANGOLARI (derivata numerica) ----
omega1(2:end) = diff(theta1) / dt;
omega2(2:end) = diff(theta2) / dt;

% ---- VELOCITÀ END EFFECTOR ----
for i = 1:nFrame
    J = [ -l1*sin(theta1(i)) - l2*sin(theta1(i)+theta2(i)),  -l2*sin(theta1(i)+theta2(i));
           l1*cos(theta1(i)) + l2*cos(theta1(i)+theta2(i)),   l2*cos(theta1(i)+theta2(i)) ];
    v = J * [omega1(i); omega2(i)];
    vx(i) = v(1);
    vy(i) = v(2);
end

% ---- GRAFICI DI CONTROLLO ----
figure;
subplot(3,1,1); plot(t, theta1, t, theta2); legend('\theta_1','\theta_2'); ylabel('Angolo (rad)'); title('Angoli articolari');
subplot(3,1,2); plot(t, omega1, t, omega2); legend('\omega_1','\omega_2'); ylabel('Velocità angolare (rad/s)'); title('Velocità angolari');
subplot(3,1,3); plot(t, vx, t, vy); legend('v_x','v_y'); ylabel('Velocità (m/s)'); title('Velocità End Effector'); xlabel('Tempo (s)');

% ---- ELLISSE DI FORZA (frame centrale) ----
i_ellisse = round(nFrame/2);
J = [ -l1*sin(theta1(i_ellisse)) - l2*sin(theta1(i_ellisse)+theta2(i_ellisse)),  -l2*sin(theta1(i_ellisse)+theta2(i_ellisse));
       l1*cos(theta1(i_ellisse)) + l2*cos(theta1(i_ellisse)+theta2(i_ellisse)),   l2*cos(theta1(i_ellisse)+theta2(i_ellisse)) ];
A = inv(J*J');
[U,S,~] = svd(A);
theta = linspace(0,2*pi,100);
ellisse = U * sqrt(S) * [cos(theta); sin(theta)];
figure; hold on;
plot(ellisse(1,:) + x3(i_ellisse), ellisse(2,:) + y3(i_ellisse), 'r','LineWidth',2);
plot(x3(i_ellisse), y3(i_ellisse), 'ko','MarkerFaceColor','k');
xlabel('x [m]'); ylabel('y [m]');
title('Ellisse di forza sull''end-effector');
axis equal; grid on;