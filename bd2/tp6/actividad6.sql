-- =============================================
-- BD2 - Trabajo Práctico N° 6
-- Tecnicatura Universitaria en Programación
-- Base de Datos II
-- Subconsultas sobre BDArchivos
-- =============================================

USE BDArchivos;
GO

-- =============================================
-- PUNTO 1
-- Nombre, extensión y tamaño en MB de los archivos
-- que pesen más que el promedio de todos los archivos.
-- =============================================
SELECT
    Nombre,
    Extension,
    CAST([Tamaño] / 1048576.0 AS DECIMAL(10, 2)) AS TamañoMB
FROM Archivos
WHERE [Tamaño] > (
    SELECT AVG(CAST([Tamaño] AS FLOAT)) FROM Archivos
);
GO

-- =============================================
-- PUNTO 2
-- Usuarios que NO son dueños de ningún archivo con extensión 'zip'.
-- =============================================
SELECT Apellido, Nombre
FROM Usuarios
WHERE IDUsuario NOT IN (
    SELECT DISTINCT [IDUsuarioDueño]
    FROM Archivos
    WHERE Extension = 'zip'
);
GO

-- =============================================
-- PUNTO 3
-- Usuarios (con tipo) que no hayan creado ni modificado
-- ningún archivo en el año actual.
-- =============================================
SELECT u.IDUsuario, u.Apellido, u.Nombre, tu.TipoUsuario
FROM Usuarios u
INNER JOIN TiposUsuario tu ON u.IDTipoUsuario = tu.IDTipoUsuario
WHERE u.IDUsuario NOT IN (
    SELECT DISTINCT [IDUsuarioDueño]
    FROM Archivos
    WHERE YEAR(FechaCreacion)           = YEAR(GETDATE())
       OR YEAR(FechaUltimaModificacion) = YEAR(GETDATE())
);
GO

-- =============================================
-- PUNTO 4
-- Tipos de usuario que NO tienen usuarios con archivos eliminados.
-- =============================================
SELECT TipoUsuario
FROM TiposUsuario
WHERE IDTipoUsuario NOT IN (
    SELECT DISTINCT u.IDTipoUsuario
    FROM Usuarios u
    INNER JOIN Archivos a ON u.IDUsuario = a.[IDUsuarioDueño]
    WHERE a.Eliminado = 1
);
GO

-- =============================================
-- PUNTO 5
-- Tipos de archivo que NO fueron compartidos con permiso 'Lectura'.
-- =============================================
SELECT TipoArchivo
FROM TiposArchivos
WHERE IDTipoArchivo NOT IN (
    SELECT DISTINCT a.IDTipoArchivo
    FROM Archivos a
    INNER JOIN ArchivosCompartidos ac ON a.IDArchivo  = ac.IDArchivo
    INNER JOIN Permisos            p  ON ac.IDPermiso = p.IDPermiso
    WHERE p.Nombre = 'Lectura'
);
GO

-- =============================================
-- PUNTO 6
-- Nombre y extensión de archivos con tamaño mayor
-- al del archivo 'xls' más grande.
-- =============================================
SELECT Nombre, Extension
FROM Archivos
WHERE [Tamaño] > (
    SELECT MAX([Tamaño]) FROM Archivos WHERE Extension = 'xls'
);
GO

-- =============================================
-- PUNTO 7
-- Nombre y extensión de archivos con tamaño mayor
-- al del archivo 'zip' más pequeño.
-- =============================================
SELECT Nombre, Extension
FROM Archivos
WHERE [Tamaño] > (
    SELECT MIN([Tamaño]) FROM Archivos WHERE Extension = 'zip'
);
GO

-- =============================================
-- PUNTO 8
-- Por cada tipo de archivo: tipo, cantidad de eliminados
-- y cantidad de no eliminados.
-- LEFT JOIN incluye tipos sin archivos (mostraría 0 en ambos).
-- =============================================
SELECT
    ta.TipoArchivo,
    ISNULL(SUM(CASE WHEN a.Eliminado = 1 THEN 1 ELSE 0 END), 0) AS CantidadEliminados,
    ISNULL(SUM(CASE WHEN a.Eliminado = 0 THEN 1 ELSE 0 END), 0) AS CantidadNoEliminados
FROM TiposArchivos ta
LEFT JOIN Archivos a ON ta.IDTipoArchivo = a.IDTipoArchivo
GROUP BY ta.IDTipoArchivo, ta.TipoArchivo;
GO

-- =============================================
-- PUNTO 9
-- Por cada usuario: IDUsuario, apellido, nombre,
-- cantidad de archivos pequeños (< 20 MB) y grandes (>= 20 MB).
-- 20 MB = 20.971.520 bytes
-- =============================================
SELECT
    u.IDUsuario,
    u.Apellido,
    u.Nombre,
    ISNULL(SUM(CASE WHEN a.[Tamaño] <  20971520 THEN 1 ELSE 0 END), 0) AS CantidadPequenos,
    ISNULL(SUM(CASE WHEN a.[Tamaño] >= 20971520 THEN 1 ELSE 0 END), 0) AS CantidadGrandes
FROM Usuarios u
LEFT JOIN Archivos a ON u.IDUsuario = a.[IDUsuarioDueño]
GROUP BY u.IDUsuario, u.Apellido, u.Nombre;
GO

-- =============================================
-- PUNTO 10
-- Por cada usuario: IDUsuario, apellido, nombre
-- y cantidad de archivos creados en 2022, 2023 y 2024.
-- =============================================
SELECT
    u.IDUsuario,
    u.Apellido,
    u.Nombre,
    SUM(CASE WHEN YEAR(a.FechaCreacion) = 2022 THEN 1 ELSE 0 END) AS Archivos2022,
    SUM(CASE WHEN YEAR(a.FechaCreacion) = 2023 THEN 1 ELSE 0 END) AS Archivos2023,
    SUM(CASE WHEN YEAR(a.FechaCreacion) = 2024 THEN 1 ELSE 0 END) AS Archivos2024
FROM Usuarios u
LEFT JOIN Archivos a ON u.IDUsuario = a.[IDUsuarioDueño]
GROUP BY u.IDUsuario, u.Apellido, u.Nombre;
GO

-- =============================================
-- PUNTO 11
-- Archivos compartidos con permiso 'Comentario'
-- pero NO con permiso 'Lectura'.
-- =============================================
SELECT Nombre, Extension
FROM Archivos
WHERE IDArchivo IN (
    SELECT ac.IDArchivo
    FROM ArchivosCompartidos ac
    INNER JOIN Permisos p ON ac.IDPermiso = p.IDPermiso
    WHERE p.Nombre = 'Comentario'
)
AND IDArchivo NOT IN (
    SELECT ac.IDArchivo
    FROM ArchivosCompartidos ac
    INNER JOIN Permisos p ON ac.IDPermiso = p.IDPermiso
    WHERE p.Nombre = 'Lectura'
);
GO

-- =============================================
-- PUNTO 12
-- Tipos de archivo con más archivos eliminados que no eliminados.
-- =============================================
SELECT ta.TipoArchivo
FROM TiposArchivos ta
INNER JOIN Archivos a ON ta.IDTipoArchivo = a.IDTipoArchivo
GROUP BY ta.IDTipoArchivo, ta.TipoArchivo
HAVING
    SUM(CASE WHEN a.Eliminado = 1 THEN 1 ELSE 0 END) >
    SUM(CASE WHEN a.Eliminado = 0 THEN 1 ELSE 0 END);
GO

-- =============================================
-- PUNTO 13
-- Usuarios con más archivos pequeños (< 20 MB) que grandes (>= 20 MB),
-- pero que tengan al menos uno de cada tipo.
-- =============================================
SELECT u.IDUsuario, u.Apellido, u.Nombre
FROM Usuarios u
INNER JOIN Archivos a ON u.IDUsuario = a.[IDUsuarioDueño]
GROUP BY u.IDUsuario, u.Apellido, u.Nombre
HAVING
    SUM(CASE WHEN a.[Tamaño] <  20971520 THEN 1 ELSE 0 END) >= 1
    AND SUM(CASE WHEN a.[Tamaño] >= 20971520 THEN 1 ELSE 0 END) >= 1
    AND SUM(CASE WHEN a.[Tamaño] <  20971520 THEN 1 ELSE 0 END) >
        SUM(CASE WHEN a.[Tamaño] >= 20971520 THEN 1 ELSE 0 END);
GO

-- =============================================
-- PUNTO 14
-- Usuarios que crearon más archivos en 2022 que en 2023,
-- y más en 2023 que en 2024.
-- =============================================
SELECT u.IDUsuario, u.Apellido, u.Nombre
FROM Usuarios u
INNER JOIN Archivos a ON u.IDUsuario = a.[IDUsuarioDueño]
GROUP BY u.IDUsuario, u.Apellido, u.Nombre
HAVING
    SUM(CASE WHEN YEAR(a.FechaCreacion) = 2022 THEN 1 ELSE 0 END) >
    SUM(CASE WHEN YEAR(a.FechaCreacion) = 2023 THEN 1 ELSE 0 END)
    AND
    SUM(CASE WHEN YEAR(a.FechaCreacion) = 2023 THEN 1 ELSE 0 END) >
    SUM(CASE WHEN YEAR(a.FechaCreacion) = 2024 THEN 1 ELSE 0 END);
GO
