USE [DBONS]
GO

/****** Object:  Table [dbo].[wind_CURTAILMENT]    Script Date: 14/08/2025 16:55:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[wind_CURTAILMENT](
	[id_subsistema] [nvarchar](3) NOT NULL,
	[nom_subsistema] [nvarchar](10) NULL,
	[id_estado] [nvarchar](2) NULL,
	[nom_estado] [nvarchar](30) NULL,
	[nom_usina] [nvarchar](50) NULL,
	[id_ons] [nvarchar](30) NULL,
	[ceg] [nvarchar](30) NULL,
	[din_instante] [datetime] NULL,
	[val_geracao] [float] NULL,
	[val_geracaolimitada] [float] NULL,
	[val_disponibilidade] [float] NULL,
	[val_geracaoreferencia] [float] NULL,
	[val_geracaoreferenciafinal] [float] NULL,
	[cod_razaorestricao] [nvarchar](3) NULL,
	[cod_origemrestricao] [nvarchar](3) NULL,
	[ANO] [int] NULL,
	[MES] [int] NULL,
	[DIA] [int] NULL,
	[HORA] [int] NULL,
	[WeekDay] [int] NULL,
	[Data] [date] NULL,
	[DayoftheWeek] [nvarchar](20) NULL,
	[MonthoftheYear] [nvarchar](20) NULL,
	[HolidayCheck] [nvarchar](20) NULL,
	[Week_withHolidays] [nvarchar](20) NULL,
	[GeracaoReal] [float] NULL,
	[GeracaoCortada] [float] NULL,
	[GeracaoAjustada] [float] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[solar_CURTAILMENT]    Script Date: 18/08/2025 16:20:11 ******/
CREATE TABLE [dbo].[solar_CURTAILMENT](
	[id_subsistema] [nvarchar](3) NOT NULL,
	[nom_subsistema] [nvarchar](20) NULL,
	[id_estado] [nvarchar](2) NULL,
	[nom_estado] [nvarchar](50) NULL,
	[nom_usina] [nvarchar](80) NULL,
	[id_ons] [nvarchar](50) NULL,
	[ceg] [nvarchar](30) NULL,
	[din_instante] [datetime] NULL,
	[val_geracao] [float] NULL,
	[val_geracaolimitada] [float] NULL,
	[val_disponibilidade] [float] NULL,
	[val_geracaoreferencia] [float] NULL,
	[val_geracaoreferenciafinal] [float] NULL,
	[cod_razaorestricao] [nvarchar](3) NULL,
	[cod_origemrestricao] [nvarchar](3) NULL,
	[ANO] [int] NULL,
	[MES] [int] NULL,
	[DIA] [int] NULL,
	[HORA] [int] NULL,
	[WeekDay] [int] NULL,
	[Data] [date] NULL,
	[DayoftheWeek] [nvarchar](20) NULL,
	[MonthoftheYear] [nvarchar](20) NULL,
	[HolidayCheck] [nvarchar](20) NULL,
	[Week_withHolidays] [nvarchar](20) NULL,
	[GeracaoReal] [float] NULL,
	[GeracaoCortada] [float] NULL,
	[GeracaoAjustada] [float] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[USINA_CONJUNTO](
	[id_subsistema] [nvarchar](3) NOT NULL,
	[nom_subsistema] [nvarchar](20) NULL,
	[estad_id] [nvarchar](2) NULL,
	[nom_estado] [nvarchar](60) NULL,
	[id_tipousina] [nvarchar](3) NULL,
	[id_conjuntousina] [int] NULL,
	[id_ons_conjunto] [nvarchar](30) NULL,
	[id_ons_usina] [nvarchar](30) NOT NULL,
	[nom_conjunto] [nvarchar](60) NULL,
	[nom_usina] [nvarchar](60) NULL,
	[ceg] [nvarchar](30) NULL,
	[dat_iniciorelacionamento] [datetime] NULL,
	[dat_fimrelacionamento] [datetime] NULL
) ON [PRIMARY]
GO

CREATE VIEW [dbo].[Curtailment_Usinas]
WITH SCHEMABINDING
AS
SELECT nom_usina, cod_razaorestricao, YEAR(din_instante) as ano,
		SUM(CASE
					WHEN ([val_disponibilidade] - [val_geracao]) > 0
					THEN ([val_disponibilidade] - [val_geracao])
					ELSE 0
				END
			)/2000 AS curt
        FROM [dbo].[wind_CURTAILMENT]
		where cod_razaorestricao not in ('nan', '')
		group by YEAR(din_instante), nom_usina, cod_razaorestricao;
GO