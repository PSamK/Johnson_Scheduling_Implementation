% Add the path to the directory where the other scripts are located
addpath('C:\Users\ACER\Desktop\UNIGE MAGISTRALE 1 ANNO\INDUSTRIAL AUTOMATION\Project\2');  % Update with the actual path

% Connect to the database
conn = connectDatabase();

% Clear existing data from the tables
if isopen(conn)
    % Delete all data from the tables
    exec(conn, 'DELETE FROM JobAssignments');
    exec(conn, 'DELETE FROM CuttedTubes');
    % Commit the transaction
    commit(conn);
else
    disp('Failed to connect to the database, cannot clear data');
    return;  % Exit the script if the connection failed
end

% Example data for CuttedTubes
cuttedTubesData = [
    1, 100, 10, 20;
    2, 101, 15, 12;
    3, 102, 12, 11;
    4, 103, 14, 24;
    5, 104, 11, 51;
    6, 105, 2, 23;
    7, 106, 16, 56;
    8, 107, 17, 27;
    9, 108, 7, 58;
    10, 109, 39, 29;
];

% Store the example data in the CuttedTubes table
%if isopen(conn)
%    for i = 1:size(cuttedTubesData, 1)
%        id = cuttedTubesData(i, 1);
%        batch_id = cuttedTubesData(i, 2);
%        processing_time_on_welding = cuttedTubesData(i, 3);
%        processing_time_on_oven = cuttedTubesData(i, 4);
%        
%        % Create a table to hold the data
%        data = table(id, batch_id, processing_time_on_welding, processing_time_on_oven);
%        
%        % Debug message to show data being inserted
%        disp(data);

        % Write the data to the database using sqlwrite
%        try
%            sqlwrite(conn, 'CuttedTubes', data);
%            disp('Results are stored');
%        catch e
%            disp('Error writing data to the database');
%            disp(e.message);
%        end
%    end


% Store the example data in the CuttedTubes table
if isopen(conn)
    for i = 1:size(cuttedTubesData, 1)
        % Extract data for each row
        id = cuttedTubesData(i, 1);
        batch_id = cuttedTubesData(i, 2);
        processing_time_on_welding = cuttedTubesData(i, 3);
        processing_time_on_oven = cuttedTubesData(i, 4);
        
        % Construct SQL query
        query = sprintf('INSERT INTO CuttedTubes (id, batch_id, processing_time_on_welding, processing_time_on_oven) VALUES (%d, %d, %d, %d)', ...
                        id, batch_id, processing_time_on_welding, processing_time_on_oven);
        
        % Execute the query
        try
            exec(conn, query);
            disp(['Data inserted successfully for id: ', num2str(id)]);
        catch e
            disp('Error writing data to the database');
            disp(e.message);
        end
    end

    %Commit the transaction
    commit(conn);

    % Close the connection
    close(conn);
else
    disp('Failed to connect to the database, cannot store results');
end
