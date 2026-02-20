clear all;
% Part A - This will make a model similar to figure 1.
% Values used in the project notes:
%   L=7,  r=1, dT=1, tI=500, n=2,   nP=300, vel=.03
za(7, 1, 1, 500, 2, 300, .03)
%   L=25, r=1, dT=1, tI=500, n=.1,  nP=300, vel=.03
za(25, 1, 1, 500, .1, 300, .03)
%   L=7,  r=1, dT=1, tI=750, n=2,   nP=300, vel=.03
za(7, 1, 1, 750, 2, 300, .03)
%   L=5,  r=1, dT=1, tI=500, n=.1,  nP=300, vel=.03
za(5, 1, 1, 500, .1, 300, .03)

%%
% Part B - This will make a model similar to figure 2.
clear all;
for repool = 1:2:5
    parN = (repool^2) * (100 / repool);
    count = 0;
    yAx = 0;
    for looper = 0:.1:5
        count = count + 1;
        yAx(count) = zb(7, 1, 1, 500, looper, parN, .03);
    end
    plot(0:.1:5, yAx)
    hold on;
end

% Vicsek Model - Function for Figure 1
function f = za(L, r, dT, tI, n, nP, v)
f = [];

% Initial factors
LinDom = L;
IntRad = r;
deltaTime = dT; %#ok<NASGU>
TimeIntervals = tI;
noise = n;
NumPart = nP;
vel = v;

% Establish X, Y, and Theta
x_comp = LinDom * rand(1, NumPart);
y_comp = LinDom * rand(1, NumPart);
theta = 2 * pi * (rand(1, NumPart) - 0.5);

for time = 1:TimeIntervals %#ok<NASGU>
    D = pdist([x_comp' y_comp']);

    % Boundary wrap setup (periodic boundaries)
    bound_x(x_comp < IntRad) = x_comp(x_comp < IntRad) + LinDom;
    bound_x(x_comp > LinDom - IntRad) = x_comp(x_comp > LinDom - IntRad) - LinDom;
    bound_x(IntRad <= x_comp & x_comp <= LinDom - IntRad) = x_comp(IntRad <= x_comp & x_comp <= LinDom - IntRad);

    bound_y(y_comp < IntRad) = LinDom + y_comp(y_comp < IntRad);
    bound_y(y_comp > LinDom - IntRad) = y_comp(y_comp > LinDom - IntRad) - LinDom;
    bound_y(IntRad <= y_comp & y_comp <= LinDom - IntRad) = y_comp(IntRad <= y_comp & y_comp <= LinDom - IntRad);

    OneTime_D = pdist([bound_x' bound_y']);
    D = min([D; OneTime_D]);

    Mat_dist = squareform(D);
    [l1, l2] = find(0 < Mat_dist & Mat_dist < IntRad);

    for i = 1:NumPart
        list = l1(l2 == i);
        if ~isempty(list)
            ave_theta(i) = atan2(mean(sin(theta(list))), mean(cos(theta(list))));
        else
            ave_theta(i) = theta(i);
        end
    end

    x_vel = vel * cos(theta);
    y_vel = vel * sin(theta);
    x_comp = x_comp + x_vel;
    y_comp = y_comp + y_vel;

    x_comp(x_comp < 0) = LinDom + x_comp(x_comp < 0);
    x_comp(LinDom < x_comp) = x_comp(LinDom < x_comp) - LinDom;
    y_comp(y_comp < 0) = LinDom + y_comp(y_comp < 0);
    y_comp(LinDom < y_comp) = y_comp(LinDom < y_comp) - LinDom;

    theta = ave_theta + noise * (rand(1, NumPart) - 0.5);

    figure(1)
    quiver(x_comp, y_comp, x_vel, y_vel, .2)
    xlim([0 LinDom]);
    ylim([0 LinDom]);
    axis square
    pause(0.15)
end
end

% Vicsek Model - Function for Figure 2
function f = zb(L, r, dT, tI, n, nP, v)
% Initial factors
LinDom = L;
IntRad = r;
deltaTime = dT; %#ok<NASGU>
TimeIntervals = tI;
noise = n;
NumPart = nP;
vel = v;

% Establish X, Y, and Theta
x_comp = LinDom * rand(1, NumPart);
y_comp = LinDom * rand(1, NumPart);
theta = 2 * pi * (rand(1, NumPart) - 0.5);

b = 0;
listOfTheta = 1:TimeIntervals;
distTheta = 1:TimeIntervals;

for time = 1:TimeIntervals %#ok<NASGU>
    b = b + 1;

    D = pdist([x_comp' y_comp']);

    bound_x(x_comp < IntRad) = x_comp(x_comp < IntRad) + LinDom;
    bound_x(x_comp > LinDom - IntRad) = x_comp(x_comp > LinDom - IntRad) - LinDom;
    bound_x(IntRad <= x_comp & x_comp <= LinDom - IntRad) = x_comp(IntRad <= x_comp & x_comp <= LinDom - IntRad);

    bound_y(y_comp < IntRad) = LinDom + y_comp(y_comp < IntRad);
    bound_y(y_comp > LinDom - IntRad) = y_comp(y_comp > LinDom - IntRad) - LinDom;
    bound_y(IntRad <= y_comp & y_comp <= LinDom - IntRad) = y_comp(IntRad <= y_comp & y_comp <= LinDom - IntRad);

    OneTime_D = pdist([bound_x' bound_y']);
    D = min([D; OneTime_D]);

    Mat_dist = squareform(D);
    [l1, l2] = find(0 < Mat_dist & Mat_dist < IntRad);

    for i = 1:NumPart
        list = l1(l2 == i);
        if ~isempty(list)
            ave_theta(i) = atan2(mean(sin(theta(list))), mean(cos(theta(list))));
        else
            ave_theta(i) = theta(i);
        end
    end

    x_vel = vel * cos(theta);
    y_vel = vel * sin(theta);
    x_comp = x_comp + x_vel;
    y_comp = y_comp + y_vel;

    x_comp(x_comp < 0) = LinDom + x_comp(x_comp < 0);
    x_comp(LinDom < x_comp) = x_comp(LinDom < x_comp) - LinDom;
    y_comp(y_comp < 0) = LinDom + y_comp(y_comp < 0);
    y_comp(LinDom < y_comp) = y_comp(LinDom < y_comp) - LinDom;

    noisey = noise * (rand(1, NumPart) - 0.5);
    theta = ave_theta + noisey;

    listOfTheta(b) = abs(mean((mean(ave_theta) - mean(theta) - mean(noisey))));
end

OverallTheta = mean(listOfTheta);
distTheta = (((OverallTheta) / pi) * -1 + 1);
f = distTheta;
end