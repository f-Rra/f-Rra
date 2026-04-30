-- =============================================
-- BD2 - Trabajo Práctico N° 3
-- Tecnicatura Universitaria en Programación
-- Base de Datos II
-- Consultas de Selección sobre BDArchivos
-- =============================================

USE BDArchivos;
GO

-- =============================================
-- PUNTO 1
-- Todos los usuarios indicando Apellido, Nombre.
-- =============================================
SELECT Apellido, Nombre
FROM Usuarios;
GO

-- =============================================
-- PUNTO 2
-- Todos los usuarios con formato [Apellido], [Nombre]
-- ordenados por Apellido de forma descendente.
-- =============================================
SELECT Apellido + ', ' + Nombre AS [Apellido, Nombre]
FROM Usuarios
ORDER BY Apellido DESC;
GO

-- =============================================
-- PUNTO 3
-- Usuarios cuyo IDTipoUsuario sea 5 (Suscripción Empresarial).
-- =============================================
SELECT Nombre, Apellido
FROM Usuarios
WHERE IDTipoUsuario = 5;
GO

-- =============================================
-- PUNTO 4
-- El último usuario en orden alfabético (por Apellido y luego Nombre).
-- Se usa TOP 1 con ORDER BY descendente.
-- =============================================
SELECT TOP 1 IDUsuario, Apellido, Nombre
FROM Usuarios
ORDER BY Apellido DESC, Nombre DESC;
GO

-- =============================================
-- PUNTO 5
-- Archivos cuyo año de creación haya sido 2021.
-- =============================================
SELECT Nombre, Extension, FechaCreacion
FROM Archivos
WHERE YEAR(FechaCreacion) = 2021;
GO

-- =============================================
-- PUNTO 6
-- Todos los usuarios con columna concatenada ApellidoYNombre,
-- en orden alfabético.
-- =============================================
SELECT Apellido + ', ' + Nombre AS ApellidoYNombre
FROM Usuarios
ORDER BY Apellido ASC, Nombre ASC;
GO

-- =============================================
-- PUNTO 7
-- Todos los archivos indicando Nombre, Extensión, FechaCreacion
-- y una columna Semestre ('Primer Semestre' o 'Segundo Semestre').
-- =============================================
SELECT
    Nombre,
    Extension,
    FechaCreacion,
    CASE
        WHEN MONTH(FechaCreacion) BETWEEN 1 AND 6 THEN 'Primer Semestre'
        ELSE 'Segundo Semestre'
    END AS Semestre
FROM Archivos;
GO

-- =============================================
-- PUNTO 8
-- Ídem al punto 7, ordenado por Semestre y FechaCreacion.
-- =============================================
SELECT
    Nombre,
    Extension,
    FechaCreacion,
    CASE
        WHEN MONTH(FechaCreacion) BETWEEN 1 AND 6 THEN 'Primer Semestre'
        ELSE 'Segundo Semestre'
    END AS Semestre
FROM Archivos
ORDER BY
    CASE
        WHEN MONTH(FechaCreacion) BETWEEN 1 AND 6 THEN 1
        ELSE 2
    END,
    FechaCreacion;
GO

-- =============================================
-- PUNTO 9
-- Extensiones de los archivos, sin repetir.
-- =============================================
SELECT DISTINCT Extension
FROM Archivos;
GO

-- =============================================
-- PUNTO 10
-- Archivos no eliminados: IDArchivo, IDUsuarioDueño,
-- FechaCreacion y Tamaño. Del más reciente al más antiguo.
-- =============================================
SELECT IDArchivo, [IDUsuarioDueño], FechaCreacion, [Tamaño]
FROM Archivos
WHERE Eliminado = 0
ORDER BY FechaCreacion DESC;
GO

-- =============================================
-- PUNTO 11
-- Archivos eliminados cuyo Tamaño esté entre 40960 y 204800.
-- Todas las columnas.
-- =============================================
SELECT *
FROM Archivos
WHERE Eliminado = 1
  AND [Tamaño] BETWEEN 40960 AND 204800;
GO

-- =============================================
-- PUNTO 12
-- Meses en los que se crearon archivos entre 2020 y 2022,
-- sin repetir.
-- =============================================
SELECT DISTINCT MONTH(FechaCreacion) AS Mes
FROM Archivos
WHERE YEAR(FechaCreacion) BETWEEN 2020 AND 2022
ORDER BY Mes;
GO

-- =============================================
-- PUNTO 13
-- IDs de dueños de archivos que no fueron modificados
-- (FechaUltimaModificacion = FechaCreacion) y no están eliminados.
-- Sin repetir.
-- =============================================
SELECT DISTINCT [IDUsuarioDueño]
FROM Archivos
WHERE FechaUltimaModificacion = FechaCreacion
  AND Eliminado = 0;
GO

-- =============================================
-- PUNTO 14
-- Todos los datos de archivos cuyos dueños sean los usuarios
-- con ID 1, 3, 5, 8 o 9. Ordenado por IDUsuarioDueño y Tamaño ASC.
-- =============================================
SELECT *
FROM Archivos
WHERE [IDUsuarioDueño] IN (1, 3, 5, 8, 9)
ORDER BY [IDUsuarioDueño] ASC, [Tamaño] ASC;
GO

-- =============================================
-- PUNTO 15
-- Los tres archivos de menor Tamaño que no estén eliminados.
-- =============================================
SELECT TOP 3 *
FROM Archivos
WHERE Eliminado = 0
ORDER BY [Tamaño] ASC;
GO

-- =============================================
-- PUNTO 16
-- Archivos que cumplan:
--   (Eliminados Y FechaUltimaModificacion <= 2021)
--   O (No eliminados Y FechaUltimaModificacion > 2021)
-- Todas las columnas excepto IDUsuarioDueño y FechaCreacion.
-- Ordenado por IDArchivo.
-- =============================================
SELECT
    IDArchivo,
    Nombre,
    Extension,
    Descripcion,
    IDTipoArchivo,
    [Tamaño],
    FechaUltimaModificacion,
    Eliminado
FROM Archivos
WHERE (Eliminado = 1 AND YEAR(FechaUltimaModificacion) <= 2021)
   OR (Eliminado = 0 AND YEAR(FechaUltimaModificacion) > 2021)
ORDER BY IDArchivo;
GO

-- =============================================
-- PUNTO 17
-- Archivos creados en 2023: todas las columnas + DiaSemana (1=Domingo).
-- DESAFÍO: + columna DiaSemanaEnLetras.
-- SET DATEFIRST 7 garantiza que Domingo=1 independientemente
-- de la configuración del servidor.
-- =============================================
SET DATEFIRST 7; -- Domingo = 1

SELECT
    IDArchivo,
    [IDUsuarioDueño],
    Nombre,
    Extension,
    Descripcion,
    IDTipoArchivo,
    [Tamaño],
    FechaCreacion,
    FechaUltimaModificacion,
    Eliminado,
    DATEPART(WEEKDAY, FechaCreacion) AS DiaSemana,
    CASE DATEPART(WEEKDAY, FechaCreacion)
        WHEN 1 THEN 'DOMINGO'
        WHEN 2 THEN 'LUNES'
        WHEN 3 THEN 'MARTES'
        WHEN 4 THEN 'MIERCOLES'
        WHEN 5 THEN 'JUEVES'
        WHEN 6 THEN 'VIERNES'
        WHEN 7 THEN 'SABADO'
    END AS DiaSemanaEnLetras
FROM Archivos
WHERE YEAR(FechaCreacion) = 2023
ORDER BY DiaSemana;
GO

-- =============================================
-- PUNTO 18
-- Archivos no eliminados cuyo mes de creación coincida
-- con el mes actual (función MONTH + GETDATE()).
-- =============================================
SELECT *
FROM Archivos
WHERE Eliminado = 0
  AND MONTH(FechaCreacion) = MONTH(GETDATE());
GO

-- =============================================
-- PUNTO 19 - No figura en el enunciado.
-- =============================================

-- =============================================
-- PUNTO 20
-- Archivos NO creados por usuarios con ID 1, 2, 5, 9 o 10.
-- Indicar IDUsuarioDueño, IDArchivo, FechaCreacion y Tamaño.
-- Ordenado por IDUsuarioDueño.
-- =============================================
SELECT [IDUsuarioDueño], IDArchivo, FechaCreacion, [Tamaño]
FROM Archivos
WHERE [IDUsuarioDueño] NOT IN (1, 2, 5, 9, 10)
ORDER BY [IDUsuarioDueño] ASC;
GO

-- =============================================
-- PUNTO 21
-- Parte A: Usuarios cuyo Apellido comienza con 'J'.
-- Parte B: Usuarios cuyo Apellido comienza con 'J' y Nombre con 'E'.
-- Ambas ordenadas por IDUsuario.
-- =============================================

-- Parte A
SELECT *
FROM Usuarios
WHERE Apellido LIKE 'J%'
ORDER BY IDUsuario;

-- Parte B
SELECT *
FROM Usuarios
WHERE Apellido LIKE 'J%'
  AND Nombre   LIKE 'E%'
ORDER BY IDUsuario;
GO

-- =============================================
-- PUNTO 22
-- Archivos con el mayor Tamaño.
-- En caso de empate, se listan todos.
-- =============================================
SELECT *
FROM Archivos
WHERE [Tamaño] = (SELECT MAX([Tamaño]) FROM Archivos);
GO
