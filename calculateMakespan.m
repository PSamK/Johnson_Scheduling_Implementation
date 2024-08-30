function makespan = calculateMakespan(conn)
    % Fetch job assignments data from the database
    jobAssignmentsData = fetch(conn, 'SELECT job_id, tube_id, machine FROM JobAssignments');
    
    % Convert job assignments data to array
    jobAssignments = [table2array(jobAssignmentsData(:, 1)), table2array(jobAssignmentsData(:, 2)), str2double(jobAssignmentsData.machine)];

    % Fetch processing times from the database
    cuttedTubesData = fetch(conn, 'SELECT id, processing_time_on_welding, processing_time_on_oven FROM CuttedTubes');
    processing_times = table2array(cuttedTubesData(:, 2:3));

    % Extract the unique tube ids and their processing times
    [uniqueTubeIds, ~, idx] = unique(jobAssignments(:, 2));
    n = length(uniqueTubeIds);

    % Initialize end times for each machine
    M1_end = zeros(n, 1);
    M2_end = zeros(n, 1);

    % Calculate end time for the first job on both machines
    M1_end(1) = processing_times(uniqueTubeIds(1), 1);
    M2_end(1) = M1_end(1) + processing_times(uniqueTubeIds(1), 2);

    % Calculate end times for remaining jobs
    for i = 2:n
        M1_end(i) = M1_end(i-1) + processing_times(uniqueTubeIds(i), 1);
        M2_end(i) = max(M1_end(i), M2_end(i-1)) + processing_times(uniqueTubeIds(i), 2);
    end

    % Makespan is the end time of the last job on the second machine
    makespan = M2_end(n);
end
