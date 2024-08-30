function createGanttChart(conn)
    % Fetch data from the database
    cuttedTubesData = fetch(conn, 'SELECT id, processing_time_on_welding, processing_time_on_oven FROM CuttedTubes');
    jobAssignmentsData = fetch(conn, 'SELECT job_id, tube_id, machine FROM JobAssignments ORDER BY job_id');
    
    % Convert tables to arrays
    cuttedTubes = table2array(cuttedTubesData);
    
    % Convert 'jobAssignmentsData' to double array
    jobAssignments = [table2array(jobAssignmentsData(:, 1)), table2array(jobAssignmentsData(:, 2)), str2double(jobAssignmentsData.machine)];
    
    % Get the unique tube ids and their processing times
    %[uniqueTubeIds, ~, ~] = unique(jobAssignments(:, 2));
    uniqueTubeIds = jobAssignments(:, 2);
    n = length(uniqueTubeIds);
    
    % Initialize arrays for end times
    M1_end = zeros(n, 1);
    M2_end = zeros(n, 1);

    % Calculate end times for jobs on M1 and M2
    for i = 1:n
        tube_id = uniqueTubeIds(i);
        
        % Get processing times
        processing_time_on_welding = cuttedTubes(cuttedTubes(:, 1) == tube_id, 2);
        processing_time_on_oven = cuttedTubes(cuttedTubes(:, 1) == tube_id, 3);
        
        if i == 1
            % First job
            M1_end(i) = processing_time_on_welding;
            M2_end(i) = M1_end(i) + processing_time_on_oven;
        else
            % Subsequent jobs
            M1_end(i) = M1_end(i-1) + processing_time_on_welding;
            M2_end(i) = max(M1_end(i), M2_end(i-1)) + processing_time_on_oven;
        end
    end

    % Create the Gantt chart
    figure;
    hold on;
    max_time = max(M2_end); % Find the maximum time for scaling the grid
    for i = 1:n
        tube_id = uniqueTubeIds(i);
        
        % Get processing times
        processing_time_on_welding = cuttedTubes(cuttedTubes(:, 1) == tube_id, 2);
        processing_time_on_oven = cuttedTubes(cuttedTubes(:, 1) == tube_id, 3);
        
        % Plot welding (machine 1) as yellow squares
        for t = 0:(processing_time_on_welding-1)
            rectangle('Position', [M1_end(i) - processing_time_on_welding + t, n - i + 0.5, 1, 1], ...
                'FaceColor', 'yellow', 'EdgeColor', 'k');
        end
        
        % Plot oven (machine 2) as blue squares
        for t = 0:(processing_time_on_oven-1)
            rectangle('Position', [M2_end(i) - processing_time_on_oven + t, n - i + 0.5, 1, 1], ...
                'FaceColor', 'cyan', 'EdgeColor', 'k');
        end
    end
    xlabel('Time');
    ylabel('Tube ID');
    title('Gantt Chart');
    set(gca, 'YTick', 1:n, 'YTickLabel', flip(uniqueTubeIds));
    xlim([0 max_time]);
    ylim([0 n+1]);
    grid on;
    hold on;
end
