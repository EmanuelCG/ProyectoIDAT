USE master
GO

SET DATEFORMAT dmy;
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT name
        FROM sys.databases
        WHERE name = N'bd_Voluntariado'
)
CREATE DATABASE bd_Voluntariado
GO

use bd_Voluntariado
GO

-- Create a new table called 'Administrador' in schema 'dbo'
IF OBJECT_ID('dbo.Administrador', 'U') IS NOT NULL
DROP TABLE dbo.Administrador
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Administrador
(
    AdministradorId INT NOT NULL IDENTITY PRIMARY KEY,
    Nombre [char](30) NOT NULL,
    Ape_Paterno [char](30) NULL,
    Ape_Materno [char](30) NULL,
    Correo [char](50) NOT NULL,
    Telefono [char](14) NULL,
    Documento [char](16) NULL,
    Tipo_Documento [char](30) NULL,
    Eliminado BIT DEFAULT 0,
);
GO

-- Create a new table called 'Voluntario' in schema 'dbo'
IF OBJECT_ID('dbo.Voluntario', 'U') IS NOT NULL
DROP TABLE dbo.Voluntario
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Voluntario
(
    VoluntarioId INT NOT NULL IDENTITY PRIMARY KEY,
    Nombre [char](30) NOT NULL,
    Ape_Paterno [char](30) NULL,
    Ape_Materno [char](30) NULL,
    Correo [char](50) NOT NULL,
    Telefono [char](14) NULL,
    Eventos_Asist INT NULL, -- Contador de Eventos asistidos
    Documento [char](16) NULL,
    Tipo_Documento [char](30) NULL,
    Eliminado BIT DEFAULT 0,
    -------Llaves Foraneas-----------
    UbicacionId INT
    /*Falta detallar las referencias del FK*/
);
GO

-- Create a new table called 'Organizacion' in schema 'dbo'
IF OBJECT_ID('dbo.Organizacion', 'U') IS NOT NULL
DROP TABLE dbo.Organizacion
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Organizacion
(
    OrganizacionId INT NOT NULL IDENTITY PRIMARY KEY,
    RazonSocial [char](50) NOT NULL,
    RUC [char](11) NOT NULl,
    Correo [char](50) NOT NULL,
    Telefono [char](14) NULL,
    Direccion [char](80) NOT NULL,
    Nombre [char](30) NOT NULL,
    Ape_Paterno [char](30) NULL,
    Ape_Materno [char](30) NULL,
    Documento [char](16) NULL,
    Tipo_Documento [char](30) NULL,
    Eliminado BIT DEFAULT 0,
    -------Llaves Foraneas-----------
    UbicacionId INT
    /*Falta detallar las referencias del FK*/
);
GO

-- Create a new table called 'Anuncio' in schema 'dbo'
IF OBJECT_ID('dbo.Anuncio', 'U') IS NOT NULL
DROP TABLE dbo.Anuncio
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Anuncio
(
    AnuncioId INT NOT NULL IDENTITY PRIMARY KEY, -- IDENTITY PRIMARY KEY column
    Nombre [char](30) NOT NULL,
    Categoria [char](25) NULL,
    FechaInicio DATE NULL,
    FechaFin DATE NULL,
    Detalle [char](150) NULL,
    CantParticip INT NULL,
    Eliminado BIT DEFAULT 0,
    -------Llaves Foraneas-----------
    UbicacionId INT,
    OrganizacionId INT
    /*Falta detallar las referencias del FK*/
);
GO

-- Create a new table called 'Evento' in schema 'dbo'
IF OBJECT_ID('dbo.Evento', 'U') IS NOT NULL
DROP TABLE dbo.Evento
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Evento
(
    EventoId INT NOT NULL IDENTITY PRIMARY KEY, -- IDENTITY PRIMARY KEY column
    Nombre [char](50) NOT NULL,
    Eliminado BIT DEFAULT 0,
  -------Llaves Foraneas-----------
    AnuncioId INT
);
GO

-- Create a new table called 'Evento_Participacion' in schema 'dbo'
IF OBJECT_ID('dbo.Evento_Participacion', 'U') IS NOT NULL
DROP TABLE dbo.Evento_Participacion
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Evento_Participacion
(
      -------Llaves Foraneas-----------
      EventoId INT,
      VoluntarioId INT
);
GO


-- Create a new table called 'Ubicacion' in schema 'dbo'
IF OBJECT_ID('dbo.Ubicacion', 'U') IS NOT NULL
DROP TABLE dbo.Ubicacion
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Ubicacion
(
    UbicacionId INT NOT NULL IDENTITY PRIMARY KEY, -- IDENTITY PRIMARY KEY column
    Departamento [char](30) NULL,
    Provincia [char](30) NULL,
    Distrito [char](30) NULL,
    Eliminado BIT DEFAULT 0
);
GO

-- Create a new table called 'Calif_Voluntario' in schema 'dbo'
IF OBJECT_ID('dbo.Calif_Voluntario', 'U') IS NOT NULL
DROP TABLE dbo.Calif_Voluntario
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Calif_Voluntario
(
    Calif_VoluntarioId INT NOT NULL IDENTITY PRIMARY KEY, -- IDENTITY PRIMARY KEY column
    Detalle INT NOT NULL, -- Hacer un constraint para restringir que solo entren valores de 0-10
    Comentario [char](200) NOT NULL,
    -------Llaves Foraneas-----------
    VoluntarioId INT,
    OrganizacionId INT,
    AnuncioId INT
    /*Falta detallar las referencias del FK*/
);
GO

-- Create a new table called 'Calif_Organizacion' in schema 'dbo'
IF OBJECT_ID('dbo.Calif_Organizacion', 'U') IS NOT NULL
DROP TABLE dbo.Calif_Organizacion
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Calif_Organizacion
(
    Calif_OrganizacionId INT NOT NULL IDENTITY PRIMARY KEY, -- IDENTITY PRIMARY KEY column
    Detalle INT NOT NULL, -- Hacer un constraint para restringir que solo entren valores de 0-10
    Comentario [char](200) NOT NULL,
    -------Llaves Foraneas-----------
    OrganizacionId INT,
    VoluntarioId INT,
    AnuncioId INT
    /*Falta detallar las referencias del FK*/
);
GO
/*
select * from Anuncio;
select * from Voluntario;
select * from Administrador;
select * from Evento;
select * from Evento_Participacion;
select * from Organizacion;
select * from Ubicacion;
select * from Calif_Organizacion;
select * from Calif_Voluntario;
*/

-- Create a new stored procedure called 'usp_InsertAnuncio' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_InsertAnuncio'
)
DROP PROCEDURE dbo.usp_InsertAnuncio
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_InsertAnuncio 
    @nombre char (30),
    @categoria char (25),
    @fInicio DATE,
    @fFin DATE,
    @detalle char (150),
    @cantidad int,
    @ubicacionId int,
    @organizacionId int
AS
    INSERT INTO Anuncio (Nombre, Categoria, FechaInicio, FechaFin, Detalle, CantParticip, UbicacionId, OrganizacionId)
                values (@nombre, @categoria, @fInicio, @fFin, @detalle, @cantidad, @ubicacionId, @organizacionId)
GO
-- Example
EXECUTE dbo.usp_InsertAnuncio 'Limpieza de calles', 'Limpieza', '02/05/2019', '15/11/2019','Explicacion del evento', 30, 1, 1
GO

-- Create a new stored procedure called 'usp_ListAnuncio' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'usp_ListAnuncio'
)
DROP PROCEDURE dbo.usp_ListAnuncio
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.usp_ListAnuncio
AS
SELECT * FROM Anuncio ORDER BY AnuncioId DESC
GO
-- Example
EXECUTE dbo.usp_ListAnuncio
GO

INSERT INTO Organizacion VALUES ('Naciones Unidas','20201211101', 'v@nu.org','01-201530','Calle Lima 123','Julia','Reina','del Bosque','12345678','DNI',0,1)
GO
INSERT INTO Ubicacion (Departamento, Provincia, Distrito) VALUES ('Amazonas', 'Chachapoyas', 'Cheto')
GO

select * from Ubicacion
go