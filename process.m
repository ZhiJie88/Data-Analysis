% Clear workspace and close all figures
clear;
close all;

% Create the main GUI figure
mainFigure = figure('Name', 'CSV Data Plotter', 'Position', [100, 100, 400, 300]);

% Create listbox for file selection
fileListbox = uicontrol('Style', 'listbox', 'Position', [20, 150, 150, 120], 'String', {}, 'Max', 2);

% Create button to load files
loadButton = uicontrol('Style', 'pushbutton', 'Position', [20, 120, 100, 20], 'String', 'Load Files', 'Callback', @loadFiles);

% Create axis for plotting
plotAxis = axes('Parent', mainFigure, 'Position', [0.4, 0.1, 0.55, 0.7]);

% Initialize variable to store data
data = cell(0, 2); % Cell array to store data: {filename, data}

% Callback function for the Load Files button
function loadFiles(~, ~)
    % Get a list of CSV files in the current directory
    csvFiles = dir('*.csv');
    
    % Populate the listbox with file names
    fileNames = {csvFiles.name};
    set(fileListbox, 'String', fileNames, 'Value', []);
end

% Callback function to plot selected data
function plotSelectedData(selectedData)
    cla(plotAxis); % Clear the plot
    
    hold(plotAxis, 'on');
    for i = 1:length(selectedData)
        filename = selectedData{i, 1};
        fileData = selectedData{i, 2};
        
        xData = fileData(:, 1);
        yData = fileData(:, 2:end);
        
        for j = 1:size(yData, 2)
            plot(plotAxis, xData, yData(:, j), 'DisplayName', [filename, ' - Y', num2str(j)]);
        end
    end
    hold(plotAxis, 'off');
    
    xlabel(plotAxis, 'X Axis');
    ylabel(plotAxis, 'Y Axis');
    title(plotAxis, 'Multiple CSV Files Plot');
    legend(plotAxis, 'Location', 'best');
end

% Callback function for listbox selection
set(loadButton, 'Callback', @loadFiles);
