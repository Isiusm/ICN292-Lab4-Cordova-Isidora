DROP DATABASE IF EXISTS austral;

CREATE DATABASE austral;

USE austral;

SELECT DATABASE();

CREATE TABLE autores (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    pais VARCHAR(60),
    genero ENUM('Cómic', 'Ensayo', 'Infantil', 'Novela', 'Poesía') NOT NULL
);

CREATE TABLE colecciones (
    id_coleccion INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(120) NOT NULL,
    fecha_publicacion DATE NOT NULL
);

CREATE TABLE libros (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    id_autor INT,
    id_coleccion INT,
    titulo VARCHAR(120) NOT NULL,
    paginas INT,
    ejemplares_vendidos INT,
    anio INT,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
    FOREIGN KEY (id_coleccion) REFERENCES colecciones(id_coleccion)
);

CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_autor INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);
SHOW TABLES;

INSERT INTO autores (nombre, pais, genero)
VALUES
('Elena Pizarro', 'Chile', 'Novela'),
('Harold Finch', 'Inglaterra', 'Ensayo'),
('Rodrigo Bahamonde', 'Chile', 'Poesía'),
('Valentina Correa', 'Argentina', 'Infantil'),
('Nora Keller', 'Estados Unidos', 'Novela'),
('Kenji Arakawa', NULL, 'Cómic');
SELECT * FROM autores;

INSERT INTO libros (id_autor, titulo, paginas, ejemplares_vendidos, anio)
VALUES
(1, 'Cielo de Enero', 210, 1500, 2024),
(1, 'Marea Baja', 185, 800, 2023),
(1, 'El Norte', 200, 2200, 2024),
(2, 'Estrellas que Caen', 240, 3000, 2022),
(2, 'Máquinas', 215, 450, 2024),
(3, 'Luz Artificial', 300, 1200, 2024),
(3, 'Ruido Blanco', 280, 600, 2023),
(4, 'El Barrio de Lila', 190, 5000, 2024),
(4, 'Antes del Amanecer', 205, 2700, 2024),
(4, 'La Calle 8', 175, 900, 2023),
(5, 'Flor de Hierro', 195, 4100, 2024),
(5, 'Hora Dorada', 220, 1800, 2022);
SELECT * FROM libros;
SELECT SUM(ejemplares_vendidos) AS total_vendidos
FROM libros;

SELECT nombre, genero
FROM autores
WHERE pais <> 'Chile' OR pais IS NULL
ORDER BY nombre ASC;

SELECT titulo, paginas
FROM libros
WHERE paginas BETWEEN 190 AND 220
ORDER BY paginas ASC;

SELECT
    COUNT(*) AS total_libros,
    SUM(ejemplares_vendidos) AS total_vendidos,
    AVG(paginas) AS promedio_paginas,
    MIN(anio) AS anio_mas_antiguo,
    MAX(ejemplares_vendidos) AS mayor_venta
FROM libros;

SELECT DISTINCT genero
FROM autores
ORDER BY genero ASC;

SELECT a.nombre, COUNT(*) AS cantidad_libros
FROM autores a
JOIN libros l ON a.id_autor = l.id_autor
WHERE l.anio = 2024
GROUP BY a.id_autor, a.nombre
HAVING COUNT(*) > 1
ORDER BY a.nombre ASC;

SELECT titulo, ejemplares_vendidos
FROM libros
WHERE anio = 2024
AND ejemplares_vendidos > 2000
ORDER BY ejemplares_vendidos DESC
LIMIT 3;

INSERT INTO libros
(id_autor, id_coleccion, titulo, paginas, ejemplares_vendidos, anio)
VALUES
(3, NULL, 'Papel Mojado', 260, 50, 2024);
SELECT *
FROM libros
WHERE titulo = 'Papel Mojado';

DELETE FROM libros
WHERE titulo = 'Papel Mojado';
SELECT *
FROM libros
WHERE titulo = 'Papel Mojado';

SELECT titulo, ejemplares_vendidos
FROM libros
WHERE titulo = 'Cielo de Enero';

UPDATE libros
SET ejemplares_vendidos = 1500
WHERE titulo = 'Cielo de Enero';
UPDATE libros
SET ejemplares_vendidos = ejemplares_vendidos + 100
WHERE titulo = 'Cielo de Enero';

INSERT INTO colecciones (titulo, fecha_publicacion)
VALUES
('Voces del Sur', '2020-03-15'),
('Horizontes Literarios', '2022-08-20');
SELECT * FROM colecciones;

UPDATE libros
SET id_coleccion = 1
WHERE id_libro BETWEEN 1 AND 6;

UPDATE libros
SET id_coleccion = 2
WHERE id_libro BETWEEN 7 AND 12;

SELECT id_libro, titulo, id_coleccion
FROM libros
ORDER BY id_libro;

SELECT
    libros.titulo AS titulo_libro,
    colecciones.titulo AS titulo_coleccion,
    colecciones.fecha_publicacion
FROM libros
INNER JOIN colecciones
ON libros.id_coleccion = colecciones.id_coleccion
ORDER BY libros.id_libro;

INSERT INTO pagos (id_autor, fecha_pago, monto)
VALUES
(1, '2026-01-15', 150000.00),
(1, '2026-06-15', 200000.00),
(2, '2026-03-10', 175000.00);
SELECT * FROM pagos;

SELECT
    autores.nombre,
    pagos.fecha_pago,
    pagos.monto
FROM pagos
INNER JOIN autores
ON pagos.id_autor = autores.id_autor
ORDER BY autores.nombre;

SELECT
    autores.nombre,
    SUM(pagos.monto) AS total_pagado
FROM autores
INNER JOIN pagos
ON autores.id_autor = pagos.id_autor
GROUP BY autores.id_autor, autores.nombre
ORDER BY autores.nombre;