-- =============================================
-- BD2 - Trabajo Práctico N° 5
-- Tecnicatura Universitaria en Programación
-- Base de Datos II
-- Funciones de Resumen sobre BDArchivos
-- =============================================

USE BDArchivos;
GO

-- =============================================
-- PUNTO 1
-- Cantidad de archivos con extensión zip.
-- =============================================
SELECT COUNT(*) AS CantidadArchivosZip
FROM Archivos
WHERE Extension = 'zip';
GO

-- =============================================
-- PUNTO 2
-- Cantidad de archivos que fueron modificados
-- (FechaUltimaModificacion distinta a FechaCreacion).
-- =============================================
SELECT COUNT(*) AS CantidadModificados
FROM Archivos
WHERE FechaUltimaModificacion <> FechaCreacion;
GO

-- =============================================
-- PUNTO 3
-- Fecha de creación más antigua de los archivos pdf.
-- =============================================
SELECT MIN(FechaCreacion) AS FechaCreacionMasAntigua
FROM Archivos
WHERE Extension = 'pdf';
GO

-- =============================================
-- PUNTO 4
-- Cantidad de extensiones distintas cuyos archivos
-- tengan 'Informe' o 'Documento' en el nombre o descripción.
-- =============================================
SELECT COUNT(DISTINCT Extension) AS CantidadExtensiones
FROM Archivos
WHERE Nombre      LIKE '%Informe%'
   OR Nombre      LIKE '%Documento%'
   OR Descripcion LIKE '%Informe%'
   OR Descripcion LIKE '%Documento%';
GO

-- =============================================
-- PUNTO 5
-- Promedio de tamaño en MB de archivos con extensión
-- 'doc', 'docx', 'xls' o 'xlsx'.
-- 1 MB = 1.048.576 bytes
-- =============================================
SELECT CAST(AVG(CAST([Tamaño] AS FLOAT) / 1048576.0) AS DECIMAL(10, 2)) AS PromedioTamañoMB
FROM Archivos
WHERE Extension IN ('doc', 'docx', 'xls', 'xlsx');
GO

-- =============================================
-- PUNTO 6
-- Cantidad de archivos compartidos con el usuario de apellido 'Clarck'.
-- =============================================
SELECT COUNT(*) AS CantidadArchivosCompartidos
FROM ArchivosCompartidos ac
INNER JOIN Usuarios u ON ac.IDUsuario = u.IDUsuario
WHERE u.Apellido = 'Clarck';
GO

-- =============================================
-- PUNTO 7
-- Cantidad de tipos de usuario distintos que tienen usuarios dueños
-- de archivos con extensión pdf.
-- =============================================
SELECT COUNT(DISTINCT u.IDTipoUsuario) AS CantidadTiposUsuario
FROM Archivos a
INNER JOIN Usuarios u ON a.[IDUsuarioDueño] = u.IDUsuario
WHERE a.Extension = 'pdf';
GO

-- =============================================
-- PUNTO 8
-- Tamaño máximo en MB de los archivos creados en 2024.
-- =============================================
SELECT CAST(MAX([Tamaño]) / 1048576.0 AS DECIMAL(10, 2)) AS TamañoMaximoMB
FROM Archivos
WHERE YEAR(FechaCreacion) = 2024;
GO

-- =============================================
-- PUNTO 9
-- Por cada tipo de usuario: nombre del tipo y cantidad de usuarios
-- distintos que son dueños de archivos con extensión pdf.
-- =============================================
SELECT
    tu.TipoUsuario,
    COUNT(DISTINCT u.IDUsuario) AS CantidadUsuarios
FROM TiposUsuario tu
INNER JOIN Usuarios  u ON tu.IDTipoUsuario   = u.IDTipoUsuario
INNER JOIN Archivos  a ON u.IDUsuario        = a.[IDUsuarioDueño]
WHERE a.Extension = 'pdf'
GROUP BY tu.IDTipoUsuario, tu.TipoUsuario;
GO

-- =============================================
-- PUNTO 10
-- Por cada dueño: nombre, apellido y suma del tamaño
-- de los archivos que tiene compartidos con otros usuarios.
-- EXISTS evita contar varias veces archivos compartidos con múltiples usuarios.
-- Ordenado de mayor a menor sumatoria.
-- =============================================
SELECT
    u.Nombre,
    u.Apellido,
    SUM(a.[Tamaño]) AS TotalTamañoBytes
FROM Archivos a
INNER JOIN Usuarios u ON a.[IDUsuarioDueño] = u.IDUsuario
WHERE EXISTS (
    SELECT 1 FROM ArchivosCompartidos ac WHERE ac.IDArchivo = a.IDArchivo
)
GROUP BY u.IDUsuario, u.Nombre, u.Apellido
ORDER BY TotalTamañoBytes DESC;
GO

-- =============================================
-- PUNTO 11
-- Por cada tipo de archivo: nombre del tipo y promedio
-- de tamaño en bytes de sus archivos.
-- =============================================
SELECT
    ta.TipoArchivo,
    CAST(AVG(CAST(a.[Tamaño] AS FLOAT)) AS DECIMAL(18, 2)) AS PromedioTamañoBytes
FROM TiposArchivos ta
INNER JOIN Archivos a ON ta.IDTipoArchivo = a.IDTipoArchivo
GROUP BY ta.IDTipoArchivo, ta.TipoArchivo;
GO

-- =============================================
-- PUNTO 12
-- Por cada extensión: extensión, cantidad de archivos
-- y total acumulado en bytes.
-- Ordenado por cantidad de archivos ASC.
-- =============================================
SELECT
    Extension,
    COUNT(*)       AS CantidadArchivos,
    SUM([Tamaño])  AS TotalBytes
FROM Archivos
GROUP BY Extension
ORDER BY CantidadArchivos ASC;
GO

-- =============================================
-- PUNTO 13
-- Por cada usuario: IDUsuario, Apellido, Nombre y suma total
-- en bytes de los archivos que posee.
-- Si no tiene archivos, se muestra 0 (LEFT JOIN + ISNULL).
-- =============================================
SELECT
    u.IDUsuario,
    u.Apellido,
    u.Nombre,
    ISNULL(SUM(a.[Tamaño]), 0) AS TotalBytes
FROM Usuarios u
LEFT JOIN Archivos a ON u.IDUsuario = a.[IDUsuarioDueño]
GROUP BY u.IDUsuario, u.Apellido, u.Nombre;
GO

-- =============================================
-- PUNTO 14
-- Tipos de archivo que fueron compartidos más de una vez
-- con el permiso 'Lectura'.
-- =============================================
SELECT ta.TipoArchivo
FROM TiposArchivos ta
INNER JOIN Archivos            a  ON ta.IDTipoArchivo = a.IDTipoArchivo
INNER JOIN ArchivosCompartidos ac ON a.IDArchivo      = ac.IDArchivo
INNER JOIN Permisos            p  ON ac.IDPermiso     = p.IDPermiso
WHERE p.Nombre = 'Lectura'
GROUP BY ta.IDTipoArchivo, ta.TipoArchivo
HAVING COUNT(*) > 1;
GO

-- =============================================
-- PUNTO 15
-- Por cada tipo de archivo: nombre del tipo y tamaño
-- del archivo más pesado de ese tipo.
-- =============================================
SELECT
    ta.TipoArchivo,
    MAX(a.[Tamaño]) AS TamañoMaximoBytes
FROM TiposArchivos ta
INNER JOIN Archivos a ON ta.IDTipoArchivo = a.IDTipoArchivo
GROUP BY ta.IDTipoArchivo, ta.TipoArchivo;
GO

-- =============================================
-- PUNTO 16
-- Por cada tipo de archivo: nombre y promedio de tamaño en MB.
-- Solo los tipos cuyo promedio supere los 50 MB.
-- 50 MB = 52.428.800 bytes → se filtra con HAVING sobre el promedio en MB.
-- =============================================
SELECT
    ta.TipoArchivo,
    CAST(AVG(CAST(a.[Tamaño] AS FLOAT) / 1048576.0) AS DECIMAL(10, 2)) AS PromedioTamañoMB
FROM TiposArchivos ta
INNER JOIN Archivos a ON ta.IDTipoArchivo = a.IDTipoArchivo
GROUP BY ta.IDTipoArchivo, ta.TipoArchivo
HAVING AVG(CAST(a.[Tamaño] AS FLOAT) / 1048576.0) >= 50;
GO

-- =============================================
-- PUNTO 17
-- Extensiones con más de 2 archivos que no hayan sido compartidos.
-- NOT EXISTS descarta los archivos que aparecen en ArchivosCompartidos.
-- =============================================
SELECT   Extension
FROM     Archivos a
WHERE    NOT EXISTS (
             SELECT 1 FROM ArchivosCompartidos ac WHERE ac.IDArchivo = a.IDArchivo
         )
GROUP BY Extension
HAVING   COUNT(*) > 2;
GO
