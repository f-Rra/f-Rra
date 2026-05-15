-- =============================================
-- BD2 - Trabajo Práctico N° 8
-- Tecnicatura Universitaria en Programación
-- Base de Datos II
-- Triggers y Transacciones sobre DBTutorias
-- =============================================

USE DBTutorias;
GO

-- Estado 'Cancelada' necesario para el Trigger 4.
-- Se agrega si no existe.
IF NOT EXISTS (SELECT 1 FROM EstadosTutoria WHERE Nombre = 'Cancelada')
    INSERT INTO EstadosTutoria (Nombre) VALUES ('Cancelada');
GO

-- =============================================
-- TRIGGER 1: tr_ValidarPostulacion
-- INSTEAD OF INSERT sobre EstudiantesMaterias.
-- Valida que el estudiante esté activo y que
-- no repita el mismo Rol en la misma Materia.
-- Luego registra la postulación.
-- =============================================
CREATE TRIGGER tr_ValidarPostulacion
ON EstudiantesMaterias
INSTEAD OF INSERT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar que el estudiante esté activo
        IF EXISTS (
            SELECT 1 FROM INSERTED i
            INNER JOIN Estudiantes e ON i.IDEstudiante = e.IDEstudiante
            WHERE e.Activo = 0
        )
        BEGIN
            RAISERROR('El estudiante no está activo en el sistema.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar que no exista el mismo Rol en la misma Materia para ese Estudiante
        IF EXISTS (
            SELECT 1 FROM INSERTED i
            INNER JOIN EstudiantesMaterias em
                ON i.IDEstudiante = em.IDEstudiante
               AND i.IDMateria    = em.IDMateria
               AND i.Rol          = em.Rol
        )
        BEGIN
            RAISERROR('El estudiante ya tiene ese rol en la materia indicada.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Registrar la postulación
        INSERT INTO EstudiantesMaterias (IDEstudiante, IDMateria, Rol, FechaAlta)
        SELECT IDEstudiante, IDMateria, Rol, FechaAlta FROM INSERTED;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO

-- =============================================
-- TRIGGER 2: tr_AgregarTutoria
-- INSTEAD OF INSERT sobre Tutorias.
-- Valida activos, roles, diferencia tutor/alumno
-- y saldo de créditos. Descuenta créditos al alumno
-- y registra la tutoría.
-- =============================================
CREATE TRIGGER tr_AgregarTutoria
ON Tutorias
INSTEAD OF INSERT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @IDTutor  INT, @IDAlumno INT,
                @IDMateria INT, @Duracion TINYINT;

        SELECT
            @IDTutor   = IDEstudianteTutor,
            @IDAlumno  = IDEstudianteAlumno,
            @IDMateria = IDMateria,
            @Duracion  = Duracion
        FROM INSERTED;

        -- Verificar que el tutor esté activo
        IF (SELECT Activo FROM Estudiantes WHERE IDEstudiante = @IDTutor) = 0
        BEGIN
            RAISERROR('El tutor no está activo en el sistema.', 16, 1);
            ROLLBACK TRANSACTION; RETURN;
        END

        -- Verificar que el alumno esté activo
        IF (SELECT Activo FROM Estudiantes WHERE IDEstudiante = @IDAlumno) = 0
        BEGIN
            RAISERROR('El alumno no está activo en el sistema.', 16, 1);
            ROLLBACK TRANSACTION; RETURN;
        END

        -- Verificar que tutor y alumno no sean el mismo estudiante
        IF @IDTutor = @IDAlumno
        BEGIN
            RAISERROR('El tutor y el alumno no pueden ser el mismo estudiante.', 16, 1);
            ROLLBACK TRANSACTION; RETURN;
        END

        -- Verificar que el tutor esté postulado como Tutor en la materia
        IF NOT EXISTS (
            SELECT 1 FROM EstudiantesMaterias
            WHERE IDEstudiante = @IDTutor AND IDMateria = @IDMateria AND Rol = 'Tutor'
        )
        BEGIN
            RAISERROR('El tutor no está postulado como Tutor en esa materia.', 16, 1);
            ROLLBACK TRANSACTION; RETURN;
        END

        -- Verificar que el alumno esté postulado como Alumno en la materia
        IF NOT EXISTS (
            SELECT 1 FROM EstudiantesMaterias
            WHERE IDEstudiante = @IDAlumno AND IDMateria = @IDMateria AND Rol = 'Alumno'
        )
        BEGIN
            RAISERROR('El alumno no está postulado como Alumno en esa materia.', 16, 1);
            ROLLBACK TRANSACTION; RETURN;
        END

        -- Verificar saldo de créditos del alumno (no puede quedar por debajo de -5)
        DECLARE @SaldoAlumno SMALLINT;
        SELECT @SaldoAlumno = SaldoCredito FROM Estudiantes WHERE IDEstudiante = @IDAlumno;

        IF @SaldoAlumno - @Duracion < -5
        BEGIN
            RAISERROR('El alumno no puede superar los 5 créditos negativos. Solicitud rechazada.', 16, 1);
            ROLLBACK TRANSACTION; RETURN;
        END

        -- Descontar créditos al alumno
        UPDATE Estudiantes
        SET    SaldoCredito = SaldoCredito - @Duracion
        WHERE  IDEstudiante = @IDAlumno;

        -- Registrar la tutoría (IDEstado=1 'Vigente' por defecto)
        INSERT INTO Tutorias (IDEstudianteTutor, IDEstudianteAlumno, IDMateria, Fecha, Duracion)
        SELECT IDEstudianteTutor, IDEstudianteAlumno, IDMateria, Fecha, Duracion
        FROM   INSERTED;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO

-- =============================================
-- TRIGGER 3: tr_RegistrarConfirmacion
-- AFTER UPDATE sobre Tutorias.
-- Cuando AMBAS confirmaciones pasan a 1:
--   - Suma créditos al tutor.
--   - Registra en HistorialCreditos para tutor y alumno.
--   - Marca la tutoría como Finalizada (IDEstado=3).
-- La condición sobre DELETED evita re-ejecución
-- cuando el propio trigger actualiza IDEstado.
-- =============================================
CREATE TRIGGER tr_RegistrarConfirmacion
ON Tutorias
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Solo proceder si ambas confirmaciones acaban de completarse
        IF EXISTS (
            SELECT 1 FROM INSERTED i
            INNER JOIN DELETED d ON i.IDTutoria = d.IDTutoria
            WHERE i.ConfirmaTutor  = 1 AND i.ConfirmaAlumno  = 1
              AND NOT (d.ConfirmaTutor = 1 AND d.ConfirmaAlumno = 1)
        )
        BEGIN
            DECLARE @IDTutoria INT, @IDTutor  INT, @IDAlumno  INT,
                    @IDMateria INT, @Duracion TINYINT, @NombreMateria VARCHAR(100);

            SELECT
                @IDTutoria = i.IDTutoria,
                @IDTutor   = i.IDEstudianteTutor,
                @IDAlumno  = i.IDEstudianteAlumno,
                @IDMateria = i.IDMateria,
                @Duracion  = i.Duracion
            FROM INSERTED i;

            SELECT @NombreMateria = Nombre FROM Materias WHERE IDMateria = @IDMateria;

            -- Sumar créditos al tutor
            UPDATE Estudiantes
            SET    SaldoCredito = SaldoCredito + @Duracion
            WHERE  IDEstudiante = @IDTutor;

            -- Registrar en historial: tutor gana créditos
            INSERT INTO HistorialCreditos (IDEstudiante, Tipo, Cantidad, Descripcion)
            VALUES (@IDTutor, 'Gana', @Duracion,
                    'Ganó créditos por tutoría de ' + @NombreMateria);

            -- Registrar en historial: alumno usó créditos
            INSERT INTO HistorialCreditos (IDEstudiante, Tipo, Cantidad, Descripcion)
            VALUES (@IDAlumno, 'Usa', @Duracion,
                    'Uso por tutoría de ' + @NombreMateria);

            -- Marcar como Finalizada (IDEstado = 3)
            UPDATE Tutorias SET IDEstado = 3 WHERE IDTutoria = @IDTutoria;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO

-- =============================================
-- TRIGGER 4: tr_CancelarTutoria
-- INSTEAD OF DELETE sobre Tutorias.
-- En lugar de eliminar físicamente:
--   - Devuelve créditos al alumno.
--   - Si ambos habían confirmado, descuenta créditos al tutor.
--   - Marca la tutoría como 'Cancelada'.
-- =============================================
CREATE TRIGGER tr_CancelarTutoria
ON Tutorias
INSTEAD OF DELETE
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @IDTutoria      INT,
                @IDTutor        INT,
                @IDAlumno       INT,
                @Duracion       TINYINT,
                @ConfTutor      BIT,
                @ConfAlumno     BIT,
                @IDEstCancelada TINYINT;

        SELECT
            @IDTutoria  = IDTutoria,
            @IDTutor    = IDEstudianteTutor,
            @IDAlumno   = IDEstudianteAlumno,
            @Duracion   = Duracion,
            @ConfTutor  = ConfirmaTutor,
            @ConfAlumno = ConfirmaAlumno
        FROM DELETED;

        SELECT @IDEstCancelada = IDEstado FROM EstadosTutoria WHERE Nombre = 'Cancelada';

        -- Devolver créditos al alumno
        UPDATE Estudiantes
        SET    SaldoCredito = SaldoCredito + @Duracion
        WHERE  IDEstudiante = @IDAlumno;

        -- Si ambos habían confirmado, descontar créditos al tutor
        IF @ConfTutor = 1 AND @ConfAlumno = 1
        BEGIN
            UPDATE Estudiantes
            SET    SaldoCredito = SaldoCredito - @Duracion
            WHERE  IDEstudiante = @IDTutor;
        END

        -- Marcar como Cancelada en lugar de eliminar
        UPDATE Tutorias
        SET    IDEstado = @IDEstCancelada
        WHERE  IDTutoria = @IDTutoria;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO

-- =============================================
-- TRIGGER 5: tr_BajaLogicaEstudiante
-- INSTEAD OF DELETE sobre Estudiantes.
-- En lugar de eliminar físicamente:
--   - Cambia Activo = 0 (baja lógica).
--   - Elimina físicamente todos sus registros
--     en HistorialCreditos.
-- =============================================
CREATE TRIGGER tr_BajaLogicaEstudiante
ON Estudiantes
INSTEAD OF DELETE
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Baja física del historial de créditos
        DELETE FROM HistorialCreditos
        WHERE IDEstudiante IN (SELECT IDEstudiante FROM DELETED);

        -- Baja lógica del estudiante
        UPDATE Estudiantes
        SET    Activo = 0
        WHERE  IDEstudiante IN (SELECT IDEstudiante FROM DELETED);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO
