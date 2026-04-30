-- =============================================
-- BD2 - Trabajo Práctico N° 4
-- Tecnicatura Universitaria en Programación
-- Base de Datos II
-- Consultas de Selección con JOINs sobre BDArchivos
-- =============================================

USE BDArchivos;
GO

-- =============================================
-- PUNTO 1
-- Por cada usuario: nombre, apellido y tipo de usuario.
-- =============================================
SELECT u.Nombre, u.Apellido, tu.TipoUsuario
FROM Usuarios u
INNER JOIN TiposUsuario tu ON u.IDTipoUsuario = tu.IDTipoUsuario;
GO

-- =============================================
-- PUNTO 2
-- ID, nombre, apellido y tipo de usuario de los usuarios
-- de tipo 'Suscripción Free' o 'Suscripción Básica'.
-- =============================================
SELECT u.IDUsuario, u.Nombre, u.Apellido, tu.TipoUsuario
FROM Usuarios u
INNER JOIN TiposUsuario tu ON u.IDTipoUsuario = tu.IDTipoUsuario
WHERE tu.TipoUsuario IN ('Suscripción Free', 'Suscripción Básica');
GO

-- =============================================
-- PUNTO 3
-- Nombre de archivo, extensión, tamaño en MB y tipo de archivo.
-- 1 MB = 1.048.576 bytes (binario, confirmado por el enunciado)
-- =============================================
SELECT
    a.Nombre,
    a.Extension,
    CAST(a.[Tamaño] / 1048576.0 AS DECIMAL(10, 2)) AS TamañoMB,
    ta.TipoArchivo
FROM Archivos a
INNER JOIN TiposArchivos ta ON a.IDTipoArchivo = ta.IDTipoArchivo;
GO

-- =============================================
-- PUNTO 4
-- Nombre de archivo con formato 'Nombre.extension'
-- solo para tipos que contengan: ZIP, Word, Excel, JavaScript o GIF.
-- =============================================
SELECT a.Nombre + '.' + a.Extension AS NombreCompleto
FROM Archivos a
INNER JOIN TiposArchivos ta ON a.IDTipoArchivo = ta.IDTipoArchivo
WHERE ta.TipoArchivo LIKE '%ZIP%'
   OR ta.TipoArchivo LIKE '%Word%'
   OR ta.TipoArchivo LIKE '%Excel%'
   OR ta.TipoArchivo LIKE '%JavaScript%'
   OR ta.TipoArchivo LIKE '%GIF%';
GO

-- =============================================
-- PUNTO 5
-- Nombre, extensión, tamaño en MB y fecha de creación
-- de los archivos cuyo dueño sea Michael Williams.
-- =============================================
SELECT
    a.Nombre,
    a.Extension,
    CAST(a.[Tamaño] / 1048576.0 AS DECIMAL(10, 2)) AS TamañoMB,
    a.FechaCreacion
FROM Archivos a
INNER JOIN Usuarios u ON a.[IDUsuarioDueño] = u.IDUsuario
WHERE u.Nombre = 'Michael' AND u.Apellido = 'Williams';
GO

-- =============================================
-- PUNTO 6
-- Datos completos del archivo más pesado de Michael Williams.
-- Si hay empate, se listan todos.
-- =============================================
SELECT a.*
FROM Archivos a
INNER JOIN Usuarios u ON a.[IDUsuarioDueño] = u.IDUsuario
WHERE u.Nombre = 'Michael' AND u.Apellido = 'Williams'
  AND a.[Tamaño] = (
      SELECT MAX(a2.[Tamaño])
      FROM   Archivos a2
      INNER JOIN Usuarios u2 ON a2.[IDUsuarioDueño] = u2.IDUsuario
      WHERE  u2.Nombre = 'Michael' AND u2.Apellido = 'Williams'
  );
GO

-- =============================================
-- PUNTO 7
-- Nombre, extensión, tamaño, fechas y dueño de archivos
-- cuya descripción contenga 'empresa' o 'presupuesto'.
-- (La colación CI_AI hace la búsqueda case-insensitive)
-- =============================================
SELECT
    a.Nombre,
    a.Extension,
    a.[Tamaño],
    a.FechaCreacion,
    a.FechaUltimaModificacion,
    u.Apellido,
    u.Nombre AS NombreDueno
FROM Archivos a
INNER JOIN Usuarios u ON a.[IDUsuarioDueño] = u.IDUsuario
WHERE a.Descripcion LIKE '%empresa%'
   OR a.Descripcion LIKE '%presupuesto%';
GO

-- =============================================
-- PUNTO 8
-- Extensiones sin repetir de archivos cuyos dueños tengan
-- tipo 'Suscripción Plus', 'Premium' o 'Empresarial'.
-- =============================================
SELECT DISTINCT a.Extension
FROM Archivos a
INNER JOIN Usuarios     u  ON a.[IDUsuarioDueño]  = u.IDUsuario
INNER JOIN TiposUsuario tu ON u.IDTipoUsuario     = tu.IDTipoUsuario
WHERE tu.TipoUsuario IN ('Suscripción Plus', 'Suscripción Premium', 'Suscripción Empresarial');
GO

-- =============================================
-- PUNTO 9
-- Apellido, nombre del dueño y tamaño de los
-- 3 archivos ZIP más pesados.
-- =============================================
SELECT TOP 3
    u.Apellido,
    u.Nombre,
    a.[Tamaño]
FROM Archivos a
INNER JOIN Usuarios u ON a.[IDUsuarioDueño] = u.IDUsuario
WHERE a.Extension = 'zip'
ORDER BY a.[Tamaño] DESC;
GO

-- =============================================
-- PUNTO 10
-- Nombre, extensión, tamaño en bytes, tipo de archivo,
-- tamaño en la mayor unidad posible y nombre de la unidad.
-- Escala binaria: 1 KB=1024 B, 1 MB=1.048.576 B, 1 GB=1.073.741.824 B
-- Ejemplo: 40.960 bytes → 40 Kilobytes
-- =============================================
SELECT
    a.Nombre,
    a.Extension,
    a.[Tamaño],
    ta.TipoArchivo,
    CASE
        WHEN a.[Tamaño] >= 1073741824 THEN CAST(a.[Tamaño] / 1073741824.0 AS DECIMAL(10, 2))
        WHEN a.[Tamaño] >= 1048576    THEN CAST(a.[Tamaño] / 1048576.0    AS DECIMAL(10, 2))
        WHEN a.[Tamaño] >= 1024       THEN CAST(a.[Tamaño] / 1024.0       AS DECIMAL(10, 2))
        ELSE                               CAST(a.[Tamaño]                 AS DECIMAL(10, 2))
    END AS [Tamaño Calculado],
    CASE
        WHEN a.[Tamaño] >= 1073741824 THEN 'Gigabytes'
        WHEN a.[Tamaño] >= 1048576    THEN 'Megabytes'
        WHEN a.[Tamaño] >= 1024       THEN 'Kilobytes'
        ELSE                               'Bytes'
    END AS Unidad
FROM Archivos a
INNER JOIN TiposArchivos ta ON a.IDTipoArchivo = ta.IDTipoArchivo;
GO

-- =============================================
-- PUNTO 11
-- Nombre y extensión de los archivos que han sido compartidos.
-- INNER JOIN garantiza que solo aparezcan los que tienen
-- al menos un registro en ArchivosCompartidos.
-- =============================================
SELECT DISTINCT a.Nombre, a.Extension
FROM Archivos a
INNER JOIN ArchivosCompartidos ac ON a.IDArchivo = ac.IDArchivo;
GO

-- =============================================
-- PUNTO 12
-- Nombre y extensión de archivos compartidos con usuarios
-- de apellido 'Clarck' o 'Jones'.
-- =============================================
SELECT DISTINCT a.Nombre, a.Extension
FROM Archivos a
INNER JOIN ArchivosCompartidos ac ON a.IDArchivo  = ac.IDArchivo
INNER JOIN Usuarios            u  ON ac.IDUsuario = u.IDUsuario
WHERE u.Apellido IN ('Clarck', 'Jones');
GO

-- =============================================
-- PUNTO 13
-- Nombre, extensión del archivo y datos del usuario
-- con quien se compartió con permiso de 'Escritura'.
-- =============================================
SELECT
    a.Nombre,
    a.Extension,
    u.Apellido,
    u.Nombre AS NombreUsuario
FROM Archivos a
INNER JOIN ArchivosCompartidos ac ON a.IDArchivo  = ac.IDArchivo
INNER JOIN Usuarios            u  ON ac.IDUsuario = u.IDUsuario
INNER JOIN Permisos            p  ON ac.IDPermiso = p.IDPermiso
WHERE p.Nombre = 'Escritura';
GO

-- =============================================
-- PUNTO 14
-- Nombre y extensión de archivos que NO han sido compartidos.
-- LEFT JOIN + filtro IS NULL detecta los sin coincidencia.
-- =============================================
SELECT a.Nombre, a.Extension
FROM Archivos a
LEFT JOIN ArchivosCompartidos ac ON a.IDArchivo = ac.IDArchivo
WHERE ac.IDArchivo IS NULL;
GO

-- =============================================
-- PUNTO 15
-- Apellido y nombre de los dueños que tienen archivos eliminados.
-- =============================================
SELECT DISTINCT u.Apellido, u.Nombre
FROM Archivos a
INNER JOIN Usuarios u ON a.[IDUsuarioDueño] = u.IDUsuario
WHERE a.Eliminado = 1;
GO

-- =============================================
-- PUNTO 16
-- Tipos de suscripción, sin repetir, cuyos usuarios dueños
-- tienen archivos que pesan al menos 120 MB.
-- 120 MB = 120 × 1.048.576 = 125.829.120 bytes
-- =============================================
SELECT DISTINCT tu.TipoUsuario
FROM TiposUsuario tu
INNER JOIN Usuarios  u ON tu.IDTipoUsuario    = u.IDTipoUsuario
INNER JOIN Archivos  a ON u.IDUsuario         = a.[IDUsuarioDueño]
WHERE a.[Tamaño] >= 125829120;
GO

-- =============================================
-- PUNTO 17
-- Dueño, nombre del archivo, extensión, fechas y días
-- transcurridos desde la última modificación.
-- Solo archivos que fueron modificados (FechaUltMod <> FechaCreacion).
-- =============================================
SELECT
    u.Apellido,
    u.Nombre                                                        AS NombreDueno,
    a.Nombre                                                        AS NombreArchivo,
    a.Extension,
    a.FechaCreacion,
    a.FechaUltimaModificacion,
    DATEDIFF(DAY, a.FechaUltimaModificacion, GETDATE())             AS DiasTranscurridos
FROM Archivos a
INNER JOIN Usuarios u ON a.[IDUsuarioDueño] = u.IDUsuario
WHERE a.FechaUltimaModificacion <> a.FechaCreacion;
GO

-- =============================================
-- PUNTO 18
-- Nombre, extensión, tamaño, dueño del archivo,
-- usuario con quien se compartió y permiso otorgado.
-- Se usan dos instancias de Usuarios (alias distintos).
-- =============================================
SELECT
    a.Nombre                AS NombreArchivo,
    a.Extension,
    a.[Tamaño],
    uDueno.Apellido         AS ApellidoDueno,
    uDueno.Nombre           AS NombreDueno,
    uComp.Apellido          AS ApellidoCompartido,
    uComp.Nombre            AS NombreCompartido,
    p.Nombre                AS Permiso
FROM Archivos a
INNER JOIN Usuarios            uDueno ON a.[IDUsuarioDueño] = uDueno.IDUsuario
INNER JOIN ArchivosCompartidos ac     ON a.IDArchivo        = ac.IDArchivo
INNER JOIN Usuarios            uComp  ON ac.IDUsuario       = uComp.IDUsuario
INNER JOIN Permisos            p      ON ac.IDPermiso       = p.IDPermiso;
GO

-- =============================================
-- PUNTO 19
-- Ídem al punto 18, pero solo los registros donde
-- el tipo de usuario del dueño y el del compartido coincidan.
-- =============================================
SELECT
    a.Nombre                AS NombreArchivo,
    a.Extension,
    a.[Tamaño],
    uDueno.Apellido         AS ApellidoDueno,
    uDueno.Nombre           AS NombreDueno,
    uComp.Apellido          AS ApellidoCompartido,
    uComp.Nombre            AS NombreCompartido,
    p.Nombre                AS Permiso
FROM Archivos a
INNER JOIN Usuarios            uDueno ON a.[IDUsuarioDueño] = uDueno.IDUsuario
INNER JOIN ArchivosCompartidos ac     ON a.IDArchivo        = ac.IDArchivo
INNER JOIN Usuarios            uComp  ON ac.IDUsuario       = uComp.IDUsuario
INNER JOIN Permisos            p      ON ac.IDPermiso       = p.IDPermiso
WHERE uDueno.IDTipoUsuario = uComp.IDTipoUsuario;
GO

-- =============================================
-- PUNTO 20
-- Apellido y nombre de los usuarios que son dueños
-- O tienen compartido el archivo 'Documento Legal'.
-- UNION elimina duplicados si algún usuario fuera ambos.
-- =============================================

-- Dueños del archivo
SELECT u.Apellido, u.Nombre
FROM Archivos a
INNER JOIN Usuarios u ON a.[IDUsuarioDueño] = u.IDUsuario
WHERE a.Nombre = 'Documento Legal'

UNION

-- Usuarios con el archivo compartido
SELECT u.Apellido, u.Nombre
FROM Archivos a
INNER JOIN ArchivosCompartidos ac ON a.IDArchivo  = ac.IDArchivo
INNER JOIN Usuarios            u  ON ac.IDUsuario = u.IDUsuario
WHERE a.Nombre = 'Documento Legal';
GO
