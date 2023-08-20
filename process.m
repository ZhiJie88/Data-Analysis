function csvFilePlotter()

    selectedFiles = {};     % Store the selected file paths
    selectedXColumn = '';   % Store the selected x-column
    selectedYColumns = {};  % Store the selected y-columns

    % Create the main figure window
    fig = figure('Name', 'CSV File Plotter', 'Position', [100, 100, 600, 400]);

    % Create the "Browse" button
    btnBrowse = uicontrol('Style', 'pushbutton', 'String', 'Browse', ...
        'Position', [20, 320, 80, 30], 'Callback', @browseFiles);

    % Create the file listbox
    fileListbox = uicontrol('Style', 'listbox', 'Position', [120, 320, 400, 60]);

    % Create the "X Column Selection" label
    labelXColumns = uicontrol('Style', 'text', 'String', 'X Column:', ...
        'Position', [20, 260, 80, 20]);

    % Create the "X Columns" popup menu
    popupXColumns = uicontrol('Style', 'popupmenu', 'Position', [120, 260, 400, 20]);

    % Create the "Y Column Selection" label
    labelYColumns = uicontrol('Style', 'text', 'String', 'Y Columns:', ...
        'Position', [20, 200, 80, 20]);

    % Create the "Y Columns" listbox
    listboxYColumns = uicontrol('Style', 'listbox', 'Position', [120, 200, 400, 80], ...
        'Max', 2, 'Min', 0);

    % Create the "Plot" button
    btnPlot = uicontrol('Style', 'pushbutton', 'String', 'Plot', ...
        'Position', [20, 140, 80, 30], 'Callback', @plotData);

    function browseFiles(~, ~)
        [filePaths, ~] = uigetfile('*.csv', 'Select CSV Files', 'MultiSelect', 'on');
        if isequal(filePaths, 0)
            return;
        end
        selectedFiles = filePaths;
        set(fileListbox, 'String', selectedFiles);
        updateColumnSelector();
    end

    function updateColumnSelector()
        set(popupXColumns, 'String', {});
        set(listboxYColumns, 'String', {});
        if ~isempty(selectedFiles)
            try
                data = readtable(selectedFiles{1});
                columns = data.Properties.VariableNames;
                set(popupXColumns, 'String', columns);
                set(listboxYColumns, 'String', columns);
            catch
                errordlg('Error reading CSV file.', 'Error');
            end
        end
    end

    function plotData(~, ~)
        selectedXColumnIndex = get(popupXColumns, 'Value');
        selectedXColumn = char(get(popupXColumns, 'String')(selectedXColumnIndex));
        selectedYColumns = get(listboxYColumns, 'String');
        
        if isempty(selectedXColumn)
            errordlg('Please select an x-column.', 'Error');
            return;
        end
        
        if isempty(selectedYColumns)
            errordlg('Please select at least one y-column.', 'Error');
            return;
        end
        
        figure;
        hold on;

        for i = 1:length(selectedFiles)
            try
                data = readtable(selectedFiles{i});
                selectedColumns = [selectedXColumn, selectedYColumns];
                data = data(:, selectedColumns);
                
                plot(data.(selectedXColumn), data{:, selectedYColumns}, 'o');
                
            catch
                continue;
            end
        end
        
        hold off;
        xlabel(selectedXColumn);
        ylabel('Selected Y Columns');
        title(['Data from CSV Files: ', selectedXColumn, ' vs ', strjoin(selectedYColumns, ', ')]);
        legend(selectedYColumns);
        grid on;
    end

end
