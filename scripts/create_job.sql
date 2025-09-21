USE Northwind2025;
GO
--creo una tabla 

	
--hay que hacer la clase InactiveCustomersLog
BEGIN	
	
END

-- insertar los cientes inactivos 
INSERT INTO InactiveCustomersLog (CustomerID, CompanyName, ContactName, LastDate)
SELECT
Customers.CustomerID,
Customers.CompanyName,
Customers.ContactName,
MAX(Orders.OrderDate) AS LastDate -- este lastdate cambia de acuerdo a como se llame la fecha del ultimo pedido en la clase de los inactivos 
FROM Customers
INNER JOIN  Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, Customers.CompanyName, Customers.ContactName