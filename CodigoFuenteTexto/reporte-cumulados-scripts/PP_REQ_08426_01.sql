---------------------------------------------------------------------------------------------------
-- Sistema            : Sistema Integrado de Gestión Administrativa – SIGA.
-- Descripción        : Modificar sp
-- Fecha de Creación  : 2025/12/22
-- Requerimiento      : 08426
-- Autor              : ACOAGUILA
-- Observación        : Ninguna
----------------------------------------------------------------------------------------------------
SELECT 'INICIO PP_REQ_08426_01.sql -  ' + CONVERT(varchar, GETDATE(), 100);
----------------------------------------------------------------------------------------------------
GO

ALTER PROCEDURE [Nomina].[Sp_Reporte_Acumulados]
--DECLARE 
@pi_empleado INT = 9606,
@ps_AllTipoPlanilla CHAR(1) = 'S',
@ps_TipoPlanilla VARCHAR(2) = '',
@ps_AllTipoProceso CHAR(1) = 'S',
@ps_TipoProceso VARCHAR(4000) = '',
@ps_AllConcepto CHAR(1) = 'N',
@ps_Concepto VARCHAR(4) = '0122',
@ps_TipoConcepto CHAR(2) = 'S',
@ps_Anio CHAR(4) = '2018',
@ps_AllPeriodo CHAR(1) = 'N',
@ps_PDesde CHAR(6) = '201801',
@ps_PHasta CHAR(6) = '201808',
@ps_ConReintegro CHAR(1) = 'S',
@ps_IncluirExternos CHAR(1) = 'S',
@ps_SoloAfectos5ta CHAR(1) = 'N',
@ps_AllCentrocosto CHAR(1) = 'S',
@ps_Centrocosto1 VARCHAR(4000) = '',
@ps_Centrocosto2 VARCHAR(4000) = '',
@ps_Formato CHAR(1) = '1'
AS
BEGIN
	CREATE TABLE #TEMP_ACUMULADO (Persona INT NOT NULL, PersonaAnt CHAR(15), PersonaActual INT NOT NULL, Concepto CHAR(4) NOT NULL, Descripcion VARCHAR(50), 
									 TipoPlanilla CHAR(2) NOT NULL, TipoProceso VARCHAR(3), Periodo varchar(4), M01 FLOAT, M02 FLOAT, M03 FLOAT, M04 FLOAT, M05 FLOAT,
									 M06 FLOAT, M07 FLOAT, M08 FLOAT, M09 FLOAT, M10 FLOAT, M11 FLOAT, M12 FLOAT, cCompaniasocio CHAR(8), CentroCosto CHAR(10),MontoTotal FLOAT)
	CREATE INDEX idx_empleado ON #TEMP_ACUMULADO (Persona ASC)

	DECLARE @SQL_1_1_1 VARCHAR (4000) = NULL,@SQL_1_1_2 VARCHAR (4000) = NULL,@SQL_1_2 VARCHAR (4000) = NULL,@SQL_1_3 VARCHAR (8000) = NULL,@SQL_1_4 VARCHAR (4000) = NULL
	DECLARE @SQL_2_1 VARCHAR (8000) = NULL,@SQL_2_2 VARCHAR (4000) = NULL,@SQL_2_3 VARCHAR (4000) = NULL
	DECLARE @SQL_3_1 VARCHAR (4500) = NULL,@SQL_3_2 VARCHAR (4000) = NULL,@SQL_3_3 VARCHAR (4000) = NULL
	DECLARE @SQL_PERIODO_1 VARCHAR (4000) = NULL,@SQL_PERIODO_2 VARCHAR (4000) = NULL,@SQL_PERIODO_3 VARCHAR (4000) = NULL
	DECLARE @SQL_5TA_1 VARCHAR (4000) = NULL,@SQL_5TA_2 VARCHAR (4000) = NULL
	DECLARE @SQL_CC VARCHAR (8000) = NULL
	DECLARE @SQL_FORMATO VARCHAR (8000) = NULL

									 
	SET @SQL_1_1_1 = 'SELECT Persona = PR_PlanillaEmpleadoConcepto.Empleado,   
			PersonaAnt = '''',
			PersonaActual = (SELECT Max(Empleado) FROM RecursosHumanos.f_Obtener_IdEmpleado_Docs_Identidad(PR_PlanillaEmpleadoConcepto.Empleado)),
			PR_PlanillaEmpleadoConcepto.Concepto,   
			PR_Concepto.Descripcion,   
			PR_PlanillaEmpleadoConcepto.TipoPlanilla,   
			TipoProceso = ''''  ,
			LEFT(PR_PlanillaEmpleado.Periodo,4) Periodo, '
	IF @ps_Formato = '1'
	BEGIN		
		SET @SQL_FORMATO = 'SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 1 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) AS M01,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 2 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) AS M02,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 3 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) AS M03,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 4 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) AS M04,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 5 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) AS M05,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 6 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) AS M06,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 7 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) AS M07,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 8 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) AS M08,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 9 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) AS M09,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 10 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) AS M10,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 11 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) AS M11,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 12 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) AS M12, '  
	END
	ELSE
	BEGIN
		SET @SQL_FORMATO = 'CASE WHEN PR_PlanillaEmpleadoConcepto.Concepto = ''0010'' AND SUBSTRING( PR_PlanillaEmpleado.Periodo , 1,4) >= ''2015''
				 THEN SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 1 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) - 
					  Nomina.f_obtener_monto_dscto_0010(PR_PlanillaEmpleadoConcepto.Empleado,PR_PlanillaEmpleadoConcepto.TipoPlanilla,LEFT(PR_PlanillaEmpleado.Periodo,4)+''0101'',PR_PlanillaEmpleado.CentroCosto)
				 ELSE SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 1 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) END AS M01,

			CASE WHEN PR_PlanillaEmpleadoConcepto.Concepto = ''0010'' AND SUBSTRING( PR_PlanillaEmpleado.Periodo , 1,4) >= ''2015''
				 THEN SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 2 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) - 
					  Nomina.f_obtener_monto_dscto_0010(PR_PlanillaEmpleadoConcepto.Empleado,PR_PlanillaEmpleadoConcepto.TipoPlanilla,LEFT(PR_PlanillaEmpleado.Periodo,4)+''0202'',PR_PlanillaEmpleado.CentroCosto)
				 ELSE SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 2 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) END AS M02,

			CASE WHEN PR_PlanillaEmpleadoConcepto.Concepto = ''0010'' AND SUBSTRING( PR_PlanillaEmpleado.Periodo , 1,4) >= ''2015''
				 THEN SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 3 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) - 
					  Nomina.f_obtener_monto_dscto_0010(PR_PlanillaEmpleadoConcepto.Empleado,PR_PlanillaEmpleadoConcepto.TipoPlanilla,LEFT(PR_PlanillaEmpleado.Periodo,4)+''0303'',PR_PlanillaEmpleado.CentroCosto)
				 ELSE SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 3 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) END AS M03,

			CASE WHEN PR_PlanillaEmpleadoConcepto.Concepto = ''0010'' AND SUBSTRING( PR_PlanillaEmpleado.Periodo , 1,4) >= ''2015''
				 THEN SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 4 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) - 
					  Nomina.f_obtener_monto_dscto_0010(PR_PlanillaEmpleadoConcepto.Empleado,PR_PlanillaEmpleadoConcepto.TipoPlanilla,LEFT(PR_PlanillaEmpleado.Periodo,4)+''0404'',PR_PlanillaEmpleado.CentroCosto)
				 ELSE SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 4 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) END AS M04,     

			CASE WHEN PR_PlanillaEmpleadoConcepto.Concepto = ''0010'' AND SUBSTRING( PR_PlanillaEmpleado.Periodo , 1,4) >= ''2015''
				 THEN SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 5 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) - 
					  Nomina.f_obtener_monto_dscto_0010(PR_PlanillaEmpleadoConcepto.Empleado,PR_PlanillaEmpleadoConcepto.TipoPlanilla,LEFT(PR_PlanillaEmpleado.Periodo,4)+''0505'',PR_PlanillaEmpleado.CentroCosto)
				 ELSE SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 5 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) END AS M05,

			CASE WHEN PR_PlanillaEmpleadoConcepto.Concepto = ''0010'' AND SUBSTRING( PR_PlanillaEmpleado.Periodo , 1,4) >= ''2015''
				 THEN SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 6 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) - 
					  Nomina.f_obtener_monto_dscto_0010(PR_PlanillaEmpleadoConcepto.Empleado,PR_PlanillaEmpleadoConcepto.TipoPlanilla,LEFT(PR_PlanillaEmpleado.Periodo,4)+''0606'',PR_PlanillaEmpleado.CentroCosto)
				 ELSE SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 6 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) END AS M06,

			CASE WHEN PR_PlanillaEmpleadoConcepto.Concepto = ''0010'' AND SUBSTRING( PR_PlanillaEmpleado.Periodo , 1,4) >= ''2015''
				 THEN SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 7 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) - 
					  Nomina.f_obtener_monto_dscto_0010(PR_PlanillaEmpleadoConcepto.Empleado,PR_PlanillaEmpleadoConcepto.TipoPlanilla,LEFT(PR_PlanillaEmpleado.Periodo,4)+''0707'',PR_PlanillaEmpleado.CentroCosto)
				 ELSE SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 7 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) END AS M07,          

			CASE WHEN PR_PlanillaEmpleadoConcepto.Concepto = ''0010'' AND SUBSTRING( PR_PlanillaEmpleado.Periodo , 1,4) >= ''2015''
				 THEN SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 8 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) - 
					  Nomina.f_obtener_monto_dscto_0010(PR_PlanillaEmpleadoConcepto.Empleado,PR_PlanillaEmpleadoConcepto.TipoPlanilla,LEFT(PR_PlanillaEmpleado.Periodo,4)+''0808'',PR_PlanillaEmpleado.CentroCosto)
				 ELSE SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 8 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) END AS M08,          

			CASE WHEN PR_PlanillaEmpleadoConcepto.Concepto = ''0010'' AND SUBSTRING( PR_PlanillaEmpleado.Periodo , 1,4) >= ''2015''
				 THEN SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 9 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) - 
					  Nomina.f_obtener_monto_dscto_0010(PR_PlanillaEmpleadoConcepto.Empleado,PR_PlanillaEmpleadoConcepto.TipoPlanilla,LEFT(PR_PlanillaEmpleado.Periodo,4)+''0909'',PR_PlanillaEmpleado.CentroCosto)
				 ELSE SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 9 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) END AS M09,          

			CASE WHEN PR_PlanillaEmpleadoConcepto.Concepto = ''0010'' AND SUBSTRING( PR_PlanillaEmpleado.Periodo , 1,4) >= ''2015''
				 THEN SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 10 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) - 
					  Nomina.f_obtener_monto_dscto_0010(PR_PlanillaEmpleadoConcepto.Empleado,PR_PlanillaEmpleadoConcepto.TipoPlanilla,LEFT(PR_PlanillaEmpleado.Periodo,4)+''1010'',PR_PlanillaEmpleado.CentroCosto)
				 ELSE SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 10 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) END AS M10,          

			CASE WHEN PR_PlanillaEmpleadoConcepto.Concepto = ''0010'' AND SUBSTRING( PR_PlanillaEmpleado.Periodo , 1,4) >= ''2015''
				 THEN SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 11 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) - 
					  Nomina.f_obtener_monto_dscto_0010(PR_PlanillaEmpleadoConcepto.Empleado,PR_PlanillaEmpleadoConcepto.TipoPlanilla,LEFT(PR_PlanillaEmpleado.Periodo,4)+''1111'',PR_PlanillaEmpleado.CentroCosto)
				 ELSE SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 11 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) END AS M11,          

			CASE WHEN PR_PlanillaEmpleadoConcepto.Concepto = ''0010'' AND SUBSTRING( PR_PlanillaEmpleado.Periodo , 1,4) >= ''2015''
				 THEN SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 12 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) - 
					  Nomina.f_obtener_monto_dscto_0010(PR_PlanillaEmpleadoConcepto.Empleado,PR_PlanillaEmpleadoConcepto.TipoPlanilla,LEFT(PR_PlanillaEmpleado.Periodo,4)+''1212'',PR_PlanillaEmpleado.CentroCosto)
				 ELSE SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoConcepto.Periodo,5,2) AS INT) = 12 THEN PR_PlanillaEmpleadoConcepto.Monto  ELSE 0 END) END AS M12, '
	END			
	
	
	SET @SQL_1_1_2 = 'cCompaniasocio = ''00000000'',
			PR_PlanillaEmpleado.CentroCosto,
			SUM(PR_PlanillaEmpleadoConcepto.Monto)
	   FROM PR_PlanillaEmpleadoConcepto WITH(NOLOCK)
	  INNER JOIN PR_Concepto  WITH(NOLOCK)
		 ON (PR_PlanillaEmpleadoConcepto.Concepto = PR_Concepto.Concepto)
	  INNER JOIN PR_PlanillaEmpleado WITH(NOLOCK)
		 ON (PR_PlanillaEmpleadoConcepto.Periodo = PR_PlanillaEmpleado.Periodo AND
			PR_PlanillaEmpleadoConcepto.TipoPlanilla = PR_PlanillaEmpleado.TipoPlanilla AND
			PR_PlanillaEmpleadoConcepto.TipoProceso = PR_PlanillaEmpleado.TipoProceso AND
			PR_PlanillaEmpleadoConcepto.Empleado = PR_PlanillaEmpleado.Empleado) 
	  INNER JOIN dbo.PR_ProcesoPeriodo P WITH(NOLOCK)
	        ON PR_PlanillaEmpleado.CompaniaSocio = P.CompaniaSocio AND PR_PlanillaEmpleado.Periodo = P.Periodo AND PR_PlanillaEmpleado.TipoPlanilla = P.TipoPlanilla AND PR_PlanillaEmpleado.TipoProceso = P.TipoProceso
	  WHERE 1=1 AND P.FlagProcesado = ''S'' '
	  
	IF @ps_ConReintegro = 'S'
	BEGIN
		/*Con Reintegro -->*/
		SET @SQL_1_2 = 'AND not exists (SELECT * FROM PR_PlanillaEmpleadoReintegro Reint 
						WHERE Reint.Empleado = PR_PlanillaEmpleadoConcepto.Empleado
						AND Reint.Periodo = PR_PlanillaEmpleadoConcepto.Periodo
						AND Reint.Tipoplanilla = PR_PlanillaEmpleadoConcepto.TipoPlanilla
						AND Reint.TipoProceso = PR_PlanillaEmpleadoConcepto.TipoProceso
						AND Reint.Concepto = PR_PlanillaEmpleadoConcepto.Concepto) '
	END					

	/*'AND (PR_PlanillaEmpleado.Empleado = '+CAST(@pi_empleado AS VARCHAR(20))+' or '+CAST(@pi_empleado AS VARCHAR(20))+' = 0)*/
	SET @SQL_1_3 = 'AND (PR_PlanillaEmpleado.Empleado IN (SELECT Empleado FROM RecursosHumanos.f_Obtener_IdEmpleado_Docs_Identidad('+CAST(@pi_empleado AS VARCHAR(20))+')) or '+CAST(@pi_empleado AS VARCHAR(20))+' = 0)
		AND (PR_PlanillaEmpleado.TipoPlanilla = '''+@ps_tipoplanilla+''' or '''+@ps_alltipoplanilla+''' = ''S'')
		AND (PR_PlanillaEmpleado.TipoProceso in ('''+@ps_tipoproceso+''') or '''+@ps_alltipoproceso+'''= ''S'')
		AND (PR_PlanillaEmpleadoConcepto.Concepto = '''+@ps_concepto+''' or '''+@ps_allconcepto+''' = ''S'')
		AND (PR_Concepto.TipoConcepto = '''+@ps_tipoconcepto+''' or '''+@ps_tipoconcepto+''' = ''S'')
		AND (LEFT(PR_PlanillaEmpleado.Periodo,4) <= '''+@ps_anio+''' )
		AND (PR_PlanillaEmpleado.companiasocio = ''00000000'')  '
		
	IF @ps_AllPeriodo = 'N'
	BEGIN
		SET @SQL_PERIODO_1 = 'AND (LEFT(PR_PlanillaEmpleado.Periodo,6) BETWEEN '''+@ps_PDesde+''' AND '''+@ps_PHasta+''') '
		SET @SQL_PERIODO_2 = 'AND (LEFT(PR_PlanillaEmpleadoReintegro.PeriodoReintegro,6) BETWEEN '''+@ps_PDesde+''' AND '''+@ps_PHasta+''') '
		SET @SQL_PERIODO_3 = 'AND (LEFT(PR_ImpuestoRenta.EjercicioFiscal,6) BETWEEN '''+@ps_PDesde+''' AND '''+@ps_PHasta+''') '
	END

	/*SOLO AFECTOS A 5TA-->*/	
	IF @ps_SoloAfectos5ta = 'S'	
	BEGIN
		SET @SQL_5TA_1 = 'AND (PR_PlanillaEmpleadoConcepto.Concepto NOT IN (SELECT concepto FROM PR_CONJUNTODETALLE WHERE CONJUNTO=''INGNAFEQTA'')) '
		SET @SQL_5TA_2 = 'AND (PR_PlanillaEmpleadoReintegro.ConceptoReintegro NOT IN (SELECT concepto FROM PR_CONJUNTODETALLE WHERE CONJUNTO=''INGNAFEQTA'')) '
	END

	/*FILTRO POR CC*/
	IF @ps_AllCentrocosto = 'N'
	BEGIN
		SET @SQL_CC = 'AND (PR_PlanillaEmpleado.CentroCosto IN ('''+IsNull(@ps_Centrocosto1,'')+IsNull(@ps_Centrocosto2,'')+''') ) '
	END
	
	SET @SQL_1_4 = 'GROUP BY PR_PlanillaEmpleado.CompaniaSocio , 				
			PR_PlanillaEmpleadoConcepto.Empleado, 	         
			PR_PlanillaEmpleadoConcepto.Concepto, 				
			PR_Concepto.Descripcion, 	         
			PR_PlanillaEmpleadoConcepto.TipoPlanilla, 				
			LEFT(PR_PlanillaEmpleado.Periodo,4), 				
			PR_PlanillaEmpleado.CentroCosto ' 
			
	SET @SQL_1_1_1 = ISNULL(@SQL_1_1_1,'')
	SET @SQL_FORMATO = ISNULL(@SQL_FORMATO,'')
	SET @SQL_1_1_2 = ISNULL(@SQL_1_1_2,'')
	SET @SQL_1_2 = ISNULL(@SQL_1_2,'')
	SET @SQL_1_3 = ISNULL(@SQL_1_3,'')
	SET @SQL_PERIODO_1 = ISNULL(@SQL_PERIODO_1,'')
	SET @SQL_5TA_1 = ISNULL(@SQL_5TA_1,'')
	SET @SQL_CC = ISNULL(@SQL_CC,'')
	SET @SQL_1_4 = ISNULL(@SQL_1_4,'')		
	--PRINT @SQL_1_1_1+@SQL_FORMATO+@SQL_1_1_2+@SQL_1_2+@SQL_1_3+@SQL_PERIODO_1+@SQL_5TA_1+@SQL_CC+@SQL_1_4
	INSERT INTO #TEMP_ACUMULADO		
	EXEC(@SQL_1_1_1+@SQL_FORMATO+@SQL_1_1_2+@SQL_1_2+@SQL_1_3+@SQL_PERIODO_1+@SQL_5TA_1+@SQL_CC+@SQL_1_4)
			
	IF @ps_ConReintegro = 'S'
	BEGIN

		 SET @SQL_2_1 = 'SELECT Persona = PR_PlanillaEmpleadoReintegro.Empleado,   
				PersonaAnt = '''',
				PersonaActual = (SELECT Max(Empleado) FROM RecursosHumanos.f_Obtener_IdEmpleado_Docs_Identidad(PR_PlanillaEmpleadoReintegro.Empleado)),
				PR_PlanillaEmpleadoReintegro.ConceptoReintegro,   
				PR_Concepto.Descripcion,   
				PR_PlanillaEmpleadoReintegro.TipoPlanilla,   
				TipoProceso = '''',
				LEFT(PR_PlanillaEmpleadoReintegro.PeriodoReintegro,4) Periodo,
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoReintegro.PeriodoReintegro,5,2) AS INT) = 1 THEN PR_PlanillaEmpleadoReintegro.MontoReintegro  ELSE 0 END) AS M01,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoReintegro.PeriodoReintegro,5,2) AS INT) = 2 THEN PR_PlanillaEmpleadoReintegro.MontoReintegro  ELSE 0 END) AS M02,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoReintegro.PeriodoReintegro,5,2) AS INT) = 3 THEN PR_PlanillaEmpleadoReintegro.MontoReintegro  ELSE 0 END) AS M03,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoReintegro.PeriodoReintegro,5,2) AS INT) = 4 THEN PR_PlanillaEmpleadoReintegro.MontoReintegro  ELSE 0 END) AS M04,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoReintegro.PeriodoReintegro,5,2) AS INT) = 5 THEN PR_PlanillaEmpleadoReintegro.MontoReintegro  ELSE 0 END) AS M05,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoReintegro.PeriodoReintegro,5,2) AS INT) = 6 THEN PR_PlanillaEmpleadoReintegro.MontoReintegro  ELSE 0 END) AS M06,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoReintegro.PeriodoReintegro,5,2) AS INT) = 7 THEN PR_PlanillaEmpleadoReintegro.MontoReintegro  ELSE 0 END) AS M07,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoReintegro.PeriodoReintegro,5,2) AS INT) = 8 THEN PR_PlanillaEmpleadoReintegro.MontoReintegro  ELSE 0 END) AS M08,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoReintegro.PeriodoReintegro,5,2) AS INT) = 9 THEN PR_PlanillaEmpleadoReintegro.MontoReintegro  ELSE 0 END) AS M09,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoReintegro.PeriodoReintegro,5,2) AS INT) = 10 THEN PR_PlanillaEmpleadoReintegro.MontoReintegro  ELSE 0 END) AS M10,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoReintegro.PeriodoReintegro,5,2) AS INT) = 11 THEN PR_PlanillaEmpleadoReintegro.MontoReintegro  ELSE 0 END) AS M11,   
				SUM( CASE WHEN CAST(SUBSTRING(PR_PlanillaEmpleadoReintegro.PeriodoReintegro,5,2) AS INT) = 12 THEN PR_PlanillaEmpleadoReintegro.MontoReintegro  ELSE 0 END) AS M12,   
				cCompaniasocio = ''00000000'',
				PR_PlanillaEmpleado.CentroCosto,
				SUM(PR_PlanillaEmpleadoReintegro.MontoReintegro)
		   FROM PR_PlanillaEmpleadoReintegro WITH(NOLOCK)
		  INNER JOIN PR_Concepto WITH(NOLOCK)
			 ON (PR_PlanillaEmpleadoReintegro.ConceptoReintegro = PR_Concepto.Concepto)
		  INNER JOIN PR_PlanillaEmpleado WITH(NOLOCK)
			 ON (PR_PlanillaEmpleadoReintegro.Periodo = PR_PlanillaEmpleado.Periodo AND
				PR_PlanillaEmpleadoReintegro.TipoPlanilla = PR_PlanillaEmpleado.TipoPlanilla AND
				PR_PlanillaEmpleadoReintegro.TipoProceso = PR_PlanillaEmpleado.TipoProceso AND
				PR_PlanillaEmpleadoReintegro.Empleado = PR_PlanillaEmpleado.Empleado) 
		  INNER JOIN dbo.PR_ProcesoPeriodo P WITH(NOLOCK)
	         ON PR_PlanillaEmpleado.CompaniaSocio = P.CompaniaSocio AND PR_PlanillaEmpleado.Periodo = P.Periodo AND PR_PlanillaEmpleado.TipoPlanilla = P.TipoPlanilla AND PR_PlanillaEmpleado.TipoProceso = P.TipoProceso
		  WHERE 1=1 AND P.FlagProcesado = ''S''
			AND (PR_PlanillaEmpleado.Empleado IN (SELECT Empleado FROM RecursosHumanos.f_Obtener_IdEmpleado_Docs_Identidad('+CAST(@pi_empleado AS VARCHAR(20))+')) or '+CAST(@pi_empleado AS VARCHAR(20))+' = 0)
			AND (PR_PlanillaEmpleado.TipoPlanilla = '''+@ps_tipoplanilla+''' or '''+@ps_alltipoplanilla+''' = ''S'')
			AND (PR_PlanillaEmpleadoReintegro.TipoProcesoReintegro in ('''+@ps_tipoproceso+''') or '''+@ps_alltipoproceso+'''= ''S'')
			AND (PR_PlanillaEmpleadoReintegro.ConceptoReintegro = '''+@ps_concepto+''' or '''+@ps_allconcepto+''' = ''S'')
			AND (PR_Concepto.TipoConcepto = '''+@ps_tipoconcepto+''' or '''+@ps_tipoconcepto+''' = ''S'')
			AND (LEFT(PR_PlanillaEmpleadoReintegro.PeriodoReintegro,4) <= '''+@ps_anio+''' ) '
			
		  SET @SQL_2_2 = 'GROUP BY PR_PlanillaEmpleado.CompaniaSocio , 
				PR_PlanillaEmpleadoReintegro.Empleado,
				PR_PlanillaEmpleadoReintegro.ConceptoReintegro,
				PR_Concepto.Descripcion,   
				PR_PlanillaEmpleadoReintegro.TipoPlanilla,   
				LEFT(PR_PlanillaEmpleadoReintegro.PeriodoReintegro,4),
				PR_PlanillaEmpleado.CentroCosto'
				
		SET @SQL_2_1 = ISNULL(@SQL_2_1,'')
		SET @SQL_2_2 = ISNULL(@SQL_2_2,'')
		SET @SQL_PERIODO_2 = ISNULL(@SQL_PERIODO_2,'')
		SET @SQL_5TA_2 = ISNULL(@SQL_5TA_2,'')
		--PRINT ISNULL(@SQL_2_1,'')+ISNULL(@SQL_PERIODO_2,'')+ISNULL(@SQL_5TA_2,'')+@SQL_CC+ISNULL(@SQL_2_2,'')		
		INSERT INTO #TEMP_ACUMULADO		
		EXEC(@SQL_2_1+@SQL_PERIODO_2+@SQL_5TA_2+@SQL_CC+@SQL_2_2)		
				
	END


	IF @ps_IncluirExternos = 'S'
	BEGIN 
		 /*Inculir Externos --->*/
		 /*ACP - 20/08/2018 - COMENTADO *//*
		 SET @SQL_3_1 = 'DECLARE @TEMP_EMPLEADOS AS TABLE(Empleado Int);
		 INSERT INTO @TEMP_EMPLEADOS
		 SELECT DISTINCT Persona FROM #TEMP_ACUMULADO

		 SELECT Persona = PR_ImpuestoRenta.Empleado, 				
				PersonaAnt = '''', 	         	
				PersonaActual = (SELECT Max(Empleado) FROM RecursosHumanos.f_Obtener_IdEmpleado_Docs_Identidad(PR_ImpuestoRenta.Empleado)),
				Concepto=CASE WHEN '''+@ps_tipoconcepto+'''= ''IN'' THEN ''0122'' ELSE ''4702'' END, 				
				PR_Concepto.Descripcion, 	         	
				TipoPlanilla= '''+@ps_tipoplanilla+''', 				
				TipoProceso = '''', 				
				Periodo = LEFT(PR_ImpuestoRenta.EjercicioFiscal,4), 				
				M01 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 1 THEN ( CASE WHEN '''+@ps_tipoconcepto+'''=''IN'' THEN PR_ImpuestoRenta.AcumuladoSueldoExterno ELSE PR_ImpuestoRenta.AcumuladoRetencionExterno END ) ELSE 0 END), 	         	
				M02 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 2 THEN ( CASE WHEN '''+@ps_tipoconcepto+'''=''IN'' THEN PR_ImpuestoRenta.AcumuladoSueldoExterno ELSE PR_ImpuestoRenta.AcumuladoRetencionExterno END ) ELSE 0 END), 				
				M03 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 3 THEN ( CASE WHEN '''+@ps_tipoconcepto+'''=''IN'' THEN PR_ImpuestoRenta.AcumuladoSueldoExterno ELSE PR_ImpuestoRenta.AcumuladoRetencionExterno END ) ELSE 0 END), 				
				M04 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 4 THEN ( CASE WHEN '''+@ps_tipoconcepto+'''=''IN'' THEN PR_ImpuestoRenta.AcumuladoSueldoExterno ELSE PR_ImpuestoRenta.AcumuladoRetencionExterno END ) ELSE 0 END), 	         	
				M05 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 5 THEN ( CASE WHEN '''+@ps_tipoconcepto+'''=''IN'' THEN PR_ImpuestoRenta.AcumuladoSueldoExterno ELSE PR_ImpuestoRenta.AcumuladoRetencionExterno END ) ELSE 0 END), 				
				M06 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 6 THEN ( CASE WHEN '''+@ps_tipoconcepto+'''=''IN'' THEN PR_ImpuestoRenta.AcumuladoSueldoExterno ELSE PR_ImpuestoRenta.AcumuladoRetencionExterno END ) ELSE 0 END), 				
				M07 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 7 THEN ( CASE WHEN '''+@ps_tipoconcepto+'''=''IN'' THEN PR_ImpuestoRenta.AcumuladoSueldoExterno ELSE PR_ImpuestoRenta.AcumuladoRetencionExterno END ) ELSE 0 END), 				
				M08 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 8 THEN ( CASE WHEN '''+@ps_tipoconcepto+'''=''IN'' THEN PR_ImpuestoRenta.AcumuladoSueldoExterno ELSE PR_ImpuestoRenta.AcumuladoRetencionExterno END ) ELSE 0 END), 	         	
				M09 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 9 THEN ( CASE WHEN '''+@ps_tipoconcepto+'''=''IN'' THEN PR_ImpuestoRenta.AcumuladoSueldoExterno ELSE PR_ImpuestoRenta.AcumuladoRetencionExterno END ) ELSE 0 END), 				
				M10 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 10 THEN ( CASE WHEN '''+@ps_tipoconcepto+'''=''IN'' THEN PR_ImpuestoRenta.AcumuladoSueldoExterno ELSE PR_ImpuestoRenta.AcumuladoRetencionExterno END ) ELSE 0 END), 				
				M11 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 11 THEN ( CASE WHEN '''+@ps_tipoconcepto+'''=''IN'' THEN PR_ImpuestoRenta.AcumuladoSueldoExterno ELSE PR_ImpuestoRenta.AcumuladoRetencionExterno END ) ELSE 0 END), 	         	
				M12 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 12 THEN ( CASE WHEN '''+@ps_tipoconcepto+'''=''IN'' THEN PR_ImpuestoRenta.AcumuladoSueldoExterno ELSE PR_ImpuestoRenta.AcumuladoRetencionExterno END ) ELSE 0 END), 				
				cCompaniasocio = ''00000000'', 				
				CentroCosto='''',
				SUM(PR_ImpuestoRenta.AcumuladoSueldoExterno) 				
		   FROM PR_ImpuestoRenta WITH(NOLOCK)
		  INNER JOIN PR_Concepto WITH(NOLOCK)	         	
			 ON (CASE WHEN '''+@ps_tipoconcepto+'''= ''IN'' THEN ''0122'' ELSE ''4702'' END = PR_Concepto.Concepto) 				
		  WHERE (LEFT(PR_ImpuestoRenta.EjercicioFiscal,4) <= '''+@ps_anio+''' )
			AND (PR_Concepto.Concepto = '''+@ps_concepto+''' or '''+@ps_allconcepto+''' = ''S'')
			AND (CASE WHEN '''+@ps_tipoconcepto+'''= ''IN'' THEN ISNULL(PR_ImpuestoRenta.AcumuladoSueldoExterno,0)  ELSE ISNULL(PR_ImpuestoRenta.AcumuladoRetencionExterno,0) END > 0 )
			AND (PR_ImpuestoRenta.Empleado IN ( SELECT Empleado FROM @TEMP_EMPLEADOS))
			AND (PR_ImpuestoRenta.Empleado IN (SELECT Empleado FROM RecursosHumanos.f_Obtener_IdEmpleado_Docs_Identidad('+CAST(@pi_empleado AS VARCHAR(20))+')) or '+CAST(@pi_empleado AS VARCHAR(20))+' = 0) '
		*/
		/*ACP - 20/08/2018 - NO REPETIR EL MONTO EXTERNO */
		IF @ps_tipoconcepto = 'S'
			SET @ps_tipoconcepto = CASE @ps_concepto WHEN '0122' THEN 'IN' WHEN '4702' THEN 'DE' ELSE 'S' END
		
		IF @ps_tipoconcepto <> 'S'
		BEGIN
		
			SET @SQL_3_1 = 'DECLARE @TEMP_EMPLEADOS AS TABLE(Empleado Int);
			 INSERT INTO @TEMP_EMPLEADOS
			 SELECT DISTINCT Persona FROM #TEMP_ACUMULADO
			 UNION
			 SELECT Empleado FROM RecursosHumanos.f_Obtener_IdEmpleado_Docs_Identidad('+CAST(@pi_empleado AS VARCHAR(20))+')

			 SELECT Persona = PR_ImpuestoRenta.Empleado, 				
					PersonaAnt = '''', 	         	
					PersonaActual = (SELECT Max(Empleado) FROM RecursosHumanos.f_Obtener_IdEmpleado_Docs_Identidad(PR_ImpuestoRenta.Empleado)),
					Concepto=CASE WHEN '''+@ps_tipoconcepto+'''= ''IN'' THEN ''0122'' ELSE ''4702'' END, 				
					PR_Concepto.Descripcion, 	         	
					TipoPlanilla= '''+@ps_tipoplanilla+''', 				
					TipoProceso = '''', 				
					Periodo = LEFT(PR_ImpuestoRenta.EjercicioFiscal,4), 				
					M01 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 1 THEN Nomina.f_Obtener_monto_externo_IR(PR_ImpuestoRenta.Empleado,'''+@ps_tipoconcepto+''',LEFT(PR_ImpuestoRenta.EjercicioFiscal,4)+''01'') ELSE 0 END), 	         	
					M02 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 2 THEN Nomina.f_Obtener_monto_externo_IR(PR_ImpuestoRenta.Empleado,'''+@ps_tipoconcepto+''',LEFT(PR_ImpuestoRenta.EjercicioFiscal,4)+''02'') ELSE 0 END), 				
					M03 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 3 THEN Nomina.f_Obtener_monto_externo_IR(PR_ImpuestoRenta.Empleado,'''+@ps_tipoconcepto+''',LEFT(PR_ImpuestoRenta.EjercicioFiscal,4)+''03'') ELSE 0 END), 				
					M04 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 4 THEN Nomina.f_Obtener_monto_externo_IR(PR_ImpuestoRenta.Empleado,'''+@ps_tipoconcepto+''',LEFT(PR_ImpuestoRenta.EjercicioFiscal,4)+''04'') ELSE 0 END), 	         	
					M05 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 5 THEN Nomina.f_Obtener_monto_externo_IR(PR_ImpuestoRenta.Empleado,'''+@ps_tipoconcepto+''',LEFT(PR_ImpuestoRenta.EjercicioFiscal,4)+''05'') ELSE 0 END), 				
					M06 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 6 THEN Nomina.f_Obtener_monto_externo_IR(PR_ImpuestoRenta.Empleado,'''+@ps_tipoconcepto+''',LEFT(PR_ImpuestoRenta.EjercicioFiscal,4)+''06'') ELSE 0 END), 				
					M07 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 7 THEN Nomina.f_Obtener_monto_externo_IR(PR_ImpuestoRenta.Empleado,'''+@ps_tipoconcepto+''',LEFT(PR_ImpuestoRenta.EjercicioFiscal,4)+''07'') ELSE 0 END), 				
					M08 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 8 THEN Nomina.f_Obtener_monto_externo_IR(PR_ImpuestoRenta.Empleado,'''+@ps_tipoconcepto+''',LEFT(PR_ImpuestoRenta.EjercicioFiscal,4)+''08'') ELSE 0 END), 	         	
					M09 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 9 THEN Nomina.f_Obtener_monto_externo_IR(PR_ImpuestoRenta.Empleado,'''+@ps_tipoconcepto+''',LEFT(PR_ImpuestoRenta.EjercicioFiscal,4)+''09'') ELSE 0 END), 				
					M10 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 10 THEN Nomina.f_Obtener_monto_externo_IR(PR_ImpuestoRenta.Empleado,'''+@ps_tipoconcepto+''',LEFT(PR_ImpuestoRenta.EjercicioFiscal,4)+''10'') ELSE 0 END), 				
					M11 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 11 THEN Nomina.f_Obtener_monto_externo_IR(PR_ImpuestoRenta.Empleado,'''+@ps_tipoconcepto+''',LEFT(PR_ImpuestoRenta.EjercicioFiscal,4)+''11'') ELSE 0 END), 	         	
					M12 = SUM(CASE WHEN CAST(SUBSTRING(PR_ImpuestoRenta.EjercicioFiscal,5,2) AS INT) = 12 THEN Nomina.f_Obtener_monto_externo_IR(PR_ImpuestoRenta.Empleado,'''+@ps_tipoconcepto+''',LEFT(PR_ImpuestoRenta.EjercicioFiscal,4)+''12'') ELSE 0 END),
					cCompaniasocio = ''00000000'', 				
					CentroCosto='''',
					SUM(PR_ImpuestoRenta.AcumuladoSueldoExterno) 				
			   FROM PR_ImpuestoRenta WITH(NOLOCK)
			  INNER JOIN PR_Concepto WITH(NOLOCK)	         	
				 ON (CASE WHEN '''+@ps_tipoconcepto+'''= ''IN'' THEN ''0122'' ELSE ''4702'' END = PR_Concepto.Concepto) 				
			  WHERE (LEFT(PR_ImpuestoRenta.EjercicioFiscal,4) <= '''+@ps_anio+''' )
				AND (PR_Concepto.Concepto = '''+@ps_concepto+''' or '''+@ps_allconcepto+''' = ''S'')
				AND (CASE WHEN '''+@ps_tipoconcepto+'''= ''IN'' THEN ISNULL(PR_ImpuestoRenta.AcumuladoSueldoExterno,0)  ELSE ISNULL(PR_ImpuestoRenta.AcumuladoRetencionExterno,0) END > 0 )
				AND (PR_ImpuestoRenta.Empleado IN ( SELECT Empleado FROM @TEMP_EMPLEADOS)) '
				
									
			  SET @SQL_3_2 = 'GROUP BY PR_ImpuestoRenta.Empleado, 
					PR_Concepto.Descripcion,
					LEFT(PR_ImpuestoRenta.EjercicioFiscal,4)  '
					
			SET @SQL_3_1 = ISNULL(@SQL_3_1,'')
			SET @SQL_3_2 = ISNULL(@SQL_3_2,'')
			SET @SQL_PERIODO_3 = ISNULL(@SQL_PERIODO_3,'')
			--PRINT ISNULL(@SQL_3_1,'')+ISNULL(@SQL_PERIODO_3,'')+ISNULL(@SQL_3_2,'')		
			INSERT INTO #TEMP_ACUMULADO		
			EXEC(@SQL_3_1+@SQL_PERIODO_3+@SQL_3_2)
		END
	END			

	 SELECT T.Persona, 
			T.PersonaAnt,
			T.PersonaActual,-- = (SELECT Max(Empleado) FROM RecursosHumanos.Obtener_IdEmpleado_Docs_Identidad(Persona)), 
			NombreCompleto= dbo.f_Obten_nombres_persona(PersonaActual),
			T.Concepto,
			T.Descripcion,
			T.TipoPlanilla,
			T.TipoProceso,
			T.Periodo,
			M01,
			M02,
			M03,
			M04,
			M05,
			M06,
			M07,
			M08,
			M09,
			M10,
			M11,
			M12,
			T.cCompaniasocio, 
			T.CentroCosto 
	   FROM #TEMP_ACUMULADO T
	  --WHERE MontoTotal <> 0
	  WHERE (ISNULL(ABS(M01),0)+ISNULL(ABS(M02),0)+ISNULL(ABS(M03),0)+ISNULL(ABS(M04),0)+ISNULL(ABS(M05),0)+ISNULL(ABS(M06),0)+
			ISNULL(ABS(M07),0)+ISNULL(ABS(M08),0)+ISNULL(ABS(M09),0)+ISNULL(ABS(M10),0)+ISNULL(ABS(M11),0)+ISNULL(ABS(M12),0)) > 0
	  ORDER BY 8,3,6,1

	DROP TABLE #TEMP_ACUMULADO
END



GO
----------------------------------------------------------------------------------------------------
SELECT 'FIN PP_REQ_08426_01.sql -  ' + CONVERT(varchar, GETDATE(), 100);
----------------------------------------------------------------------------------------------------