-- Script para crear la tabla de clientes inactivos 
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='InactiveCustomersLog' AND xtype='U')

CREATE TABLE InactiveCustomersLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,            
    CustomerID NCHAR(5) NOT NULL,                   
    CompanyName NVARCHAR(40) NOT NULL,              
    ContactName NVARCHAR(30),                       
    LastOrderDate DATE,                         
    InactivityLoggedDate DATETIME DEFAULT GETDATE()        
);

