USE msdb;
GO

-- Eliminar el JOB si ya existe (para evitar errores)
IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs WHERE name = 'Job_DetectarClientesInactivos')
    EXEC sp_delete_job @job_name = 'Job_DetectarClientesInactivos';
GO

-- Crear el JOB
EXEC dbo.sp_add_job
    @job_name = 'Job_DetectarClientesInactivos',
    @enabled = 1,
    @description = 'Detectar clientes inactivos (sin pedidos en últimos 183 días)';
GO

-- Paso del JOB: Ejecutar el stored procedure
EXEC sp_add_jobstep
    @job_name = 'Job_DetectarClientesInactivos',
    @step_name = 'Ejecutar SP Inactivos',
    @subsystem = 'TSQL',
    @command = 'EXEC Northwind2025.dbo.sp_LogInactiveCustomers;',
    @database_name = 'Northwind2025';
GO

-- Programar el JOB para ejecutar diariamente a las 2:00 AM
EXEC sp_add_jobschedule
    @job_name = 'Job_DetectarClientesInactivos',
    @name = 'EjecucionDiaria',
    @freq_type = 4, -- Diariamente
    @freq_interval = 1,
    @active_start_time = 20000; 

-- Asignar el JOB al servidor local
EXEC sp_add_jobserver
    @job_name = 'Job_DetectarClientesInactivos',
    @server_name = @@SERVERNAME;
GO

USE Northwind2025;
EXEC sp_LogInactiveCustomers;
SELECT * FROM InactiveCustomersLog;
