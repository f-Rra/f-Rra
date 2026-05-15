-- =============================================
-- BD2 - Trabajo Práctico N° 7 - Parte 2: Vistas
-- Tecnicatura Universitaria en Programación
-- Base de Datos II
-- Vistas sobre DBTutorias
-- =============================================

USE DBTutorias;
GO

-- =============================================
-- VISTA 1: Estudiantes activos
-- Legajo, Nombre, Apellido, Email y SaldoCredito
-- de los estudiantes con Activo = 1.
-- =============================================
CREATE VIEW v_EstudiantesActivos AS
SELECT
    Legajo,
    Nombre,
    Apellido,
    Email,
    SaldoCredito
FROM Estudiantes
WHERE Activo = 1;
GO

-- =============================================
-- VISTA 2: Materias
-- Nombre, CodigoMateria, Carrera y Nivel
-- de todas las materias registradas.
-- =============================================
CREATE VIEW v_Materias AS
SELECT
    Nombre,
    CodigoMateria,
    Carrera,
    Nivel
FROM Materias;
GO

-- =============================================
-- VISTA 3: Postulaciones de estudiantes a materias
-- Nombre completo del estudiante, materia y rol
-- (Tutor o Alumno) en el que se postuló.
-- =============================================
CREATE VIEW v_Postulaciones AS
SELECT
    e.Nombre + ' ' + e.Apellido AS NombreCompleto,
    m.Nombre                    AS Materia,
    em.Rol
FROM EstudiantesMaterias em
INNER JOIN Estudiantes e ON em.IDEstudiante = e.IDEstudiante
INNER JOIN Materias    m ON em.IDMateria    = m.IDMateria;
GO

-- =============================================
-- VISTA 4: Tutorías confirmadas por ambas partes
-- Fecha, duración, materia, nombre completo
-- del tutor y del alumno.
-- =============================================
CREATE VIEW v_TutoriasConfirmadas AS
SELECT
    t.Fecha,
    t.Duracion,
    m.Nombre                           AS Materia,
    eTutor.Nombre  + ' ' + eTutor.Apellido   AS NombreCompletoTutor,
    eAlumno.Nombre + ' ' + eAlumno.Apellido  AS NombreCompletoAlumno
FROM       Tutorias    t
INNER JOIN Materias    m       ON t.IDMateria          = m.IDMateria
INNER JOIN Estudiantes eTutor  ON t.IDEstudianteTutor  = eTutor.IDEstudiante
INNER JOIN Estudiantes eAlumno ON t.IDEstudianteAlumno = eAlumno.IDEstudiante
WHERE t.ConfirmaTutor = 1 AND t.ConfirmaAlumno = 1;
GO

-- =============================================
-- VISTA 5: Historial de movimientos de créditos
-- Nombre completo del estudiante, fecha, tipo
-- (Gana / Usa), cantidad y descripción.
-- =============================================
CREATE VIEW v_HistorialCreditos AS
SELECT
    e.Nombre + ' ' + e.Apellido AS NombreCompleto,
    hc.Fecha,
    hc.Tipo,
    hc.Cantidad,
    hc.Descripcion
FROM HistorialCreditos hc
INNER JOIN Estudiantes e ON hc.IDEstudiante = e.IDEstudiante;
GO

-- =============================================
-- Ejemplos de consulta a las vistas
-- =============================================
-- SELECT * FROM v_EstudiantesActivos;
-- SELECT * FROM v_Materias;
-- SELECT * FROM v_Postulaciones;
-- SELECT * FROM v_TutoriasConfirmadas;
-- SELECT * FROM v_HistorialCreditos;
