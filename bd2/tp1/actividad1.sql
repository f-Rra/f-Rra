-- =============================================
-- BD2 - Actividad 1
-- Técnico Universitario en Programación
-- Base de Datos II
-- =============================================

CREATE DATABASE BD2_Actividad1;
GO

USE BD2_Actividad1;
GO

-- =============================================
-- Tabla: Carreras
-- Se crea primero porque Alumnos y Materias la referencian
-- =============================================
CREATE TABLE Carreras (
    ID            VARCHAR(4)   NOT NULL,
    Nombre        VARCHAR(100) NOT NULL,
    FechaCreacion DATE         NOT NULL,
    Mail          VARCHAR(255) NOT NULL,
    Nivel         VARCHAR(15)  NOT NULL,
    CONSTRAINT PK_Carreras        PRIMARY KEY (ID),
    CONSTRAINT CK_Carreras_Fecha  CHECK (FechaCreacion <= GETDATE()),
    CONSTRAINT CK_Carreras_Nivel  CHECK (Nivel IN ('Diplomatura', 'Pregrado', 'Grado', 'Posgrado'))
);
GO

-- =============================================
-- Tabla: Alumnos
-- =============================================
CREATE TABLE Alumnos (
    Legajo          INT          IDENTITY(1000, 1) NOT NULL,
    IDCarrera       VARCHAR(4)   NOT NULL,
    Apellidos       VARCHAR(100) NOT NULL,
    Nombres         VARCHAR(100) NOT NULL,
    FechaNacimiento DATE         NOT NULL,
    Mail            VARCHAR(255) NOT NULL,
    Telefono        VARCHAR(20)  NULL,
    CONSTRAINT PK_Alumnos              PRIMARY KEY (Legajo),
    CONSTRAINT FK_Alumnos_Carreras     FOREIGN KEY (IDCarrera) REFERENCES Carreras(ID),
    CONSTRAINT CK_Alumnos_FechaNac     CHECK (FechaNacimiento <= GETDATE()),
    CONSTRAINT UQ_Alumnos_Mail         UNIQUE (Mail)
);
GO

-- =============================================
-- Tabla: Materias
-- =============================================
CREATE TABLE Materias (
    ID           INT          IDENTITY(1, 1) NOT NULL,
    IDCarrera    VARCHAR(4)   NOT NULL,
    Nombre       VARCHAR(100) NOT NULL,
    CargaHoraria INT          NOT NULL,
    CONSTRAINT PK_Materias             PRIMARY KEY (ID),
    CONSTRAINT FK_Materias_Carreras    FOREIGN KEY (IDCarrera) REFERENCES Carreras(ID),
    CONSTRAINT CK_Materias_CargaHor    CHECK (CargaHoraria > 0)
);
GO
