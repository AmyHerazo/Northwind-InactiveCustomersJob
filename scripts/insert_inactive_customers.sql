GO
-- indica la base de datos con la que se va a trabajar y de donde se va a extraer la información 
USE Northwind2025;
GO
-- Se crea el procedimiento almacenado si no existe, o lo modifica si ya existe
CREATE OR ALTER PROCEDURE sp_LogInactiveCustomers
AS
BEGIN
    INSERT INTO InactiveCustomersLog (CustomerID, CompanyName, ContactName, FechaUltimoPedido) -- agrega registros en la tabla y especifica las columnas donde se registran
    SELECT 
        c.CustomerID,
        c.CompanyName,
        c.ContactName,
        MAX(o.OrderDate) AS FechaUltimoPedido -- Toma la fecha máxima de la tabla Orders para cada cliente
    FROM 
        Customers c
    INNER JOIN 
        Orders o ON c.CustomerID = o.CustomerID -- Une la tabla Orders con Customers usando la columna CustomerID. Solo se incluyen los clientes que tengan órdenes
    WHERE 
        o.OrderDate < DATEADD(day, -183, GETDATE()) -- le resta 183 días a la fecha actual
    GROUP BY --  agrupa los resultados por cliente, esto se hace porque usamos la función de agregación MAX 
        c.CustomerID, c.CompanyName, c.ContactName
    HAVING -- Filtra los clientes que cumplan la condición
        MAX(o.OrderDate) < DATEADD(day, -183, GETDATE()); -- Asegura que la última orden del cliente sea anterior a hace 183 días.
END;
GO
