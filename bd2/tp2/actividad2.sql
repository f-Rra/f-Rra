-- =============================================
-- BD2 - Trabajo Práctico N° 2
-- Tecnicatura Universitaria en Programación
-- Base de Datos II
-- =============================================

USE BDArchivos;
GO

-- =============================================
-- PUNTO 1 - Inserción de datos
-- Orden respetando integridad referencial:
-- TiposUsuario → Permisos → TiposArchivos → Usuarios → Archivos → ArchivosCompartidos
-- =============================================

-- TiposUsuario (IDs: Free=1, Básica=2, Plus=3, Premium=4, Empresarial=5)
INSERT INTO TiposUsuario (TipoUsuario) VALUES ('Suscripción Free');
INSERT INTO TiposUsuario (TipoUsuario) VALUES ('Suscripción Básica');
INSERT INTO TiposUsuario (TipoUsuario) VALUES ('Suscripción Plus');
INSERT INTO TiposUsuario (TipoUsuario) VALUES ('Suscripción Premium');
INSERT INTO TiposUsuario (TipoUsuario) VALUES ('Suscripción Empresarial');
GO

-- Permisos (IDs: Lectura=1, Comentario=2, Escritura=3, Administrador=4)
INSERT INTO Permisos (Nombre) VALUES ('Lectura');
INSERT INTO Permisos (Nombre) VALUES ('Comentario');
INSERT INTO Permisos (Nombre) VALUES ('Escritura');
INSERT INTO Permisos (Nombre) VALUES ('Administrador');
GO

-- TiposArchivos
-- IDs: PDF=1, JPEG=2, BMP=3, ZIP=4, EXE=5, Word=6, Excel=7, PPT=8, TXT=9,
--      HTML=10, CSS=11, JS=12, XML=13, JSON=14, MP3=15, MP4=16, WAV=17, PNG=18, GIF=19, TAR=20
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Documento PDF');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Imagen JPEG');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Imagen BMP');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Archivo ZIP');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Ejecutable EXE');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Documento Word');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Hoja de Cálculo Excel');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Presentación PowerPoint');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Archivo de Texto TXT');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Archivo HTML');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Archivo CSS');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Archivo JavaScript');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Archivo XML');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Archivo JSON');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Archivo MP3');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Video MP4');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Archivo WAV');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Imagen PNG');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Archivo GIF');
INSERT INTO TiposArchivos (TipoArchivo) VALUES ('Archivo TAR');
GO

-- Usuarios
-- IDs: Adrián=1, María=2, Carlos=3, Ana=4, Luis=5, John=6, Emily=7, Michael=8, Jessica=9, David=10
INSERT INTO Usuarios (Nombre, Apellido, IDTipoUsuario) VALUES ('Adrián',  'Clarck',    1);
INSERT INTO Usuarios (Nombre, Apellido, IDTipoUsuario) VALUES ('María',   'González',  2);
INSERT INTO Usuarios (Nombre, Apellido, IDTipoUsuario) VALUES ('Carlos',  'López',     3);
INSERT INTO Usuarios (Nombre, Apellido, IDTipoUsuario) VALUES ('Ana',     'Martínez',  4);
INSERT INTO Usuarios (Nombre, Apellido, IDTipoUsuario) VALUES ('Luis',    'Fernández', 5);
INSERT INTO Usuarios (Nombre, Apellido, IDTipoUsuario) VALUES ('John',    'Smith',     1);
INSERT INTO Usuarios (Nombre, Apellido, IDTipoUsuario) VALUES ('Emily',   'Johnson',   2);
INSERT INTO Usuarios (Nombre, Apellido, IDTipoUsuario) VALUES ('Michael', 'Williams',  3);
INSERT INTO Usuarios (Nombre, Apellido, IDTipoUsuario) VALUES ('Jessica', 'Brown',     4);
INSERT INTO Usuarios (Nombre, Apellido, IDTipoUsuario) VALUES ('David',   'Jones',     5);
GO

-- Archivos
-- Columnas con caracteres especiales referenciadas con corchetes: [IDUsuarioDueño], [Tamaño]
-- IDTipoArchivo: 1=PDF, 2=JPEG, 4=ZIP, 6=Word, 7=Excel, 8=PPT, 15=MP3, 16=MP4, 18=PNG
-- Eliminado: 0=No, 1=Sí

-- ID=1  Adrián Clarck
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (1, 'Informe Anual', 'pdf', 'Informe de resultados anuales', 1, 204800, '2021-03-15', '2021-03-16', 0);

-- ID=2  Adrián Clarck
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (1, 'Foto de perfil', 'jpg', 'Imagen para perfil en la plataforma', 2, 51200, '2022-01-10', '2022-01-10', 0);

-- ID=3  Adrián Clarck
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (1, 'Backup Sistema', 'zip', 'Copia de seguridad del sistema', 4, 104857600, '2023-05-01', '2023-05-01', 1);

-- ID=4  María González
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (2, 'Presentación Proyecto', 'pptx', 'Presentación del proyecto final', 8, 307200, '2020-07-22', '2020-07-22', 0);

-- ID=5  María González
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (2, 'Reporte Financiero', 'xls', 'Reporte del estado financiero', 7, 102400, '2022-12-05', '2022-12-06', 0);

-- ID=6  María González
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (2, 'Diagrama de Red', 'png', 'Diagrama de la red interna', 18, 81920, '2021-09-15', '2021-09-15', 0);

-- ID=7  Carlos López
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (3, 'Manual de Usuario', 'pdf', 'Manual de uso del software', 1, 256000, '2021-11-10', '2021-11-11', 0);

-- ID=8  Carlos López
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (3, 'Informe de Ventas', 'xls', 'Informe de ventas del trimestre', 7, 76800, '2023-01-20', '2023-01-21', 0);

-- ID=9  Ana Martínez  (descripción con comillas simples → escapadas con '')
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (4, 'Documento Legal', 'docx', '''Contrato legal revisado''', 6, 51200, '2020-03-01', '2020-03-02', 0);

-- ID=10 Ana Martínez
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (4, 'Plan de Marketing', 'pptx', 'Plan de marketing para el nuevo producto', 8, 153600, '2022-10-10', '2022-10-11', 0);

-- ID=11 Ana Martínez
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (4, 'Presupuesto 2023', 'xls', 'Presupuesto aprobado para 2023', 7, 128000, '2023-08-15', '2023-08-16', 0);

-- ID=12 Ana Martínez
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (4, 'Logo Empresa', 'png', 'Logo oficial de la empresa', 18, 102400, '2020-06-20', '2020-06-20', 1);

-- ID=13 Luis Fernández
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (5, 'Audio Conferencia', 'mp3', 'Grabación de la conferencia anual', 15, 52428800, '2021-04-12', '2021-04-12', 0);

-- ID=14 Luis Fernández
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (5, 'Video Promocional', 'mp4', 'Video promocional del nuevo producto', 16, 104857600, '2023-02-14', '2023-02-14', 0);

-- ID=15 John Smith
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (6, 'Guía de Estilo', 'docx', 'Guía de estilo para la empresa', 6, 40960, '2022-05-30', '2022-05-30', 0);

-- ID=16 John Smith
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (6, 'Esquema de Base de Datos', 'pdf', 'Esquema detallado de la base de datos', 1, 102400, '2023-07-21', '2023-07-21', 0);

-- ID=17 Emily Johnson
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (7, 'Presentación Producto', 'pptx', 'Presentación de características del nuevo producto', 8, 204800, '2021-08-15', '2021-08-15', 0);

-- ID=18 Emily Johnson
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (7, 'Análisis Competencia', 'docx', 'Análisis del mercado y competencia', 6, 61440, '2022-03-18', '2022-03-19', 0);

-- ID=19 Michael Williams
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (8, 'Memorándum Interno', 'docx', 'Memorándum para todo el personal', 6, 30720, '2023-11-10', '2023-11-10', 0);

-- ID=20 Michael Williams
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (8, 'Propuesta Comercial', 'pdf', 'Propuesta comercial para el cliente', 1, 153600, '2021-04-05', '2021-04-06', 1);

-- ID=21 Jessica Brown
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (9, 'Plan Estratégico', 'xls', 'Plan estratégico para los próximos 5 años', 7, 256000, '2023-02-28', '2023-03-01', 0);

-- ID=22 Jessica Brown
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (9, 'Informe de Sostenibilidad', 'pdf', 'Informe anual de sostenibilidad', 1, 204800, '2020-11-11', '2020-11-11', 0);

-- ID=23 Jessica Brown
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (9, 'Resumen Ejecutivo', 'docx', 'Resumen ejecutivo del informe anual', 6, 40960, '2021-12-20', '2021-12-21', 0);

-- ID=24 Adrián Clarck
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (1, 'Backup Datos', 'zip', 'Copia de seguridad de los datos', 4, 209715200, '2024-01-01', '2024-01-02', 0);

-- ID=25 María González
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (2, 'Esquema del Proyecto', 'pdf', 'Esquema general del proyecto', 1, 102400, '2022-04-15', '2022-04-16', 0);

-- ID=26 Carlos López
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (3, 'Video Corporativo', 'mp4', 'Video de presentación corporativa', 16, 157286400, '2023-06-05', '2023-06-05', 1);

-- ID=27 Ana Martínez
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (4, 'Documento de Propuesta', 'docx', 'Propuesta enviada al cliente', 6, 61440, '2021-09-01', '2021-09-01', 0);

-- ID=28 Luis Fernández
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (5, 'Reporte de Uso', 'xls', 'Reporte de uso de recursos', 7, 122880, '2023-08-20', '2023-08-21', 0);

-- ID=29 John Smith
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (6, 'Imagen del Producto', 'jpg', 'Imagen del nuevo producto', 2, 51200, '2020-05-10', '2020-05-10', 0);

-- ID=30 Emily Johnson
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (7, 'Estudio de Mercado', 'pdf', 'Estudio de mercado para la nueva campaña', 1, 153600, '2022-06-22', '2022-06-23', 0);

-- ID=31 Michael Williams
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (8, 'Modelo Financiero', 'xls', 'Modelo financiero para la nueva línea de negocio', 7, 204800, '2024-02-01', '2024-02-02', 0);

-- ID=32 Jessica Brown
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (9, 'Archivo de Código', 'zip', 'Código fuente del proyecto', 4, 104857600, '2023-03-30', '2023-03-31', 1);

-- ID=33 María González  (ya marcado como eliminado)
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (2, 'Documento Eliminado', 'docx', 'Archivo que fue eliminado', 6, 40960, '2021-07-15', '2021-07-15', 1);

-- ID=34 Ana Martínez  (ya marcado como eliminado)
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (4, 'Imagen Vieja', 'png', 'Imagen que fue reemplazada', 18, 102400, '2022-09-10', '2022-09-10', 1);

-- ID=35 John Smith  (ya marcado como eliminado)
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (6, 'Archivo Descontinuado', 'pdf', 'Archivo que ya no se usa', 1, 153600, '2020-12-25', '2020-12-26', 1);

-- ID=36 Michael Williams  (ya marcado como eliminado)
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (8, 'Versión Antigua', 'pptx', 'Versión anterior de la presentación', 8, 204800, '2023-05-15', '2023-05-16', 1);
GO

-- ArchivosCompartidos
-- PK: (IDArchivo, IDUsuario)  — sin duplicados
-- IDPermiso: Lectura=1, Comentario=2, Escritura=3, Administrador=4
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (1,  6,  1, '2022-05-11'); -- Informe Anual         | John Smith       | Lectura
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (2,  7,  2, '2022-06-15'); -- Foto de perfil        | Emily Johnson    | Comentario
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (3,  8,  3, '2023-01-12'); -- Backup Sistema        | Michael Williams | Escritura
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (4,  9,  1, '2020-08-01'); -- Presentación Proyecto | Jessica Brown    | Lectura
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (5,  5,  4, '2023-09-20'); -- Reporte Financiero    | Luis Fernández   | Administrador
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (6,  6,  1, '2022-02-18'); -- Diagrama de Red       | John Smith       | Lectura
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (7,  7,  3, '2021-10-05'); -- Manual de Usuario     | Emily Johnson    | Escritura
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (8,  8,  1, '2023-04-17'); -- Informe de Ventas     | Michael Williams | Lectura
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (9,  9,  2, '2020-04-25'); -- Documento Legal       | Jessica Brown    | Comentario
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (10, 1,  4, '2022-11-30'); -- Plan de Marketing     | Adrián Clarck    | Administrador
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (11, 2,  1, '2021-06-22'); -- Presupuesto 2023      | María González   | Lectura
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (12, 3,  3, '2023-02-14'); -- Logo Empresa          | Carlos López     | Escritura
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (13, 4,  2, '2020-01-19'); -- Audio Conferencia     | Ana Martínez     | Comentario
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (14, 6,  1, '2023-03-23'); -- Video Promocional     | John Smith       | Lectura
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (15, 7,  4, '2022-07-29'); -- Guía de Estilo        | Emily Johnson    | Administrador
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (16, 7,  2, '2023-12-05'); -- Esquema Base de Datos | Emily Johnson    | Comentario
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (17, 8,  1, '2021-09-16'); -- Presentación Producto | Michael Williams | Lectura
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (18, 9,  3, '2020-12-07'); -- Análisis Competencia  | Jessica Brown    | Escritura
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (18, 1,  4, '2024-02-28'); -- Análisis Competencia  | Adrián Clarck    | Administrador
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido) VALUES (18, 10, 1, '2023-05-10'); -- Análisis Competencia  | David Jones      | Lectura
GO

-- =============================================
-- PUNTO 2 - Actualizar descripción de archivo eliminado
-- =============================================
UPDATE Archivos
SET    Descripcion = 'Archivo eliminado por el usuario'
WHERE  Nombre = 'Documento Eliminado';
GO

-- =============================================
-- PUNTO 3 - Marcar como eliminados archivos viejos
-- Afecta a: Presentación Proyecto, Documento Legal,
--           Informe de Sostenibilidad, Imagen del Producto
-- =============================================
UPDATE Archivos
SET    Eliminado = 1
WHERE  FechaCreacion < '2021-01-01'
  AND  Eliminado = 0;
GO

-- =============================================
-- PUNTO 4 - Eliminar un archivo ZIP del usuario 1 (Adrián Clarck)
-- Se elige 'Backup Datos' (ID=24) porque no tiene entradas
-- en ArchivosCompartidos, evitando errores de FK
-- =============================================
DELETE FROM Archivos
WHERE  IDArchivo = 24;
GO

-- =============================================
-- PUNTO 5 - Asignar permiso de Lectura
-- Usuario ID=10 (David Jones) sobre archivo ID=1 (Informe Anual)
-- =============================================
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido)
VALUES (1, 10, 1, GETDATE());
GO

-- =============================================
-- PUNTO 6 - Eliminar archivos antiguos marcados como eliminados
-- Primero se borran los registros dependientes en ArchivosCompartidos
-- (los archivos afectados que tienen compartidos son: 4, 9, 12)
-- =============================================
DELETE FROM ArchivosCompartidos
WHERE  IDArchivo IN (
    SELECT IDArchivo FROM Archivos
    WHERE  Eliminado = 1
      AND  FechaUltimaModificacion < '2022-01-01'
);
GO

DELETE FROM Archivos
WHERE  Eliminado = 1
  AND  FechaUltimaModificacion < '2022-01-01';
GO

-- =============================================
-- PUNTO 7 - Corregir extensión de imágenes JPEG
-- Cambia 'jpg' → 'jpeg' solo en archivos de tipo Imagen JPEG
-- =============================================
UPDATE Archivos
SET    Extension = 'jpeg'
WHERE  Extension = 'jpg'
  AND  IDTipoArchivo = (
           SELECT IDTipoArchivo FROM TiposArchivos
           WHERE  TipoArchivo = 'Imagen JPEG'
       );
GO

-- =============================================
-- PUNTO 8 - Insertar archivo nuevo y compartirlo
-- con tres usuarios con distintos permisos
-- =============================================
INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (1, 'Informe Trimestral Q3', 'pdf', 'Informe de resultados del tercer trimestre', 1, 512000, GETDATE(), NULL, 0);

DECLARE @IDNuevo INT = SCOPE_IDENTITY();

INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido)
VALUES (@IDNuevo, 2,  1, GETDATE()); -- María González | Lectura

INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido)
VALUES (@IDNuevo, 3,  3, GETDATE()); -- Carlos López   | Escritura

INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido)
VALUES (@IDNuevo, 4,  4, GETDATE()); -- Ana Martínez   | Administrador
GO

-- =============================================
-- PUNTO 9 - Asignar permiso Administrador a usuario premium
-- Archivo ID=5 (Reporte Financiero), Usuario ID=4 (Ana Martínez - Premium)
-- =============================================
INSERT INTO ArchivosCompartidos (IDArchivo, IDUsuario, IDPermiso, FechaCompartido)
VALUES (5, 4, 4, GETDATE());
GO

-- =============================================
-- PUNTO 10 - Reemplazo de archivo PPTX eliminado
-- Se usa 'Versión Antigua' (ID=36, pptx, Eliminado=1)
-- Se guarda su información en variables, se borra,
-- y se inserta uno nuevo con nombre + '_v2'
-- =============================================
DECLARE @Nombre       VARCHAR(255);
DECLARE @Descripcion  VARCHAR(500);
DECLARE @IDDuenio     INT;
DECLARE @IDTipo       INT;
DECLARE @Tamanio      BIGINT;

SELECT
    @Nombre      = Nombre,
    @Descripcion = Descripcion,
    @IDDuenio    = [IDUsuarioDueño],
    @IDTipo      = IDTipoArchivo,
    @Tamanio     = [Tamaño]
FROM Archivos
WHERE IDArchivo = 36;

DELETE FROM Archivos
WHERE  IDArchivo = 36;

INSERT INTO Archivos ([IDUsuarioDueño], Nombre, Extension, Descripcion, IDTipoArchivo, [Tamaño], FechaCreacion, FechaUltimaModificacion, Eliminado)
VALUES (@IDDuenio, @Nombre + '_v2', 'pptx', @Descripcion, @IDTipo, @Tamanio, GETDATE(), NULL, 0);
GO
