% Main script to connect to the database and run Johnson's algorithm

% Add the path to the directory where the other scripts are located
addpath('C:\Users\ACER\Desktop\UNIGE MAGISTRALE 1 ANNO\INDUSTRIAL AUTOMATION\Project\2');  % Update with the actual path

% Connect to the database
conn = connectDatabase();

% Store the results in the database
if isopen(conn)

    % Retrieve processing times from the CuttedTubes table
    data = fetch(conn, 'SELECT processing_time_on_welding, processing_time_on_oven FROM CuttedTubes');
    
    % Convert the table to an array
    process_times = table2array(data);

    % Run Johnson's algorithm
    schedule = johnsonAlgorithm(process_times);

    for i = 1:size(schedule, 1)
        job_id = i;
        tube_id = schedule(i, 1);
        machine = {num2str(schedule(i, 2))};  % Convert to cell array of character vector
        
        % Create a table to hold the data
        data = table(job_id, tube_id, machine);
        
        % Write the data to the database using sqlwrite
        sqlwrite(conn, 'JobAssignments', data);
    end

    % Create Gantt chart
    createGanttChart(conn);

    % Calculate and display makespan using job assignments from Johnson's algorithm
    makespan_johnson = calculateMakespan(conn);
    disp('Makespan from Johnson''s algorithm:');
    disp(makespan_johnson);
    
    % Optimize the makespan using the mathematical model
    [xopt, val] = optimizeMakespan(conn);
    
    % Create Gantt chart from optimization results
    % createGanttChartFromOptimization(process_times, optimalJobSequence);

    % Close the connection
    close(conn);
else
    disp('Failed to connect to the database, cannot store results');

end
