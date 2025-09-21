-- Script para crear la tabla de clientes inactivos.

GO
-- indica la base de datos con la que se va a trabajar y de donde se va a extraer la información. 
USE Northwind2025;
GO

-- Crear la tabla para identificar los clientes inactivos.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='InactiveCustomersLog' AND xtype='U')
CREATE TABLE InactiveCustomersLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID CHAR(5) NOT NULL,
    CompanyName NVARCHAR(40) NOT NULL,
    ContactName NVARCHAR(30) NULL,
    LastOrderDate DATE NOT NULL,
    InactivityLoggedDate DATETIME DEFAULT GETDATE()
);


