
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

## 🎓 SQL y los paradigmas de programación

El lenguaje **SQL** se relaciona con varios paradigmas de programación, pero en este proyecto se manifiestan de la siguiente forma:

### 🔹 Paradigma principal: Declarativo / Funcional
- SQL es un **lenguaje declarativo**, ya que las consultas describen *qué resultado se desea* y no *cómo obtenerlo*.  
- En este proyecto: el script `query_inactive_customers.sql` define las condiciones de inactividad y deja que el motor de SQL Server calcule el resultado.  
- Esto lo aproxima al **paradigma funcional**, donde las consultas se comportan como funciones puras sobre los datos.

### 🔹 Paradigma Imperativo
- Aparece cuando se definen acciones en secuencia que cambian el estado de la base de datos.  
- En este proyecto: `insert_inactive_customers.sql` ejecuta instrucciones que **modifican** la tabla de log agregando nuevos registros.

### 🔹 Paradigma Orientado a Objetos (visión conceptual en tablas)
- Las tablas como `Customers` pueden entenderse como entidades con atributos (columnas) y relaciones (claves foráneas).  
- De este modo, la estructura de la base refleja principios de organización típicos del paradigma orientado a objetos.

### 🔹 Paradigma Lógico
- SQL utiliza **hechos** (datos almacenados) y **reglas** (`WHERE`, `JOIN`) para inferir conclusiones.  
- Ejemplo: en este proyecto, la regla “un cliente es inactivo si no tiene pedidos en los últimos X días” se traduce directamente en una consulta.

---

## Notas

- Puedes modificar los criterios de inactividad directamente en el script `query_inactive_customers.sql`.  
- El job puede configurarse para ejecutarse *diariamente, semanalmente o mensualmente* según necesidad.  
