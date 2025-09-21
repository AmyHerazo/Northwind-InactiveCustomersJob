USE Northwind2025;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='InactiveCustomersLog' AND xtype='U')
CREATE TABLE InactiveCustomersLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID CHAR(5) NOT NULL,
    CompanyName NVARCHAR(40) NOT NULL,
    ContactName NVARCHAR(30) NULL,
    LastOrderDate DATE NOT NULL,
    InactivityLoggedDate DATETIME DEFAULT GETDATE()
        );
END
GO

IF OBJECT_ID('sp_LogInactiveCustomers', 'P') IS NOT NULL
    DROP PROCEDURE sp_LogInactiveCustomers;
GO

CREATE PROCEDURE sp_LogInactiveCustomers
AS
BEGIN
    INSERT INTO InactiveCustomersLog (CustomerID, CompanyName, ContactName, LastOrderDate)
    SELECT
        c.CustomerID,
        c.CompanyName,
        c.ContactName,
        MAX(o.OrderDate) AS LastOrderDate
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CompanyName, c.ContactName
    HAVING MAX(o.OrderDate) < DATEADD(DAY, -183, GETDATE())
           AND NOT EXISTS (
                SELECT 1 
                FROM InactiveCustomersLog ic
                WHERE ic.CustomerID = c.CustomerID
           );
END;
GO

/*=================================*/

-- Crear el job
EXEC msdb.dbo.sp_add_job
    @job_name = 'Job_LogInactiveCustomers',
    @enabled = 1,
    @description = 'Job que detecta clientes inactivos y los inserta en InactiveCustomersLog';
GO

-- Crear un paso que ejecute el procedimiento
EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'Job_LogInactiveCustomers',
    @step_name = 'Detectar clientes inactivos',
    @subsystem = 'TSQL',
    @database_name = 'Northwind2025',
    @command = 'EXEC sp_LogInactiveCustomers;',
    @on_success_action = 1;
GO

-- Crear un schedule (ejemplo: todos los días a las 02:00 AM)
EXEC msdb.dbo.sp_add_schedule
    @schedule_name = 'Daily_LogInactiveCustomers',
    @freq_type = 4, -- Diario
    @freq_interval = 1,
    @active_start_time = 020000; -- 02:00 AM
GO

-- Asociar el schedule al job
EXEC msdb.dbo.sp_attach_schedule
    @job_name = 'Job_LogInactiveCustomers',
    @schedule_name = 'Daily_LogInactiveCustomers';
GO

-- Asociar el job al servidor actual
EXEC msdb.dbo.sp_add_jobserver
    @job_name = 'Job_LogInactiveCustomers';
GO 