USE [GEO_SIGR_PERDAS]
GO

CREATE SCHEMA [sde]
GO

/****** Object:  UserDefinedFunction [dbo].[CategoriaFaseSegmentoSGT]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[CategoriaFaseSegmentoSGT]
(
	-- Add the parameters for the function here
	@CodFase nvarchar(4)
)
RETURNS nvarchar(3)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Resultado nvarchar(3) = NULL

	-- Add the T-SQL statements to compute the return value here
	IF (@CodFase = N'ABC' OR @CodFase = N'ABCN') SET @Resultado = N'TRI'
	IF (@CodFase = N'AB' OR @CodFase = N'BC' OR @CodFase = N'CA' OR @CodFase = N'ABN' OR @CodFase = N'BCN' OR @CodFase = N'CAN') SET @Resultado = N'BIF'
	IF (@CodFase = N'A' OR @CodFase = N'B' OR @CodFase = N'C' OR @CodFase = N'AN' OR @CodFase = N'BN' OR @CodFase = N'CN') SET @Resultado = N'MON'

	-- Return the result of the function
	RETURN @Resultado

END




GO
/****** Object:  UserDefinedFunction [dbo].[CategoriaTrafoATATATMTSGT]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[CategoriaTrafoATATATMTSGT]
(
	-- Add the parameters for the function here
	@Tensao_kV decimal(18,9)
)
RETURNS nvarchar(6)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Resultado nvarchar(6) = NULL

	-- Add the T-SQL statements to compute the return value here
	IF (@Tensao_kV >= 230) SET @Resultado = N'>230'
	IF (@Tensao_kV >= 88 AND @Tensao_kV <= 145) SET @Resultado = N'88-138'
	IF (@Tensao_kV >= 60 AND @Tensao_kV <= 72.5) SET @Resultado = N'69'
	IF (@Tensao_kV >= 2.2 AND @Tensao_kV <= 48) SET @Resultado = N'2,3-44'

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[CategoriaTrafoMTMTMTBTSGT]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[CategoriaTrafoMTMTMTBTSGT]
(
	-- Add the parameters for the function here
	@Tensao_kV decimal(18,9)
)
RETURNS nvarchar(4)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Resultado nvarchar(4) = NULL

	-- Add the T-SQL statements to compute the return value here
	IF (@Tensao_kV >= 1 AND @Tensao_kV < 60) SET @Resultado = N'1-69'
	IF (@Tensao_kV < 1) SET @Resultado = N'<1'

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[EFeriado]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[EFeriado] 
(
	-- Add the parameters for the function here
	@dtData date
)
RETURNS int
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado int = 0
	DECLARE @Dia int = Day(@dtData), @Mes int = Month(@dtData), @Ano int = Year(@dtData)

	-- Add the T-SQL statements to compute the return value here
	IF (@Dia = 1 AND @Mes = 1) SET @Resultado = 1
	IF (@Dia = 21 AND @Mes = 4) SET @Resultado = 1
	IF (@Dia = 1 AND @Mes = 5) SET @Resultado = 1
	IF (@Dia = 7 AND @Mes = 9) SET @Resultado = 1
	IF (@Dia = 12 AND @Mes = 10) SET @Resultado = 1
	IF (@Dia = 2 AND @Mes = 11) SET @Resultado = 1
	IF (@Dia = 15 AND @Mes = 11) SET @Resultado = 1
	IF (@Dia = 25 AND @Mes = 12) SET @Resultado = 1
	IF (dbo.EFeriadoMovel(@Dia, @Mes, @Ano) = 1) SET @Resultado = 1

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[EFeriadoMovel]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[EFeriadoMovel]
(
	-- Add the parameters for the function here
	@Dia int,
	@Mes int,
	@Ano int
)
RETURNS int
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado int = 0
	DECLARE @temp01 int = 0, @temp02 int = 0, @temp03 int = 0, @temp04 int = 0, @temp05 int = 0, @temp06 int = 0, @temp07 int = 0, @temp08 int = 0, @temp09 int = 0, @temp10 int = 0, @temp11 int = 0, @temp12 int = 0, @temp13 int = 0, @temp14 int = 0
	DECLARE @DateInicial date = '2014-01-01', @DateFeriado1 date = '2014-01-01', @DateFeriado2 date = '2014-01-01', @DateFeriado3 date = '2014-01-01'

	-- Add the T-SQL statements to compute the return value here
	SET @temp01 = @Ano % 19
	SET @temp02 = @Ano / 100
	SET @temp03 = @Ano % 100
	SET @temp04 = @temp02 / 4
	SET @temp05 = @temp02 % 4
	SET @temp06 = (@temp02 + 8) / 25
	SET @temp07 = (@temp02 - @temp06 + 1) / 3
	SET @temp08 = (19 * @temp01 + @temp02 - @temp04 - @temp07 + 15) % 30
	SET @temp09 = @temp03 / 4
	SET @temp10 = @temp03 % 4
	SET @temp11 = (32 + 2 * @temp05 + 2 * @temp09 - @temp08 - @temp10) % 7
	SET @temp12 = (@temp01 + 11 * @temp08 + 22 * @temp11) / 451
	SET @temp13 = (@temp08 + @temp11 - 7 * @temp12 + 114) / 31
	SET @temp14 = (@temp08 + @temp11 - 7 * @temp12 + 114) % 31

	SET @DateInicial =  str(@Ano) + '-' + str(@temp13) + '-' +  str(@temp14 + 1)
	SET @DateFeriado1 = dateadd(day, -47, @DateInicial)
	SET @DateFeriado2 = dateadd(day, -2, @DateInicial)
	SET @DateFeriado3 = dateadd(day, 60, @DateInicial)
	IF (@Dia = DAY(@DateFeriado1) AND @Mes = MONTH(@DateFeriado1) AND @Ano = YEAR(@DateFeriado1)) SET @Resultado = 1
	IF (@Dia = DAY(@DateFeriado2) AND @Mes = MONTH(@DateFeriado2) AND @Ano = YEAR(@DateFeriado2)) SET @Resultado = 1
	IF (@Dia = DAY(@DateFeriado3) AND @Mes = MONTH(@DateFeriado3) AND @Ano = YEAR(@DateFeriado3)) SET @Resultado = 1

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[EscolhaPropriedade]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[EscolhaPropriedade] 
(
	-- Add the parameters for the function here
	@Propriedade01 nvarchar(2),
	@Propriedade02 nvarchar(2),
	@Propriedade03 nvarchar(2)
)
RETURNS nvarchar(2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Resultado nvarchar(2) = N'PR'

	-- Add the T-SQL statements to compute the return value here
	IF (@Propriedade01 = N'TC') SET @Resultado = N'TC'
	IF (@Propriedade02 = N'TC') SET @Resultado = N'TC'
	IF (@Propriedade03 = N'TC') SET @Resultado = N'TC'

	-- Return the result of the function
	RETURN @Resultado

END





GO
/****** Object:  UserDefinedFunction [dbo].[FasesCoincidentesReguladores]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FasesCoincidentesReguladores]
(
	-- Add the parameters for the function here
	@Var01 nvarchar(4),
	@Var02 nvarchar(4),
	@Var03 nvarchar(4),
	@Var04 nvarchar(4)
)
RETURNS nvarchar(1)
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado nvarchar(4) = ''
	DECLARE @LtA1 int, @LtB1 int, @LtC1 int
	DECLARE @LtA2 int, @LtB2 int, @LtC2 int
	DECLARE @LtA3 int, @LtB3 int, @LtC3 int
	DECLARE @LtA4 int, @LtB4 int, @LtC4 int

	-- Add the T-SQL statements to compute the return value here
	SET @LtA1 = charindex('A', @Var01)
	SET @LtB1 = charindex('B', @Var01)
	SET @LtC1 = charindex('C', @Var01)
	SET @LtA2 = charindex('A', @Var02)
	SET @LtB2 = charindex('B', @Var02)
	SET @LtC2 = charindex('C', @Var02)
	SET @LtA3 = charindex('A', @Var03)
	SET @LtB3 = charindex('B', @Var03)
	SET @LtC3 = charindex('C', @Var03)
	SET @LtA4 = charindex('A', @Var04)
	SET @LtB4 = charindex('B', @Var04)
	SET @LtC4 = charindex('C', @Var04)

	IF (@LtA1 <> 0 And @LtA2 <> 0 And @LtA3 <> 0 And @LtA4 <> 0) SET @Resultado = @Resultado + 'A'
	IF (@LtB1 <> 0 And @LtB2 <> 0 And @LtB3 <> 0 And @LtB4 <> 0) SET @Resultado = @Resultado + 'B'
	IF (@LtC1 <> 0 And @LtC2 <> 0 AND @LtC3 <> 0 And @LtC4 <> 0) SET @Resultado = @Resultado + 'C'
	SET @Resultado = @Resultado + 'X'

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[FasesDeltaAbertoProblematico]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FasesDeltaAbertoProblematico]
(
	-- Add the parameters for the function here
	@Var01 nvarchar(4),
	@Var02 nvarchar(4),
	@Var03 nvarchar(4),
	@Var04 nvarchar(4),
	@Var05 nvarchar(4),
	@Var06 nvarchar(4)
)
RETURNS int
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado int = 1

	-- Add the T-SQL statements to compute the return value here
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'BC' Or @Var05 = 'CA') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'BC' Or @Var05 = 'CA') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'BC' Or @Var05 = 'AB') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'BC' Or @Var05 = 'AB') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'CA' Or @Var05 = 'AB') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'CA' Or @Var05 = 'AB') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'CA' Or @Var05 = 'AB') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'CA' Or @Var05 = 'AB') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'BC' Or @Var05 = 'CA') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'BC' Or @Var05 = 'CA') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'BC' Or @Var05 = 'AB') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'BC' Or @Var05 = 'AB') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'BC' Or @Var05 = 'AB') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'BC' Or @Var05 = 'AB') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'CA' Or @Var05 = 'AB') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'CA' Or @Var05 = 'AB') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'BC' Or @Var05 = 'CA') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'BC' Or @Var05 = 'CA') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'BC' Or @Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'BC' Or @Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'BC' Or @Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'BC' Or @Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'CA' Or @Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'CA' Or @Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'CA' Or @Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'CA' Or @Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'BC' Or @Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'BC' Or @Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'BC' Or @Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'BC' Or @Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'BC' Or @Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'BC' Or @Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'CA' Or @Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'CA' Or @Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'BC' Or @Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'BC' Or @Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0

	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'A' Or @Var02 = 'AN') And @Var03 = 'XX' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'A' Or @Var02 = 'AN') And @Var03 = 'XX' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'A' Or @Var02 = 'AN') And @Var03 = 'XX' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'A' Or @Var02 = 'AN') And @Var03 = 'XX' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'B' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'B' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'B' oR @Var02 = 'BN') And @Var03 = 'XX' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'B' oR @Var02 = 'BN') And @Var03 = 'XX' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'B' oR @Var02 = 'BN') And @Var03 = 'XX' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN' Or @Var01 = 'AB') And (@Var02 = 'B' oR @Var02 = 'BN') And @Var03 = 'XX' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'A' Or @Var02 = 'AN') And @Var03 = 'XX' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'A' Or @Var02 = 'AN') And @Var03 = 'XX' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'A' Or @Var02 = 'AN') And @Var03 = 'XX' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'A' Or @Var02 = 'AN') And @Var03 = 'XX' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'B' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'B' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'B' oR @Var02 = 'BN') And @Var03 = 'XX' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'B' oR @Var02 = 'BN') And @Var03 = 'XX' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'B' oR @Var02 = 'BN') And @Var03 = 'XX' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN' Or @Var01 = 'BC') And (@Var02 = 'B' oR @Var02 = 'BN') And @Var03 = 'XX' And (@Var04 = 'C' Or @Var04 = 'CN' Or @Var04 = 'CA') And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'A' Or @Var02 = 'AN') And @Var03 = 'XX' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'A' Or @Var02 = 'AN') And @Var03 = 'XX' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'A' Or @Var02 = 'AN') And @Var03 = 'XX' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'A' Or @Var02 = 'AN') And @Var03 = 'XX' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'B' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'B' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'B' oR @Var02 = 'BN') And @Var03 = 'XX' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'B' oR @Var02 = 'BN') And @Var03 = 'XX' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'B' oR @Var02 = 'BN') And @Var03 = 'XX' And (@Var04 = 'A' Or @Var04 = 'AN' Or @Var04 = 'AB') And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN' Or @Var01 = 'CA') And (@Var02 = 'B' oR @Var02 = 'BN') And @Var03 = 'XX' And (@Var04 = 'B' Or @Var04 = 'BN' Or @Var04 = 'BC') And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX') SET @Resultado = 0

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[FasesDeltaAbertoRegulProblematico]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FasesDeltaAbertoRegulProblematico] 
(
	-- Add the parameters for the function here
	@Var01 nvarchar(4),
	@Var02 nvarchar(4),
	@Var03 nvarchar(4),
	@Var04 nvarchar(4)
)
RETURNS int
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado int = 1

	-- Add the T-SQL statements to compute the return value here
	IF (@Var01 = 'AB' And @Var02 = 'AB' And @Var03 = 'BC' And @Var04 = 'BC') SET @Resultado = 0
	IF (@Var01 = 'AB' And @Var02 = 'AB' And @Var03 = 'CA' And @Var04 = 'CA') SET @Resultado = 0
	IF (@Var01 = 'BC' And @Var02 = 'BC' And @Var03 = 'CA' And @Var04 = 'CA') SET @Resultado = 0
	IF (@Var01 = 'BC' And @Var02 = 'BC' And @Var03 = 'AB' And @Var04 = 'AB') SET @Resultado = 0
	IF (@Var01 = 'CA' And @Var02 = 'CA' And @Var03 = 'AB' And @Var04 = 'AB') SET @Resultado = 0
	IF (@Var01 = 'CA' And @Var02 = 'CA' And @Var03 = 'BC' And @Var04 = 'BC') SET @Resultado = 0

	IF (@Var01 = 'AN' And @Var02 = 'AN' And @Var03 = 'BN' And @Var04 = 'BN') SET @Resultado = 0
	IF (@Var01 = 'AN' And @Var02 = 'AN' And @Var03 = 'CN' And @Var04 = 'CN') SET @Resultado = 0
	IF (@Var01 = 'BN' And @Var02 = 'BN' And @Var03 = 'CN' And @Var04 = 'CN') SET @Resultado = 0
	IF (@Var01 = 'BN' And @Var02 = 'BN' And @Var03 = 'AN' And @Var04 = 'AN') SET @Resultado = 0
	IF (@Var01 = 'CN' And @Var02 = 'CN' And @Var03 = 'AN' And @Var04 = 'AN') SET @Resultado = 0
	IF (@Var01 = 'CN' And @Var02 = 'CN' And @Var03 = 'BN' And @Var04 = 'BN') SET @Resultado = 0

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[FasesDeltaFechadoProblematico]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FasesDeltaFechadoProblematico]
(
	-- Add the parameters for the function here
	@Var01 nvarchar(4),
	@Var02 nvarchar(4),
	@Var03 nvarchar(4),
	@Var04 nvarchar(4),
	@Var05 nvarchar(4),
	@Var06 nvarchar(4),
	@Var07 nvarchar(4),
	@Var08 nvarchar(4),
	@Var09 nvarchar(4)
)
RETURNS int
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado int = 1

	-- Add the T-SQL statements to compute the return value here
	IF ((@Var01 = 'A' Or @Var01 = 'AN') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0     
	IF ((@Var01 = 'A' Or @Var01 = 'AN') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0       
	IF ((@Var01 = 'A' Or @Var01 = 'AN') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0        
	IF ((@Var01 = 'A' Or @Var01 = 'AN') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0        
	IF ((@Var01 = 'A' Or @Var01 = 'AN') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0        
	IF ((@Var01 = 'A' Or @Var01 = 'AN') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0 
	IF ((@Var01 = 'A' Or @Var01 = 'AN') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0        
	IF ((@Var01 = 'A' Or @Var01 = 'AN') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0        
	IF ((@Var01 = 'A' Or @Var01 = 'AN') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0        
	IF ((@Var01 = 'A' Or @Var01 = 'AN') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0        
	IF ((@Var01 = 'A' Or @Var01 = 'AN') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'A' Or @Var01 = 'AN') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'AB') And @Var03 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'BC') And @Var03 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'CA') And @Var03 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'BC') And @Var03 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'CA') And @Var03 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'AB') And @Var03 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'AB') And @Var03 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'BC') And @Var03 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'CA') And @Var03 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'BC') And @Var03 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'CA') And @Var03 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'A' Or @Var04 = 'AN') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'AB') And @Var03 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'A' Or @Var07 = 'AN') And @Var08 = 'CN' And @Var09 = 'AN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'BC') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'A' Or @Var07 = 'AN') And @Var08 = 'CN' And @Var09 = 'AN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'A' Or @Var07 = 'AN') And @Var08 = 'AN' And @Var09 = 'BN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'BC') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'A' Or @Var07 = 'AN') And @Var08 = 'AN' And @Var09 = 'BN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'A' Or @Var07 = 'AN') And @Var08 = 'BN' And @Var09 = 'CN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'A' Or @Var07 = 'AN') And @Var08 = 'BN' And @Var09 = 'CN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'A' Or @Var07 = 'AN') And @Var08 = 'CN' And @Var09 = 'AN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'BC') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'A' Or @Var07 = 'AN') And @Var08 = 'CN' And @Var09 = 'AN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'A' Or @Var07 = 'AN') And @Var08 = 'AN' And @Var09 = 'BN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'BC') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'A' Or @Var07 = 'AN') And @Var08 = 'AN' And @Var09 = 'BN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'A' Or @Var07 = 'AN') And @Var08 = 'BN' And @Var09 = 'CN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'A' Or @Var07 = 'AN') And @Var08 = 'BN' And @Var09 = 'CN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'B' Or @Var01 = 'BN') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'AB') And @Var03 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'BC') And @Var03 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'CA') And @Var03 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'BC') And @Var03 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'CA') And @Var03 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'AB') And @Var03 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'AB') And @Var03 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'BC') And @Var03 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'CA') And @Var03 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'BC') And @Var03 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'CA') And @Var03 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'B' Or @Var04 = 'BN') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'AB') And @Var03 = 'XX' And (@Var07 = 'C' Or @Var07 = 'CN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'B' Or @Var07 = 'BN') And @Var08 = 'CN' And @Var09 = 'AN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'BC') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'B' Or @Var07 = 'BN') And @Var08 = 'CN' And @Var09 = 'AN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'B' Or @Var07 = 'BN') And @Var08 = 'AN' And @Var09 = 'BN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'BC') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'B' Or @Var07 = 'BN') And @Var08 = 'AN' And @Var09 = 'BN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'B' Or @Var07 = 'BN') And @Var08 = 'BN' And @Var09 = 'CN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'B' Or @Var07 = 'BN') And @Var08 = 'BN' And @Var09 = 'CN' And (@Var04 = 'C' Or @Var04 = 'CN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'B' Or @Var07 = 'BN') And @Var08 = 'CN' And @Var09 = 'AN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'BC') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'B' Or @Var07 = 'BN') And @Var08 = 'CN' And @Var09 = 'AN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'B' Or @Var07 = 'BN') And @Var08 = 'AN' And @Var09 = 'BN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'BC') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'B' Or @Var07 = 'BN') And @Var08 = 'AN' And @Var09 = 'BN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'B' Or @Var07 = 'BN') And @Var08 = 'BN' And @Var09 = 'CN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'B' Or @Var07 = 'BN') And @Var08 = 'BN' And @Var09 = 'CN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var01 = 'C' Or @Var01 = 'CN') And (@Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN') And @Var02 = 'CN' And @Var03 = 'AN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN') And @Var02 = 'AN' And @Var03 = 'BN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var01 = 'C' Or @Var01 = 'CN') And @Var02 = 'BN' And @Var03 = 'CN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'AB') And @Var03 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'BC') And @Var03 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'CA') And @Var03 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'BC') And @Var03 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'CA') And @Var03 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'AB') And @Var03 = 'XX' And (@Var07 = 'A' Or @Var07 = 'AN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'AB') And @Var03 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN') And @Var05 = 'CN' And @Var06 = 'AN' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'BC') And @Var03 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'CA') And @Var03 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'BC') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN') And @Var05 = 'AN' And @Var06 = 'BN' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'BC') And @Var03 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'CA') And @Var03 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'AB') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var04 = 'C' Or @Var04 = 'CN') And @Var05 = 'BN' And @Var06 = 'CN' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'AB') And @Var03 = 'XX' And (@Var07 = 'B' Or @Var07 = 'BN') And (@Var08 = 'CA') And @Var09 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'C' Or @Var07 = 'CN') And @Var08 = 'CN' And @Var09 = 'AN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'BC') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'C' Or @Var07 = 'CN') And @Var08 = 'CN' And @Var09 = 'AN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'C' Or @Var07 = 'CN') And @Var08 = 'AN' And @Var09 = 'BN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'BC') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'C' Or @Var07 = 'CN') And @Var08 = 'AN' And @Var09 = 'BN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'C' Or @Var07 = 'CN') And @Var08 = 'BN' And @Var09 = 'CN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'C' Or @Var07 = 'CN') And @Var08 = 'BN' And @Var09 = 'CN' And (@Var04 = 'B' Or @Var04 = 'BN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var01 = 'A' Or @Var01 = 'AN') And (@Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'C' Or @Var07 = 'CN') And @Var08 = 'CN' And @Var09 = 'AN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'BC') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'C' Or @Var07 = 'CN') And @Var08 = 'CN' And @Var09 = 'AN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'C' Or @Var07 = 'CN') And @Var08 = 'AN' And @Var09 = 'BN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'BC') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'C' Or @Var07 = 'CN') And @Var08 = 'AN' And @Var09 = 'BN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'BC') And @Var06 = 'XX' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'C' Or @Var07 = 'CN') And @Var08 = 'BN' And @Var09 = 'CN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'CA') And @Var06 = 'XX' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'AB') And @Var03 = 'XX') SET @Resultado = 0
	IF ((@Var07 = 'C' Or @Var07 = 'CN') And @Var08 = 'BN' And @Var09 = 'CN' And (@Var04 = 'A' Or @Var04 = 'AN') And (@Var05 = 'AB') And @Var06 = 'XX' And (@Var01 = 'B' Or @Var01 = 'BN') And (@Var02 = 'CA') And @Var03 = 'XX') SET @Resultado = 0

	IF (@Var01 = 'AB' And (@Var02 = 'A' Or @Var02 = 'AN') And @Var03 = 'XX' And @Var04 = 'BC'And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX' And @Var07 = 'CA' And (@Var08 = 'C' Or @Var08 = 'CN') And @Var09 = 'XX') SET @Resultado = 0     
	IF (@Var01 = 'AB' And (@Var02 = 'A' Or @Var02 = 'AN') And @Var03 = 'XX' And @Var04 = 'CA'And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX' And @Var07 = 'BC' And (@Var08 = 'C' Or @Var08 = 'CN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'BC' And (@Var02 = 'A' oR @Var02 = 'AN') And @Var03 = 'XX' And @Var04 = 'AB'And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX' And @Var07 = 'CA' And (@Var08 = 'C' Or @Var08 = 'CN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'BC' And (@Var02 = 'A' oR @Var02 = 'AN') And @Var03 = 'XX' And @Var04 = 'CA'And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX' And @Var07 = 'AB' And (@Var08 = 'C' Or @Var08 = 'CN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'CA' And (@Var02 = 'A' oR @Var02 = 'AN') And @Var03 = 'XX' And @Var04 = 'AB'And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX' And @Var07 = 'BC' And (@Var08 = 'C' Or @Var08 = 'CN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'CA' And (@Var02 = 'A' oR @Var02 = 'AN') And @Var03 = 'XX' And @Var04 = 'BC'And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX' And @Var07 = 'AB' And (@Var08 = 'C' Or @Var08 = 'CN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'AB' And (@Var02 = 'A' oR @Var02 = 'AN') And @Var03 = 'XX' And @Var04 = 'BC'And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX' And @Var07 = 'CA' And (@Var08 = 'B' Or @Var08 = 'BN') And @Var09 = 'XX') SET @Resultado = 0     
	IF (@Var01 = 'AB' And (@Var02 = 'A' oR @Var02 = 'AN') And @Var03 = 'XX' And @Var04 = 'CA'And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX' And @Var07 = 'BC' And (@Var08 = 'B' Or @Var08 = 'BN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'BC' And (@Var02 = 'A' oR @Var02 = 'AN') And @Var03 = 'XX' And @Var04 = 'AB'And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX' And @Var07 = 'CA' And (@Var08 = 'B' Or @Var08 = 'BN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'BC' And (@Var02 = 'A' oR @Var02 = 'AN') And @Var03 = 'XX' And @Var04 = 'CA'And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX' And @Var07 = 'AB' And (@Var08 = 'B' Or @Var08 = 'BN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'CA' And (@Var02 = 'A' oR @Var02 = 'AN') And @Var03 = 'XX' And @Var04 = 'AB'And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX' And @Var07 = 'BC' And (@Var08 = 'B' Or @Var08 = 'BN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'CA' And (@Var02 = 'A' oR @Var02 = 'AN') And @Var03 = 'XX' And @Var04 = 'BC'And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX' And @Var07 = 'AB' And (@Var08 = 'B' Or @Var08 = 'BN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'AB' And (@Var02 = 'B' Or @Var02 = 'BN') And @Var03 = 'XX' And @Var04 = 'BC'And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX' And @Var07 = 'CA' And (@Var08 = 'C' Or @Var08 = 'CN') And @Var09 = 'XX') SET @Resultado = 0     
	IF (@Var01 = 'AB' And (@Var02 = 'B' Or @Var02 = 'BN') And @Var03 = 'XX' And @Var04 = 'CA'And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX' And @Var07 = 'BC' And (@Var08 = 'C' Or @Var08 = 'CN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'BC' And (@Var02 = 'B' Or @Var02 = 'BN') And @Var03 = 'XX' And @Var04 = 'AB'And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX' And @Var07 = 'CA' And (@Var08 = 'C' Or @Var08 = 'CN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'BC' And (@Var02 = 'B' Or @Var02 = 'BN') And @Var03 = 'XX' And @Var04 = 'CA'And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX' And @Var07 = 'AB' And (@Var08 = 'C' Or @Var08 = 'CN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'CA' And (@Var02 = 'B' Or @Var02 = 'BN') And @Var03 = 'XX' And @Var04 = 'AB'And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX' And @Var07 = 'BC' And (@Var08 = 'C' Or @Var08 = 'CN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'CA' And (@Var02 = 'B' Or @Var02 = 'BN') And @Var03 = 'XX' And @Var04 = 'BC'And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX' And @Var07 = 'AB' And (@Var08 = 'C' Or @Var08 = 'CN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'AB' And (@Var02 = 'B' Or @Var02 = 'BN') And @Var03 = 'XX' And @Var04 = 'BC'And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX' And @Var07 = 'CA' And (@Var08 = 'A' Or @Var08 = 'AN') And @Var09 = 'XX') SET @Resultado = 0     
	IF (@Var01 = 'AB' And (@Var02 = 'B' Or @Var02 = 'BN') And @Var03 = 'XX' And @Var04 = 'CA'And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX' And @Var07 = 'BC' And (@Var08 = 'A' Or @Var08 = 'AN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'BC' And (@Var02 = 'B' Or @Var02 = 'BN') And @Var03 = 'XX' And @Var04 = 'AB'And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX' And @Var07 = 'CA' And (@Var08 = 'A' Or @Var08 = 'AN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'BC' And (@Var02 = 'B' Or @Var02 = 'BN') And @Var03 = 'XX' And @Var04 = 'CA'And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX' And @Var07 = 'AB' And (@Var08 = 'A' Or @Var08 = 'AN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'CA' And (@Var02 = 'B' Or @Var02 = 'BN') And @Var03 = 'XX' And @Var04 = 'AB'And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX' And @Var07 = 'BC' And (@Var08 = 'A' Or @Var08 = 'AN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'CA' And (@Var02 = 'B' Or @Var02 = 'BN') And @Var03 = 'XX' And @Var04 = 'BC'And (@Var05 = 'C' Or @Var05 = 'CN') And @Var06 = 'XX' And @Var07 = 'AB' And (@Var08 = 'A' Or @Var08 = 'AN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'AB' And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And @Var04 = 'BC'And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX' And @Var07 = 'CA' And (@Var08 = 'A' Or @Var08 = 'AN') And @Var09 = 'XX') SET @Resultado = 0     
	IF (@Var01 = 'AB' And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And @Var04 = 'CA'And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX' And @Var07 = 'BC' And (@Var08 = 'A' Or @Var08 = 'AN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'BC' And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And @Var04 = 'AB'And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX' And @Var07 = 'CA' And (@Var08 = 'A' Or @Var08 = 'AN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'BC' And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And @Var04 = 'CA'And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX' And @Var07 = 'AB' And (@Var08 = 'A' Or @Var08 = 'AN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'CA' And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And @Var04 = 'AB'And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX' And @Var07 = 'BC' And (@Var08 = 'A' Or @Var08 = 'AN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'CA' And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And @Var04 = 'BC'And (@Var05 = 'B' Or @Var05 = 'BN') And @Var06 = 'XX' And @Var07 = 'AB' And (@Var08 = 'A' Or @Var08 = 'AN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'AB' And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And @Var04 = 'BC'And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX' And @Var07 = 'CA' And (@Var08 = 'B' Or @Var08 = 'BN') And @Var09 = 'XX') SET @Resultado = 0     
	IF (@Var01 = 'AB' And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And @Var04 = 'CA'And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX' And @Var07 = 'BC' And (@Var08 = 'B' Or @Var08 = 'BN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'BC' And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And @Var04 = 'AB'And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX' And @Var07 = 'CA' And (@Var08 = 'B' Or @Var08 = 'BN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'BC' And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And @Var04 = 'CA'And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX' And @Var07 = 'AB' And (@Var08 = 'B' Or @Var08 = 'BN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'CA' And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And @Var04 = 'AB'And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX' And @Var07 = 'BC' And (@Var08 = 'B' Or @Var08 = 'BN') And @Var09 = 'XX') SET @Resultado = 0
	IF (@Var01 = 'CA' And (@Var02 = 'C' Or @Var02 = 'CN') And @Var03 = 'XX' And @Var04 = 'BC'And (@Var05 = 'A' Or @Var05 = 'AN') And @Var06 = 'XX' And @Var07 = 'AB' And (@Var08 = 'B' Or @Var08 = 'BN') And @Var09 = 'XX') SET @Resultado = 0

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[FasesDeltaFechadoRegulProblematico]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FasesDeltaFechadoRegulProblematico] 
(
	-- Add the parameters for the function here
	@Var01 nvarchar(4),
	@Var02 nvarchar(4),
	@Var03 nvarchar(4),
	@Var04 nvarchar(4),
	@Var05 nvarchar(4),
	@Var06 nvarchar(4)	
)
RETURNS int
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado int = 1

	-- Add the T-SQL statements to compute the return value here
	IF (@Var01 = 'AB' And @Var02 = 'AB' And @Var03 = 'BC' And @Var04 = 'BC' And @Var05 = 'CA' And @Var06 = 'CA') SET @Resultado = 0
	IF (@Var01 = 'AB' And @Var02 = 'AB' And @Var03 = 'CA' And @Var04 = 'CA' And @Var05 = 'BC' And @Var06 = 'BC') SET @Resultado = 0
	IF (@Var01 = 'BC' And @Var02 = 'BC' And @Var03 = 'CA' And @Var04 = 'CA' And @Var05 = 'AB' And @Var06 = 'AB') SET @Resultado = 0
	IF (@Var01 = 'BC' And @Var02 = 'BC' And @Var03 = 'AB' And @Var04 = 'AB' And @Var05 = 'CA' And @Var06 = 'CA') SET @Resultado = 0
	IF (@Var01 = 'CA' And @Var02 = 'CA' And @Var03 = 'AB' And @Var04 = 'AB' And @Var05 = 'BC' And @Var06 = 'BC') SET @Resultado = 0
	IF (@Var01 = 'CA' And @Var02 = 'CA' And @Var03 = 'BC' And @Var04 = 'BC' And @Var05 = 'AB' And @Var06 = 'AB') SET @Resultado = 0

	IF (@Var01 = 'AN' And @Var02 = 'AN' And @Var03 = 'BN' And @Var04 = 'BN' And @Var05 = 'CN' And @Var06 = 'CN') SET @Resultado = 0
	IF (@Var01 = 'AN' And @Var02 = 'AN' And @Var03 = 'CN' And @Var04 = 'CN' And @Var05 = 'BN' And @Var06 = 'BN') SET @Resultado = 0
	IF (@Var01 = 'BN' And @Var02 = 'BN' And @Var03 = 'CN' And @Var04 = 'CN' And @Var05 = 'AN' And @Var06 = 'AN') SET @Resultado = 0
	IF (@Var01 = 'BN' And @Var02 = 'BN' And @Var03 = 'AN' And @Var04 = 'AN' And @Var05 = 'CN' And @Var06 = 'CN') SET @Resultado = 0
	IF (@Var01 = 'CN' And @Var02 = 'CN' And @Var03 = 'AN' And @Var04 = 'AN' And @Var05 = 'BN' And @Var06 = 'BN') SET @Resultado = 0
	IF (@Var01 = 'CN' And @Var02 = 'CN' And @Var03 = 'BN' And @Var04 = 'BN' And @Var05 = 'AN' And @Var06 = 'AN') SET @Resultado = 0
	
	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[FasesEquivalentePrim]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FasesEquivalentePrim]
(
	-- Add the parameters for the function here
	@Var01 nvarchar(4),
	@Var02 nvarchar(4),
	@Var03 nvarchar(4)
)
RETURNS nvarchar(4)
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado nvarchar(4) = ''
	DECLARE @LtA1 int, @LtB1 int, @LtC1 int
	DECLARE @LtA2 int, @LtB2 int, @LtC2 int
	DECLARE @LtA3 int, @LtB3 int, @LtC3 int

	-- Add the T-SQL statements to compute the return value here
	SET @LtA1 = charindex('A', @Var01)
	SET @LtB1 = charindex('B', @Var01)
	SET @LtC1 = charindex('C', @Var01)
	SET @LtA2 = charindex('A', @Var02)
	SET @LtB2 = charindex('B', @Var02)
	SET @LtC2 = charindex('C', @Var02)
	SET @LtA3 = charindex('A', @Var03)
	SET @LtB3 = charindex('B', @Var03)
	SET @LtC3 = charindex('C', @Var03)

	IF (@LtA1 <> 0 Or @LtA2 <> 0 Or @LtA3 <> 0) SET @Resultado = @Resultado + 'A'
	IF (@LtB1 <> 0 Or @LtB2 <> 0 Or @LtB3 <> 0) SET @Resultado = @Resultado + 'B'
	IF (@LtC1 <> 0 Or @LtC2 <> 0 Or @LtC3 <> 0) SET @Resultado = @Resultado + 'C'
	IF (@Resultado = 'AC') SET @Resultado = 'CA'

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[FasesEquivalenteSecu]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FasesEquivalenteSecu]
(
	-- Add the parameters for the function here
	@Var01 nvarchar(4),
	@Var02 nvarchar(4),
	@Var03 nvarchar(4),
	@Var04 nvarchar(4),
	@Var05 nvarchar(4),
	@Var06 nvarchar(4)
)
RETURNS nvarchar(4)
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado nvarchar(4) = ''
	DECLARE @LtA1 int, @LtB1 int, @LtC1 int, @LtN1 int
	DECLARE @LtA2 int, @LtB2 int, @LtC2 int, @LtN2 int
	DECLARE @LtA3 int, @LtB3 int, @LtC3 int, @LtN3 int
	DECLARE @LtA4 int, @LtB4 int, @LtC4 int, @LtN4 int
	DECLARE @LtA5 int, @LtB5 int, @LtC5 int, @LtN5 int
	DECLARE @LtA6 int, @LtB6 int, @LtC6 int, @LtN6 int

	-- Add the T-SQL statements to compute the return value here
	SET @LtA1 = charindex('A', @Var01)
	SET @LtB1 = charindex('B', @Var01)
	SET @LtC1 = charindex('C', @Var01)
	SET @LtN1 = charindex('N', @Var01)
	SET @LtA2 = charindex('A', @Var02)
	SET @LtB2 = charindex('B', @Var02)
	SET @LtC2 = charindex('C', @Var02)
	SET @LtN2 = charindex('N', @Var02)
	SET @LtA3 = charindex('A', @Var03)
	SET @LtB3 = charindex('B', @Var03)
	SET @LtC3 = charindex('C', @Var03)
	SET @LtN3 = charindex('N', @Var03)
	SET @LtA4 = charindex('A', @Var04)
	SET @LtB4 = charindex('B', @Var04)
	SET @LtC4 = charindex('C', @Var04)
	SET @LtN4 = charindex('N', @Var04)
	SET @LtA5 = charindex('A', @Var05)
	SET @LtB5 = charindex('B', @Var05)
	SET @LtC5 = charindex('C', @Var05)
	SET @LtN5 = charindex('N', @Var05)
	SET @LtA6 = charindex('A', @Var06)
	SET @LtB6 = charindex('B', @Var06)
	SET @LtC6 = charindex('C', @Var06)
	SET @LtN6 = charindex('N', @Var06)

	IF (@LtA1 <> 0 Or @LtA2 <> 0 Or @LtA3 <> 0 Or @LtA4 <> 0 Or @LtA5 <> 0 Or @LtA6 <> 0) SET @Resultado = @Resultado + 'A'
	IF (@LtB1 <> 0 Or @LtB2 <> 0 Or @LtB3 <> 0 Or @LtB4 <> 0 Or @LtB5 <> 0 Or @LtB6 <> 0) SET @Resultado = @Resultado + 'B'
	IF (@LtC1 <> 0 Or @LtC2 <> 0 Or @LtC3 <> 0 Or @LtC4 <> 0 Or @LtC5 <> 0 Or @LtC6 <> 0) SET @Resultado = @Resultado + 'C'
	IF (@Resultado = 'AC') SET @Resultado = 'CA'
	IF (@LtN1 <> 0 Or @LtN2 <> 0 Or @LtN3 <> 0 Or @LtN4 <> 0 Or @LtN5 <> 0 Or @LtN6 <> 0) SET @Resultado = @Resultado + 'N'

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[FasesEstaProblematicaTrafoNCrtNeutro]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FasesEstaProblematicaTrafoNCrtNeutro]
(
	-- Add the parameters for the function here
	@FaseAnterior nvarchar(4),
	@FasePosterior nvarchar(4)
)
RETURNS int
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado int = 1

	-- Add the T-SQL statements to compute the return value here
	IF (@FaseAnterior = 'ABCN' OR @FaseAnterior = 'ABC') AND (@FasePosterior = 'ABCN' OR @FasePosterior = 'ABC') SET @Resultado = 0
	IF (@FaseAnterior = 'A' OR @FaseAnterior = 'AN') AND (@FasePosterior = 'A' OR @FasePosterior = 'AN') SET @Resultado = 0
	IF (@FaseAnterior = 'B' OR @FaseAnterior = 'BN') AND (@FasePosterior = 'B' OR @FasePosterior = 'BN') SET @Resultado = 0
	IF (@FaseAnterior = 'C' OR @FaseAnterior = 'CN') AND (@FasePosterior = 'C' OR @FasePosterior = 'CN') SET @Resultado = 0	
	IF (@FaseAnterior = 'AB' OR @FaseAnterior = 'ABN') AND (@FasePosterior = 'AB' OR @FasePosterior = 'ABN') SET @Resultado = 0
	IF (@FaseAnterior = 'BC' OR @FaseAnterior = 'BCN') AND (@FasePosterior = 'BC' OR @FasePosterior = 'BCN') SET @Resultado = 0
	IF (@FaseAnterior = 'CA' OR @FaseAnterior = 'CAN') AND (@FasePosterior = 'CA' OR @FasePosterior = 'CAN') SET @Resultado = 0

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[FasesEstaProblematicaTramoNCrtNeutro]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FasesEstaProblematicaTramoNCrtNeutro]
(
	-- Add the parameters for the function here
	@FaseAnterior nvarchar(4),
	@FasePosterior nvarchar(4)
)
RETURNS int
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado int = 1

	-- Add the T-SQL statements to compute the return value here
	IF (@FaseAnterior = 'ABCN' OR @FaseAnterior = 'ABC') AND (@FasePosterior = 'ABCN' OR @FasePosterior = 'ABC' OR @FasePosterior = 'ABN' OR @FasePosterior = 'AB' OR @FasePosterior = 'BCN' OR @FasePosterior = 'BC' OR @FasePosterior = 'CAN' OR @FasePosterior = 'CA' OR @FasePosterior = 'AN' OR @FasePosterior = 'A' OR @FasePosterior = 'BN' OR @FasePosterior = 'B' OR @FasePosterior = 'CN' OR @FasePosterior = 'C') SET @Resultado = 0
	IF (@FaseAnterior = 'ABN' OR @FaseAnterior = 'AB') AND (@FasePosterior = 'ABN' OR @FasePosterior = 'AB' OR @FasePosterior = 'AN' OR @FasePosterior = 'A' OR @FasePosterior = 'BN' OR @FasePosterior = 'B') SET @Resultado = 0
	IF (@FaseAnterior = 'BCN' OR @FaseAnterior = 'BC') AND (@FasePosterior = 'BCN' OR @FasePosterior = 'BC' OR @FasePosterior = 'BN' OR @FasePosterior = 'B' OR @FasePosterior = 'CN' OR @FasePosterior = 'C') SET @Resultado = 0
	IF (@FaseAnterior = 'CAN' OR @FaseAnterior = 'CA') AND (@FasePosterior = 'CAN' OR @FasePosterior = 'CA' OR @FasePosterior = 'AN' OR @FasePosterior = 'A' OR @FasePosterior = 'CN' OR @FasePosterior = 'C') SET @Resultado = 0
	IF (@FaseAnterior = 'AN' OR @FaseAnterior = 'A') AND (@FasePosterior = 'AN' OR @FasePosterior = 'A') SET @Resultado = 0
	IF (@FaseAnterior = 'BN' OR @FaseAnterior = 'B') AND (@FasePosterior = 'BN' OR @FasePosterior = 'B') SET @Resultado = 0
	IF (@FaseAnterior = 'CN' OR @FaseAnterior = 'C') AND (@FasePosterior = 'CN' OR @FasePosterior = 'C') SET @Resultado = 0

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[Max24Patamares]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[Max24Patamares] 
(
	-- Add the parameters for the function here
	@Var01 decimal(18,9),
	@Var02 decimal(18,9),
	@Var03 decimal(18,9),
	@Var04 decimal(18,9),
	@Var05 decimal(18,9),
	@Var06 decimal(18,9),
	@Var07 decimal(18,9),
	@Var08 decimal(18,9),
	@Var09 decimal(18,9),
	@Var10 decimal(18,9),
	@Var11 decimal(18,9),
	@Var12 decimal(18,9),
	@Var13 decimal(18,9),
	@Var14 decimal(18,9),
	@Var15 decimal(18,9),
	@Var16 decimal(18,9),
	@Var17 decimal(18,9),
	@Var18 decimal(18,9),
	@Var19 decimal(18,9),
	@Var20 decimal(18,9),
	@Var21 decimal(18,9),
	@Var22 decimal(18,9),
	@Var23 decimal(18,9),
	@Var24 decimal(18,9)
)
RETURNS decimal(18,9)
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado decimal(18,9) = 0.0

	-- Add the T-SQL statements to compute the return value here
	IF (@Var01 > @Resultado) SET @Resultado = @Var01
	IF (@Var02 > @Resultado) SET @Resultado = @Var02
	IF (@Var03 > @Resultado) SET @Resultado = @Var03
	IF (@Var04 > @Resultado) SET @Resultado = @Var04
	IF (@Var05 > @Resultado) SET @Resultado = @Var05
	IF (@Var06 > @Resultado) SET @Resultado = @Var06
	IF (@Var07 > @Resultado) SET @Resultado = @Var07
	IF (@Var08 > @Resultado) SET @Resultado = @Var08
	IF (@Var09 > @Resultado) SET @Resultado = @Var09
	IF (@Var10 > @Resultado) SET @Resultado = @Var10
	IF (@Var11 > @Resultado) SET @Resultado = @Var11
	IF (@Var12 > @Resultado) SET @Resultado = @Var12
	IF (@Var13 > @Resultado) SET @Resultado = @Var13
	IF (@Var14 > @Resultado) SET @Resultado = @Var14
	IF (@Var15 > @Resultado) SET @Resultado = @Var15
	IF (@Var16 > @Resultado) SET @Resultado = @Var16
	IF (@Var17 > @Resultado) SET @Resultado = @Var17
	IF (@Var18 > @Resultado) SET @Resultado = @Var18
	IF (@Var19 > @Resultado) SET @Resultado = @Var19
	IF (@Var20 > @Resultado) SET @Resultado = @Var20
	IF (@Var21 > @Resultado) SET @Resultado = @Var21
	IF (@Var22 > @Resultado) SET @Resultado = @Var22
	IF (@Var23 > @Resultado) SET @Resultado = @Var23
	IF (@Var24 > @Resultado) SET @Resultado = @Var24

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[Max36Patamares]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[Max36Patamares] 
(
	-- Add the parameters for the function here
	@Var01 decimal(18,9),
	@Var02 decimal(18,9),
	@Var03 decimal(18,9),
	@Var04 decimal(18,9),
	@Var05 decimal(18,9),
	@Var06 decimal(18,9),
	@Var07 decimal(18,9),
	@Var08 decimal(18,9),
	@Var09 decimal(18,9),
	@Var10 decimal(18,9),
	@Var11 decimal(18,9),
	@Var12 decimal(18,9),
	@Var13 decimal(18,9),
	@Var14 decimal(18,9),
	@Var15 decimal(18,9),
	@Var16 decimal(18,9),
	@Var17 decimal(18,9),
	@Var18 decimal(18,9),
	@Var19 decimal(18,9),
	@Var20 decimal(18,9),
	@Var21 decimal(18,9),
	@Var22 decimal(18,9),
	@Var23 decimal(18,9),
	@Var24 decimal(18,9),
	@Var25 decimal(18,9),
	@Var26 decimal(18,9),
	@Var27 decimal(18,9),
	@Var28 decimal(18,9),
	@Var29 decimal(18,9),
	@Var30 decimal(18,9),
	@Var31 decimal(18,9),
	@Var32 decimal(18,9),
	@Var33 decimal(18,9),
	@Var34 decimal(18,9),
	@Var35 decimal(18,9),
	@Var36 decimal(18,9)
)
RETURNS decimal(18,9)
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado decimal(18,9) = 0.0

	-- Add the T-SQL statements to compute the return value here
	IF (@Var01 > @Resultado) SET @Resultado = @Var01
	IF (@Var02 > @Resultado) SET @Resultado = @Var02
	IF (@Var03 > @Resultado) SET @Resultado = @Var03
	IF (@Var04 > @Resultado) SET @Resultado = @Var04
	IF (@Var05 > @Resultado) SET @Resultado = @Var05
	IF (@Var06 > @Resultado) SET @Resultado = @Var06
	IF (@Var07 > @Resultado) SET @Resultado = @Var07
	IF (@Var08 > @Resultado) SET @Resultado = @Var08
	IF (@Var09 > @Resultado) SET @Resultado = @Var09
	IF (@Var10 > @Resultado) SET @Resultado = @Var10
	IF (@Var11 > @Resultado) SET @Resultado = @Var11
	IF (@Var12 > @Resultado) SET @Resultado = @Var12
	IF (@Var13 > @Resultado) SET @Resultado = @Var13
	IF (@Var14 > @Resultado) SET @Resultado = @Var14
	IF (@Var15 > @Resultado) SET @Resultado = @Var15
	IF (@Var16 > @Resultado) SET @Resultado = @Var16
	IF (@Var17 > @Resultado) SET @Resultado = @Var17
	IF (@Var18 > @Resultado) SET @Resultado = @Var18
	IF (@Var19 > @Resultado) SET @Resultado = @Var19
	IF (@Var20 > @Resultado) SET @Resultado = @Var20
	IF (@Var21 > @Resultado) SET @Resultado = @Var21
	IF (@Var22 > @Resultado) SET @Resultado = @Var22
	IF (@Var23 > @Resultado) SET @Resultado = @Var23
	IF (@Var24 > @Resultado) SET @Resultado = @Var24
	IF (@Var25 > @Resultado) SET @Resultado = @Var25
	IF (@Var26 > @Resultado) SET @Resultado = @Var26
	IF (@Var27 > @Resultado) SET @Resultado = @Var27
	IF (@Var28 > @Resultado) SET @Resultado = @Var28
	IF (@Var29 > @Resultado) SET @Resultado = @Var29
	IF (@Var30 > @Resultado) SET @Resultado = @Var30
	IF (@Var31 > @Resultado) SET @Resultado = @Var31
	IF (@Var32 > @Resultado) SET @Resultado = @Var32
	IF (@Var33 > @Resultado) SET @Resultado = @Var33
	IF (@Var34 > @Resultado) SET @Resultado = @Var34
	IF (@Var35 > @Resultado) SET @Resultado = @Var35
	IF (@Var36 > @Resultado) SET @Resultado = @Var36

	-- Return the result of the function
	RETURN @Resultado

END









GO
/****** Object:  UserDefinedFunction [dbo].[Max864Patamares]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[Max864Patamares] 
(
	-- Add the parameters for the function here
	@Var01 decimal(18,9),
	@Var02 decimal(18,9),
	@Var03 decimal(18,9),
	@Var04 decimal(18,9),
	@Var05 decimal(18,9),
	@Var06 decimal(18,9),
	@Var07 decimal(18,9),
	@Var08 decimal(18,9),
	@Var09 decimal(18,9),
	@Var10 decimal(18,9),
	@Var11 decimal(18,9),
	@Var12 decimal(18,9),
	@Var13 decimal(18,9),
	@Var14 decimal(18,9),
	@Var15 decimal(18,9),
	@Var16 decimal(18,9),
	@Var17 decimal(18,9),
	@Var18 decimal(18,9),
	@Var19 decimal(18,9),
	@Var20 decimal(18,9),
	@Var21 decimal(18,9),
	@Var22 decimal(18,9),
	@Var23 decimal(18,9),
	@Var24 decimal(18,9),
	@Var25 decimal(18,9),
	@Var26 decimal(18,9),
	@Var27 decimal(18,9),
	@Var28 decimal(18,9),
	@Var29 decimal(18,9),
	@Var30 decimal(18,9),
	@Var31 decimal(18,9),
	@Var32 decimal(18,9),
	@Var33 decimal(18,9),
	@Var34 decimal(18,9),
	@Var35 decimal(18,9),
	@Var36 decimal(18,9),
	@Var37 decimal(18,9),
	@Var38 decimal(18,9),
	@Var39 decimal(18,9),
	@Var40 decimal(18,9),
	@Var41 decimal(18,9),
	@Var42 decimal(18,9),
	@Var43 decimal(18,9),
	@Var44 decimal(18,9),
	@Var45 decimal(18,9),
	@Var46 decimal(18,9),
	@Var47 decimal(18,9),
	@Var48 decimal(18,9),
	@Var49 decimal(18,9),
	@Var50 decimal(18,9),
	@Var51 decimal(18,9),
	@Var52 decimal(18,9),
	@Var53 decimal(18,9),
	@Var54 decimal(18,9),
	@Var55 decimal(18,9),
	@Var56 decimal(18,9),
	@Var57 decimal(18,9),
	@Var58 decimal(18,9),
	@Var59 decimal(18,9),
	@Var60 decimal(18,9),
	@Var61 decimal(18,9),
	@Var62 decimal(18,9),
	@Var63 decimal(18,9),
	@Var64 decimal(18,9),
	@Var65 decimal(18,9),
	@Var66 decimal(18,9),
	@Var67 decimal(18,9),
	@Var68 decimal(18,9),
	@Var69 decimal(18,9),
	@Var70 decimal(18,9),
	@Var71 decimal(18,9),
	@Var72 decimal(18,9),
	@Var73 decimal(18,9),
	@Var74 decimal(18,9),
	@Var75 decimal(18,9),
	@Var76 decimal(18,9),
	@Var77 decimal(18,9),
	@Var78 decimal(18,9),
	@Var79 decimal(18,9),
	@Var80 decimal(18,9),
	@Var81 decimal(18,9),
	@Var82 decimal(18,9),
	@Var83 decimal(18,9),
	@Var84 decimal(18,9),
	@Var85 decimal(18,9),
	@Var86 decimal(18,9),
	@Var87 decimal(18,9),
	@Var88 decimal(18,9),
	@Var89 decimal(18,9),
	@Var90 decimal(18,9),
	@Var91 decimal(18,9),
	@Var92 decimal(18,9),
	@Var93 decimal(18,9),
	@Var94 decimal(18,9),
	@Var95 decimal(18,9),
	@Var96 decimal(18,9),
	@Var97 decimal(18,9),
	@Var98 decimal(18,9),
	@Var99 decimal(18,9),
	@Var100 decimal(18,9),
	@Var101 decimal(18,9),
	@Var102 decimal(18,9),
	@Var103 decimal(18,9),
	@Var104 decimal(18,9),
	@Var105 decimal(18,9),
	@Var106 decimal(18,9),
	@Var107 decimal(18,9),
	@Var108 decimal(18,9),
	@Var109 decimal(18,9),
	@Var110 decimal(18,9),
	@Var111 decimal(18,9),
	@Var112 decimal(18,9),
	@Var113 decimal(18,9),
	@Var114 decimal(18,9),
	@Var115 decimal(18,9),
	@Var116 decimal(18,9),
	@Var117 decimal(18,9),
	@Var118 decimal(18,9),
	@Var119 decimal(18,9),
	@Var120 decimal(18,9),
	@Var121 decimal(18,9),
	@Var122 decimal(18,9),
	@Var123 decimal(18,9),
	@Var124 decimal(18,9),
	@Var125 decimal(18,9),
	@Var126 decimal(18,9),
	@Var127 decimal(18,9),
	@Var128 decimal(18,9),
	@Var129 decimal(18,9),
	@Var130 decimal(18,9),
	@Var131 decimal(18,9),
	@Var132 decimal(18,9),
	@Var133 decimal(18,9),
	@Var134 decimal(18,9),
	@Var135 decimal(18,9),
	@Var136 decimal(18,9),
	@Var137 decimal(18,9),
	@Var138 decimal(18,9),
	@Var139 decimal(18,9),
	@Var140 decimal(18,9),
	@Var141 decimal(18,9),
	@Var142 decimal(18,9),
	@Var143 decimal(18,9),
	@Var144 decimal(18,9),
	@Var145 decimal(18,9),
	@Var146 decimal(18,9),
	@Var147 decimal(18,9),
	@Var148 decimal(18,9),
	@Var149 decimal(18,9),
	@Var150 decimal(18,9),
	@Var151 decimal(18,9),
	@Var152 decimal(18,9),
	@Var153 decimal(18,9),
	@Var154 decimal(18,9),
	@Var155 decimal(18,9),
	@Var156 decimal(18,9),
	@Var157 decimal(18,9),
	@Var158 decimal(18,9),
	@Var159 decimal(18,9),
	@Var160 decimal(18,9),
	@Var161 decimal(18,9),
	@Var162 decimal(18,9),
	@Var163 decimal(18,9),
	@Var164 decimal(18,9),
	@Var165 decimal(18,9),
	@Var166 decimal(18,9),
	@Var167 decimal(18,9),
	@Var168 decimal(18,9),
	@Var169 decimal(18,9),
	@Var170 decimal(18,9),
	@Var171 decimal(18,9),
	@Var172 decimal(18,9),
	@Var173 decimal(18,9),
	@Var174 decimal(18,9),
	@Var175 decimal(18,9),
	@Var176 decimal(18,9),
	@Var177 decimal(18,9),
	@Var178 decimal(18,9),
	@Var179 decimal(18,9),
	@Var180 decimal(18,9),
	@Var181 decimal(18,9),
	@Var182 decimal(18,9),
	@Var183 decimal(18,9),
	@Var184 decimal(18,9),
	@Var185 decimal(18,9),
	@Var186 decimal(18,9),
	@Var187 decimal(18,9),
	@Var188 decimal(18,9),
	@Var189 decimal(18,9),
	@Var190 decimal(18,9),
	@Var191 decimal(18,9),
	@Var192 decimal(18,9),
	@Var193 decimal(18,9),
	@Var194 decimal(18,9),
	@Var195 decimal(18,9),
	@Var196 decimal(18,9),
	@Var197 decimal(18,9),
	@Var198 decimal(18,9),
	@Var199 decimal(18,9),
	@Var200 decimal(18,9),
	@Var201 decimal(18,9),
	@Var202 decimal(18,9),
	@Var203 decimal(18,9),
	@Var204 decimal(18,9),
	@Var205 decimal(18,9),
	@Var206 decimal(18,9),
	@Var207 decimal(18,9),
	@Var208 decimal(18,9),
	@Var209 decimal(18,9),
	@Var210 decimal(18,9),
	@Var211 decimal(18,9),
	@Var212 decimal(18,9),
	@Var213 decimal(18,9),
	@Var214 decimal(18,9),
	@Var215 decimal(18,9),
	@Var216 decimal(18,9),
	@Var217 decimal(18,9),
	@Var218 decimal(18,9),
	@Var219 decimal(18,9),
	@Var220 decimal(18,9),
	@Var221 decimal(18,9),
	@Var222 decimal(18,9),
	@Var223 decimal(18,9),
	@Var224 decimal(18,9),
	@Var225 decimal(18,9),
	@Var226 decimal(18,9),
	@Var227 decimal(18,9),
	@Var228 decimal(18,9),
	@Var229 decimal(18,9),
	@Var230 decimal(18,9),
	@Var231 decimal(18,9),
	@Var232 decimal(18,9),
	@Var233 decimal(18,9),
	@Var234 decimal(18,9),
	@Var235 decimal(18,9),
	@Var236 decimal(18,9),
	@Var237 decimal(18,9),
	@Var238 decimal(18,9),
	@Var239 decimal(18,9),
	@Var240 decimal(18,9),
	@Var241 decimal(18,9),
	@Var242 decimal(18,9),
	@Var243 decimal(18,9),
	@Var244 decimal(18,9),
	@Var245 decimal(18,9),
	@Var246 decimal(18,9),
	@Var247 decimal(18,9),
	@Var248 decimal(18,9),
	@Var249 decimal(18,9),
	@Var250 decimal(18,9),
	@Var251 decimal(18,9),
	@Var252 decimal(18,9),
	@Var253 decimal(18,9),
	@Var254 decimal(18,9),
	@Var255 decimal(18,9),
	@Var256 decimal(18,9),
	@Var257 decimal(18,9),
	@Var258 decimal(18,9),
	@Var259 decimal(18,9),
	@Var260 decimal(18,9),
	@Var261 decimal(18,9),
	@Var262 decimal(18,9),
	@Var263 decimal(18,9),
	@Var264 decimal(18,9),
	@Var265 decimal(18,9),
	@Var266 decimal(18,9),
	@Var267 decimal(18,9),
	@Var268 decimal(18,9),
	@Var269 decimal(18,9),
	@Var270 decimal(18,9),
	@Var271 decimal(18,9),
	@Var272 decimal(18,9),
	@Var273 decimal(18,9),
	@Var274 decimal(18,9),
	@Var275 decimal(18,9),
	@Var276 decimal(18,9),
	@Var277 decimal(18,9),
	@Var278 decimal(18,9),
	@Var279 decimal(18,9),
	@Var280 decimal(18,9),
	@Var281 decimal(18,9),
	@Var282 decimal(18,9),
	@Var283 decimal(18,9),
	@Var284 decimal(18,9),
	@Var285 decimal(18,9),
	@Var286 decimal(18,9),
	@Var287 decimal(18,9),
	@Var288 decimal(18,9),
	@Var289 decimal(18,9),
	@Var290 decimal(18,9),
	@Var291 decimal(18,9),
	@Var292 decimal(18,9),
	@Var293 decimal(18,9),
	@Var294 decimal(18,9),
	@Var295 decimal(18,9),
	@Var296 decimal(18,9),
	@Var297 decimal(18,9),
	@Var298 decimal(18,9),
	@Var299 decimal(18,9),
	@Var300 decimal(18,9),
	@Var301 decimal(18,9),
	@Var302 decimal(18,9),
	@Var303 decimal(18,9),
	@Var304 decimal(18,9),
	@Var305 decimal(18,9),
	@Var306 decimal(18,9),
	@Var307 decimal(18,9),
	@Var308 decimal(18,9),
	@Var309 decimal(18,9),
	@Var310 decimal(18,9),
	@Var311 decimal(18,9),
	@Var312 decimal(18,9),
	@Var313 decimal(18,9),
	@Var314 decimal(18,9),
	@Var315 decimal(18,9),
	@Var316 decimal(18,9),
	@Var317 decimal(18,9),
	@Var318 decimal(18,9),
	@Var319 decimal(18,9),
	@Var320 decimal(18,9),
	@Var321 decimal(18,9),
	@Var322 decimal(18,9),
	@Var323 decimal(18,9),
	@Var324 decimal(18,9),
	@Var325 decimal(18,9),
	@Var326 decimal(18,9),
	@Var327 decimal(18,9),
	@Var328 decimal(18,9),
	@Var329 decimal(18,9),
	@Var330 decimal(18,9),
	@Var331 decimal(18,9),
	@Var332 decimal(18,9),
	@Var333 decimal(18,9),
	@Var334 decimal(18,9),
	@Var335 decimal(18,9),
	@Var336 decimal(18,9),
	@Var337 decimal(18,9),
	@Var338 decimal(18,9),
	@Var339 decimal(18,9),
	@Var340 decimal(18,9),
	@Var341 decimal(18,9),
	@Var342 decimal(18,9),
	@Var343 decimal(18,9),
	@Var344 decimal(18,9),
	@Var345 decimal(18,9),
	@Var346 decimal(18,9),
	@Var347 decimal(18,9),
	@Var348 decimal(18,9),
	@Var349 decimal(18,9),
	@Var350 decimal(18,9),
	@Var351 decimal(18,9),
	@Var352 decimal(18,9),
	@Var353 decimal(18,9),
	@Var354 decimal(18,9),
	@Var355 decimal(18,9),
	@Var356 decimal(18,9),
	@Var357 decimal(18,9),
	@Var358 decimal(18,9),
	@Var359 decimal(18,9),
	@Var360 decimal(18,9),
	@Var361 decimal(18,9),
	@Var362 decimal(18,9),
	@Var363 decimal(18,9),
	@Var364 decimal(18,9),
	@Var365 decimal(18,9),
	@Var366 decimal(18,9),
	@Var367 decimal(18,9),
	@Var368 decimal(18,9),
	@Var369 decimal(18,9),
	@Var370 decimal(18,9),
	@Var371 decimal(18,9),
	@Var372 decimal(18,9),
	@Var373 decimal(18,9),
	@Var374 decimal(18,9),
	@Var375 decimal(18,9),
	@Var376 decimal(18,9),
	@Var377 decimal(18,9),
	@Var378 decimal(18,9),
	@Var379 decimal(18,9),
	@Var380 decimal(18,9),
	@Var381 decimal(18,9),
	@Var382 decimal(18,9),
	@Var383 decimal(18,9),
	@Var384 decimal(18,9),
	@Var385 decimal(18,9),
	@Var386 decimal(18,9),
	@Var387 decimal(18,9),
	@Var388 decimal(18,9),
	@Var389 decimal(18,9),
	@Var390 decimal(18,9),
	@Var391 decimal(18,9),
	@Var392 decimal(18,9),
	@Var393 decimal(18,9),
	@Var394 decimal(18,9),
	@Var395 decimal(18,9),
	@Var396 decimal(18,9),
	@Var397 decimal(18,9),
	@Var398 decimal(18,9),
	@Var399 decimal(18,9),
	@Var400 decimal(18,9),
	@Var401 decimal(18,9),
	@Var402 decimal(18,9),
	@Var403 decimal(18,9),
	@Var404 decimal(18,9),
	@Var405 decimal(18,9),
	@Var406 decimal(18,9),
	@Var407 decimal(18,9),
	@Var408 decimal(18,9),
	@Var409 decimal(18,9),
	@Var410 decimal(18,9),
	@Var411 decimal(18,9),
	@Var412 decimal(18,9),
	@Var413 decimal(18,9),
	@Var414 decimal(18,9),
	@Var415 decimal(18,9),
	@Var416 decimal(18,9),
	@Var417 decimal(18,9),
	@Var418 decimal(18,9),
	@Var419 decimal(18,9),
	@Var420 decimal(18,9),
	@Var421 decimal(18,9),
	@Var422 decimal(18,9),
	@Var423 decimal(18,9),
	@Var424 decimal(18,9),
	@Var425 decimal(18,9),
	@Var426 decimal(18,9),
	@Var427 decimal(18,9),
	@Var428 decimal(18,9),
	@Var429 decimal(18,9),
	@Var430 decimal(18,9),
	@Var431 decimal(18,9),
	@Var432 decimal(18,9),
	@Var433 decimal(18,9),
	@Var434 decimal(18,9),
	@Var435 decimal(18,9),
	@Var436 decimal(18,9),
	@Var437 decimal(18,9),
	@Var438 decimal(18,9),
	@Var439 decimal(18,9),
	@Var440 decimal(18,9),
	@Var441 decimal(18,9),
	@Var442 decimal(18,9),
	@Var443 decimal(18,9),
	@Var444 decimal(18,9),
	@Var445 decimal(18,9),
	@Var446 decimal(18,9),
	@Var447 decimal(18,9),
	@Var448 decimal(18,9),
	@Var449 decimal(18,9),
	@Var450 decimal(18,9),
	@Var451 decimal(18,9),
	@Var452 decimal(18,9),
	@Var453 decimal(18,9),
	@Var454 decimal(18,9),
	@Var455 decimal(18,9),
	@Var456 decimal(18,9),
	@Var457 decimal(18,9),
	@Var458 decimal(18,9),
	@Var459 decimal(18,9),
	@Var460 decimal(18,9),
	@Var461 decimal(18,9),
	@Var462 decimal(18,9),
	@Var463 decimal(18,9),
	@Var464 decimal(18,9),
	@Var465 decimal(18,9),
	@Var466 decimal(18,9),
	@Var467 decimal(18,9),
	@Var468 decimal(18,9),
	@Var469 decimal(18,9),
	@Var470 decimal(18,9),
	@Var471 decimal(18,9),
	@Var472 decimal(18,9),
	@Var473 decimal(18,9),
	@Var474 decimal(18,9),
	@Var475 decimal(18,9),
	@Var476 decimal(18,9),
	@Var477 decimal(18,9),
	@Var478 decimal(18,9),
	@Var479 decimal(18,9),
	@Var480 decimal(18,9),
	@Var481 decimal(18,9),
	@Var482 decimal(18,9),
	@Var483 decimal(18,9),
	@Var484 decimal(18,9),
	@Var485 decimal(18,9),
	@Var486 decimal(18,9),
	@Var487 decimal(18,9),
	@Var488 decimal(18,9),
	@Var489 decimal(18,9),
	@Var490 decimal(18,9),
	@Var491 decimal(18,9),
	@Var492 decimal(18,9),
	@Var493 decimal(18,9),
	@Var494 decimal(18,9),
	@Var495 decimal(18,9),
	@Var496 decimal(18,9),
	@Var497 decimal(18,9),
	@Var498 decimal(18,9),
	@Var499 decimal(18,9),
	@Var500 decimal(18,9),
	@Var501 decimal(18,9),
	@Var502 decimal(18,9),
	@Var503 decimal(18,9),
	@Var504 decimal(18,9),
	@Var505 decimal(18,9),
	@Var506 decimal(18,9),
	@Var507 decimal(18,9),
	@Var508 decimal(18,9),
	@Var509 decimal(18,9),
	@Var510 decimal(18,9),
	@Var511 decimal(18,9),
	@Var512 decimal(18,9),
	@Var513 decimal(18,9),
	@Var514 decimal(18,9),
	@Var515 decimal(18,9),
	@Var516 decimal(18,9),
	@Var517 decimal(18,9),
	@Var518 decimal(18,9),
	@Var519 decimal(18,9),
	@Var520 decimal(18,9),
	@Var521 decimal(18,9),
	@Var522 decimal(18,9),
	@Var523 decimal(18,9),
	@Var524 decimal(18,9),
	@Var525 decimal(18,9),
	@Var526 decimal(18,9),
	@Var527 decimal(18,9),
	@Var528 decimal(18,9),
	@Var529 decimal(18,9),
	@Var530 decimal(18,9),
	@Var531 decimal(18,9),
	@Var532 decimal(18,9),
	@Var533 decimal(18,9),
	@Var534 decimal(18,9),
	@Var535 decimal(18,9),
	@Var536 decimal(18,9),
	@Var537 decimal(18,9),
	@Var538 decimal(18,9),
	@Var539 decimal(18,9),
	@Var540 decimal(18,9),
	@Var541 decimal(18,9),
	@Var542 decimal(18,9),
	@Var543 decimal(18,9),
	@Var544 decimal(18,9),
	@Var545 decimal(18,9),
	@Var546 decimal(18,9),
	@Var547 decimal(18,9),
	@Var548 decimal(18,9),
	@Var549 decimal(18,9),
	@Var550 decimal(18,9),
	@Var551 decimal(18,9),
	@Var552 decimal(18,9),
	@Var553 decimal(18,9),
	@Var554 decimal(18,9),
	@Var555 decimal(18,9),
	@Var556 decimal(18,9),
	@Var557 decimal(18,9),
	@Var558 decimal(18,9),
	@Var559 decimal(18,9),
	@Var560 decimal(18,9),
	@Var561 decimal(18,9),
	@Var562 decimal(18,9),
	@Var563 decimal(18,9),
	@Var564 decimal(18,9),
	@Var565 decimal(18,9),
	@Var566 decimal(18,9),
	@Var567 decimal(18,9),
	@Var568 decimal(18,9),
	@Var569 decimal(18,9),
	@Var570 decimal(18,9),
	@Var571 decimal(18,9),
	@Var572 decimal(18,9),
	@Var573 decimal(18,9),
	@Var574 decimal(18,9),
	@Var575 decimal(18,9),
	@Var576 decimal(18,9),
	@Var577 decimal(18,9),
	@Var578 decimal(18,9),
	@Var579 decimal(18,9),
	@Var580 decimal(18,9),
	@Var581 decimal(18,9),
	@Var582 decimal(18,9),
	@Var583 decimal(18,9),
	@Var584 decimal(18,9),
	@Var585 decimal(18,9),
	@Var586 decimal(18,9),
	@Var587 decimal(18,9),
	@Var588 decimal(18,9),
	@Var589 decimal(18,9),
	@Var590 decimal(18,9),
	@Var591 decimal(18,9),
	@Var592 decimal(18,9),
	@Var593 decimal(18,9),
	@Var594 decimal(18,9),
	@Var595 decimal(18,9),
	@Var596 decimal(18,9),
	@Var597 decimal(18,9),
	@Var598 decimal(18,9),
	@Var599 decimal(18,9),
	@Var600 decimal(18,9),
	@Var601 decimal(18,9),
	@Var602 decimal(18,9),
	@Var603 decimal(18,9),
	@Var604 decimal(18,9),
	@Var605 decimal(18,9),
	@Var606 decimal(18,9),
	@Var607 decimal(18,9),
	@Var608 decimal(18,9),
	@Var609 decimal(18,9),
	@Var610 decimal(18,9),
	@Var611 decimal(18,9),
	@Var612 decimal(18,9),
	@Var613 decimal(18,9),
	@Var614 decimal(18,9),
	@Var615 decimal(18,9),
	@Var616 decimal(18,9),
	@Var617 decimal(18,9),
	@Var618 decimal(18,9),
	@Var619 decimal(18,9),
	@Var620 decimal(18,9),
	@Var621 decimal(18,9),
	@Var622 decimal(18,9),
	@Var623 decimal(18,9),
	@Var624 decimal(18,9),
	@Var625 decimal(18,9),
	@Var626 decimal(18,9),
	@Var627 decimal(18,9),
	@Var628 decimal(18,9),
	@Var629 decimal(18,9),
	@Var630 decimal(18,9),
	@Var631 decimal(18,9),
	@Var632 decimal(18,9),
	@Var633 decimal(18,9),
	@Var634 decimal(18,9),
	@Var635 decimal(18,9),
	@Var636 decimal(18,9),
	@Var637 decimal(18,9),
	@Var638 decimal(18,9),
	@Var639 decimal(18,9),
	@Var640 decimal(18,9),
	@Var641 decimal(18,9),
	@Var642 decimal(18,9),
	@Var643 decimal(18,9),
	@Var644 decimal(18,9),
	@Var645 decimal(18,9),
	@Var646 decimal(18,9),
	@Var647 decimal(18,9),
	@Var648 decimal(18,9),
	@Var649 decimal(18,9),
	@Var650 decimal(18,9),
	@Var651 decimal(18,9),
	@Var652 decimal(18,9),
	@Var653 decimal(18,9),
	@Var654 decimal(18,9),
	@Var655 decimal(18,9),
	@Var656 decimal(18,9),
	@Var657 decimal(18,9),
	@Var658 decimal(18,9),
	@Var659 decimal(18,9),
	@Var660 decimal(18,9),
	@Var661 decimal(18,9),
	@Var662 decimal(18,9),
	@Var663 decimal(18,9),
	@Var664 decimal(18,9),
	@Var665 decimal(18,9),
	@Var666 decimal(18,9),
	@Var667 decimal(18,9),
	@Var668 decimal(18,9),
	@Var669 decimal(18,9),
	@Var670 decimal(18,9),
	@Var671 decimal(18,9),
	@Var672 decimal(18,9),
	@Var673 decimal(18,9),
	@Var674 decimal(18,9),
	@Var675 decimal(18,9),
	@Var676 decimal(18,9),
	@Var677 decimal(18,9),
	@Var678 decimal(18,9),
	@Var679 decimal(18,9),
	@Var680 decimal(18,9),
	@Var681 decimal(18,9),
	@Var682 decimal(18,9),
	@Var683 decimal(18,9),
	@Var684 decimal(18,9),
	@Var685 decimal(18,9),
	@Var686 decimal(18,9),
	@Var687 decimal(18,9),
	@Var688 decimal(18,9),
	@Var689 decimal(18,9),
	@Var690 decimal(18,9),
	@Var691 decimal(18,9),
	@Var692 decimal(18,9),
	@Var693 decimal(18,9),
	@Var694 decimal(18,9),
	@Var695 decimal(18,9),
	@Var696 decimal(18,9),
	@Var697 decimal(18,9),
	@Var698 decimal(18,9),
	@Var699 decimal(18,9),
	@Var700 decimal(18,9),
	@Var701 decimal(18,9),
	@Var702 decimal(18,9),
	@Var703 decimal(18,9),
	@Var704 decimal(18,9),
	@Var705 decimal(18,9),
	@Var706 decimal(18,9),
	@Var707 decimal(18,9),
	@Var708 decimal(18,9),
	@Var709 decimal(18,9),
	@Var710 decimal(18,9),
	@Var711 decimal(18,9),
	@Var712 decimal(18,9),
	@Var713 decimal(18,9),
	@Var714 decimal(18,9),
	@Var715 decimal(18,9),
	@Var716 decimal(18,9),
	@Var717 decimal(18,9),
	@Var718 decimal(18,9),
	@Var719 decimal(18,9),
	@Var720 decimal(18,9),
	@Var721 decimal(18,9),
	@Var722 decimal(18,9),
	@Var723 decimal(18,9),
	@Var724 decimal(18,9),
	@Var725 decimal(18,9),
	@Var726 decimal(18,9),
	@Var727 decimal(18,9),
	@Var728 decimal(18,9),
	@Var729 decimal(18,9),
	@Var730 decimal(18,9),
	@Var731 decimal(18,9),
	@Var732 decimal(18,9),
	@Var733 decimal(18,9),
	@Var734 decimal(18,9),
	@Var735 decimal(18,9),
	@Var736 decimal(18,9),
	@Var737 decimal(18,9),
	@Var738 decimal(18,9),
	@Var739 decimal(18,9),
	@Var740 decimal(18,9),
	@Var741 decimal(18,9),
	@Var742 decimal(18,9),
	@Var743 decimal(18,9),
	@Var744 decimal(18,9),
	@Var745 decimal(18,9),
	@Var746 decimal(18,9),
	@Var747 decimal(18,9),
	@Var748 decimal(18,9),
	@Var749 decimal(18,9),
	@Var750 decimal(18,9),
	@Var751 decimal(18,9),
	@Var752 decimal(18,9),
	@Var753 decimal(18,9),
	@Var754 decimal(18,9),
	@Var755 decimal(18,9),
	@Var756 decimal(18,9),
	@Var757 decimal(18,9),
	@Var758 decimal(18,9),
	@Var759 decimal(18,9),
	@Var760 decimal(18,9),
	@Var761 decimal(18,9),
	@Var762 decimal(18,9),
	@Var763 decimal(18,9),
	@Var764 decimal(18,9),
	@Var765 decimal(18,9),
	@Var766 decimal(18,9),
	@Var767 decimal(18,9),
	@Var768 decimal(18,9),
	@Var769 decimal(18,9),
	@Var770 decimal(18,9),
	@Var771 decimal(18,9),
	@Var772 decimal(18,9),
	@Var773 decimal(18,9),
	@Var774 decimal(18,9),
	@Var775 decimal(18,9),
	@Var776 decimal(18,9),
	@Var777 decimal(18,9),
	@Var778 decimal(18,9),
	@Var779 decimal(18,9),
	@Var780 decimal(18,9),
	@Var781 decimal(18,9),
	@Var782 decimal(18,9),
	@Var783 decimal(18,9),
	@Var784 decimal(18,9),
	@Var785 decimal(18,9),
	@Var786 decimal(18,9),
	@Var787 decimal(18,9),
	@Var788 decimal(18,9),
	@Var789 decimal(18,9),
	@Var790 decimal(18,9),
	@Var791 decimal(18,9),
	@Var792 decimal(18,9),
	@Var793 decimal(18,9),
	@Var794 decimal(18,9),
	@Var795 decimal(18,9),
	@Var796 decimal(18,9),
	@Var797 decimal(18,9),
	@Var798 decimal(18,9),
	@Var799 decimal(18,9),
	@Var800 decimal(18,9),
	@Var801 decimal(18,9),
	@Var802 decimal(18,9),
	@Var803 decimal(18,9),
	@Var804 decimal(18,9),
	@Var805 decimal(18,9),
	@Var806 decimal(18,9),
	@Var807 decimal(18,9),
	@Var808 decimal(18,9),
	@Var809 decimal(18,9),
	@Var810 decimal(18,9),
	@Var811 decimal(18,9),
	@Var812 decimal(18,9),
	@Var813 decimal(18,9),
	@Var814 decimal(18,9),
	@Var815 decimal(18,9),
	@Var816 decimal(18,9),
	@Var817 decimal(18,9),
	@Var818 decimal(18,9),
	@Var819 decimal(18,9),
	@Var820 decimal(18,9),
	@Var821 decimal(18,9),
	@Var822 decimal(18,9),
	@Var823 decimal(18,9),
	@Var824 decimal(18,9),
	@Var825 decimal(18,9),
	@Var826 decimal(18,9),
	@Var827 decimal(18,9),
	@Var828 decimal(18,9),
	@Var829 decimal(18,9),
	@Var830 decimal(18,9),
	@Var831 decimal(18,9),
	@Var832 decimal(18,9),
	@Var833 decimal(18,9),
	@Var834 decimal(18,9),
	@Var835 decimal(18,9),
	@Var836 decimal(18,9),
	@Var837 decimal(18,9),
	@Var838 decimal(18,9),
	@Var839 decimal(18,9),
	@Var840 decimal(18,9),
	@Var841 decimal(18,9),
	@Var842 decimal(18,9),
	@Var843 decimal(18,9),
	@Var844 decimal(18,9),
	@Var845 decimal(18,9),
	@Var846 decimal(18,9),
	@Var847 decimal(18,9),
	@Var848 decimal(18,9),
	@Var849 decimal(18,9),
	@Var850 decimal(18,9),
	@Var851 decimal(18,9),
	@Var852 decimal(18,9),
	@Var853 decimal(18,9),
	@Var854 decimal(18,9),
	@Var855 decimal(18,9),
	@Var856 decimal(18,9),
	@Var857 decimal(18,9),
	@Var858 decimal(18,9),
	@Var859 decimal(18,9),
	@Var860 decimal(18,9),
	@Var861 decimal(18,9),
	@Var862 decimal(18,9),
	@Var863 decimal(18,9),
	@Var864 decimal(18,9)
)
RETURNS decimal(18,9)
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado decimal(18,9) = 0.0

	-- Add the T-SQL statements to compute the return value here
	IF (@Var01 > @Resultado) SET @Resultado = @Var01
	IF (@Var02 > @Resultado) SET @Resultado = @Var02
	IF (@Var03 > @Resultado) SET @Resultado = @Var03
	IF (@Var04 > @Resultado) SET @Resultado = @Var04
	IF (@Var05 > @Resultado) SET @Resultado = @Var05
	IF (@Var06 > @Resultado) SET @Resultado = @Var06
	IF (@Var07 > @Resultado) SET @Resultado = @Var07
	IF (@Var08 > @Resultado) SET @Resultado = @Var08
	IF (@Var09 > @Resultado) SET @Resultado = @Var09
	IF (@Var10 > @Resultado) SET @Resultado = @Var10
	IF (@Var11 > @Resultado) SET @Resultado = @Var11
	IF (@Var12 > @Resultado) SET @Resultado = @Var12
	IF (@Var13 > @Resultado) SET @Resultado = @Var13
	IF (@Var14 > @Resultado) SET @Resultado = @Var14
	IF (@Var15 > @Resultado) SET @Resultado = @Var15
	IF (@Var16 > @Resultado) SET @Resultado = @Var16
	IF (@Var17 > @Resultado) SET @Resultado = @Var17
	IF (@Var18 > @Resultado) SET @Resultado = @Var18
	IF (@Var19 > @Resultado) SET @Resultado = @Var19
	IF (@Var20 > @Resultado) SET @Resultado = @Var20
	IF (@Var21 > @Resultado) SET @Resultado = @Var21
	IF (@Var22 > @Resultado) SET @Resultado = @Var22
	IF (@Var23 > @Resultado) SET @Resultado = @Var23
	IF (@Var24 > @Resultado) SET @Resultado = @Var24
	IF (@Var25 > @Resultado) SET @Resultado = @Var25
	IF (@Var26 > @Resultado) SET @Resultado = @Var26
	IF (@Var27 > @Resultado) SET @Resultado = @Var27
	IF (@Var28 > @Resultado) SET @Resultado = @Var28
	IF (@Var29 > @Resultado) SET @Resultado = @Var29
	IF (@Var30 > @Resultado) SET @Resultado = @Var30
	IF (@Var31 > @Resultado) SET @Resultado = @Var31
	IF (@Var32 > @Resultado) SET @Resultado = @Var32
	IF (@Var33 > @Resultado) SET @Resultado = @Var33
	IF (@Var34 > @Resultado) SET @Resultado = @Var34
	IF (@Var35 > @Resultado) SET @Resultado = @Var35
	IF (@Var36 > @Resultado) SET @Resultado = @Var36
	IF (@Var37 > @Resultado) SET @Resultado = @Var37
	IF (@Var38 > @Resultado) SET @Resultado = @Var38
	IF (@Var39 > @Resultado) SET @Resultado = @Var39
	IF (@Var40 > @Resultado) SET @Resultado = @Var40
	IF (@Var41 > @Resultado) SET @Resultado = @Var41
	IF (@Var42 > @Resultado) SET @Resultado = @Var42
	IF (@Var43 > @Resultado) SET @Resultado = @Var43
	IF (@Var44 > @Resultado) SET @Resultado = @Var44
	IF (@Var45 > @Resultado) SET @Resultado = @Var45
	IF (@Var46 > @Resultado) SET @Resultado = @Var46
	IF (@Var47 > @Resultado) SET @Resultado = @Var47
	IF (@Var48 > @Resultado) SET @Resultado = @Var48
	IF (@Var49 > @Resultado) SET @Resultado = @Var49
	IF (@Var50 > @Resultado) SET @Resultado = @Var50
	IF (@Var51 > @Resultado) SET @Resultado = @Var51
	IF (@Var52 > @Resultado) SET @Resultado = @Var52
	IF (@Var53 > @Resultado) SET @Resultado = @Var53
	IF (@Var54 > @Resultado) SET @Resultado = @Var54
	IF (@Var55 > @Resultado) SET @Resultado = @Var55
	IF (@Var56 > @Resultado) SET @Resultado = @Var56
	IF (@Var57 > @Resultado) SET @Resultado = @Var57
	IF (@Var58 > @Resultado) SET @Resultado = @Var58
	IF (@Var59 > @Resultado) SET @Resultado = @Var59
	IF (@Var60 > @Resultado) SET @Resultado = @Var60
	IF (@Var61 > @Resultado) SET @Resultado = @Var61
	IF (@Var62 > @Resultado) SET @Resultado = @Var62
	IF (@Var63 > @Resultado) SET @Resultado = @Var63
	IF (@Var64 > @Resultado) SET @Resultado = @Var64
	IF (@Var65 > @Resultado) SET @Resultado = @Var65
	IF (@Var66 > @Resultado) SET @Resultado = @Var66
	IF (@Var67 > @Resultado) SET @Resultado = @Var67
	IF (@Var68 > @Resultado) SET @Resultado = @Var68
	IF (@Var69 > @Resultado) SET @Resultado = @Var69
	IF (@Var70 > @Resultado) SET @Resultado = @Var70
	IF (@Var71 > @Resultado) SET @Resultado = @Var71
	IF (@Var72 > @Resultado) SET @Resultado = @Var72
	IF (@Var73 > @Resultado) SET @Resultado = @Var73
	IF (@Var74 > @Resultado) SET @Resultado = @Var74
	IF (@Var75 > @Resultado) SET @Resultado = @Var75
	IF (@Var76 > @Resultado) SET @Resultado = @Var76
	IF (@Var77 > @Resultado) SET @Resultado = @Var77
	IF (@Var78 > @Resultado) SET @Resultado = @Var78
	IF (@Var79 > @Resultado) SET @Resultado = @Var79
	IF (@Var80 > @Resultado) SET @Resultado = @Var80
	IF (@Var81 > @Resultado) SET @Resultado = @Var81
	IF (@Var82 > @Resultado) SET @Resultado = @Var82
	IF (@Var83 > @Resultado) SET @Resultado = @Var83
	IF (@Var84 > @Resultado) SET @Resultado = @Var84
	IF (@Var85 > @Resultado) SET @Resultado = @Var85
	IF (@Var86 > @Resultado) SET @Resultado = @Var86
	IF (@Var87 > @Resultado) SET @Resultado = @Var87
	IF (@Var88 > @Resultado) SET @Resultado = @Var88
	IF (@Var89 > @Resultado) SET @Resultado = @Var89
	IF (@Var90 > @Resultado) SET @Resultado = @Var90
	IF (@Var91 > @Resultado) SET @Resultado = @Var91
	IF (@Var92 > @Resultado) SET @Resultado = @Var92
	IF (@Var93 > @Resultado) SET @Resultado = @Var93
	IF (@Var94 > @Resultado) SET @Resultado = @Var94
	IF (@Var95 > @Resultado) SET @Resultado = @Var95
	IF (@Var96 > @Resultado) SET @Resultado = @Var96
	IF (@Var97 > @Resultado) SET @Resultado = @Var97
	IF (@Var98 > @Resultado) SET @Resultado = @Var98
	IF (@Var99 > @Resultado) SET @Resultado = @Var99
	IF (@Var100 > @Resultado) SET @Resultado = @Var100
	IF (@Var101 > @Resultado) SET @Resultado = @Var101
	IF (@Var102 > @Resultado) SET @Resultado = @Var102
	IF (@Var103 > @Resultado) SET @Resultado = @Var103
	IF (@Var104 > @Resultado) SET @Resultado = @Var104
	IF (@Var105 > @Resultado) SET @Resultado = @Var105
	IF (@Var106 > @Resultado) SET @Resultado = @Var106
	IF (@Var107 > @Resultado) SET @Resultado = @Var107
	IF (@Var108 > @Resultado) SET @Resultado = @Var108
	IF (@Var109 > @Resultado) SET @Resultado = @Var109
	IF (@Var110 > @Resultado) SET @Resultado = @Var110
	IF (@Var111 > @Resultado) SET @Resultado = @Var111
	IF (@Var112 > @Resultado) SET @Resultado = @Var112
	IF (@Var113 > @Resultado) SET @Resultado = @Var113
	IF (@Var114 > @Resultado) SET @Resultado = @Var114
	IF (@Var115 > @Resultado) SET @Resultado = @Var115
	IF (@Var116 > @Resultado) SET @Resultado = @Var116
	IF (@Var117 > @Resultado) SET @Resultado = @Var117
	IF (@Var118 > @Resultado) SET @Resultado = @Var118
	IF (@Var119 > @Resultado) SET @Resultado = @Var119
	IF (@Var120 > @Resultado) SET @Resultado = @Var120
	IF (@Var121 > @Resultado) SET @Resultado = @Var121
	IF (@Var122 > @Resultado) SET @Resultado = @Var122
	IF (@Var123 > @Resultado) SET @Resultado = @Var123
	IF (@Var124 > @Resultado) SET @Resultado = @Var124
	IF (@Var125 > @Resultado) SET @Resultado = @Var125
	IF (@Var126 > @Resultado) SET @Resultado = @Var126
	IF (@Var127 > @Resultado) SET @Resultado = @Var127
	IF (@Var128 > @Resultado) SET @Resultado = @Var128
	IF (@Var129 > @Resultado) SET @Resultado = @Var129
	IF (@Var130 > @Resultado) SET @Resultado = @Var130
	IF (@Var131 > @Resultado) SET @Resultado = @Var131
	IF (@Var132 > @Resultado) SET @Resultado = @Var132
	IF (@Var133 > @Resultado) SET @Resultado = @Var133
	IF (@Var134 > @Resultado) SET @Resultado = @Var134
	IF (@Var135 > @Resultado) SET @Resultado = @Var135
	IF (@Var136 > @Resultado) SET @Resultado = @Var136
	IF (@Var137 > @Resultado) SET @Resultado = @Var137
	IF (@Var138 > @Resultado) SET @Resultado = @Var138
	IF (@Var139 > @Resultado) SET @Resultado = @Var139
	IF (@Var140 > @Resultado) SET @Resultado = @Var140
	IF (@Var141 > @Resultado) SET @Resultado = @Var141
	IF (@Var142 > @Resultado) SET @Resultado = @Var142
	IF (@Var143 > @Resultado) SET @Resultado = @Var143
	IF (@Var144 > @Resultado) SET @Resultado = @Var144
	IF (@Var145 > @Resultado) SET @Resultado = @Var145
	IF (@Var146 > @Resultado) SET @Resultado = @Var146
	IF (@Var147 > @Resultado) SET @Resultado = @Var147
	IF (@Var148 > @Resultado) SET @Resultado = @Var148
	IF (@Var149 > @Resultado) SET @Resultado = @Var149
	IF (@Var150 > @Resultado) SET @Resultado = @Var150
	IF (@Var151 > @Resultado) SET @Resultado = @Var151
	IF (@Var152 > @Resultado) SET @Resultado = @Var152
	IF (@Var153 > @Resultado) SET @Resultado = @Var153
	IF (@Var154 > @Resultado) SET @Resultado = @Var154
	IF (@Var155 > @Resultado) SET @Resultado = @Var155
	IF (@Var156 > @Resultado) SET @Resultado = @Var156
	IF (@Var157 > @Resultado) SET @Resultado = @Var157
	IF (@Var158 > @Resultado) SET @Resultado = @Var158
	IF (@Var159 > @Resultado) SET @Resultado = @Var159
	IF (@Var160 > @Resultado) SET @Resultado = @Var160
	IF (@Var161 > @Resultado) SET @Resultado = @Var161
	IF (@Var162 > @Resultado) SET @Resultado = @Var162
	IF (@Var163 > @Resultado) SET @Resultado = @Var163
	IF (@Var164 > @Resultado) SET @Resultado = @Var164
	IF (@Var165 > @Resultado) SET @Resultado = @Var165
	IF (@Var166 > @Resultado) SET @Resultado = @Var166
	IF (@Var167 > @Resultado) SET @Resultado = @Var167
	IF (@Var168 > @Resultado) SET @Resultado = @Var168
	IF (@Var169 > @Resultado) SET @Resultado = @Var169
	IF (@Var170 > @Resultado) SET @Resultado = @Var170
	IF (@Var171 > @Resultado) SET @Resultado = @Var171
	IF (@Var172 > @Resultado) SET @Resultado = @Var172
	IF (@Var173 > @Resultado) SET @Resultado = @Var173
	IF (@Var174 > @Resultado) SET @Resultado = @Var174
	IF (@Var175 > @Resultado) SET @Resultado = @Var175
	IF (@Var176 > @Resultado) SET @Resultado = @Var176
	IF (@Var177 > @Resultado) SET @Resultado = @Var177
	IF (@Var178 > @Resultado) SET @Resultado = @Var178
	IF (@Var179 > @Resultado) SET @Resultado = @Var179
	IF (@Var180 > @Resultado) SET @Resultado = @Var180
	IF (@Var181 > @Resultado) SET @Resultado = @Var181
	IF (@Var182 > @Resultado) SET @Resultado = @Var182
	IF (@Var183 > @Resultado) SET @Resultado = @Var183
	IF (@Var184 > @Resultado) SET @Resultado = @Var184
	IF (@Var185 > @Resultado) SET @Resultado = @Var185
	IF (@Var186 > @Resultado) SET @Resultado = @Var186
	IF (@Var187 > @Resultado) SET @Resultado = @Var187
	IF (@Var188 > @Resultado) SET @Resultado = @Var188
	IF (@Var189 > @Resultado) SET @Resultado = @Var189
	IF (@Var190 > @Resultado) SET @Resultado = @Var190
	IF (@Var191 > @Resultado) SET @Resultado = @Var191
	IF (@Var192 > @Resultado) SET @Resultado = @Var192
	IF (@Var193 > @Resultado) SET @Resultado = @Var193
	IF (@Var194 > @Resultado) SET @Resultado = @Var194
	IF (@Var195 > @Resultado) SET @Resultado = @Var195
	IF (@Var196 > @Resultado) SET @Resultado = @Var196
	IF (@Var197 > @Resultado) SET @Resultado = @Var197
	IF (@Var198 > @Resultado) SET @Resultado = @Var198
	IF (@Var199 > @Resultado) SET @Resultado = @Var199
	IF (@Var200 > @Resultado) SET @Resultado = @Var200
	IF (@Var201 > @Resultado) SET @Resultado = @Var201
	IF (@Var202 > @Resultado) SET @Resultado = @Var202
	IF (@Var203 > @Resultado) SET @Resultado = @Var203
	IF (@Var204 > @Resultado) SET @Resultado = @Var204
	IF (@Var205 > @Resultado) SET @Resultado = @Var205
	IF (@Var206 > @Resultado) SET @Resultado = @Var206
	IF (@Var207 > @Resultado) SET @Resultado = @Var207
	IF (@Var208 > @Resultado) SET @Resultado = @Var208
	IF (@Var209 > @Resultado) SET @Resultado = @Var209
	IF (@Var210 > @Resultado) SET @Resultado = @Var210
	IF (@Var211 > @Resultado) SET @Resultado = @Var211
	IF (@Var212 > @Resultado) SET @Resultado = @Var212
	IF (@Var213 > @Resultado) SET @Resultado = @Var213
	IF (@Var214 > @Resultado) SET @Resultado = @Var214
	IF (@Var215 > @Resultado) SET @Resultado = @Var215
	IF (@Var216 > @Resultado) SET @Resultado = @Var216
	IF (@Var217 > @Resultado) SET @Resultado = @Var217
	IF (@Var218 > @Resultado) SET @Resultado = @Var218
	IF (@Var219 > @Resultado) SET @Resultado = @Var219
	IF (@Var220 > @Resultado) SET @Resultado = @Var220
	IF (@Var221 > @Resultado) SET @Resultado = @Var221
	IF (@Var222 > @Resultado) SET @Resultado = @Var222
	IF (@Var223 > @Resultado) SET @Resultado = @Var223
	IF (@Var224 > @Resultado) SET @Resultado = @Var224
	IF (@Var225 > @Resultado) SET @Resultado = @Var225
	IF (@Var226 > @Resultado) SET @Resultado = @Var226
	IF (@Var227 > @Resultado) SET @Resultado = @Var227
	IF (@Var228 > @Resultado) SET @Resultado = @Var228
	IF (@Var229 > @Resultado) SET @Resultado = @Var229
	IF (@Var230 > @Resultado) SET @Resultado = @Var230
	IF (@Var231 > @Resultado) SET @Resultado = @Var231
	IF (@Var232 > @Resultado) SET @Resultado = @Var232
	IF (@Var233 > @Resultado) SET @Resultado = @Var233
	IF (@Var234 > @Resultado) SET @Resultado = @Var234
	IF (@Var235 > @Resultado) SET @Resultado = @Var235
	IF (@Var236 > @Resultado) SET @Resultado = @Var236
	IF (@Var237 > @Resultado) SET @Resultado = @Var237
	IF (@Var238 > @Resultado) SET @Resultado = @Var238
	IF (@Var239 > @Resultado) SET @Resultado = @Var239
	IF (@Var240 > @Resultado) SET @Resultado = @Var240
	IF (@Var241 > @Resultado) SET @Resultado = @Var241
	IF (@Var242 > @Resultado) SET @Resultado = @Var242
	IF (@Var243 > @Resultado) SET @Resultado = @Var243
	IF (@Var244 > @Resultado) SET @Resultado = @Var244
	IF (@Var245 > @Resultado) SET @Resultado = @Var245
	IF (@Var246 > @Resultado) SET @Resultado = @Var246
	IF (@Var247 > @Resultado) SET @Resultado = @Var247
	IF (@Var248 > @Resultado) SET @Resultado = @Var248
	IF (@Var249 > @Resultado) SET @Resultado = @Var249
	IF (@Var250 > @Resultado) SET @Resultado = @Var250
	IF (@Var251 > @Resultado) SET @Resultado = @Var251
	IF (@Var252 > @Resultado) SET @Resultado = @Var252
	IF (@Var253 > @Resultado) SET @Resultado = @Var253
	IF (@Var254 > @Resultado) SET @Resultado = @Var254
	IF (@Var255 > @Resultado) SET @Resultado = @Var255
	IF (@Var256 > @Resultado) SET @Resultado = @Var256
	IF (@Var257 > @Resultado) SET @Resultado = @Var257
	IF (@Var258 > @Resultado) SET @Resultado = @Var258
	IF (@Var259 > @Resultado) SET @Resultado = @Var259
	IF (@Var260 > @Resultado) SET @Resultado = @Var260
	IF (@Var261 > @Resultado) SET @Resultado = @Var261
	IF (@Var262 > @Resultado) SET @Resultado = @Var262
	IF (@Var263 > @Resultado) SET @Resultado = @Var263
	IF (@Var264 > @Resultado) SET @Resultado = @Var264
	IF (@Var265 > @Resultado) SET @Resultado = @Var265
	IF (@Var266 > @Resultado) SET @Resultado = @Var266
	IF (@Var267 > @Resultado) SET @Resultado = @Var267
	IF (@Var268 > @Resultado) SET @Resultado = @Var268
	IF (@Var269 > @Resultado) SET @Resultado = @Var269
	IF (@Var270 > @Resultado) SET @Resultado = @Var270
	IF (@Var271 > @Resultado) SET @Resultado = @Var271
	IF (@Var272 > @Resultado) SET @Resultado = @Var272
	IF (@Var273 > @Resultado) SET @Resultado = @Var273
	IF (@Var274 > @Resultado) SET @Resultado = @Var274
	IF (@Var275 > @Resultado) SET @Resultado = @Var275
	IF (@Var276 > @Resultado) SET @Resultado = @Var276
	IF (@Var277 > @Resultado) SET @Resultado = @Var277
	IF (@Var278 > @Resultado) SET @Resultado = @Var278
	IF (@Var279 > @Resultado) SET @Resultado = @Var279
	IF (@Var280 > @Resultado) SET @Resultado = @Var280
	IF (@Var281 > @Resultado) SET @Resultado = @Var281
	IF (@Var282 > @Resultado) SET @Resultado = @Var282
	IF (@Var283 > @Resultado) SET @Resultado = @Var283
	IF (@Var284 > @Resultado) SET @Resultado = @Var284
	IF (@Var285 > @Resultado) SET @Resultado = @Var285
	IF (@Var286 > @Resultado) SET @Resultado = @Var286
	IF (@Var287 > @Resultado) SET @Resultado = @Var287
	IF (@Var288 > @Resultado) SET @Resultado = @Var288
	IF (@Var289 > @Resultado) SET @Resultado = @Var289
	IF (@Var290 > @Resultado) SET @Resultado = @Var290
	IF (@Var291 > @Resultado) SET @Resultado = @Var291
	IF (@Var292 > @Resultado) SET @Resultado = @Var292
	IF (@Var293 > @Resultado) SET @Resultado = @Var293
	IF (@Var294 > @Resultado) SET @Resultado = @Var294
	IF (@Var295 > @Resultado) SET @Resultado = @Var295
	IF (@Var296 > @Resultado) SET @Resultado = @Var296
	IF (@Var297 > @Resultado) SET @Resultado = @Var297
	IF (@Var298 > @Resultado) SET @Resultado = @Var298
	IF (@Var299 > @Resultado) SET @Resultado = @Var299
	IF (@Var300 > @Resultado) SET @Resultado = @Var300
	IF (@Var301 > @Resultado) SET @Resultado = @Var301
	IF (@Var302 > @Resultado) SET @Resultado = @Var302
	IF (@Var303 > @Resultado) SET @Resultado = @Var303
	IF (@Var304 > @Resultado) SET @Resultado = @Var304
	IF (@Var305 > @Resultado) SET @Resultado = @Var305
	IF (@Var306 > @Resultado) SET @Resultado = @Var306
	IF (@Var307 > @Resultado) SET @Resultado = @Var307
	IF (@Var308 > @Resultado) SET @Resultado = @Var308
	IF (@Var309 > @Resultado) SET @Resultado = @Var309
	IF (@Var310 > @Resultado) SET @Resultado = @Var310
	IF (@Var311 > @Resultado) SET @Resultado = @Var311
	IF (@Var312 > @Resultado) SET @Resultado = @Var312
	IF (@Var313 > @Resultado) SET @Resultado = @Var313
	IF (@Var314 > @Resultado) SET @Resultado = @Var314
	IF (@Var315 > @Resultado) SET @Resultado = @Var315
	IF (@Var316 > @Resultado) SET @Resultado = @Var316
	IF (@Var317 > @Resultado) SET @Resultado = @Var317
	IF (@Var318 > @Resultado) SET @Resultado = @Var318
	IF (@Var319 > @Resultado) SET @Resultado = @Var319
	IF (@Var320 > @Resultado) SET @Resultado = @Var320
	IF (@Var321 > @Resultado) SET @Resultado = @Var321
	IF (@Var322 > @Resultado) SET @Resultado = @Var322
	IF (@Var323 > @Resultado) SET @Resultado = @Var323
	IF (@Var324 > @Resultado) SET @Resultado = @Var324
	IF (@Var325 > @Resultado) SET @Resultado = @Var325
	IF (@Var326 > @Resultado) SET @Resultado = @Var326
	IF (@Var327 > @Resultado) SET @Resultado = @Var327
	IF (@Var328 > @Resultado) SET @Resultado = @Var328
	IF (@Var329 > @Resultado) SET @Resultado = @Var329
	IF (@Var330 > @Resultado) SET @Resultado = @Var330
	IF (@Var331 > @Resultado) SET @Resultado = @Var331
	IF (@Var332 > @Resultado) SET @Resultado = @Var332
	IF (@Var333 > @Resultado) SET @Resultado = @Var333
	IF (@Var334 > @Resultado) SET @Resultado = @Var334
	IF (@Var335 > @Resultado) SET @Resultado = @Var335
	IF (@Var336 > @Resultado) SET @Resultado = @Var336
	IF (@Var337 > @Resultado) SET @Resultado = @Var337
	IF (@Var338 > @Resultado) SET @Resultado = @Var338
	IF (@Var339 > @Resultado) SET @Resultado = @Var339
	IF (@Var340 > @Resultado) SET @Resultado = @Var340
	IF (@Var341 > @Resultado) SET @Resultado = @Var341
	IF (@Var342 > @Resultado) SET @Resultado = @Var342
	IF (@Var343 > @Resultado) SET @Resultado = @Var343
	IF (@Var344 > @Resultado) SET @Resultado = @Var344
	IF (@Var345 > @Resultado) SET @Resultado = @Var345
	IF (@Var346 > @Resultado) SET @Resultado = @Var346
	IF (@Var347 > @Resultado) SET @Resultado = @Var347
	IF (@Var348 > @Resultado) SET @Resultado = @Var348
	IF (@Var349 > @Resultado) SET @Resultado = @Var349
	IF (@Var350 > @Resultado) SET @Resultado = @Var350
	IF (@Var351 > @Resultado) SET @Resultado = @Var351
	IF (@Var352 > @Resultado) SET @Resultado = @Var352
	IF (@Var353 > @Resultado) SET @Resultado = @Var353
	IF (@Var354 > @Resultado) SET @Resultado = @Var354
	IF (@Var355 > @Resultado) SET @Resultado = @Var355
	IF (@Var356 > @Resultado) SET @Resultado = @Var356
	IF (@Var357 > @Resultado) SET @Resultado = @Var357
	IF (@Var358 > @Resultado) SET @Resultado = @Var358
	IF (@Var359 > @Resultado) SET @Resultado = @Var359
	IF (@Var360 > @Resultado) SET @Resultado = @Var360
	IF (@Var361 > @Resultado) SET @Resultado = @Var361
	IF (@Var362 > @Resultado) SET @Resultado = @Var362
	IF (@Var363 > @Resultado) SET @Resultado = @Var363
	IF (@Var364 > @Resultado) SET @Resultado = @Var364
	IF (@Var365 > @Resultado) SET @Resultado = @Var365
	IF (@Var366 > @Resultado) SET @Resultado = @Var366
	IF (@Var367 > @Resultado) SET @Resultado = @Var367
	IF (@Var368 > @Resultado) SET @Resultado = @Var368
	IF (@Var369 > @Resultado) SET @Resultado = @Var369
	IF (@Var370 > @Resultado) SET @Resultado = @Var370
	IF (@Var371 > @Resultado) SET @Resultado = @Var371
	IF (@Var372 > @Resultado) SET @Resultado = @Var372
	IF (@Var373 > @Resultado) SET @Resultado = @Var373
	IF (@Var374 > @Resultado) SET @Resultado = @Var374
	IF (@Var375 > @Resultado) SET @Resultado = @Var375
	IF (@Var376 > @Resultado) SET @Resultado = @Var376
	IF (@Var377 > @Resultado) SET @Resultado = @Var377
	IF (@Var378 > @Resultado) SET @Resultado = @Var378
	IF (@Var379 > @Resultado) SET @Resultado = @Var379
	IF (@Var380 > @Resultado) SET @Resultado = @Var380
	IF (@Var381 > @Resultado) SET @Resultado = @Var381
	IF (@Var382 > @Resultado) SET @Resultado = @Var382
	IF (@Var383 > @Resultado) SET @Resultado = @Var383
	IF (@Var384 > @Resultado) SET @Resultado = @Var384
	IF (@Var385 > @Resultado) SET @Resultado = @Var385
	IF (@Var386 > @Resultado) SET @Resultado = @Var386
	IF (@Var387 > @Resultado) SET @Resultado = @Var387
	IF (@Var388 > @Resultado) SET @Resultado = @Var388
	IF (@Var389 > @Resultado) SET @Resultado = @Var389
	IF (@Var390 > @Resultado) SET @Resultado = @Var390
	IF (@Var391 > @Resultado) SET @Resultado = @Var391
	IF (@Var392 > @Resultado) SET @Resultado = @Var392
	IF (@Var393 > @Resultado) SET @Resultado = @Var393
	IF (@Var394 > @Resultado) SET @Resultado = @Var394
	IF (@Var395 > @Resultado) SET @Resultado = @Var395
	IF (@Var396 > @Resultado) SET @Resultado = @Var396
	IF (@Var397 > @Resultado) SET @Resultado = @Var397
	IF (@Var398 > @Resultado) SET @Resultado = @Var398
	IF (@Var399 > @Resultado) SET @Resultado = @Var399
	IF (@Var400 > @Resultado) SET @Resultado = @Var400
	IF (@Var401 > @Resultado) SET @Resultado = @Var401
	IF (@Var402 > @Resultado) SET @Resultado = @Var402
	IF (@Var403 > @Resultado) SET @Resultado = @Var403
	IF (@Var404 > @Resultado) SET @Resultado = @Var404
	IF (@Var405 > @Resultado) SET @Resultado = @Var405
	IF (@Var406 > @Resultado) SET @Resultado = @Var406
	IF (@Var407 > @Resultado) SET @Resultado = @Var407
	IF (@Var408 > @Resultado) SET @Resultado = @Var408
	IF (@Var409 > @Resultado) SET @Resultado = @Var409
	IF (@Var410 > @Resultado) SET @Resultado = @Var410
	IF (@Var411 > @Resultado) SET @Resultado = @Var411
	IF (@Var412 > @Resultado) SET @Resultado = @Var412
	IF (@Var413 > @Resultado) SET @Resultado = @Var413
	IF (@Var414 > @Resultado) SET @Resultado = @Var414
	IF (@Var415 > @Resultado) SET @Resultado = @Var415
	IF (@Var416 > @Resultado) SET @Resultado = @Var416
	IF (@Var417 > @Resultado) SET @Resultado = @Var417
	IF (@Var418 > @Resultado) SET @Resultado = @Var418
	IF (@Var419 > @Resultado) SET @Resultado = @Var419
	IF (@Var420 > @Resultado) SET @Resultado = @Var420
	IF (@Var421 > @Resultado) SET @Resultado = @Var421
	IF (@Var422 > @Resultado) SET @Resultado = @Var422
	IF (@Var423 > @Resultado) SET @Resultado = @Var423
	IF (@Var424 > @Resultado) SET @Resultado = @Var424
	IF (@Var425 > @Resultado) SET @Resultado = @Var425
	IF (@Var426 > @Resultado) SET @Resultado = @Var426
	IF (@Var427 > @Resultado) SET @Resultado = @Var427
	IF (@Var428 > @Resultado) SET @Resultado = @Var428
	IF (@Var429 > @Resultado) SET @Resultado = @Var429
	IF (@Var430 > @Resultado) SET @Resultado = @Var430
	IF (@Var431 > @Resultado) SET @Resultado = @Var431
	IF (@Var432 > @Resultado) SET @Resultado = @Var432
	IF (@Var433 > @Resultado) SET @Resultado = @Var433
	IF (@Var434 > @Resultado) SET @Resultado = @Var434
	IF (@Var435 > @Resultado) SET @Resultado = @Var435
	IF (@Var436 > @Resultado) SET @Resultado = @Var436
	IF (@Var437 > @Resultado) SET @Resultado = @Var437
	IF (@Var438 > @Resultado) SET @Resultado = @Var438
	IF (@Var439 > @Resultado) SET @Resultado = @Var439
	IF (@Var440 > @Resultado) SET @Resultado = @Var440
	IF (@Var441 > @Resultado) SET @Resultado = @Var441
	IF (@Var442 > @Resultado) SET @Resultado = @Var442
	IF (@Var443 > @Resultado) SET @Resultado = @Var443
	IF (@Var444 > @Resultado) SET @Resultado = @Var444
	IF (@Var445 > @Resultado) SET @Resultado = @Var445
	IF (@Var446 > @Resultado) SET @Resultado = @Var446
	IF (@Var447 > @Resultado) SET @Resultado = @Var447
	IF (@Var448 > @Resultado) SET @Resultado = @Var448
	IF (@Var449 > @Resultado) SET @Resultado = @Var449
	IF (@Var450 > @Resultado) SET @Resultado = @Var450
	IF (@Var451 > @Resultado) SET @Resultado = @Var451
	IF (@Var452 > @Resultado) SET @Resultado = @Var452
	IF (@Var453 > @Resultado) SET @Resultado = @Var453
	IF (@Var454 > @Resultado) SET @Resultado = @Var454
	IF (@Var455 > @Resultado) SET @Resultado = @Var455
	IF (@Var456 > @Resultado) SET @Resultado = @Var456
	IF (@Var457 > @Resultado) SET @Resultado = @Var457
	IF (@Var458 > @Resultado) SET @Resultado = @Var458
	IF (@Var459 > @Resultado) SET @Resultado = @Var459
	IF (@Var460 > @Resultado) SET @Resultado = @Var460
	IF (@Var461 > @Resultado) SET @Resultado = @Var461
	IF (@Var462 > @Resultado) SET @Resultado = @Var462
	IF (@Var463 > @Resultado) SET @Resultado = @Var463
	IF (@Var464 > @Resultado) SET @Resultado = @Var464
	IF (@Var465 > @Resultado) SET @Resultado = @Var465
	IF (@Var466 > @Resultado) SET @Resultado = @Var466
	IF (@Var467 > @Resultado) SET @Resultado = @Var467
	IF (@Var468 > @Resultado) SET @Resultado = @Var468
	IF (@Var469 > @Resultado) SET @Resultado = @Var469
	IF (@Var470 > @Resultado) SET @Resultado = @Var470
	IF (@Var471 > @Resultado) SET @Resultado = @Var471
	IF (@Var472 > @Resultado) SET @Resultado = @Var472
	IF (@Var473 > @Resultado) SET @Resultado = @Var473
	IF (@Var474 > @Resultado) SET @Resultado = @Var474
	IF (@Var475 > @Resultado) SET @Resultado = @Var475
	IF (@Var476 > @Resultado) SET @Resultado = @Var476
	IF (@Var477 > @Resultado) SET @Resultado = @Var477
	IF (@Var478 > @Resultado) SET @Resultado = @Var478
	IF (@Var479 > @Resultado) SET @Resultado = @Var479
	IF (@Var480 > @Resultado) SET @Resultado = @Var480
	IF (@Var481 > @Resultado) SET @Resultado = @Var481
	IF (@Var482 > @Resultado) SET @Resultado = @Var482
	IF (@Var483 > @Resultado) SET @Resultado = @Var483
	IF (@Var484 > @Resultado) SET @Resultado = @Var484
	IF (@Var485 > @Resultado) SET @Resultado = @Var485
	IF (@Var486 > @Resultado) SET @Resultado = @Var486
	IF (@Var487 > @Resultado) SET @Resultado = @Var487
	IF (@Var488 > @Resultado) SET @Resultado = @Var488
	IF (@Var489 > @Resultado) SET @Resultado = @Var489
	IF (@Var490 > @Resultado) SET @Resultado = @Var490
	IF (@Var491 > @Resultado) SET @Resultado = @Var491
	IF (@Var492 > @Resultado) SET @Resultado = @Var492
	IF (@Var493 > @Resultado) SET @Resultado = @Var493
	IF (@Var494 > @Resultado) SET @Resultado = @Var494
	IF (@Var495 > @Resultado) SET @Resultado = @Var495
	IF (@Var496 > @Resultado) SET @Resultado = @Var496
	IF (@Var497 > @Resultado) SET @Resultado = @Var497
	IF (@Var498 > @Resultado) SET @Resultado = @Var498
	IF (@Var499 > @Resultado) SET @Resultado = @Var499
	IF (@Var500 > @Resultado) SET @Resultado = @Var500
	IF (@Var501 > @Resultado) SET @Resultado = @Var501
	IF (@Var502 > @Resultado) SET @Resultado = @Var502
	IF (@Var503 > @Resultado) SET @Resultado = @Var503
	IF (@Var504 > @Resultado) SET @Resultado = @Var504
	IF (@Var505 > @Resultado) SET @Resultado = @Var505
	IF (@Var506 > @Resultado) SET @Resultado = @Var506
	IF (@Var507 > @Resultado) SET @Resultado = @Var507
	IF (@Var508 > @Resultado) SET @Resultado = @Var508
	IF (@Var509 > @Resultado) SET @Resultado = @Var509
	IF (@Var510 > @Resultado) SET @Resultado = @Var510
	IF (@Var511 > @Resultado) SET @Resultado = @Var511
	IF (@Var512 > @Resultado) SET @Resultado = @Var512
	IF (@Var513 > @Resultado) SET @Resultado = @Var513
	IF (@Var514 > @Resultado) SET @Resultado = @Var514
	IF (@Var515 > @Resultado) SET @Resultado = @Var515
	IF (@Var516 > @Resultado) SET @Resultado = @Var516
	IF (@Var517 > @Resultado) SET @Resultado = @Var517
	IF (@Var518 > @Resultado) SET @Resultado = @Var518
	IF (@Var519 > @Resultado) SET @Resultado = @Var519
	IF (@Var520 > @Resultado) SET @Resultado = @Var520
	IF (@Var521 > @Resultado) SET @Resultado = @Var521
	IF (@Var522 > @Resultado) SET @Resultado = @Var522
	IF (@Var523 > @Resultado) SET @Resultado = @Var523
	IF (@Var524 > @Resultado) SET @Resultado = @Var524
	IF (@Var525 > @Resultado) SET @Resultado = @Var525
	IF (@Var526 > @Resultado) SET @Resultado = @Var526
	IF (@Var527 > @Resultado) SET @Resultado = @Var527
	IF (@Var528 > @Resultado) SET @Resultado = @Var528
	IF (@Var529 > @Resultado) SET @Resultado = @Var529
	IF (@Var530 > @Resultado) SET @Resultado = @Var530
	IF (@Var531 > @Resultado) SET @Resultado = @Var531
	IF (@Var532 > @Resultado) SET @Resultado = @Var532
	IF (@Var533 > @Resultado) SET @Resultado = @Var533
	IF (@Var534 > @Resultado) SET @Resultado = @Var534
	IF (@Var535 > @Resultado) SET @Resultado = @Var535
	IF (@Var536 > @Resultado) SET @Resultado = @Var536
	IF (@Var537 > @Resultado) SET @Resultado = @Var537
	IF (@Var538 > @Resultado) SET @Resultado = @Var538
	IF (@Var539 > @Resultado) SET @Resultado = @Var539
	IF (@Var540 > @Resultado) SET @Resultado = @Var540
	IF (@Var541 > @Resultado) SET @Resultado = @Var541
	IF (@Var542 > @Resultado) SET @Resultado = @Var542
	IF (@Var543 > @Resultado) SET @Resultado = @Var543
	IF (@Var544 > @Resultado) SET @Resultado = @Var544
	IF (@Var545 > @Resultado) SET @Resultado = @Var545
	IF (@Var546 > @Resultado) SET @Resultado = @Var546
	IF (@Var547 > @Resultado) SET @Resultado = @Var547
	IF (@Var548 > @Resultado) SET @Resultado = @Var548
	IF (@Var549 > @Resultado) SET @Resultado = @Var549
	IF (@Var550 > @Resultado) SET @Resultado = @Var550
	IF (@Var551 > @Resultado) SET @Resultado = @Var551
	IF (@Var552 > @Resultado) SET @Resultado = @Var552
	IF (@Var553 > @Resultado) SET @Resultado = @Var553
	IF (@Var554 > @Resultado) SET @Resultado = @Var554
	IF (@Var555 > @Resultado) SET @Resultado = @Var555
	IF (@Var556 > @Resultado) SET @Resultado = @Var556
	IF (@Var557 > @Resultado) SET @Resultado = @Var557
	IF (@Var558 > @Resultado) SET @Resultado = @Var558
	IF (@Var559 > @Resultado) SET @Resultado = @Var559
	IF (@Var560 > @Resultado) SET @Resultado = @Var560
	IF (@Var561 > @Resultado) SET @Resultado = @Var561
	IF (@Var562 > @Resultado) SET @Resultado = @Var562
	IF (@Var563 > @Resultado) SET @Resultado = @Var563
	IF (@Var564 > @Resultado) SET @Resultado = @Var564
	IF (@Var565 > @Resultado) SET @Resultado = @Var565
	IF (@Var566 > @Resultado) SET @Resultado = @Var566
	IF (@Var567 > @Resultado) SET @Resultado = @Var567
	IF (@Var568 > @Resultado) SET @Resultado = @Var568
	IF (@Var569 > @Resultado) SET @Resultado = @Var569
	IF (@Var570 > @Resultado) SET @Resultado = @Var570
	IF (@Var571 > @Resultado) SET @Resultado = @Var571
	IF (@Var572 > @Resultado) SET @Resultado = @Var572
	IF (@Var573 > @Resultado) SET @Resultado = @Var573
	IF (@Var574 > @Resultado) SET @Resultado = @Var574
	IF (@Var575 > @Resultado) SET @Resultado = @Var575
	IF (@Var576 > @Resultado) SET @Resultado = @Var576
	IF (@Var577 > @Resultado) SET @Resultado = @Var577
	IF (@Var578 > @Resultado) SET @Resultado = @Var578
	IF (@Var579 > @Resultado) SET @Resultado = @Var579
	IF (@Var580 > @Resultado) SET @Resultado = @Var580
	IF (@Var581 > @Resultado) SET @Resultado = @Var581
	IF (@Var582 > @Resultado) SET @Resultado = @Var582
	IF (@Var583 > @Resultado) SET @Resultado = @Var583
	IF (@Var584 > @Resultado) SET @Resultado = @Var584
	IF (@Var585 > @Resultado) SET @Resultado = @Var585
	IF (@Var586 > @Resultado) SET @Resultado = @Var586
	IF (@Var587 > @Resultado) SET @Resultado = @Var587
	IF (@Var588 > @Resultado) SET @Resultado = @Var588
	IF (@Var589 > @Resultado) SET @Resultado = @Var589
	IF (@Var590 > @Resultado) SET @Resultado = @Var590
	IF (@Var591 > @Resultado) SET @Resultado = @Var591
	IF (@Var592 > @Resultado) SET @Resultado = @Var592
	IF (@Var593 > @Resultado) SET @Resultado = @Var593
	IF (@Var594 > @Resultado) SET @Resultado = @Var594
	IF (@Var595 > @Resultado) SET @Resultado = @Var595
	IF (@Var596 > @Resultado) SET @Resultado = @Var596
	IF (@Var597 > @Resultado) SET @Resultado = @Var597
	IF (@Var598 > @Resultado) SET @Resultado = @Var598
	IF (@Var599 > @Resultado) SET @Resultado = @Var599
	IF (@Var600 > @Resultado) SET @Resultado = @Var600
	IF (@Var601 > @Resultado) SET @Resultado = @Var601
	IF (@Var602 > @Resultado) SET @Resultado = @Var602
	IF (@Var603 > @Resultado) SET @Resultado = @Var603
	IF (@Var604 > @Resultado) SET @Resultado = @Var604
	IF (@Var605 > @Resultado) SET @Resultado = @Var605
	IF (@Var606 > @Resultado) SET @Resultado = @Var606
	IF (@Var607 > @Resultado) SET @Resultado = @Var607
	IF (@Var608 > @Resultado) SET @Resultado = @Var608
	IF (@Var609 > @Resultado) SET @Resultado = @Var609
	IF (@Var610 > @Resultado) SET @Resultado = @Var610
	IF (@Var611 > @Resultado) SET @Resultado = @Var611
	IF (@Var612 > @Resultado) SET @Resultado = @Var612
	IF (@Var613 > @Resultado) SET @Resultado = @Var613
	IF (@Var614 > @Resultado) SET @Resultado = @Var614
	IF (@Var615 > @Resultado) SET @Resultado = @Var615
	IF (@Var616 > @Resultado) SET @Resultado = @Var616
	IF (@Var617 > @Resultado) SET @Resultado = @Var617
	IF (@Var618 > @Resultado) SET @Resultado = @Var618
	IF (@Var619 > @Resultado) SET @Resultado = @Var619
	IF (@Var620 > @Resultado) SET @Resultado = @Var620
	IF (@Var621 > @Resultado) SET @Resultado = @Var621
	IF (@Var622 > @Resultado) SET @Resultado = @Var622
	IF (@Var623 > @Resultado) SET @Resultado = @Var623
	IF (@Var624 > @Resultado) SET @Resultado = @Var624
	IF (@Var625 > @Resultado) SET @Resultado = @Var625
	IF (@Var626 > @Resultado) SET @Resultado = @Var626
	IF (@Var627 > @Resultado) SET @Resultado = @Var627
	IF (@Var628 > @Resultado) SET @Resultado = @Var628
	IF (@Var629 > @Resultado) SET @Resultado = @Var629
	IF (@Var630 > @Resultado) SET @Resultado = @Var630
	IF (@Var631 > @Resultado) SET @Resultado = @Var631
	IF (@Var632 > @Resultado) SET @Resultado = @Var632
	IF (@Var633 > @Resultado) SET @Resultado = @Var633
	IF (@Var634 > @Resultado) SET @Resultado = @Var634
	IF (@Var635 > @Resultado) SET @Resultado = @Var635
	IF (@Var636 > @Resultado) SET @Resultado = @Var636
	IF (@Var637 > @Resultado) SET @Resultado = @Var637
	IF (@Var638 > @Resultado) SET @Resultado = @Var638
	IF (@Var639 > @Resultado) SET @Resultado = @Var639
	IF (@Var640 > @Resultado) SET @Resultado = @Var640
	IF (@Var641 > @Resultado) SET @Resultado = @Var641
	IF (@Var642 > @Resultado) SET @Resultado = @Var642
	IF (@Var643 > @Resultado) SET @Resultado = @Var643
	IF (@Var644 > @Resultado) SET @Resultado = @Var644
	IF (@Var645 > @Resultado) SET @Resultado = @Var645
	IF (@Var646 > @Resultado) SET @Resultado = @Var646
	IF (@Var647 > @Resultado) SET @Resultado = @Var647
	IF (@Var648 > @Resultado) SET @Resultado = @Var648
	IF (@Var649 > @Resultado) SET @Resultado = @Var649
	IF (@Var650 > @Resultado) SET @Resultado = @Var650
	IF (@Var651 > @Resultado) SET @Resultado = @Var651
	IF (@Var652 > @Resultado) SET @Resultado = @Var652
	IF (@Var653 > @Resultado) SET @Resultado = @Var653
	IF (@Var654 > @Resultado) SET @Resultado = @Var654
	IF (@Var655 > @Resultado) SET @Resultado = @Var655
	IF (@Var656 > @Resultado) SET @Resultado = @Var656
	IF (@Var657 > @Resultado) SET @Resultado = @Var657
	IF (@Var658 > @Resultado) SET @Resultado = @Var658
	IF (@Var659 > @Resultado) SET @Resultado = @Var659
	IF (@Var660 > @Resultado) SET @Resultado = @Var660
	IF (@Var661 > @Resultado) SET @Resultado = @Var661
	IF (@Var662 > @Resultado) SET @Resultado = @Var662
	IF (@Var663 > @Resultado) SET @Resultado = @Var663
	IF (@Var664 > @Resultado) SET @Resultado = @Var664
	IF (@Var665 > @Resultado) SET @Resultado = @Var665
	IF (@Var666 > @Resultado) SET @Resultado = @Var666
	IF (@Var667 > @Resultado) SET @Resultado = @Var667
	IF (@Var668 > @Resultado) SET @Resultado = @Var668
	IF (@Var669 > @Resultado) SET @Resultado = @Var669
	IF (@Var670 > @Resultado) SET @Resultado = @Var670
	IF (@Var671 > @Resultado) SET @Resultado = @Var671
	IF (@Var672 > @Resultado) SET @Resultado = @Var672
	IF (@Var673 > @Resultado) SET @Resultado = @Var673
	IF (@Var674 > @Resultado) SET @Resultado = @Var674
	IF (@Var675 > @Resultado) SET @Resultado = @Var675
	IF (@Var676 > @Resultado) SET @Resultado = @Var676
	IF (@Var677 > @Resultado) SET @Resultado = @Var677
	IF (@Var678 > @Resultado) SET @Resultado = @Var678
	IF (@Var679 > @Resultado) SET @Resultado = @Var679
	IF (@Var680 > @Resultado) SET @Resultado = @Var680
	IF (@Var681 > @Resultado) SET @Resultado = @Var681
	IF (@Var682 > @Resultado) SET @Resultado = @Var682
	IF (@Var683 > @Resultado) SET @Resultado = @Var683
	IF (@Var684 > @Resultado) SET @Resultado = @Var684
	IF (@Var685 > @Resultado) SET @Resultado = @Var685
	IF (@Var686 > @Resultado) SET @Resultado = @Var686
	IF (@Var687 > @Resultado) SET @Resultado = @Var687
	IF (@Var688 > @Resultado) SET @Resultado = @Var688
	IF (@Var689 > @Resultado) SET @Resultado = @Var689
	IF (@Var690 > @Resultado) SET @Resultado = @Var690
	IF (@Var691 > @Resultado) SET @Resultado = @Var691
	IF (@Var692 > @Resultado) SET @Resultado = @Var692
	IF (@Var693 > @Resultado) SET @Resultado = @Var693
	IF (@Var694 > @Resultado) SET @Resultado = @Var694
	IF (@Var695 > @Resultado) SET @Resultado = @Var695
	IF (@Var696 > @Resultado) SET @Resultado = @Var696
	IF (@Var697 > @Resultado) SET @Resultado = @Var697
	IF (@Var698 > @Resultado) SET @Resultado = @Var698
	IF (@Var699 > @Resultado) SET @Resultado = @Var699
	IF (@Var700 > @Resultado) SET @Resultado = @Var700
	IF (@Var701 > @Resultado) SET @Resultado = @Var701
	IF (@Var702 > @Resultado) SET @Resultado = @Var702
	IF (@Var703 > @Resultado) SET @Resultado = @Var703
	IF (@Var704 > @Resultado) SET @Resultado = @Var704
	IF (@Var705 > @Resultado) SET @Resultado = @Var705
	IF (@Var706 > @Resultado) SET @Resultado = @Var706
	IF (@Var707 > @Resultado) SET @Resultado = @Var707
	IF (@Var708 > @Resultado) SET @Resultado = @Var708
	IF (@Var709 > @Resultado) SET @Resultado = @Var709
	IF (@Var710 > @Resultado) SET @Resultado = @Var710
	IF (@Var711 > @Resultado) SET @Resultado = @Var711
	IF (@Var712 > @Resultado) SET @Resultado = @Var712
	IF (@Var713 > @Resultado) SET @Resultado = @Var713
	IF (@Var714 > @Resultado) SET @Resultado = @Var714
	IF (@Var715 > @Resultado) SET @Resultado = @Var715
	IF (@Var716 > @Resultado) SET @Resultado = @Var716
	IF (@Var717 > @Resultado) SET @Resultado = @Var717
	IF (@Var718 > @Resultado) SET @Resultado = @Var718
	IF (@Var719 > @Resultado) SET @Resultado = @Var719
	IF (@Var720 > @Resultado) SET @Resultado = @Var720
	IF (@Var721 > @Resultado) SET @Resultado = @Var721
	IF (@Var722 > @Resultado) SET @Resultado = @Var722
	IF (@Var723 > @Resultado) SET @Resultado = @Var723
	IF (@Var724 > @Resultado) SET @Resultado = @Var724
	IF (@Var725 > @Resultado) SET @Resultado = @Var725
	IF (@Var726 > @Resultado) SET @Resultado = @Var726
	IF (@Var727 > @Resultado) SET @Resultado = @Var727
	IF (@Var728 > @Resultado) SET @Resultado = @Var728
	IF (@Var729 > @Resultado) SET @Resultado = @Var729
	IF (@Var730 > @Resultado) SET @Resultado = @Var730
	IF (@Var731 > @Resultado) SET @Resultado = @Var731
	IF (@Var732 > @Resultado) SET @Resultado = @Var732
	IF (@Var733 > @Resultado) SET @Resultado = @Var733
	IF (@Var734 > @Resultado) SET @Resultado = @Var734
	IF (@Var735 > @Resultado) SET @Resultado = @Var735
	IF (@Var736 > @Resultado) SET @Resultado = @Var736
	IF (@Var737 > @Resultado) SET @Resultado = @Var737
	IF (@Var738 > @Resultado) SET @Resultado = @Var738
	IF (@Var739 > @Resultado) SET @Resultado = @Var739
	IF (@Var740 > @Resultado) SET @Resultado = @Var740
	IF (@Var741 > @Resultado) SET @Resultado = @Var741
	IF (@Var742 > @Resultado) SET @Resultado = @Var742
	IF (@Var743 > @Resultado) SET @Resultado = @Var743
	IF (@Var744 > @Resultado) SET @Resultado = @Var744
	IF (@Var745 > @Resultado) SET @Resultado = @Var745
	IF (@Var746 > @Resultado) SET @Resultado = @Var746
	IF (@Var747 > @Resultado) SET @Resultado = @Var747
	IF (@Var748 > @Resultado) SET @Resultado = @Var748
	IF (@Var749 > @Resultado) SET @Resultado = @Var749
	IF (@Var750 > @Resultado) SET @Resultado = @Var750
	IF (@Var751 > @Resultado) SET @Resultado = @Var751
	IF (@Var752 > @Resultado) SET @Resultado = @Var752
	IF (@Var753 > @Resultado) SET @Resultado = @Var753
	IF (@Var754 > @Resultado) SET @Resultado = @Var754
	IF (@Var755 > @Resultado) SET @Resultado = @Var755
	IF (@Var756 > @Resultado) SET @Resultado = @Var756
	IF (@Var757 > @Resultado) SET @Resultado = @Var757
	IF (@Var758 > @Resultado) SET @Resultado = @Var758
	IF (@Var759 > @Resultado) SET @Resultado = @Var759
	IF (@Var760 > @Resultado) SET @Resultado = @Var760
	IF (@Var761 > @Resultado) SET @Resultado = @Var761
	IF (@Var762 > @Resultado) SET @Resultado = @Var762
	IF (@Var763 > @Resultado) SET @Resultado = @Var763
	IF (@Var764 > @Resultado) SET @Resultado = @Var764
	IF (@Var765 > @Resultado) SET @Resultado = @Var765
	IF (@Var766 > @Resultado) SET @Resultado = @Var766
	IF (@Var767 > @Resultado) SET @Resultado = @Var767
	IF (@Var768 > @Resultado) SET @Resultado = @Var768
	IF (@Var769 > @Resultado) SET @Resultado = @Var769
	IF (@Var770 > @Resultado) SET @Resultado = @Var770
	IF (@Var771 > @Resultado) SET @Resultado = @Var771
	IF (@Var772 > @Resultado) SET @Resultado = @Var772
	IF (@Var773 > @Resultado) SET @Resultado = @Var773
	IF (@Var774 > @Resultado) SET @Resultado = @Var774
	IF (@Var775 > @Resultado) SET @Resultado = @Var775
	IF (@Var776 > @Resultado) SET @Resultado = @Var776
	IF (@Var777 > @Resultado) SET @Resultado = @Var777
	IF (@Var778 > @Resultado) SET @Resultado = @Var778
	IF (@Var779 > @Resultado) SET @Resultado = @Var779
	IF (@Var780 > @Resultado) SET @Resultado = @Var780
	IF (@Var781 > @Resultado) SET @Resultado = @Var781
	IF (@Var782 > @Resultado) SET @Resultado = @Var782
	IF (@Var783 > @Resultado) SET @Resultado = @Var783
	IF (@Var784 > @Resultado) SET @Resultado = @Var784
	IF (@Var785 > @Resultado) SET @Resultado = @Var785
	IF (@Var786 > @Resultado) SET @Resultado = @Var786
	IF (@Var787 > @Resultado) SET @Resultado = @Var787
	IF (@Var788 > @Resultado) SET @Resultado = @Var788
	IF (@Var789 > @Resultado) SET @Resultado = @Var789
	IF (@Var790 > @Resultado) SET @Resultado = @Var790
	IF (@Var791 > @Resultado) SET @Resultado = @Var791
	IF (@Var792 > @Resultado) SET @Resultado = @Var792
	IF (@Var793 > @Resultado) SET @Resultado = @Var793
	IF (@Var794 > @Resultado) SET @Resultado = @Var794
	IF (@Var795 > @Resultado) SET @Resultado = @Var795
	IF (@Var796 > @Resultado) SET @Resultado = @Var796
	IF (@Var797 > @Resultado) SET @Resultado = @Var797
	IF (@Var798 > @Resultado) SET @Resultado = @Var798
	IF (@Var799 > @Resultado) SET @Resultado = @Var799
	IF (@Var800 > @Resultado) SET @Resultado = @Var800
	IF (@Var801 > @Resultado) SET @Resultado = @Var801
	IF (@Var802 > @Resultado) SET @Resultado = @Var802
	IF (@Var803 > @Resultado) SET @Resultado = @Var803
	IF (@Var804 > @Resultado) SET @Resultado = @Var804
	IF (@Var805 > @Resultado) SET @Resultado = @Var805
	IF (@Var806 > @Resultado) SET @Resultado = @Var806
	IF (@Var807 > @Resultado) SET @Resultado = @Var807
	IF (@Var808 > @Resultado) SET @Resultado = @Var808
	IF (@Var809 > @Resultado) SET @Resultado = @Var809
	IF (@Var810 > @Resultado) SET @Resultado = @Var810
	IF (@Var811 > @Resultado) SET @Resultado = @Var811
	IF (@Var812 > @Resultado) SET @Resultado = @Var812
	IF (@Var813 > @Resultado) SET @Resultado = @Var813
	IF (@Var814 > @Resultado) SET @Resultado = @Var814
	IF (@Var815 > @Resultado) SET @Resultado = @Var815
	IF (@Var816 > @Resultado) SET @Resultado = @Var816
	IF (@Var817 > @Resultado) SET @Resultado = @Var817
	IF (@Var818 > @Resultado) SET @Resultado = @Var818
	IF (@Var819 > @Resultado) SET @Resultado = @Var819
	IF (@Var820 > @Resultado) SET @Resultado = @Var820
	IF (@Var821 > @Resultado) SET @Resultado = @Var821
	IF (@Var822 > @Resultado) SET @Resultado = @Var822
	IF (@Var823 > @Resultado) SET @Resultado = @Var823
	IF (@Var824 > @Resultado) SET @Resultado = @Var824
	IF (@Var825 > @Resultado) SET @Resultado = @Var825
	IF (@Var826 > @Resultado) SET @Resultado = @Var826
	IF (@Var827 > @Resultado) SET @Resultado = @Var827
	IF (@Var828 > @Resultado) SET @Resultado = @Var828
	IF (@Var829 > @Resultado) SET @Resultado = @Var829
	IF (@Var830 > @Resultado) SET @Resultado = @Var830
	IF (@Var831 > @Resultado) SET @Resultado = @Var831
	IF (@Var832 > @Resultado) SET @Resultado = @Var832
	IF (@Var833 > @Resultado) SET @Resultado = @Var833
	IF (@Var834 > @Resultado) SET @Resultado = @Var834
	IF (@Var835 > @Resultado) SET @Resultado = @Var835
	IF (@Var836 > @Resultado) SET @Resultado = @Var836
	IF (@Var837 > @Resultado) SET @Resultado = @Var837
	IF (@Var838 > @Resultado) SET @Resultado = @Var838
	IF (@Var839 > @Resultado) SET @Resultado = @Var839
	IF (@Var840 > @Resultado) SET @Resultado = @Var840
	IF (@Var841 > @Resultado) SET @Resultado = @Var841
	IF (@Var842 > @Resultado) SET @Resultado = @Var842
	IF (@Var843 > @Resultado) SET @Resultado = @Var843
	IF (@Var844 > @Resultado) SET @Resultado = @Var844
	IF (@Var845 > @Resultado) SET @Resultado = @Var845
	IF (@Var846 > @Resultado) SET @Resultado = @Var846
	IF (@Var847 > @Resultado) SET @Resultado = @Var847
	IF (@Var848 > @Resultado) SET @Resultado = @Var848
	IF (@Var849 > @Resultado) SET @Resultado = @Var849
	IF (@Var850 > @Resultado) SET @Resultado = @Var850
	IF (@Var851 > @Resultado) SET @Resultado = @Var851
	IF (@Var852 > @Resultado) SET @Resultado = @Var852
	IF (@Var853 > @Resultado) SET @Resultado = @Var853
	IF (@Var854 > @Resultado) SET @Resultado = @Var854
	IF (@Var855 > @Resultado) SET @Resultado = @Var855
	IF (@Var856 > @Resultado) SET @Resultado = @Var856
	IF (@Var857 > @Resultado) SET @Resultado = @Var857
	IF (@Var858 > @Resultado) SET @Resultado = @Var858
	IF (@Var859 > @Resultado) SET @Resultado = @Var859
	IF (@Var860 > @Resultado) SET @Resultado = @Var860
	IF (@Var861 > @Resultado) SET @Resultado = @Var861
	IF (@Var862 > @Resultado) SET @Resultado = @Var862
	IF (@Var863 > @Resultado) SET @Resultado = @Var863
	IF (@Var864 > @Resultado) SET @Resultado = @Var864

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[Min2Patamares]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[Min2Patamares] 
(
	-- Add the parameters for the function here
	@Var01 decimal(18,9),
	@Var02 decimal(18,9)
)
RETURNS decimal(18,9)
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado decimal(18,9) = @Var01

	-- Add the T-SQL statements to compute the return value here
	IF (@Var01 < @Resultado) SET @Resultado = @Var01
	IF (@Var02 < @Resultado) SET @Resultado = @Var02

	-- Return the result of the function
	RETURN @Resultado

END









GO
/****** Object:  UserDefinedFunction [dbo].[NivelTensao]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[NivelTensao] 
(
	-- Add the parameters for the function here
	@Tensao_kV decimal(18,9)
)
RETURNS nvarchar(3)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Resultado nvarchar(3) = NULL

	-- Add the T-SQL statements to compute the return value here
	IF (@Tensao_kV >= 230) SET @Resultado = N'A1'
	ELSE IF (@Tensao_kV >= 88) SET @Resultado = N'A2'
	ELSE IF (@Tensao_kV >= 60) SET @Resultado = N'A3'
	ELSE IF (@Tensao_kV >= 30) SET @Resultado = N'A3a'
	ELSE IF (@Tensao_kV >= 2.3) SET @Resultado = N'A4'
	ELSE IF (@Tensao_kV < 2.3 AND @Tensao_kV <> 0) SET @Resultado = N'B'

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[NivelTensaoSimplificado]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[NivelTensaoSimplificado] 
(
	-- Add the parameters for the function here
	@NivTenPri nvarchar(3),
	@NivTenSec nvarchar(3),
	@NivTenTer nvarchar(3),
	@Inv int,
	@Ordem int
)
RETURNS nvarchar(3)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Resultado nvarchar(3) = NULL

	-- Add the T-SQL statements to compute the return value here
	IF (@Inv = 1)
	BEGIN
		IF (@Ordem = 1)
		BEGIN
			IF (@NivTenSec = N'A1') SET @Resultado = N'A1'
			ELSE IF (@NivTenSec = N'A2') SET @Resultado = N'A2'
			ELSE IF (@NivTenSec = N'A3') SET @Resultado = N'A3'
			ELSE IF (@NivTenSec = N'A3a') SET @Resultado = N'MT'
			ELSE IF (@NivTenSec = N'A4') SET @Resultado = N'MT'
			ELSE IF (@NivTenSec = N'B') SET @Resultado = N'B'
		END
		IF (@Ordem = 2)
		BEGIN
			IF (@NivTenPri = N'A1') SET @Resultado = N'A1'
			ELSE IF (@NivTenPri = N'A2') SET @Resultado = N'A2'
			ELSE IF (@NivTenPri = N'A3') SET @Resultado = N'A3'
			ELSE IF (@NivTenPri = N'A3a') SET @Resultado = N'MT'
			ELSE IF (@NivTenPri = N'A4') SET @Resultado = N'MT'
			ELSE IF (@NivTenPri = N'B') SET @Resultado = N'B'
		END
		IF (@Ordem = 3)
		BEGIN
			IF (@NivTenTer = N'A1') SET @Resultado = N'A1'
			ELSE IF (@NivTenTer = N'A2') SET @Resultado = N'A2'
			ELSE IF (@NivTenTer = N'A3') SET @Resultado = N'A3'
			ELSE IF (@NivTenTer = N'A3a') SET @Resultado = N'MT'
			ELSE IF (@NivTenTer = N'A4') SET @Resultado = N'MT'
			ELSE IF (@NivTenTer = N'B') SET @Resultado = N'B'
		END
	END

	IF (@Inv = 0)
	BEGIN
		IF (@Ordem = 1)
		BEGIN
			IF (@NivTenPri = N'A1') SET @Resultado = N'A1'
			ELSE IF (@NivTenPri = N'A2') SET @Resultado = N'A2'
			ELSE IF (@NivTenPri = N'A3') SET @Resultado = N'A3'
			ELSE IF (@NivTenPri = N'A3a') SET @Resultado = N'MT'
			ELSE IF (@NivTenPri = N'A4') SET @Resultado = N'MT'
			ELSE IF (@NivTenPri = N'B') SET @Resultado = N'B'
		END
		IF (@Ordem = 2)
		BEGIN
			IF (@NivTenSec = N'A1') SET @Resultado = N'A1'
			ELSE IF (@NivTenSec = N'A2') SET @Resultado = N'A2'
			ELSE IF (@NivTenSec = N'A3') SET @Resultado = N'A3'
			ELSE IF (@NivTenSec = N'A3a') SET @Resultado = N'MT'
			ELSE IF (@NivTenSec = N'A4') SET @Resultado = N'MT'
			ELSE IF (@NivTenSec = N'B') SET @Resultado = N'B'
		END
		IF (@Ordem = 3)
		BEGIN
			IF (@NivTenTer = N'A1') SET @Resultado = N'A1'
			ELSE IF (@NivTenTer = N'A2') SET @Resultado = N'A2'
			ELSE IF (@NivTenTer = N'A3') SET @Resultado = N'A3'
			ELSE IF (@NivTenTer = N'A3a') SET @Resultado = N'MT'
			ELSE IF (@NivTenTer = N'A4') SET @Resultado = N'MT'
			ELSE IF (@NivTenTer = N'B') SET @Resultado = N'B'
		END
	END

	-- Return the result of the function
	RETURN @Resultado

END









GO
/****** Object:  UserDefinedFunction [dbo].[NomeSegmentoTensaoBus]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[NomeSegmentoTensaoBus] 
(
	-- Add the parameters for the function here
	@TnsLnh_kV decimal (18,9)
)
RETURNS nvarchar(3)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Resultado nvarchar(3) = N'---'

	-- Add the T-SQL statements to compute the return value here
	IF (@TnsLnh_kV > 25) SET @Resultado = 'A3a'
	IF (@TnsLnh_kV <= 25 AND @TnsLnh_kV > 1) SET @Resultado = 'A4-'
	IF (@TnsLnh_kV <= 1) SET @Resultado = 'B--'

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[NumeroFases]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[NumeroFases]
(
	-- Add the parameters for the function here
	@Fase nvarchar(4)
)
RETURNS int
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado int = 1

	-- Add the T-SQL statements to compute the return value here
	IF (@Fase = 'ABCN' OR @Fase = 'ABC') SET @Resultado = 3
	IF (@Fase = 'ABN' OR @Fase = 'AB' OR @Fase = 'BCN' OR @Fase = 'BC' OR @Fase = 'CAN' OR @Fase = 'CA') SET @Resultado = 2
	IF (@Fase = 'AN' OR @Fase = 'A' OR @Fase = 'BN' OR @Fase = 'B' OR @Fase = 'CN' OR @Fase = 'C') SET @Resultado = 1

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[OrdemTensao]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[OrdemTensao] 
(
	-- Add the parameters for the function here
	@NivTen nvarchar(3)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Resultado int = null

	-- Add the T-SQL statements to compute the return value here
	IF (@NivTen = N'A1') SET @Resultado = 1
	IF (@NivTen = N'A2') SET @Resultado = 2
	IF (@NivTen = N'A3') SET @Resultado = 3
	IF (@NivTen = N'A3a') SET @Resultado = 4
	IF (@NivTen = N'A4') SET @Resultado = 5
	IF (@NivTen = N'B') SET @Resultado = 6

	-- Return the result of the function
	RETURN @Resultado

END








GO
/****** Object:  UserDefinedFunction [dbo].[QuantidadeDias]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[QuantidadeDias] 
(
	-- Add the parameters for the function here
	@Mes int,
	@Ano int,
	@Tipo nvarchar(2)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Resultado int = 0
	DECLARE @DataContagem date = '2015-1-1'
	DECLARE @DiaSemana int = 0
	Declare @Iniciomes int = 0

	-- Add the T-SQL statements to compute the return value here
	SET @DataContagem = str(@Ano) + '-' + str(@Mes) + '-' + str(@Iniciomes+1)
	WHILE (Month(@DataContagem) = @Mes AND Year(@DataContagem) = @Ano) 
	BEGIN

		SET @DiaSemana = datepart(weekday, @DataContagem)
		IF (@Tipo = 'DO' AND (@DiaSemana = 1 or dbo.EFeriado(@DataContagem) = 1)) SET @Resultado = @Resultado + 1
		IF (@Tipo = 'SA' AND (@DiaSemana = 7 AND dbo.EFeriado(@DataContagem) = 0)) SET @Resultado = @Resultado + 1
		IF (@Tipo = 'DU' AND (@DiaSemana <> 1 AND @DiaSemana <> 7 AND dbo.EFeriado(@DataContagem) = 0)) SET @Resultado = @Resultado + 1
		SET @DataContagem = DATEADD(day, 1, @DataContagem)

	END

	-- Return the result of the function
	RETURN @Resultado 

END








GO
/****** Object:  UserDefinedFunction [dbo].[TensaoFaseBaseTransformador]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[TensaoFaseBaseTransformador]
(
	-- Add the parameters for the function here
	@Var01 nvarchar(4),
	@Var02 int,
	@Var03 decimal(18,9)
)
RETURNS decimal(18,9)
AS
BEGIN

	-- Declare the return variable here
	DECLARE @Resultado decimal(18,9) = @Var03 / SQRT(3)

	-- Add the T-SQL statements to compute the return value here
	IF (@Var01 <> N'XX' OR @Var02 = 3) SET @Resultado = @Var03 / 2
	
	-- Return the result of the function
	RETURN @Resultado

END









GO
/****** Object:  UserDefinedFunction [sde].[archive_view_name]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [sde].[archive_view_name]
(@owner NVARCHAR(128), @table NVARCHAR(128))
RETURNS NVARCHAR(128)
AS BEGIN
DECLARE @view_name NVARCHAR(128)
SELECT @view_name = imv_view_name FROM sde.SDE_table_registry  WHERE owner = @owner AND table_name = @table AND 
(object_flags & 8) = 0 AND (object_flags & 262144) > 0 
RETURN @view_name
END

GO
/****** Object:  UserDefinedFunction [sde].[check_mv_release]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [sde].[check_mv_release] () RETURNS VARCHAR(20)
BEGIN
  RETURN 'DEFAULT 1.0'
END

GO
/****** Object:  UserDefinedFunction [sde].[geometry_column_type]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [sde].[geometry_column_type]
(@owner NVARCHAR(128), @table NVARCHAR(128), @column NVARCHAR(128))
RETURNS VARCHAR(128)
AS BEGIN
DECLARE @spatial_type VARCHAR(128)
SELECT @spatial_type = CAST (t.name AS VARCHAR(128)) 
  FROM sys.objects o INNER JOIN sys.columns c INNER JOIN sys.types t
  ON c.user_type_id = t.user_type_id AND c.user_type_id = t.user_type_id 
  ON c.object_id = o.object_id 
  WHERE c.object_id = OBJECT_ID(@owner + '.' + @table) AND c.name = @column

if (@spatial_type != 'geometry' AND @spatial_type != 'geography')
  set @spatial_type = NULL

RETURN @spatial_type
END

GO
/****** Object:  UserDefinedFunction [sde].[globalid_name]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [sde].[globalid_name]
(@owner NVARCHAR(128), @table NVARCHAR(128))
RETURNS VARCHAR(14)
AS BEGIN
-- check if the object is a multiversioned view
DECLARE @base_table NVARCHAR(128)
DECLARE @qualified_table NVARCHAR (200)
SET @qualified_table = db_name() + '.' + @owner + '.'

SELECT @base_table = table_name FROM sde.SDE_table_registry 
  WHERE owner = @owner AND imv_view_name = @table
IF @@ROWCOUNT = 0
  SET @qualified_table = @qualified_table + @table
ELSE
  SET @qualified_table = @qualified_table + @base_table

DECLARE @def VARCHAR(max)
DECLARE @properties int
SELECT @def = CAST (definition AS VARCHAR(max)), @properties = properties
  FROM sde.GDB_Items WHERE physicalname = @qualified_table
IF @@ROWCOUNT = 0
    RETURN 'NOT REGISTERED'
DECLARE @pos INT
DECLARE @pos2 INT
SET @pos = charindex ('<HasGlobalID>', @def)
SET @pos2 = charindex('</HasGlobalID>', @def, @pos)
IF @pos >= @pos2
    RETURN 'FALSE'
SET @pos = @pos + 13

DECLARE @str_val NVARCHAR(128)
SET @str_val = substring(@def,@pos,@pos2 - @pos)
IF @str_val = 'TRUE'
BEGIN
  SET @pos = charindex ('<GlobalIDFieldName>', @def)
  SET @pos2 = charindex('</GlobalIDFieldName>', @def, @pos)
  IF @pos >= @pos2
      RETURN NULL -- no global id in this table

  SET @pos = @pos + 19
  SET @str_val = substring(@def,@pos,@pos2 - @pos)
END
ELSE
  RETURN NULL
RETURN @str_val
END

GO
/****** Object:  UserDefinedFunction [sde].[is_archive_enabled]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [sde].[is_archive_enabled]
(@owner NVARCHAR(128), @table NVARCHAR(128))
RETURNS NVARCHAR(128)
AS BEGIN
DECLARE @oflags INTEGER
SELECT @oflags = object_flags FROM sde.SDE_table_registry  WHERE owner = @owner AND table_name = @table 
IF @@ROWCOUNT = 0
  RETURN 'NOT REGISTERED'
IF (@oflags & 262144) > 0 
  RETURN 'TRUE'
RETURN 'FALSE'
END

GO
/****** Object:  UserDefinedFunction [sde].[is_replicated]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [sde].[is_replicated]
(@owner NVARCHAR(128), @table NVARCHAR(128))
RETURNS VARCHAR(14)
AS BEGIN
-- check if the object is a multiversioned view
DECLARE @base_table NVARCHAR(128)
DECLARE @qualified_table NVARCHAR (200)
SET @qualified_table = db_name() + '.' + @owner + '.'

SELECT @base_table = table_name FROM sde.SDE_table_registry 
  WHERE owner = @owner AND imv_view_name = @table
IF @@ROWCOUNT = 0
  SET @qualified_table = @qualified_table + @table
ELSE
  SET @qualified_table = @qualified_table + @base_table

DECLARE @intval INT
SELECT TOP 1 @intval = 1 
FROM (SELECT UUID, Type FROM sde.GDB_Items
      WHERE PhysicalName = @qualified_table) objclass 
  INNER JOIN sde.GDB_Itemrelationships rel1
  ON rel1.destid = objclass.uuid
WHERE ((rel1.type = '{D022DE33-45BD-424C-88BF-5B1B6B957BD3}') OR
       (rel1.type = '{8DB31AF1-DF7C-4632-AA10-3CC44B0C6914}'))
IF @@ROWCOUNT = 0
  RETURN 'FALSE'
RETURN 'TRUE'
END

GO
/****** Object:  UserDefinedFunction [sde].[is_simple]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [sde].[is_simple](
@owner NVARCHAR(128), @table NVARCHAR(128))
RETURNS VARCHAR(14)
AS BEGIN
-- check if the object is a multiversioned view
DECLARE @base_table NVARCHAR(128)
DECLARE @qualified_table NVARCHAR (200)
DECLARE @is_reg INT
DECLARE @int_val INT

SET @qualified_table = db_name() + '.' + @owner + '.'

SELECT @base_table = table_name FROM sde.SDE_table_registry 
  WHERE owner = @owner AND imv_view_name = @table
IF @@ROWCOUNT = 0
  SET @qualified_table = @qualified_table + @table
ELSE
  SET @qualified_table = @qualified_table + @base_table

-- Check ArcSDE metadata first
SET @is_reg = 0
SELECT @is_reg = 1 FROM sde.SDE_table_registry WHERE owner = @owner AND table_name = @table

-- Get XML string from view. Return NOT REGISTERED when not found.
DECLARE @def VARCHAR(max)
DECLARE @datasetsubtype1 int
SELECT @def = CAST (definition AS VARCHAR(max)), @datasetsubtype1 = datasetsubtype1
  FROM sde.GDB_Items WHERE physicalname = @qualified_table
IF @@ROWCOUNT = 0
BEGIN
  IF @is_reg = 1
    RETURN 'TRUE'
  ELSE
      RETURN 'NOT REGISTERED'
END

IF @datasetsubtype1 != 1
  RETURN 'FALSE'

-- Check FeatureType for esriFTSimple. This check also 
-- covers checks for:
--
--   * Dimension feature classes
--   * Annotation eature classes
--   * Schematics, Locators, and Toolboxes

DECLARE @pos INT
DECLARE @pos2 INT
SET @pos = charindex('<FeatureType>',@def);
IF @pos > 0
BEGIN
  SET @pos2 = charindex('</FeatureType>', @def, @pos)
  SET @pos = @pos + 13
  IF substring(@def,@pos,@pos2 - @pos) != 'ESRIFTSIMPLE'
    RETURN 'FALSE'
END

SET @int_val = 0
SELECT @int_val = 1 FROM sde.GDB_Items a
  WHERE a.PhysicalName = @qualified_table and a.Type IN
    (SELECT b.UUID FROM sde.GDB_ItemTypes b WHERE b.Name in ('Feature Class','Feature Dataset','Table'))
IF @int_val != 1
  RETURN 'FALSE'

-- Check if the object participates in a	Parcel Fabric, Networkdataset,
-- Geometric Network, Terrain, Networkdataset, Topology or Relationship.

SET @int_val = 0
SELECT TOP 1 @int_val = 1
FROM (SELECT b.originid FROM sde.GDB_Items a INNER JOIN sde.GDB_ItemRelationships b
        ON a.uuid = b.destid WHERE a.physicalname = @qualified_table) objclass
  INNER JOIN sde.GDB_Items origin_items
    ON origin_items.uuid = objclass.originid
  INNER JOIN sde.GDB_ItemRelationships  rel1
    ON rel1.originid = origin_items.uuid
  INNER JOIN sde.GDB_ItemRelationships rel2
    ON rel2.destid = rel1.destid
WHERE origin_items.physicalname IS NOT NULL AND
  ((rel2.type = '{583A5BAA-3551-41AE-8AA8-1185719F3889}') OR 
   (rel2.type = '{DC739A70-9B71-41E8-868C-008CF46F16D7}') OR
   (rel2.type = '{55D2F4DC-CB17-4E32-A8C7-47591E8C71DE}') OR
   (rel2.type = '{B32B8563-0B96-4D32-92C4-086423AE9962}') OR
   (rel2.type = '{D088B110-190B-4229-BDF7-89FDDD14D1EA}') OR
   (rel2.type = '{725BADAB-3452-491B-A795-55F32D67229C}'))
IF @int_val = 1
  RETURN 'FALSE'

-- Check if Dataset has dependent objects that participate in a Parcel Fabric
-- Networkdataset, Geometric Network, Terrain, Networkdataset, Topology or Relationship.

SET @int_val = 0
SELECT TOP 1 @int_val = 1
FROM (SELECT rel2.uuid FROM (SELECT UUID, Type FROM sde.GDB_Items WHERE PhysicalName = @qualified_table) src_items
  INNER JOIN sde.GDB_Itemrelationships rel1 ON src_items.uuid = rel1.originid
  INNER JOIN sde.GDB_Itemrelationships rel2 ON rel2.originid = rel1.destid 
WHERE ((rel2.type = '{583A5BAA-3551-41AE-8AA8-1185719F3889}') OR
       (rel2.type = '{DC739A70-9B71-41E8-868C-008CF46F16D7}') OR
       (rel2.type = '{55D2F4DC-CB17-4E32-A8C7-47591E8C71DE}') OR
       (rel2.type = '{B32B8563-0B96-4D32-92C4-086423AE9962}') OR
       (rel2.type = '{D088B110-190B-4229-BDF7-89FDDD14D1EA}') OR
       (rel2.type = '{725BADAB-3452-491B-A795-55F32D67229C}')) ) expr
IF @int_val = 1
  RETURN 'FALSE'

-- Check if Object (No Dataset) has dependent objects that participate in a Parcel Fabric
-- Networkdataset, Geometric Network, Terrain, Networkdataset, Topology or Relationship.

SET @int_val = 0
SELECT TOP 1 @int_val = 1
FROM (SELECT rel1.type FROM (SELECT UUID, Type FROM sde.GDB_Items WHERE PhysicalName = @qualified_table) src_items
  INNER JOIN sde.GDB_Itemrelationships rel1 ON rel1.originid = src_items.uuid
  INNER JOIN sde.GDB_Itemrelationships rel2 ON rel2.destid = rel1.destid
WHERE ((rel2.type = '{583A5BAA-3551-41AE-8AA8-1185719F3889}') OR
       (rel2.type = '{DC739A70-9B71-41E8-868C-008CF46F16D7}') OR
       (rel2.type = '{55D2F4DC-CB17-4E32-A8C7-47591E8C71DE}') OR
       (rel2.type = '{B32B8563-0B96-4D32-92C4-086423AE9962}') OR
       (rel2.type = '{D088B110-190B-4229-BDF7-89FDDD14D1EA}') OR
       (rel2.type = '{725BADAB-3452-491B-A795-55F32D67229C}')) ) expr
IF @int_val = 1
  RETURN 'FALSE'

-- Check XML Definition
SET @pos = charindex ('<ControllerMemberships>', @def)
IF @pos = 0
  SET @pos = charindex ('<ControllerMemberships ', @def)
IF @pos > 0
BEGIN
  SET @pos = charindex ('<GeometricNetworkMembership>', @def)
  IF @pos > 0
    RETURN 'FALSE'

  SET @pos = charindex ('<TopologyMembership>', @def)
  IF @pos > 0
    RETURN 'FALSE'

  SET @pos = charindex ('<NetworkDatasetMembership>', @def)
  IF @pos > 0
    RETURN 'FALSE'

  SET @pos = charindex ('<NetworkDatasetName>', @def)
  IF @pos > 0
    RETURN 'FALSE'

  SET @pos = charindex ('<TerrainMembership>', @def)
  IF @pos = 0
    SET @pos = charindex ('<TerrainName>', @def)
  IF @pos > 0
    RETURN 'FALSE'
END

-- Check for Editor Tracking enabled.

SET @pos = charindex('<EditorTrackingEnabled>',@def);
IF @pos > 0
BEGIN
  SET @pos2 = charindex('</EditorTrackingEnabled>', @def, @pos)
  SET @pos = @pos + 23
  IF substring(@def,@pos,@pos2 - @pos) = 'TRUE'
    RETURN 'FALSE'
END

-- Check for Custom Class Extensions. 

SET @pos = charindex('<EXTCLSID>',@def);
IF @pos > 0
BEGIN
  SET @pos2 = charindex('</EXTCLSID>', @def, @pos)
  IF @pos2 != (@pos + 10)
    RETURN 'FALSE'
END

RETURN 'TRUE'
END

GO
/****** Object:  UserDefinedFunction [sde].[is_versioned]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [sde].[is_versioned]
(@owner NVARCHAR(128), @table NVARCHAR(128))
RETURNS VARCHAR(14)
AS BEGIN
-- check if the object is a multiversioned view
DECLARE @base_table NVARCHAR(128)
DECLARE @qualified_table NVARCHAR (200)
SET @qualified_table = db_name() + '.' + @owner + '.'

SELECT @base_table = table_name FROM sde.SDE_table_registry 
  WHERE owner = @owner AND imv_view_name = @table
IF @@ROWCOUNT = 0
  SET @qualified_table = @qualified_table + @table
ELSE
  SET @qualified_table = @qualified_table + @base_table

DECLARE @def VARCHAR(max)
DECLARE @properties int
SELECT @def = CAST (definition AS VARCHAR(max)), @properties = properties
  FROM sde.GDB_Items WHERE physicalname = @qualified_table
IF @@ROWCOUNT = 0
    RETURN 'NOT REGISTERED'
DECLARE @pos INT
DECLARE @pos2 INT
SET @pos = charindex ('<Versioned>', @def)
SET @pos2 = charindex('</Versioned>', @def, @pos)
IF @pos >= @pos2
    RETURN 'FALSE'
SET @pos = @pos + 11

DECLARE @is_versioned VARCHAR(5)
SET @is_versioned = substring(@def,@pos,@pos2 - @pos)
RETURN UPPER(@is_versioned)
END

GO
/****** Object:  UserDefinedFunction [sde].[retrieve_guid]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [sde].[retrieve_guid] () RETURNS NVARCHAR(38)
BEGIN
  RETURN(SELECT guidstr from sde.SDE_generate_guid )
END
GO
/****** Object:  UserDefinedFunction [sde].[rowid_name]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [sde].[rowid_name](
@owner NVARCHAR(128), @table NVARCHAR(128))
RETURNS NVARCHAR(128)
AS BEGIN
-- check if the object is a multiversioned view
DECLARE @base_table NVARCHAR(128)
DECLARE @qualified_table NVARCHAR (200)
SET @qualified_table = db_name() + '.' + @owner + '.'

SELECT @base_table = table_name FROM sde.SDE_table_registry 
  WHERE owner = @owner AND imv_view_name = @table
IF @@ROWCOUNT = 0
  SET @qualified_table = @qualified_table + @table
ELSE
  SET @qualified_table = @qualified_table + @base_table

DECLARE @def VARCHAR(max)
DECLARE @properties int
SELECT @def = CAST (definition AS VARCHAR(max)), @properties = properties
  FROM sde.GDB_Items WHERE physicalname = @qualified_table
IF @@ROWCOUNT = 0
    RETURN NULL -- layer not found, but can't raise errors in a function!

DECLARE @pos INT
DECLARE @pos2 INT
SET @pos = charindex ('<OIDFieldName>', @def)
SET @pos2 = charindex('</OIDFieldName>', @def, @pos)
IF @pos >= @pos2
    RETURN NULL -- no rowid column in this table

SET @pos = @pos + 14

DECLARE @rowid_name NVARCHAR(128)
SET @rowid_name = substring(@def,@pos,@pos2 - @pos)
RETURN @rowid_name
END

GO
/****** Object:  UserDefinedFunction [sde].[SDE_get_cad_table_name]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [sde].[SDE_get_cad_table_name]
(@owner NVARCHAR(128),@table NVARCHAR(128),@spatial_column NVARCHAR(128))
RETURNS NVARCHAR(128)
AS BEGIN
DECLARE @layer_id INTEGER
DECLARE @qualified_table NVARCHAR(200)
DECLARE @cad_mask BIGINT
DECLARE @layer_eflags INTEGER
/* set SE_CAD_TYPE_MASK defined sdecomn.h */
SELECT @cad_mask = 1 * POWER(2,22)
SET @qualified_table = db_name() + '.' + @owner + '.SDE_GEOMETRY'
SELECT @layer_id = layer_id, @layer_eflags = eflags FROM sde.SDE_layers
 WHERE owner = @owner AND table_name = @table AND spatial_column = @spatial_column
IF @@ROWCOUNT = 0
  SET @qualified_table =  NULL
ELSE
BEGIN
  IF @layer_eflags & @cad_mask = @cad_mask
    SET @qualified_table = @qualified_table + CONVERT(NVARCHAR(10),@layer_id)
  ELSE
    SET @qualified_table =  NULL
END
RETURN @qualified_table
END

GO
/****** Object:  UserDefinedFunction [sde].[SDE_get_version_access]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [sde].[SDE_get_version_access] (
@status INTEGER,
@version_owner NVARCHAR (128)) 
RETURNS CHAR(1) 
BEGIN
--This is a private support function for SDE versioned views.

-- Get the current login & user name
DECLARE @user      NVARCHAR (128)
DECLARE @protected CHAR (1)
DECLARE @is_dba INTEGER
DECLARE @delimiter INTEGER
SELECT @user = user_name()
SET @delimiter = PATINDEX('"%', @version_owner)
IF @delimiter > 0
BEGIN
 SET @user = N'"' + user_name() + N'"' 
END
SET @is_dba = sde.SDE_is_user_sde_dba ()
SET @status = @status - floor (@status / 4) * 4
IF @status = 0 -- private version
BEGIN
  IF ((@is_dba = 0) AND (@user <> @version_owner))
    SET @protected = '2' -- no permission
  ELSE
    SET @protected = '0'; -- full permission
END
ELSE IF @status = 2 -- protected version
BEGIN
  IF ((@is_dba = 0) AND (@user <> @version_owner))
    SET @protected = '1' -- read only permission
  ELSE
    SET @protected = '0' -- full permission
END
ELSE
  SET @protected = '0' -- must be a public version
RETURN @protected
END

GO
/****** Object:  UserDefinedFunction [sde].[SDE_get_view_state]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [sde].[SDE_get_view_state] () RETURNS BIGINT
BEGIN
--This is a private support function for SDE versioned views.
DECLARE @state_id BIGINT
DECLARE @context_info VARCHAR(128)
SELECT @context_info = CAST (context_info AS VARCHAR(128))
FROM sys.dm_exec_sessions
WHERE session_id = @@SPID AND CAST (context_info AS VARCHAR(128)) like 'SDE%'
IF @context_info IS NULL
  SET @state_id = -1  -- version has not been set.
ELSE
BEGIN
  DECLARE @delimiter INTEGER
  SET @delimiter = charindex (',', @context_info)
  IF @delimiter = 0
    SET @state_id = -1  -- version has not been set.
  ELSE
  BEGIN
    DECLARE @next_delimiter INTEGER
    SET @next_delimiter = charindex (',', @context_info, @delimiter + 1)
    SET @context_info = substring (@context_info, @delimiter + 1,
        @next_delimiter - @delimiter - 1)
    SET @state_id = CAST (@context_info as bigint)
  END
END
IF @state_id < 0
  -- Set to default version's state id
  SELECT @state_id = state_id FROM sde.SDE_versions
    WHERE name = 'DEFAULT' AND owner = 'sde'
RETURN @state_id
END

GO
/****** Object:  UserDefinedFunction [sde].[SDE_is_user_sde_dba]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [sde].[SDE_is_user_sde_dba] () RETURNS INTEGER
BEGIN
  --This is a private support function for SDE versioned views.
  DECLARE @user  NVARCHAR (128)
  DECLARE @is_dba INTEGER

  SELECT @user = user_name()
  IF ((@user <> 'sde') AND (IS_SRVROLEMEMBER ('sysadmin') <> 1)) 
  BEGIN
    IF (IS_MEMBER('db_owner') <> 1) 
      SET @is_dba = 0 -- is not dba
    ELSE
      SET @is_dba = 1 -- is dba
  END
  ELSE
    SET @is_dba = 1 -- is dba

  RETURN @is_dba
END

GO
/****** Object:  UserDefinedFunction [sde].[version_view_name]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [sde].[version_view_name]
(@owner NVARCHAR(128), @table NVARCHAR(128))
RETURNS NVARCHAR(128)
AS BEGIN
DECLARE @view_name NVARCHAR(128)
SELECT @view_name = imv_view_name FROM sde.SDE_table_registry  WHERE owner = @owner AND table_name = @table AND 
(object_flags & 8) > 0
RETURN @view_name
END

GO
/****** Object:  Table [dbo].[StoredCrvCrgBT]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoredCrvCrgBT](
	[CodBase] [int] NOT NULL,
	[CodCrvCrg] [nvarchar](100) NOT NULL,
	[TipoDia] [nvarchar](2) NOT NULL,
	[PotAtv01_kW] [decimal](18, 9) NULL,
	[PotAtv02_kW] [decimal](18, 9) NULL,
	[PotAtv03_kW] [decimal](18, 9) NULL,
	[PotAtv04_kW] [decimal](18, 9) NULL,
	[PotAtv05_kW] [decimal](18, 9) NULL,
	[PotAtv06_kW] [decimal](18, 9) NULL,
	[PotAtv07_kW] [decimal](18, 9) NULL,
	[PotAtv08_kW] [decimal](18, 9) NULL,
	[PotAtv09_kW] [decimal](18, 9) NULL,
	[PotAtv10_kW] [decimal](18, 9) NULL,
	[PotAtv11_kW] [decimal](18, 9) NULL,
	[PotAtv12_kW] [decimal](18, 9) NULL,
	[PotAtv13_kW] [decimal](18, 9) NULL,
	[PotAtv14_kW] [decimal](18, 9) NULL,
	[PotAtv15_kW] [decimal](18, 9) NULL,
	[PotAtv16_kW] [decimal](18, 9) NULL,
	[PotAtv17_kW] [decimal](18, 9) NULL,
	[PotAtv18_kW] [decimal](18, 9) NULL,
	[PotAtv19_kW] [decimal](18, 9) NULL,
	[PotAtv20_kW] [decimal](18, 9) NULL,
	[PotAtv21_kW] [decimal](18, 9) NULL,
	[PotAtv22_kW] [decimal](18, 9) NULL,
	[PotAtv23_kW] [decimal](18, 9) NULL,
	[PotAtv24_kW] [decimal](18, 9) NULL,
	[PotAtv25_kW] [decimal](18, 9) NULL,
	[PotAtv26_kW] [decimal](18, 9) NULL,
	[PotAtv27_kW] [decimal](18, 9) NULL,
	[PotAtv28_kW] [decimal](18, 9) NULL,
	[PotAtv29_kW] [decimal](18, 9) NULL,
	[PotAtv30_kW] [decimal](18, 9) NULL,
	[PotAtv31_kW] [decimal](18, 9) NULL,
	[PotAtv32_kW] [decimal](18, 9) NULL,
	[PotAtv33_kW] [decimal](18, 9) NULL,
	[PotAtv34_kW] [decimal](18, 9) NULL,
	[PotAtv35_kW] [decimal](18, 9) NULL,
	[PotAtv36_kW] [decimal](18, 9) NULL,
	[PotAtv37_kW] [decimal](18, 9) NULL,
	[PotAtv38_kW] [decimal](18, 9) NULL,
	[PotAtv39_kW] [decimal](18, 9) NULL,
	[PotAtv40_kW] [decimal](18, 9) NULL,
	[PotAtv41_kW] [decimal](18, 9) NULL,
	[PotAtv42_kW] [decimal](18, 9) NULL,
	[PotAtv43_kW] [decimal](18, 9) NULL,
	[PotAtv44_kW] [decimal](18, 9) NULL,
	[PotAtv45_kW] [decimal](18, 9) NULL,
	[PotAtv46_kW] [decimal](18, 9) NULL,
	[PotAtv47_kW] [decimal](18, 9) NULL,
	[PotAtv48_kW] [decimal](18, 9) NULL,
	[PotAtv49_kW] [decimal](18, 9) NULL,
	[PotAtv50_kW] [decimal](18, 9) NULL,
	[PotAtv51_kW] [decimal](18, 9) NULL,
	[PotAtv52_kW] [decimal](18, 9) NULL,
	[PotAtv53_kW] [decimal](18, 9) NULL,
	[PotAtv54_kW] [decimal](18, 9) NULL,
	[PotAtv55_kW] [decimal](18, 9) NULL,
	[PotAtv56_kW] [decimal](18, 9) NULL,
	[PotAtv57_kW] [decimal](18, 9) NULL,
	[PotAtv58_kW] [decimal](18, 9) NULL,
	[PotAtv59_kW] [decimal](18, 9) NULL,
	[PotAtv60_kW] [decimal](18, 9) NULL,
	[PotAtv61_kW] [decimal](18, 9) NULL,
	[PotAtv62_kW] [decimal](18, 9) NULL,
	[PotAtv63_kW] [decimal](18, 9) NULL,
	[PotAtv64_kW] [decimal](18, 9) NULL,
	[PotAtv65_kW] [decimal](18, 9) NULL,
	[PotAtv66_kW] [decimal](18, 9) NULL,
	[PotAtv67_kW] [decimal](18, 9) NULL,
	[PotAtv68_kW] [decimal](18, 9) NULL,
	[PotAtv69_kW] [decimal](18, 9) NULL,
	[PotAtv70_kW] [decimal](18, 9) NULL,
	[PotAtv71_kW] [decimal](18, 9) NULL,
	[PotAtv72_kW] [decimal](18, 9) NULL,
	[PotAtv73_kW] [decimal](18, 9) NULL,
	[PotAtv74_kW] [decimal](18, 9) NULL,
	[PotAtv75_kW] [decimal](18, 9) NULL,
	[PotAtv76_kW] [decimal](18, 9) NULL,
	[PotAtv77_kW] [decimal](18, 9) NULL,
	[PotAtv78_kW] [decimal](18, 9) NULL,
	[PotAtv79_kW] [decimal](18, 9) NULL,
	[PotAtv80_kW] [decimal](18, 9) NULL,
	[PotAtv81_kW] [decimal](18, 9) NULL,
	[PotAtv82_kW] [decimal](18, 9) NULL,
	[PotAtv83_kW] [decimal](18, 9) NULL,
	[PotAtv84_kW] [decimal](18, 9) NULL,
	[PotAtv85_kW] [decimal](18, 9) NULL,
	[PotAtv86_kW] [decimal](18, 9) NULL,
	[PotAtv87_kW] [decimal](18, 9) NULL,
	[PotAtv88_kW] [decimal](18, 9) NULL,
	[PotAtv89_kW] [decimal](18, 9) NULL,
	[PotAtv90_kW] [decimal](18, 9) NULL,
	[PotAtv91_kW] [decimal](18, 9) NULL,
	[PotAtv92_kW] [decimal](18, 9) NULL,
	[PotAtv93_kW] [decimal](18, 9) NULL,
	[PotAtv94_kW] [decimal](18, 9) NULL,
	[PotAtv95_kW] [decimal](18, 9) NULL,
	[PotAtv96_kW] [decimal](18, 9) NULL,
	[Descr] [text] NULL,
	[DATA_BASE] [datetime2](7) NULL,
 CONSTRAINT [PK_StoredCrvCrgBT] PRIMARY KEY CLUSTERED 
(
	[CodBase] ASC,
	[CodCrvCrg] ASC,
	[TipoDia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StoredCrvCrgMT]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoredCrvCrgMT](
	[CodBase] [int] NOT NULL,
	[CodCrvCrg] [nvarchar](100) NOT NULL,
	[TipoDia] [nvarchar](2) NOT NULL,
	[PotAtv01_kW] [decimal](18, 9) NULL,
	[PotAtv02_kW] [decimal](18, 9) NULL,
	[PotAtv03_kW] [decimal](18, 9) NULL,
	[PotAtv04_kW] [decimal](18, 9) NULL,
	[PotAtv05_kW] [decimal](18, 9) NULL,
	[PotAtv06_kW] [decimal](18, 9) NULL,
	[PotAtv07_kW] [decimal](18, 9) NULL,
	[PotAtv08_kW] [decimal](18, 9) NULL,
	[PotAtv09_kW] [decimal](18, 9) NULL,
	[PotAtv10_kW] [decimal](18, 9) NULL,
	[PotAtv11_kW] [decimal](18, 9) NULL,
	[PotAtv12_kW] [decimal](18, 9) NULL,
	[PotAtv13_kW] [decimal](18, 9) NULL,
	[PotAtv14_kW] [decimal](18, 9) NULL,
	[PotAtv15_kW] [decimal](18, 9) NULL,
	[PotAtv16_kW] [decimal](18, 9) NULL,
	[PotAtv17_kW] [decimal](18, 9) NULL,
	[PotAtv18_kW] [decimal](18, 9) NULL,
	[PotAtv19_kW] [decimal](18, 9) NULL,
	[PotAtv20_kW] [decimal](18, 9) NULL,
	[PotAtv21_kW] [decimal](18, 9) NULL,
	[PotAtv22_kW] [decimal](18, 9) NULL,
	[PotAtv23_kW] [decimal](18, 9) NULL,
	[PotAtv24_kW] [decimal](18, 9) NULL,
	[PotAtv25_kW] [decimal](18, 9) NULL,
	[PotAtv26_kW] [decimal](18, 9) NULL,
	[PotAtv27_kW] [decimal](18, 9) NULL,
	[PotAtv28_kW] [decimal](18, 9) NULL,
	[PotAtv29_kW] [decimal](18, 9) NULL,
	[PotAtv30_kW] [decimal](18, 9) NULL,
	[PotAtv31_kW] [decimal](18, 9) NULL,
	[PotAtv32_kW] [decimal](18, 9) NULL,
	[PotAtv33_kW] [decimal](18, 9) NULL,
	[PotAtv34_kW] [decimal](18, 9) NULL,
	[PotAtv35_kW] [decimal](18, 9) NULL,
	[PotAtv36_kW] [decimal](18, 9) NULL,
	[PotAtv37_kW] [decimal](18, 9) NULL,
	[PotAtv38_kW] [decimal](18, 9) NULL,
	[PotAtv39_kW] [decimal](18, 9) NULL,
	[PotAtv40_kW] [decimal](18, 9) NULL,
	[PotAtv41_kW] [decimal](18, 9) NULL,
	[PotAtv42_kW] [decimal](18, 9) NULL,
	[PotAtv43_kW] [decimal](18, 9) NULL,
	[PotAtv44_kW] [decimal](18, 9) NULL,
	[PotAtv45_kW] [decimal](18, 9) NULL,
	[PotAtv46_kW] [decimal](18, 9) NULL,
	[PotAtv47_kW] [decimal](18, 9) NULL,
	[PotAtv48_kW] [decimal](18, 9) NULL,
	[PotAtv49_kW] [decimal](18, 9) NULL,
	[PotAtv50_kW] [decimal](18, 9) NULL,
	[PotAtv51_kW] [decimal](18, 9) NULL,
	[PotAtv52_kW] [decimal](18, 9) NULL,
	[PotAtv53_kW] [decimal](18, 9) NULL,
	[PotAtv54_kW] [decimal](18, 9) NULL,
	[PotAtv55_kW] [decimal](18, 9) NULL,
	[PotAtv56_kW] [decimal](18, 9) NULL,
	[PotAtv57_kW] [decimal](18, 9) NULL,
	[PotAtv58_kW] [decimal](18, 9) NULL,
	[PotAtv59_kW] [decimal](18, 9) NULL,
	[PotAtv60_kW] [decimal](18, 9) NULL,
	[PotAtv61_kW] [decimal](18, 9) NULL,
	[PotAtv62_kW] [decimal](18, 9) NULL,
	[PotAtv63_kW] [decimal](18, 9) NULL,
	[PotAtv64_kW] [decimal](18, 9) NULL,
	[PotAtv65_kW] [decimal](18, 9) NULL,
	[PotAtv66_kW] [decimal](18, 9) NULL,
	[PotAtv67_kW] [decimal](18, 9) NULL,
	[PotAtv68_kW] [decimal](18, 9) NULL,
	[PotAtv69_kW] [decimal](18, 9) NULL,
	[PotAtv70_kW] [decimal](18, 9) NULL,
	[PotAtv71_kW] [decimal](18, 9) NULL,
	[PotAtv72_kW] [decimal](18, 9) NULL,
	[PotAtv73_kW] [decimal](18, 9) NULL,
	[PotAtv74_kW] [decimal](18, 9) NULL,
	[PotAtv75_kW] [decimal](18, 9) NULL,
	[PotAtv76_kW] [decimal](18, 9) NULL,
	[PotAtv77_kW] [decimal](18, 9) NULL,
	[PotAtv78_kW] [decimal](18, 9) NULL,
	[PotAtv79_kW] [decimal](18, 9) NULL,
	[PotAtv80_kW] [decimal](18, 9) NULL,
	[PotAtv81_kW] [decimal](18, 9) NULL,
	[PotAtv82_kW] [decimal](18, 9) NULL,
	[PotAtv83_kW] [decimal](18, 9) NULL,
	[PotAtv84_kW] [decimal](18, 9) NULL,
	[PotAtv85_kW] [decimal](18, 9) NULL,
	[PotAtv86_kW] [decimal](18, 9) NULL,
	[PotAtv87_kW] [decimal](18, 9) NULL,
	[PotAtv88_kW] [decimal](18, 9) NULL,
	[PotAtv89_kW] [decimal](18, 9) NULL,
	[PotAtv90_kW] [decimal](18, 9) NULL,
	[PotAtv91_kW] [decimal](18, 9) NULL,
	[PotAtv92_kW] [decimal](18, 9) NULL,
	[PotAtv93_kW] [decimal](18, 9) NULL,
	[PotAtv94_kW] [decimal](18, 9) NULL,
	[PotAtv95_kW] [decimal](18, 9) NULL,
	[PotAtv96_kW] [decimal](18, 9) NULL,
	[Descr] [text] NULL,
	[DATA_BASE] [datetime2](7) NULL,
 CONSTRAINT [PK_StoredCrvCrgMT] PRIMARY KEY CLUSTERED 
(
	[CodBase] ASC,
	[CodCrvCrg] ASC,
	[TipoDia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StoredCrvCrgTrafoATATATMT]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoredCrvCrgTrafoATATATMT](
	[CodBase] [int] NOT NULL,
	[CodTrafo] [nvarchar](100) NOT NULL,
	[Dia] [nvarchar](2) NOT NULL,
	[Intervalo] [int] NOT NULL,
	[PotAtv_MW] [decimal](18, 9) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StoredCrvGeraBT]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoredCrvGeraBT](
	[CodBase] [bigint] NOT NULL,
	[CodCrvGera] [nvarchar](100) NOT NULL,
	[TipoDia] [nvarchar](2) NOT NULL,
	[PotAtv01_kW] [decimal](18, 9) NULL,
	[PotAtv02_kW] [decimal](18, 9) NULL,
	[PotAtv03_kW] [decimal](18, 9) NULL,
	[PotAtv04_kW] [decimal](18, 9) NULL,
	[PotAtv05_kW] [decimal](18, 9) NULL,
	[PotAtv06_kW] [decimal](18, 9) NULL,
	[PotAtv07_kW] [decimal](18, 9) NULL,
	[PotAtv08_kW] [decimal](18, 9) NULL,
	[PotAtv09_kW] [decimal](18, 9) NULL,
	[PotAtv10_kW] [decimal](18, 9) NULL,
	[PotAtv11_kW] [decimal](18, 9) NULL,
	[PotAtv12_kW] [decimal](18, 9) NULL,
	[PotAtv13_kW] [decimal](18, 9) NULL,
	[PotAtv14_kW] [decimal](18, 9) NULL,
	[PotAtv15_kW] [decimal](18, 9) NULL,
	[PotAtv16_kW] [decimal](18, 9) NULL,
	[PotAtv17_kW] [decimal](18, 9) NULL,
	[PotAtv18_kW] [decimal](18, 9) NULL,
	[PotAtv19_kW] [decimal](18, 9) NULL,
	[PotAtv20_kW] [decimal](18, 9) NULL,
	[PotAtv21_kW] [decimal](18, 9) NULL,
	[PotAtv22_kW] [decimal](18, 9) NULL,
	[PotAtv23_kW] [decimal](18, 9) NULL,
	[PotAtv24_kW] [decimal](18, 9) NULL,
	[PotAtv25_kW] [decimal](18, 9) NULL,
	[PotAtv26_kW] [decimal](18, 9) NULL,
	[PotAtv27_kW] [decimal](18, 9) NULL,
	[PotAtv28_kW] [decimal](18, 9) NULL,
	[PotAtv29_kW] [decimal](18, 9) NULL,
	[PotAtv30_kW] [decimal](18, 9) NULL,
	[PotAtv31_kW] [decimal](18, 9) NULL,
	[PotAtv32_kW] [decimal](18, 9) NULL,
	[PotAtv33_kW] [decimal](18, 9) NULL,
	[PotAtv34_kW] [decimal](18, 9) NULL,
	[PotAtv35_kW] [decimal](18, 9) NULL,
	[PotAtv36_kW] [decimal](18, 9) NULL,
	[PotAtv37_kW] [decimal](18, 9) NULL,
	[PotAtv38_kW] [decimal](18, 9) NULL,
	[PotAtv39_kW] [decimal](18, 9) NULL,
	[PotAtv40_kW] [decimal](18, 9) NULL,
	[PotAtv41_kW] [decimal](18, 9) NULL,
	[PotAtv42_kW] [decimal](18, 9) NULL,
	[PotAtv43_kW] [decimal](18, 9) NULL,
	[PotAtv44_kW] [decimal](18, 9) NULL,
	[PotAtv45_kW] [decimal](18, 9) NULL,
	[PotAtv46_kW] [decimal](18, 9) NULL,
	[PotAtv47_kW] [decimal](18, 9) NULL,
	[PotAtv48_kW] [decimal](18, 9) NULL,
	[PotAtv49_kW] [decimal](18, 9) NULL,
	[PotAtv50_kW] [decimal](18, 9) NULL,
	[PotAtv51_kW] [decimal](18, 9) NULL,
	[PotAtv52_kW] [decimal](18, 9) NULL,
	[PotAtv53_kW] [decimal](18, 9) NULL,
	[PotAtv54_kW] [decimal](18, 9) NULL,
	[PotAtv55_kW] [decimal](18, 9) NULL,
	[PotAtv56_kW] [decimal](18, 9) NULL,
	[PotAtv57_kW] [decimal](18, 9) NULL,
	[PotAtv58_kW] [decimal](18, 9) NULL,
	[PotAtv59_kW] [decimal](18, 9) NULL,
	[PotAtv60_kW] [decimal](18, 9) NULL,
	[PotAtv61_kW] [decimal](18, 9) NULL,
	[PotAtv62_kW] [decimal](18, 9) NULL,
	[PotAtv63_kW] [decimal](18, 9) NULL,
	[PotAtv64_kW] [decimal](18, 9) NULL,
	[PotAtv65_kW] [decimal](18, 9) NULL,
	[PotAtv66_kW] [decimal](18, 9) NULL,
	[PotAtv67_kW] [decimal](18, 9) NULL,
	[PotAtv68_kW] [decimal](18, 9) NULL,
	[PotAtv69_kW] [decimal](18, 9) NULL,
	[PotAtv70_kW] [decimal](18, 9) NULL,
	[PotAtv71_kW] [decimal](18, 9) NULL,
	[PotAtv72_kW] [decimal](18, 9) NULL,
	[PotAtv73_kW] [decimal](18, 9) NULL,
	[PotAtv74_kW] [decimal](18, 9) NULL,
	[PotAtv75_kW] [decimal](18, 9) NULL,
	[PotAtv76_kW] [decimal](18, 9) NULL,
	[PotAtv77_kW] [decimal](18, 9) NULL,
	[PotAtv78_kW] [decimal](18, 9) NULL,
	[PotAtv79_kW] [decimal](18, 9) NULL,
	[PotAtv80_kW] [decimal](18, 9) NULL,
	[PotAtv81_kW] [decimal](18, 9) NULL,
	[PotAtv82_kW] [decimal](18, 9) NULL,
	[PotAtv83_kW] [decimal](18, 9) NULL,
	[PotAtv84_kW] [decimal](18, 9) NULL,
	[PotAtv85_kW] [decimal](18, 9) NULL,
	[PotAtv86_kW] [decimal](18, 9) NULL,
	[PotAtv87_kW] [decimal](18, 9) NULL,
	[PotAtv88_kW] [decimal](18, 9) NULL,
	[PotAtv89_kW] [decimal](18, 9) NULL,
	[PotAtv90_kW] [decimal](18, 9) NULL,
	[PotAtv91_kW] [decimal](18, 9) NULL,
	[PotAtv92_kW] [decimal](18, 9) NULL,
	[PotAtv93_kW] [decimal](18, 9) NULL,
	[PotAtv94_kW] [decimal](18, 9) NULL,
	[PotAtv95_kW] [decimal](18, 9) NULL,
	[PotAtv96_kW] [decimal](18, 9) NULL,
	[Descr] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StoredCrvGeraMT]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoredCrvGeraMT](
	[CodBase] [bigint] NOT NULL,
	[CodCrvGera] [nvarchar](100) NOT NULL,
	[TipoDia] [nvarchar](2) NOT NULL,
	[PotAtv01_kW] [decimal](18, 9) NULL,
	[PotAtv02_kW] [decimal](18, 9) NULL,
	[PotAtv03_kW] [decimal](18, 9) NULL,
	[PotAtv04_kW] [decimal](18, 9) NULL,
	[PotAtv05_kW] [decimal](18, 9) NULL,
	[PotAtv06_kW] [decimal](18, 9) NULL,
	[PotAtv07_kW] [decimal](18, 9) NULL,
	[PotAtv08_kW] [decimal](18, 9) NULL,
	[PotAtv09_kW] [decimal](18, 9) NULL,
	[PotAtv10_kW] [decimal](18, 9) NULL,
	[PotAtv11_kW] [decimal](18, 9) NULL,
	[PotAtv12_kW] [decimal](18, 9) NULL,
	[PotAtv13_kW] [decimal](18, 9) NULL,
	[PotAtv14_kW] [decimal](18, 9) NULL,
	[PotAtv15_kW] [decimal](18, 9) NULL,
	[PotAtv16_kW] [decimal](18, 9) NULL,
	[PotAtv17_kW] [decimal](18, 9) NULL,
	[PotAtv18_kW] [decimal](18, 9) NULL,
	[PotAtv19_kW] [decimal](18, 9) NULL,
	[PotAtv20_kW] [decimal](18, 9) NULL,
	[PotAtv21_kW] [decimal](18, 9) NULL,
	[PotAtv22_kW] [decimal](18, 9) NULL,
	[PotAtv23_kW] [decimal](18, 9) NULL,
	[PotAtv24_kW] [decimal](18, 9) NULL,
	[PotAtv25_kW] [decimal](18, 9) NULL,
	[PotAtv26_kW] [decimal](18, 9) NULL,
	[PotAtv27_kW] [decimal](18, 9) NULL,
	[PotAtv28_kW] [decimal](18, 9) NULL,
	[PotAtv29_kW] [decimal](18, 9) NULL,
	[PotAtv30_kW] [decimal](18, 9) NULL,
	[PotAtv31_kW] [decimal](18, 9) NULL,
	[PotAtv32_kW] [decimal](18, 9) NULL,
	[PotAtv33_kW] [decimal](18, 9) NULL,
	[PotAtv34_kW] [decimal](18, 9) NULL,
	[PotAtv35_kW] [decimal](18, 9) NULL,
	[PotAtv36_kW] [decimal](18, 9) NULL,
	[PotAtv37_kW] [decimal](18, 9) NULL,
	[PotAtv38_kW] [decimal](18, 9) NULL,
	[PotAtv39_kW] [decimal](18, 9) NULL,
	[PotAtv40_kW] [decimal](18, 9) NULL,
	[PotAtv41_kW] [decimal](18, 9) NULL,
	[PotAtv42_kW] [decimal](18, 9) NULL,
	[PotAtv43_kW] [decimal](18, 9) NULL,
	[PotAtv44_kW] [decimal](18, 9) NULL,
	[PotAtv45_kW] [decimal](18, 9) NULL,
	[PotAtv46_kW] [decimal](18, 9) NULL,
	[PotAtv47_kW] [decimal](18, 9) NULL,
	[PotAtv48_kW] [decimal](18, 9) NULL,
	[PotAtv49_kW] [decimal](18, 9) NULL,
	[PotAtv50_kW] [decimal](18, 9) NULL,
	[PotAtv51_kW] [decimal](18, 9) NULL,
	[PotAtv52_kW] [decimal](18, 9) NULL,
	[PotAtv53_kW] [decimal](18, 9) NULL,
	[PotAtv54_kW] [decimal](18, 9) NULL,
	[PotAtv55_kW] [decimal](18, 9) NULL,
	[PotAtv56_kW] [decimal](18, 9) NULL,
	[PotAtv57_kW] [decimal](18, 9) NULL,
	[PotAtv58_kW] [decimal](18, 9) NULL,
	[PotAtv59_kW] [decimal](18, 9) NULL,
	[PotAtv60_kW] [decimal](18, 9) NULL,
	[PotAtv61_kW] [decimal](18, 9) NULL,
	[PotAtv62_kW] [decimal](18, 9) NULL,
	[PotAtv63_kW] [decimal](18, 9) NULL,
	[PotAtv64_kW] [decimal](18, 9) NULL,
	[PotAtv65_kW] [decimal](18, 9) NULL,
	[PotAtv66_kW] [decimal](18, 9) NULL,
	[PotAtv67_kW] [decimal](18, 9) NULL,
	[PotAtv68_kW] [decimal](18, 9) NULL,
	[PotAtv69_kW] [decimal](18, 9) NULL,
	[PotAtv70_kW] [decimal](18, 9) NULL,
	[PotAtv71_kW] [decimal](18, 9) NULL,
	[PotAtv72_kW] [decimal](18, 9) NULL,
	[PotAtv73_kW] [decimal](18, 9) NULL,
	[PotAtv74_kW] [decimal](18, 9) NULL,
	[PotAtv75_kW] [decimal](18, 9) NULL,
	[PotAtv76_kW] [decimal](18, 9) NULL,
	[PotAtv77_kW] [decimal](18, 9) NULL,
	[PotAtv78_kW] [decimal](18, 9) NULL,
	[PotAtv79_kW] [decimal](18, 9) NULL,
	[PotAtv80_kW] [decimal](18, 9) NULL,
	[PotAtv81_kW] [decimal](18, 9) NULL,
	[PotAtv82_kW] [decimal](18, 9) NULL,
	[PotAtv83_kW] [decimal](18, 9) NULL,
	[PotAtv84_kW] [decimal](18, 9) NULL,
	[PotAtv85_kW] [decimal](18, 9) NULL,
	[PotAtv86_kW] [decimal](18, 9) NULL,
	[PotAtv87_kW] [decimal](18, 9) NULL,
	[PotAtv88_kW] [decimal](18, 9) NULL,
	[PotAtv89_kW] [decimal](18, 9) NULL,
	[PotAtv90_kW] [decimal](18, 9) NULL,
	[PotAtv91_kW] [decimal](18, 9) NULL,
	[PotAtv92_kW] [decimal](18, 9) NULL,
	[PotAtv93_kW] [decimal](18, 9) NULL,
	[PotAtv94_kW] [decimal](18, 9) NULL,
	[PotAtv95_kW] [decimal](18, 9) NULL,
	[PotAtv96_kW] [decimal](18, 9) NULL,
	[Descr] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [sde].[ARAT]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[ARAT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](25) NULL,
	[DIST] [int] NULL,
	[FUN_PR] [int] NULL,
	[FUN_TE] [int] NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[Shape_STArea__] [numeric](38, 8) NOT NULL,
	[Shape_STLength__] [numeric](38, 8) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[BAR]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[BAR](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[TEN_NOM] [nvarchar](3) NULL,
	[POS] [nvarchar](2) NULL,
	[PAC] [nvarchar](40) NULL,
	[ODI] [nvarchar](99) NULL,
	[TI] [nvarchar](2) NULL,
	[CM] [nvarchar](3) NULL,
	[TUC] [nvarchar](3) NULL,
	[A1] [nvarchar](2) NULL,
	[A2] [nvarchar](2) NULL,
	[A3] [nvarchar](2) NULL,
	[A4] [nvarchar](2) NULL,
	[A5] [nvarchar](2) NULL,
	[A6] [nvarchar](2) NULL,
	[IDUC] [nvarchar](99) NULL,
	[SITCONT] [nvarchar](3) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[TIP_INST] [nvarchar](15) NULL,
	[UAR] [nvarchar](6) NULL,
	[DAT_IMO] [nvarchar](10) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[BASE]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[BASE](
	[OBJECTID] [int] NOT NULL,
	[DIST] [int] NULL,
	[DAT_INC] [nvarchar](10) NULL,
	[DAT_FNL] [nvarchar](10) NULL,
	[DAT_EXT] [nvarchar](10) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[BAY]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[BAY](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[SUB_GRP] [nvarchar](3) NULL,
	[POS] [nvarchar](2) NULL,
	[SUB] [nvarchar](40) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[TIP_BAY] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[BE]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[BE](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[SUB_GRP] [nvarchar](3) NULL,
	[ORG_ENER] [nvarchar](3) NULL,
	[ENE_01] [numeric](38, 8) NULL,
	[ENE_02] [numeric](38, 8) NULL,
	[ENE_03] [numeric](38, 8) NULL,
	[ENE_04] [numeric](38, 8) NULL,
	[ENE_05] [numeric](38, 8) NULL,
	[ENE_06] [numeric](38, 8) NULL,
	[ENE_07] [numeric](38, 8) NULL,
	[ENE_08] [numeric](38, 8) NULL,
	[ENE_09] [numeric](38, 8) NULL,
	[ENE_10] [numeric](38, 8) NULL,
	[ENE_11] [numeric](38, 8) NULL,
	[ENE_12] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[CONJ]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[CONJ](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](20) NULL,
	[DIST] [int] NULL,
	[NOM] [nvarchar](254) NULL,
	[SIST_INTE] [int] NULL,
	[SIST_SUBT] [int] NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[Shape_STArea__] [numeric](38, 8) NOT NULL,
	[Shape_STLength__] [numeric](38, 8) NOT NULL,
	[NOME] [nvarchar](254) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[CRVCRG]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[CRVCRG](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[TIP_DIA] [nvarchar](2) NULL,
	[POT_01] [numeric](38, 8) NULL,
	[POT_02] [numeric](38, 8) NULL,
	[POT_03] [numeric](38, 8) NULL,
	[POT_04] [numeric](38, 8) NULL,
	[POT_05] [numeric](38, 8) NULL,
	[POT_06] [numeric](38, 8) NULL,
	[POT_07] [numeric](38, 8) NULL,
	[POT_08] [numeric](38, 8) NULL,
	[POT_09] [numeric](38, 8) NULL,
	[POT_10] [numeric](38, 8) NULL,
	[POT_11] [numeric](38, 8) NULL,
	[POT_12] [numeric](38, 8) NULL,
	[POT_13] [numeric](38, 8) NULL,
	[POT_14] [numeric](38, 8) NULL,
	[POT_15] [numeric](38, 8) NULL,
	[POT_16] [numeric](38, 8) NULL,
	[POT_17] [numeric](38, 8) NULL,
	[POT_18] [numeric](38, 8) NULL,
	[POT_19] [numeric](38, 8) NULL,
	[POT_20] [numeric](38, 8) NULL,
	[POT_21] [numeric](38, 8) NULL,
	[POT_22] [numeric](38, 8) NULL,
	[POT_23] [numeric](38, 8) NULL,
	[POT_24] [numeric](38, 8) NULL,
	[POT_25] [numeric](38, 8) NULL,
	[POT_26] [numeric](38, 8) NULL,
	[POT_27] [numeric](38, 8) NULL,
	[POT_28] [numeric](38, 8) NULL,
	[POT_29] [numeric](38, 8) NULL,
	[POT_30] [numeric](38, 8) NULL,
	[POT_31] [numeric](38, 8) NULL,
	[POT_32] [numeric](38, 8) NULL,
	[POT_33] [numeric](38, 8) NULL,
	[POT_34] [numeric](38, 8) NULL,
	[POT_35] [numeric](38, 8) NULL,
	[POT_36] [numeric](38, 8) NULL,
	[POT_37] [numeric](38, 8) NULL,
	[POT_38] [numeric](38, 8) NULL,
	[POT_39] [numeric](38, 8) NULL,
	[POT_40] [numeric](38, 8) NULL,
	[POT_41] [numeric](38, 8) NULL,
	[POT_42] [numeric](38, 8) NULL,
	[POT_43] [numeric](38, 8) NULL,
	[POT_44] [numeric](38, 8) NULL,
	[POT_45] [numeric](38, 8) NULL,
	[POT_46] [numeric](38, 8) NULL,
	[POT_47] [numeric](38, 8) NULL,
	[POT_48] [numeric](38, 8) NULL,
	[POT_49] [numeric](38, 8) NULL,
	[POT_50] [numeric](38, 8) NULL,
	[POT_51] [numeric](38, 8) NULL,
	[POT_52] [numeric](38, 8) NULL,
	[POT_53] [numeric](38, 8) NULL,
	[POT_54] [numeric](38, 8) NULL,
	[POT_55] [numeric](38, 8) NULL,
	[POT_56] [numeric](38, 8) NULL,
	[POT_57] [numeric](38, 8) NULL,
	[POT_58] [numeric](38, 8) NULL,
	[POT_59] [numeric](38, 8) NULL,
	[POT_60] [numeric](38, 8) NULL,
	[POT_61] [numeric](38, 8) NULL,
	[POT_62] [numeric](38, 8) NULL,
	[POT_63] [numeric](38, 8) NULL,
	[POT_64] [numeric](38, 8) NULL,
	[POT_65] [numeric](38, 8) NULL,
	[POT_66] [numeric](38, 8) NULL,
	[POT_67] [numeric](38, 8) NULL,
	[POT_68] [numeric](38, 8) NULL,
	[POT_69] [numeric](38, 8) NULL,
	[POT_70] [numeric](38, 8) NULL,
	[POT_71] [numeric](38, 8) NULL,
	[POT_72] [numeric](38, 8) NULL,
	[POT_73] [numeric](38, 8) NULL,
	[POT_74] [numeric](38, 8) NULL,
	[POT_75] [numeric](38, 8) NULL,
	[POT_76] [numeric](38, 8) NULL,
	[POT_77] [numeric](38, 8) NULL,
	[POT_78] [numeric](38, 8) NULL,
	[POT_79] [numeric](38, 8) NULL,
	[POT_80] [numeric](38, 8) NULL,
	[POT_81] [numeric](38, 8) NULL,
	[POT_82] [numeric](38, 8) NULL,
	[POT_83] [numeric](38, 8) NULL,
	[POT_84] [numeric](38, 8) NULL,
	[POT_85] [numeric](38, 8) NULL,
	[POT_86] [numeric](38, 8) NULL,
	[POT_87] [numeric](38, 8) NULL,
	[POT_88] [numeric](38, 8) NULL,
	[POT_89] [numeric](38, 8) NULL,
	[POT_90] [numeric](38, 8) NULL,
	[POT_91] [numeric](38, 8) NULL,
	[POT_92] [numeric](38, 8) NULL,
	[POT_93] [numeric](38, 8) NULL,
	[POT_94] [numeric](38, 8) NULL,
	[POT_95] [numeric](38, 8) NULL,
	[POT_96] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[GRU_TEN] [nvarchar](2) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[CTAT]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[CTAT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[NOM] [nvarchar](254) NULL,
	[TEN_NOM] [nvarchar](3) NULL,
	[DIST] [int] NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[PAC_INI] [nvarchar](40) NULL,
	[NOME] [nvarchar](254) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[CTMT]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[CTMT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[NOM] [nvarchar](254) NULL,
	[BARR] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[PAC] [nvarchar](20) NULL,
	[TEN_NOM] [nvarchar](3) NULL,
	[TEN_OPE] [numeric](38, 8) NULL,
	[ATIP] [int] NULL,
	[RECONFIG] [int] NULL,
	[DIST] [int] NULL,
	[UNI_TR_S] [nvarchar](20) NULL,
	[ENE_01] [numeric](38, 8) NULL,
	[ENE_02] [numeric](38, 8) NULL,
	[ENE_03] [numeric](38, 8) NULL,
	[ENE_04] [numeric](38, 8) NULL,
	[ENE_05] [numeric](38, 8) NULL,
	[ENE_06] [numeric](38, 8) NULL,
	[ENE_07] [numeric](38, 8) NULL,
	[ENE_08] [numeric](38, 8) NULL,
	[ENE_09] [numeric](38, 8) NULL,
	[ENE_10] [numeric](38, 8) NULL,
	[ENE_11] [numeric](38, 8) NULL,
	[ENE_12] [numeric](38, 8) NULL,
	[PERD_A3a] [numeric](38, 8) NULL,
	[PERD_A4] [numeric](38, 8) NULL,
	[PERD_B] [numeric](38, 8) NULL,
	[PERD_MED] [numeric](38, 8) NULL,
	[PERD_A3a_B] [numeric](38, 8) NULL,
	[PERD_A4_B] [numeric](38, 8) NULL,
	[PERD_B_A3a] [numeric](38, 8) NULL,
	[PERD_B_A4] [numeric](38, 8) NULL,
	[PNTMT_01] [numeric](38, 8) NULL,
	[PNTMT_02] [numeric](38, 8) NULL,
	[PNTMT_03] [numeric](38, 8) NULL,
	[PNTMT_04] [numeric](38, 8) NULL,
	[PNTMT_05] [numeric](38, 8) NULL,
	[PNTMT_06] [numeric](38, 8) NULL,
	[PNTMT_07] [numeric](38, 8) NULL,
	[PNTMT_08] [numeric](38, 8) NULL,
	[PNTMT_09] [numeric](38, 8) NULL,
	[PNTMT_10] [numeric](38, 8) NULL,
	[PNTMT_11] [numeric](38, 8) NULL,
	[PNTMT_12] [numeric](38, 8) NULL,
	[PNTBT_01] [numeric](38, 8) NULL,
	[PNTBT_02] [numeric](38, 8) NULL,
	[PNTBT_03] [numeric](38, 8) NULL,
	[PNTBT_04] [numeric](38, 8) NULL,
	[PNTBT_05] [numeric](38, 8) NULL,
	[PNTBT_06] [numeric](38, 8) NULL,
	[PNTBT_07] [numeric](38, 8) NULL,
	[PNTBT_08] [numeric](38, 8) NULL,
	[PNTBT_09] [numeric](38, 8) NULL,
	[PNTBT_10] [numeric](38, 8) NULL,
	[PNTBT_11] [numeric](38, 8) NULL,
	[PNTBT_12] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[PERD_A3aA4] [numeric](38, 8) NULL,
	[PERD_A4A3a] [numeric](38, 8) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[PAC_INI] [nvarchar](40) NULL,
	[NOME] [nvarchar](254) NULL,
	[UNI_TR_AT] [nvarchar](40) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[EP]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[EP](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[SUB_GRP_PR] [nvarchar](3) NULL,
	[SUB_GRP_SE] [nvarchar](3) NULL,
	[ENE_01] [numeric](38, 8) NULL,
	[ENE_02] [numeric](38, 8) NULL,
	[ENE_03] [numeric](38, 8) NULL,
	[ENE_04] [numeric](38, 8) NULL,
	[ENE_05] [numeric](38, 8) NULL,
	[ENE_06] [numeric](38, 8) NULL,
	[ENE_07] [numeric](38, 8) NULL,
	[ENE_08] [numeric](38, 8) NULL,
	[ENE_09] [numeric](38, 8) NULL,
	[ENE_10] [numeric](38, 8) NULL,
	[ENE_11] [numeric](38, 8) NULL,
	[ENE_12] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[EQCR]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[EQCR](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[SUB] [nvarchar](20) NULL,
	[DIST] [int] NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[ODI] [nvarchar](99) NULL,
	[TI] [nvarchar](2) NULL,
	[CM] [nvarchar](3) NULL,
	[TUC] [nvarchar](3) NULL,
	[A1] [nvarchar](2) NULL,
	[A2] [nvarchar](2) NULL,
	[A3] [nvarchar](2) NULL,
	[A4] [nvarchar](2) NULL,
	[A5] [nvarchar](2) NULL,
	[A6] [nvarchar](2) NULL,
	[IDUC] [nvarchar](99) NULL,
	[SITCONT] [nvarchar](3) NULL,
	[DAT_IMO] [nvarchar](10) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[GRU_TEN] [nvarchar](2) NULL,
	[UN_CR] [nvarchar](40) NULL,
	[UAR] [nvarchar](6) NULL,
	[TIP_INST] [nvarchar](15) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[EQME]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[EQME](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](255) NULL,
	[PAC] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[TIP_UNID] [nvarchar](3) NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[TIPMED] [int] NULL,
	[ODI] [nvarchar](99) NULL,
	[TI] [nvarchar](2) NULL,
	[CM] [nvarchar](3) NULL,
	[TUC] [nvarchar](3) NULL,
	[A1] [nvarchar](2) NULL,
	[A2] [nvarchar](2) NULL,
	[A3] [nvarchar](2) NULL,
	[A4] [nvarchar](2) NULL,
	[A5] [nvarchar](2) NULL,
	[A6] [nvarchar](2) NULL,
	[SITCONT] [nvarchar](3) NULL,
	[DAT_IMO] [nvarchar](10) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[GRU_TEN] [nvarchar](2) NULL,
	[UC_UG] [nvarchar](255) NULL,
	[TIP_INST] [nvarchar](15) NULL,
	[UAR] [nvarchar](6) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[EQRE]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[EQRE](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[POT_NOM] [nvarchar](3) NULL,
	[TIP_REGU] [nvarchar](2) NULL,
	[TEN_REG] [numeric](38, 8) NULL,
	[LIG_FAS_P] [nvarchar](4) NULL,
	[LIG_FAS_S] [nvarchar](4) NULL,
	[COR_NOM] [nvarchar](3) NULL,
	[REL_TP] [nvarchar](3) NULL,
	[REL_TC] [nvarchar](3) NULL,
	[ODI] [nvarchar](99) NULL,
	[TI] [nvarchar](2) NULL,
	[CM] [nvarchar](3) NULL,
	[TUC] [nvarchar](3) NULL,
	[A1] [nvarchar](2) NULL,
	[A2] [nvarchar](2) NULL,
	[A3] [nvarchar](2) NULL,
	[A4] [nvarchar](2) NULL,
	[A5] [nvarchar](2) NULL,
	[A6] [nvarchar](2) NULL,
	[IDUC] [nvarchar](99) NULL,
	[SITCONT] [nvarchar](3) NULL,
	[DAT_IMO] [nvarchar](10) NULL,
	[PER_FER] [numeric](38, 8) NULL,
	[PER_TOT] [numeric](38, 8) NULL,
	[R] [numeric](38, 8) NULL,
	[XHL] [numeric](38, 8) NULL,
	[ENE_01] [numeric](38, 8) NULL,
	[ENE_02] [numeric](38, 8) NULL,
	[ENE_03] [numeric](38, 8) NULL,
	[ENE_04] [numeric](38, 8) NULL,
	[ENE_05] [numeric](38, 8) NULL,
	[ENE_06] [numeric](38, 8) NULL,
	[ENE_07] [numeric](38, 8) NULL,
	[ENE_08] [numeric](38, 8) NULL,
	[ENE_09] [numeric](38, 8) NULL,
	[ENE_10] [numeric](38, 8) NULL,
	[ENE_11] [numeric](38, 8) NULL,
	[ENE_12] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[CodBnc] [smallint] NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[GRU_TEN] [nvarchar](2) NULL,
	[UN_RE] [nvarchar](40) NULL,
	[TIP_INST] [nvarchar](15) NULL,
	[UAR] [nvarchar](6) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[EQSE]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[EQSE](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[CLAS_TEN] [nvarchar](2) NULL,
	[ELO_FSV] [nvarchar](5) NULL,
	[MEI_ISO] [nvarchar](2) NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[COR_NOM] [nvarchar](3) NULL,
	[ODI] [nvarchar](99) NULL,
	[TI] [nvarchar](2) NULL,
	[CM] [nvarchar](3) NULL,
	[TUC] [nvarchar](3) NULL,
	[A1] [nvarchar](2) NULL,
	[A2] [nvarchar](2) NULL,
	[A3] [nvarchar](2) NULL,
	[A4] [nvarchar](2) NULL,
	[A5] [nvarchar](2) NULL,
	[A6] [nvarchar](2) NULL,
	[IDUC] [nvarchar](99) NULL,
	[SITCONT] [nvarchar](3) NULL,
	[DAT_IMO] [nvarchar](10) NULL,
	[ABER_CRG] [int] NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[GRU_TEN] [nvarchar](2) NULL,
	[UN_SE] [nvarchar](40) NULL,
	[TIP_INST] [nvarchar](15) NULL,
	[UAR] [nvarchar](6) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[EQSIAT]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[EQSIAT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[SUB] [nvarchar](20) NULL,
	[TIP_UNID] [nvarchar](3) NULL,
	[ODI] [nvarchar](99) NULL,
	[TI] [nvarchar](2) NULL,
	[CM] [nvarchar](3) NULL,
	[TUC] [nvarchar](3) NULL,
	[A1] [nvarchar](2) NULL,
	[A2] [nvarchar](2) NULL,
	[A3] [nvarchar](2) NULL,
	[A4] [nvarchar](2) NULL,
	[A5] [nvarchar](2) NULL,
	[A6] [nvarchar](2) NULL,
	[IDUC] [nvarchar](99) NULL,
	[SITCONT] [nvarchar](3) NULL,
	[COMP] [numeric](38, 8) NULL,
	[DAT_IMO] [nvarchar](10) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[TIP_INST] [nvarchar](50) NULL,
	[UNI_TR_AT] [nvarchar](50) NULL,
	[UAR] [nvarchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[EQTRD]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[EQTRD](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[PAC_3] [nvarchar](40) NULL,
	[CLAS_TEN] [nvarchar](2) NULL,
	[POT_NOM] [nvarchar](3) NULL,
	[LIG] [nvarchar](2) NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[TEN_PRI] [nvarchar](3) NULL,
	[TEN_SEC] [nvarchar](3) NULL,
	[TEN_TER] [nvarchar](3) NULL,
	[LIG_FAS_P] [nvarchar](4) NULL,
	[LIG_FAS_S] [nvarchar](4) NULL,
	[LIG_FAS_T] [nvarchar](4) NULL,
	[ODI] [nvarchar](99) NULL,
	[TI] [nvarchar](2) NULL,
	[CM] [nvarchar](3) NULL,
	[TUC] [nvarchar](3) NULL,
	[A1] [nvarchar](2) NULL,
	[A2] [nvarchar](2) NULL,
	[A3] [nvarchar](2) NULL,
	[A4] [nvarchar](2) NULL,
	[A5] [nvarchar](2) NULL,
	[A6] [nvarchar](2) NULL,
	[SITCONT] [nvarchar](3) NULL,
	[DAT_IMO] [nvarchar](10) NULL,
	[PER_FER] [numeric](38, 8) NULL,
	[PER_TOT] [numeric](38, 8) NULL,
	[R] [numeric](38, 8) NULL,
	[XHL] [numeric](38, 8) NULL,
	[XHT] [numeric](38, 8) NULL,
	[XLT] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[CodBnc] [smallint] NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[TIP_INST] [nvarchar](15) NULL,
	[UNI_TR_MT] [nvarchar](40) NULL,
	[UAR] [nvarchar](6) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[EQTRM]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[EQTRM](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[PAC] [nvarchar](40) NULL,
	[TIP_UNID] [nvarchar](3) NULL,
	[ODI] [nvarchar](99) NULL,
	[TI] [nvarchar](2) NULL,
	[CM] [nvarchar](3) NULL,
	[TUC] [nvarchar](3) NULL,
	[A1] [nvarchar](2) NULL,
	[A2] [nvarchar](2) NULL,
	[A3] [nvarchar](2) NULL,
	[A4] [nvarchar](2) NULL,
	[A5] [nvarchar](2) NULL,
	[A6] [nvarchar](2) NULL,
	[IDUC] [nvarchar](99) NULL,
	[SITCONT] [nvarchar](3) NULL,
	[DAT_IMO] [nvarchar](10) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[GRU_TEN] [nvarchar](2) NULL,
	[UC_UG] [nvarchar](255) NULL,
	[TIP_INST] [nvarchar](15) NULL,
	[UAR] [nvarchar](6) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[EQTRS]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[EQTRS](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[PAC_3] [nvarchar](40) NULL,
	[CLAS_TEN] [nvarchar](2) NULL,
	[POT_NOM] [nvarchar](3) NULL,
	[LIG] [nvarchar](2) NULL,
	[POS] [nvarchar](2) NULL,
	[FLX_INV] [int] NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[TEN_PRI] [nvarchar](3) NULL,
	[TEN_SEC] [nvarchar](3) NULL,
	[TEN_TER] [nvarchar](3) NULL,
	[ODI] [nvarchar](99) NULL,
	[TI] [nvarchar](2) NULL,
	[CM] [nvarchar](3) NULL,
	[TUC] [nvarchar](3) NULL,
	[A1] [nvarchar](2) NULL,
	[A2] [nvarchar](2) NULL,
	[A3] [nvarchar](2) NULL,
	[A4] [nvarchar](2) NULL,
	[A5] [nvarchar](2) NULL,
	[A6] [nvarchar](2) NULL,
	[IDUC] [nvarchar](99) NULL,
	[SITCONT] [nvarchar](3) NULL,
	[DAT_IMO] [nvarchar](10) NULL,
	[PER_FER] [numeric](38, 8) NULL,
	[PER_TOT] [numeric](38, 8) NULL,
	[POT_F01] [numeric](38, 8) NULL,
	[POT_F02] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[CodBnc] [smallint] NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[UNI_TR_AT] [nvarchar](40) NULL,
	[TIP_INST] [nvarchar](15) NULL,
	[UAR] [nvarchar](6) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[EQTRSX]    Script Date: 15/09/2022 09:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[EQTRSX](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](20) NULL,
	[SUB] [nvarchar](20) NULL,
	[DIST] [int] NULL,
	[TIP_UNID] [nvarchar](3) NULL,
	[ODI] [nvarchar](99) NULL,
	[TI] [nvarchar](2) NULL,
	[CM] [nvarchar](3) NULL,
	[TUC] [nvarchar](3) NULL,
	[A1] [nvarchar](2) NULL,
	[A2] [nvarchar](2) NULL,
	[A3] [nvarchar](2) NULL,
	[A4] [nvarchar](2) NULL,
	[A5] [nvarchar](2) NULL,
	[A6] [nvarchar](2) NULL,
	[IDUC] [nvarchar](99) NULL,
	[SITCONT] [nvarchar](3) NULL,
	[DAT_IMO] [nvarchar](10) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[GDB_ITEMRELATIONSHIPS]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[GDB_ITEMRELATIONSHIPS](
	[ObjectID] [int] NOT NULL,
	[UUID] [uniqueidentifier] NOT NULL,
	[Type] [uniqueidentifier] NOT NULL,
	[OriginID] [uniqueidentifier] NOT NULL,
	[DestID] [uniqueidentifier] NOT NULL,
	[Properties] [int] NULL,
	[Attributes] [xml] NULL,
 CONSTRAINT [R3_pk] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [sde].[GDB_ITEMRELATIONSHIPTYPES]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[GDB_ITEMRELATIONSHIPTYPES](
	[ObjectID] [int] NOT NULL,
	[UUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](226) NOT NULL,
	[ForwardLabel] [nvarchar](226) NULL,
	[BackwardLabel] [nvarchar](226) NULL,
	[OrigItemTypeID] [uniqueidentifier] NOT NULL,
	[DestItemTypeID] [uniqueidentifier] NOT NULL,
	[IsContainment] [smallint] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[GDB_ITEMS]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[GDB_ITEMS](
	[ObjectID] [int] NOT NULL,
	[UUID] [uniqueidentifier] NOT NULL,
	[Type] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](226) NULL,
	[PhysicalName] [nvarchar](226) NULL,
	[Path] [nvarchar](512) NULL,
	[Url] [nvarchar](255) NULL,
	[Properties] [int] NULL,
	[Defaults] [varbinary](max) NULL,
	[DatasetSubtype1] [int] NULL,
	[DatasetSubtype2] [int] NULL,
	[DatasetInfo1] [nvarchar](255) NULL,
	[DatasetInfo2] [nvarchar](255) NULL,
	[Definition] [xml] NULL,
	[Documentation] [xml] NULL,
	[ItemInfo] [xml] NULL,
	[Shape] [geometry] NULL,
 CONSTRAINT [R2_pk] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[GDB_ITEMTYPES]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[GDB_ITEMTYPES](
	[ObjectID] [int] NOT NULL,
	[UUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](226) NOT NULL,
	[ParentTypeID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[GDB_REPLICALOG]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[GDB_REPLICALOG](
	[ID] [int] NOT NULL,
	[ReplicaID] [int] NOT NULL,
	[Event] [int] NOT NULL,
	[ErrorCode] [int] NOT NULL,
	[LogDate] [datetime2](7) NOT NULL,
	[SourceBeginGen] [int] NOT NULL,
	[SourceEndGen] [int] NOT NULL,
	[TargetGen] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[GDB_TABLES_LAST_MODIFIED]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[GDB_TABLES_LAST_MODIFIED](
	[table_name] [nvarchar](160) NOT NULL,
	[last_modified_count] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i100]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i100](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i100_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i101]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i101](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i101_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i102]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i102](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i102_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i2]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i2](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i2_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i3]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i3](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i3_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i38]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i38](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i38_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i39]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i39](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i39_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i4]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i4](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i4_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i40]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i40](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i40_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i41]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i41](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i41_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i42]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i42](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i42_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i43]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i43](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i43_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i44]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i44](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i44_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i45]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i45](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i45_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i46]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i46](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i46_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i47]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i47](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i47_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i48]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i48](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i48_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i49]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i49](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i49_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i5]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i5](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i5_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i50]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i50](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i50_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i51]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i51](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i51_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i53]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i53](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i53_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i54]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i54](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i54_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i56]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i56](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i56_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i58]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i58](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i58_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i59]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i59](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i59_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i6]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i6](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i6_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i60]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i60](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i60_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i61]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i61](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i61_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i66]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i66](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i66_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i67]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i67](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i67_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i68]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i68](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i68_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i69]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i69](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i69_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i71]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i71](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i71_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i73]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i73](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i73_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i74]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i74](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i74_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i75]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i75](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i75_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i76]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i76](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i76_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i77]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i77](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i77_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i80]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i80](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i80_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i81]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i81](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i81_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i82]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i82](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i82_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i83]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i83](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i83_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i84]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i84](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i84_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i85]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i85](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i85_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i86]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i86](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i86_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i87]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i87](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i87_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i88]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i88](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i88_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i93]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i93](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i93_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i94]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i94](
	[id_type] [int] NOT NULL,
	[base_id] [bigint] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [bigint] NULL,
 CONSTRAINT [i94_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i98]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i98](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i98_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i99]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i99](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i99_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[INDGER]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[INDGER](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](20) NULL,
	[DIST] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[MES] [int] NULL,
	[ANO] [int] NULL,
	[NCM] [int] NULL,
	[NFEMC] [int] NULL,
	[NFECDCL] [int] NULL,
	[NFECDSL] [int] NULL,
	[NFE] [int] NULL,
	[NFEAU] [int] NULL,
	[NFEAR] [int] NULL,
	[NLSBR] [int] NULL,
	[NLEBR] [int] NULL,
	[NLSBU] [int] NULL,
	[NLEBU] [int] NULL,
	[NLSGA] [int] NULL,
	[NLEGA] [int] NULL,
	[NVLBU] [int] NULL,
	[NVLBR] [int] NULL,
	[NVLBUP] [int] NULL,
	[NVLBRP] [int] NULL,
	[NRUSAR] [int] NULL,
	[NRUEDPAR] [int] NULL,
	[NRUSAU] [int] NULL,
	[NRUEDPAU] [int] NULL,
	[NRNSAR] [int] NULL,
	[NRNEDPAR] [int] NULL,
	[NRNSAU] [int] NULL,
	[NRNEDPAU] [int] NULL,
	[NCR] [int] NULL,
	[NCRES] [int] NULL,
	[NCIND] [int] NULL,
	[NCSP] [int] NULL,
	[NCPP] [int] NULL,
	[NCIP] [int] NULL,
	[NCCO] [int] NULL,
	[NCCP] [int] NULL,
	[NCSDE] [int] NULL,
	[NCRDE] [int] NULL,
	[MINVC] [numeric](38, 8) NULL,
	[MAXVC] [numeric](38, 8) NULL,
	[VMC] [numeric](38, 8) NULL,
	[VTP] [numeric](38, 8) NULL,
	[NSA] [int] NULL,
	[NEA] [int] NULL,
	[NIMP] [int] NULL,
	[NSM] [int] NULL,
	[NPAD] [int] NULL,
	[NII] [int] NULL,
	[NTOI] [int] NULL,
	[NACDFPR] [int] NULL,
	[NMORFPR] [int] NULL,
	[NACDFTR] [int] NULL,
	[NMORFTR] [int] NULL,
	[NACDPOP] [int] NULL,
	[NMORPOP] [int] NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[NVAL_BDGD_CONSOLIDADA]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[NVAL_BDGD_CONSOLIDADA](
	[OBJECTID] [int] NOT NULL,
	[STATUS_CARGA] [smallint] NOT NULL,
	[ENTIDADE] [nvarchar](10) NULL,
	[DATA_BASE] [nvarchar](10) NULL,
	[DIST] [smallint] NULL,
	[COD_BDGD] [nvarchar](40) NULL,
	[DATAHORA_CARGA] [datetime2](7) NULL,
	[N_REGISTROS] [int] NULL,
	[DATA_BASE_DT] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[PIP]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[PIP](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[CONJ] [int] NULL,
	[SUB] [nvarchar](40) NULL,
	[UNI_TR_S] [nvarchar](40) NULL,
	[CTMT] [nvarchar](40) NULL,
	[UNI_TR_D] [nvarchar](40) NULL,
	[PN_CON] [nvarchar](40) NULL,
	[CLAS_SUB] [nvarchar](4) NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[GRU_TEN] [nvarchar](2) NULL,
	[TEN_FORN] [nvarchar](3) NULL,
	[GRU_TAR] [nvarchar](4) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[PAC] [nvarchar](40) NULL,
	[TIP_CC] [nvarchar](20) NULL,
	[CAR_INST] [numeric](38, 8) NULL,
	[ENE_01] [numeric](38, 8) NULL,
	[ENE_02] [numeric](38, 8) NULL,
	[ENE_03] [numeric](38, 8) NULL,
	[ENE_04] [numeric](38, 8) NULL,
	[ENE_05] [numeric](38, 8) NULL,
	[ENE_06] [numeric](38, 8) NULL,
	[ENE_07] [numeric](38, 8) NULL,
	[ENE_08] [numeric](38, 8) NULL,
	[ENE_09] [numeric](38, 8) NULL,
	[ENE_10] [numeric](38, 8) NULL,
	[ENE_11] [numeric](38, 8) NULL,
	[ENE_12] [numeric](38, 8) NULL,
	[DIC] [numeric](38, 8) NULL,
	[FIC] [numeric](38, 8) NULL,
	[LIV] [int] NULL,
	[SEMRED] [int] NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[DESCR] [nvarchar](254) NULL,
	[ARE_LOC] [nvarchar](2) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[UNI_TR_MT] [nvarchar](40) NULL,
	[UNI_TR_AT] [nvarchar](40) NULL,
	[TIPO_LAMP] [nvarchar](2) NULL,
	[POT_LAMP] [numeric](38, 8) NULL,
	[PERDA_REAT] [numeric](38, 8) NULL,
	[PERDA_RELE] [numeric](38, 8) NULL,
	[CONTROLE] [int] NULL,
	[PERDA_OUTR] [numeric](38, 8) NULL,
	[UC_ID] [nvarchar](40) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[PNT]    Script Date: 15/09/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[PNT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[SUB_GRP] [nvarchar](3) NULL,
	[ENE_01] [numeric](38, 8) NULL,
	[ENE_02] [numeric](38, 8) NULL,
	[ENE_03] [numeric](38, 8) NULL,
	[ENE_04] [numeric](38, 8) NULL,
	[ENE_05] [numeric](38, 8) NULL,
	[ENE_06] [numeric](38, 8) NULL,
	[ENE_07] [numeric](38, 8) NULL,
	[ENE_08] [numeric](38, 8) NULL,
	[ENE_09] [numeric](38, 8) NULL,
	[ENE_10] [numeric](38, 8) NULL,
	[ENE_11] [numeric](38, 8) NULL,
	[ENE_12] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[PONNOT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[PONNOT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[TIP_PN] [nvarchar](3) NULL,
	[POS] [nvarchar](2) NULL,
	[ESTR] [nvarchar](2) NULL,
	[MAT] [nvarchar](2) NULL,
	[ESF] [nvarchar](3) NULL,
	[ALT] [nvarchar](3) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[ODI] [nvarchar](99) NULL,
	[TI] [nvarchar](2) NULL,
	[CM] [nvarchar](3) NULL,
	[TUC] [nvarchar](3) NULL,
	[A1] [nvarchar](2) NULL,
	[A2] [nvarchar](2) NULL,
	[A3] [nvarchar](2) NULL,
	[A4] [nvarchar](2) NULL,
	[A5] [nvarchar](2) NULL,
	[A6] [nvarchar](2) NULL,
	[SITCONT] [nvarchar](3) NULL,
	[DESCR] [nvarchar](254) NULL,
	[ARE_LOC] [nvarchar](2) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[TIP_INST] [nvarchar](15) NULL,
	[UAR] [nvarchar](6) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[PT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[PT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[CATEG] [nvarchar](6) NULL,
	[ENE_01] [numeric](38, 8) NULL,
	[ENE_02] [numeric](38, 8) NULL,
	[ENE_03] [numeric](38, 8) NULL,
	[ENE_04] [numeric](38, 8) NULL,
	[ENE_05] [numeric](38, 8) NULL,
	[ENE_06] [numeric](38, 8) NULL,
	[ENE_07] [numeric](38, 8) NULL,
	[ENE_08] [numeric](38, 8) NULL,
	[ENE_09] [numeric](38, 8) NULL,
	[ENE_10] [numeric](38, 8) NULL,
	[ENE_11] [numeric](38, 8) NULL,
	[ENE_12] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[RAMLIG]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[RAMLIG](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[PN_CON_1] [nvarchar](40) NULL,
	[PN_CON_2] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[UNI_TR_D] [nvarchar](40) NULL,
	[CTMT] [nvarchar](40) NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[UNI_TR_S] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[TIP_CND] [nvarchar](20) NULL,
	[POS] [nvarchar](2) NULL,
	[ODI_FAS] [nvarchar](99) NULL,
	[TI_FAS] [nvarchar](2) NULL,
	[ODI_NEU] [nvarchar](99) NULL,
	[TI_NEU] [nvarchar](2) NULL,
	[COMP] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[SITCONTFAS] [nvarchar](3) NULL,
	[SITCONTNEU] [nvarchar](3) NULL,
	[ARE_LOC] [nvarchar](2) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[SITCONT] [nvarchar](3) NULL,
	[ODI] [nvarchar](99) NULL,
	[TI] [nvarchar](2) NULL,
	[UNI_TR_MT] [nvarchar](40) NULL,
	[UNI_TR_AT] [nvarchar](40) NULL,
	[TIP_INST] [nvarchar](15) NULL,
	[CM] [nvarchar](3) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_archives]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_archives](
	[archiving_regid] [int] NOT NULL,
	[history_regid] [int] NOT NULL,
	[from_date] [nvarchar](32) NOT NULL,
	[to_date] [nvarchar](32) NOT NULL,
	[archive_date] [bigint] NOT NULL,
	[archive_flags] [bigint] NOT NULL,
 CONSTRAINT [archives_pk] PRIMARY KEY CLUSTERED 
(
	[archiving_regid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [archives_uk] UNIQUE NONCLUSTERED 
(
	[history_regid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_column_registry]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_column_registry](
	[database_name] [nvarchar](32) NOT NULL,
	[table_name] [sysname] NOT NULL,
	[owner] [nvarchar](32) NOT NULL,
	[column_name] [nvarchar](32) NOT NULL,
	[sde_type] [int] NOT NULL,
	[column_size] [int] NULL,
	[decimal_digits] [int] NULL,
	[description] [nvarchar](65) NULL,
	[object_flags] [int] NOT NULL,
	[object_id] [int] NULL,
 CONSTRAINT [colregistry_pk] PRIMARY KEY CLUSTERED 
(
	[database_name] ASC,
	[table_name] ASC,
	[owner] ASC,
	[column_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_dbtune]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_dbtune](
	[keyword] [nvarchar](32) NOT NULL,
	[parameter_name] [nvarchar](32) NOT NULL,
	[config_string] [nvarchar](2048) NULL,
 CONSTRAINT [dbtune_pk] PRIMARY KEY CLUSTERED 
(
	[keyword] ASC,
	[parameter_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_geometry_columns]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_geometry_columns](
	[f_table_catalog] [nvarchar](32) NOT NULL,
	[f_table_schema] [nvarchar](32) NOT NULL,
	[f_table_name] [sysname] NOT NULL,
	[f_geometry_column] [nvarchar](32) NOT NULL,
	[g_table_catalog] [nvarchar](32) NULL,
	[g_table_schema] [nvarchar](32) NOT NULL,
	[g_table_name] [sysname] NOT NULL,
	[storage_type] [int] NULL,
	[geometry_type] [int] NULL,
	[coord_dimension] [int] NULL,
	[max_ppr] [int] NULL,
	[srid] [int] NOT NULL,
 CONSTRAINT [geocol_pk] PRIMARY KEY CLUSTERED 
(
	[f_table_catalog] ASC,
	[f_table_schema] ASC,
	[f_table_name] ASC,
	[f_geometry_column] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_GEOMETRY1]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[SDE_GEOMETRY1](
	[GEOMETRY_ID] [int] NOT NULL,
	[CAD] [varbinary](max) NULL,
 CONSTRAINT [geom1_idx] PRIMARY KEY CLUSTERED 
(
	[GEOMETRY_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[SDE_layer_locks]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[SDE_layer_locks](
	[sde_id] [int] NOT NULL,
	[layer_id] [int] NOT NULL,
	[autolock] [char](1) NOT NULL,
	[lock_type] [char](1) NOT NULL,
	[lock_time] [datetime] NOT NULL,
	[minx] [bigint] NULL,
	[miny] [bigint] NULL,
	[maxx] [bigint] NULL,
	[maxy] [bigint] NULL,
 CONSTRAINT [layer_locks_pk] PRIMARY KEY CLUSTERED 
(
	[sde_id] ASC,
	[layer_id] ASC,
	[autolock] ASC,
	[lock_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[SDE_layer_stats]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_layer_stats](
	[oid] [int] IDENTITY(1,1) NOT NULL,
	[layer_id] [int] NOT NULL,
	[version_id] [int] NULL,
	[minx] [float] NOT NULL,
	[miny] [float] NOT NULL,
	[maxx] [float] NOT NULL,
	[maxy] [float] NOT NULL,
	[minz] [float] NULL,
	[minm] [float] NULL,
	[maxz] [float] NULL,
	[maxm] [float] NULL,
	[total_features] [int] NOT NULL,
	[total_points] [int] NOT NULL,
	[last_analyzed] [datetime] NOT NULL,
 CONSTRAINT [sdelayer_stats_pk] PRIMARY KEY CLUSTERED 
(
	[oid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [sdelayer_stats_uk] UNIQUE NONCLUSTERED 
(
	[layer_id] ASC,
	[version_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_layers]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_layers](
	[layer_id] [int] NOT NULL,
	[description] [nvarchar](65) NULL,
	[database_name] [nvarchar](128) NOT NULL,
	[table_name] [sysname] NOT NULL,
	[owner] [nvarchar](128) NOT NULL,
	[spatial_column] [nvarchar](128) NOT NULL,
	[eflags] [int] NOT NULL,
	[layer_mask] [int] NOT NULL,
	[gsize1] [float] NOT NULL,
	[gsize2] [float] NOT NULL,
	[gsize3] [float] NOT NULL,
	[minx] [float] NOT NULL,
	[miny] [float] NOT NULL,
	[maxx] [float] NOT NULL,
	[maxy] [float] NOT NULL,
	[minz] [float] NULL,
	[maxz] [float] NULL,
	[minm] [float] NULL,
	[maxm] [float] NULL,
	[cdate] [int] NOT NULL,
	[layer_config] [nvarchar](32) NULL,
	[optimal_array_size] [int] NULL,
	[stats_date] [int] NULL,
	[minimum_id] [int] NULL,
	[srid] [int] NOT NULL,
	[base_layer_id] [int] NOT NULL,
	[secondary_srid] [int] NULL,
 CONSTRAINT [layers_pk] PRIMARY KEY CLUSTERED 
(
	[database_name] ASC,
	[table_name] ASC,
	[owner] ASC,
	[spatial_column] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY],
 CONSTRAINT [layers_uk] UNIQUE NONCLUSTERED 
(
	[layer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_lineages_modified]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_lineages_modified](
	[lineage_name] [bigint] NOT NULL,
	[time_last_modified] [datetime] NOT NULL,
 CONSTRAINT [lineages_mod_pk] PRIMARY KEY CLUSTERED 
(
	[lineage_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_locators]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_locators](
	[locator_id] [int] NOT NULL,
	[name] [nvarchar](32) NOT NULL,
	[owner] [nvarchar](32) NOT NULL,
	[category] [nvarchar](32) NOT NULL,
	[type] [int] NOT NULL,
	[description] [nvarchar](64) NULL,
 CONSTRAINT [sdelocators_pk] PRIMARY KEY CLUSTERED 
(
	[locator_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY],
 CONSTRAINT [sdelocators_uk] UNIQUE NONCLUSTERED 
(
	[name] ASC,
	[owner] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_logfile_pool]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_logfile_pool](
	[table_id] [int] NOT NULL,
	[sde_id] [int] NULL,
 CONSTRAINT [logfile_pool_pk] PRIMARY KEY CLUSTERED 
(
	[table_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_metadata]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_metadata](
	[record_id] [int] NOT NULL,
	[object_database] [nvarchar](32) NULL,
	[object_name] [nvarchar](160) NOT NULL,
	[object_owner] [nvarchar](32) NOT NULL,
	[object_type] [int] NOT NULL,
	[class_name] [nvarchar](32) NULL,
	[property] [nvarchar](32) NULL,
	[prop_value] [nvarchar](255) NULL,
	[description] [nvarchar](65) NULL,
	[creation_date] [datetime] NOT NULL,
 CONSTRAINT [sdemetadata_pk] PRIMARY KEY CLUSTERED 
(
	[record_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_mvtables_modified]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_mvtables_modified](
	[state_id] [bigint] NOT NULL,
	[registration_id] [int] NOT NULL,
 CONSTRAINT [mvtables_modified_pk] PRIMARY KEY CLUSTERED 
(
	[state_id] ASC,
	[registration_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_object_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[SDE_object_ids](
	[id_type] [int] NOT NULL,
	[base_id] [bigint] NOT NULL,
	[object_type] [varchar](30) NOT NULL,
 CONSTRAINT [object_ids_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[SDE_object_locks]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[SDE_object_locks](
	[sde_id] [int] NOT NULL,
	[object_id] [int] NOT NULL,
	[object_type] [int] NOT NULL,
	[application_id] [int] NOT NULL,
	[autolock] [char](1) NOT NULL,
	[lock_type] [char](1) NOT NULL,
	[lock_time] [datetime] NOT NULL,
 CONSTRAINT [object_locks_pk] PRIMARY KEY CLUSTERED 
(
	[sde_id] ASC,
	[object_id] ASC,
	[object_type] ASC,
	[application_id] ASC,
	[autolock] ASC,
	[lock_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[SDE_process_information]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[SDE_process_information](
	[sde_id] [int] NOT NULL,
	[spid] [int] NOT NULL,
	[server_id] [int] NOT NULL,
	[start_time] [datetime] NOT NULL,
	[rcount] [int] NOT NULL,
	[wcount] [int] NOT NULL,
	[opcount] [int] NOT NULL,
	[numlocks] [int] NOT NULL,
	[fb_partial] [int] NOT NULL,
	[fb_count] [int] NOT NULL,
	[fb_fcount] [int] NOT NULL,
	[fb_kbytes] [int] NOT NULL,
	[owner] [nvarchar](30) NOT NULL,
	[direct_connect] [varchar](1) NOT NULL,
	[sysname] [nvarchar](32) NOT NULL,
	[nodename] [nvarchar](256) NOT NULL,
	[xdr_needed] [varchar](1) NOT NULL,
	[table_name] [nvarchar](95) NOT NULL,
 CONSTRAINT [process_pk] PRIMARY KEY CLUSTERED 
(
	[sde_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[SDE_raster_columns]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_raster_columns](
	[rastercolumn_id] [int] NOT NULL,
	[description] [nvarchar](65) NULL,
	[database_name] [nvarchar](32) NOT NULL,
	[owner] [nvarchar](32) NOT NULL,
	[table_name] [sysname] NOT NULL,
	[raster_column] [nvarchar](32) NOT NULL,
	[cdate] [int] NOT NULL,
	[config_keyword] [nvarchar](32) NULL,
	[minimum_id] [int] NULL,
	[base_rastercolumn_id] [int] NOT NULL,
	[rastercolumn_mask] [int] NOT NULL,
	[srid] [int] NULL,
 CONSTRAINT [rascol_pk] PRIMARY KEY CLUSTERED 
(
	[database_name] ASC,
	[owner] ASC,
	[table_name] ASC,
	[raster_column] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY],
 CONSTRAINT [rascol_uk] UNIQUE NONCLUSTERED 
(
	[rastercolumn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_server_config]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_server_config](
	[prop_name] [nvarchar](32) NOT NULL,
	[char_prop_value] [nvarchar](512) NULL,
	[num_prop_value] [int] NULL,
 CONSTRAINT [server_config_pk] PRIMARY KEY CLUSTERED 
(
	[prop_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_spatial_references]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[SDE_spatial_references](
	[srid] [int] NOT NULL,
	[description] [nvarchar](64) NULL,
	[auth_name] [nvarchar](255) NULL,
	[auth_srid] [int] NULL,
	[falsex] [float] NOT NULL,
	[falsey] [float] NOT NULL,
	[xyunits] [float] NOT NULL,
	[falsez] [float] NOT NULL,
	[zunits] [float] NOT NULL,
	[falsem] [float] NOT NULL,
	[munits] [float] NOT NULL,
	[xycluster_tol] [float] NULL,
	[zcluster_tol] [float] NULL,
	[mcluster_tol] [float] NULL,
	[object_flags] [int] NOT NULL,
	[srtext] [varchar](1024) NOT NULL,
 CONSTRAINT [spatial_ref_pk] PRIMARY KEY CLUSTERED 
(
	[srid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[SDE_state_lineages]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_state_lineages](
	[lineage_name] [bigint] NOT NULL,
	[lineage_id] [bigint] NOT NULL,
 CONSTRAINT [state_lineages_pk] PRIMARY KEY CLUSTERED 
(
	[lineage_name] ASC,
	[lineage_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_state_locks]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[SDE_state_locks](
	[sde_id] [int] NOT NULL,
	[state_id] [bigint] NOT NULL,
	[autolock] [char](1) NOT NULL,
	[lock_type] [char](1) NOT NULL,
	[lock_time] [datetime] NOT NULL,
 CONSTRAINT [state_locks_pk] PRIMARY KEY CLUSTERED 
(
	[sde_id] ASC,
	[state_id] ASC,
	[autolock] ASC,
	[lock_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[SDE_states]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_states](
	[state_id] [bigint] NOT NULL,
	[owner] [nvarchar](32) NOT NULL,
	[creation_time] [datetime] NOT NULL,
	[closing_time] [datetime] NULL,
	[parent_state_id] [bigint] NOT NULL,
	[lineage_name] [bigint] NOT NULL,
 CONSTRAINT [states_pk] PRIMARY KEY CLUSTERED 
(
	[state_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY],
 CONSTRAINT [states_cuk] UNIQUE NONCLUSTERED 
(
	[parent_state_id] ASC,
	[lineage_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_table_locks]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[SDE_table_locks](
	[sde_id] [int] NOT NULL,
	[registration_id] [int] NOT NULL,
	[lock_type] [char](1) NOT NULL,
	[lock_time] [datetime] NOT NULL,
 CONSTRAINT [table_locks_pk] PRIMARY KEY CLUSTERED 
(
	[sde_id] ASC,
	[registration_id] ASC,
	[lock_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[SDE_table_registry]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_table_registry](
	[registration_id] [int] NOT NULL,
	[database_name] [nvarchar](32) NULL,
	[table_name] [sysname] NOT NULL,
	[owner] [nvarchar](32) NOT NULL,
	[rowid_column] [nvarchar](32) NULL,
	[description] [nvarchar](65) NULL,
	[object_flags] [int] NOT NULL,
	[registration_date] [int] NOT NULL,
	[config_keyword] [nvarchar](32) NULL,
	[minimum_id] [int] NULL,
	[imv_view_name] [nvarchar](128) NULL,
 CONSTRAINT [registry_pk] PRIMARY KEY CLUSTERED 
(
	[registration_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY],
 CONSTRAINT [registry_uk2] UNIQUE NONCLUSTERED 
(
	[table_name] ASC,
	[owner] ASC,
	[database_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_tables_modified]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_tables_modified](
	[table_name] [sysname] NOT NULL,
	[time_last_modified] [datetime] NOT NULL,
 CONSTRAINT [tables_modified_pk] PRIMARY KEY CLUSTERED 
(
	[table_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_version]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_version](
	[MAJOR] [int] NOT NULL,
	[MINOR] [int] NOT NULL,
	[BUGFIX] [int] NOT NULL,
	[DESCRIPTION] [nvarchar](96) NOT NULL,
	[RELEASE] [int] NOT NULL,
	[SDESVR_REL_LOW] [int] NOT NULL,
 CONSTRAINT [version_pk] PRIMARY KEY CLUSTERED 
(
	[MAJOR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_versions]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_versions](
	[name] [nvarchar](64) NOT NULL,
	[owner] [nvarchar](32) NOT NULL,
	[version_id] [int] NOT NULL,
	[status] [int] NOT NULL,
	[state_id] [bigint] NOT NULL,
	[description] [nvarchar](64) NULL,
	[parent_name] [nvarchar](64) NULL,
	[parent_owner] [nvarchar](32) NULL,
	[parent_version_id] [int] NULL,
	[creation_time] [datetime] NOT NULL,
 CONSTRAINT [versions_pk] PRIMARY KEY CLUSTERED 
(
	[version_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY],
 CONSTRAINT [versions_uk] UNIQUE NONCLUSTERED 
(
	[name] ASC,
	[owner] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_xml_columns]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_xml_columns](
	[column_id] [int] IDENTITY(1,1) NOT NULL,
	[registration_id] [int] NOT NULL,
	[column_name] [nvarchar](32) NOT NULL,
	[index_id] [int] NULL,
	[minimum_id] [int] NULL,
	[config_keyword] [nvarchar](32) NULL,
	[xflags] [int] NOT NULL,
 CONSTRAINT [xml_columns_pk] PRIMARY KEY NONCLUSTERED 
(
	[column_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_xml_index_tags]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_xml_index_tags](
	[index_id] [int] NOT NULL,
	[tag_id] [int] IDENTITY(1,1) NOT NULL,
	[tag_name] [nvarchar](1024) NOT NULL,
	[data_type] [int] NOT NULL,
	[tag_alias] [int] NULL,
	[description] [nvarchar](64) NULL,
	[is_excluded] [int] NOT NULL,
 CONSTRAINT [xml_indextags_pk] PRIMARY KEY CLUSTERED 
(
	[index_id] ASC,
	[tag_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_xml_indexes]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_xml_indexes](
	[index_id] [int] IDENTITY(1,1) NOT NULL,
	[index_name] [nvarchar](32) NOT NULL,
	[owner] [nvarchar](32) NOT NULL,
	[index_type] [int] NOT NULL,
	[description] [nvarchar](64) NULL,
 CONSTRAINT [xml_indexes_pk] PRIMARY KEY CLUSTERED 
(
	[index_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SEGCON]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SEGCON](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[GEOM_CAB] [nvarchar](2) NULL,
	[FORM_CAB] [nvarchar](2) NULL,
	[MAT_FAS_1] [nvarchar](2) NULL,
	[MAT_FAS_2] [nvarchar](2) NULL,
	[MAT_FAS_3] [nvarchar](2) NULL,
	[MAT_NEU] [nvarchar](2) NULL,
	[ISO_FAS_1] [nvarchar](2) NULL,
	[ISO_FAS_2] [nvarchar](2) NULL,
	[ISO_FAS_3] [nvarchar](2) NULL,
	[ISO_NEU] [nvarchar](2) NULL,
	[CND_FAS] [int] NULL,
	[R1] [numeric](38, 8) NULL,
	[X1] [numeric](38, 8) NULL,
	[FTRCNV] [numeric](38, 8) NULL,
	[CNOM] [numeric](38, 8) NULL,
	[CMAX] [numeric](38, 8) NULL,
	[CM_FAS] [nvarchar](3) NULL,
	[TUC_FAS] [nvarchar](3) NULL,
	[A1_FAS] [nvarchar](2) NULL,
	[A2_FAS] [nvarchar](2) NULL,
	[A3_FAS] [nvarchar](2) NULL,
	[A4_FAS] [nvarchar](2) NULL,
	[A5_FAS] [nvarchar](2) NULL,
	[A6_FAS] [nvarchar](2) NULL,
	[CM_NEU] [nvarchar](3) NULL,
	[TUC_NEU] [nvarchar](3) NULL,
	[A1_NEU] [nvarchar](2) NULL,
	[A2_NEU] [nvarchar](2) NULL,
	[A3_NEU] [nvarchar](2) NULL,
	[A4_NEU] [nvarchar](2) NULL,
	[A5_NEU] [nvarchar](2) NULL,
	[A6_NEU] [nvarchar](2) NULL,
	[DESCR] [nvarchar](254) NULL,
	[BIT_FAS_1] [nvarchar](3) NULL,
	[BIT_FAS_2] [nvarchar](3) NULL,
	[BIT_FAS_3] [nvarchar](3) NULL,
	[BIT_NEU] [nvarchar](3) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[R_REGUL] [nvarchar](15) NULL,
	[UAR] [nvarchar](6) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SSDAT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SSDAT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[PN_CON_1] [nvarchar](40) NULL,
	[PN_CON_2] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[DIST] [int] NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[TIP_CND] [nvarchar](40) NULL,
	[POS] [nvarchar](2) NULL,
	[ODI_FAS] [nvarchar](99) NULL,
	[TI_FAS] [nvarchar](2) NULL,
	[ODI_NEU] [nvarchar](99) NULL,
	[TI_NEU] [nvarchar](2) NULL,
	[COMP] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[SITCONTFAS] [nvarchar](3) NULL,
	[SITCONTNEU] [nvarchar](3) NULL,
	[ARE_LOC] [nvarchar](2) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[COMP_GIS] [numeric](38, 8) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[Shape_STLength__] [numeric](38, 8) NOT NULL,
	[SITCONT] [nvarchar](3) NULL,
	[ODI] [nvarchar](99) NULL,
	[TI] [nvarchar](2) NULL,
	[TIP_INST] [nvarchar](15) NULL,
	[CM] [nvarchar](3) NULL,
	[CT_COD_OP] [nvarchar](99) NULL,
	[POINT_Y1] [numeric](18, 8) NULL,
	[POINT_Y2] [numeric](18, 8) NULL,
	[POINT_X1] [numeric](18, 8) NULL,
	[POINT_X2] [numeric](18, 8) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SSDBT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SSDBT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[PN_CON_1] [nvarchar](40) NULL,
	[PN_CON_2] [nvarchar](40) NULL,
	[UNI_TR_D] [nvarchar](40) NULL,
	[CTMT] [nvarchar](40) NULL,
	[UNI_TR_S] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[DIST] [int] NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[TIP_CND] [nvarchar](40) NULL,
	[POS] [nvarchar](2) NULL,
	[ODI_FAS] [nvarchar](99) NULL,
	[TI_FAS] [nvarchar](2) NULL,
	[ODI_NEU] [nvarchar](99) NULL,
	[TI_NEU] [nvarchar](2) NULL,
	[COMP] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[SITCONTFAS] [nvarchar](3) NULL,
	[SITCONTNEU] [nvarchar](3) NULL,
	[ARE_LOC] [nvarchar](2) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[COMP_GIS] [numeric](38, 8) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[Shape_STLength__] [numeric](38, 8) NOT NULL,
	[SITCONT] [nvarchar](3) NULL,
	[ODI] [nvarchar](99) NULL,
	[TI] [nvarchar](2) NULL,
	[UNI_TR_MT] [nvarchar](40) NULL,
	[UNI_TR_AT] [nvarchar](40) NULL,
	[CM] [nvarchar](3) NULL,
	[CT_COD_OP] [nvarchar](99) NULL,
	[TIP_INST] [nvarchar](15) NULL,
	[POINT_Y1] [numeric](18, 8) NULL,
	[POINT_Y2] [numeric](18, 8) NULL,
	[POINT_X1] [numeric](18, 8) NULL,
	[POINT_X2] [numeric](18, 8) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SSDMT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SSDMT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[PN_CON_1] [nvarchar](40) NULL,
	[PN_CON_2] [nvarchar](40) NULL,
	[CTMT] [nvarchar](40) NULL,
	[UNI_TR_S] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[DIST] [int] NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[TIP_CND] [nvarchar](40) NULL,
	[POS] [nvarchar](2) NULL,
	[ODI_FAS] [nvarchar](99) NULL,
	[TI_FAS] [nvarchar](2) NULL,
	[ODI_NEU] [nvarchar](99) NULL,
	[TI_NEU] [nvarchar](2) NULL,
	[COMP] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[SITCONTFAS] [nvarchar](3) NULL,
	[SITCONTNEU] [nvarchar](3) NULL,
	[ARE_LOC] [nvarchar](2) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[COMP_GIS] [numeric](38, 8) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[Shape_STLength__] [numeric](38, 8) NOT NULL,
	[SITCONT] [nvarchar](3) NULL,
	[ODI] [nvarchar](99) NULL,
	[TI] [nvarchar](2) NULL,
	[CT_COD_OP] [nvarchar](99) NULL,
	[UNI_TR_AT] [nvarchar](40) NULL,
	[TIP_INST] [nvarchar](15) NULL,
	[CM] [nvarchar](3) NULL,
	[POINT_Y1] [numeric](18, 8) NULL,
	[POINT_Y2] [numeric](18, 8) NULL,
	[POINT_X1] [numeric](18, 8) NULL,
	[POINT_X2] [numeric](18, 8) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SUB]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SUB](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[POS] [nvarchar](2) NULL,
	[NOM] [nvarchar](50) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[Shape_STArea__] [numeric](38, 8) NOT NULL,
	[Shape_STLength__] [numeric](38, 8) NOT NULL,
	[NOME] [nvarchar](254) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[UCAT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[UCAT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](255) NULL,
	[PN_CON] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[PAC] [nvarchar](40) NULL,
	[CEG] [nvarchar](21) NULL,
	[CTAT] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[LGRD] [nvarchar](254) NULL,
	[BRR] [nvarchar](254) NULL,
	[CEP] [nvarchar](10) NULL,
	[CLAS_SUB] [nvarchar](4) NULL,
	[CNAE] [nvarchar](9) NULL,
	[TIP_CC] [nvarchar](20) NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[GRU_TEN] [nvarchar](2) NULL,
	[TEN_FORN] [nvarchar](3) NULL,
	[GRU_TAR] [nvarchar](4) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[CAR_INST] [numeric](38, 8) NULL,
	[LIV] [int] NULL,
	[DEM_P_01] [numeric](38, 8) NULL,
	[DEM_P_02] [numeric](38, 8) NULL,
	[DEM_P_03] [numeric](38, 8) NULL,
	[DEM_P_04] [numeric](38, 8) NULL,
	[DEM_P_05] [numeric](38, 8) NULL,
	[DEM_P_06] [numeric](38, 8) NULL,
	[DEM_P_07] [numeric](38, 8) NULL,
	[DEM_P_08] [numeric](38, 8) NULL,
	[DEM_P_09] [numeric](38, 8) NULL,
	[DEM_P_10] [numeric](38, 8) NULL,
	[DEM_P_11] [numeric](38, 8) NULL,
	[DEM_P_12] [numeric](38, 8) NULL,
	[DEM_F_01] [numeric](38, 8) NULL,
	[DEM_F_02] [numeric](38, 8) NULL,
	[DEM_F_03] [numeric](38, 8) NULL,
	[DEM_F_04] [numeric](38, 8) NULL,
	[DEM_F_05] [numeric](38, 8) NULL,
	[DEM_F_06] [numeric](38, 8) NULL,
	[DEM_F_07] [numeric](38, 8) NULL,
	[DEM_F_08] [numeric](38, 8) NULL,
	[DEM_F_09] [numeric](38, 8) NULL,
	[DEM_F_10] [numeric](38, 8) NULL,
	[DEM_F_11] [numeric](38, 8) NULL,
	[DEM_F_12] [numeric](38, 8) NULL,
	[ENE_P_01] [numeric](38, 8) NULL,
	[ENE_P_02] [numeric](38, 8) NULL,
	[ENE_P_03] [numeric](38, 8) NULL,
	[ENE_P_04] [numeric](38, 8) NULL,
	[ENE_P_05] [numeric](38, 8) NULL,
	[ENE_P_06] [numeric](38, 8) NULL,
	[ENE_P_07] [numeric](38, 8) NULL,
	[ENE_P_08] [numeric](38, 8) NULL,
	[ENE_P_09] [numeric](38, 8) NULL,
	[ENE_P_10] [numeric](38, 8) NULL,
	[ENE_P_11] [numeric](38, 8) NULL,
	[ENE_P_12] [numeric](38, 8) NULL,
	[ENE_F_01] [numeric](38, 8) NULL,
	[ENE_F_02] [numeric](38, 8) NULL,
	[ENE_F_03] [numeric](38, 8) NULL,
	[ENE_F_04] [numeric](38, 8) NULL,
	[ENE_F_05] [numeric](38, 8) NULL,
	[ENE_F_06] [numeric](38, 8) NULL,
	[ENE_F_07] [numeric](38, 8) NULL,
	[ENE_F_08] [numeric](38, 8) NULL,
	[ENE_F_09] [numeric](38, 8) NULL,
	[ENE_F_10] [numeric](38, 8) NULL,
	[ENE_F_11] [numeric](38, 8) NULL,
	[ENE_F_12] [numeric](38, 8) NULL,
	[DIC] [numeric](38, 8) NULL,
	[FIC] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[ARE_LOC] [nvarchar](2) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[CEG_GD] [nvarchar](21) NULL,
	[DEM_CONT] [numeric](38, 8) NULL,
	[DIC_01] [numeric](38, 8) NULL,
	[DIC_02] [numeric](38, 8) NULL,
	[DIC_03] [numeric](38, 8) NULL,
	[DIC_04] [numeric](38, 8) NULL,
	[DIC_05] [numeric](38, 8) NULL,
	[DIC_06] [numeric](38, 8) NULL,
	[DIC_07] [numeric](38, 8) NULL,
	[DIC_08] [numeric](38, 8) NULL,
	[DIC_09] [numeric](38, 8) NULL,
	[DIC_10] [numeric](38, 8) NULL,
	[DIC_11] [numeric](38, 8) NULL,
	[DIC_12] [numeric](38, 8) NULL,
	[FIC_01] [numeric](38, 8) NULL,
	[FIC_02] [numeric](38, 8) NULL,
	[FIC_03] [numeric](38, 8) NULL,
	[FIC_04] [numeric](38, 8) NULL,
	[FIC_05] [numeric](38, 8) NULL,
	[FIC_06] [numeric](38, 8) NULL,
	[FIC_07] [numeric](38, 8) NULL,
	[FIC_08] [numeric](38, 8) NULL,
	[FIC_09] [numeric](38, 8) NULL,
	[FIC_10] [numeric](38, 8) NULL,
	[FIC_11] [numeric](38, 8) NULL,
	[FIC_12] [numeric](38, 8) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[UCBT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[UCBT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](255) NULL,
	[DIST] [int] NULL,
	[PAC] [nvarchar](40) NULL,
	[CEG] [nvarchar](21) NULL,
	[PN_CON] [nvarchar](40) NULL,
	[UNI_TR_D] [nvarchar](40) NULL,
	[CTMT] [nvarchar](40) NULL,
	[UNI_TR_S] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[LGRD] [nvarchar](254) NULL,
	[BRR] [nvarchar](254) NULL,
	[CEP] [nvarchar](10) NULL,
	[CLAS_SUB] [nvarchar](4) NULL,
	[CNAE] [nvarchar](9) NULL,
	[TIP_CC] [nvarchar](20) NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[GRU_TEN] [nvarchar](2) NULL,
	[TEN_FORN] [nvarchar](3) NULL,
	[GRU_TAR] [nvarchar](4) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[CAR_INST] [numeric](38, 8) NULL,
	[LIV] [int] NULL,
	[ENE_01] [numeric](38, 8) NULL,
	[ENE_02] [numeric](38, 8) NULL,
	[ENE_03] [numeric](38, 8) NULL,
	[ENE_04] [numeric](38, 8) NULL,
	[ENE_05] [numeric](38, 8) NULL,
	[ENE_06] [numeric](38, 8) NULL,
	[ENE_07] [numeric](38, 8) NULL,
	[ENE_08] [numeric](38, 8) NULL,
	[ENE_09] [numeric](38, 8) NULL,
	[ENE_10] [numeric](38, 8) NULL,
	[ENE_11] [numeric](38, 8) NULL,
	[ENE_12] [numeric](38, 8) NULL,
	[DIC] [numeric](38, 8) NULL,
	[FIC] [numeric](38, 8) NULL,
	[SEMRED] [int] NULL,
	[DESCR] [nvarchar](254) NULL,
	[ARE_LOC] [nvarchar](2) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[CEG_GD] [nvarchar](21) NULL,
	[UNI_TR_AT] [nvarchar](40) NULL,
	[RAMAL] [nvarchar](40) NULL,
	[UNI_TR_MT] [nvarchar](40) NULL,
	[DIC_01] [numeric](38, 8) NULL,
	[DIC_02] [numeric](38, 8) NULL,
	[DIC_03] [numeric](38, 8) NULL,
	[DIC_04] [numeric](38, 8) NULL,
	[DIC_05] [numeric](38, 8) NULL,
	[DIC_06] [numeric](38, 8) NULL,
	[DIC_07] [numeric](38, 8) NULL,
	[DIC_08] [numeric](38, 8) NULL,
	[DIC_09] [numeric](38, 8) NULL,
	[DIC_10] [numeric](38, 8) NULL,
	[DIC_11] [numeric](38, 8) NULL,
	[DIC_12] [numeric](38, 8) NULL,
	[FIC_01] [numeric](38, 8) NULL,
	[FIC_02] [numeric](38, 8) NULL,
	[FIC_03] [numeric](38, 8) NULL,
	[FIC_04] [numeric](38, 8) NULL,
	[FIC_05] [numeric](38, 8) NULL,
	[FIC_06] [numeric](38, 8) NULL,
	[FIC_07] [numeric](38, 8) NULL,
	[FIC_08] [numeric](38, 8) NULL,
	[FIC_09] [numeric](38, 8) NULL,
	[FIC_10] [numeric](38, 8) NULL,
	[FIC_11] [numeric](38, 8) NULL,
	[FIC_12] [numeric](38, 8) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[UCMT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[UCMT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](255) NULL,
	[PN_CON] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[PAC] [nvarchar](40) NULL,
	[CEG] [nvarchar](21) NULL,
	[CTMT] [nvarchar](40) NULL,
	[UNI_TR_S] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[LGRD] [nvarchar](254) NULL,
	[BRR] [nvarchar](254) NULL,
	[CEP] [nvarchar](10) NULL,
	[CLAS_SUB] [nvarchar](4) NULL,
	[CNAE] [nvarchar](9) NULL,
	[TIP_CC] [nvarchar](20) NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[GRU_TEN] [nvarchar](2) NULL,
	[TEN_FORN] [nvarchar](3) NULL,
	[GRU_TAR] [nvarchar](4) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[CAR_INST] [numeric](38, 8) NULL,
	[LIV] [int] NULL,
	[DEM_01] [numeric](38, 8) NULL,
	[DEM_02] [numeric](38, 8) NULL,
	[DEM_03] [numeric](38, 8) NULL,
	[DEM_04] [numeric](38, 8) NULL,
	[DEM_05] [numeric](38, 8) NULL,
	[DEM_06] [numeric](38, 8) NULL,
	[DEM_07] [numeric](38, 8) NULL,
	[DEM_08] [numeric](38, 8) NULL,
	[DEM_09] [numeric](38, 8) NULL,
	[DEM_10] [numeric](38, 8) NULL,
	[DEM_11] [numeric](38, 8) NULL,
	[DEM_12] [numeric](38, 8) NULL,
	[ENE_01] [numeric](38, 8) NULL,
	[ENE_02] [numeric](38, 8) NULL,
	[ENE_03] [numeric](38, 8) NULL,
	[ENE_04] [numeric](38, 8) NULL,
	[ENE_05] [numeric](38, 8) NULL,
	[ENE_06] [numeric](38, 8) NULL,
	[ENE_07] [numeric](38, 8) NULL,
	[ENE_08] [numeric](38, 8) NULL,
	[ENE_09] [numeric](38, 8) NULL,
	[ENE_10] [numeric](38, 8) NULL,
	[ENE_11] [numeric](38, 8) NULL,
	[ENE_12] [numeric](38, 8) NULL,
	[DIC] [numeric](38, 8) NULL,
	[FIC] [numeric](38, 8) NULL,
	[SEMRED] [int] NULL,
	[DESCR] [nvarchar](254) NULL,
	[ARE_LOC] [nvarchar](2) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[CEG_GD] [nvarchar](21) NULL,
	[DEM_CONT] [numeric](38, 8) NULL,
	[UNI_TR_AT] [nvarchar](40) NULL,
	[DIC_01] [numeric](38, 8) NULL,
	[DIC_02] [numeric](38, 8) NULL,
	[DIC_03] [numeric](38, 8) NULL,
	[DIC_04] [numeric](38, 8) NULL,
	[DIC_05] [numeric](38, 8) NULL,
	[DIC_06] [numeric](38, 8) NULL,
	[DIC_07] [numeric](38, 8) NULL,
	[DIC_08] [numeric](38, 8) NULL,
	[DIC_09] [numeric](38, 8) NULL,
	[DIC_10] [numeric](38, 8) NULL,
	[DIC_11] [numeric](38, 8) NULL,
	[DIC_12] [numeric](38, 8) NULL,
	[FIC_01] [numeric](38, 8) NULL,
	[FIC_02] [numeric](38, 8) NULL,
	[FIC_03] [numeric](38, 8) NULL,
	[FIC_04] [numeric](38, 8) NULL,
	[FIC_05] [numeric](38, 8) NULL,
	[FIC_06] [numeric](38, 8) NULL,
	[FIC_07] [numeric](38, 8) NULL,
	[FIC_08] [numeric](38, 8) NULL,
	[FIC_09] [numeric](38, 8) NULL,
	[FIC_10] [numeric](38, 8) NULL,
	[FIC_11] [numeric](38, 8) NULL,
	[FIC_12] [numeric](38, 8) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[UGAT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[UGAT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](255) NULL,
	[PN_CON] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[PAC] [nvarchar](40) NULL,
	[CTAT] [nvarchar](40) NULL,
	[CEG] [nvarchar](21) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[SUB] [nvarchar](40) NULL,
	[LGRD] [nvarchar](254) NULL,
	[BRR] [nvarchar](254) NULL,
	[CEP] [nvarchar](10) NULL,
	[CNAE] [nvarchar](9) NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[GRU_TEN] [nvarchar](2) NULL,
	[TEN_FORN] [nvarchar](3) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[POT_INST] [numeric](38, 8) NULL,
	[POT_CONT] [numeric](38, 8) NULL,
	[DEM_P_01] [numeric](38, 8) NULL,
	[DEM_P_02] [numeric](38, 8) NULL,
	[DEM_P_03] [numeric](38, 8) NULL,
	[DEM_P_04] [numeric](38, 8) NULL,
	[DEM_P_05] [numeric](38, 8) NULL,
	[DEM_P_06] [numeric](38, 8) NULL,
	[DEM_P_07] [numeric](38, 8) NULL,
	[DEM_P_08] [numeric](38, 8) NULL,
	[DEM_P_09] [numeric](38, 8) NULL,
	[DEM_P_10] [numeric](38, 8) NULL,
	[DEM_P_11] [numeric](38, 8) NULL,
	[DEM_P_12] [numeric](38, 8) NULL,
	[DEM_F_01] [numeric](38, 8) NULL,
	[DEM_F_02] [numeric](38, 8) NULL,
	[DEM_F_03] [numeric](38, 8) NULL,
	[DEM_F_04] [numeric](38, 8) NULL,
	[DEM_F_05] [numeric](38, 8) NULL,
	[DEM_F_06] [numeric](38, 8) NULL,
	[DEM_F_07] [numeric](38, 8) NULL,
	[DEM_F_08] [numeric](38, 8) NULL,
	[DEM_F_09] [numeric](38, 8) NULL,
	[DEM_F_10] [numeric](38, 8) NULL,
	[DEM_F_11] [numeric](38, 8) NULL,
	[DEM_F_12] [numeric](38, 8) NULL,
	[ENE_P_01] [numeric](38, 8) NULL,
	[ENE_P_02] [numeric](38, 8) NULL,
	[ENE_P_03] [numeric](38, 8) NULL,
	[ENE_P_04] [numeric](38, 8) NULL,
	[ENE_P_05] [numeric](38, 8) NULL,
	[ENE_P_06] [numeric](38, 8) NULL,
	[ENE_P_07] [numeric](38, 8) NULL,
	[ENE_P_08] [numeric](38, 8) NULL,
	[ENE_P_09] [numeric](38, 8) NULL,
	[ENE_P_10] [numeric](38, 8) NULL,
	[ENE_P_11] [numeric](38, 8) NULL,
	[ENE_P_12] [numeric](38, 8) NULL,
	[ENE_F_01] [numeric](38, 8) NULL,
	[ENE_F_02] [numeric](38, 8) NULL,
	[ENE_F_03] [numeric](38, 8) NULL,
	[ENE_F_04] [numeric](38, 8) NULL,
	[ENE_F_05] [numeric](38, 8) NULL,
	[ENE_F_06] [numeric](38, 8) NULL,
	[ENE_F_07] [numeric](38, 8) NULL,
	[ENE_F_08] [numeric](38, 8) NULL,
	[ENE_F_09] [numeric](38, 8) NULL,
	[ENE_F_10] [numeric](38, 8) NULL,
	[ENE_F_11] [numeric](38, 8) NULL,
	[ENE_F_12] [numeric](38, 8) NULL,
	[DIC] [numeric](38, 8) NULL,
	[FIC] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[CEG_GD] [nvarchar](21) NULL,
	[TEN_CON] [nvarchar](3) NULL,
	[DEN_CONT] [numeric](38, 8) NULL,
	[DIC_01] [numeric](38, 8) NULL,
	[DIC_02] [numeric](38, 8) NULL,
	[DIC_03] [numeric](38, 8) NULL,
	[DIC_04] [numeric](38, 8) NULL,
	[DIC_05] [numeric](38, 8) NULL,
	[DIC_06] [numeric](38, 8) NULL,
	[DIC_07] [numeric](38, 8) NULL,
	[DIC_08] [numeric](38, 8) NULL,
	[DIC_09] [numeric](38, 8) NULL,
	[DIC_10] [numeric](38, 8) NULL,
	[DIC_11] [numeric](38, 8) NULL,
	[DIC_12] [numeric](38, 8) NULL,
	[FIC_01] [numeric](38, 8) NULL,
	[FIC_02] [numeric](38, 8) NULL,
	[FIC_03] [numeric](38, 8) NULL,
	[FIC_04] [numeric](38, 8) NULL,
	[FIC_05] [numeric](38, 8) NULL,
	[FIC_06] [numeric](38, 8) NULL,
	[FIC_07] [numeric](38, 8) NULL,
	[FIC_08] [numeric](38, 8) NULL,
	[FIC_09] [numeric](38, 8) NULL,
	[FIC_10] [numeric](38, 8) NULL,
	[FIC_11] [numeric](38, 8) NULL,
	[FIC_12] [numeric](38, 8) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[UGBT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[UGBT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](255) NULL,
	[PN_CON] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[PAC] [nvarchar](40) NULL,
	[CEG] [nvarchar](21) NULL,
	[UNI_TR_D] [nvarchar](40) NULL,
	[CTMT] [nvarchar](40) NULL,
	[UNI_TR_S] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[LGRD] [nvarchar](254) NULL,
	[BRR] [nvarchar](254) NULL,
	[CEP] [nvarchar](10) NULL,
	[CNAE] [nvarchar](9) NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[GRU_TEN] [nvarchar](2) NULL,
	[TEN_FORN] [nvarchar](3) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[POT_INST] [numeric](38, 8) NULL,
	[POT_CONT] [numeric](38, 8) NULL,
	[ENE_01] [numeric](38, 8) NULL,
	[ENE_02] [numeric](38, 8) NULL,
	[ENE_03] [numeric](38, 8) NULL,
	[ENE_04] [numeric](38, 8) NULL,
	[ENE_05] [numeric](38, 8) NULL,
	[ENE_06] [numeric](38, 8) NULL,
	[ENE_07] [numeric](38, 8) NULL,
	[ENE_08] [numeric](38, 8) NULL,
	[ENE_09] [numeric](38, 8) NULL,
	[ENE_10] [numeric](38, 8) NULL,
	[ENE_11] [numeric](38, 8) NULL,
	[ENE_12] [numeric](38, 8) NULL,
	[DIC] [numeric](38, 8) NULL,
	[FIC] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[CEG_GD] [nvarchar](21) NULL,
	[TEN_CON] [nvarchar](3) NULL,
	[UNI_TR_MT] [nvarchar](40) NULL,
	[UNI_TR_AT] [nvarchar](40) NULL,
	[DEM_CONT] [numeric](38, 8) NULL,
	[DIC_01] [numeric](38, 8) NULL,
	[DIC_02] [numeric](38, 8) NULL,
	[DIC_03] [numeric](38, 8) NULL,
	[DIC_04] [numeric](38, 8) NULL,
	[DIC_05] [numeric](38, 8) NULL,
	[DIC_06] [numeric](38, 8) NULL,
	[DIC_07] [numeric](38, 8) NULL,
	[DIC_08] [numeric](38, 8) NULL,
	[DIC_09] [numeric](38, 8) NULL,
	[DIC_10] [numeric](38, 8) NULL,
	[DIC_11] [numeric](38, 8) NULL,
	[DIC_12] [numeric](38, 8) NULL,
	[FIC_01] [numeric](38, 8) NULL,
	[FIC_02] [numeric](38, 8) NULL,
	[FIC_03] [numeric](38, 8) NULL,
	[FIC_04] [numeric](38, 8) NULL,
	[FIC_05] [numeric](38, 8) NULL,
	[FIC_06] [numeric](38, 8) NULL,
	[FIC_07] [numeric](38, 8) NULL,
	[FIC_08] [numeric](38, 8) NULL,
	[FIC_09] [numeric](38, 8) NULL,
	[FIC_10] [numeric](38, 8) NULL,
	[FIC_11] [numeric](38, 8) NULL,
	[FIC_12] [numeric](38, 8) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[UGMT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[UGMT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](255) NULL,
	[PN_CON] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[PAC] [nvarchar](40) NULL,
	[CEG] [nvarchar](21) NULL,
	[CTMT] [nvarchar](40) NULL,
	[UNI_TR_S] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[LGRD] [nvarchar](254) NULL,
	[BRR] [nvarchar](254) NULL,
	[CEP] [nvarchar](10) NULL,
	[CNAE] [nvarchar](9) NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[GRU_TEN] [nvarchar](2) NULL,
	[TEN_FORN] [nvarchar](3) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[POT_INST] [numeric](38, 8) NULL,
	[POT_CONT] [numeric](38, 8) NULL,
	[DEM_01] [numeric](38, 8) NULL,
	[DEM_02] [numeric](38, 8) NULL,
	[DEM_03] [numeric](38, 8) NULL,
	[DEM_04] [numeric](38, 8) NULL,
	[DEM_05] [numeric](38, 8) NULL,
	[DEM_06] [numeric](38, 8) NULL,
	[DEM_07] [numeric](38, 8) NULL,
	[DEM_08] [numeric](38, 8) NULL,
	[DEM_09] [numeric](38, 8) NULL,
	[DEM_10] [numeric](38, 8) NULL,
	[DEM_11] [numeric](38, 8) NULL,
	[DEM_12] [numeric](38, 8) NULL,
	[ENE_01] [numeric](38, 8) NULL,
	[ENE_02] [numeric](38, 8) NULL,
	[ENE_03] [numeric](38, 8) NULL,
	[ENE_04] [numeric](38, 8) NULL,
	[ENE_05] [numeric](38, 8) NULL,
	[ENE_06] [numeric](38, 8) NULL,
	[ENE_07] [numeric](38, 8) NULL,
	[ENE_08] [numeric](38, 8) NULL,
	[ENE_09] [numeric](38, 8) NULL,
	[ENE_10] [numeric](38, 8) NULL,
	[ENE_11] [numeric](38, 8) NULL,
	[ENE_12] [numeric](38, 8) NULL,
	[DIC] [numeric](38, 8) NULL,
	[FIC] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[CEG_GD] [nvarchar](21) NULL,
	[TEN_CON] [nvarchar](3) NULL,
	[UNI_TR_AT] [nvarchar](40) NULL,
	[DEM_CONT] [numeric](38, 8) NULL,
	[DIC_01] [numeric](38, 8) NULL,
	[DIC_02] [numeric](38, 8) NULL,
	[DIC_03] [numeric](38, 8) NULL,
	[DIC_04] [numeric](38, 8) NULL,
	[DIC_05] [numeric](38, 8) NULL,
	[DIC_06] [numeric](38, 8) NULL,
	[DIC_07] [numeric](38, 8) NULL,
	[DIC_08] [numeric](38, 8) NULL,
	[DIC_09] [numeric](38, 8) NULL,
	[DIC_10] [numeric](38, 8) NULL,
	[DIC_11] [numeric](38, 8) NULL,
	[DIC_12] [numeric](38, 8) NULL,
	[FIC_01] [numeric](38, 8) NULL,
	[FIC_02] [numeric](38, 8) NULL,
	[FIC_03] [numeric](38, 8) NULL,
	[FIC_04] [numeric](38, 8) NULL,
	[FIC_05] [numeric](38, 8) NULL,
	[FIC_06] [numeric](38, 8) NULL,
	[FIC_07] [numeric](38, 8) NULL,
	[FIC_08] [numeric](38, 8) NULL,
	[FIC_09] [numeric](38, 8) NULL,
	[FIC_10] [numeric](38, 8) NULL,
	[FIC_11] [numeric](38, 8) NULL,
	[FIC_12] [numeric](38, 8) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[UNCRAT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[UNCRAT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[TIP_UNID] [nvarchar](3) NULL,
	[POT_NOM] [nvarchar](3) NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[BANC] [int] NULL,
	[POS] [nvarchar](2) NULL,
	[DESCR] [nvarchar](254) NULL,
	[ARE_LOC] [nvarchar](2) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[UNCRBT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[UNCRBT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[TIP_UNID] [nvarchar](3) NULL,
	[POT_NOM] [nvarchar](3) NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[UNI_TR_D] [nvarchar](40) NULL,
	[CTMT] [nvarchar](40) NULL,
	[UNI_TR_S] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[BANC] [int] NULL,
	[POS] [nvarchar](2) NULL,
	[DESCR] [nvarchar](254) NULL,
	[ARE_LOC] [nvarchar](2) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[UNI_TR_MT] [nvarchar](40) NULL,
	[UNI_TR_AT] [nvarchar](40) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[UNCRMT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[UNCRMT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[TIP_UNID] [nvarchar](3) NULL,
	[POT_NOM] [nvarchar](3) NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[CTMT] [nvarchar](40) NULL,
	[UNI_TR_S] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[BANC] [int] NULL,
	[POS] [nvarchar](2) NULL,
	[DESCR] [nvarchar](254) NULL,
	[ARE_LOC] [nvarchar](2) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[UNI_TR_AT] [nvarchar](40) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[UNREAT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[UNREAT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[TIP_UNID] [nvarchar](3) NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[BANC] [int] NULL,
	[POS] [nvarchar](2) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[TIP_REGU] [nvarchar](2) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[UNREMT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[UNREMT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[TIP_UNID] [nvarchar](3) NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[CTMT] [nvarchar](40) NULL,
	[UNI_TR_S] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[BANC] [int] NULL,
	[POS] [nvarchar](2) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[TIP_REGU] [nvarchar](2) NULL,
	[UNI_TR_AT] [nvarchar](40) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[UNSEAT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[UNSEAT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[TIP_UNID] [nvarchar](3) NULL,
	[P_N_OPE] [nvarchar](2) NULL,
	[CAP_ELO] [nvarchar](5) NULL,
	[COR_NOM] [nvarchar](3) NULL,
	[TLCD] [int] NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[POS] [nvarchar](2) NULL,
	[DESCR] [nvarchar](254) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[UNSEBT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[UNSEBT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[TIP_UNID] [nvarchar](3) NULL,
	[P_N_OPE] [nvarchar](2) NULL,
	[CAP_ELO] [nvarchar](5) NULL,
	[COR_NOM] [nvarchar](3) NULL,
	[TLCD] [int] NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[POS] [nvarchar](2) NULL,
	[UNI_TR_D] [nvarchar](40) NULL,
	[CTMT] [nvarchar](40) NULL,
	[UNI_TR_S] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[DESCR] [nvarchar](254) NULL,
	[ARE_LOC] [nvarchar](2) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[UNI_TR_MT] [nvarchar](40) NULL,
	[UNI_TR_AT] [nvarchar](40) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[UNSEMT]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[UNSEMT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[FAS_CON] [nvarchar](4) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[TIP_UNID] [nvarchar](3) NULL,
	[P_N_OPE] [nvarchar](2) NULL,
	[CAP_ELO] [nvarchar](5) NULL,
	[COR_NOM] [nvarchar](3) NULL,
	[TLCD] [int] NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[POS] [nvarchar](2) NULL,
	[CTMT] [nvarchar](40) NULL,
	[UNI_TR_S] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[DESCR] [nvarchar](254) NULL,
	[ARE_LOC] [nvarchar](2) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[UNI_TR_AT] [nvarchar](40) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[UNTRD]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[UNTRD](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[PAC_3] [nvarchar](40) NULL,
	[FAS_CON_P] [nvarchar](4) NULL,
	[FAS_CON_S] [nvarchar](4) NULL,
	[FAS_CON_T] [nvarchar](4) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[TIP_UNID] [nvarchar](3) NULL,
	[POS] [nvarchar](2) NULL,
	[ATRB_PER] [int] NULL,
	[TEN_LIN_SE] [numeric](38, 8) NULL,
	[CAP_ELO] [nvarchar](5) NULL,
	[CAP_CHA] [nvarchar](3) NULL,
	[TAP] [numeric](38, 8) NULL,
	[CONF] [nvarchar](2) NULL,
	[POSTO] [nvarchar](2) NULL,
	[POT_NOM] [numeric](38, 8) NULL,
	[PER_FER] [numeric](38, 8) NULL,
	[PER_TOT] [numeric](38, 8) NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[CTMT] [nvarchar](40) NULL,
	[UNI_TR_S] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[BANC] [int] NULL,
	[TIP_TRAFO] [nvarchar](2) NULL,
	[MRT] [int] NULL,
	[DESCR] [nvarchar](254) NULL,
	[ARE_LOC] [nvarchar](2) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[UNI_TR_AT] [nvarchar](40) NULL,
	[BARR_1] [nvarchar](40) NULL,
	[BARR_2] [nvarchar](40) NULL,
	[BARR_3] [nvarchar](40) NULL,
	[ENES_01_IN] [numeric](38, 8) NULL,
	[ENES_02_IN] [numeric](38, 8) NULL,
	[ENES_03_IN] [numeric](38, 8) NULL,
	[ENES_04_IN] [numeric](38, 8) NULL,
	[ENES_05_IN] [numeric](38, 8) NULL,
	[ENES_06_IN] [numeric](38, 8) NULL,
	[ENES_07_IN] [numeric](38, 8) NULL,
	[ENES_08_IN] [numeric](38, 8) NULL,
	[ENES_09_IN] [numeric](38, 8) NULL,
	[ENES_10_IN] [numeric](38, 8) NULL,
	[ENES_11_IN] [numeric](38, 8) NULL,
	[ENES_12_IN] [numeric](38, 8) NULL,
	[ENET_01_IN] [numeric](38, 8) NULL,
	[ENET_02_IN] [numeric](38, 8) NULL,
	[ENET_03_IN] [numeric](38, 8) NULL,
	[ENET_04_IN] [numeric](38, 8) NULL,
	[ENET_05_IN] [numeric](38, 8) NULL,
	[ENET_06_IN] [numeric](38, 8) NULL,
	[ENET_07_IN] [numeric](38, 8) NULL,
	[ENET_08_IN] [numeric](38, 8) NULL,
	[ENET_09_IN] [numeric](38, 8) NULL,
	[ENET_10_IN] [numeric](38, 8) NULL,
	[ENET_11_IN] [numeric](38, 8) NULL,
	[ENET_12_IN] [numeric](38, 8) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[UNTRS]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[UNTRS](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](40) NULL,
	[SUB] [nvarchar](40) NULL,
	[BARR_1] [nvarchar](40) NULL,
	[BARR_2] [nvarchar](40) NULL,
	[BARR_3] [nvarchar](40) NULL,
	[PAC_1] [nvarchar](40) NULL,
	[PAC_2] [nvarchar](40) NULL,
	[PAC_3] [nvarchar](40) NULL,
	[DIST] [int] NULL,
	[FAS_CON_P] [nvarchar](4) NULL,
	[FAS_CON_S] [nvarchar](4) NULL,
	[FAS_CON_T] [nvarchar](4) NULL,
	[SIT_ATIV] [nvarchar](2) NULL,
	[TIP_UNID] [nvarchar](3) NULL,
	[POS] [nvarchar](2) NULL,
	[POT_NOM] [numeric](38, 8) NULL,
	[POT_F01] [numeric](38, 8) NULL,
	[POT_F02] [numeric](38, 8) NULL,
	[PER_FER] [numeric](38, 8) NULL,
	[PER_TOT] [numeric](38, 8) NULL,
	[BANC] [int] NULL,
	[DAT_CON] [nvarchar](10) NULL,
	[CONJ] [int] NULL,
	[MUN] [nvarchar](7) NULL,
	[TIP_TRAFO] [nvarchar](2) NULL,
	[ALOC_PERD] [nvarchar](2) NULL,
	[ENES_01] [numeric](38, 8) NULL,
	[ENES_02] [numeric](38, 8) NULL,
	[ENES_03] [numeric](38, 8) NULL,
	[ENES_04] [numeric](38, 8) NULL,
	[ENES_05] [numeric](38, 8) NULL,
	[ENES_06] [numeric](38, 8) NULL,
	[ENES_07] [numeric](38, 8) NULL,
	[ENES_08] [numeric](38, 8) NULL,
	[ENES_09] [numeric](38, 8) NULL,
	[ENES_10] [numeric](38, 8) NULL,
	[ENES_11] [numeric](38, 8) NULL,
	[ENES_12] [numeric](38, 8) NULL,
	[ENET_01] [numeric](38, 8) NULL,
	[ENET_02] [numeric](38, 8) NULL,
	[ENET_03] [numeric](38, 8) NULL,
	[ENET_04] [numeric](38, 8) NULL,
	[ENET_05] [numeric](38, 8) NULL,
	[ENET_06] [numeric](38, 8) NULL,
	[ENET_07] [numeric](38, 8) NULL,
	[ENET_08] [numeric](38, 8) NULL,
	[ENET_09] [numeric](38, 8) NULL,
	[ENET_10] [numeric](38, 8) NULL,
	[ENET_11] [numeric](38, 8) NULL,
	[ENET_12] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL,
	[ARE_LOC] [nvarchar](2) NULL,
	[DATA_BASE] [datetime2](7) NULL,
	[DATA_CARGA] [datetime2](7) NULL,
	[POINT_Y] [numeric](38, 8) NULL,
	[POINT_X] [numeric](38, 8) NULL,
	[ENES_01_IN] [numeric](38, 8) NULL,
	[ENES_02_IN] [numeric](38, 8) NULL,
	[ENES_03_IN] [numeric](38, 8) NULL,
	[ENES_04_IN] [numeric](38, 8) NULL,
	[ENES_05_IN] [numeric](38, 8) NULL,
	[ENES_06_IN] [numeric](38, 8) NULL,
	[ENES_07_IN] [numeric](38, 8) NULL,
	[ENES_08_IN] [numeric](38, 8) NULL,
	[ENES_09_IN] [numeric](38, 8) NULL,
	[ENES_10_IN] [numeric](38, 8) NULL,
	[ENES_11_IN] [numeric](38, 8) NULL,
	[ENES_12_IN] [numeric](38, 8) NULL,
	[ENET_01_IN] [numeric](38, 8) NULL,
	[ENET_02_IN] [numeric](38, 8) NULL,
	[ENET_03_IN] [numeric](38, 8) NULL,
	[ENET_04_IN] [numeric](38, 8) NULL,
	[ENET_05_IN] [numeric](38, 8) NULL,
	[ENET_06_IN] [numeric](38, 8) NULL,
	[ENET_07_IN] [numeric](38, 8) NULL,
	[ENET_08_IN] [numeric](38, 8) NULL,
	[ENET_09_IN] [numeric](38, 8) NULL,
	[ENET_10_IN] [numeric](38, 8) NULL,
	[ENET_11_IN] [numeric](38, 8) NULL,
	[ENET_12_IN] [numeric](38, 8) NULL
) ON [PRIMARY]

GO
/****** Object:  View [sde].[dbtune]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [sde].[dbtune] as select * from sde.SDE_dbtune
GO
/****** Object:  View [sde].[SDE_generate_guid]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [sde].[SDE_generate_guid] AS 
 SELECT '{' + CONVERT(NVARCHAR(36),newid()) + '}' as guidstr 

GO
/****** Object:  View [sde].[ST_GEOMETRY_COLUMNS]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [sde].[ST_GEOMETRY_COLUMNS] (table_schema, table_name,       column_name, type_schema, type_name,  srs_id) AS        SELECT f_table_schema, f_table_name, f_geometry_column,'dbo',       CASE geometry_type        WHEN 0 THEN 'ST_GEOMETRY'        WHEN 1 THEN 'ST_POINT'        WHEN 2 THEN 'ST_CURVE'        WHEN 3 THEN 'ST_LINESTRING'        WHEN 4 THEN 'ST_SURFACE'        WHEN 5 THEN 'ST_POLYGON'        WHEN 6 THEN 'ST_COLLECTION'        WHEN 7 THEN 'ST_MULTIPOINT'        WHEN 8 THEN 'ST_MULTICURVE'        WHEN 9 THEN 'ST_MULTISTRING'        WHEN 10 THEN 'ST_MULTISURFACE'        WHEN 11 THEN 'ST_MULTIPOLYGON'        ELSE 'ST_GEOMETRY'        END,        srid FROM sde.SDE_geometry_columns g
GO
/****** Object:  View [sde].[ST_SPATIAL_REFERENCE_SYSTEMS]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [sde].[ST_SPATIAL_REFERENCE_SYSTEMS] (srs_id, x_offset,       x_scale, y_offset, y_scale, z_offset, z_scale, m_offset,        m_scale, organization,organization_coordsys_id, definition)       AS SELECT srid, falsex, xyunits, falsey, xyunits,       falsez, zunits, falsem, munits,        auth_name, auth_srid, srtext  FROM       sde.SDE_spatial_references 
GO
/****** Object:  View [sde].[VIEW_EQRE_Bnc]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [sde].[VIEW_EQRE_Bnc] AS SELECT     DIST, DATA_BASE, PAC_1, PAC_2, COUNT(COD_ID) AS NUM_EQ, MAX(CodBnc) AS CODBNC
FROM         sde.EQRE
WHERE     (PAC_1 <> PAC_2) AND (PAC_1 <> '0') AND (PAC_2 <> '0') AND (PAC_1 <> '') AND (PAC_2 <> '') AND (PAC_1 IS NOT NULL) AND (PAC_2 IS NOT NULL)
GROUP BY DIST, DATA_BASE, PAC_1, PAC_2
HAVING      (COUNT(COD_ID) > 1)
GO
/****** Object:  View [sde].[VIEW_EQTRD_Bnc]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [sde].[VIEW_EQTRD_Bnc] AS SELECT     DIST, DATA_BASE, PAC_1, PAC_2, COUNT(COD_ID) AS NUM_EQ, MAX(CodBnc) AS CODBNC
FROM         sde.EQTRD
WHERE     (PAC_1 <> PAC_2) AND (PAC_1 <> '0') AND (PAC_2 <> '0') AND (PAC_1 <> '') AND (PAC_2 <> '') AND (PAC_1 IS NOT NULL) AND (PAC_2 IS NOT NULL)
GROUP BY DIST, DATA_BASE, PAC_1, PAC_2
HAVING      (COUNT(COD_ID) > 1)
GO
/****** Object:  View [sde].[VIEW_EQTRS_Bnc]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [sde].[VIEW_EQTRS_Bnc] AS  SELECT     DIST, DATA_BASE, PAC_1, PAC_2, COUNT(COD_ID) AS NUM_EQ, MAX(CodBnc) AS CODBNC
FROM         sde.EQTRS
WHERE     (PAC_1 <> PAC_2) AND (PAC_1 <> '0') AND (PAC_2 <> '0') AND (PAC_1 <> '') AND (PAC_2 <> '') AND (PAC_1 IS NOT NULL) AND (PAC_2 IS NOT NULL)
GROUP BY DIST, DATA_BASE, PAC_1, PAC_2
HAVING      (COUNT(COD_ID) > 1)
GO
ALTER TABLE [sde].[SDE_layer_locks] ADD  DEFAULT (getdate()) FOR [lock_time]
GO
ALTER TABLE [sde].[SDE_object_locks] ADD  DEFAULT (getdate()) FOR [lock_time]
GO
ALTER TABLE [sde].[SDE_state_locks] ADD  DEFAULT (getdate()) FOR [lock_time]
GO
ALTER TABLE [sde].[SDE_table_locks] ADD  DEFAULT (getdate()) FOR [lock_time]
GO
ALTER TABLE [sde].[SDE_archives]  WITH CHECK ADD  CONSTRAINT [archives_fk1] FOREIGN KEY([archiving_regid])
REFERENCES [sde].[SDE_table_registry] ([registration_id])
GO
ALTER TABLE [sde].[SDE_archives] CHECK CONSTRAINT [archives_fk1]
GO
ALTER TABLE [sde].[SDE_archives]  WITH CHECK ADD  CONSTRAINT [archives_fk2] FOREIGN KEY([history_regid])
REFERENCES [sde].[SDE_table_registry] ([registration_id])
GO
ALTER TABLE [sde].[SDE_archives] CHECK CONSTRAINT [archives_fk2]
GO
ALTER TABLE [sde].[SDE_column_registry]  WITH CHECK ADD  CONSTRAINT [colregistry_fk] FOREIGN KEY([table_name], [owner], [database_name])
REFERENCES [sde].[SDE_table_registry] ([table_name], [owner], [database_name])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [sde].[SDE_column_registry] CHECK CONSTRAINT [colregistry_fk]
GO
ALTER TABLE [sde].[SDE_geometry_columns]  WITH CHECK ADD  CONSTRAINT [geocol_fk] FOREIGN KEY([srid])
REFERENCES [sde].[SDE_spatial_references] ([srid])
GO
ALTER TABLE [sde].[SDE_geometry_columns] CHECK CONSTRAINT [geocol_fk]
GO
ALTER TABLE [sde].[SDE_layer_stats]  WITH CHECK ADD  CONSTRAINT [sdelayer_stats_fk1] FOREIGN KEY([layer_id])
REFERENCES [sde].[SDE_layers] ([layer_id])
ON DELETE CASCADE
GO
ALTER TABLE [sde].[SDE_layer_stats] CHECK CONSTRAINT [sdelayer_stats_fk1]
GO
ALTER TABLE [sde].[SDE_layer_stats]  WITH CHECK ADD  CONSTRAINT [sdelayer_stats_fk2] FOREIGN KEY([version_id])
REFERENCES [sde].[SDE_versions] ([version_id])
ON DELETE CASCADE
GO
ALTER TABLE [sde].[SDE_layer_stats] CHECK CONSTRAINT [sdelayer_stats_fk2]
GO
ALTER TABLE [sde].[SDE_layers]  WITH CHECK ADD  CONSTRAINT [layers_fk] FOREIGN KEY([srid])
REFERENCES [sde].[SDE_spatial_references] ([srid])
GO
ALTER TABLE [sde].[SDE_layers] CHECK CONSTRAINT [layers_fk]
GO
ALTER TABLE [sde].[SDE_layers]  WITH CHECK ADD  CONSTRAINT [layers_sfk] FOREIGN KEY([secondary_srid])
REFERENCES [sde].[SDE_spatial_references] ([srid])
GO
ALTER TABLE [sde].[SDE_layers] CHECK CONSTRAINT [layers_sfk]
GO
ALTER TABLE [sde].[SDE_mvtables_modified]  WITH CHECK ADD  CONSTRAINT [mvtables_modified_fk1] FOREIGN KEY([state_id])
REFERENCES [sde].[SDE_states] ([state_id])
GO
ALTER TABLE [sde].[SDE_mvtables_modified] CHECK CONSTRAINT [mvtables_modified_fk1]
GO
ALTER TABLE [sde].[SDE_mvtables_modified]  WITH CHECK ADD  CONSTRAINT [mvtables_modified_fk2] FOREIGN KEY([registration_id])
REFERENCES [sde].[SDE_table_registry] ([registration_id])
GO
ALTER TABLE [sde].[SDE_mvtables_modified] CHECK CONSTRAINT [mvtables_modified_fk2]
GO
ALTER TABLE [sde].[SDE_raster_columns]  WITH CHECK ADD  CONSTRAINT [rascol_fk] FOREIGN KEY([srid])
REFERENCES [sde].[SDE_spatial_references] ([srid])
GO
ALTER TABLE [sde].[SDE_raster_columns] CHECK CONSTRAINT [rascol_fk]
GO
ALTER TABLE [sde].[SDE_xml_columns]  WITH CHECK ADD  CONSTRAINT [xml_columns_fk1] FOREIGN KEY([registration_id])
REFERENCES [sde].[SDE_table_registry] ([registration_id])
GO
ALTER TABLE [sde].[SDE_xml_columns] CHECK CONSTRAINT [xml_columns_fk1]
GO
ALTER TABLE [sde].[SDE_xml_columns]  WITH CHECK ADD  CONSTRAINT [xml_columns_fk2] FOREIGN KEY([index_id])
REFERENCES [sde].[SDE_xml_indexes] ([index_id])
GO
ALTER TABLE [sde].[SDE_xml_columns] CHECK CONSTRAINT [xml_columns_fk2]
GO
ALTER TABLE [sde].[SDE_xml_index_tags]  WITH CHECK ADD  CONSTRAINT [xml_indextags_fk1] FOREIGN KEY([index_id])
REFERENCES [sde].[SDE_xml_indexes] ([index_id])
ON DELETE CASCADE
GO
ALTER TABLE [sde].[SDE_xml_index_tags] CHECK CONSTRAINT [xml_indextags_fk1]
GO
ALTER TABLE [sde].[GDB_ITEMS]  WITH CHECK ADD  CONSTRAINT [g1_ck] CHECK  (([Shape].[STSrid]=(4326)))
GO
ALTER TABLE [sde].[GDB_ITEMS] CHECK CONSTRAINT [g1_ck]
GO
ALTER TABLE [sde].[SDE_spatial_references]  WITH CHECK ADD  CONSTRAINT [spatial_ref_xyunits] CHECK  (([xyunits]>=(1)))
GO
ALTER TABLE [sde].[SDE_spatial_references] CHECK CONSTRAINT [spatial_ref_xyunits]
GO
ALTER TABLE [sde].[SDE_spatial_references]  WITH CHECK ADD  CONSTRAINT [spatial_ref_zunits] CHECK  (([zunits]>=(1)))
GO
ALTER TABLE [sde].[SDE_spatial_references] CHECK CONSTRAINT [spatial_ref_zunits]
GO
ALTER TABLE [sde].[SDE_table_registry]  WITH CHECK ADD  CONSTRAINT [registry_chk] CHECK  (([database_name]=db_name()))
GO
ALTER TABLE [sde].[SDE_table_registry] CHECK CONSTRAINT [registry_chk]
GO
/****** Object:  StoredProcedure [dbo].[Loop_Atualiza]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		SRD
-- Create date: 1/1/2020
-- Description:	Carga de dados agregados do SIG-R 
-- Parameters: Parâmetros da carga para distribuidoras, data-base, banco de origem (@base) e entidade 
	-- entidades: 1 - Consumidores; 2 - Rede; 3 - Trafos; 0 - Todas
-- =============================================
CREATE PROCEDURE [dbo].[Loop_Atualiza]
	-- Add the parameters for the stored procedure here
	@DIST_INI int,
	@DIST_FIM int,
	@DATA_BASE [DATETIME]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @cnt INT = @DIST_INI;
	declare @dist int;
	DECLARE @formatted_datetime char(23);
	DECLARE @msg nvarchar(50);
	DECLARE @sigla nvarchar(30);

	WHILE @cnt <= @DIST_FIM
		BEGIN

			set @dist = (select IdAgente from GEO_SIGR_DDAD.sde.TDIST where COD_ID = @cnt)
			set @sigla = (select SIGLA from GEO_SIGR_DDAD.sde.TDIST where COD_ID = @cnt)
			SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
			RAISERROR (N'%s: Atualização V1.0 da DIST %d / %s', 0, 1, @formatted_datetime, @dist, @sigla) WITH NOWAIT

			EXEC [sde].[_atualiza_v1.0] @DIST = @dist, @DATA_BASE = @DATA_BASE

			SET @cnt = @cnt + 1;
		END;
END



GO
/****** Object:  StoredProcedure [dbo].[Loop_Limpeza]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		SRD
-- Create date: 1/1/2020
-- Description:	Carga de dados agregados do SIG-R 
-- Parameters: Parâmetros da carga para distribuidoras, data-base, banco de origem (@base) e entidade 
	-- entidades: 1 - Consumidores; 2 - Rede; 3 - Trafos; 0 - Todas
-- =============================================
CREATE PROCEDURE [dbo].[Loop_Limpeza]
	-- Add the parameters for the stored procedure here
	@DIST_INI int,
	@DIST_FIM int,
	@DATA_BASE [DATETIME]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @cnt INT = @DIST_INI;
	declare @dist nvarchar(5);
	DECLARE @formatted_datetime char(23);
	DECLARE @dist_sigr nvarchar(3);
	DECLARE @sigla nvarchar(30);
	declare @data nvarchar(10);

	WHILE @cnt <= @DIST_FIM
		BEGIN

			IF @cnt <= 116 
			BEGIN set @dist = (select IdAgente from GEO_SIGR_DDAD.sde.TDIST where COD_ID = @cnt) END
			ELSE 
			BEGIN set @dist = 9790 + @cnt END -- válido para user teste 201-209

			set @sigla = (select SIGLA from GEO_SIGR_DDAD.sde.TDIST where COD_ID = @cnt)
			SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
			SET @data = CONVERT(char(10), @DATA_BASE, 121)
			set @dist_sigr = convert(char(3), @cnt)
			
			RAISERROR (N'%s: Limpeza da DIST %s-%s-%s de %s', 0, 1, @formatted_datetime, @dist_sigr, @dist, @sigla, @data) WITH NOWAIT

			EXEC [sde].[_limpa_base] @DIST = @dist, @DATA_BASE = @DATA_BASE, @DATA_BASE2 = '1900-01-01'

			SET @cnt = @cnt + 1;
		END;
END





GO
/****** Object:  StoredProcedure [sde].[_atualiza_v1.0]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [sde].[_atualiza_v1.0]
	-- Add the parameters for the stored procedure here
	@dist int,
	@data_base [date]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

if (@data_base >= '2021-12-31')

	BEGIN
		DECLARE @formatted_datetime char(23)
		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza PAC_1, PAC_2 e TIP_REGU de EQRE com UNREAT...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[EQRE] 
		SET [PAC_1] = U.PAC_1, [PAC_2] = U.PAC_2, TIP_REGU = U.TIP_REGU
		FROM [sde].[EQRE] AS E JOIN [sde].[UNREAT] AS U ON ((E.UN_RE = U.COD_ID) AND (U.DIST = E.DIST) AND (U.DATA_BASE = E.DATA_BASE))
		WHERE E.DIST = ' + @dist + ' AND E.DATA_BASE = ''' + @data_base + ''' AND E.GRU_TEN = ''AT'''
		)
		
		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza PAC_1, PAC_2 e TIP_REGU de EQRE com UNREMT...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[EQRE] 
		SET PAC_1 = U.PAC_1, PAC_2 = U.PAC_2, TIP_REGU = U.TIP_REGU
		FROM [sde].[EQRE] AS E JOIN [sde].[UNREMT] AS U ON ((E.UN_RE = U.COD_ID) AND (U.DIST = E.DIST) AND (U.DATA_BASE = E.DATA_BASE))
		WHERE E.DIST = ' + @dist + ' AND E.DATA_BASE = ''' + @data_base + ''' AND E.GRU_TEN = ''MT'''
		)
		
		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza DESCR, PAC_1 e PAC_2 de EQTRD/MT com UNTRD/MT...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[EQTRD] 
		SET PAC_1 = U.PAC_1, PAC_2 = U.PAC_2, DESCR = UNI_TR_MT
		FROM [sde].[EQTRD] AS E JOIN [sde].[UNTRD] AS U ON ((E.UNI_TR_MT = U.COD_ID) AND (U.DIST = E.DIST) AND (U.DATA_BASE = E.DATA_BASE))
		WHERE E.DIST = ' + @dist + ' AND E.DATA_BASE = ''' + @data_base + ''''
		)

				
		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza DESCR, PAC_1 e PAC_2 de EQTRS/AT com UNTRS/AT...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[EQTRS] 
		SET PAC_1 = U.PAC_1, PAC_2 = U.PAC_2, DESCR = UNI_TR_AT
		FROM [sde].[EQTRS] AS E JOIN [sde].[UNTRS] AS U ON ((E.UNI_TR_AT = U.COD_ID) AND (U.DIST = E.DIST) AND (U.DATA_BASE = E.DATA_BASE))
		WHERE E.DIST = ' + @dist + ' AND E.DATA_BASE = ''' + @data_base + ''''
		)
				
		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza PAC_1 e PAC_2 de EQSE com UNSEAT...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[EQSE] 
		SET PAC_1 = U.PAC_1, PAC_2 = U.PAC_2
		FROM [sde].[EQSE] AS E JOIN [sde].[UNSEAT] AS U ON ((E.UN_SE = U.COD_ID) AND (U.DIST = E.DIST) AND (U.DATA_BASE = E.DATA_BASE))
		WHERE E.GRU_TEN = ''AT'' AND E.DIST = ' + @dist + ' AND E.DATA_BASE = ''' + @data_base + ''''
		)

		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza PAC_1 e PAC_2 de EQSE com UNSEMT...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[EQSE] 
		SET PAC_1 = U.PAC_1, PAC_2 = U.PAC_2
		FROM [sde].[EQSE] AS E JOIN [sde].[UNSEMT] AS U ON ((E.UN_SE = U.COD_ID) AND (U.DIST = E.DIST) AND (U.DATA_BASE = E.DATA_BASE))
		WHERE E.GRU_TEN = ''MT'' AND E.DIST = ' + @dist + ' AND E.DATA_BASE = ''' + @data_base + ''''
		)

		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza PAC_1 e PAC_2 de EQSE com UNSEBT...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[EQSE] 
		SET PAC_1 = U.PAC_1, PAC_2 = U.PAC_2
		FROM [sde].[EQSE] AS E JOIN [sde].[UNSEBT] AS U ON ((E.UN_SE = U.COD_ID) AND (U.DIST = E.DIST) AND (U.DATA_BASE = E.DATA_BASE))
		WHERE E.GRU_TEN = ''BT'' AND E.DIST = ' + @dist + ' AND E.DATA_BASE = ''' + @data_base + ''''
		)
						
		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza PAC de CTMT com PAC_INI...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[CTMT] 
		SET PAC = PAC_INI
		FROM [sde].[CTMT]
		WHERE DIST = ' + @dist + ' AND DATA_BASE = ''' + @data_base + ''''
		)
										
		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza UNI_TR_D/S e CEG de UCBT com UNI_TR_MT/AT e CEG_GD...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[UCBT] 
		SET UNI_TR_D = UNI_TR_MT, CEG = CEG_GD, UNI_TR_S = UNI_TR_AT
		FROM [sde].[UCBT]
		WHERE DIST = ' + @dist + ' AND DATA_BASE = ''' + @data_base + ''''
		)

		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza CEG de UCMT com CEG_GD...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[UCMT] 
		SET CEG = CEG_GD
		FROM [sde].[UCMT]
		WHERE DIST = ' + @dist + ' AND DATA_BASE = ''' + @data_base + ''''
		)

		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza CEG de UCAT com CEG_GD...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[UCAT] 
		SET CEG = CEG_GD
		FROM [sde].[UCAT]
		WHERE DIST = ' + @dist + ' AND DATA_BASE = ''' + @data_base + ''''
		)

		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza UNI_TR_D/S de PIP com UNI_TR_MT/AT...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[PIP] 
		SET UNI_TR_D = UNI_TR_MT, UNI_TR_S = UNI_TR_AT
		FROM [sde].[PIP]
		WHERE DIST = ' + @dist + ' AND DATA_BASE = ''' + @data_base + ''''
		)

		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza CEG e TEN_FORN de UGBT com CEG_GD e TEN_CON...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[UGBT] 
		SET CEG = CEG_GD, TEN_FORN = TEN_CON
		FROM [sde].[UGBT]
		WHERE DIST = ' + @dist + ' AND DATA_BASE = ''' + @data_base + ''''
		)

		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza CEG e TEN_FORN de UGMT com CEG_GD e TEN_CON...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[UGMT] 
		SET CEG = CEG_GD, TEN_FORN = TEN_CON
		FROM [sde].[UGMT]
		WHERE DIST = ' + @dist + ' AND DATA_BASE = ''' + @data_base + ''''
		)

		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza CEG e TEN_FORN de UGAT com CEG_GD e TEN_CON...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[UGAT] 
		SET CEG = CEG_GD, TEN_FORN = TEN_CON
		FROM [sde].[UGAT]
		WHERE DIST = ' + @dist + ' AND DATA_BASE = ''' + @data_base + ''''
		)
						
		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza UNI_TR_D/S, SITCONTFAS/NEU, ODI_FAS/NEU e TIFAS/NEU de RAMLIG com UNI_TR_MT/AT, SITCONT, ODI e TI...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[RAMLIG] 
		SET UNI_TR_D = UNI_TR_MT, UNI_TR_S = UNI_TR_AT, SITCONTFAS = SITCONT, SITCONTNEU = SITCONT, ODI_FAS = ODI, ODI_NEU = ODI, TI_FAS = TI, TI_NEU = TI
		FROM [sde].[RAMLIG]
		WHERE DIST = ' + @dist + ' AND DATA_BASE = ''' + @data_base + ''''
		)
						
		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza SITCONTFAS/NEU, ODI_FAS/NEU e TIFAS/NEU de SSDAT com SITCONT, ODI e TI...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[SSDAT] 
		SET SITCONTFAS = SITCONT, SITCONTNEU = SITCONT, ODI_FAS = ODI, ODI_NEU = ODI, TI_FAS = TI, TI_NEU = TI
		FROM [sde].[SSDAT]
		WHERE DIST = ' + @dist + ' AND DATA_BASE = ''' + @data_base + ''''
		)
						
		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza UNI_TR_D/S, SITCONTFAS/NEU, ODI_FAS/NEU e TIFAS/NEU de SSDBT com UNI_TRM/AT, SITCONT, ODI e TI...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[SSDBT] 
		SET UNI_TR_D = UNI_TR_MT, UNI_TR_S = UNI_TR_AT, SITCONTFAS = SITCONT, SITCONTNEU = SITCONT, ODI_FAS = ODI, ODI_NEU = ODI, TI_FAS = TI, TI_NEU = TI
		FROM [sde].[SSDBT]
		WHERE DIST = ' + @dist + ' AND DATA_BASE = ''' + @data_base + ''''
		)
						
		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Atualiza SITCONTFAS/NEU, ODI_FAS/NEU e TIFAS/NEU de SSDMT com SITCONT, ODI e TI...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'UPDATE [sde].[SSDMT] 
		SET SITCONTFAS = SITCONT, SITCONTNEU = SITCONT, ODI_FAS = ODI, ODI_NEU = ODI, TI_FAS = TI, TI_NEU = TI
		FROM [sde].[SSDMT]
		WHERE DIST = ' + @dist + ' AND DATA_BASE = ''' + @data_base + ''''
		)

		DECLARE @CodBase int = CONVERT(int, CONCAT(YEAR(@data_base), FORMAT(MONTH(@data_base), '00'), @dist))
		--DECLARE @param varchar(100) = CONVERT(char(10), @data_base, 121) +  CONVERT(char(5), @dist, 121) + CONVERT(char(11), @CodBase, 121)
		DELETE FROM [dbo].[StoredCrvCrgBT] WHERE [CodBase] = @CodBase
		DELETE FROM [dbo].[StoredCrvCrgMT] WHERE [CodBase] = @CodBase
		
		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Início da Carga de StoredCrvCrgMT...', 0, 1, @formatted_datetime) WITH NOWAIT
		--RAISERROR ('Parâmetros: %s', 0, 1, @param) WITH NOWAIT
		EXECUTE(
		'INSERT INTO [dbo].[StoredCrvCrgMT]
		([CodBase]
		,[CodCrvCrg]
		,[TipoDia]
		,[PotAtv01_kW]
		,[PotAtv02_kW]
		,[PotAtv03_kW]
		,[PotAtv04_kW]
		,[PotAtv05_kW]
		,[PotAtv06_kW]
		,[PotAtv07_kW]
		,[PotAtv08_kW]
		,[PotAtv09_kW]
		,[PotAtv10_kW]
		,[PotAtv11_kW]
		,[PotAtv12_kW]
		,[PotAtv13_kW]
		,[PotAtv14_kW]
		,[PotAtv15_kW]
		,[PotAtv16_kW]
		,[PotAtv17_kW]
		,[PotAtv18_kW]
		,[PotAtv19_kW]
		,[PotAtv20_kW]
		,[PotAtv21_kW]
		,[PotAtv22_kW]
		,[PotAtv23_kW]
		,[PotAtv24_kW]
		,[PotAtv25_kW]
		,[PotAtv26_kW]
		,[PotAtv27_kW]
		,[PotAtv28_kW]
		,[PotAtv29_kW]
		,[PotAtv30_kW]
		,[PotAtv31_kW]
		,[PotAtv32_kW]
		,[PotAtv33_kW]
		,[PotAtv34_kW]
		,[PotAtv35_kW]
		,[PotAtv36_kW]
		,[PotAtv37_kW]
		,[PotAtv38_kW]
		,[PotAtv39_kW]
		,[PotAtv40_kW]
		,[PotAtv41_kW]
		,[PotAtv42_kW]
		,[PotAtv43_kW]
		,[PotAtv44_kW]
		,[PotAtv45_kW]
		,[PotAtv46_kW]
		,[PotAtv47_kW]
		,[PotAtv48_kW]
		,[PotAtv49_kW]
		,[PotAtv50_kW]
		,[PotAtv51_kW]
		,[PotAtv52_kW]
		,[PotAtv53_kW]
		,[PotAtv54_kW]
		,[PotAtv55_kW]
		,[PotAtv56_kW]
		,[PotAtv57_kW]
		,[PotAtv58_kW]
		,[PotAtv59_kW]
		,[PotAtv60_kW]
		,[PotAtv61_kW]
		,[PotAtv62_kW]
		,[PotAtv63_kW]
		,[PotAtv64_kW]
		,[PotAtv65_kW]
		,[PotAtv66_kW]
		,[PotAtv67_kW]
		,[PotAtv68_kW]
		,[PotAtv69_kW]
		,[PotAtv70_kW]
		,[PotAtv71_kW]
		,[PotAtv72_kW]
		,[PotAtv73_kW]
		,[PotAtv74_kW]
		,[PotAtv75_kW]
		,[PotAtv76_kW]
		,[PotAtv77_kW]
		,[PotAtv78_kW]
		,[PotAtv79_kW]
		,[PotAtv80_kW]
		,[PotAtv81_kW]
		,[PotAtv82_kW]
		,[PotAtv83_kW]
		,[PotAtv84_kW]
		,[PotAtv85_kW]
		,[PotAtv86_kW]
		,[PotAtv87_kW]
		,[PotAtv88_kW]
		,[PotAtv89_kW]
		,[PotAtv90_kW]
		,[PotAtv91_kW]
		,[PotAtv92_kW]
		,[PotAtv93_kW]
		,[PotAtv94_kW]
		,[PotAtv95_kW]
		,[PotAtv96_kW]
		,[Descr])
		SELECT ' + @CodBase +  ' as [CodBase]
		,[COD_ID]
		,[TIP_DIA]
		,[POT_01]
		,[POT_02]
		,[POT_03]
		,[POT_04]
		,[POT_05]
		,[POT_06]
		,[POT_07]
		,[POT_08]
		,[POT_09]
		,[POT_10]
		,[POT_11]
		,[POT_12]
		,[POT_13]
		,[POT_14]
		,[POT_15]
		,[POT_16]
		,[POT_17]
		,[POT_18]
		,[POT_19]
		,[POT_20]
		,[POT_21]
		,[POT_22]
		,[POT_23]
		,[POT_24]
		,[POT_25]
		,[POT_26]
		,[POT_27]
		,[POT_28]
		,[POT_29]
		,[POT_30]
		,[POT_31]
		,[POT_32]
		,[POT_33]
		,[POT_34]
		,[POT_35]
		,[POT_36]
		,[POT_37]
		,[POT_38]
		,[POT_39]
		,[POT_40]
		,[POT_41]
		,[POT_42]
		,[POT_43]
		,[POT_44]
		,[POT_45]
		,[POT_46]
		,[POT_47]
		,[POT_48]
		,[POT_49]
		,[POT_50]
		,[POT_51]
		,[POT_52]
		,[POT_53]
		,[POT_54]
		,[POT_55]
		,[POT_56]
		,[POT_57]
		,[POT_58]
		,[POT_59]
		,[POT_60]
		,[POT_61]
		,[POT_62]
		,[POT_63]
		,[POT_64]
		,[POT_65]
		,[POT_66]
		,[POT_67]
		,[POT_68]
		,[POT_69]
		,[POT_70]
		,[POT_71]
		,[POT_72]
		,[POT_73]
		,[POT_74]
		,[POT_75]
		,[POT_76]
		,[POT_77]
		,[POT_78]
		,[POT_79]
		,[POT_80]
		,[POT_81]
		,[POT_82]
		,[POT_83]
		,[POT_84]
		,[POT_85]
		,[POT_86]
		,[POT_87]
		,[POT_88]
		,[POT_89]
		,[POT_90]
		,[POT_91]
		,[POT_92]
		,[POT_93]
		,[POT_94]
		,[POT_95]
		,[POT_96]
		,[Descr]
		FROM [sde].[CRVCRG]
		WHERE GRU_TEN = ''MT'' AND DIST = ' + @dist + ' AND DATA_BASE = ''' + @data_base + ''''
		)

		SET @formatted_datetime = CONVERT(char(23), GETDATE(), 121)
		RAISERROR ('%s: Início da Carga de StoredCrvCrgBT...', 0, 1, @formatted_datetime) WITH NOWAIT
		EXECUTE(
		'INSERT INTO [dbo].[StoredCrvCrgBT]
		([CodBase]
		,[CodCrvCrg]
		,[TipoDia]
		,[PotAtv01_kW]
		,[PotAtv02_kW]
		,[PotAtv03_kW]
		,[PotAtv04_kW]
		,[PotAtv05_kW]
		,[PotAtv06_kW]
		,[PotAtv07_kW]
		,[PotAtv08_kW]
		,[PotAtv09_kW]
		,[PotAtv10_kW]
		,[PotAtv11_kW]
		,[PotAtv12_kW]
		,[PotAtv13_kW]
		,[PotAtv14_kW]
		,[PotAtv15_kW]
		,[PotAtv16_kW]
		,[PotAtv17_kW]
		,[PotAtv18_kW]
		,[PotAtv19_kW]
		,[PotAtv20_kW]
		,[PotAtv21_kW]
		,[PotAtv22_kW]
		,[PotAtv23_kW]
		,[PotAtv24_kW]
		,[PotAtv25_kW]
		,[PotAtv26_kW]
		,[PotAtv27_kW]
		,[PotAtv28_kW]
		,[PotAtv29_kW]
		,[PotAtv30_kW]
		,[PotAtv31_kW]
		,[PotAtv32_kW]
		,[PotAtv33_kW]
		,[PotAtv34_kW]
		,[PotAtv35_kW]
		,[PotAtv36_kW]
		,[PotAtv37_kW]
		,[PotAtv38_kW]
		,[PotAtv39_kW]
		,[PotAtv40_kW]
		,[PotAtv41_kW]
		,[PotAtv42_kW]
		,[PotAtv43_kW]
		,[PotAtv44_kW]
		,[PotAtv45_kW]
		,[PotAtv46_kW]
		,[PotAtv47_kW]
		,[PotAtv48_kW]
		,[PotAtv49_kW]
		,[PotAtv50_kW]
		,[PotAtv51_kW]
		,[PotAtv52_kW]
		,[PotAtv53_kW]
		,[PotAtv54_kW]
		,[PotAtv55_kW]
		,[PotAtv56_kW]
		,[PotAtv57_kW]
		,[PotAtv58_kW]
		,[PotAtv59_kW]
		,[PotAtv60_kW]
		,[PotAtv61_kW]
		,[PotAtv62_kW]
		,[PotAtv63_kW]
		,[PotAtv64_kW]
		,[PotAtv65_kW]
		,[PotAtv66_kW]
		,[PotAtv67_kW]
		,[PotAtv68_kW]
		,[PotAtv69_kW]
		,[PotAtv70_kW]
		,[PotAtv71_kW]
		,[PotAtv72_kW]
		,[PotAtv73_kW]
		,[PotAtv74_kW]
		,[PotAtv75_kW]
		,[PotAtv76_kW]
		,[PotAtv77_kW]
		,[PotAtv78_kW]
		,[PotAtv79_kW]
		,[PotAtv80_kW]
		,[PotAtv81_kW]
		,[PotAtv82_kW]
		,[PotAtv83_kW]
		,[PotAtv84_kW]
		,[PotAtv85_kW]
		,[PotAtv86_kW]
		,[PotAtv87_kW]
		,[PotAtv88_kW]
		,[PotAtv89_kW]
		,[PotAtv90_kW]
		,[PotAtv91_kW]
		,[PotAtv92_kW]
		,[PotAtv93_kW]
		,[PotAtv94_kW]
		,[PotAtv95_kW]
		,[PotAtv96_kW]
		,[Descr])
		SELECT ' + @CodBase +  ' as [CodBase]
		,[COD_ID]
		,[TIP_DIA]
		,[POT_01]
		,[POT_02]
		,[POT_03]
		,[POT_04]
		,[POT_05]
		,[POT_06]
		,[POT_07]
		,[POT_08]
		,[POT_09]
		,[POT_10]
		,[POT_11]
		,[POT_12]
		,[POT_13]
		,[POT_14]
		,[POT_15]
		,[POT_16]
		,[POT_17]
		,[POT_18]
		,[POT_19]
		,[POT_20]
		,[POT_21]
		,[POT_22]
		,[POT_23]
		,[POT_24]
		,[POT_25]
		,[POT_26]
		,[POT_27]
		,[POT_28]
		,[POT_29]
		,[POT_30]
		,[POT_31]
		,[POT_32]
		,[POT_33]
		,[POT_34]
		,[POT_35]
		,[POT_36]
		,[POT_37]
		,[POT_38]
		,[POT_39]
		,[POT_40]
		,[POT_41]
		,[POT_42]
		,[POT_43]
		,[POT_44]
		,[POT_45]
		,[POT_46]
		,[POT_47]
		,[POT_48]
		,[POT_49]
		,[POT_50]
		,[POT_51]
		,[POT_52]
		,[POT_53]
		,[POT_54]
		,[POT_55]
		,[POT_56]
		,[POT_57]
		,[POT_58]
		,[POT_59]
		,[POT_60]
		,[POT_61]
		,[POT_62]
		,[POT_63]
		,[POT_64]
		,[POT_65]
		,[POT_66]
		,[POT_67]
		,[POT_68]
		,[POT_69]
		,[POT_70]
		,[POT_71]
		,[POT_72]
		,[POT_73]
		,[POT_74]
		,[POT_75]
		,[POT_76]
		,[POT_77]
		,[POT_78]
		,[POT_79]
		,[POT_80]
		,[POT_81]
		,[POT_82]
		,[POT_83]
		,[POT_84]
		,[POT_85]
		,[POT_86]
		,[POT_87]
		,[POT_88]
		,[POT_89]
		,[POT_90]
		,[POT_91]
		,[POT_92]
		,[POT_93]
		,[POT_94]
		,[POT_95]
		,[POT_96]
		,[Descr]
		FROM [sde].[CRVCRG]
		WHERE GRU_TEN = ''BT'' AND DIST = ' + @dist + ' AND DATA_BASE = ''' + @data_base + ''''
		)

	END

END




GO
/****** Object:  StoredProcedure [sde].[_limpa_base]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [sde].[_limpa_base]
	-- Add the parameters for the stored procedure here
	@dist [text],
	@data_base [datetime],
	@data_base2 [text]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

EXECUTE('delete from [sde].[ARAT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base + ''' or data_base is null)')
EXECUTE('delete from [sde].[BAR]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[CONJ]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[CTAT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[EQCR]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[EQME]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE( 'delete from [sde].[EQSE]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[EQSIAT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[EQTRM]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[EQTRSX]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[INDGER]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[PONNOT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[SSDAT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[SUB]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[UCAT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[UGAT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[UNCRAT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[UNCRBT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[UNCRMT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[UNREAT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[UNSEAT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[BASE]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[BAY]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[BE]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[CTMT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[EP]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[EQRE]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[EQTRD]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[EQTRS]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[PIP]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[PNT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[PT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[RAMLIG]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[SEGCON]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[SSDBT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[SSDMT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[UCBT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[UCMT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[UGBT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[UGMT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[UNREMT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[UNSEMT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[UNSEBT]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[UNTRD]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[UNTRS]
where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
EXECUTE('delete from [sde].[NVAL_BDGD_CONSOLIDADA]
where dist = ' + @dist + ' and (data_base = ''' + @data_base2+ ''' or data_base is null)')
if (@data_base >= '2021-12-31')
	EXECUTE('delete from [sde].[CRVCRG]
	where dist = ' + @dist + ' and (data_base = ''' + @data_base+ ''' or data_base is null)')
END


GO
/****** Object:  StoredProcedure [sde].[create_version]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[create_version] 
@parent_name NVARCHAR (97),
@name NVARCHAR (64) OUTPUT,
@name_rule INTEGER,
@access INTEGER,
@description NVARCHAR(64) AS SET NOCOUNT ON
BEGIN
  /* This is a public procedure to create an SDE version.
  The new version will be a child of the given parent version name.
  The new version may have a unique name generated, depending on the
  value of the name_rule parameter. Valid name rules are:
  1 - generate a new name if there's already a version with the given name.
    In this case, the new name will be returned in the @name parameter, 
    as long as the caller supplied the OUTPUT keyword with the parameter.
  2 - Only use the name supplied, return an error if it already exists.

  The access parameter specified the new version's access as follows:
  0 - private version.
  1 - public version.
  2 - protected version. */

  -- Setup possible return codes

  DECLARE @SE_NO_PERMISSIONS INTEGER
  SET @SE_NO_PERMISSIONS = 50025

  DECLARE @SE_LOCK_CONFLICT INTEGER
  SET @SE_LOCK_CONFLICT = 50049

  DECLARE @SE_INVALID_PARAM_VALUE INTEGER
  SET @SE_INVALID_PARAM_VALUE = 50066

  DECLARE @SE_VERSION_NOEXIST INTEGER
  SET @SE_VERSION_NOEXIST = 50126

  DECLARE @SE_INVALID_VERSION_NAME INTEGER
  SET @SE_INVALID_VERSION_NAME = 50171

  DECLARE @SE_STATE_NOEXIST INTEGER
  SET @SE_STATE_NOEXIST = 50172

  DECLARE @SE_INVALID_VERSION_ID INTEGER
  SET @SE_INVALID_VERSION_ID = 50298

  -- Check arguments.

  IF @parent_name IS NULL

  BEGIN
    RAISERROR ('Parent version can not be NULL.',16,-1)
    RETURN @SE_VERSION_NOEXIST
  END

  DECLARE @parsed_name NVARCHAR(64)
  DECLARE @parsed_owner NVARCHAR(32)
  DECLARE @current_user NVARCHAR(32)
  DECLARE @error_string NVARCHAR(256)
  DECLARE @node_name  NVARCHAR(256)
  DECLARE @ret_code INTEGER

  EXECUTE sde.SDE_get_current_user_name @current_user OUTPUT 
  EXECUTE @ret_code = sde.SDE_parse_version_name @name,
                      @parsed_name OUTPUT, 
                      @parsed_owner OUTPUT
  IF (@ret_code != 0)
    RETURN @ret_code

  IF @parsed_owner <> @current_user
  BEGIN
    RAISERROR ('The new version must be in the current user''s schema.', 16,-1)
    RETURN @SE_INVALID_VERSION_NAME
  END

  IF @access IS NULL
  BEGIN
    RAISERROR ('NULL is not a valid access type code.',16,-1)
    RETURN @SE_INVALID_PARAM_VALUE
  END
  ELSE IF @access < 0 OR @access > 2
  BEGIN
    SET @error_string = cast (@access AS VARCHAR (10)) + 
                       ' is not a valid access type code.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_INVALID_PARAM_VALUE
  END

  IF @name_rule IS NULL
  BEGIN
    RAISERROR ('NULL is not a valid name rule.',16,-1)
    RETURN @SE_INVALID_PARAM_VALUE
  END
  ELSE IF @name_rule < 1 OR @name_rule > 2
  BEGIN
   SET @error_string = cast (@name_rule AS VARCHAR (10)) + 
                       ' is not a valid name rule.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_INVALID_PARAM_VALUE
  END

  -- Fetch the proposed parent version.

  DECLARE @parsed_parent_name NVARCHAR(64)
  DECLARE @parsed_parent_owner NVARCHAR(32)
  DECLARE @parent_version_id INTEGER
  DECLARE @parent_state_id BIGINT
  DECLARE @parent_status INTEGER

  EXECUTE @ret_code = sde.SDE_parse_version_name @parent_name,
                      @parsed_parent_name OUTPUT,
                      @parsed_parent_owner OUTPUT
  IF (@ret_code != 0)
    RETURN @ret_code

  SELECT @parent_version_id = version_id, @parent_state_id = state_id,
         @parent_status = status
  FROM   sde.SDE_versions
  WHERE  name = @parsed_parent_name AND
         owner = @parsed_parent_owner

  IF @parent_version_id IS NULL
  BEGIN
    SET @error_string = 'Version ' + @parent_name + ' not found.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_VERSION_NOEXIST
  END

  -- Check permissions.  At least one of the following must be true for this
  -- operation:  (1) The parent version must be public or protected, or
  --             (2) The current user is the parent version's owner, or
  --             (3) The current user is the SDE DBA user.

  DECLARE @protected CHAR (1)

  SET @protected = sde.SDE_get_version_access (@parent_status,
                    @parsed_parent_owner)
  IF @protected = '2'
  BEGIN
    SET @error_string = 'Insufficient access to version ' + @parent_name
    RAISERROR (@error_string,16,-1)
    RETURN @SE_NO_PERMISSIONS
  END

  -- Get an sde connection id for locking purposes

  DECLARE @connection_id INTEGER
  EXECUTE sde.SDE_get_primary_oid 12, 1, @connection_id OUTPUT

  -- We also need to insert into the process info table, otherwise if
  -- another process detects a lock conflict, this lock will be dropped
  -- since it doesn't belong to a valid SDE connection in the
  -- process info table.

  DECLARE @conn_tab NVARCHAR(95)
  SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
    + N'_GEO_SIGR_PERDAS' 
  DECLARE @sql AS NVARCHAR (256)
  SET @sql = N'CREATE TABLE ' + @conn_tab + N' (keycol INTEGER)'
  EXEC (@sql)
  SET @conn_tab = N'tempdb.' + USER_NAME() + N'.' + @conn_tab
  SET @node_name = HOST_NAME()
  EXECUTE sde.SDE_pinfo_def_insert @connection_id, 0,'Y',
    'Win32',@node_name,'F',@conn_tab

  -- Lock the underlying state, to make sure it stays still.

  EXECUTE @ret_code = sde.SDE_state_lock_def_insert @connection_id,
                      @parent_state_id, 'Y', 'S'
  IF @ret_code = -49
    SET @ret_code = @SE_LOCK_CONFLICT
  IF @ret_code != 0
  BEGIN
    EXECUTE sde.SDE_pinfo_def_delete @connection_id
    SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
      + N'_GEO_SIGR_PERDAS' 
    SET @sql = N'DROP TABLE ' + @conn_tab
    EXEC (@sql)
    RETURN @ret_code
  END

  -- Now that we have a lock, we safely check to see if the parent
  -- version's state still exists.

  DECLARE @state_id BIGINT

  SELECT @state_id = state_id
  FROM   sde.SDE_states
  WHERE  state_id = @parent_state_id

  IF @state_id IS NULL
  BEGIN
    EXECUTE sde.SDE_pinfo_def_delete @connection_id
    SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
      + N'_GEO_SIGR_PERDAS' 
    SET @sql = N'DROP TABLE ' + @conn_tab
    EXEC (@sql)
    SET @error_string = 'State ' + cast (@parent_state_id AS VARCHAR (20))
                        + ' from version ' + @parent_name + ' not found.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_STATE_NOEXIST
  END

  -- Get a version ID.

  DECLARE @version_id INTEGER
  EXECUTE sde.SDE_get_primary_oid 9, 1, @version_id OUTPUT

  IF @version_id IS NULL
  BEGIN
    EXECUTE sde.SDE_pinfo_def_delete @connection_id
    SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
      + N'_GEO_SIGR_PERDAS' 
    SET @sql = N'DROP TABLE ' + @conn_tab
    EXEC (@sql)
    SET @error_string = 'Unable to generate a version ID for ' +  @name
    RAISERROR (@error_string,16,-1)
    RETURN @SE_INVALID_VERSION_ID
  END

  -- Insert the new version.

  DECLARE @current_date DATETIME
  SET @current_date = GETDATE ()

  EXECUTE @ret_code = sde.SDE_versions_def_insert @parsed_name OUTPUT,
       @current_user, @version_id, @access, @parent_state_id, @description,
       @parsed_parent_name, @parsed_parent_owner, @parent_version_id,
       @current_date, @name_rule

  -- Set the returned name, in case we changed it.
  SET @name = @parsed_name

  -- It's now safe to remove the state lock and pinfo entry.

  SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
    + N'_GEO_SIGR_PERDAS' 
  SET @sql = N'DROP TABLE ' + @conn_tab
  EXEC (@sql)
  EXECUTE sde.SDE_pinfo_def_delete @connection_id

  -- do a hard commit, even if called within a transaction.
  WHILE @@TRANCOUNT > 0
    COMMIT

  RETURN @ret_code
END

GO
/****** Object:  StoredProcedure [sde].[delete_version]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[delete_version]
@name NVARCHAR (97) AS SET NOCOUNT ON
BEGIN
  -- This is a public procedure to delete an SDE version.

  -- Setup possible return codes

  DECLARE @SE_NO_PERMISSIONS INTEGER
  SET @SE_NO_PERMISSIONS = 50025

  DECLARE @SE_VERSION_NOEXIST INTEGER
  SET @SE_VERSION_NOEXIST = 50126

  DECLARE @SE_VERSION_HAS_CHILDREN INTEGER
  SET @SE_VERSION_HAS_CHILDREN = 50175

  DECLARE @SE_MVV_VERSION_IN_USE INTEGER
  SET @SE_MVV_VERSION_IN_USE = 50553

  DECLARE @SE_LOCK_CONFLICT INTEGER
  SET @SE_LOCK_CONFLICT = 50049

  DECLARE @parsed_name NVARCHAR(64)
  DECLARE @parsed_owner NVARCHAR(32)
  DECLARE @error_string NVARCHAR(256)
  DECLARE @ret_code INTEGER

  -- Parse the version name.

  EXECUTE @ret_code = sde.SDE_parse_version_name @name,
          @parsed_name OUTPUT, @parsed_owner OUTPUT
  IF (@ret_code != 0)
    RETURN @ret_code

  -- Make sure this is not the default version.

  IF @parsed_owner = 'sde' AND @parsed_name = 'DEFAULT'
  BEGIN
    RAISERROR ('The default version may not be deleted.',16,-1)
    RETURN @SE_NO_PERMISSIONS
  END

  -- If we are not the DBA, make sure that we are the owner.

  DECLARE @current_user NVARCHAR(32)
  DECLARE @is_dba INTEGER
  SET @is_dba = sde.SDE_is_user_sde_dba ()
  EXECUTE sde.SDE_get_current_user_name @current_user OUTPUT

  IF @is_dba = 0
  BEGIN
    IF @current_user != @parsed_owner
    BEGIN
      SET @error_string = @current_user + ' not owner of version ' +
                          @name + '.'
      RAISERROR (@error_string,16,-1)
      RETURN @SE_NO_PERMISSIONS
    END
  END

  -- Make sure that the version exists.

  DECLARE @version_id INTEGER

  DECLARE @state_id INTEGER

  SELECT @version_id = version_id, @state_id = state_id
  FROM   sde.SDE_versions
  WHERE  name = @parsed_name AND
         owner = @parsed_owner

  IF @version_id IS NULL
  BEGIN
    SET @error_string = 'Version ' + @name + ' not found.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_VERSION_NOEXIST
  END

  -- Make sure that this version has no children.

  DECLARE @parent_version_id INTEGER

  SET @parent_version_id = NULL

  SELECT @parent_version_id = version_id
  FROM   sde.SDE_versions
  WHERE  parent_name = @parsed_name AND
         parent_owner = @parsed_owner

  IF @parent_version_id IS NOT NULL
  BEGIN
    SET @error_string = 'Version ' + @name +
                        ' can not be deleted, as it has children.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_VERSION_HAS_CHILDREN
  END

  -- Check if we set this version in the current session.
  DECLARE @g_state_id BIGINT
  DECLARE @g_protected CHAR(1)
  DECLARE @g_is_default CHAR(1)
  DECLARE @g_version_id INTEGER
  EXECUTE sde.SDE_get_globals @g_state_id OUTPUT,@g_protected OUTPUT,@g_is_default OUTPUT,@g_version_id OUTPUT
  IF (@g_version_id = @version_id) OR
     (@g_state_id = @state_id AND @g_is_default = '0')
  BEGIN
    SET @error_string = 'Version ' + @name +
                        ' can not be deleted, as it is in use.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_MVV_VERSION_IN_USE
  END

  -- Place an object lock on the version to be deleted to be sure 
  -- it isn't currently in use.

  DECLARE @connection_id INTEGER

  -- Get an sde connection id for locking purposes

  EXECUTE sde.SDE_get_primary_oid 12, 1, @connection_id OUTPUT

  -- We also need to insert into the process info table, otherwise if
  -- another process detects a lock conflict, this lock will be dropped
  -- since it doesn't belong to a valid SDE connection in the
  -- process info table.

  DECLARE @conn_tab NVARCHAR(95)
  DECLARE @node_name NVARCHAR(256)
  SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
    + N'_GEO_SIGR_PERDAS' 
  DECLARE @sql AS NVARCHAR (256)
  SET @sql = N'CREATE TABLE ' + @conn_tab + N' (keycol INTEGER)'
  EXEC (@sql)
  SET @conn_tab = N'tempdb.' + USER_NAME() + N'.' + @conn_tab
  SET @node_name = HOST_NAME()
  EXECUTE sde.SDE_pinfo_def_insert @connection_id, 0,'Y',
    'Win32',@node_name,'F',@conn_tab

  -- Lock the underlying object, to make sure it stays still.

  EXECUTE @ret_code = sde.SDE_object_lock_def_insert @connection_id,
                      @version_id,1,999, 'Y', 'E'
  IF @ret_code = -49
    SET @ret_code = @SE_LOCK_CONFLICT
  IF @ret_code != 0
  BEGIN
    EXECUTE sde.SDE_pinfo_def_delete @connection_id
    SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
      + N'_GEO_SIGR_PERDAS' 
    SET @sql = N'DROP TABLE ' + @conn_tab
    EXEC (@sql)
    SET @error_string = 'Unable to delete version ' +  @name + 
           ' which may be currently referenced by other object'
    RAISERROR (@error_string,16,-1)
    RETURN @ret_code
  END

  -- Perform the delete.

  EXECUTE sde.SDE_versions_def_delete @parsed_owner, @parsed_name

  -- Remove the lock.
  EXECUTE sde.SDE_object_lock_def_delete            @connection_id,@version_id,1,999,'Y'

  -- It's now safe to remove pinfo entry.

  SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
    + N'_GEO_SIGR_PERDAS' 
  SET @sql = N'DROP TABLE ' + @conn_tab
  EXEC (@sql)
  EXECUTE sde.SDE_pinfo_def_delete @connection_id

END

GO
/****** Object:  StoredProcedure [sde].[edit_version]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[edit_version] 
@name NVARCHAR (97),
@edit_action INTEGER AS SET NOCOUNT ON
BEGIN

  /* This is a public procedure to toggle an SDE version's editability.
  If edit_action is 1, the version will be made editable by creating
  a new state as the child of the version's current state. The version
  will then point to this new state. The version will also be made the
  current version for versioned views.
  If edit_action is 2, the version will no longer be editable. The state
  it is pointing to will be closed. */
  -- Setup possible return codes

  DECLARE @SE_NO_PERMISSIONS INTEGER
  SET @SE_NO_PERMISSIONS = 50025

  DECLARE @SE_LOCK_CONFLICT INTEGER
  SET @SE_LOCK_CONFLICT = 50049

  DECLARE @SE_INVALID_PARAM_VALUE INTEGER
  SET @SE_INVALID_PARAM_VALUE = 50066

  DECLARE @SE_VERSION_NOEXIST INTEGER
  SET @SE_VERSION_NOEXIST = 50126

  DECLARE @SE_STATE_NOEXIST INTEGER
  SET @SE_STATE_NOEXIST = 50172

  DECLARE @SE_VERSION_HAS_MOVED INTEGER
  SET @SE_VERSION_HAS_MOVED = 50174

  DECLARE @SE_PARENT_NOT_CLOSED INTEGER
  SET @SE_PARENT_NOT_CLOSED = 50176

  DECLARE @SE_TRANS_IN_PROGRESS INTEGER
  SET @SE_TRANS_IN_PROGRESS = 50068

  DECLARE @SE_MVV_IN_EDIT_MODE INTEGER
  SET @SE_MVV_IN_EDIT_MODE = 50501

  DECLARE @SE_MVV_NAMEVER_NOT_CURRVER INTEGER
  SET @SE_MVV_NAMEVER_NOT_CURRVER = 50503

  DECLARE @parsed_name NVARCHAR(64)
  DECLARE @parsed_owner NVARCHAR(32)
  DECLARE @node_name  NVARCHAR(256)
  DECLARE @error_string NVARCHAR(256)
  DECLARE @ret_code INTEGER

  DECLARE @sql AS NVARCHAR (256)
  -- Check arguments.

  IF @edit_action IS NULL
  BEGIN
    RAISERROR ('Edit action may not be NULL.',16,-1)
    RETURN @SE_INVALID_PARAM_VALUE
  END
  ELSE IF @edit_action < 1 OR @edit_action > 2
  BEGIN
    SET @error_string = cast (@edit_action AS VARCHAR (10)) + 
                       ' is not a valid edit action code.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_INVALID_PARAM_VALUE
  END

  -- Parse the version name
  EXECUTE @ret_code = sde.SDE_parse_version_name @name,
          @parsed_name OUTPUT, @parsed_owner OUTPUT
  IF (@ret_code != 0)
    RETURN @ret_code

  -- Do not allow editing of default version.

  IF (@parsed_name = 'DEFAULT') AND (@parsed_owner = 'sde')
  BEGIN
    SET @error_string = 'Cannot edit the DEFAULT version in STANDARD transaction mode.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_INVALID_PARAM_VALUE
  END

  -- Get the information we need from the version.

  DECLARE @version_id INTEGER
  DECLARE @state_id BIGINT
  DECLARE @status INTEGER

  SELECT @version_id = version_id, @state_id = state_id,
         @status = status
  FROM   sde.SDE_versions
  WHERE  name = @parsed_name AND
         owner = @parsed_owner

  IF @version_id IS NULL
  BEGIN
    SET @error_string = 'Version ' + @name + ' not found.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_VERSION_NOEXIST
  END

  -- Check if we are already in an edit session.
  DECLARE @g_state_id BIGINT
  DECLARE @g_protected CHAR(1)
  DECLARE @g_is_default CHAR(1)
  DECLARE @g_version_id INTEGER
  EXECUTE sde.SDE_get_globals @g_state_id OUTPUT,@g_protected OUTPUT,@g_is_default OUTPUT,@g_version_id OUTPUT
  IF @edit_action = 1
  BEGIN
    DECLARE @exists INTEGER
    IF (@g_version_id != -1) AND (@g_version_id != @version_id)
    BEGIN
      -- Check that version and state still exist (e.g. may have been rolled back)
      SELECT @exists = count(*) from sde.SDE_versions
        WHERE version_id = @g_version_id
      IF @exists > 0
      BEGIN
        SELECT @exists = count(*) from sde.SDE_states
          WHERE state_id = @g_state_id
        IF @exists > 0
        BEGIN
          SET @error_string = 'Cannot start edit on a new version with an open edit session to another version.'
          RAISERROR (@error_string,16,-1)
          RETURN @SE_MVV_IN_EDIT_MODE
        END
      END
    END
    IF @g_version_id = @version_id
    BEGIN
      SELECT @exists = count(*) from sde.SDE_states
        WHERE state_id = @g_state_id
      IF @exists > 0
        RETURN 0 -- no-op
    END
  END
  ELSE
  BEGIN
    IF @g_version_id != @version_id
    BEGIN
      IF @g_version_id = -1
        SET @error_string = 'Not currently editing a version, cannot stop edit.'
      ELSE
        SET @error_string = 'Cannot stop edit on ' + @name + ' while version id ' + 
          cast (@g_version_id AS VARCHAR(10)) + ' is the current edit version.'
      RAISERROR (@error_string,16,-1)
      RETURN @SE_MVV_NAMEVER_NOT_CURRVER
    END
  END

  -- Check permissions.  At least one of the following must be true for this
  -- operation:  (1) The version must be public, or
  --             (2) The current user is the version's owner, or
  --             (3) The current user is the SDE DBA user.

  DECLARE @protected CHAR (1)

  SET @protected = sde.SDE_get_version_access (@status, @parsed_owner)
  IF @protected = '1' OR @protected = '2'
  BEGIN
    SET @error_string = 'Insufficient access to version ' + @name
    RAISERROR (@error_string,16,-1)
    RETURN @SE_NO_PERMISSIONS
  END

  -- Get an sde connection id for locking purposes

  DECLARE @connection_id INTEGER
  IF @edit_action = 2
  BEGIN
    SELECT @connection_id = sde_id from sde.SDE_process_information WHERE spid = @@spid
  END
  IF @edit_action = 1 OR @connection_id IS NULL
  BEGIN
    EXECUTE sde.SDE_get_primary_oid 12, 1, @connection_id OUTPUT

  -- We also need to insert into the process info table, otherwise if
  -- another process detects a lock conflict, this lock will be dropped
  -- since it doesn't belong to a valid SDE connection in the
  -- process info table.

    DECLARE @conn_tab NVARCHAR(95)
    SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
      + N'_GEO_SIGR_PERDAS' 
    SET @sql = N'CREATE TABLE ' + @conn_tab + N' (keycol INTEGER)'
    EXEC (@sql)
    SET @conn_tab = N'tempdb.' + USER_NAME() + N'.' + @conn_tab
    SET @node_name = HOST_NAME()
    EXECUTE sde.SDE_pinfo_def_insert @connection_id, 0,
      'Y','Win32',@node_name,'F',@conn_tab

  END
  -- Lock the version's state if this is a open edit.

  IF @edit_action = 1
  BEGIN
    EXECUTE @ret_code = sde.SDE_state_lock_def_insert @connection_id,
                       @state_id, 'Y', 'S'

    IF @ret_code = -49
      SET @ret_code = @SE_LOCK_CONFLICT
    IF @ret_code != 0
    BEGIN
      SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
        + N'_GEO_SIGR_PERDAS' 
      SET @sql = N'DROP TABLE ' + @conn_tab
      EXEC (@sql)
      EXECUTE sde.SDE_pinfo_def_delete @connection_id
      SET @error_string = 'Lock conflict detected for state ' + cast(@state_id as varchar(10))
      RAISERROR (@error_string,16,-1)
      RETURN @ret_code
    END
  END

  DECLARE @state_owner NVARCHAR(32)
  DECLARE @closing_time DATETIME
  DECLARE @parent_lineage_name BIGINT

  DECLARE @current_user NVARCHAR(32)
  EXECUTE sde.SDE_get_current_user_name @current_user OUTPUT

  DECLARE @current_date DATETIME
  SET @current_date = GETDATE ()

  -- Perform version open or close for editing.

  IF @edit_action = 2
  BEGIN
    -- If we are done editing, close the state.
    -- Make sure that the state exists, and that the current user can 
    -- write to it.
    SELECT @state_owner = owner, @closing_time = closing_time
    FROM   sde.SDE_states
    WHERE  state_id = @state_id
    IF @state_owner IS NULL
    BEGIN
      SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
        + N'_GEO_SIGR_PERDAS' 
      SET @sql = N'DROP TABLE ' + @conn_tab
      EXEC (@sql)
      EXECUTE sde.SDE_pinfo_def_delete @connection_id
      SET @error_string = 'State ' + cast (@state_id AS VARCHAR (20)) +
                          ' from version ' + @name + ' not found.'
      RAISERROR (@error_string,16,-1)
      RETURN @SE_STATE_NOEXIST
    END

    DECLARE @is_dba INTEGER
    SET @is_dba = sde.SDE_is_user_sde_dba ()

    IF @is_dba = 0
    BEGIN
      IF @current_user != @state_owner
      BEGIN
        SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
          + N'_GEO_SIGR_PERDAS' 
        SET @sql = N'DROP TABLE ' + @conn_tab
        EXEC (@sql)
        EXECUTE sde.SDE_pinfo_def_delete @connection_id
        SET @error_string = 'Not owner of state ' +
                            cast (@state_id AS VARCHAR (20)) + '.'
        RAISERROR (@error_string,16,-1)
        RETURN @SE_NO_PERMISSIONS
      END
    END

    BEGIN TRAN edit_version
    UPDATE sde.SDE_states
    SET    closing_time = @current_date
    WHERE  state_id = @state_id

    -- The change is made, we can release our locks (incl. mark state locks).

    SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
      + N'_GEO_SIGR_PERDAS' 
    SET @sql = N'DROP TABLE ' + @conn_tab
    EXEC (@sql)
    EXECUTE sde.SDE_pinfo_def_delete @connection_id

    -- Update globals to mark that we're done editing.
    EXECUTE sde.SDE_set_globals @g_state_id,@g_protected,@g_is_default,-1 
  END
  ELSE
  BEGIN
    -- If we starting editing, we will create a child of the current state,
    -- and move this version on to it.

    -- Fetch the information from the version's current state that we need
    -- to create the child state.

    SELECT @state_owner = owner, @closing_time = closing_time,
           @parent_lineage_name = lineage_name
    FROM   sde.SDE_states
    WHERE  state_id = @state_id

    IF @state_owner IS NULL
    BEGIN
      SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
        + N'_GEO_SIGR_PERDAS' 
      SET @sql = N'DROP TABLE ' + @conn_tab
      EXEC (@sql)
      EXECUTE sde.SDE_pinfo_def_delete @connection_id
      SET @error_string = 'State ' + cast (@state_id AS VARCHAR (20)) +
                          ' from version ' + @name + ' not found.'
      RAISERROR (@error_string,16,-1)
      RETURN @SE_STATE_NOEXIST
    END

    -- If the version's current state is open, try to close it

    IF @closing_time IS NULL
    BEGIN
      UPDATE sde.SDE_states
      SET    closing_time = @current_date
      WHERE  state_id = @state_id

    END

    -- Get a state ID.

    DECLARE @new_state_id BIGINT
    EXECUTE sde.SDE_get_primary_oid 8, 1, @new_state_id OUTPUT

    -- Create the new state.

    EXECUTE sde.SDE_state_def_insert  @new_state_id, @current_user,
                       @state_id, @parent_lineage_name,
                      @connection_id, 1, @current_date

    -- Unlock the parent state -- we don't need it any longer.

    EXECUTE sde.SDE_state_lock_def_delete @connection_id, @state_id, 'Y', 0
    -- Move the version to the new state.

    EXECUTE sde.SDE_versions_def_change_state @new_state_id, @parsed_name,
            @parsed_owner, @state_id
    IF @@ROWCOUNT = 0
    BEGIN
      -- determine if the version has been deleted or if it has
      -- already been changed
      SET @version_id = NULL
      SELECT @version_id = version_id
      FROM   sde.SDE_versions
      WHERE  name = @parsed_name AND
            owner = @parsed_owner

      IF @version_id IS NULL
      BEGIN
        SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
          + N'_GEO_SIGR_PERDAS' 
        SET @sql = N'DROP TABLE ' + @conn_tab
        EXEC (@sql)
        EXECUTE sde.SDE_pinfo_def_delete @connection_id
        SET @error_string = 'Version ' + @name + ' not found.'
        RAISERROR (@error_string,16,-1)
        RETURN @SE_VERSION_NOEXIST
      END
      ELSE
      BEGIN
        SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
          + N'_GEO_SIGR_PERDAS' 
        SET @sql = N'DROP TABLE ' + @conn_tab
        EXEC (@sql)
        EXECUTE sde.SDE_pinfo_def_delete @connection_id
        SET @error_string = 'Version ' + @name + ' is no longer state ' +
                            cast (@state_id AS VARCHAR (10)) + '.'
        RAISERROR (@error_string,16,-1)
        RETURN @SE_VERSION_HAS_MOVED
      END
    END

    -- Now lock the new state with a persistent lock
    EXECUTE @ret_code = sde.SDE_state_lock_def_insert @connection_id,
                       @new_state_id, 'Y', 'E'

    IF @ret_code = -49
      SET @ret_code = @SE_LOCK_CONFLICT
    IF @ret_code != 0
    BEGIN
      SET @conn_tab = N'##SDE_' + CAST(@connection_id as NVARCHAR(10))
        + N'_GEO_SIGR_PERDAS' 
      SET @sql = N'DROP TABLE ' + @conn_tab
      EXEC (@sql)
      EXECUTE sde.SDE_pinfo_def_delete @connection_id
      SET @error_string = 'Lock conflict detected for state ' + cast(@new_state_id as varchar(10))
      RAISERROR (@error_string,16,-1)
      RETURN @ret_code
    END
    -- Set the now editable version as the current version.

  EXECUTE sde.SDE_set_globals @new_state_id,@protected,'0',@version_id 
  END

  -- do a hard commit, even if called within a transaction.
  while @@TRANCOUNT > 0
    COMMIT

END

GO
/****** Object:  StoredProcedure [sde].[gdb_util_release]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[gdb_util_release] AS SELECT 3
GO
/****** Object:  StoredProcedure [sde].[geometry_columns]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[geometry_columns]
@owner NVARCHAR(128), @table NVARCHAR(128)
AS SET NOCOUNT ON
BEGIN
SELECT c.name column_name FROM sys.objects o INNER JOIN sys.columns c
  INNER JOIN sys.types t
  ON c.user_type_id = t.user_type_id AND c.user_type_id = t.user_type_id
  ON c.object_id = o.object_id 
  WHERE t.name in ('geometry','geography')
  AND c.object_id = OBJECT_ID(@owner + '.' + @table)
END

GO
/****** Object:  StoredProcedure [sde].[geometry_type]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[geometry_type]
@owner NVARCHAR(128), @table NVARCHAR(128), @column NVARCHAR(128)
AS SET NOCOUNT ON
BEGIN
DECLARE @eflags INT
DECLARE @type_tab AS TABLE (type_names NVARCHAR(128))
DECLARE @type AS NVARCHAR(128)
DECLARE @zm AS NVARCHAR(3)
DECLARE @multi AS NVARCHAR(5)

-- Check if it's a registered layer
SELECT @eflags = eflags FROM sde.SDE_layers 
WHERE owner = @owner AND table_name = @table AND spatial_column = @column

IF @@ROWCOUNT = 1
BEGIN
  -- Decode eflags to determine shape type
  IF (@eflags & 262144) > 0
    SET @multi = N'MULTI'
  ELSE
    SET @multi = N''

  SET @zm = N''
  IF (@eflags & 65536) > 0
    SET @zm = @zm + N' Z'
  IF (@eflags & 524288) > 0
  BEGIN
    IF @zm = ''
      SET @zm = @zm + N' M'
    ELSE
      SET @zm = @zm + N'M'
  END

  IF (@eflags & 1) > 0
    INSERT INTO @type_tab (type_names) VALUES (N'NIL')

  IF (@eflags & 2) > 0
    INSERT INTO @type_tab (type_names) VALUES (@multi + N'POINT' + @zm)

  IF (@eflags & 4) > 0
    INSERT INTO @type_tab (type_names) VALUES (@multi + N'LINESTRING' + @zm)

  IF (@eflags & 8) > 0
    INSERT INTO @type_tab (type_names) VALUES (@multi + N'SIMPLELINESTRING' + @zm)

  IF (@eflags & 16) > 0
    INSERT INTO @type_tab (type_names) VALUES (@multi + N'POLYGON' + @zm)

  SELECT type_names AS geometry_type from @type_tab

END
ELSE
BEGIN
  -- Not a registered layer, check if it's a spatial column
  DECLARE @spatial_type VARCHAR(128)
  SELECT @spatial_type = CAST (t.name AS VARCHAR(128)) 
    FROM sys.objects o INNER JOIN sys.columns c INNER JOIN sys.types t
    ON c.user_type_id = t.user_type_id AND c.user_type_id = t.user_type_id 
    ON c.object_id = o.object_id 
    WHERE c.object_id = OBJECT_ID(@owner + '.' + @table) AND c.name = @column

  IF (@spatial_type IS NULL OR (@spatial_type != 'geometry' AND @spatial_type != 'geography'))
  BEGIN
    DECLARE @errstr varchar (256)
    SET @errstr = 'Spatial column ' + @owner + '.' + @table + '.' + @column + ' does not exist.'
    RAISERROR (@errstr,16,-1)
    RETURN
  END

  -- Let's fetch the first shape
  DECLARE @sql NVARCHAR (1024)
  SET @sql = 'SELECT TOP 1 UPPER (' + @column + '.STGeometryType()) AS geometry_type FROM ' + @owner + '.' + @table +
             ' WHERE ' + @column + ' IS NOT NULL'
  EXEC (@sql)
END
END

GO
/****** Object:  StoredProcedure [sde].[get_extent]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[get_extent]
@owner NVARCHAR(128), @table NVARCHAR(128), @column NVARCHAR(128),
@minx DOUBLE PRECISION OUTPUT, @miny DOUBLE PRECISION OUTPUT,
@maxx DOUBLE PRECISION OUTPUT, @maxy DOUBLE PRECISION OUTPUT
AS SET NOCOUNT ON
BEGIN
DECLARE @layer_table NVARCHAR (128)
DECLARE @get_meta_extent INT
DECLARE @errstr varchar (256)

SET @get_meta_extent = 0 --Assume no metadata
SET @layer_table = @table

SELECT @layer_table = table_name FROM sde.SDE_table_registry
  WHERE owner = @owner AND table_name = @table
IF @@ROWCOUNT = 0
BEGIN
  SELECT @layer_table = table_name FROM sde.SDE_table_registry
    WHERE owner = @owner AND imv_view_name = @table
  IF @@ROWCOUNT > 0
    SET @get_meta_extent = 1
END
ELSE
  SET @get_meta_extent = 1

IF @get_meta_extent = 1
BEGIN
  -- table is registered, see if it's in the layers table
  SELECT @minx = minx, @miny = miny, @maxx = maxx, @maxy = maxy 
  FROM sde.SDE_layers l
  WHERE l.owner = @owner and l.table_name = @layer_table AND l.spatial_column = @column
  IF @@ROWCOUNT > 0
    RETURN -- we're done!
END

-- Need to calculate the extent. Check if it's a geometry or geography

DECLARE @spatial_type NVARCHAR(128)
SELECT @spatial_type = DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
  WHERE  table_schema = @owner AND table_name = @layer_table AND column_name = @column
IF @@ROWCOUNT = 0
BEGIN
  SET @errstr = 'Class ' + @owner + '.' + @table + '.' + @column + ' does not exist.'
  RAISERROR (@errstr,16,-1)
  RETURN
END
-- Calculate the extent
DECLARE @sql NVARCHAR (1024)
IF @spatial_type = 'geometry' 
BEGIN
  SET @sql = 
    'SELECT @lminx = MIN(((' + @column + '.STEnvelope()).STPointN(1)).STX),' + 
    ' @lminy = MIN(((' + @column + '.STEnvelope()).STPointN(1)).STY),' + 
    ' @lmaxx = MAX(((' + @column + '.STEnvelope()).STPointN(3)).STX),' + 
    ' @lmaxy = MAX(((' + @column + '.STEnvelope()).STPointN(3)).STY) ' + 
    'FROM ' + @owner + '.' + @layer_table +
    ' WHERE ' + @column + ' IS NOT NULL'
  EXECUTE sp_executesql @sql, N'@lminx double precision output,@lminy double precision output,@lmaxx double precision output,@lmaxy double precision output',
  @lminx = @minx output,@lminy = @miny output,@lmaxx = @maxx output, @lmaxy = @maxy output
END
ELSE
BEGIN
  IF @spatial_type = 'geography'
  BEGIN
    SET @sql = 
      'SELECT @lminx = MIN(((geometry::STGeomFromWKB(' + @column + '.STAsBinary(),' + @column + '.STSrid).STEnvelope()).STPointN(1)).STX),' + 
      '  @lminy = MIN(((geometry::STGeomFromWKB(' + @column + '.STAsBinary(),' + @column + '.STSrid).STEnvelope()).STPointN(1)).STY),' + 
      '  @lmaxx = MAX(((geometry::STGeomFromWKB(' + @column + '.STAsBinary(),' + @column + '.STSrid).STEnvelope()).STPointN(3)).STX),' + 
      '  @lmaxy = MAX(((geometry::STGeomFromWKB(' + @column + '.STAsBinary(),' + @column + '.STSrid).STEnvelope()).STPointN(3)).STY) ' + 
      'FROM ' + @owner + '.' + @layer_table +
      ' WHERE ' + @column + ' IS NOT NULL'
    EXECUTE sp_executesql @sql, N'@lminx double precision output,@lminy double precision output,@lmaxx double precision output,@lmaxy double precision output',
    @lminx = @minx output,@lminy = @miny output,@lmaxx = @maxx output, @lmaxy = @maxy output
  END
  ELSE
  BEGIN
    SET @errstr = 'Column ' + @owner + '.' + @table + '.' + @column + ' is not a geometry or geography column.'
    RAISERROR (@errstr,16,-1)
    RETURN
  END
END
END

GO
/****** Object:  StoredProcedure [sde].[get_filtered_table_names]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[get_filtered_table_names]
AS SET NOCOUNT ON
BEGIN
SELECT SCHEMA_NAME(o.schema_id) + '.' + o.name
FROM sys.objects o
WHERE o.type IN ('U','V') AND 
  (has_perms_by_name (SCHEMA_NAME(o.schema_id) + '.' + o.name,'OBJECT','SELECT') = 1)
  AND o.name NOT LIKE 'GDB_%%'
  AND o.name NOT LIKE 'f[1-9]%%'
  AND o.name NOT LIKE 's[1-9]%%'
  AND o.name NOT LIKE 'a[1-9]%%'
  AND o.name NOT LIKE 'd[1-9]%%'
  AND o.name NOT LIKE 'i[1-9]%%'
  AND o.name NOT LIKE 'sde_%%'
  AND o.name NOT LIKE '%%_H'
  AND o.name NOT LIKE 'ST_%%'
  AND o.name != 'dbtune'
END

GO
/****** Object:  StoredProcedure [sde].[i100_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i100_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i100 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i100 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i100 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i100 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i100
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i100 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i100 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i100_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i100_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i100 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i100 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i100 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i101_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i101_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i101 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i101 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i101 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i101 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i101
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i101 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i101 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i101_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i101_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i101 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i101 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i101 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i102_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i102_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i102 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i102 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i102 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i102 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i102
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i102 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i102 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i102_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i102_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i102 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i102 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i102 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i2_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i2_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i2 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i2 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i2 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i2 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i2
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i2 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i2 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i2_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i2_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i2 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i2 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i2 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i3_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i3_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i3 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i3 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i3 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i3 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i3
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i3 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i3 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i3_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i3_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i3 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i3 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i3 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i38_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i38_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i38 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i38 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i38 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i38 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i38
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i38 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i38 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i38_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i38_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i38 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i38 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i38 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i39_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i39_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i39 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i39 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i39 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i39 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i39
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i39 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i39 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i39_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i39_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i39 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i39 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i39 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i4_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i4_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i4 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i4 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i4 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i4 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i4
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i4 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i4 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i4_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i4_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i4 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i4 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i4 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i40_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i40_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i40 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i40 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i40 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i40 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i40
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i40 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i40 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i40_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i40_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i40 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i40 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i40 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i41_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i41_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i41 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i41 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i41 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i41 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i41
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i41 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i41 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i41_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i41_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i41 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i41 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i41 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i42_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i42_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i42 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i42 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i42 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i42 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i42
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i42 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i42 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i42_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i42_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i42 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i42 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i42 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i43_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i43_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i43 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i43 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i43 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i43 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i43
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i43 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i43 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i43_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i43_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i43 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i43 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i43 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i44_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i44_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i44 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i44 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i44 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i44 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i44
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i44 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i44 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i44_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i44_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i44 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i44 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i44 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i45_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i45_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i45 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i45 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i45 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i45 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i45
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i45 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i45 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i45_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i45_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i45 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i45 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i45 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i46_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i46_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i46 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i46 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i46 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i46 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i46
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i46 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i46 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i46_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i46_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i46 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i46 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i46 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i47_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i47_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i47 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i47 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i47 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i47 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i47
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i47 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i47 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i47_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i47_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i47 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i47 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i47 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i48_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i48_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i48 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i48 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i48 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i48 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i48
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i48 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i48 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i48_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i48_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i48 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i48 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i48 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i49_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i49_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i49 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i49 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i49 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i49 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i49
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i49 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i49 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i49_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i49_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i49 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i49 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i49 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i5_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i5_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i5 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i5 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i5 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i5 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i5
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i5 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i5 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i5_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i5_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i5 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i5 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i5 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i50_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i50_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i50 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i50 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i50 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i50 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i50
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i50 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i50 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i50_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i50_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i50 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i50 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i50 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i51_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i51_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i51 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i51 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i51 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i51 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i51
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i51 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i51 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i51_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i51_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i51 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i51 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i51 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i53_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i53_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i53 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i53 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i53 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i53 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i53
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i53 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i53 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i53_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i53_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i53 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i53 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i53 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i54_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i54_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i54 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i54 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i54 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i54 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i54
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i54 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i54 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i54_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i54_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i54 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i54 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i54 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i56_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i56_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i56 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i56 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i56 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i56 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i56
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i56 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i56 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i56_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i56_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i56 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i56 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i56 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i58_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i58_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i58 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i58 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i58 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i58 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i58
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i58 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i58 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i58_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i58_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i58 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i58 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i58 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i59_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i59_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i59 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i59 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i59 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i59 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i59
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i59 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i59 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i59_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i59_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i59 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i59 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i59 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i6_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i6_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i6 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i6 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i6 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i6 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i6
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i6 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i6 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i6_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i6_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i6 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i6 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i6 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i60_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i60_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i60 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i60 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i60 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i60 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i60
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i60 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i60 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i60_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i60_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i60 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i60 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i60 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i61_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i61_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i61 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i61 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i61 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i61 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i61
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i61 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i61 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i61_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i61_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i61 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i61 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i61 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i66_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i66_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i66 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i66 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i66 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i66 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i66
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i66 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i66 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i66_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i66_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i66 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i66 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i66 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i67_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i67_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i67 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i67 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i67 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i67 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i67
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i67 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i67 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i67_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i67_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i67 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i67 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i67 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i68_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i68_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i68 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i68 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i68 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i68 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i68
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i68 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i68 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i68_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i68_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i68 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i68 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i68 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i69_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i69_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i69 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i69 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i69 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i69 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i69
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i69 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i69 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i69_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i69_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i69 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i69 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i69 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i71_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i71_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i71 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i71 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i71 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i71 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i71
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i71 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i71 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i71_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i71_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i71 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i71 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i71 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i73_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i73_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i73 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i73 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i73 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i73 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i73
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i73 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i73 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i73_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i73_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i73 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i73 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i73 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i74_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i74_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i74 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i74 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i74 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i74 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i74
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i74 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i74 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i74_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i74_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i74 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i74 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i74 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i75_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i75_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i75 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i75 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i75 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i75 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i75
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i75 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i75 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i75_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i75_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i75 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i75 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i75 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i76_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i76_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i76 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i76 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i76 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i76 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i76
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i76 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i76 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i76_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i76_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i76 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i76 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i76 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i77_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i77_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i77 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i77 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i77 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i77 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i77
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i77 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i77 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i77_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i77_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i77 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i77 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i77 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i80_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i80_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i80 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i80 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i80 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i80 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i80
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i80 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i80 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i80_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i80_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i80 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i80 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i80 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i81_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i81_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i81 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i81 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i81 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i81 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i81
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i81 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i81 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i81_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i81_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i81 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i81 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i81 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i82_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i82_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i82 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i82 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i82 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i82 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i82
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i82 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i82 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i82_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i82_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i82 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i82 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i82 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i83_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i83_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i83 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i83 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i83 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i83 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i83
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i83 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i83 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i83_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i83_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i83 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i83 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i83 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i84_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i84_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i84 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i84 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i84 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i84 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i84
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i84 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i84 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i84_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i84_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i84 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i84 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i84 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i85_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i85_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i85 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i85 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i85 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i85 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i85
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i85 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i85 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i85_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i85_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i85 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i85 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i85 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i86_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i86_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i86 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i86 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i86 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i86 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i86
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i86 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i86 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i86_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i86_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i86 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i86 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i86 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i87_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i87_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i87 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i87 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i87 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i87 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i87
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i87 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i87 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i87_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i87_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i87 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i87 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i87 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i88_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i88_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i88 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i88 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i88 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i88 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i88
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i88 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i88 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i88_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i88_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i88 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i88 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i88 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i93_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i93_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i93 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i93 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i93 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i93 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i93
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i93 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i93 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i93_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i93_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i93 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i93 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i93 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i94_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i94_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id bigint OUTPUT,
@num_obtained_ids integer OUTPUT,
@64bit_rowid integer = 0 AS SET NOCOUNT ON
BEGIN
  DECLARE @int_overflow INTEGER
  DECLARE @max_int INTEGER
  SET @int_overflow = 0
  SET @max_int = 2147483647
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i94 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i94 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i94 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i94 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* Check for INTEGER OVERFLOW if not 64bit ROWID enabled */
        IF (@64bit_rowid = 0 AND (@base_id + @num_obtained_ids) > @max_int)
          SET @int_overflow = 1
        ELSE
          /* update the last id and base id */
          UPDATE SDE.i94
            SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
            WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          /* Check for INTEGER OVERFLOW if not 64bit ROWID enabled */
          IF (@64bit_rowid = 0 AND (@base_id + @num_obtained_ids) > @max_int)
            SET @int_overflow = 1
          ELSE
            UPDATE SDE.i94 SET base_id = base_id + 1,
              num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Check for INTEGER OVERFLOW if not 64bit ROWID enabled */
          IF (@64bit_rowid = 0 AND (@base_id + @num_obtained_ids) > @max_int)
            SET @int_overflow = 1
          ELSE
            /* Return the whole fragment, delete the the row */
            DELETE FROM SDE.i94 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
  /* throw error for integer overflow */
  IF (@int_overflow = 1)
    RAISERROR (N'INTEGER OVERFLOW', 16, -1)
END 
GO
/****** Object:  StoredProcedure [sde].[i94_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i94_return_ids]
@id_type integer,
@base_id bigint,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id bigint
  DECLARE @fetched_base_id bigint
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i94 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i94 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i94 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i98_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i98_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i98 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i98 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i98 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i98 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i98
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i98 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i98 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i98_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i98_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i98 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i98 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i98 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[i99_get_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i99_get_ids]
@id_type integer,
@num_requested_ids integer,
@base_id integer OUTPUT,
@num_obtained_ids integer OUTPUT AS SET NOCOUNT ON
BEGIN
  IF (@num_requested_ids < 0)
  BEGIN 
    BEGIN TRAN id_tran
    /* We are resetting the generator. */
    /* Delete fragments and update the base value.*/
    UPDATE SDE.i99 WITH  (tablockx, holdlock)
      SET base_id = base_id + @num_requested_ids
      WHERE num_ids = -1 AND id_type = @id_type
    DELETE FROM SDE.i99 WHERE id_type = @id_type and num_ids <> -1
    COMMIT TRAN id_tran /* releases holdlock table lock */
  END
  ELSE
  BEGIN
    IF (@num_requested_ids > 0)
    BEGIN
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i99 WITH (tablockx, holdlock)
        WHERE id_type = @id_type
        ORDER BY num_ids DESC /* ensures that fragments come first */
        FOR UPDATE /* to get a lock */
    END
    ELSE
    BEGIN
      /* only interested in base id */
      DECLARE I_cursor CURSOR FOR
        SELECT base_id, num_ids
        FROM SDE.i99 WITH (tablockx, holdlock)
        WHERE id_type = @id_type AND num_ids = -1
        FOR UPDATE /* to get a lock */
    END
    BEGIN TRAN id_tran
    OPEN I_cursor
    FETCH NEXT FROM I_cursor INTO @base_id, @num_obtained_ids
    IF (@num_requested_ids = 0)
    BEGIN
      /* Just getting current value */
      SET @num_obtained_ids = 0
    END
    ELSE
    BEGIN
      IF (@num_obtained_ids = -1)
      BEGIN
        /* user got the amount they wanted */
        SET @num_obtained_ids = @num_requested_ids
        /* update the last id and base id */
        UPDATE SDE.i99
          SET base_id = base_id + @num_obtained_ids,
              last_id =  @base_id
          WHERE CURRENT OF I_cursor
      END
      ELSE
      BEGIN
        /* user got a fragment */
        IF (@num_requested_ids = 1) AND (@num_obtained_ids > 1)
        BEGIN
          /* they want one and exactly one id */
          SET @num_obtained_ids = 1
          UPDATE SDE.i99 SET base_id = base_id + 1,
            num_ids =  num_ids - 1 WHERE CURRENT OF I_cursor
        END
        ELSE
        BEGIN
          /* Return the whole fragment, delete the the row */
          DELETE FROM SDE.i99 WHERE CURRENT OF I_cursor
        END
      END
    END
    CLOSE I_cursor
    COMMIT TRAN id_tran /* releases holdlock table lock */
    DEALLOCATE I_cursor
  END
END 
GO
/****** Object:  StoredProcedure [sde].[i99_return_ids]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[i99_return_ids]
@id_type integer,
@base_id integer,
@num_ids integer
AS SET NOCOUNT ON
BEGIN
  DECLARE @last_id integer
  DECLARE @fetched_base_id integer
  BEGIN TRAN id_tran
  SELECT @last_id = last_id, @fetched_base_id = base_id
    FROM SDE.i99 WITH (tablockx, holdlock)
    WHERE num_ids = -1 AND id_type = @id_type
  IF ( (@last_id < @base_id) AND
       ((@base_id + @num_ids) = @fetched_base_id))
  BEGIN
    /* only return ids if no one else has grabbed a block
       and were returning the remainder of the block. */
    UPDATE SDE.i99 SET base_id = @base_id
       WHERE num_ids = -1 AND id_type = @id_type
  END
  ELSE
  BEGIN
    /* Insert a new fragment */
    INSERT INTO SDE.i99 (base_id, num_ids, id_type)
      VALUES (@base_id, @num_ids, @id_type)
  END
  COMMIT TRAN id_tran /* releases holdlock table lock */
END
GO
/****** Object:  StoredProcedure [sde].[isGeoDatabase]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[isGeoDatabase]
@isgdb VARCHAR(5) OUTPUT
AS SET NOCOUNT ON
BEGIN
DECLARE @intval INT
-- check if current database is a gdb
SELECT @intval = 1 FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'GDB_TABLES_LAST_MODIFIED' AND TABLE_SCHEMA IN ('sde','dbo')
IF @@ROWCOUNT = 0
BEGIN
  BEGIN TRY
    -- check if this database is part of a multi-db sde database. We need to wrap
    -- this statement in an execute block, since try/catch does not catch name
    -- resolution errors.
    DECLARE @count int
    DECLARE @sql NVARCHAR(256)
    SET @sql = N'SELECT @intval = count(*) FROM sde.sde.SDE_table_registry
                 WHERE database_name = ''' +  DB_NAME() + N''''
    EXECUTE sp_executesql @sql, N'@intval integer output', @intval = @count output
    IF @count > 0
      SET @isgdb = 'TRUE'
    ELSE
      SET @isgdb = 'FALSE'
  END TRY
  BEGIN CATCH
    -- sde database doesn't exist or we don't have login permission
    SET @isgdb = 'FALSE'
  END CATCH
END
ELSE
  SET @isgdb = 'TRUE'
END

GO
/****** Object:  StoredProcedure [sde].[next_globalid]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[next_globalid]
@guid NVARCHAR(38) OUTPUT
AS SET NOCOUNT ON
BEGIN
SELECT @guid =  '{' + CAST (NEWID() AS NVARCHAR(38)) + '}'
END

GO
/****** Object:  StoredProcedure [sde].[next_rowid]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[next_rowid]
@owner NVARCHAR(128), @table NVARCHAR(128), @rowid INT OUTPUT
AS SET NOCOUNT ON
BEGIN
DECLARE @regid INT
DECLARE @newid INT
DECLARE @sql NVARCHAR (1024)
SELECT @regid = registration_id FROM sde.SDE_table_registry  WHERE owner = @owner AND table_name = @table
IF @@ROWCOUNT = 0
BEGIN
  SELECT @regid = registration_id FROM sde.SDE_table_registry    WHERE owner = @owner AND imv_view_name = @table
  IF @@ROWCOUNT = 0
  BEGIN
    DECLARE @errstr VARCHAR (256)
    SET @errstr = 'Class ' + @table + ' not registered to the Geodatabase.'
    RAISERROR (@errstr,16,-1)
    RETURN
  END
END
SET @sql = 
'DECLARE @num_ids INT ' +
'EXEC ' + @owner + '.i' +cast (@regid AS VARCHAR(10)) + '_get_ids 2,1,@newid OUTPUT,@num_ids OUTPUT'
EXECUTE sp_executesql @sql, N'@newid INTEGER OUTPUT', @newid = @rowid OUTPUT
END

GO
/****** Object:  StoredProcedure [sde].[SDE_archives_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_archives_def_delete]
@archivingRegIdVal INTEGER AS SET NOCOUNT ON
BEGIN
DELETE FROM sde.SDE_archives WHERE archiving_regid =  @archivingRegIdVal
END

GO
/****** Object:  StoredProcedure [sde].[SDE_archives_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_archives_def_insert]
@archivingRegIdVal INTEGER, @historyRegIdVal INTEGER,
@fromDateVal NVARCHAR(32),
@toDateVal NVARCHAR(32),
@archiveDateVal BIGINT, @archiveFlagsVal BIGINT
AS SET NOCOUNT ON
BEGIN
INSERT INTO sde.SDE_archives
  (archiving_regid,history_regid,from_date,to_date,archive_date,archive_flags) VALUES
  (@archivingRegIdVal,@historyRegIdVal,@fromDateVal,@toDateVal,@archiveDateVal,@archiveFlagsVal)
END

GO
/****** Object:  StoredProcedure [sde].[SDE_col_registry_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_col_registry_def_update]        @dbNameVal NVARCHAR(32), @tabNameVal sysname, @ownerVal NVARCHAR(32),       @colNameVal NVARCHAR(32), @sdeTypeVal INTEGER, @colSizeVal INTEGER,        @decDigitVal INTEGER, @descVal NVARCHAR(65), @objFlagsVal INTEGER,       @objIdVal INTEGER, @oldColNameVal NVARCHAR(32) AS SET NOCOUNT ON       UPDATE sde.SDE_column_registry SET column_name = @colNameVal, sde_type = @sdeTypeVal,       column_size = @colSizeVal,        decimal_digits = @decDigitVal, description = @descVal,       object_flags = @objFlagsVal ,object_id = @objIdVal        WHERE database_name = @dbNameVal AND table_name = @tabNameVal AND              owner = @ownerVal AND column_name = @oldColNameVal 
GO
/****** Object:  StoredProcedure [sde].[SDE_column_registry_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_column_registry_def_delete]                         @dbNameVal NVARCHAR(32), @tabNameVal sysname,                         @ownerVal NVARCHAR(32), @colNameVal NVARCHAR(32) AS                         SET NOCOUNT ON DELETE FROM sde.SDE_column_registry WHERE                         database_name = @dbNameVal AND table_name = @tabNameVal AND                         owner = @ownerVal AND column_name = @colNameVal 
GO
/****** Object:  StoredProcedure [sde].[SDE_column_registry_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_column_registry_def_insert]        @dbNameVal NVARCHAR(32), @tabNameVal sysname, @ownerVal NVARCHAR(32),       @colNameVal NVARCHAR(32), @sdeTypeVal INTEGER, @colSizeVal INTEGER,        @decDigitVal INTEGER, @descVal NVARCHAR(65), @objFlagsVal INTEGER,       @objIdVal INTEGER AS SET NOCOUNT ON       INSERT INTO sde.SDE_column_registry (database_name, table_name, owner, column_name, sde_type,        column_size, decimal_digits,description,object_flags, object_id )        VALUES ( @dbNameVal, @tabNameVal, @ownerVal, @colNameVal, @sdeTypeVal,        @colSizeVal ,@decDigitVal, @descVal, @objFlagsVal, @objIdVal)
GO
/****** Object:  StoredProcedure [sde].[SDE_column_registry_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_column_registry_def_update]        @dbNameVal NVARCHAR(32), @tabNameVal sysname, @ownerVal NVARCHAR(32),       @colNameVal NVARCHAR(32), @sdeTypeVal INTEGER, @colSizeVal INTEGER,        @decDigitVal INTEGER, @descVal NVARCHAR(65), @objFlagsVal INTEGER,       @objIdVal INTEGER AS SET NOCOUNT ON       UPDATE sde.SDE_column_registry SET sde_type = @sdeTypeVal, column_size = @colSizeVal,        decimal_digits = @decDigitVal, description = @descVal,       object_flags = @objFlagsVal ,object_id = @objIdVal        WHERE database_name = @dbNameVal AND table_name = @tabNameVal AND              owner = @ownerVal AND column_name = @colNameVal 
GO
/****** Object:  StoredProcedure [sde].[SDE_current_version_not_default]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_current_version_not_default] @current_state BIGINT AS 
SET NOCOUNT ON BEGIN
--This is a private support procedure for SDE versioned views.
--Check for default version.
  DECLARE @count INTEGER
  SELECT @count = count(*)
  FROM   sde.SDE_versions 
  WHERE  name = 'DEFAULT' AND owner = 'sde' AND state_id = @current_state
IF @count = 1
BEGIN
  DECLARE @error_string NVARCHAR(256)
  SET @error_string = 'You may not update this view on an ' +
                      'archiving table in the DEFAULT version.'
  RAISERROR (@error_string,16,-1)
  RETURN -1
END
RETURN 0
END

GO
/****** Object:  StoredProcedure [sde].[SDE_current_version_writable]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_current_version_writable] @current_state BIGINT OUTPUT AS 
SET NOCOUNT ON BEGIN
--This is a private support procedure for SDE versioned views.
DECLARE @context_info VARCHAR(128)
SELECT @context_info = CAST (context_info AS VARCHAR(128))
FROM sys.dm_exec_sessions
WHERE session_id = @@SPID AND CAST (context_info AS VARCHAR(128)) like 'SDE%'
DECLARE @protected CHAR (1)
DECLARE @delimiter INTEGER
IF @context_info IS NULL
  SET @delimiter = 0
ELSE
BEGIN
  SET @delimiter = charindex (',', @context_info)
  IF @delimiter != 0 -- move past the SDE token
    SET @delimiter = charindex (',', @context_info, @delimiter + 1)
END
IF @delimiter = 0
BEGIN
  -- No context info set, so we're working off the default version.
  DECLARE @status INTEGER
  SELECT @current_state = v.state_id, @status = v.status
  FROM   sde.SDE_versions v
  WHERE  v.name = 'DEFAULT' AND v.owner = 'sde'
  SET @protected = sde.SDE_get_version_access (@status, 'sde')
END
ELSE
BEGIN
  SET @protected = substring (@context_info, @delimiter + 1, 1)
  DECLARE @sde_delimiter INTEGER
  SET @sde_delimiter = charindex (',', @context_info)
  SET @current_state = CAST (substring (@context_info, @sde_delimiter + 1,
      @delimiter - @sde_delimiter - 1) AS BIGINT)
END
DECLARE @error_string NVARCHAR(256)
IF @protected = '1'
BEGIN
    SET @error_string = 'Current version is protected, and you ' +
                        'are not the owner.'
    RAISERROR (@error_string,16,-1)
    RETURN -1
END
-- Make sure that the state exists, and that the current user can write 
-- to it.
DECLARE @owner NVARCHAR (128)
DECLARE @closing_time DATETIME
SELECT @owner = owner, @closing_time = closing_time
FROM sde.SDE_states
WHERE state_id = @current_state
IF (@owner IS NULL)
BEGIN
  SET @error_string = 'State ' + cast (@current_state AS VARCHAR (20)) +
                      ' not found.'
  RAISERROR (@error_string,16,-1)
  RETURN -1
END
DECLARE @user NVARCHAR (128)
EXECUTE sde.SDE_get_current_user_name @user OUTPUT 
IF @user != @owner
BEGIN
  DECLARE @is_dba INTEGER
  SET @is_dba = sde.SDE_is_user_sde_dba ()
  IF @is_dba = 0
  BEGIN
    SET @error_string = 'Not owner of state ' +
                        CAST (@current_state AS VARCHAR (20)) + '.'
    RAISERROR (@error_string,16,-1)
    RETURN -1
  END
END
IF @closing_time IS NOT NULL 
BEGIN
  SET @error_string = 'State ' + CAST (@current_state AS VARCHAR (20)) +
                      ' is closed.'
  RAISERROR (@error_string,16,-1)
  RETURN -1
END
RETURN 0
END

GO
/****** Object:  StoredProcedure [sde].[SDE_dbtune_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_dbtune_def_delete]       @keywordVal NVARCHAR(32),@parameter_nameVal NVARCHAR(32)       AS SET NOCOUNT OFF IF (@parameter_nameVal IS NULL)        DELETE FROM sde.SDE_dbtune WHERE keyword = @keywordVal      ELSE DELETE FROM sde.SDE_dbtune WHERE keyword = @keywordVal AND           parameter_name = @parameter_nameVal
GO
/****** Object:  StoredProcedure [sde].[SDE_dbtune_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_dbtune_def_insert]       @keywordVal NVARCHAR(32),@parameter_nameVal NVARCHAR(32),       @config_stringVal NVARCHAR(2048) AS INSERT INTO sde.SDE_dbtune       (keyword,parameter_name,config_string) VALUES       (@keywordVal,@parameter_nameVal,@config_stringVal)
GO
/****** Object:  StoredProcedure [sde].[SDE_dbtune_def_truncate]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_dbtune_def_truncate]       AS SET NOCOUNT ON DELETE FROM sde.SDE_dbtune 
GO
/****** Object:  StoredProcedure [sde].[SDE_dbtune_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_dbtune_def_update]       @keywordVal NVARCHAR(32),@parameter_nameVal NVARCHAR(32),       @config_stringVal NVARCHAR(2048) AS UPDATE sde.SDE_dbtune       SET  config_string = @config_stringVal WHERE       keyword = @keywordVal AND parameter_name = @parameter_nameVal
GO
/****** Object:  StoredProcedure [sde].[SDE_generator_release]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_generator_release] AS SELECT 3 FROM sde.SDE_version
GO
/****** Object:  StoredProcedure [sde].[SDE_geocol_def_change_table_name]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_geocol_def_change_table_name]              @tabNameVal sysname, @layerIdVal INTEGER AS SET NOCOUNT ON             UPDATE sde.SDE_geometry_columns SET f_table_name = @tabNameVal FROM sde.SDE_geometry_columns INNER JOIN sde.SDE_layers ON (            (sde.SDE_geometry_columns.f_table_catalog = sde.SDE_layers.database_name) AND             (sde.SDE_geometry_columns.f_table_schema = sde.SDE_layers.owner) AND             (sde.SDE_geometry_columns.f_table_name = sde.SDE_layers.table_name) AND             (sde.SDE_geometry_columns.f_geometry_column =  sde.SDE_layers.spatial_column) )              WHERE layer_id= @layerIdVal
GO
/****** Object:  StoredProcedure [sde].[SDE_geocol_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_geocol_def_delete]                 @fTableCatalogVal NVARCHAR(32), @fTableSchemaVal NVARCHAR(32),                @fTableNameVal sysname, @fGeometryColumnVal NVARCHAR(32) AS                 SET NOCOUNT ON                BEGIN                BEGIN TRAN geocol_delete                DELETE FROM sde.SDE_geometry_columns WHERE f_table_catalog = @fTableCatalogVal AND                 f_table_schema = @fTableSchemaVal AND                 f_table_name = @fTableNameVal AND                 f_geometry_column = @fGeometryColumnVal                COMMIT TRAN geocol_delete                END
GO
/****** Object:  StoredProcedure [sde].[SDE_geocol_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_geocol_def_insert] @fTabCatVal NVARCHAR(32),     @fTabSchVal NVARCHAR(32), @fTabNameVal sysname, @fGeoColVal NVARCHAR(32), @gTabCatVal     NVARCHAR(32), @gTabSchVal NVARCHAR(32), @gTabNameVal sysname,    @storageTypeVal INTEGER, @geometryTypeVal INTEGER,    @CoordDimensionVal INTEGER, @sridVal INTEGER AS    SET NOCOUNT ON    BEGIN    BEGIN TRAN geocol_insert    INSERT INTO sde.SDE_geometry_columns (f_table_catalog,f_table_schema,f_table_name, f_geometry_column,     g_table_catalog,g_table_schema,g_table_name,storage_type, geometry_type,    coord_dimension, srid) VALUES ( @fTabCatVal, @fTabSchVal,    @fTabNameVal, @fGeoColVal, @gTabCatVal, @gTabSchVal, @gTabNameVal,    @storageTypeVal, @geometryTypeVal, @CoordDimensionVal, @sridVal)    COMMIT TRAN geocol_insert    END
GO
/****** Object:  StoredProcedure [sde].[SDE_geocol_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_geocol_def_update]             @layerIdVal INTEGER, @srTextVal VARCHAR(2048), @xycluster_tolVal FLOAT,            @zcluster_tolVal FLOAT, @mcluster_tolVal FLOAT AS SET NOCOUNT ON            UPDATE sde.SDE_spatial_references SET srtext = @srTextVal,            xycluster_tol = @xycluster_tolVal, zcluster_tol = @zcluster_tolVal,            mcluster_tol = @mcluster_tolVal WHERE srid  in (SELECT srid            FROM sde.SDE_layers WHERE layer_id = @layerIdVal)
GO
/****** Object:  StoredProcedure [sde].[SDE_get_current_user_name]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_get_current_user_name]
@current_user NVARCHAR (128) OUTPUT AS SET NOCOUNT ON
BEGIN
 DECLARE @delimiter INTEGER
 DECLARE @owner NVARCHAR(128)
 -- Get current user name. Format the user name as quoted identifier
 -- if the current user name does not comply with the rules for the format of
 -- regular identifiers

 SET @current_user = user_name()
 SET @delimiter = charindex('~', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex ('.', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex ('%', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex ('^', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex ('(', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex (')', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex ('-', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex ('{', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex ('}', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex (' ', @current_user)
 IF @delimiter = 0
   SET @delimiter = charindex ('\', @current_user)
 IF  @delimiter <> 0
 BEGIN
   SET  @current_user = N'"' + user_name() + N'"'
 END
 -- This stored prcedure will return current user name in upper case format 
 -- if the database is case insenstive. In order to know if the database is case
 -- sensitive, here to compare the @current_user to the same string but in upper 
 -- case. If they are equal, then the database is case insenstive and uppercase 
 -- format of current user name will be returned. 
 SET  @owner = UPPER(@current_user)
 IF  @current_user = @owner 
   SET  @current_user = @owner
END

GO
/****** Object:  StoredProcedure [sde].[SDE_get_globals]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_get_globals] 
@current_state BIGINT OUTPUT,
@protected CHAR(1) OUTPUT,
@is_default CHAR(1) OUTPUT,
@edit_version_id INTEGER OUTPUT,
@state_is_set INTEGER = -1 OUTPUT --optional param
AS SET NOCOUNT ON
BEGIN
  -- This is a private support procedure for SDE versioned views.
  -- 
  -- Context info contains: SDE,current state id,protected,is_default_version,edit_version_id;
  DECLARE @context_info VARCHAR(128)
  DECLARE  @delimiter INTEGER
  SELECT @context_info = CAST (context_info AS VARCHAR(128))
  FROM sys.dm_exec_sessions
  WHERE session_id = @@SPID AND CAST (context_info AS VARCHAR(128)) like 'SDE%'
  IF @context_info IS NULL
    SET @delimiter = 0
  ELSE
  BEGIN
    IF substring (@context_info, 1, 3) != 'SDE'
      SET @delimiter = 0 -- unknown context info
    ELSE
    BEGIN
      SET @delimiter = charindex (',', @context_info)
      IF @delimiter != 0
        -- move past the state id
        SET @delimiter = charindex (',', @context_info, @delimiter + 1)
    END
  END
  IF @delimiter = 0
  BEGIN
    -- No context info set, so we're working off the default version.
    DECLARE @status INTEGER
    SELECT @current_state = v.state_id, @status = v.status
      FROM   sde.SDE_versions v
      WHERE  v.name = 'DEFAULT' AND v.owner = 'sde'
    SET @protected = sde.SDE_get_version_access (@status, 'sde')
    SET @is_default = '1'
    SET @edit_version_id = -1 -- not in edit version mode
    IF (@state_is_set != -1) OR (@state_is_set IS NULL)
      SET @state_is_set = 0 -- not a fixed state
  END
  ELSE
  BEGIN
    SET @current_state = CAST (substring (@context_info, 5,
      @delimiter - 5) AS BIGINT)
    SET @protected = substring (@context_info, @delimiter + 1, 1)
    SET @is_default = substring (@context_info, @delimiter + 3, 1)
    SET @edit_version_id = CAST (substring (@context_info, @delimiter + 5,
      charindex (';', @context_info, @delimiter + 5) - @delimiter - 5 ) AS INTEGER) 
    IF (@state_is_set != -1) OR (@state_is_set IS NULL)
      SET @state_is_set = 1 -- working with a fixed state
  END
END

GO
/****** Object:  StoredProcedure [sde].[SDE_get_primary_oid]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_get_primary_oid]
@id_type INTEGER,
@num_ids INTEGER,
@base_id BIGINT OUTPUT
AS
BEGIN
  DECLARE @baseidTable table (oldbaseid bigint);
  IF @id_type = -1
    SET @base_id = 3
  ELSE
  BEGIN
    BEGIN TRAN id_tran
    /* update the base id */
    UPDATE sde.SDE_object_ids SET base_id = base_id + @num_ids
    OUTPUT Deleted.base_id INTO @baseidTable
    WHERE id_type = @id_type
    SELECT @base_id = oldbaseid FROM @baseidTable
    COMMIT TRAN id_tran /* releases update lock */
  END
END 
GO
/****** Object:  StoredProcedure [sde].[SDE_keyset_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_keyset_delete]
@tableNameVal sysname,
@keysetIdVal INTEGER
AS
BEGIN
BEGIN TRAN keyset_tran
DECLARE @sql AS NVARCHAR(256)
SET @sql = N'DELETE FROM sde.' + @tableNameVal + N'WHERE KEYSET_ID = ' + @keysetIdVal
EXECUTE (@sql)
COMMIT TRAN keyset_tran
END

GO
/****** Object:  StoredProcedure [sde].[SDE_keyset_remove]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_keyset_remove]
@tableNameVal sysname
AS
BEGIN
BEGIN TRAN keyset_tran
DECLARE @sql AS NVARCHAR(256)
SET @sql = N'DROP TABLE sde.' + @tableNameVal
EXECUTE (@sql)
COMMIT TRAN keyset_tran
END

GO
/****** Object:  StoredProcedure [sde].[SDE_last_lineage_mod_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_last_lineage_mod_def_insert]
@lineageNameVal BIGINT,
@newTimeVal DATETIME AS SET NOCOUNT ON
BEGIN TRAN last_lineage_mod_tran
DECLARE @current_time DATETIME
SELECT @current_time = time_last_modified
  FROM sde.SDE_lineages_modified WITH (TABLOCKX, HOLDLOCK)
  WHERE lineage_name = @lineageNameVal
IF @@ROWCOUNT > 0
BEGIN
/* Never let the last_time_modifed remain the same or decrement */
  IF DATEDIFF (second, @current_time, @newTimeVal) <= 0
    SET @newTimeVal = DATEADD(second, 1, @current_time)
  UPDATE sde.SDE_lineages_modified SET time_last_modified = @newTimeVal
    WHERE lineage_name = @lineageNameVal
END
ELSE
  INSERT INTO sde.SDE_lineages_modified (lineage_name, time_last_modified)    VALUES(@lineageNameVal,@newTimeVal)

COMMIT TRAN last_lineage_mod_tran
GO
/****** Object:  StoredProcedure [sde].[SDE_last_modified_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_last_modified_def_update]
@tableNameVal sysname,
@newTimeVal DATETIME OUTPUT AS SET NOCOUNT ON
BEGIN TRAN last_modified_tran
DECLARE @current_time DATETIME
SELECT @current_time = time_last_modified
  FROM sde.SDE_tables_modified WITH (TABLOCKX, HOLDLOCK)
  WHERE table_name = @tableNameVal
IF @@ROWCOUNT = 0
BEGIN
  /* Insert a value for this table */
  INSERT INTO sde.SDE_tables_modified (table_name,time_last_modified)
VALUES (@tableNameVal, @newTimeVal)
END
ELSE
BEGIN
  /* Never let the last_time_modifed remain the same or decrement */
  IF DATEDIFF (second, @current_time, @newTimeVal) <= 0
    SET @newTimeVal = DATEADD(second, 1, @current_time)
  UPDATE sde.SDE_tables_modified SET time_last_modified = @newTimeVal
    WHERE table_name = @tableNameVal
END
COMMIT TRAN last_modified_tran
GO
/****** Object:  StoredProcedure [sde].[SDE_layer_check_lock_conflicts]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_layer_check_lock_conflicts]
@sdeIdVal INTEGER,
@layerIdVal INTEGER,
@autoLockVal VARCHAR(1),
@lockTypeVal VARCHAR(1),
@minxVal BIGINT,
@minyVal BIGINT,
@maxxVal BIGINT,
@maxyVal BIGINT,
@lock_conflict INTEGER OUTPUT AS SET NOCOUNT ON
BEGIN
  DECLARE locks_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT sde_id
    FROM   sde.SDE_layer_locks WITH (TABLOCKX,HOLDLOCK)
    WHERE  layer_id = @layerIdVal AND
           (sde_id <> @sdeIdVal OR
           autolock = @autoLockVal) AND
           (lock_type = 'E' /* E: Exclusive lock */ OR
            @lockTypeVal = 'E') AND
           ((maxx >= @minxVal AND maxy >= @minyVal AND
             @maxxVal >= minx AND @maxyVal >= miny) OR
             (minx IS NULL OR @minxVal IS NULL))
  /* Find any conflicting locks.  The query we use is sensitive about
     whether we are trying to place an exclusive lock (in which case we
     have to consider all locks as possibly conflicting), or a shared lock
     (in which case we only have to worry about conflicting with exclusive
     locks).  In either case, the query will include a range expression so
     composed that a lock with NULL envelope variables will always match
     any other lock.  This is because a NULL envelope indicates a layer-
     wide lock.  With all of the about constraints in place, if any rows
     are returned, we probably have a conflict.  The last thing we have to
     check is if the connection owning the lock has somehow died without
     cleaning up. */
  OPEN locks_cursor
  DECLARE @id INTEGER
  DECLARE @loop_done INTEGER
  SET @lock_conflict = 0
  SET @loop_done = 0
  DECLARE @f_sde_id INTEGER
  WHILE @loop_done = 0
  BEGIN 
    FETCH NEXT FROM locks_cursor INTO @f_sde_id
    IF @@FETCH_STATUS = 0
    BEGIN
      /* We found a matching layer lock.  See if the owning connection
         id is still out there.  If not, then this lock is invalid. */

      SELECT @id = SO.object_id
        FROM tempdb.sys.objects SO INNER JOIN 
            sde.SDE_process_information PR ON object_id (PR.table_name) = SO.object_id
        WHERE PR.sde_id = @f_sde_id

      IF @@ROWCOUNT > 0
      BEGIN
          /* we have a lock conflict! */
          SET @lock_conflict = 1
          SET @loop_done = 1
      END
      ELSE
      BEGIN
          /* defunct connection found, clean it up */
         EXECUTE sde.SDE_pinfo_def_delete @f_sde_id
       END
     END
     ELSE
       SET @loop_done = 1
  END /* while */
  CLOSE locks_cursor
  DEALLOCATE locks_cursor
END

GO
/****** Object:  StoredProcedure [sde].[SDE_layer_def_change_table_name]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_layer_def_change_table_name]              @tabNameVal sysname, @layerIdVal INTEGER AS SET NOCOUNT ON             UPDATE sde.SDE_layers SET              table_name = @tabNameVal  WHERE layer_id = @layerIdVal
GO
/****** Object:  StoredProcedure [sde].[SDE_layer_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_layer_def_delete]               @layer_idVal INTEGER AS SET NOCOUNT ON             DELETE FROM sde.SDE_layers WHERE layer_id = @layer_idVal
GO
/****** Object:  StoredProcedure [sde].[SDE_layer_def_envelope_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_layer_def_envelope_update]              @minxVal FLOAT, @minyVal FLOAT, @maxxVal FLOAT,              @maxyVal FLOAT, @minzVal FLOAT, @maxzVal FLOAT,              @minmVal FLOAT, @maxmVal FLOAT, @layeridVal INTEGER AS              SET NOCOUNT ON              BEGIN             BEGIN TRAN layer_env_update             UPDATE sde.SDE_layers              SET minx = @minxVal,              miny = @minyVal,              maxx = @maxxVal,              maxy = @maxyVal,              minz = @minzVal,              maxz = @maxzVal,              minm = @minmVal,              maxm = @maxmVal              WHERE layer_id = @layeridVal             COMMIT TRAN layer_env_update             END
GO
/****** Object:  StoredProcedure [sde].[SDE_layer_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_layer_def_insert]
@layerIdVal INTEGER, @descVal NVARCHAR(65),@dbNameVal NVARCHAR(32),
@tabNameVal sysname, @ownerVal NVARCHAR(32), @spColVal NVARCHAR(32),
@eflagsVal INTEGER, @layerMaskVal INTEGER, @gsize1Val FLOAT, @gsize2Val FLOAT,
@gsize3Val FLOAT,@minxVal FLOAT,@minyVal FLOAT, @maxxVal FLOAT, @maxyVal FLOAT,
@minzVal FLOAT, @maxzVal FLOAT,@minmVal FLOAT, @maxmVal FLOAT, @cdateVal INTEGER,
@layerConfigVal NVARCHAR(32),@optArraySizeVal INTEGER, @statsDateVal INTEGER,
@minIdVal INTEGER, @sridVal INTEGER, @baseId INTEGER, @secondarySridVal INTEGER AS
SET NOCOUNT ON
BEGIN
BEGIN TRAN layer_insert
INSERT INTO sde.SDE_layers (layer_id,description,database_name,table_name,owner,
spatial_column,eflags,layer_mask,gsize1,gsize2,gsize3,minx,miny,maxx,maxy,
minz,maxz,minm, maxm,cdate,layer_config,optimal_array_size,stats_date,
minimum_id,srid,base_layer_id,secondary_srid) VALUES (@layerIdVal, @descVal,
@dbNameVal, @tabNameVal,
@ownerVal, @spColVal,@eflagsVal, @layerMaskVal, @gsize1Val, @gsize2Val, @gsize3Val,
@minxVal, @minyVal, @maxxVal, @maxyVal,@minzVal, @maxzVal, @minmVal, @maxmVal,
@cdateVal,@layerConfigVal, @optArraySizeVal, @statsDateVal, @minIdVal, @sridVal,
@baseId, @secondarySridVal)
COMMIT TRAN layer_insert
END
GO
/****** Object:  StoredProcedure [sde].[SDE_layer_def_mask_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_layer_def_mask_update]              @maskVal INTEGER, @layeridVal INTEGER AS              SET NOCOUNT ON              BEGIN             BEGIN TRAN layer_mask_update             UPDATE sde.SDE_layers              SET layer_mask = @maskVal              WHERE layer_id = @layeridVal             COMMIT TRAN layer_mask_update             END
GO
/****** Object:  StoredProcedure [sde].[SDE_layer_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_layer_def_update]
@descVal NVARCHAR(65), @g1Val FLOAT, @g2Val FLOAT, @g3Val FLOAT,
@minxVal FLOAT, @minyVal FLOAT, @maxxVal FLOAT, @maxyVal FLOAT,
@minzVal FLOAT, @maxzVal FLOAT, @minmVal FLOAT, @maxmVal FLOAT,
@efVal INTEGER, @layerMaskVal INTEGER, @layerConVal  NVARCHAR(32),
@optArrSize INTEGER, @statDateVal INTEGER, @minIdVal INTEGER,
@layerIdVal INTEGER, @geometryTypeVal INTEGER, @secondarySridVal INTEGER AS
SET NOCOUNT ON
DECLARE @eflag_mask INTEGER
DECLARE @layer_mask INTEGER
DECLARE @cad_mask INTEGER
DECLARE @geom_attr_data_mask INTEGER
DECLARE @spatial_type_mask INTEGER
DECLARE @owner NVARCHAR(128)
DECLARE @sql NVARCHAR(320)

-- @cad_mask = SE_CAD_TYPE_MASK (1L << 22)
SELECT @cad_mask = POWER(2,22)

-- @geom_attr_data_mask = DB_HAS_GEOM_COL_MASK (1L << 25)
SELECT @geom_attr_data_mask = POWER(2,25)

-- @spatial_type_mask = SE_STORAGE_GEOMETRY_TYPE (1L<<27) | SE_STORAGE_GEOGRAPHY_TYPE (1L<<15)
--                    =134250496
SET @spatial_type_mask = POWER(2, 15) | POWER (2,27)

SELECT @owner = owner, @eflag_mask = eflags, @layer_mask = layer_mask from sde.SDE_layers where layer_id = @layerIdVal
IF @@ROWCOUNT > 0
BEGIN
IF @eflag_mask & @spatial_type_mask = @spatial_type_mask AND 
   @eflag_mask & @cad_mask = @cad_mask AND
   @layer_mask & @geom_attr_data_mask = @geom_attr_data_mask
BEGIN
  SET @sql= 'DROP TABLE' + db_name() + '.' + @owner + '.SDE_GEOMETRY' + CONVERT(NVARCHAR(10),@layerIdVal)
  EXECUTE (@sql)
END
END

UPDATE sde.SDE_layers
SET description = @descVal, gsize1 = @g1Val, gsize2 = @g2Val,
  gsize3 = @g3Val, minx = @minxVal, miny = @minyVal, maxx = @maxxVal,
  maxy = @maxyVal, minz = @minzVal, maxz = @maxzVal, minm = @minmVal,
  maxm = @maxmVal, eflags = @efVal, layer_mask = @layerMaskVal,
  layer_config = @layerConVal, optimal_array_size = @optArrSize,
  stats_date = @statDateVal, minimum_id = @minIdVal, secondary_srid = @secondarySridVal 
WHERE layer_id = @layerIdVal
UPDATE sde.SDE_geometry_columns
SET geometry_type = @geometryTypeVal
FROM sde.SDE_layers l
WHERE l.layer_id = @layerIdVal AND l.database_name = f_table_catalog
  AND l.owner = f_table_schema AND l.table_name = f_table_name AND
  l.spatial_column = f_geometry_column
GO
/****** Object:  StoredProcedure [sde].[SDE_layer_lock_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_layer_lock_def_delete] @sdeIdVal INTEGER, @layerIdVal INTEGER,     @autoLockVal VARCHAR(1) AS SET NOCOUNT ON     BEGIN TRAN layer_lock_del_tran     DECLARE @ret_val INTEGER     DELETE FROM sde.SDE_layer_locks WHERE  sde_id = @sdeIdVal AND layer_id = @layerIdVal AND     autolock = @autoLockVal     IF @@ROWCOUNT = 0 SET @ret_val = -48 /* SE_NO_LOCKS */     ELSE SET @ret_val = 0 /* SE_SUCCESS */     COMMIT TRAN layer_lock_del_tran     RETURN @ret_val
GO
/****** Object:  StoredProcedure [sde].[SDE_layer_lock_def_delete_user]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_layer_lock_def_delete_user] @sdeIdVal INTEGER AS SET NOCOUNT ON     BEGIN TRAN layer_lock_tran     DELETE FROM sde.SDE_layer_locks WHERE  sde_id = @sdeIdVal     COMMIT TRAN layer_lock_tran
GO
/****** Object:  StoredProcedure [sde].[SDE_layer_lock_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_layer_lock_def_insert]
@sdeIdVal INTEGER,
@layerIdVal INTEGER,
@autoLockVal VARCHAR(1),
@lockTypeVal VARCHAR(1),
@minxVal BIGINT,
@minyVal BIGINT,
@maxxVal BIGINT,
@maxyVal BIGINT AS SET NOCOUNT ON
DECLARE @lock_conflict INTEGER
/* If this is not an autolock, delete any existing regular lock on this
   layer owned by this user.
   The lock is to be removed even if we subsequently encounter a lock
   conflict (this behavior is unique to layer locks).*/
BEGIN TRAN layer_lock_tran
IF @autoLockVal <> 'Y'
  EXECUTE sde.SDE_layer_lock_def_delete @sdeIdVal, @layerIdVal, @autoLockVal
/* check for conflicts */

  DECLARE locks_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT sde_id
    FROM   sde.SDE_layer_locks WITH (TABLOCKX,HOLDLOCK)
    WHERE  layer_id = @layerIdVal AND
           (sde_id <> @sdeIdVal OR
           autolock = @autoLockVal) AND
           (lock_type = 'E' /* E: Exclusive lock */ OR
            @lockTypeVal = 'E') AND
           ((maxx >= @minxVal AND maxy >= @minyVal AND
             @maxxVal >= minx AND @maxyVal >= miny) OR
             (minx IS NULL OR @minxVal IS NULL))
  /* Find any conflicting locks.  The query we use is sensitive about
     whether we are trying to place an exclusive lock (in which case we
     have to consider all locks as possibly conflicting), or a shared lock
     (in which case we only have to worry about conflicting with exclusive
     locks).  In either case, the query will include a range expression so
     composed that a lock with NULL envelope variables will always match
     any other lock.  This is because a NULL envelope indicates a layer-
     wide lock.  With all of the about constraints in place, if any rows
     are returned, we probably have a conflict.  The last thing we have to
     check is if the connection owning the lock has somehow died without
     cleaning up. */
  OPEN locks_cursor
  DECLARE @loop_done INTEGER
  DECLARE @id INTEGER
  SET @lock_conflict = 0
  SET @loop_done = 0
  DECLARE @f_sde_id INTEGER
  WHILE @loop_done = 0
  BEGIN 
    FETCH NEXT FROM locks_cursor INTO @f_sde_id
    IF @@FETCH_STATUS = 0
    BEGIN
      /* We found a matching layer lock.  See if the owning connection
         id is still out there.  If not, then this lock is invalid. */

      SELECT @id = SO.object_id
        FROM tempdb.sys.objects SO INNER JOIN 
            sde.SDE_process_information       PR ON object_id (PR.table_name) = SO.object_id
        WHERE PR.sde_id = @f_sde_id

      IF @@ROWCOUNT > 0
      BEGIN
        /* we have a lock conflict! */
        SET @lock_conflict = 1
        SET @loop_done = 1
      END
      ELSE
      BEGIN
        /* defunct connection found, clean it up */
        EXECUTE sde.SDE_pinfo_def_delete @f_sde_id
      END
     END
     ELSE
       SET @loop_done = 1
  END /* while */
  CLOSE locks_cursor
  DEALLOCATE locks_cursor

DECLARE @ret_val INTEGER
IF (@lock_conflict = 0)
BEGIN
  INSERT INTO sde.SDE_layer_locks
         (sde_id,layer_id,autolock,lock_type,minx,miny,maxx,maxy)
  VALUES (@sdeIdVal,@layerIdVal,@autoLockVal,@lockTypeVal,@minxVal,
          @minyVal,@maxxVal,@maxyVal)
  SET @ret_val = 0 /* SE_SUCCESS */
  COMMIT TRAN layer_lock_tran
END
ELSE
BEGIN
  SET @ret_val = -49 /* SE_LOCK_CONFLICT */
  ROLLBACK TRAN layer_lock_tran
END
RETURN @ret_val
GO
/****** Object:  StoredProcedure [sde].[SDE_layer_lock_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_layer_lock_def_update]
@sdeIdVal INTEGER,
@layerIdVal INTEGER,
@autoLockVal VARCHAR(1),
@lockTypeVal VARCHAR(1),
@minxVal BIGINT,
@minyVal BIGINT,
@maxxVal BIGINT,
@maxyVal BIGINT AS SET NOCOUNT ON
DECLARE @isConflictVal INTEGER
DECLARE @ret_val INTEGER
BEGIN TRAN layer_lock_tran
/* Delete the lock we are to update.  If it doesn't exist, we will
   report an error.  If it does exist, this will
   get it out of the way so we can test for conflicts.*/
  EXECUTE @ret_val = sde.SDE_layer_lock_def_delete @sdeIdVal, @layerIdVal, @autoLockVal
  IF @ret_val <> 0
    RETURN @ret_val
/* check for conflicts */
EXECUTE sde.SDE_layer_check_lock_conflicts @sdeIdVal,@layerIdVal,@autoLockVal,@lockTypeVal,@minxVal,
        @minyVal,@maxxVal,@maxyVal, @isConflictVal OUTPUT
IF (@isConflictVal = 0)
BEGIN
  INSERT INTO sde.SDE_layer_locks
         (sde_id,layer_id,autolock,lock_type,minx,miny,maxx,maxy)
  VALUES (@sdeIdVal,@layerIdVal,@autoLockVal,@lockTypeVal,@minxVal,
          @minyVal,@maxxVal,@maxyVal)
  SET @ret_val = 0 /* SE_SUCCESS */
  COMMIT TRAN layer_lock_tran
END
ELSE
BEGIN
  SET @ret_val = -49 /* SE_LOCK_CONFLICT */
  ROLLBACK TRAN layer_lock_tran
END
RETURN @ret_val
GO
/****** Object:  StoredProcedure [sde].[SDE_layer_srid_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_layer_srid_update]              @sridVal INTEGER, @layeridVal INTEGER AS SET NOCOUNT ON BEGIN              DECLARE @g_table sysname              SET @g_table = N'f' + cast(@layeridVal as NVARCHAR)              UPDATE sde.SDE_layers SET srid = @sridVal WHERE layer_id = @layeridVal 
 UPDATE             sde.SDE_geometry_columns SET srid = @sridVal WHERE g_table_name = @g_table END
GO
/****** Object:  StoredProcedure [sde].[SDE_layer_stats_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_layer_stats_def_delete]
@layerIdVal INTEGER, @versionIdVal INTEGER AS
SET NOCOUNT ON
BEGIN
BEGIN TRAN layer_stats_delete
IF @versionIdVal <= 0
BEGIN
  DELETE FROM sde.SDE_layer_stats  WHERE layer_id = @layerIdVal AND version_id IS NULL
END
ELSE
BEGIN
  DELETE FROM sde.SDE_layer_stats  WHERE layer_id = @layerIdVal AND version_id = @versionIdVal
END
COMMIT TRAN layer_stats_delete
END
GO
/****** Object:  StoredProcedure [sde].[SDE_layer_stats_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_layer_stats_def_insert]
@layerIdVal INTEGER, @versionIdVal INTEGER,
@minxVal FLOAT,@minyVal FLOAT, @maxxVal FLOAT, @maxyVal FLOAT,
@minzVal FLOAT, @maxzVal FLOAT,@minmVal FLOAT, @maxmVal FLOAT,
@totalFeaturesVal INTEGER, @totalPointsVal INTEGER AS
SET NOCOUNT ON
BEGIN
BEGIN TRAN layer_stats_insert
INSERT INTO sde.SDE_layer_stats (layer_id,version_id, 
  minx, miny, maxx, maxy, minz, maxz, minm, maxm, 
  total_features, total_points, last_analyzed)
 VALUES (@layerIdVal, @versionIdVal, @minxVal, @minyVal, @maxxVal, @maxyVal,
  @minzVal, @maxzVal, @minmVal, @maxmVal, @totalFeaturesVal, @totalPointsVal,
  GETDATE())
COMMIT TRAN layer_stats_insert
END
GO
/****** Object:  StoredProcedure [sde].[SDE_layer_stats_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_layer_stats_def_update]
@layerIdVal INTEGER, @versionIdVal INTEGER,
@minxVal FLOAT,@minyVal FLOAT, @maxxVal FLOAT, @maxyVal FLOAT,
@minzVal FLOAT, @maxzVal FLOAT,@minmVal FLOAT, @maxmVal FLOAT,
@totalFeaturesVal INTEGER, @totalPointsVal INTEGER AS
SET NOCOUNT ON
BEGIN
BEGIN TRAN layer_stats_update
IF @versionIdVal IS NULL
BEGIN
  UPDATE sde.SDE_layer_stats  SET minx = @minxVal, miny = @minyVal, maxx = @maxxVal, maxy = @maxyVal,
      minz = @minzVal, maxz = @maxzVal, minm = @minmVal, maxm = @maxmVal,
      total_features = @totalFeaturesVal, total_points = @totalPointsVal,
      last_analyzed = GETDATE()
  WHERE layer_id = @layerIdVal AND version_id IS NULL
END
ELSE
BEGIN
  UPDATE sde.SDE_layer_stats  SET minx = @minxVal, miny = @minyVal, maxx = @maxxVal, maxy = @maxyVal,
      minz = @minzVal, maxz = @maxzVal, minm = @minmVal, maxm = @maxmVal,
      total_features = @totalFeaturesVal, total_points = @totalPointsVal,
      last_analyzed = GETDATE()
  WHERE layer_id = @layerIdVal AND version_id = @versionIdVal
END
COMMIT TRAN layer_stats_update
END
GO
/****** Object:  StoredProcedure [sde].[SDE_locator_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_locator_def_delete] @id1        INTEGER AS SET NOCOUNT ON DELETE FROM sde.SDE_locators WHERE locator_id = @id1
GO
/****** Object:  StoredProcedure [sde].[SDE_locator_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_locator_def_insert]       @locator_idVal INTEGER,@categoryVal NVARCHAR(32),@typeVal INTEGER,       @descriptionVal NVARCHAR(64), @nameVal NVARCHAR(32),       @ownerVal NVARCHAR(32) AS SET NOCOUNT ON INSERT INTO sde.SDE_locators      (locator_id,category,type,description,name,owner) VALUES (      @locator_idVal,@categoryVal,@typeVal,@descriptionVal,@nameVal,@ownerVal)
GO
/****** Object:  StoredProcedure [sde].[SDE_locator_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_locator_def_update] @locator_idVal INTEGER,      @categoryVal NVARCHAR(32), @typeVal INTEGER, @descriptionVal NVARCHAR(64),      @nameVal NVARCHAR(32) AS SET NOCOUNT ON      UPDATE sde.SDE_locators SET name = @nameVal, category = @categoryVal,type = @typeVal,      description = @descriptionVal WHERE locator_id = @locator_idVal
GO
/****** Object:  StoredProcedure [sde].[SDE_logfile_pool_get_id]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_logfile_pool_get_id]
@sdeIdVal INTEGER,
@checkOrphansVal INTEGER,
@useTruncateVal INTEGER
AS
BEGIN TRAN logfile_tran
DECLARE @table_id INTEGER
SET @table_id = 0
SELECT TOP 1 @table_id = table_id
  FROM sde.SDE_logfile_pool WITH (TABLOCKX, HOLDLOCK)
  WHERE sde_id IS NULL
IF @@ROWCOUNT > 0
BEGIN
  /* Grab this table */
  UPDATE sde.SDE_logfile_pool SET sde_id = @sdeIdVal
    WHERE table_id = @table_id
END
ELSE
BEGIN
  IF @checkOrphansVal = 1
  BEGIN
    /* Check if any of the tables are orphaned */
    SELECT TOP 1 @table_id = LP.table_id FROM sde.SDE_logfile_pool LP
    LEFT JOIN (SELECT PR.sde_id FROM sde.SDE_process_information PR 
    INNER JOIN  tempdb.sys.objects SO      ON object_id (PR.table_name) = SO.object_id
    WHERE SO.object_id IS NOT NULL) SPR
    ON LP.sde_id = SPR.sde_id WHERE SPR.sde_id IS NULL
    IF @@ROWCOUNT > 0
    BEGIN
      /* Grab this orphaned table */
      UPDATE sde.SDE_logfile_pool SET sde_id = @sdeIdVal
        WHERE table_id = @table_id
    END
  END
END
/* If we got a table, truncate it in case the last user did
   not clean it up properly. */
IF @table_id > 0
BEGIN
  DECLARE @sqlstmt AS VARCHAR (64)
  IF @useTruncateVal = 1
  BEGIN
    SET @sqlstmt = 'TRUNCATE TABLE sde.SDE_logpool_' + cast (@table_id as varchar(10))
  END
  ELSE
  BEGIN
    SET @sqlstmt = 'DELETE FROM sde.SDE_logpool_' + cast (@table_id as varchar(10))
  END
  EXEC (@sqlstmt)
END
COMMIT TRAN logfile_tran
RETURN @table_id
GO
/****** Object:  StoredProcedure [sde].[SDE_logfile_pool_release_id]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_logfile_pool_release_id]
@tableIdVal INTEGER
AS SET NOCOUNT ON
BEGIN TRAN logfile_tran
  UPDATE sde.SDE_logfile_pool SET sde_id = NULL
    WHERE table_id = @tableIdVal
COMMIT TRAN logfile_tran
GO
/****** Object:  StoredProcedure [sde].[SDE_metadata_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_metadata_def_delete] @id1        INTEGER, @id2 INTEGER, @id3 INTEGER, @id4 INTEGER, @id5 INTEGER,        @id6 INTEGER, @id7 INTEGER, @id8 INTEGER, @id9 INTEGER, @id10 INTEGER AS       SET NOCOUNT ON DELETE FROM sde.SDE_metadata WHERE record_id IN (       @id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8, @id9, @id10)
GO
/****** Object:  StoredProcedure [sde].[SDE_metadata_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_metadata_def_insert]       @record_idVal INTEGER, @object_nameVal NVARCHAR(32), @object_databaseVal NVARCHAR(32),       @object_ownerVal NVARCHAR(32),@object_typeVal INTEGER, @class_nameVal      NVARCHAR(32), @propertyVal NVARCHAR(32), @prop_valueVal NVARCHAR(255),        @descriptionVal NVARCHAR(64), @creation_dateVal DATETIME AS SET NOCOUNT ON      INSERT INTO sde.SDE_metadata      (record_id,object_name,object_database,object_owner,object_type,class_name,property,      prop_value,description,creation_date) VALUES (@record_idVal, @object_nameVal,      @object_databaseVal, @object_ownerVal, @object_typeVal, @class_nameVal, @propertyVal,      @prop_valueVal, @descriptionVal, @creation_dateVal)
GO
/****** Object:  StoredProcedure [sde].[SDE_metadata_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_metadata_def_update]       @record_idVal INTEGER, @class_nameVal      NVARCHAR(32), @propertyVal NVARCHAR(32), @prop_valueVal NVARCHAR(255),        @descriptionVal NVARCHAR(64), @creation_dateVal DATETIME AS      SET NOCOUNT ON UPDATE sde.SDE_metadata      SET class_name = @class_nameVal,property = @propertyVal,      prop_value = @prop_valueVal,description = @descriptionVal,      creation_date = @creation_dateVal WHERE record_id = @record_idVal
GO
/****** Object:  StoredProcedure [sde].[SDE_mvmodified_table_del_base_save]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_mvmodified_table_del_base_save]       @high_state_idVal BIGINT, @lineage_nameVal BIGINT, @id1 INTEGER,      @id2 INTEGER, @id3 INTEGER, @id4 INTEGER, @id5 INTEGER,      @id6 INTEGER, @id7 INTEGER, @id8 INTEGER AS      SET NOCOUNT ON      BEGIN      DELETE FROM sde.SDE_mvtables_modified WHERE registration_id IN         (@id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8)        AND state_id IN (SELECT state_id FROM sde.SDE_states WHERE state_id > 0 AND        state_id <= @high_state_idVal AND lineage_name = @lineage_nameVal)      END
GO
/****** Object:  StoredProcedure [sde].[SDE_mvmodified_table_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_mvmodified_table_insert]       @registration_idVal INTEGER, @state_idVal BIGINT AS      SET NOCOUNT ON      BEGIN      BEGIN TRAN mvmodified_insert      INSERT INTO sde.SDE_mvtables_modified (registration_id, state_id)       VALUES ( @registration_idVal, @state_idVal )      COMMIT TRAN mvmodified_insert      END
GO
/****** Object:  StoredProcedure [sde].[SDE_new_branch_state]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_new_branch_state] 
@current_state_id BIGINT,
@current_lineage_name BIGINT,
@new_state_id BIGINT OUTPUT AS SET NOCOUNT ON
BEGIN
  --This is a private support procedure for SDE versioned views.

  DECLARE @ret INTEGER
  DECLARE @i INTEGER
  DECLARE @l_current_state_id BIGINT
  DECLARE @l_current_lineage_name BIGINT
  DECLARE @new_lineage_name BIGINT
  DECLARE @new_state_time DATETIME
  DECLARE @connection_id INTEGER
  DECLARE @user NVARCHAR (128)
  SET @i = 1
  SET @ret = 0
  SET @l_current_state_id = @current_state_id
  SET @l_current_lineage_name = @current_lineage_name
  WHILE @i < 4
  BEGIN
    -- insert a new state and point the default version to it.
    EXECUTE sde.SDE_get_primary_oid 8,1,@new_state_id OUTPUT
    SET @new_lineage_name = @l_current_lineage_name
    EXECUTE sde.SDE_get_primary_oid 12, 1, @connection_id OUTPUT
    EXECUTE sde.SDE_get_current_user_name @user OUTPUT 
    EXECUTE sde.SDE_state_def_insert @new_state_id,
      @user, @l_current_state_id, @new_lineage_name OUTPUT,
      @connection_id, 2, @new_state_time OUTPUT

    SET NOCOUNT OFF
    EXECUTE sde.SDE_versions_def_change_state @new_state_id, 'DEFAULT',
      'sde', @l_current_state_id
    IF @@ROWCOUNT = 0
    BEGIN
      SET @ret = -1
      EXECUTE sde.SDE_state_def_delete @new_state_id,-1,-1,-1,-1,-1,-1,-1
      SELECT @l_current_state_id = state_id, @l_current_lineage_name = lineage_name
      FROM   sde.SDE_states
      WHERE  state_id = (SELECT state_id FROM sde.SDE_versions
        WHERE name = 'DEFAULT' AND owner = 'sde')
      SET @i = @i + 1
    END
    ELSE
    BEGIN
      SET @i = 4
      SET @ret = 0
    END
  END --while loop

  SET NOCOUNT ON
  IF @ret != 0
    RETURN @ret

  EXECUTE sde.SDE_state_lock_def_delete_user @connection_id

  RETURN 0
END

GO
/****** Object:  StoredProcedure [sde].[SDE_object_check_lock_conflicts]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_object_check_lock_conflicts]
@sdeIdVal INTEGER,
@objectIdVal INTEGER,
@objectTypeVal INTEGER,
@applicationIdVal INTEGER,
@autoLockVal VARCHAR(1),
@lockTypeVal VARCHAR(1),
@lock_conflict INTEGER OUTPUT AS SET NOCOUNT ON
BEGIN
  DECLARE locks_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT sde_id
    FROM   sde.SDE_object_locks WITH (TABLOCKX,HOLDLOCK)
    WHERE  object_id = @objectIdVal AND
           object_type = @objectTypeVal AND
           application_id = @applicationIdVal AND
           (sde_id <> @sdeIdVal OR
            autolock = @autoLockVal) AND
           (lock_type = 'E' /* E: Exclusive lock */ OR 
            @lockTypeVal = 'E')
  /* Find any conflicting locks.  The query we use is sensitive about
     whether we are trying to place an exclusive lock (in which case we
     have to consider all locks as possibly conflicting), or a shared lock
     (in which case we only have to worry about conflicting with exclusive
     locks).  With all of the about constraints in place, if any rows
     are returned, we probably have a conflict.  The last thing we have to
     check is if the connection owning the lock has somehow died without
     cleaning up. */
  OPEN locks_cursor
  DECLARE @loop_done INTEGER
  DECLARE @id INTEGER
  SET @lock_conflict = 0
  SET @loop_done = 0
  DECLARE @f_sde_id INTEGER
  WHILE @loop_done = 0
  BEGIN 
    FETCH NEXT FROM locks_cursor INTO @f_sde_id
    IF @@FETCH_STATUS = 0
    BEGIN
      /* We found a matching table lock.  See if the owning connection
         id is still out there.  If not, then this lock is invalid. */

      SELECT @id = SO.object_id
        FROM tempdb.sys.objects SO INNER JOIN
            sde.SDE_process_information      PR ON object_id (PR.table_name) = SO.object_id
        WHERE PR.sde_id = @f_sde_id

      IF @@ROWCOUNT > 0
      BEGIN
        /* we have a lock conflict! */
        SET @lock_conflict = 1
        SET @loop_done = 1
      END
      ELSE
      BEGIN
         /* defunct connection found, clean it up */
         EXECUTE sde.SDE_pinfo_def_delete @f_sde_id
      END
     END
     ELSE
       SET @loop_done = 1
  END /* while */
  CLOSE locks_cursor
  DEALLOCATE locks_cursor
END

GO
/****** Object:  StoredProcedure [sde].[SDE_object_lock_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_object_lock_def_delete] @sdeIdVal INTEGER, @objectIdVal INTEGER,     @objectTypeVal INTEGER, @applicationIdVal INTEGER,     @autoLockVal VARCHAR(1) AS SET NOCOUNT ON     BEGIN TRAN object_lock_del_tran     DECLARE @ret_val INTEGER     DELETE FROM sde.SDE_object_locks WITH (TABLOCKX) WHERE  sde_id = @sdeIdVal AND     object_id = @objectIdVal AND object_type = @objectTypeVal     AND application_id = @applicationIdVal AND autolock = @autoLockVal     IF @@ROWCOUNT = 0 SET @ret_val = -48 /* SE_NO_LOCKS */     ELSE SET @ret_val = 0 /* SE_SUCCESS */     COMMIT TRAN object_lock_del_tran     RETURN @ret_val
GO
/****** Object:  StoredProcedure [sde].[SDE_object_lock_def_delete_user]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_object_lock_def_delete_user] @sdeIdVal INTEGER AS SET NOCOUNT ON     BEGIN TRAN object_lock_tran     DELETE FROM sde.SDE_object_locks WHERE  sde_id = @sdeIdVal     COMMIT TRAN object_lock_tran
GO
/****** Object:  StoredProcedure [sde].[SDE_object_lock_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_object_lock_def_insert]
@sdeIdVal INTEGER,
@objectIdVal INTEGER,
@objectTypeVal INTEGER,
@applicationIdVal INTEGER,
@autoLockVal VARCHAR(1),
@lockTypeVal VARCHAR(1) AS SET NOCOUNT ON
DECLARE @isConflictVal INTEGER
DECLARE @ret_val INTEGER
BEGIN TRAN object_lock_tran

/* Delete any existing lock on this object owned by this user. */
/* This gets it out of the way during conflict checking (it will be */
/* restored via rollback if a conflict is detected).*/
EXECUTE sde.SDE_object_lock_def_delete @sdeIdVal, @objectIdVal, @objectTypeVal,
  @applicationIdVal, @autoLockVal

/* check for conflicts */
EXECUTE sde.SDE_object_check_lock_conflicts @sdeIdVal,@objectIdVal,@objectTypeVal,
  @applicationIdVal,@autoLockVal,@lockTypeVal,@isConflictVal OUTPUT
IF (@isConflictVal = 0)
BEGIN
  INSERT INTO sde.SDE_object_locks
    (sde_id,object_id,object_type,application_id,autolock,lock_type)
  VALUES (@sdeIdVal,@objectIdVal,@objectTypeVal,@applicationIdVal,
    @autoLockVal,@lockTypeVal)
  SET @ret_val = 0 /* SE_SUCCESS */ 
  COMMIT TRAN object_lock_tran
END
ELSE
BEGIN
  SET @ret_val = -49 /* SE_LOCK_CONFLICT */
  ROLLBACK TRAN object_lock_tran
END
RETURN @ret_val

GO
/****** Object:  StoredProcedure [sde].[SDE_parse_version_name]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_parse_version_name] 
@version_name NVARCHAR (97),
@parsed_name NVARCHAR (64) OUTPUT,
@parsed_owner NVARCHAR (32) OUTPUT AS SET NOCOUNT ON
BEGIN
  --This is a private support function for SDE versioned views.

  DECLARE @error_string NVARCHAR(256)
  DECLARE @delimiter INTEGER
  DECLARE @SE_INVALID_VERSION_NAME INTEGER
  SET @SE_INVALID_VERSION_NAME = 50171

  -- Parse the version name.
  SET @delimiter = PATINDEX ('%".%', @version_name)
  IF @delimiter <> 0
  BEGIN
    SET @parsed_owner = substring (@version_name, 1, @delimiter)
    SET @parsed_name = substring (@version_name, @delimiter + 2, 64)
  END
  ELSE
  BEGIN
    SET @delimiter = charindex ('.', @version_name)
    IF @delimiter <> 0
    BEGIN
      SET @parsed_owner = substring (@version_name, 1, @delimiter - 1)
      SET @parsed_name = substring (@version_name, @delimiter + 1, 64)
    END
    ELSE
    BEGIN
      SET @parsed_name = @version_name
      EXECUTE sde.SDE_get_current_user_name @parsed_owner OUTPUT
    END
  END

  IF RTRIM (@parsed_name) IS NULL OR LEN (@parsed_name) = 0 OR
     RTRIM (@parsed_owner) IS NULL OR LEN (@parsed_owner) = 0
  BEGIN
    SET @error_string = ISNULL (@version_name, '(null)') +
                       ' is not a valid version name.'
    RAISERROR (@error_string,16,-1)
    RETURN @SE_INVALID_VERSION_NAME
  END

  RETURN 0
END

GO
/****** Object:  StoredProcedure [sde].[SDE_pinfo_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_pinfo_def_delete] @sdeIdVal INTEGER AS SET NOCOUNT ON     BEGIN TRAN pinfo_tran     DELETE FROM sde.SDE_layer_locks WHERE sde_id = @sdeIdVal     DELETE FROM sde.SDE_state_locks WHERE sde_id = @sdeIdVal     DELETE FROM sde.SDE_table_locks WHERE sde_id = @sdeIdVal     DELETE FROM sde.SDE_object_locks WHERE sde_id = @sdeIdVal     UPDATE sde.SDE_logfile_pool SET sde_id = NULL WHERE sde_id = @sdeIdVal     DELETE FROM sde.SDE_process_information WHERE sde_id = @sdeIdVal     COMMIT TRAN pinfo_tran
GO
/****** Object:  StoredProcedure [sde].[SDE_pinfo_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_pinfo_def_insert]
 @sdeIdVal INTEGER,
  @serverIdVal INTEGER,
 @directConnectVal VARCHAR(1),
 @sysnameVal NVARCHAR(32),
 @nodenameVal NVARCHAR(256),
 @xdrneededVal VARCHAR(1),
 @tablenameVal NVARCHAR(95) AS SET NOCOUNT ON
 BEGIN TRAN pinfo_tran
 DECLARE @current_user NVARCHAR(30)
 DECLARE process_cursor CURSOR LOCAL FAST_FORWARD FOR 
 SELECT sde_id FROM sde.SDE_process_information WITH  (TABLOCK,XLOCK,HOLDLOCK) 
 WHERE spid = @@spid and table_name <> @tablenameVal 
 OPEN process_cursor 
 DECLARE @sde_id INTEGER
 FETCH NEXT FROM process_cursor INTO @sde_id
 WHILE @@FETCH_STATUS = 0
  BEGIN
  /* We found an invalid connection, clean it up. */ 
  EXECUTE sde.SDE_pinfo_def_delete @sde_id
  FETCH NEXT FROM process_cursor INTO @sde_id
  END /* while */ 
 CLOSE process_cursor
 DEALLOCATE process_cursor
 EXECUTE sde.SDE_get_current_user_name @current_user OUTPUT
 INSERT INTO sde.SDE_process_information (sde_id,spid,server_id,start_time,
    rcount,wcount,opcount,numlocks,fb_partial,fb_count,fb_fcount,
    fb_kbytes,owner,direct_connect,sysname,nodename,xdr_needed,table_name)
 VALUES (@sdeIdVal,@@spid,@serverIdVal,getdate(),0,0,0,0,0,0,0,0,
    @current_user,@directConnectVal,@sysnameVal,@nodenameVal,
    @xdrneededVal,@tablenameVal)
 DELETE FROM sde.SDE_lineages_modified 
    WHERE DATEDIFF (day, time_last_modified, getdate()) > 2
 COMMIT TRAN pinfo_tran

GO
/****** Object:  StoredProcedure [sde].[SDE_pinfo_def_insert_ex]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_pinfo_def_insert_ex]
 @sdeIdVal INTEGER,
  @serverIdVal INTEGER,
 @directConnectVal VARCHAR(1),
 @sysnameVal NVARCHAR(32),
 @nodenameVal NVARCHAR(256),
 @xdrneededVal VARCHAR(1),
 @tablenameVal NVARCHAR(95) AS SET NOCOUNT ON
 BEGIN TRAN pinfo_tran
 DECLARE @current_user NVARCHAR(30)
 EXECUTE sde.SDE_get_current_user_name @current_user OUTPUT
 INSERT INTO sde.SDE_process_information (sde_id,spid,server_id,start_time,
    rcount,wcount,opcount,numlocks,fb_partial,fb_count,fb_fcount,
    fb_kbytes,owner,direct_connect,sysname,nodename,xdr_needed,table_name)
 VALUES (@sdeIdVal,@@spid,@serverIdVal,getdate(),0,0,0,0,0,0,0,0,
    @current_user,@directConnectVal,@sysnameVal,@nodenameVal,
    @xdrneededVal,@tablenameVal)
 COMMIT TRAN pinfo_tran

GO
/****** Object:  StoredProcedure [sde].[SDE_pinfo_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_pinfo_def_update] @sdeIdVal INTEGER, @rcountVal INTEGER,     @wcountVal INTEGER, @opcountVal INTEGER, @numlocksVal INTEGER,     @fb_partialVal INTEGER, @fb_countVal INTEGER, @fb_fcountVal INTEGER,     @fb_kbytesVal INTEGER AS SET NOCOUNT ON     BEGIN TRAN pinfo_tran     UPDATE sde.SDE_process_information  SET rcount = @rcountVal, wcount = @wcountVal,     opcount = @opcountVal, numlocks = @numlocksVal,      fb_partial = @fb_partialVal, fb_count = @fb_countVal,     fb_fcount = @fb_fcountVal, fb_kbytes = @fb_kbytesVal     WHERE sde_id = @sdeIdVal     COMMIT TRAN pinfo_tran
GO
/****** Object:  StoredProcedure [sde].[SDE_procedure_release]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_procedure_release] AS SELECT 7000105 FROM sde.SDE_version
GO
/****** Object:  StoredProcedure [sde].[SDE_purge_processes]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_purge_processes] AS SET NOCOUNT ON
BEGIN
  BEGIN TRAN pinfo_tran
  DECLARE process_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT PR.sde_id, SO.object_id
    FROM sde.SDE_process_information PR WITH  (TABLOCK,XLOCK,HOLDLOCK)
      LEFT JOIN tempdb.sys.objects SO
      ON object_id (PR.table_name) = SO.object_id
  OPEN process_cursor
  DECLARE @sde_id INTEGER
  DECLARE @table_id INTEGER
  FETCH NEXT FROM process_cursor INTO @sde_id,@table_id
  WHILE @@FETCH_STATUS = 0
    BEGIN
    IF (@table_id IS NULL)
    BEGIN
      /* We found an invalid connection, clean it up. */
      EXECUTE sde.SDE_pinfo_def_delete @sde_id
    END
    FETCH NEXT FROM process_cursor INTO @sde_id,@table_id
  END /* while */
  CLOSE process_cursor
  DEALLOCATE process_cursor
  COMMIT TRAN pinfo_tran
END

GO
/****** Object:  StoredProcedure [sde].[SDE_rascol_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_rascol_def_delete] @rascol_idVal        INTEGER AS SET NOCOUNT ON DELETE FROM sde.SDE_raster_columns WHERE rastercolumn_id =       @rascol_idVal
GO
/****** Object:  StoredProcedure [sde].[SDE_rascol_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_rascol_def_insert]       @rastercolumn_idVal INTEGER,@descriptionVal NVARCHAR(65),       @database_nameVal NVARCHAR(32),@ownerVal NVARCHAR(32), @table_nameVal sysname,      @raster_columnVal NVARCHAR(32), @cdateVal INTEGER,       @config_keywordVal NVARCHAR(32), @minimum_idVal INTEGER, @base_idVal INTEGER,       @rastercolumn_maskVal INTEGER, @sridVal INTEGER AS SET NOCOUNT ON      INSERT INTO sde.SDE_raster_columns       (rastercolumn_id,description,database_name,owner,table_name,raster_column,      cdate,config_keyword,minimum_id,base_rastercolumn_id, rastercolumn_mask,srid) VALUES       (@rastercolumn_idVal,@descriptionVal,@database_nameVal,@ownerVal,       @table_nameVal,@raster_columnVal,@cdateVal,@config_keywordVal,       @minimum_idVal,@base_idVal,@rastercolumn_maskVal,@sridVal)
GO
/****** Object:  StoredProcedure [sde].[SDE_rascol_def_rename]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_rascol_def_rename] @table_nameVal sysname,      @rastercolumn_idVal INTEGER       AS SET NOCOUNT ON UPDATE sde.SDE_raster_columns SET table_name = @table_nameVal       WHERE rastercolumn_id = @rastercolumn_idVal
GO
/****** Object:  StoredProcedure [sde].[SDE_rascol_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_rascol_def_update] @rastercolumn_idVal INTEGER,      @descriptionVal NVARCHAR(65), @config_keywordVal NVARCHAR(32),       @minimum_idVal INTEGER, @rastercolumn_maskVal INTEGER      AS SET NOCOUNT ON UPDATE sde.SDE_raster_columns SET description = @descriptionVal,      config_keyword = @config_keywordVal,       minimum_id = @minimum_idVal, rastercolumn_mask = @rastercolumn_maskVal       WHERE rastercolumn_id = @rastercolumn_idVal
GO
/****** Object:  StoredProcedure [sde].[SDE_rascol_def_update_migrate]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_rascol_def_update_migrate] @rastercolumn_idVal INTEGER,      @descriptionVal NVARCHAR(65), @config_keywordVal NVARCHAR(32),       @minimum_idVal INTEGER, @rastercolumn_maskVal INTEGER,       @raster_columnVal NVARCHAR(32)       AS SET NOCOUNT ON UPDATE sde.SDE_raster_columns SET description = @descriptionVal,      config_keyword = @config_keywordVal,       minimum_id = @minimum_idVal, rastercolumn_mask = @rastercolumn_maskVal,       raster_column = @raster_columnVal       WHERE rastercolumn_id = @rastercolumn_idVal
GO
/****** Object:  StoredProcedure [sde].[SDE_rascol_spatial_reference_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_rascol_spatial_reference_update]             @rastercolumn_idVal INTEGER, @srTextVal VARCHAR(2048),            @xycluster_tolVal FLOAT,            @zcluster_tolVal FLOAT, @mcluster_tolVal FLOAT AS            SET NOCOUNT ON UPDATE sde.SDE_spatial_references SET             srtext = @srTextVal, xycluster_tol = @xycluster_tolVal,            zcluster_tol = @zcluster_tolVal, mcluster_tol = @mcluster_tolVal            WHERE srid  in (SELECT srid from sde.SDE_raster_columns             WHERE rastercolumn_id = @rastercolumn_idVal)
GO
/****** Object:  StoredProcedure [sde].[SDE_rascol_srid_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_rascol_srid_update]              @sridVal INTEGER, @rastercolumn_idVal INTEGER AS             SET NOCOUNT ON UPDATE sde.SDE_raster_columns               SET srid = @sridVal WHERE rastercolumn_id = @rastercolumn_idVal
GO
/****** Object:  StoredProcedure [sde].[SDE_registry_clear_modified]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_registry_clear_modified]                         @regIdVal INTEGER AS SET NOCOUNT ON DELETE FROM sde.SDE_mvtables_modified WHERE                        registration_id = @regIdVal 
GO
/****** Object:  StoredProcedure [sde].[SDE_registry_def_change_table_name]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_registry_def_change_table_name]       @tabNameVal sysname, @regIdVal INTEGER AS SET NOCOUNT ON
      UPDATE m set m.object_name = @tabNameVal from sde.SDE_metadata m 
       INNER JOIN sde.SDE_table_registry r ON 
       m.object_database = r.database_name AND m.object_name = r.table_name AND 
       m.object_owner = r.owner 
       WHERE  r.registration_id = @regIdVal AND m.object_type = 1 
      UPDATE sde.SDE_table_registry SET table_name = @tabNameVal WHERE registration_id = @regIdVal
GO
/****** Object:  StoredProcedure [sde].[SDE_registry_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_registry_def_delete]        @regIdVal INTEGER AS SET NOCOUNT ON       DELETE FROM sde.SDE_mvtables_modified WHERE registration_id = @regIdVal 
       DELETE FROM sde.SDE_table_registry WHERE registration_id = @regIdVal 
GO
/****** Object:  StoredProcedure [sde].[SDE_registry_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_registry_def_insert]        @regIdVal INTEGER, @dbNameVal NVARCHAR(32), @tabNameVal sysname, @ownerVal NVARCHAR(32),       @rowidColVal NVARCHAR(32), @descVal NVARCHAR(65), @objFlagsVal INTEGER,       @regDate INTEGER, @conKeyWordVal  NVARCHAR(32), @minIdVal INTEGER,        @imvNameVal NVARCHAR(128) AS SET NOCOUNT ON       INSERT INTO sde.SDE_table_registry (registration_id, database_name, table_name, owner,       rowid_column,description,object_flags,registration_date,       config_keyword,minimum_id,imv_view_name) VALUES ( @regIdVal, @dbNameVal, @tabNameVal,       @ownerVal,@rowidColVal, @descVal, @objFlagsVal, @regDate, @conKeyWordVal, @minIdVal,       @imvNameVal)
GO
/****** Object:  StoredProcedure [sde].[SDE_registry_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_registry_def_update]        @rowidColVal NVARCHAR(32), @descVal NVARCHAR(65), @objFlagsVal INTEGER,       @conKeyWordVal  NVARCHAR(32), @minIdVal INTEGER, @regIdVal INTEGER,       @imvNameVal NVARCHAR (128) AS SET NOCOUNT ON       UPDATE sde.SDE_table_registry SET rowid_column = @rowidColVal, description = @descVal,       object_flags = @objFlagsVal ,config_keyword = @conKeyWordVal,       minimum_id = @minIdVal, imv_view_name = @imvNameVal       WHERE registration_id = @regIdVal
GO
/****** Object:  StoredProcedure [sde].[SDE_server_config_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_server_config_insert]
 @PropNameVal NVARCHAR(32),
    @CharPropVal NVARCHAR(512),
    @NumPropVal INTEGER AS SET NOCOUNT ON
    UPDATE sde.SDE_server_config SET prop_name = UPPER(@PropNameVal), 
    char_prop_value = @CharPropVal, 
     num_prop_value = @NumPropVal WHERE prop_name =  UPPER(@PropNameVal) 

    IF @@ROWCOUNT = 0 
     INSERT INTO sde.SDE_server_config (prop_name,char_prop_value,num_prop_value) 
     VALUES (UPPER(@PropNameVal),@CharPropVal,@NumPropVal)
GO
/****** Object:  StoredProcedure [sde].[SDE_set_globals]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_set_globals] 
@current_state BIGINT,
@protected CHAR(1),
@is_default CHAR(1),
@edit_version_id INTEGER
AS SET NOCOUNT ON
BEGIN
  -- This is a private support procedure for SDE versioned views.
  -- 
  -- Context info contains: SDE,current state id,protected,is_default_version,edit_version_id;
  DECLARE @context_info VARCHAR(128)
  DECLARE @varbin_context_info VARBINARY(128)
  SET @context_info = 'SDE,' + CAST (@current_state AS VARCHAR(21)) + ',' +
    @protected + ',' + @is_default + ',' + CAST (@edit_version_id AS VARCHAR(10)) + ';'
  SET @varbin_context_info = CAST (@context_info AS VARBINARY(128) )
  SET CONTEXT_INFO @varbin_context_info
END

GO
/****** Object:  StoredProcedure [sde].[SDE_sref_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_sref_def_delete]       @sridVal INTEGER AS SET NOCOUNT ON DELETE FROM sde.SDE_spatial_references WHERE srid = @sridVal
GO
/****** Object:  StoredProcedure [sde].[SDE_sref_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_sref_def_insert]       @sridVal INTEGER, @falsexVal FLOAT, @falseyVal FLOAT,       @xyunitsVal FLOAT, @falsezVal FLOAT, @zunitsVal FLOAT,       @falsemVal FLOAT, @munitsVal FLOAT, @object_flagsVal INTEGER,       @srtextVal VARCHAR(2048), @descriptionVal NVARCHAR(64),       @auth_nameVal NVARCHAR(255), @auth_sridVal INTEGER,       @xycluster_tolVal FLOAT, @zcluster_tolVal FLOAT, @mcluster_tolVal FLOAT      AS SET NOCOUNT ON INSERT INTO sde.SDE_spatial_references       (srid,falsex,falsey,xyunits,falsez,zunits,falsem,munits,object_flags,       srtext, description,auth_name,auth_srid,xycluster_tol,zcluster_tol,      mcluster_tol) VALUES (@sridVal, @falsexVal, @falseyVal,       @xyunitsVal, @falsezVal, @zunitsVal, @falsemVal, @munitsVal,       @object_flagsVal, @srtextVal, @descriptionVal, @auth_nameVal,      @auth_sridVal, @xycluster_tolVal, @zcluster_tolVal, @mcluster_tolVal)
GO
/****** Object:  StoredProcedure [sde].[SDE_sref_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_sref_def_update]       @sridVal INTEGER, @falsexVal FLOAT, @falseyVal FLOAT, @xyunitsVal FLOAT,      @falsezVal FLOAT, @zunitsVal FLOAT, @falsemVal FLOAT,       @munitsVal FLOAT, @object_flagsVal INTEGER,       @srtextVal VARCHAR(2048), @descriptionVal NVARCHAR(64),       @auth_nameVal NVARCHAR(255), @auth_sridVal INTEGER,       @xycluster_tolVal FLOAT, @zcluster_tolVal FLOAT, @mcluster_tolVal FLOAT      AS SET NOCOUNT ON UPDATE sde.SDE_spatial_references SET falsex = @falsexVal,       falsey = @falseyVal,xyunits = @xyunitsVal,falsez = @falsezVal,       zunits = @zunitsVal,falsem = @falsemVal,munits = @munitsVal,       object_flags = @object_flagsVal, srtext = @srtextVal,       description = @descriptionVal,       auth_name = @auth_nameVal, auth_srid = @auth_sridVal,      xycluster_tol = @xycluster_tolVal,zcluster_tol = @zcluster_tolVal,      mcluster_tol = @mcluster_tolVal      WHERE srid = @sridVal
GO
/****** Object:  StoredProcedure [sde].[SDE_state_check_lock_conflicts]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_state_check_lock_conflicts]
@sdeIdVal INTEGER,
@stateIdVal BIGINT,
@autoLockVal VARCHAR(1),
@lockTypeVal VARCHAR(1),
@lock_conflict INTEGER OUTPUT AS SET NOCOUNT ON
BEGIN
  DECLARE locks_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT sde_id
    FROM   sde.SDE_state_locks WITH (TABLOCKX,HOLDLOCK)
    WHERE ((state_id = @stateIdVal AND
           (sde_id <> @sdeIdVal OR 
            autolock = @autoLockVal) AND
           (lock_type = 'E' /* E: Exclusive lock */ OR 
            @lockTypeVal = 'E')) OR
          (lock_type = 'X' /* X: Exclusive lock all */ OR
           @lockTypeVal = 'X')) AND
          lock_type <> 'M'
  /* Find any conflicting locks.  The query we use is sensitive about
     whether we are trying to place an exclusive lock (in which case we
     have to consider all locks as possibly conflicting), or a shared lock
     (in which case we only have to worry about conflicting with exclusive
     locks).  With all of the about constraints in place, if any rows
     are returned, we probably have a conflict.  The last thing we have to
     check is if the connection owning the lock has somehow died without
     cleaning up. */
  OPEN locks_cursor
  DECLARE @loop_done INTEGER
  DECLARE @id INTEGER
  SET @lock_conflict = 0
  SET @loop_done = 0
  DECLARE @f_sde_id INTEGER
  WHILE @loop_done = 0
  BEGIN 
    FETCH NEXT FROM locks_cursor INTO @f_sde_id
    IF @@FETCH_STATUS = 0
    BEGIN
      /* We found a matching table lock.  See if the owning connection
         id is still out there.  If not, then this lock is invalid. */

      SELECT @id = SO.object_id
        FROM tempdb.sys.objects SO INNER JOIN
            sde.SDE_process_information        PR ON object_id (PR.table_name) = SO.object_id
        WHERE PR.sde_id = @f_sde_id

      IF @@ROWCOUNT > 0
      BEGIN
        /* we have a lock conflict! */
        SET @lock_conflict = 1
        SET @loop_done = 1
      END
      ELSE
      BEGIN
         /* defunct connection found, clean it up */
         EXECUTE sde.SDE_pinfo_def_delete @f_sde_id
      END
     END
     ELSE
       SET @loop_done = 1
  END /* while */
  CLOSE locks_cursor
  DEALLOCATE locks_cursor
END

GO
/****** Object:  StoredProcedure [sde].[SDE_state_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_state_def_delete]
@id1 BIGINT, @id2 BIGINT, @id3 BIGINT, @id4 BIGINT, @id5 BIGINT,
@id6 BIGINT, @id7 BIGINT, @id8 BIGINT AS SET NOCOUNT ON
BEGIN
  DECLARE @ret_code INTEGER
  SET @ret_code = 0
  -- If we are deleting a single state, we add an additional check
  -- to make sure that this state has no child states.  This
  -- prevents some potential timing problems with compress.
  IF @id2 = -1
  BEGIN
    DECLARE @SE_STATE_HAS_CHILDREN INTEGER
    SET @SE_STATE_HAS_CHILDREN = 50175

    DECLARE @childCount INTEGER
    SELECT @childCount = COUNT(*) FROM sde.SDE_states
      WHERE  parent_state_id = @id1
    IF @childCount <> 0
    BEGIN
      SET @ret_code = @SE_STATE_HAS_CHILDREN
      RETURN @ret_code
    END
  END

  DELETE FROM sde.SDE_mvtables_modified WHERE state_id IN
    (@id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8)

  -- Delete any lineages about to be orphaned
  DELETE FROM sde.SDE_state_lineages WHERE lineage_name IN
    (SELECT lineage_name FROM sde.SDE_states S1 WHERE state_id in
         (@id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8)
     AND NOT EXISTS (SELECT * FROM sde.SDE_states S2
     WHERE S1.lineage_name = ABS(S2.lineage_name) AND S2.state_id NOT IN
         (@id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8)))

  -- Delete the states
  DELETE FROM sde.SDE_states WHERE state_id IN
    (@id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8)

  -- Delete any automatically placed exclusive state locks.
  DELETE FROM sde.SDE_state_locks WHERE  state_id IN
    (@id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8) AND  state_id <> 0 AND
    autolock = 'Y' AND lock_type = 'E'
  RETURN @ret_code
END
GO
/****** Object:  StoredProcedure [sde].[SDE_state_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_state_def_insert]
@stateIdVal BIGINT, @ownerVal NVARCHAR(32), @pStateIdVal BIGINT,
@pLineageNameVal BIGINT OUTPUT, @sdeIdVal INTEGER,@OpenOrCloseVal INTEGER,
@crTimeVal DATETIME OUTPUT AS SET NOCOUNT ON
BEGIN
  SET XACT_ABORT OFF
  DECLARE @new_lineage_name BIGINT
  DECLARE @clTimeVal DATETIME
  SET @new_lineage_name = @pLineageNameVal

  SET @crTimeVal = GETDATE()
  -- close state
  IF @OpenOrCloseVal = 2
  BEGIN
    SET @clTimeVal = @crTimeVal
  END
  ELSE
  BEGIN
    SET @clTimeVal = NULL
  END

  BEGIN TRAN state_insert
  BEGIN TRY
    INSERT INTO sde.SDE_states (state_id,owner,
      creation_time, closing_time,parent_state_id,lineage_name) VALUES
      (@stateIdVal, @ownerVal, @crTimeVal, @clTimeVal, @pStateIdVal,
       @pLineageNameVal)
  END TRY
  BEGIN CATCH
    IF ERROR_NUMBER() = 2627 /* unique constraint violation */ 
    BEGIN
      INSERT INTO sde.SDE_states (state_id,owner,creation_time, closing_time,
                                  parent_state_id,lineage_name) VALUES 
                (@stateIdVal, @ownerVal, @crTimeVal, @clTimeVal, @pStateIdVal, 
                 @stateIdVal)
      SET @new_lineage_name = @stateIdVal
    END
    ELSE
    BEGIN
      -- rethrow unexpected error
      DECLARE @ErrorMessage    NVARCHAR(4000),
        @ErrorNumber     INT,
        @ErrorSeverity   INT,
        @ErrorState      INT,
        @ErrorLine       INT,
        @ErrorProcedure  NVARCHAR(200);
      SELECT @ErrorNumber = ERROR_NUMBER(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorLine = ERROR_LINE(),
        @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');
      SELECT @ErrorMessage = 
        N'Error %d, Level %d, State %d, Procedure %s, Line %d, ' +
        'Message: '+ ERROR_MESSAGE();
      RAISERROR (@ErrorMessage, @ErrorSeverity, 1,
        @ErrorNumber, @ErrorSeverity, @ErrorState,
        @ErrorProcedure, @ErrorLine);
    END
  END CATCH
  -- If we created a new lineage, insert it into the STATE_LINEAGE table
  --  in normalized form. 
  IF @new_lineage_name <> @pLineageNameVal
  BEGIN
    INSERT INTO sde.SDE_state_lineages (lineage_name, lineage_id)
         SELECT @new_lineage_name,l.lineage_id
         FROM sde.SDE_state_lineages l 
         WHERE l.lineage_name = @pLineageNameVal AND
               l.lineage_id <= @pStateIdVal
    SET @pLineageNameVal = @new_lineage_name
  END

  -- We also insert a row for this state, as if it were in its own
  -- state lineage. 

  INSERT INTO sde.SDE_state_lineages  (lineage_name, lineage_id)
      VALUES (@new_lineage_name,@stateIdVal)

  -- Place a mark on the new state so that it doesn't get cleaned up
  -- by compress.  Do it before the commit so it won't ever be both
  -- visible and unmarked at the same time.

  EXECUTE sde.SDE_state_lock_def_insert @sdeIdVal, @stateIdVal, 'Y', 'M'

  COMMIT TRAN state_insert
END
GO
/****** Object:  StoredProcedure [sde].[SDE_state_def_trim_states]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_state_def_trim_states]
@highStateIdVal BIGINT, @lowStateIdVal BIGINT AS SET NOCOUNT ON
BEGIN
  IF @lowStateIdVal = 0
  BEGIN
    -- Uninvert the inverted lineage names; once the delete is done
    -- it is safe to put them back. Make sure to use RC so that
    -- we don't update another process's negative lineages.
    UPDATE sde.SDE_states WITH (READCOMMITTED)
    SET    lineage_name = -lineage_name
    WHERE  lineage_name < 0 AND parent_state_id = 0
  END
  ELSE
  BEGIN
    -- Return the lineage id to a positive number.
    UPDATE sde.SDE_states
    SET    lineage_name = -lineage_name
    WHERE  state_id = @highStateIdVal
  END
END
GO
/****** Object:  StoredProcedure [sde].[SDE_state_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_state_def_update]
@stateIdVal BIGINT, @OpenOrCloseVal INTEGER,
@clTimeVal DATETIME OUTPUT AS SET NOCOUNT ON 
BEGIN
DECLARE @closeTimeVal DATETIME
SET @clTimeVal = GETDATE()
IF @OpenOrCloseVal = 2
BEGIN
  SET @closeTimeVal = @clTimeVal
END
ELSE
BEGIN
  SET @closeTimeVal = NULL
END
BEGIN TRAN state_def_update
UPDATE sde.SDE_states SET closing_time = @closeTimeVal
  WHERE state_id = @stateIdVal
COMMIT TRAN state_def_update
END
GO
/****** Object:  StoredProcedure [sde].[SDE_state_lock_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_state_lock_def_delete]
@sdeIdVal INTEGER,
@stateIdVal BIGINT,
@autoLockVal VARCHAR(1),
@markedVal INTEGER AS SET NOCOUNT ON
BEGIN TRAN state_lock_del_tran
DECLARE @ret_val INTEGER
IF (@markedVal = 0)
 DELETE FROM sde.SDE_state_locks WITH (TABLOCKX) WHERE  sde_id = @sdeIdVal AND state_id = @stateIdVal AND autolock = @autoLockVal AND lock_type <> 'M'
ELSE
 DELETE FROM sde.SDE_state_locks WITH (TABLOCKX) WHERE  sde_id = @sdeIdVal AND state_id = @stateIdVal AND autolock = @autoLockVal
IF @@ROWCOUNT = 0 SET @ret_val = -48 /* SE_NO_LOCKS */
ELSE SET @ret_val = 0 /* SE_SUCCESS */
COMMIT TRAN state_lock_del_tran
RETURN @ret_val
GO
/****** Object:  StoredProcedure [sde].[SDE_state_lock_def_delete_user]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_state_lock_def_delete_user] @sdeIdVal INTEGER AS SET NOCOUNT ON     BEGIN TRAN state_lock_tran     DELETE FROM sde.SDE_state_locks WHERE  sde_id = @sdeIdVal     COMMIT TRAN state_lock_tran
GO
/****** Object:  StoredProcedure [sde].[SDE_state_lock_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_state_lock_def_insert]
@sdeIdVal INTEGER,
@stateIdVal BIGINT,
@autoLockVal VARCHAR(1),
@lockTypeVal VARCHAR(1) AS SET NOCOUNT ON
DECLARE @isConflictVal INTEGER
DECLARE @ret_val INTEGER
BEGIN TRAN state_lock_tran

/* Marks don't conflict and it doesn't hurt if they are duplicates, */
/* so skip all that for them */
IF @lockTypeVal <> 'M' 
BEGIN
/* Delete any existing lock on this state owned by this user. */
/* This gets it out of the way during conflict checking (it will be */
/* restored via rollback if a conflict is detected).*/
  EXECUTE sde.SDE_state_lock_def_delete @sdeIdVal, @stateIdVal, @autoLockVal,0

/* check for conflicts */
  EXECUTE sde.SDE_state_check_lock_conflicts @sdeIdVal,@stateIdVal,@autoLockVal,@lockTypeVal,@isConflictVal OUTPUT
END
ELSE
BEGIN
  SET @isConflictVal = 0
END

IF (@isConflictVal = 0)
BEGIN
  INSERT INTO sde.SDE_state_locks
         (sde_id,state_id,autolock,lock_type)
  VALUES (@sdeIdVal,@stateIdVal,@autoLockVal,@lockTypeVal)
  SET @ret_val = 0 /* SE_SUCCESS */ 
  COMMIT TRAN state_lock_tran
END
ELSE
BEGIN
  SET @ret_val = -49 /* SE_LOCK_CONFLICT */
  ROLLBACK TRAN state_lock_tran
END
RETURN @ret_val
GO
/****** Object:  StoredProcedure [sde].[SDE_state_new_edit]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_state_new_edit]
@stateIdVal BIGINT, @ownerVal NVARCHAR(32),
@pStateIdVal BIGINT, @pLineageNameVal BIGINT OUTPUT,
@sdeIdVal INTEGER,
@crTimeVal DATETIME OUTPUT AS SET NOCOUNT ON
BEGIN
  DECLARE @new_lineage_name BIGINT
  DECLARE @ClosingTime DATETIME

  BEGIN TRAN state_new_edit
  --  Close parent state if it is open
  SELECT @ClosingTime = closing_time FROM sde.SDE_states
     WHERE state_id = @pStateIdVal

  SET @crTimeVal = GETDATE()
  IF @ClosingTime  IS NULL
  BEGIN
     UPDATE sde.SDE_states SET closing_time =  @crTimeVal 
          WHERE state_id = @pStateIdVal
  END

  SET @new_lineage_name = @pLineageNameVal
  BEGIN TRY
    INSERT INTO sde.SDE_states (state_id,owner,
      creation_time, closing_time,parent_state_id,lineage_name) VALUES
      (@stateIdVal, @ownerVal, @crTimeVal, NULL, @pStateIdVal,
       @pLineageNameVal)
  END TRY
  BEGIN CATCH
    IF ERROR_NUMBER() = 2627 /* unique constraint violation */ 
    BEGIN
      INSERT INTO sde.SDE_states (state_id,owner,creation_time, closing_time,
                                  parent_state_id,lineage_name) VALUES 
                (@stateIdVal, @ownerVal, @crTimeVal, NULL, @pStateIdVal, 
                 @stateIdVal)
      SET @new_lineage_name = @stateIdVal
    END
    ELSE
    BEGIN
      -- rethrow unexpected error
      DECLARE @ErrorMessage    NVARCHAR(4000),
        @ErrorNumber     INT,
        @ErrorSeverity   INT,
        @ErrorState      INT,
        @ErrorLine       INT,
        @ErrorProcedure  NVARCHAR(200);
      SELECT @ErrorNumber = ERROR_NUMBER(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorLine = ERROR_LINE(),
        @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');
      SELECT @ErrorMessage = 
        N'Error %d, Level %d, State %d, Procedure %s, Line %d, ' +
        'Message: '+ ERROR_MESSAGE();
      RAISERROR (@ErrorMessage, @ErrorSeverity, 1,
        @ErrorNumber, @ErrorSeverity, @ErrorState,
        @ErrorProcedure, @ErrorLine);
    END
  END CATCH
  -- If we created a new lineage, insert it into the STATE_LINEAGE table
  --  in normalized form. 
  IF @new_lineage_name <> @pLineageNameVal
  BEGIN
    INSERT INTO sde.SDE_state_lineages (lineage_name, lineage_id)
         SELECT @new_lineage_name,l.lineage_id
         FROM sde.SDE_state_lineages l 
         WHERE l.lineage_name = @pLineageNameVal AND
               l.lineage_id <= @pStateIdVal
    SET @pLineageNameVal = @new_lineage_name
  END

  -- We also insert a row for this state, as if it were in its own
  -- state lineage. 

  INSERT INTO sde.SDE_state_lineages  (lineage_name, lineage_id)
      VALUES (@new_lineage_name,@stateIdVal)

  -- Place a lock entry in the SDE_state_locks table.  Doing this directly
  -- is both safe and necessary.  Safe, as this is a newly created state
  -- so there can not be a conflict; necessary as this function needs to
  -- be efficient and secure, this is the only way to avoid rechecking
  -- the current user's access rights.

  INSERT INTO sde.SDE_state_locks(sde_id,state_id,autolock,lock_type)
     VALUES (@sdeIdVal, @stateIdVal, 'N', 'E')
  COMMIT TRAN state_new_edit

END
GO
/****** Object:  StoredProcedure [sde].[SDE_state_trim_pre_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_state_trim_pre_delete]
@highStateIdVal BIGINT, @lowStateIdVal BIGINT AS SET NOCOUNT ON
BEGIN
  IF @lowStateIdVal = 0
  BEGIN
    -- We need to delete any modified flags before changing the high
    -- state to be the base state, or the states<->mvtables_modified
    -- integrity constraint will be violated, aborting the following.
    -- UPDATE. Similarly, we must also remove old state_lineages entries.

    DELETE FROM sde.SDE_mvtables_modified
    WHERE  state_id  = @highStateIdVal
    DELETE FROM sde.SDE_state_lineages
    WHERE  lineage_id  = @highStateIdVal

    -- We need to insert a 0,0 entry in the state_lineages table
    -- if it doesn't exist.
    DECLARE @baseIdExists INTEGER
    SELECT @baseIdExists = count(*) FROM sde.SDE_state_lineages
      WHERE lineage_name = 0 AND lineage_id = 0
    IF (@baseIdExists = 0)
    BEGIN
      INSERT INTO sde.SDE_state_lineages (lineage_name,lineage_id) VALUES (0,0)
    END
    -- Make sure the base state is closed and proper.
    UPDATE sde.SDE_states
      SET parent_state_id = 0,
          owner = 'sde',
          closing_time = ISNULL (closing_time,GETDATE()),
          lineage_name = 0
      WHERE state_id = 0
    -- Make the lineage_name negative of any immediate child state
    -- of the state becoming the base state, so that when we update
    -- the parent_state_id to become the base_state_id, we don't
    -- violate the states_uk constraint on parent_state_id and
    -- lineage_name.
    UPDATE sde.SDE_states
      SET    lineage_name = -lineage_name
      WHERE  parent_state_id = @highStateIdVal
    -- Update the parent_id of any immediate child state of the state
    -- becoming the base state to be the base state.
    UPDATE sde.SDE_states
      SET    parent_state_id = 0
      WHERE  parent_state_id = @highStateIdVal
    -- Update any versions based on the state becoming the base state
    -- to point at the base state instead.
    UPDATE sde.SDE_versions
      SET    state_id = 0
      WHERE  state_id = @highStateIdVal
    -- Remove the high_state now that it has been compressed.
    DELETE FROM sde.SDE_states
    WHERE  state_id = @highStateIdVal
  END
  ELSE
  BEGIN
    -- Update the parent_id but also invert the lineage id to avoid
    -- violating states_uk.
    UPDATE sde.SDE_states
    SET    parent_state_id = (SELECT parent_state_id
                              FROM  sde.SDE_states
                              WHERE  state_id = @lowStateIdVal),
           lineage_name = -lineage_name
    WHERE  state_id = @highStateIdVal
  END
END
GO
/****** Object:  StoredProcedure [sde].[SDE_table_check_lock_conflicts]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_table_check_lock_conflicts]
@sdeIdVal INTEGER,
@registrationIdVal INTEGER,
@lockTypeVal VARCHAR(1),
@lock_conflict INTEGER OUTPUT AS SET NOCOUNT ON
BEGIN
  DECLARE locks_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT sde_id
    FROM   sde.SDE_table_locks WITH (TABLOCKX,HOLDLOCK)
    WHERE  registration_id = @registrationIdVal AND
           (lock_type = 'E' /* E: Exclusive lock */ OR
           @lockTypeVal = 'E')
  /* Find any conflicting locks.  The query we use is sensitive about
     whether we are trying to place an exclusive lock (in which case we
     have to consider all locks as possibly conflicting), or a shared lock
     (in which case we only have to worry about conflicting with exclusive
     locks).  With all of the about constraints in place, if any rows
     are returned, we probably have a conflict.  The last thing we have to
     check is if the connection owning the lock has somehow died without
     cleaning up. */
  OPEN locks_cursor
  DECLARE @loop_done INTEGER
  DECLARE @id INTEGER
  SET @lock_conflict = 0
  SET @loop_done = 0
  DECLARE @f_sde_id INTEGER
  WHILE @loop_done = 0
  BEGIN 
    FETCH NEXT FROM locks_cursor
      INTO @f_sde_id
    IF @@FETCH_STATUS = 0
    BEGIN
      /* We found a matching table lock.  See if the owning connection
         id is still out there.  If not, then this lock is invalid. */

      SELECT @id = SO.object_id
        FROM tempdb.sys.objects SO INNER JOIN
            sde.SDE_process_information        PR ON object_id (PR.table_name) = SO.object_id
        WHERE PR.sde_id = @f_sde_id

      IF @@ROWCOUNT > 0
      BEGIN
        /* we have a lock conflict! */
        SET @lock_conflict = 1
        SET @loop_done = 1
      END
      ELSE
      BEGIN
         /* defunct connection found, clean it up */
         EXECUTE sde.SDE_pinfo_def_delete @f_sde_id
      END
     END
     ELSE
       SET @loop_done = 1
  END /* while */
  CLOSE locks_cursor
  DEALLOCATE locks_cursor
END

GO
/****** Object:  StoredProcedure [sde].[SDE_table_lock_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_table_lock_def_delete] @sdeIdVal INTEGER, @registrationIdVal INTEGER AS     SET NOCOUNT ON BEGIN TRAN table_lock_del_tran     DECLARE @ret_val INTEGER     DELETE FROM sde.SDE_table_locks WITH (TABLOCKX) WHERE  sde_id = @sdeIdVal AND     registration_id = @registrationIdVal     IF @@ROWCOUNT = 0 SET @ret_val = -48 /* SE_NO_LOCKS */     ELSE SET @ret_val = 0 /* SE_SUCCESS */     COMMIT TRAN table_lock_del_tran     RETURN @ret_val
GO
/****** Object:  StoredProcedure [sde].[SDE_table_lock_def_delete_user]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_table_lock_def_delete_user] @sdeIdVal INTEGER AS SET NOCOUNT ON     BEGIN TRAN table_lock_tran     DELETE FROM sde.SDE_table_locks WHERE  sde_id = @sdeIdVal     COMMIT TRAN table_lock_tran
GO
/****** Object:  StoredProcedure [sde].[SDE_table_lock_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_table_lock_def_insert]
@sdeIdVal INTEGER,
@registrationIdVal INTEGER,
@lockTypeVal VARCHAR(1) AS SET NOCOUNT ON
DECLARE @isConflictVal INTEGER
DECLARE @ret_val INTEGER
BEGIN TRAN table_lock_tran

/* Delete any existing lock on this table owned by this user.*/
/* This gets it out of the way during conflict checking (it will be*/
/* restored via rollback if a conflict is detected).*/
EXECUTE sde.SDE_table_lock_def_delete @sdeIdVal, @registrationIdVal

/* check for conflicts */
EXECUTE sde.SDE_table_check_lock_conflicts @sdeIdVal,@registrationIdVal,@lockTypeVal,@isConflictVal OUTPUT
IF (@isConflictVal = 0)
BEGIN
  INSERT INTO sde.SDE_table_locks
         (sde_id,registration_id,lock_type)
  VALUES (@sdeIdVal,@registrationIdVal,@lockTypeVal)
  SET @ret_val = 0 /* SE_SUCCESS */ 
  COMMIT TRAN table_lock_tran
END
ELSE
BEGIN
  SET @ret_val = -49 /* SE_LOCK_CONFLICT */
  ROLLBACK TRAN table_lock_tran
END
RETURN @ret_val

GO
/****** Object:  StoredProcedure [sde].[SDE_versions_def_change_state]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_versions_def_change_state] @newStateIdVal BIGINT,      @nameVal NVARCHAR(64), @ownerVal NVARCHAR(32), @oldStateIdVal BIGINT AS      SET NOCOUNT OFF      UPDATE sde.SDE_versions SET       state_id = @newStateIdVal WHERE name = @nameVal and owner = @ownerVal AND       state_id = @oldStateIdVal
GO
/****** Object:  StoredProcedure [sde].[SDE_versions_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_versions_def_delete]       @ownerVal NVARCHAR(32), @nameVal  NVARCHAR(64) AS SET NOCOUNT ON      DECLARE @result INTEGER      SET @result = 0      IF UPPER(@ownerVal) = UPPER('sde') AND UPPER(@nameVal) = 'DEFAULT'        SET @result = -25 /* SE_NO_PERMISSIONS */      ELSE        DELETE FROM sde.SDE_versions WHERE owner = @ownerVal AND name = @nameVal      RETURN @result
GO
/****** Object:  StoredProcedure [sde].[SDE_versions_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_versions_def_insert]
@nameVal NVARCHAR(64) OUTPUT, @ownerVal NVARCHAR(32), @versionIdVal INTEGER,
@statusVal INTEGER, @stateIdVal BIGINT, @descVal NVARCHAR(64),
@pNameVal NVARCHAR(64), @pOwnerVal NVARCHAR(32), @pVersionIdVal INTEGER,
@dateVal DATETIME, @nameRuleVal INTEGER AS SET NOCOUNT ON
BEGIN
  DECLARE @suffix INTEGER
  DECLARE @ret_code INTEGER
  DECLARE @err_code INTEGER
  DECLARE @error_string NVARCHAR(256)
  DECLARE @local_version_name NVARCHAR(65)
  DECLARE @done INTEGER

  DECLARE @SE_VERSION_EXIST INTEGER
  SET @SE_VERSION_EXIST = 50177

  SET @local_version_name = RTRIM (@nameVal)
  SET @done = 0
  SET @suffix = 0

  WHILE @done = 0
  BEGIN 
    INSERT INTO sde.SDE_versions (name, owner, version_id, status,
      state_id, description, parent_name, parent_owner,
      parent_version_id, creation_time) VALUES (
      @local_version_name,@ownerVal,@versionIdVal,@statusVal,@stateIdVal,
      @descVal,@pNameVal,@pOwnerVal,@pVersionIdVal,@dateVal)
    SET @err_code = @@error
    IF @err_code = 0
    BEGIN
      -- Insert worked, exit loop
      SET @done = 1
      SET @ret_code = 0
    END
    ELSE
    BEGIN
      IF @err_code = 2627
      BEGIN
        IF @nameRuleVal = 1
        BEGIN
          -- Unique constraint violation, let's try to generate a
          -- unique name
          SET @suffix = @suffix + 1
          SET @local_version_name = RTRIM (@nameVal) +
                                    cast (@suffix AS NVARCHAR(10))
          IF LEN (@local_version_name) > 64
          BEGIN
            SET @done = 1
            SET @ret_code = @SE_VERSION_EXIST
            SET @error_string = N'Unable to generate a name for ' + @nameVal
            RAISERROR (@error_string,16,-1)
          END
        END
        ELSE
        BEGIN
          -- Unique constraint violation, and we are not generating
          -- unique names
          SET @done = 1
          SET @ret_code = @SE_VERSION_EXIST
          SET @error_string = N'Version ' +  @nameVal + N' already exists.'
          RAISERROR (@error_string,16,-1)
        END
      END
      ELSE
      BEGIN
        -- Some other error occurred
        SET @done = 1
        SET @ret_code = @err_code
        SET @error_string = N'Unable to create version ' +  @nameVal
        RAISERROR (@error_string,16,-1)
      END
    END
  END

  -- Set the returned name, in case we changed it.
  SET @nameVal = @local_version_name

  RETURN @ret_code
END

GO
/****** Object:  StoredProcedure [sde].[SDE_versions_def_rename]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_versions_def_rename] @newNameVal     NVARCHAR(64), @oldNameVal NVARCHAR(64), @ownerVal NVARCHAR(32) AS    DECLARE @result INTEGER    SET @result = 0    IF UPPER(@ownerVal) = 'sde' AND UPPER(@oldNameVal) = 'DEFAULT'      SET @result = -25 /* SE_NO_PERMISSIONS */    ELSE    BEGIN      SET NOCOUNT OFF      UPDATE sde.SDE_versions SET name = @newNameVal        WHERE name = @oldNameVal and owner = @ownerVal    END    RETURN @result
GO
/****** Object:  StoredProcedure [sde].[SDE_versions_def_rename_parent]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_versions_def_rename_parent] @newNameVal     NVARCHAR(64), @oldNameVal NVARCHAR(64), @ownerVal NVARCHAR(32) AS    SET NOCOUNT OFF    UPDATE sde.SDE_versions     SET parent_name = @newNameVal WHERE parent_name = @oldNameVal    AND parent_owner = @ownerVal
GO
/****** Object:  StoredProcedure [sde].[SDE_versions_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_versions_def_update]        @statusVal INTEGER, @descVal NVARCHAR(64), @nameVal NVARCHAR(64),        @ownerVal NVARCHAR(32) AS SET NOCOUNT ON UPDATE sde.SDE_versions SET status = @statusVal,        description = @descVal WHERE name = @nameVal and owner = @ownerVal
GO
/****** Object:  StoredProcedure [sde].[SDE_xml_columns_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_xml_columns_def_delete]
@columnIdVal INTEGER AS SET NOCOUNT ON
BEGIN
DELETE FROM sde.SDE_xml_columns WHERE column_id =  @columnIdVal
END

GO
/****** Object:  StoredProcedure [sde].[SDE_xml_columns_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_xml_columns_def_insert]
@regIdVal INTEGER, @colNameVal NVARCHAR(32),
@indexIdVal INTEGER, @minimumIdVal INTEGER,
@configKeywordVal NVARCHAR(32), @xflagsVal INTEGER
AS SET NOCOUNT ON
BEGIN
INSERT INTO sde.SDE_xml_columns
  (registration_id, column_name, index_id, minimum_id, config_keyword, xflags) VALUES
  (@regIdVal, @colNameVal, @indexIdVal, @minimumIdVal, @configKeywordVal, @xflagsVal)
DECLARE @column_id INTEGER
SELECT @column_id = @@IDENTITY
RETURN @column_id
END

GO
/****** Object:  StoredProcedure [sde].[SDE_xml_columns_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_xml_columns_def_update]
@columnIdVal INTEGER, @indexIdVal INTEGER, @minimumIdVal INTEGER,
@configKeywordVal NVARCHAR(32), @xflagsVal INTEGER
AS SET NOCOUNT ON
BEGIN
-- Either we're updating all three columns, or just the index
IF @minimumIdVal IS NOT NULL
BEGIN
  UPDATE sde.SDE_xml_columns
  SET index_id =  @indexIdVal,
  minimum_id =  @minimumIdVal,
  config_keyword =  @configKeywordVal,
  xflags =  @xflagsVal
  WHERE column_id =  @columnIdVal
END
ELSE
BEGIN
  UPDATE sde.SDE_xml_columns
  SET index_id =  @indexIdVal
  WHERE column_id =  @columnIdVal
END
END

GO
/****** Object:  StoredProcedure [sde].[SDE_xml_index_tags_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_xml_index_tags_def_delete]
@indexIdVal INTEGER, @id1 INTEGER, @id2 INTEGER, @id3 INTEGER,
@id4 INTEGER, @id5 INTEGER, @id6 INTEGER, @id7 INTEGER, @id8 INTEGER AS
SET NOCOUNT ON
BEGIN
  DELETE FROM sde.SDE_xml_index_tags WHERE index_id = @indexIdVal
  AND tag_id IN (@id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8)
END
GO
/****** Object:  StoredProcedure [sde].[SDE_xml_index_tags_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_xml_index_tags_def_insert]
@index_id INTEGER, @tagNameVal NVARCHAR(1024),
@dataTypeVal INTEGER, @tagAliasVal INTEGER,
@descriptionVal NVARCHAR(64), @excluded  INTEGER
AS SET NOCOUNT ON
BEGIN
  INSERT INTO sde.SDE_xml_index_tags
   (index_id, tag_name, data_type, tag_alias, description, is_excluded)   VALUES (@index_id, @tagNameVal, @dataTypeVal, @tagAliasVal,
           @descriptionVal, @excluded)
  DECLARE @tag_id INTEGER
  SELECT @tag_id = @@IDENTITY
  RETURN @tag_id
END

GO
/****** Object:  StoredProcedure [sde].[SDE_xml_index_tags_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_xml_index_tags_def_update]
@indexIdVal INTEGER, @tagNameVal NVARCHAR(1024),
@tagAliasVal INTEGER, @descriptionVal NVARCHAR(64),
@isExcludedVal INTEGER AS
SET NOCOUNT ON
BEGIN
  UPDATE sde.SDE_xml_index_tags SET tag_alias = @tagAliasVal,
    description = @descriptionVal, is_excluded = @isExcludedVal
    WHERE index_id = @indexIdVal AND tag_name = @tagNameVal
END
GO
/****** Object:  StoredProcedure [sde].[SDE_xml_indexes_def_delete]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_xml_indexes_def_delete]
@ownerVal NVARCHAR(32),@indexNameVal NVARCHAR(64) AS
SET NOCOUNT ON BEGIN
BEGIN TRAN xml_index_del
-- Delete index record. Cascading constraint will delete from sde.SDE_xml_index_tags 
DELETE FROM sde.SDE_xml_indexes
  WHERE owner = @ownerVal AND index_name = @indexNameVal
COMMIT TRAN xml_index_del
END

GO
/****** Object:  StoredProcedure [sde].[SDE_xml_indexes_def_insert]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_xml_indexes_def_insert]
@ownerVal NVARCHAR(32),@indexNameVal NVARCHAR(32),
@indexTypeVal INTEGER, @descriptionVal NVARCHAR(64) AS
SET NOCOUNT ON BEGIN
INSERT INTO sde.SDE_xml_indexes(index_name, owner, index_type, description) VALUES 
  (@indexNameVal, @ownerVal, @indexTypeVal, @descriptionVal)
DECLARE @index_id INTEGER
SELECT @index_id = @@IDENTITY
RETURN @index_id
END

GO
/****** Object:  StoredProcedure [sde].[SDE_xml_indexes_def_update]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[SDE_xml_indexes_def_update]
@index_id INTEGER, @indexNameVal NVARCHAR(32),
@descriptionVal NVARCHAR(64)
AS SET NOCOUNT ON
BEGIN
  UPDATE sde.SDE_xml_indexes
   SET index_name = @indexNameVal, description = @descriptionVal
   WHERE index_id = @index_id
END

GO
/****** Object:  StoredProcedure [sde].[set_current_version]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[set_current_version] 
@version_name NVARCHAR (97) AS SET NOCOUNT ON
BEGIN
-- This is a public support function for SDE versioned views. When working with
-- versioned views, call this procedure with the version name you wish the views to
-- reflect. Failure to call this procedure will cause versioned views to be based
-- on version 'sde.default'.

DECLARE @error_string NVARCHAR(256)
DECLARE @ret_code INTEGER
DECLARE @version_id INTEGER
DECLARE @parsed_name NVARCHAR (64)
DECLARE @parsed_owner NVARCHAR (32)

-- Parse the version name.
EXECUTE @ret_code = sde.SDE_parse_version_name @version_name,
                    @parsed_name OUTPUT,  @parsed_owner OUTPUT
IF (@ret_code != 0)
  RETURN
-- Fetch the state id.
DECLARE @state_id BIGINT
DECLARE @status INTEGER
SELECT @state_id = v.state_id, @status = v.status, @version_id = v.version_id
FROM   sde.SDE_versions v
WHERE  v.name = @parsed_name AND
       v.owner = @parsed_owner;
IF @state_id IS NULL
BEGIN
  SET @error_string = 'Version ' + @version_name + ' not found.'
  RAISERROR (@error_string,16,-1)
  RETURN
END
-- Check the version status: if private, we must be owner to continue,
-- if protected, note for future use.
DECLARE @protected CHAR (1)
SET @protected = sde.SDE_get_version_access (@status, @parsed_owner)
IF @protected = '2'
BEGIN
  DECLARE @login  NVARCHAR (128)
  SELECT @login = suser_sname()
  SET @error_string = @login + ' is not the owner of version ' + 
                      @version_name + '.'
  RAISERROR (@error_string,16,-1)
  RETURN
END

-- Check if we are already in an edit session.
DECLARE @g_state_id BIGINT
DECLARE @g_protected CHAR(1)
DECLARE @g_is_default CHAR(1)
DECLARE @g_version_id INTEGER
EXECUTE sde.SDE_get_globals @g_state_id OUTPUT,@g_protected OUTPUT,@g_is_default OUTPUT,@g_version_id OUTPUT
IF @g_version_id != -1 AND @g_version_id != @version_id
BEGIN
  -- Check that version and state still exist (e.g. may have been rolled back)
  DECLARE @exists INTEGER
  SELECT @exists = count(*) from sde.SDE_versions
    WHERE version_id = @g_version_id
  IF @exists > 0
  BEGIN
    SELECT @exists = count(*) from sde.SDE_states
      WHERE state_id = @g_state_id
    IF @exists > 0
    BEGIN
      SET @error_string = 'Cannot set version with an open transaction to another version.'
      RAISERROR (@error_string,16,-1)
     RETURN
    END
  END
  -- state or version do not exist, clear any edit session we were in
  SET @g_version_id = -1
END

-- Finally, set the global info
DECLARE @is_default CHAR(1)
IF @parsed_owner = 'sde' AND @parsed_name = 'DEFAULT'
  SET @is_default = '1'
ELSE
  SET @is_default = '0'
EXECUTE sde.SDE_set_globals @state_id,@protected,@is_default,@g_version_id 
END

GO
/****** Object:  StoredProcedure [sde].[set_default]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[set_default] 
AS SET NOCOUNT ON
BEGIN
  /* This is a public procedure to set multi version views
  to point to the default version, even as other processes
  might be moving the default version to new states.*/

  -- Check if we are already in an edit session.
  DECLARE @g_state_id BIGINT
  DECLARE @g_protected CHAR(1)
  DECLARE @g_is_default CHAR(1)
  DECLARE @g_version_id INTEGER
  EXECUTE sde.SDE_get_globals   @g_state_id OUTPUT,@g_protected OUTPUT,@g_is_default OUTPUT,@g_version_id OUTPUT
  IF @g_version_id != -1
  BEGIN
    -- Check that version and state still exist (e.g. may have been rolled back)
    DECLARE @exists INTEGER
    SELECT @exists = count(*) from sde.SDE_versions
      WHERE version_id = @g_version_id
    IF @exists > 0
    BEGIN
      SELECT @exists = count(*) from sde.SDE_states
        WHERE state_id = @g_state_id
      IF @exists > 0
      BEGIN
        DECLARE @error_string NVARCHAR(256)
        SET @error_string = 'Cannot set default with an open transaction to another version.'
        RAISERROR (@error_string,16,-1)
        RETURN
      END
    END
  END

  SET CONTEXT_INFO 0x0
END

GO
/****** Object:  StoredProcedure [sde].[spatial_ref_info]    Script Date: 15/09/2022 09:34:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sde].[spatial_ref_info]
@owner NVARCHAR(128), @table NVARCHAR(128), @column NVARCHAR(128),
@wkid INT OUTPUT, @wkt NVARCHAR(4000) OUTPUT, @st_srid INT OUTPUT
AS SET NOCOUNT ON
BEGIN
DECLARE @layer_table NVARCHAR (128)
DECLARE @get_meta_spref INT

SET @get_meta_spref = 0 --Assume no metadata
SET @layer_table = @table

SELECT @layer_table = table_name FROM sde.SDE_table_registry
  WHERE owner = @owner AND table_name = @table
IF @@ROWCOUNT = 0
BEGIN
  SELECT @layer_table = table_name FROM sde.SDE_table_registry
    WHERE owner = @owner AND imv_view_name = @table
  IF @@ROWCOUNT > 0
    SET @get_meta_spref = 1
END
ELSE
  SET @get_meta_spref = 1

IF @get_meta_spref = 1
BEGIN
  -- table is registered, see if it's in the layers table
  SELECT @wkid = s.auth_srid, @wkt = s.srtext, @st_srid = s.srid 
  FROM sde.SDE_layers l INNER JOIN sde.SDE_spatial_references s
  ON l.srid = s.srid
  WHERE l.owner = @owner and l.table_name = @layer_table AND l.spatial_column = @column
  IF @@ROWCOUNT > 0
    RETURN -- we're done!
END

-- Need to get the spatial info from first shape
DECLARE @sql NVARCHAR(256)
SET @sql = N'SELECT TOP 1 @intval = ' + @column + '.STSrid FROM ' + @owner +  '.' + @layer_table +
           ' WHERE ' + @column + ' IS NOT NULL'
EXECUTE sp_executesql @sql, N'@intval integer output', @intval = @st_srid output

SELECT @wkid = spatial_reference_id, @wkt = well_known_text FROM sys.spatial_reference_systems
  WHERE spatial_reference_id = @st_srid
END

GO
