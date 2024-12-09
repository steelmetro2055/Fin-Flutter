function flutterui
% Creates User Interface for the Fin Flutter Code
%   Detailed explanation goes here 


fig = uifigure('Name', 'Flutter Those Fins', 'WindowState', 'maximized', 'Color',[1 1 1]);
grid = uigridlayout(fig, [10, 3]); 
grid.BackgroundColor = [1 1 1];

img = uiimage(fig); % Not part of the grid layout
img.Position = [1325, 510, 300, 300]; % Adjust as needed (x, y, width, height)
img.ImageSource = 'logo.png';
 
titleshadow = uilabel(grid, 'Text', ' Fin Flutter Approximator', 'HorizontalAlignment', 'center','FontWeight','Bold','FontSize',30,'FontName','Times New Roman','FontColor',[.8 .8 .8]);
titleshadow.Layout.Row = 1; 
titleshadow.Layout.Column = 2; 

title = uilabel(grid, 'Text', 'Fin Flutter Approximator', 'HorizontalAlignment', 'center','FontWeight','Bold','FontSize',30,'FontName','Times New Roman');
title.Layout.Row = 1; 
title.Layout.Column = 2; 

filler = uilabel(grid, 'Text', '', 'HorizontalAlignment', 'left');
filler.Layout.Row = 1; 
filler.Layout.Column = 3; 

uilabel(grid, 'Text', ['Altitude ASL of Max Rocket Velocity: '], 'HorizontalAlignment', 'left'); 
inputFields(1) = uieditfield(grid, 'numeric');
units(1) = uidropdown(grid,"Items",["km","m"],"FontWeight", "bold");

uilabel(grid, 'Text', ['Shear Modulus of the Fin Material: '], 'HorizontalAlignment', 'left'); 
inputFields(2) = uieditfield(grid, 'numeric');
units(2) = uidropdown(grid,"Items",["GPa","kPa"],"FontWeight", "bold");

uilabel(grid, 'Text', ['Height of the Fin: '], 'HorizontalAlignment', 'left'); 
inputFields(3) = uieditfield(grid, 'numeric');
units(3) = uidropdown(grid,"Items",["in","cm"],"FontWeight", "bold");

uilabel(grid, 'Text', ['Tip Chord Length of the Fin: '], 'HorizontalAlignment', 'left'); 
inputFields(4) = uieditfield(grid, 'numeric');
units(4) = uidropdown(grid,"Items",["in","cm"],"FontWeight", "bold");

uilabel(grid, 'Text', ['Root Chord Length of the Fin: '], 'HorizontalAlignment', 'left'); 
inputFields(5) = uieditfield(grid, 'numeric');
units(5) = uidropdown(grid,"Items",["in","cm"],"FontWeight", "bold");

uilabel(grid, 'Text', ['Fin Thickness: '], 'HorizontalAlignment', 'left'); 
inputFields(6) = uieditfield(grid, 'numeric');
units(6) = uidropdown(grid,"Items",["in","cm"],"FontWeight", "bold");

uilabel(grid, 'Text', ['Sweep Length: '], 'HorizontalAlignment', 'left'); 
inputFields(7) = uieditfield(grid, 'numeric');
units(7) = uidropdown(grid,"Items",["in","cm"],"FontWeight", "bold");

resultLabel = uilabel(grid, 'Text', '', 'HorizontalAlignment', 'right','FontWeight', 'bold','FontColor', 'red','FontSize',20);
resultLabel.Layout.Row = 9; 
resultLabel.Layout.Column = 2; 

resultLabelLabelunits = uilabel(grid, 'Text', 'meters/second', 'HorizontalAlignment', 'left','FontWeight','bold');
resultLabelLabelunits.Layout.Row = 9; 
resultLabelLabelunits.Layout.Column = 3; 

finshape = uiaxes(grid);
finshape.Layout.Row = 10;
finshape.Layout.Column = [1,3];
finshape.Title.String = 'Fin Geometry';
finshape.XLabel.String = 'X-Axis';
finshape.YLabel.String = 'Y-Axis';

calcButton = uibutton(grid,'Text', 'Thy Fin Shall Flutter at:','ButtonPushedFcn', @(calcButton,event) calculateResult(inputFields, resultLabel, units, finshape),'BackgroundColor', [1, 0, 0],'FontColor', [1, 1, 1],'FontWeight', 'bold','FontSize',15); 
calcButton.Layout.Row = 9; 
calcButton.Layout.Column = [1];


grid.RowHeight = {'3x', '1x', '1x', '1x', '1x', '1x', '1x','1x','1x','10x'}; 
grid.ColumnWidth = {'fit', '1x','fit'}; 

end 

function calculateResult(inputFields, resultLabel, units, finshape, ~) % Add third parameter for the event
    % Get values from input fields
    values = zeros(1, 7);
    am = inputFields(1).Value; 
    if strcmp(units(1).Value,"km")
        am = inputFields(1).Value*1000;
    end
    Ge = inputFields(2).Value;
    if strcmp(units(2).Value,"GPa")
        Ge = inputFields(2).Value*1000000;
    end
    height = inputFields(3).Value; 
    if strcmp(units(3).Value,"in")
        height = inputFields(3).Value*2.54;
    end
    tclength = inputFields(4).Value; 
    if strcmp(units(4).Value,"in")
        tclength = inputFields(4).Value*2.54;
    end
    rclength = inputFields(5).Value; 
    if strcmp(units(5).Value,"in")
        rclength = inputFields(5).Value*2.54;
    end
    thickness = inputFields(6).Value; 
    if strcmp(units(6).Value,"in")
        thickness = inputFields(6).Value*2.54;
    end
    m = inputFields(7).Value; 
    if strcmp(units(7).Value,"in")
        m = inputFields(7).Value*2.54;
    end
    % Perform calculation 
    p0 = 101.29; % air pressure at sea level (14.696 psi or 101.325 KPa)
    if am > 0 && am <= 11000
        Tc = 15.04 - (0.00649*am); % Finds approximate air tempature in C at altitude of maximum velocity 
         p = p0*((Tc + 273.1)/(288.08))^5.256; % calculates air pressure in KPa
    elseif am > 11000 && am <= 25000
         Tc = -56.46;
            p = 22.65*exp(1.73-0.000157*am);
    elseif am > 25000
         Tc = -131.21 + 0.00299*am;
         p = 2.488 * ((Tc + 273.1)/216.6)^-11.388;
    end
    
    ams = 20.05 * sqrt(273.16 + Tc); % Finds speed of sound in meters/sec at altitude of maximum velocity 
    
    area = height*(tclength+rclength)/2;
    A = (height^2)/(area);
    
    lam = tclength/rclength;
    
    p0 = 101.325; % air pressure at sea level (14.696 psi or 101.325 KPa)
    p = p0*((Tc + 273.16)/(288.16))^5.256; % calculates air pressure in KPa
    pratio = p/p0; % divides by the air pressure at sea level

    Cx = ((2*tclength*m)+(tclength)^2+(m*rclength)+(tclength*rclength)+(rclength)^2)/(3*(tclength+rclength));
    eps = (Cx/rclength)-0.25;
    k = 1.4; % adiabatic index for air
    DN = (24*eps*k*p0)/pi;

    vf = ams*sqrt(Ge/(((DN*A^3)/((thickness/rclength)^3*(A+2)))*((lam+1)/2)*(p/p0)));
    result = vf;

    % Update the result label directly
    resultLabel.Text = num2str(result);

    % Calculate the coordinates of the trapezoid
    x = [0, 0, height, height]; % X-coordinates
    y = [0, rclength, rclength-m, rclength-m-tclength]; % Y-coordinates


    fill(finshape, x, y, [0 .4 0]); % Fill the trapezoid with color
    finshape.DataAspectRatio = [1 1 1];

end


%% notes for jeffrey
% error calculator 