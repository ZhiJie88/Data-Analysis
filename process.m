% Clear workspace and close all figures
clear;
close all;

% Create the main GUI figure
mainFigure = figure('Name', 'CSV Data Plotter', 'Position', [100, 100, 400, 300]);

% Initialize list of filenames
fileNames = {};

% Create listbox for file selection
fileListbox = uicontrol('Style', 'listbox', 'Position', [20, 150, 150, 120], 'String', fileNames);

% Create button to load files
loadButton = uicontrol('Style', 'pushbutton', 'Position', [20, 120, 100, 20], 'String', 'Load Files', 'Callback', @loadFiles);

% Create axis for plotting
plotAxis = axes('Parent', mainFigure, 'Position', [0.4, 0.1, 0.55, 0.7]);

% Callback function for the Load Files button
function loadFiles(~, ~)
    % Get a list of CSV files in the current directory
    csvFiles = dir('*.csv');
    
    % Extract filenames
    fileNames = {csvFiles.name};
    
    % Update listbox with file names
    set(fileListbox, 'String', fileNames, 'Value', []);
end

% Callback function for listbox selection
set(fileListbox, 'Callback', @selectFile);

function selectFile(~, ~)
    selectedIndices = get(fileListbox, 'Value');
    
    % Clear previous data
    data = cell(0, 2);
    
    % Read data from selected CSV files and store in 'data' variable
    for i = selectedIndices
        filename = fileNames{i};
        fileData = csvread(filename);
        data{end+1, 1} = filename;
        data{end, 2} = fileData;
    end
    
    % Update the plot with the selected data
    plotSelectedData(data);
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
