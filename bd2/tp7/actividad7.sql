-- =============================================
-- BD2 - Trabajo Práctico N° 7
-- Tecnicatura Universitaria en Programación
-- Base de Datos II
-- Procedimientos Almacenados sobre DBTutorias
-- =============================================

USE DBTutorias;
GO

-- =============================================
-- SP 1: sp_Agregar_Estudiante
-- Registra un nuevo estudiante. SaldoCredito
-- inicia en 10 por defecto (definido en la tabla).
-- =============================================
CREATE PROCEDURE sp_Agregar_Estudiante
    @Legajo   VARCHAR(10),
    @Nombre   VARCHAR(100),
    @Apellido VARCHAR(100),
    @Email    VARCHAR(150)
AS
BEGIN
    INSERT INTO Estudiantes (Legajo, Nombre, Apellido, Email)
    VALUES (@Legajo, @Nombre, @Apellido, @Email);
END
GO

-- =============================================
-- SP 2: sp_Agregar_Materia
-- Registra una nueva materia en el sistema.
-- =============================================
CREATE PROCEDURE sp_Agregar_Materia
    @Nombre        VARCHAR(100),
    @Nivel         TINYINT,
    @Carrera       VARCHAR(150),
    @CodigoMateria VARCHAR(4)
AS
BEGIN
    INSERT INTO Materias (Nombre, Nivel, Carrera, CodigoMateria)
    VALUES (@Nombre, @Nivel, @Carrera, @CodigoMateria);
END
GO

-- =============================================
-- SP 3: sp_Agregar_EstudianteMateria
-- Registra el postulamiento de un estudiante
-- como Tutor o Alumno en una materia.
-- =============================================
CREATE PROCEDURE sp_Agregar_EstudianteMateria
    @IDEstudiante INT,
    @IDMateria    INT,
    @Rol          VARCHAR(10)   -- 'Tutor' o 'Alumno'
AS
BEGIN
    INSERT INTO EstudiantesMaterias (IDEstudiante, IDMateria, Rol)
    VALUES (@IDEstudiante, @IDMateria, @Rol);
END
GO

-- =============================================
-- SP 4: sp_Agregar_Tutoria
-- Registra una tutoría y descuenta créditos al alumno
-- según la duración (1 crédito = 1 hora).
-- REGLA: el alumno no puede quedar con más de 5 créditos
-- negativos (SaldoCredito no puede bajar de -5).
-- También registra el movimiento en HistorialCreditos.
-- =============================================
CREATE PROCEDURE sp_Agregar_Tutoria
    @IDEstudianteTutor  INT,
    @IDEstudianteAlumno INT,
    @IDMateria          INT,
    @Fecha              DATE,
    @Duracion           TINYINT   -- duración en horas
AS
BEGIN
    BEGIN TRY
        DECLARE @SaldoActual   SMALLINT;
        DECLARE @NombreMateria VARCHAR(100);

        -- Obtener saldo actual del alumno
        SELECT @SaldoActual = SaldoCredito
        FROM   Estudiantes
        WHERE  IDEstudiante = @IDEstudianteAlumno;

        -- Verificar límite de créditos negativos
        IF @SaldoActual - @Duracion < -5
        BEGIN
            RAISERROR('El alumno no puede superar los 5 créditos negativos. Solicitud rechazada.', 16, 1);
            RETURN;
        END

        -- Obtener nombre de la materia para la descripción
        SELECT @NombreMateria = Nombre
        FROM   Materias
        WHERE  IDMateria = @IDMateria;

        -- Registrar la tutoría (IDEstado=1 'Vigente' por defecto)
        INSERT INTO Tutorias (IDEstudianteTutor, IDEstudianteAlumno, IDMateria, Fecha, Duracion)
        VALUES (@IDEstudianteTutor, @IDEstudianteAlumno, @IDMateria, @Fecha, @Duracion);

        -- Descontar créditos al alumno
        UPDATE Estudiantes
        SET    SaldoCredito = SaldoCredito - @Duracion
        WHERE  IDEstudiante = @IDEstudianteAlumno;

        -- Registrar movimiento en historial
        INSERT INTO HistorialCreditos (IDEstudiante, Tipo, Cantidad, Descripcion)
        VALUES (@IDEstudianteAlumno, 'Usa', @Duracion,
                'Uso por tutoría de ' + @NombreMateria);

    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO

-- =============================================
-- SP 5: sp_Confirmar_Tutoria
-- Registra la confirmación del Tutor o del Alumno.
-- Si ambos confirman:
--   - Suma créditos al tutor según duración.
--   - Registra el movimiento en HistorialCreditos.
--   - Actualiza el estado a 'Finalizada' (IDEstado=3).
-- =============================================
CREATE PROCEDURE sp_Confirmar_Tutoria
    @IDTutoria INT,
    @Rol       VARCHAR(10)   -- 'Tutor' o 'Alumno'
AS
BEGIN
    BEGIN TRY
        -- Registrar confirmación según rol
        IF @Rol = 'Tutor'
            UPDATE Tutorias SET ConfirmaTutor  = 1 WHERE IDTutoria = @IDTutoria;
        ELSE IF @Rol = 'Alumno'
            UPDATE Tutorias SET ConfirmaAlumno = 1 WHERE IDTutoria = @IDTutoria;
        ELSE
        BEGIN
            RAISERROR('Rol inválido. Debe ser Tutor o Alumno.', 16, 1);
            RETURN;
        END

        -- Verificar si ambas partes ya confirmaron
        DECLARE @ConfTutor  BIT;
        DECLARE @ConfAlumno BIT;
        DECLARE @IDTutor    INT;
        DECLARE @Duracion   TINYINT;
        DECLARE @IDMateria  INT;

        SELECT
            @ConfTutor  = ConfirmaTutor,
            @ConfAlumno = ConfirmaAlumno,
            @IDTutor    = IDEstudianteTutor,
            @Duracion   = Duracion,
            @IDMateria  = IDMateria
        FROM Tutorias
        WHERE IDTutoria = @IDTutoria;

        -- Procesar cierre si ambos confirmaron
        IF @ConfTutor = 1 AND @ConfAlumno = 1
        BEGIN
            DECLARE @NombreMateria VARCHAR(100);
            SELECT @NombreMateria = Nombre FROM Materias WHERE IDMateria = @IDMateria;

            -- Sumar créditos al tutor
            UPDATE Estudiantes
            SET    SaldoCredito = SaldoCredito + @Duracion
            WHERE  IDEstudiante = @IDTutor;

            -- Registrar ganancia en historial
            INSERT INTO HistorialCreditos (IDEstudiante, Tipo, Cantidad, Descripcion)
            VALUES (@IDTutor, 'Gana', @Duracion,
                    'Ganó créditos por tutoría de ' + @NombreMateria);

            -- Marcar como Finalizada (IDEstado = 3)
            UPDATE Tutorias
            SET    IDEstado = 3
            WHERE  IDTutoria = @IDTutoria;
        END

    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO

-- =============================================
-- SP 6: sp_Obtener_Tutorias
-- Devuelve las tutorías brindadas o recibidas
-- según el rol enviado, con datos del tutor, alumno,
-- fecha, materia y horas de duración.
-- =============================================
CREATE PROCEDURE sp_Obtener_Tutorias
    @IDEstudiante INT,
    @Rol          VARCHAR(10)   -- 'Tutor' o 'Alumno'
AS
BEGIN
    IF @Rol = 'Tutor'
    BEGIN
        SELECT
            eTutor.Nombre  + ' ' + eTutor.Apellido  AS NombreApellidoTutor,
            eAlumno.Nombre + ' ' + eAlumno.Apellido AS NombreApellidoAlumno,
            t.Fecha,
            m.Nombre   AS Materia,
            t.Duracion AS Horas
        FROM       Tutorias   t
        INNER JOIN Estudiantes eTutor  ON t.IDEstudianteTutor  = eTutor.IDEstudiante
        INNER JOIN Estudiantes eAlumno ON t.IDEstudianteAlumno = eAlumno.IDEstudiante
        INNER JOIN Materias    m       ON t.IDMateria          = m.IDMateria
        WHERE t.IDEstudianteTutor = @IDEstudiante;
    END
    ELSE IF @Rol = 'Alumno'
    BEGIN
        SELECT
            eTutor.Nombre  + ' ' + eTutor.Apellido  AS NombreApellidoTutor,
            eAlumno.Nombre + ' ' + eAlumno.Apellido AS NombreApellidoAlumno,
            t.Fecha,
            m.Nombre   AS Materia,
            t.Duracion AS Horas
        FROM       Tutorias   t
        INNER JOIN Estudiantes eTutor  ON t.IDEstudianteTutor  = eTutor.IDEstudiante
        INNER JOIN Estudiantes eAlumno ON t.IDEstudianteAlumno = eAlumno.IDEstudiante
        INNER JOIN Materias    m       ON t.IDMateria          = m.IDMateria
        WHERE t.IDEstudianteAlumno = @IDEstudiante;
    END
    ELSE
    BEGIN
        RAISERROR('Rol inválido. Debe ser Tutor o Alumno.', 16, 1);
    END
END
GO

-- =============================================
-- Ejemplos de ejecución
-- =============================================

-- EXEC sp_Agregar_Estudiante '12345', 'Juan', 'Pérez', 'juan@mail.com';
-- EXEC sp_Agregar_Materia 'Programación 1', 1, 'Tecnicatura en Programación', 'PRG1';
-- EXEC sp_Agregar_EstudianteMateria 1, 1, 'Tutor';
-- EXEC sp_Agregar_EstudianteMateria 2, 1, 'Alumno';
-- EXEC sp_Agregar_Tutoria 1, 2, 1, '2025-06-10', 2;
-- EXEC sp_Confirmar_Tutoria 1, 'Tutor';
-- EXEC sp_Confirmar_Tutoria 1, 'Alumno';
-- EXEC sp_Obtener_Tutorias 1, 'Tutor';
-- EXEC sp_Obtener_Tutorias 2, 'Alumno';
