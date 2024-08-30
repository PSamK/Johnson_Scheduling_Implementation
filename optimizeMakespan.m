function [xopt, val] = optimizeMakespan(conn)
    % Fetch data from the database
    cuttedTubesData = fetch(conn, 'SELECT id, processing_time_on_welding, processing_time_on_oven FROM CuttedTubes');
    
    % Convert the table to an array
    processing_times = table2array(cuttedTubesData(:, 2:3));
    
    % Transpose the processing times matrix for compatibility
    p = processing_times';

    % Define the number of jobs and machines
    [numMachines, numJobs] = size(p);
    
    % Print the number of jobs and machines
    disp(['Number of jobs: ', num2str(numJobs)]);
    disp(['Number of machines: ', num2str(numMachines)]);

    % Define the optimization problem
    prob = optimproblem('ObjectiveSense', 'min');

    % Define decision variables
    Cmax = optimvar('Cmax', 1, 1);
    s = optimvar('s', numMachines, numJobs, 'LowerBound', 0);
    c = optimvar('c', numMachines, numJobs, 'LowerBound', 0);
    x = optimvar('x', numMachines, numJobs, numJobs, 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);

    % Objective function
    objective = Cmax;
    prob.Objective = objective;

    % Constraints for completion time
    cons1 = optimconstr(numMachines * numJobs);
    count = 0;
    for k = 1:numMachines
        for i = 1:numJobs
            count = count + 1;
            cons1(count) = c(k, i) == s(k, i) + p(k, i);
        end
    end
    prob.Constraints.cons1 = cons1;

    % Constraints for sequencing jobs
    cons2 = optimconstr(numMachines * (numJobs^2 - numJobs));
    count = 0;
    for k = 1:numMachines
        for i = 1:numJobs
            for j = 1:numJobs
                if i ~= j
                    count = count + 1;
                    cons2(count) = s(k, j) >= c(k, i) - 10000 * (1 - x(k, i, j));
                end
            end
        end
    end
    prob.Constraints.cons2 = cons2;

    cons3 = optimconstr(numMachines * (numJobs^2 - numJobs));
    count = 0;
    for k = 1*numMachines
        for i = 1:numJobs
            for j = 1:numJobs
                if i ~= j
                    count = count + 1;
                    cons3(count) = s(k, i) >= c(k, j) - 10000 * x(k, i, j);
                end
            end
        end
    end
    prob.Constraints.cons3 = cons3;

    % Constraints for makespan
    cons4 = optimconstr(numJobs);
    for i = 1:numJobs
        cons4(i) = Cmax >= c(2, i);
    end
    prob.Constraints.cons4 = cons4;

    % Constraints for sequencing between machines
    cons5 = optimconstr(numJobs);
    for i = 1*numJobs
        cons5(i) = s(2, i) >= c(1, i);
    end
    prob.Constraints.cons5 = cons5;

    % Solve the problem
    opts = optimoptions('intlinprog', 'Display', 'off');
    [sol, fval] = solve(prob, 'Options', opts);

    xopt = sol;
    val = fval;
    
    disp('Minimum Makespan:');
    disp(val);
end
