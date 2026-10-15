--- Motor utilizado: PostgreSQL 18

--SECCION 1: DROP TABLES

DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;


--SECCION 2: CREATE TABLES

CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);

CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    ciudad VARCHAR(50),
    fecha_registro DATE NOT NULL
);

CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria INT,
    precio_unitario DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    cantidad INT NOT NULL,
    fecha_venta DATE NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);



-- SECCIÓN 3: INSERT DATA

-- Carga en categorias


INSERT INTO categorias (id_categoria, nombre_categoria, descripcion) VALUES
  (1, 'Computación',    'Laptops, PCs y monitores'),
  (2, 'Accesorios',     'Periféricos y complementos'),
  (3, 'Audio',          'Auriculares y parlantes'),
  (4, 'Almacenamiento', 'Discos y memorias');


-- Carga en clientes

INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro) VALUES
  (1, 'María López',  'maria@mail.com',  'Buenos Aires', '2024-01-05'),
  (2, 'Carlos Ruiz',  'carlos@mail.com', 'Córdoba',      '2024-01-10'),
  (3, 'Ana Gómez',    'ana@mail.com',    'Rosario',      '2024-02-01'),
  (4, 'Pedro Sanz',   'pedro@mail.com',  'Mendoza',      '2024-02-15'),
  (5, 'Laura Torres', 'laura@mail.com',  'Tucumán',      '2024-03-01');
  
  
-- Carga en productos 

INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio_unitario, stock, activo) VALUES

  (1, 'Laptop Pro 15',      1, 1200.00, 15, TRUE),
  (2, 'Mouse Inalámbrico',  2,   28.00, 80, TRUE),
  (3, 'Monitor 4K 27',      1,  450.00, 12, TRUE),
  (4, 'Auriculares BT Pro', 3,  120.00, 35, TRUE),
  (5, 'SSD Externo 1TB',    4,  130.00, 18, TRUE),
  (6, 'Teclado Mecánico',   2,   95.00, 40, TRUE);
  (7, 'Accesorio USB C',     4,   12.50, 10, TRUE),
  (8, 'Soporte de Notebook', 2,   35.00, 15, TRUE);


-- Carga en ventas

INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, fecha_venta, precio_unitario) VALUES
  ( 1, 1, 1, 2, '2024-03-05', 2400.00),
  ( 2, 2, 2, 5, '2024-03-06',  140.00),
  ( 3, 3, 3, 1, '2024-03-07',  450.00),
  ( 4, 1, 4, 2, '2024-03-08',  240.00),
  ( 5, 4, 5, 3, '2024-03-10',  390.00),
  ( 6, 2, 6, 4, '2024-03-11',  380.00),
  ( 7, 5, 1, 1, '2024-03-12', 1200.00),
  ( 8, 3, 2, 8, '2024-03-13',  224.00),
  ( 9, 4, 4, 1, '2024-03-14',  120.00),
  (10, 5, 3, 2, '2024-03-15',  900.00);


-- SECCIÓN 4: VALIDACIÓN

SELECT * FROM categorias;
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;


INSERT INTO clientes (id_cliente, nombre, email, fecha_registro, ciudad)
VALUES 
    (7, 'Laura Gómez', 'laura.gomez@test.com', '2024-03-01', 'Córdoba'),
    (8, 'Martín Silva', 'martin.silva@test.com', '2024-03-15', 'Rosario');



--ENTREGABLE 5


--Consulta 1 -- Vista base del proyecto

SELECT 
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.id_producto,
    p.nombre_producto,
    p.id_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c 
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p 
    ON v.id_producto = p.id_producto
ORDER BY v.fecha_venta ASC;


--Consulta 2 --Clientes sin ventas

SELECT 
    c.id_cliente,
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v 
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.fecha_registro;

--Consulta 3 — Productos sin ventas

SELECT 
    p.id_producto,
    p.nombre_producto,
    p.id_categoria,
    p.precio_unitario
FROM productos AS p
LEFT JOIN ventas AS v 
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY p.nombre_producto;


--Consulta 4 --Consolidado por canal 

SELECT canal, SUM(total) AS total_canal
FROM (
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Online' AS canal
    FROM ventas 
    WHERE id_venta % 2 = 0
    UNION ALL
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Presencial' AS canal
    FROM ventas 
    WHERE id_venta % 2 <> 0
) AS consolidado
GROUP BY canal;









