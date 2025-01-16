USE [master]
GO

/****** Object:  Database [IRRADIANCIA]    Script Date: 15/01/2025 21:06:51 ******/
CREATE DATABASE [TESTE]
 
GO

USE [TESTE]
GO
CREATE SCHEMA [sde]
GO

USE [TESTE]
GO

CREATE TABLE [sde].[MUNICIPIO] (
	[UF] [numeric] (2) NOT NULL,
	[NOME_UF] [nvarchar] (40) NOT NULL,
	[REG_GEO_INT] [numeric] (4) NOT NULL,
	[NOME_REG_GEO_INT] [nvarchar] (40) NOT NULL,
	[REG_GEO_IME] [numeric] (6) NOT NULL,
	[NOME_REG_GEO_IME] [nvarchar] (40) NOT NULL,
	[MESO_GEO] [numeric] (2) NOT NULL,
	[NOME_MESO] [nvarchar] (40) NOT NULL,
	[MICRO_GEO] [numeric] (3) NOT NULL,
	[NOME_MICRO] [nvarchar] (40) NOT NULL,
	[MUNICIPIO] [numeric] (5) NOT NULL,
	[COD_MUNICIPIO] [numeric] (7) NOT NULL,
	[NOME_MUNICIPIO] [nvarchar] (40) NOT NULL
) ON [PRIMARY]

CREATE TABLE [sde].[IRRAD] (
	[COD_MUNICIPIO] [numeric] (7) NOT NULL,
	[MES] [numeric] (2) NOT NULL,
	[DIA] [numeric] (2) NOT NULL,
	[HORA] [numeric] (2) NOT NULL,
	[GT(I)_MEAN] [numeric] (6, 2) NOT NULL,
	[GT(I)_STD] [numeric] (6, 2) NOT NULL,
	[T2M_MEAN] [numeric] (6, 2) NOT NULL,
	[T2M_STD] [numeric] (6, 2) NOT NULL
) ON [PRIMARY]

