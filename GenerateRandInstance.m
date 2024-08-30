% Script to Generate Different Problem Instances

% Connect to the database
conn = connectDatabase();

% Clear existing data from the tables
if isopen(conn)
    % Delete all data from the tables
    execute(conn, 'DELETE FROM JobAssignments;');
    execute(conn, 'DELETE FROM CuttedTubes;');
    % Commit the transaction
    commit(conn);
else
    disp('Failed to connect to the database, cannot clear data');
    return;  % Exit the script if the connection failed
end

% Store the results in the database
if isopen(conn)

    % Define Parameters for Instance Generation
    numJobs = 10;
    minTime = 1;
    maxTime = 40;
    
    % Generate random processing times
    jobData = randi([minTime maxTime], numJobs, 2);

    % Insert Generated Data into the Database
    for id = 1:numJobs
        query = sprintf('INSERT INTO CuttedTubes (id, batch_id, processing_time_on_welding, processing_time_on_oven) VALUES (%d, %d, %d, %d);', ...
                        id, id + numJobs ^ 2, jobData(id, 1), jobData(id, 2));
        
        % Execute the query
        try
            execute(conn, query);
            disp(['Data inserted successfully for id: ', num2str(id)]);
        catch e
            disp('Error writing data to the database');
            disp(e.message);
        end
    end
    
    % Close the Database Connection
    close(conn);

else
    disp('Failed to connect to the database, cannot store results');
end
