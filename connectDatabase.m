function conn = connectDatabase()
    % Function to connect to the MS-SQL database
    % Here you have to set your credential
    databaseName = 'LocalHost_IA';
    serverName = 'LAPTOP-UOFBKJH6';
    username = 'Acer';

% Connect to the database
conn = database(databaseName,username,'');
    % Check the connection
    if isopen(conn)
        disp('Connection to SQL Server successful');
    else
        disp('Connection to SQL Server failed');
        disp(conn.Message);  % Display the error message
    end
end