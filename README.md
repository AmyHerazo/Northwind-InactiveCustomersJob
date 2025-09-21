
---

## Requisitos

- **SQL Server** (2019 o superior recomendado)  
- **SQL Server Management Studio (SSMS)** para ejecutar los scripts  
- Base de datos Northwind cargada en tu instancia (incluida en `database/Northwind2025.sql`)

---

## Instrucciones de uso

1. **Restaurar la base de datos Northwind**  
   - Abre SSMS.  
   - Ejecuta el script:  
     ```sql
     database/Northwind2025.sql
     ```  
   - Esto creará las tablas y datos de ejemplo.

2. **Crear la tabla de log de clientes inactivos**  
   - Ejecuta el script:  
     ```sql
     scripts/create_inactive_log_table.sql
     ```

3. **Consultar clientes inactivos (opcional)**  
   - Para verificar qué clientes se consideran inactivos:  
     ```sql
     scripts/query_inactive_customers.sql
     ```

4. **Insertar clientes inactivos en el log**  
   - Ejecuta:  
     ```sql
     scripts/insert_inactive_customers.sql
     ```

5. **Crear el Job automático en SQL Server**  
   - Finalmente, programa el job para que se ejecute periódicamente:  
     ```sql
     scripts/create_job.sql
     ```

---

## Flujo del Job

1. Se consulta la tabla de clientes en Northwind.  
2. Se identifican clientes sin pedidos en el periodo definido.  
3. Se registran en la tabla de log de inactivos.  
4. El job se ejecuta de forma programada (según configuración de `create_job.sql`).  

---

## Notas

- Puedes modificar los criterios de inactividad directamente en el script `query_inactive_customers.sql`.  
- El job puede configurarse para ejecutarse *diariamente, semanalmente o mensualmente* según necesidad.  
